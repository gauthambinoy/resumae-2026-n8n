#!/bin/bash
set -uo pipefail

echo "[CODEX-RUNNER] starting $(date -Iseconds)" >&2

PROMPT_FILE="${1:-}"
JD_FILE="${2:-}"
MODEL="${3:-gpt-5.5}"
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

map_model() {
  case "$1" in
    gpt-5.5|gpt-5.4|gpt-5.3-codex|gpt-5.2|gpt-5-mini|o3|o4-mini)
      printf '%s' "$1"
      ;;
    claude-*|opus|sonnet|haiku|"")
      printf '%s' "gpt-5.5"
      ;;
    *)
      printf '%s' "$1"
      ;;
  esac
}

map_thinking() {
  case "$1" in
    low|medium|high|xhigh)
      printf '%s' "$1"
      ;;
    max|ultra)
      printf '%s' "xhigh"
      ;;
    *)
      printf '%s' "medium"
      ;;
  esac
}

emit_error_json() {
  local error_type="$1"
  local exit_code="$2"
  local message="$3"
  ERROR_TYPE="$error_type" \
  ERROR_EXIT_CODE="$exit_code" \
  ERROR_MESSAGE="$message" \
  JOB_ID="$JOB_ID" \
  MODEL="$MODEL" \
  CODEX_MODEL="${CODEX_MODEL:-}" \
  THINKING="$THINKING" \
  CODEX_THINKING="${CODEX_THINKING:-}" \
  WEBSEARCH="$WEBSEARCH" \
  SCHEMA_PATH="$SCHEMA_PATH" \
  OUTPUT_DIR="$OUTPUT_DIR" \
  TIMEOUT_SECONDS="${TIMEOUT_SECONDS:-1800}" \
  python3 - <<'PY'
import json, os, pathlib

out_dir = pathlib.Path(os.environ["OUTPUT_DIR"])
stdout_path = out_dir / "codex.stdout.log"
stderr_path = out_dir / "codex.stderr.log"
last_path = out_dir / "codex.last-message.txt"

def tail(path, limit):
    try:
        data = path.read_bytes()[-limit:]
        return data.decode("utf-8", "replace").replace("\x00", "")
    except FileNotFoundError:
        return ""

payload = {
    "is_error": True,
    "error": "codex-runner-failed",
    "error_type": os.environ["ERROR_TYPE"],
    "message": os.environ["ERROR_MESSAGE"],
    "exit_code": int(os.environ["ERROR_EXIT_CODE"]),
    "job_id": os.environ["JOB_ID"],
    "model": os.environ["MODEL"],
    "codex_model": os.environ["CODEX_MODEL"],
    "thinking": os.environ["THINKING"],
    "codex_thinking": os.environ["CODEX_THINKING"],
    "websearch": os.environ["WEBSEARCH"],
    "schema_path": os.environ["SCHEMA_PATH"],
    "timeout_seconds": int(os.environ["TIMEOUT_SECONDS"]),
    "stdout_bytes": stdout_path.stat().st_size if stdout_path.exists() else 0,
    "stderr_bytes": stderr_path.stat().st_size if stderr_path.exists() else 0,
    "last_message_bytes": last_path.stat().st_size if last_path.exists() else 0,
    "stdout_head": tail(stdout_path, 1200),
    "stderr_tail": tail(stderr_path, 4000),
    "last_message_tail": tail(last_path, 2000),
}
print(json.dumps(payload, ensure_ascii=False))
PY
}

if [ ! -f "$PROMPT_FILE" ] || [ ! -f "$JD_FILE" ]; then
  emit_error_json "missing-input" 1 "Missing prompt or JD file argument before Codex invocation."
  exit 0
fi

if ! PROMPT=$(cat "$PROMPT_FILE" 2>"$OUTPUT_DIR/prompt.decode.stderr.log"); then
  cat "$OUTPUT_DIR/prompt.decode.stderr.log" > "$OUTPUT_DIR/codex.stderr.log"
  emit_error_json "prompt-read-failed" 1 "Prompt file read failed."
  exit 0
