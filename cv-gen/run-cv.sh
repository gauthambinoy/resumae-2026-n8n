#!/bin/bash
set -uo pipefail

echo "[MY-SCRIPT] starting $(date -Iseconds)" >&2

PROMPT_FILE="${1:-}"
JD_FILE="${2:-}"
MODEL="${3:-claude-sonnet-4.6}"
THINKING="${4:-medium}"
WEBSEARCH="${5:-off}"
SCHEMA_PATH="${6:-}"
JOB_ID="${7:-manual-$(date +%s)}"
# Optional 8th positional arg is a resume/session id. Some n8n SSH nodes omit
# the empty arg and pass flags immediately after JOB_ID, so only consume $8
# when it is not a named flag.
shift 7 || true
RESUME_SESSION_ID=""
if [[ $# -gt 0 && "${1:-}" != --* ]]; then
  RESUME_SESSION_ID="$1"
  shift
fi
# __PHASE4_TEMP_STOP__ — named flags parsed after positional args
TEMPERATURE_FLAG="0.7"
STOP_FLAGS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --temperature)
      if [[ $# -lt 2 ]]; then break; fi
      TEMPERATURE_FLAG="$2"; shift 2 ;;
    --stop)
      if [[ $# -lt 2 ]]; then break; fi
      STOP_FLAGS+=("$2"); shift 2 ;;
    *) shift ;;
  esac
done
BASE="/home/ubuntu/cv-gen"
OUTPUT_DIR="$BASE/output/$JOB_ID"
mkdir -p "$OUTPUT_DIR"

emit_error_json() {
  local error_type="$1"
  local exit_code="$2"
  local message="$3"
  ERROR_TYPE="$error_type" \
  ERROR_EXIT_CODE="$exit_code" \
  ERROR_MESSAGE="$message" \
  JOB_ID="$JOB_ID" \
  MODEL="$MODEL" \
  THINKING="$THINKING" \
  WEBSEARCH="$WEBSEARCH" \
  SCHEMA_PATH="$SCHEMA_PATH" \
  OUTPUT_DIR="$OUTPUT_DIR" \
  TIMEOUT_SECONDS="${TIMEOUT_SECONDS:-1800}" \
  python3 - <<'PY'
import json, os, pathlib

out_dir = pathlib.Path(os.environ["OUTPUT_DIR"])
stdout_path = out_dir / "claude.stdout.log"
stderr_path = out_dir / "claude.stderr.log"

def tail(path, limit):
    try:
        data = path.read_bytes()[-limit:]
        return data.decode("utf-8", "replace").replace("\x00", "")
    except FileNotFoundError:
        return ""

payload = {
    "error": "claude-runner-failed",
    "error_type": os.environ["ERROR_TYPE"],
    "message": os.environ["ERROR_MESSAGE"],
    "exit_code": int(os.environ["ERROR_EXIT_CODE"]),
    "job_id": os.environ["JOB_ID"],
    "model": os.environ["MODEL"],
    "thinking": os.environ["THINKING"],
    "websearch": os.environ["WEBSEARCH"],
    "schema_path": os.environ["SCHEMA_PATH"],
    "timeout_seconds": int(os.environ["TIMEOUT_SECONDS"]),
    "stdout_bytes": stdout_path.stat().st_size if stdout_path.exists() else 0,
    "stderr_bytes": stderr_path.stat().st_size if stderr_path.exists() else 0,
    "stdout_head": tail(stdout_path, 1200),
    "stderr_tail": tail(stderr_path, 4000),
}
print(json.dumps(payload, ensure_ascii=False))
PY
}

if [ ! -f "$PROMPT_FILE" ] || [ ! -f "$JD_FILE" ]; then
  emit_error_json "missing-input" 1 "Missing prompt_b64 or jd_b64 argument before Claude invocation."
  exit 0
fi

if ! PROMPT=$(cat "$PROMPT_FILE" 2>"$OUTPUT_DIR/prompt.decode.stderr.log"); then
  cat "$OUTPUT_DIR/prompt.decode.stderr.log" > "$OUTPUT_DIR/claude.stderr.log"
  emit_error_json "prompt-decode-failed" 1 "Prompt base64 decoding failed."
  exit 0
fi

if ! JD=$(cat "$JD_FILE" 2>"$OUTPUT_DIR/jd.decode.stderr.log"); then
  cat "$OUTPUT_DIR/jd.decode.stderr.log" > "$OUTPUT_DIR/claude.stderr.log"
  emit_error_json "jd-decode-failed" 1 "JD base64 decoding failed."
  exit 0
fi

echo "[MY-SCRIPT] prompt chars: ${#PROMPT}" >&2
echo "[MY-SCRIPT] jd chars: ${#JD}" >&2
echo "[MY-SCRIPT] model: $MODEL  thinking: $THINKING  websearch: $WEBSEARCH" >&2
echo "[MY-SCRIPT] resume session: ${RESUME_SESSION_ID:-none}" >&2
echo "[MY-SCRIPT] schema path: ${SCHEMA_PATH:-none}" >&2

if [ -n "$RESUME_SESSION_ID" ]; then
  FULL_PROMPT="$PROMPT"
else
  FULL_PROMPT="$PROMPT

## JOB DESCRIPTION
$JD"
fi

# Append generation-control annotations (Claude has no native --temperature flag)
TEMP_ANNOTATION="\n\n[GENERATION CONTROL: target_temperature=${TEMPERATURE_FLAG}]"
if [ "${#STOP_FLAGS[@]}" -gt 0 ]; then
  STOP_LIST=$(IFS=','; echo "${STOP_FLAGS[*]}")
  TEMP_ANNOTATION+="\n[STOP SIGNALS: halt output upon encountering: ${STOP_LIST}]"
fi
FULL_PROMPT="${FULL_PROMPT}${TEMP_ANNOTATION}"

# Hard output contract: pipeline reads stdout's `result` field. Model must
# NOT call Write/Edit — past failures saw Sonnet attempt Write → claude.stdout.log,
# get permission-denied in non-interactive (-p) mode, and emit a refusal sentence
# instead of JSON. Belt-and-braces: instruct model AND disable the tools below.
OUTPUT_CONTRACT="

[OUTPUT CONTRACT — STRICT]
- Return your FINAL response as JSON in the assistant message body. The pipeline reads the stdout 'result' field directly.
- Do NOT call the Write, Edit, or NotebookEdit tools. They are disabled and any attempt will be denied.
- Do NOT save anything to claude.stdout.log or any file in the current working directory; the shell already redirects stdout to that file.
- If you need to plan, do so silently; emit only the final JSON as your last message."
FULL_PROMPT="${FULL_PROMPT}${OUTPUT_CONTRACT}"

# Build args array
CLAUDE_ARGS=(
  -p "$FULL_PROMPT"
  --model "$MODEL"
  --max-turns 12
  --output-format json
  --strict-mcp-config
  --disable-slash-commands
  --exclude-dynamic-system-prompt-sections
  --permission-mode acceptEdits
  --disallowed-tools Write Edit NotebookEdit
)

# Map thinking level → Claude CLI --effort. CLI accepts: low, medium, high, xhigh, max.
# Form currently sends: low, medium, high. Pass through directly; anything else → medium.
case "$THINKING" in
  low|medium|high|xhigh|max)
    CLAUDE_ARGS+=(--effort "$THINKING")
    echo "[MY-SCRIPT] effort set to: $THINKING" >&2
    ;;
  *)
    CLAUDE_ARGS+=(--effort medium)
    echo "[MY-SCRIPT] unknown thinking '$THINKING', defaulting to medium" >&2
    ;;
esac

# Only pass --allowed-tools if we actually want tools (empty string breaks flag parsing)
if [ "$WEBSEARCH" = "on" ]; then
  CLAUDE_ARGS+=(--allowed-tools "WebSearch")
fi

# --json-schema takes the SCHEMA JSON INLINE, not a path
if [ -n "$SCHEMA_PATH" ] && [ -f "$SCHEMA_PATH" ]; then
  SCHEMA_JSON=$(cat "$SCHEMA_PATH")
  if [ -n "$SCHEMA_JSON" ]; then
    CLAUDE_ARGS+=(--json-schema "$SCHEMA_JSON")
    echo "[MY-SCRIPT] schema loaded (${#SCHEMA_JSON} chars)" >&2
  fi
fi

# Resume flag goes last, after all other options
if [ -n "$RESUME_SESSION_ID" ]; then
  CLAUDE_ARGS+=(--resume "$RESUME_SESSION_ID")
fi


# Claude stores resumable conversations under the project/cwd used for the
# first call. Rewrites use a new JOB_ID, so resume must run from the original
# draft cwd while still writing logs to this stage's OUTPUT_DIR.
RUN_CWD="$OUTPUT_DIR"
if [ -n "$RESUME_SESSION_ID" ]; then
  RESUME_CWD=$(
    RESUME_SESSION_ID="$RESUME_SESSION_ID" python3 - <<'PY'
import json
import os
import pathlib
import sys

sid = os.environ["RESUME_SESSION_ID"]
projects = pathlib.Path.home() / ".claude" / "projects"
for session_file in projects.glob(f"*/{sid}.jsonl"):
    try:
        with session_file.open("r", encoding="utf-8", errors="replace") as handle:
            for line in handle:
                try:
                    event = json.loads(line)
                except json.JSONDecodeError:
                    continue
                cwd = event.get("cwd")
                if cwd and pathlib.Path(cwd).is_dir():
                    print(cwd)
                    sys.exit(0)
    except OSError:
        continue
sys.exit(1)
PY
  ) || true
  if [ -z "$RESUME_CWD" ]; then
    echo "[MY-SCRIPT] ERROR: could not locate Claude session cwd for $RESUME_SESSION_ID" >&2
    emit_error_json "missing-claude-session-cwd" 1 "Could not locate the original Claude cwd for the requested resume session."
    exit 0
  fi
  RUN_CWD="$RESUME_CWD"
  echo "[MY-SCRIPT] resume cwd: $RUN_CWD" >&2
fi

# --- hermetic run: clean cwd; MCP/skills disabled via flags above ---
cd "$RUN_CWD"
echo "[MY-SCRIPT] invoking claude with ${#CLAUDE_ARGS[@]} args" >&2

CLAUDE_BIN="/usr/local/bin/claude"
if [ ! -x "$CLAUDE_BIN" ]; then
  echo "[MY-SCRIPT] ERROR: claude CLI not found at $CLAUDE_BIN" >&2
  exit 2
fi

# Capture both streams; emit stdout verbatim so n8n SSH receives it.
# Claude CLI can wait indefinitely for stdin when launched from n8n's SSH node,
# so detach stdin and enforce a hard timeout for production stability.
TIMEOUT_SECONDS="${TIMEOUT_SECONDS:-1800}"
WATCHDOG_GRACE="${WATCHDOG_GRACE:-900}"
WATCHDOG_INTERVAL=30

# Save decoded inputs into OUTPUT_DIR for diagnosability (so wrong-CV bugs can be traced)
cp "$PROMPT_FILE" "$OUTPUT_DIR/_input_prompt.txt" 2>/dev/null || true
cp "$JD_FILE" "$OUTPUT_DIR/_input_jd.txt" 2>/dev/null || true
printf 'MODEL=%s\nTHINKING=%s\nWEBSEARCH=%s\nJOB_ID=%s\nTIMEOUT_SECONDS=%s\nWATCHDOG_GRACE=%s\n' \
  "$MODEL" "$THINKING" "$WEBSEARCH" "$JOB_ID" "$TIMEOUT_SECONDS" "$WATCHDOG_GRACE" \
  > "$OUTPUT_DIR/_meta.txt"

timeout --kill-after=30s "$TIMEOUT_SECONDS"s "$CLAUDE_BIN" "${CLAUDE_ARGS[@]}" </dev/null > "$OUTPUT_DIR/claude.stdout.log" 2> "$OUTPUT_DIR/claude.stderr.log" &
CLI_PID=$!

# Stdout-growth watchdog: if zero bytes appended for WATCHDOG_GRACE seconds, kill the CLI.
(
  prev=0
  stalled=0
  while kill -0 $CLI_PID 2>/dev/null; do
    sleep $WATCHDOG_INTERVAL
    cur=$(wc -c < "$OUTPUT_DIR/claude.stdout.log" 2>/dev/null || echo 0)
    if [ "$cur" -gt "$prev" ]; then
      prev=$cur
      stalled=0
    else
      stalled=$((stalled + WATCHDOG_INTERVAL))
    fi
    if [ "$stalled" -ge "$WATCHDOG_GRACE" ]; then
      echo "[WATCHDOG] no stdout growth for ${stalled}s; killing CLI pid=$CLI_PID" >&2
      touch "$OUTPUT_DIR/.watchdog-killed"
      kill -TERM $CLI_PID 2>/dev/null
      sleep 5
      kill -KILL $CLI_PID 2>/dev/null
      exit 0
    fi
  done
) &
WATCHDOG_PID=$!

wait $CLI_PID
EXIT_CODE=$?
kill $WATCHDOG_PID 2>/dev/null
wait $WATCHDOG_PID 2>/dev/null

echo "[MY-SCRIPT] claude exit: $EXIT_CODE" >&2
STDOUT_SIZE=$(wc -c < "$OUTPUT_DIR/claude.stdout.log" | tr -d ' ')
echo "[MY-SCRIPT] stdout bytes: $STDOUT_SIZE" >&2

# If claude failed, surface the error as a JSON blob that Parse Output can diagnose
if [ "$EXIT_CODE" -ne 0 ] || [ "$STDOUT_SIZE" = "0" ]; then
  if [ -f "$OUTPUT_DIR/.watchdog-killed" ]; then
    emit_error_json "silent-hang" "$EXIT_CODE" "Claude produced no stdout for ${WATCHDOG_GRACE}s; watchdog killed it. Likely model stalled."
  elif [ "$EXIT_CODE" -eq 124 ]; then
    emit_error_json "timeout" "$EXIT_CODE" "Claude exceeded the ${TIMEOUT_SECONDS}s timeout before producing a complete response."
  elif [ "$EXIT_CODE" -eq 137 ]; then
    emit_error_json "killed-after-timeout" "$EXIT_CODE" "Claude was force-killed after the timeout grace period."
  elif [ "$STDOUT_SIZE" = "0" ]; then
    emit_error_json "empty-output" "$EXIT_CODE" "Claude exited without stdout."
  else
    emit_error_json "non-zero-exit" "$EXIT_CODE" "Claude exited with a non-zero status."
  fi
  exit 0
fi

if python3 - "$OUTPUT_DIR/claude.stdout.log" >/tmp/claude-is-error-check.$$ 2>/dev/null <<'PY'
import json, sys
with open(sys.argv[1], "r", encoding="utf-8", errors="replace") as f:
    data = json.load(f)
sys.exit(0 if data.get("is_error") is True else 1)
PY
then
  rm -f /tmp/claude-is-error-check.$$
  emit_error_json "claude-api-error" 0 "Claude returned a JSON response with is_error=true."
  exit 0
fi
rm -f /tmp/claude-is-error-check.$$

cat "$OUTPUT_DIR/claude.stdout.log"