fi

if ! JD=$(cat "$JD_FILE" 2>"$OUTPUT_DIR/jd.decode.stderr.log"); then
  cat "$OUTPUT_DIR/jd.decode.stderr.log" > "$OUTPUT_DIR/codex.stderr.log"
  emit_error_json "jd-read-failed" 1 "JD file read failed."
  exit 0
fi

CODEX_MODEL="$(map_model "$MODEL")"
CODEX_THINKING="$(map_thinking "$THINKING")"

echo "[CODEX-RUNNER] prompt chars: ${#PROMPT}" >&2
echo "[CODEX-RUNNER] jd chars: ${#JD}" >&2
echo "[CODEX-RUNNER] model: $MODEL -> $CODEX_MODEL  thinking: $THINKING -> $CODEX_THINKING  websearch: $WEBSEARCH" >&2
echo "[CODEX-RUNNER] resume session argument: ${RESUME_SESSION_ID:-none}" >&2
echo "[CODEX-RUNNER] schema path: ${SCHEMA_PATH:-none}" >&2

if [ -n "$RESUME_SESSION_ID" ]; then
  FULL_PROMPT="$PROMPT"
else
  FULL_PROMPT="$PROMPT

## JOB DESCRIPTION
$JD"
fi

CODEX_BIN="$(command -v codex || true)"
if [ -z "$CODEX_BIN" ] || [ ! -x "$CODEX_BIN" ]; then
  echo "[CODEX-RUNNER] ERROR: codex CLI not found in PATH" >&2
  emit_error_json "missing-codex-cli" 2 "Codex CLI was not found. Install with: npm i -g @openai/codex"
  exit 0
fi

# Codex config flags must appear before positional args such as SESSION_ID/PROMPT.
CODEX_CONFIG_ARGS=()
if [ -n "$TEMPERATURE_FLAG" ] && [ "$TEMPERATURE_FLAG" != "0.7" ]; then
  CODEX_CONFIG_ARGS+=(-c "temperature=${TEMPERATURE_FLAG}")
fi
if [ "${#STOP_FLAGS[@]}" -gt 0 ]; then
  STOP_JSON="["
  for s in "${STOP_FLAGS[@]}"; do STOP_JSON+="\"${s}\","; done
  STOP_JSON="${STOP_JSON%,}]"
  CODEX_CONFIG_ARGS+=(-c "stop=${STOP_JSON}")
fi

CODEX_ARGS=(
  --ask-for-approval never
  --sandbox read-only
)

if [ "$WEBSEARCH" = "on" ]; then
  CODEX_ARGS+=(--search)
fi

CODEX_ARGS+=(
  exec
)

if [ -n "$RESUME_SESSION_ID" ]; then
  CODEX_ARGS+=(
    resume
    --model "$CODEX_MODEL"
    --skip-git-repo-check
    -c "model_reasoning_effort=\"$CODEX_THINKING\""
    "${CODEX_CONFIG_ARGS[@]}"
    --output-last-message "$OUTPUT_DIR/codex.last-message.txt"
    "$RESUME_SESSION_ID"
  )
else
  CODEX_ARGS+=(
  --model "$CODEX_MODEL"
  --skip-git-repo-check
  -c "model_reasoning_effort=\"$CODEX_THINKING\""
  "${CODEX_CONFIG_ARGS[@]}"
  --output-last-message "$OUTPUT_DIR/codex.last-message.txt"
  )
fi

if [ -z "$RESUME_SESSION_ID" ] && [ -n "$SCHEMA_PATH" ] && [ -f "$SCHEMA_PATH" ]; then
  CODEX_ARGS+=(--output-schema "$SCHEMA_PATH")
  echo "[CODEX-RUNNER] schema path enabled" >&2
fi

CODEX_ARGS+=(-)

cd "$OUTPUT_DIR"
echo "[CODEX-RUNNER] invoking codex with ${#CODEX_ARGS[@]} args" >&2

TIMEOUT_SECONDS="${TIMEOUT_SECONDS:-1800}"
WATCHDOG_GRACE="${WATCHDOG_GRACE:-900}"
WATCHDOG_INTERVAL="${WATCHDOG_INTERVAL:-30}"
CODEX_RETRY_ATTEMPT="${CODEX_RETRY_ATTEMPT:-0}"

valid_json_file() {
  local path="${1:-}"
  [ -s "$path" ] || return 1
  python3 - "$path" >/dev/null 2>&1 <<'PYJSON'
import json, pathlib, sys
text = pathlib.Path(sys.argv[1]).read_text(encoding='utf-8', errors='replace').strip()
json.loads(text)
PYJSON
}

downgrade_thinking() {
  case "$1" in
    xhigh) printf '%s' "high" ;;
    high) printf '%s' "medium" ;;
    medium) printf '%s' "low" ;;
    low) printf '%s' "low" ;;
    *) printf '%s' "medium" ;;
  esac
}

retry_once_after_empty_failure() {
  [ "${CODEX_RETRY_ATTEMPT:-0}" -lt 1 ] || return 1

  local retry_thinking retry_job retry_out retry_err retry_rc
  retry_thinking="$(downgrade_thinking "$CODEX_THINKING")"
  retry_job="${JOB_ID}-retry1"
  retry_out="$OUTPUT_DIR/retry1.runner.json"
  retry_err="$OUTPUT_DIR/retry1.runner.stderr.log"

  local retry_args=()
  if [ -n "$RESUME_SESSION_ID" ]; then
    retry_args+=("$RESUME_SESSION_ID")
  fi
  if [ -n "$TEMPERATURE_FLAG" ]; then
    retry_args+=(--temperature "$TEMPERATURE_FLAG")
  fi
  for s in "${STOP_FLAGS[@]}"; do
    retry_args+=(--stop "$s")
  done

  echo "[CODEX-RUNNER] retrying once after empty/stalled failure: job=$retry_job thinking=$retry_thinking websearch=off" >&2
  CODEX_RETRY_ATTEMPT=1 \
  TIMEOUT_SECONDS="$TIMEOUT_SECONDS" \
  WATCHDOG_GRACE="$WATCHDOG_GRACE" \
  WATCHDOG_INTERVAL="$WATCHDOG_INTERVAL" \
    bash "$0" "$PROMPT_FILE" "$JD_FILE" "$MODEL" "$retry_thinking" "off" "$SCHEMA_PATH" "$retry_job" "${retry_args[@]}" \
    > "$retry_out" 2> "$retry_err"
  retry_rc=$?
  cat "$retry_err" >&2 2>/dev/null || true

  if [ ! -s "$retry_out" ]; then
    echo "[CODEX-RUNNER] retry produced no runner stdout" >&2
    return 1
  fi

  RETRY_OUT="$retry_out" \
  RETRY_RC="$retry_rc" \
  RETRY_JOB="$retry_job" \
  RETRY_THINKING="$retry_thinking" \
  PARENT_JOB="$JOB_ID" \
  PARENT_EXIT_CODE="$EXIT_CODE" \
  PARENT_ERROR_TYPE="silent-hang" \
  python3 - <<'PY'
import json, os, pathlib, sys

path = pathlib.Path(os.environ["RETRY_OUT"])
try:
    payload = json.loads(path.read_text(encoding="utf-8", errors="replace"))
except Exception:
    sys.exit(2)

payload["runner_retry"] = {
    "used": True,
    "parent_job_id": os.environ["PARENT_JOB"],
    "retry_job_id": os.environ["RETRY_JOB"],
    "parent_error_type": os.environ["PARENT_ERROR_TYPE"],
    "parent_exit_code": int(os.environ["PARENT_EXIT_CODE"]),
    "retry_exit_code": int(os.environ["RETRY_RC"]),
    "retry_thinking": os.environ["RETRY_THINKING"],
    "retry_websearch": "off",
}
print(json.dumps(payload, ensure_ascii=False))
PY
  return $?
}

# Save decoded inputs into OUTPUT_DIR for diagnosability (so wrong-CV bugs can be traced)
cp "$PROMPT_FILE" "$OUTPUT_DIR/_input_prompt.txt" 2>/dev/null || true
cp "$JD_FILE" "$OUTPUT_DIR/_input_jd.txt" 2>/dev/null || true
printf 'MODEL=%s\nCODEX_MODEL=%s\nTHINKING=%s\nCODEX_THINKING=%s\nWEBSEARCH=%s\nJOB_ID=%s\nTIMEOUT_SECONDS=%s\nWATCHDOG_GRACE=%s\n' \
  "$MODEL" "${CODEX_MODEL:-}" "$THINKING" "${CODEX_THINKING:-}" "$WEBSEARCH" "$JOB_ID" "$TIMEOUT_SECONDS" "$WATCHDOG_GRACE" \
  > "$OUTPUT_DIR/_meta.txt"

{ printf '%s' "$FULL_PROMPT" | timeout --kill-after=30s "$TIMEOUT_SECONDS"s "$CODEX_BIN" "${CODEX_ARGS[@]}" > "$OUTPUT_DIR/codex.stdout.log" 2> "$OUTPUT_DIR/codex.stderr.log"; } &
CLI_PID=$!

# Progress watchdog. Codex often writes the prompt/progress to stderr and the
# final answer to --output-last-message; stdout alone is not a reliable liveness
# signal. Terminate only when all output is stalled, and mark successful completion
# if a valid final JSON message already exists but the CLI process is lingering.
(
  prev=0
  stalled=0
  while kill -0 $CLI_PID 2>/dev/null; do
    sleep $WATCHDOG_INTERVAL
    out_size=0
    err_size=0
    last_size=0
    [ -f "$OUTPUT_DIR/codex.stdout.log" ] && out_size=$(wc -c < "$OUTPUT_DIR/codex.stdout.log" | tr -d ' ')
    [ -f "$OUTPUT_DIR/codex.stderr.log" ] && err_size=$(wc -c < "$OUTPUT_DIR/codex.stderr.log" | tr -d ' ')
    [ -f "$OUTPUT_DIR/codex.last-message.txt" ] && last_size=$(wc -c < "$OUTPUT_DIR/codex.last-message.txt" | tr -d ' ')
    cur=$((out_size + err_size + last_size))
    if [ "$cur" -gt "$prev" ]; then
      prev=$cur
      stalled=0
    else
      stalled=$((stalled + WATCHDOG_INTERVAL))
    fi
    if [ "$stalled" -ge "$WATCHDOG_GRACE" ]; then
      if valid_json_file "$OUTPUT_DIR/codex.last-message.txt"; then
        echo "[WATCHDOG] valid final JSON exists after ${stalled}s stalled; terminating lingering CLI pid=$CLI_PID" >&2
        touch "$OUTPUT_DIR/.watchdog-salvaged"
      else
        echo "[WATCHDOG] no output growth for ${stalled}s and no valid final JSON; terminating CLI pid=$CLI_PID" >&2
        touch "$OUTPUT_DIR/.watchdog-killed"
      fi
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

echo "[CODEX-RUNNER] codex exit: $EXIT_CODE" >&2
STDOUT_SIZE=$(wc -c < "$OUTPUT_DIR/codex.stdout.log" 2>/dev/null | tr -d ' ')
LAST_SIZE=0
if [ -f "$OUTPUT_DIR/codex.last-message.txt" ]; then
  LAST_SIZE=$(wc -c < "$OUTPUT_DIR/codex.last-message.txt" | tr -d ' ')
fi

# Final salvage pass. The watchdog may terminate a lingering Codex process after
# the answer has already been written. Treat valid JSON in either canonical output
# as success, regardless of process exit code or watchdog marker.
SALVAGED_VALID_JSON=0
if valid_json_file "$OUTPUT_DIR/codex.last-message.txt"; then
  SALVAGED_VALID_JSON=1
elif valid_json_file "$OUTPUT_DIR/codex.stdout.log"; then
  cp "$OUTPUT_DIR/codex.stdout.log" "$OUTPUT_DIR/codex.last-message.txt"
  LAST_SIZE=$(wc -c < "$OUTPUT_DIR/codex.last-message.txt" | tr -d ' ')
  SALVAGED_VALID_JSON=1
fi

if [ "$SALVAGED_VALID_JSON" = "1" ]; then
  EXIT_CODE=0
  rm -f "$OUTPUT_DIR/.watchdog-killed"
  touch "$OUTPUT_DIR/.watchdog-salvaged"
fi

echo "[CODEX-RUNNER] stdout bytes: $STDOUT_SIZE last message bytes: $LAST_SIZE salvaged_valid_json=$SALVAGED_VALID_JSON" >&2

if [ "$EXIT_CODE" -ne 0 ] || [ "$LAST_SIZE" = "0" ]; then
  if [ -f "$OUTPUT_DIR/.watchdog-killed" ] || [ "$LAST_SIZE" = "0" ]; then
    if retry_once_after_empty_failure; then
      exit 0
    fi
  fi
  if [ -f "$OUTPUT_DIR/.watchdog-killed" ]; then
    emit_error_json "silent-hang" "$EXIT_CODE" "Codex had no output growth for ${WATCHDOG_GRACE}s and no valid final JSON message was available."
  elif [ "$EXIT_CODE" -eq 124 ]; then
    emit_error_json "timeout" "$EXIT_CODE" "Codex exceeded the ${TIMEOUT_SECONDS}s timeout before producing a complete response."
  elif [ "$EXIT_CODE" -eq 137 ]; then
    emit_error_json "killed-after-timeout" "$EXIT_CODE" "Codex was force-killed after the timeout grace period."
  elif [ "$LAST_SIZE" = "0" ]; then
    emit_error_json "empty-output" "$EXIT_CODE" "Codex exited without a final message."
  else
    emit_error_json "non-zero-exit" "$EXIT_CODE" "Codex exited with a non-zero status and no salvageable final JSON."
  fi
  exit 0
fi

OUTPUT_DIR="$OUTPUT_DIR" python3 - <<'PY'
import json, os, pathlib
import re

out_dir = pathlib.Path(os.environ["OUTPUT_DIR"])
last = (out_dir / "codex.last-message.txt").read_text(encoding="utf-8", errors="replace").strip()
stderr = ""
stdout = ""
try:
    stderr = (out_dir / "codex.stderr.log").read_text(encoding="utf-8", errors="replace")
except FileNotFoundError:
    pass
try:
    stdout = (out_dir / "codex.stdout.log").read_text(encoding="utf-8", errors="replace")
except FileNotFoundError:
    pass

session_id = ""
for blob in (stderr, stdout):
    match = re.search(r"session id:\s*([0-9a-fA-F-]{36})", blob)
    if match:
        session_id = match.group(1)
        break

structured = None
if last:
    try:
        parsed = json.loads(last)
        if isinstance(parsed, dict):
            structured = parsed
    except json.JSONDecodeError:
        structured = None

payload = {
    "result": last,
    "model_provider": "openai-codex",
}
if session_id:
    payload["session_id"] = session_id
if structured is not None:
    payload["structured_output"] = structured

print(json.dumps(payload, ensure_ascii=False))
PY
