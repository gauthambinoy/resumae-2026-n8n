#!/bin/bash
set -uo pipefail

# Single-shot CV generator: one Claude CLI call, web search + high effort.
# Input:  JD_PATH env var (path to file containing raw JD UTF-8).
#         OR JD_B64 env var (base64-encoded JD) — fallback for backwards compat.
# Output: JSON envelope on stdout. Logs in /home/ubuntu/cv-gen/output/<job_id>.log

BASE="/home/ubuntu/cv-gen"
PROMPT_TEMPLATE="$BASE/prompts/master_single_shot.md"
OUTPUT_DIR="$BASE/output"
MODEL="${SS_MODEL:-claude-sonnet-4-6}"
CLAUDE_BIN="/usr/local/bin/claude"

mkdir -p "$OUTPUT_DIR"

JOB_ID="${JOB_ID:-$(date -u +%Y-%m-%dT%H-%M-%S)-$(uuidgen | cut -c1-6)-singleshot}"
LOG_FILE="$OUTPUT_DIR/$JOB_ID.log"
STDERR_FILE="$OUTPUT_DIR/$JOB_ID.stderr"

echo "[singleshot] start $(date -Iseconds) job_id=$JOB_ID" >&2

emit_failure() {
  local err="$1"
  local stderr_tail
  stderr_tail=$(tail -c 4000 "$STDERR_FILE" 2>/dev/null || echo "")
  jq -cn --arg e "$err" --arg s "$stderr_tail" --arg j "$JOB_ID" \
    "{ok:false,error:\$e,stderr:\$s,job_id:\$j}"
}

if [ ! -f "$PROMPT_TEMPLATE" ]; then
  emit_failure "prompt template missing: $PROMPT_TEMPLATE"
  exit 0
fi

# Get JD: prefer JD_PATH (file) over JD_B64 (env)
if [ -n "${JD_PATH:-}" ] && [ -f "$JD_PATH" ]; then
  JD_CLEANED=$(cat "$JD_PATH")
elif [ -n "${JD_B64:-}" ]; then
  JD_CLEANED=$(printf "%s" "$JD_B64" | base64 -d 2>/dev/null) || {
    emit_failure "base64 decode of JD_B64 failed"
    exit 0
  }
else
  emit_failure "no JD provided (set JD_PATH or JD_B64)"
  exit 0
fi

if [ -z "$JD_CLEANED" ] || [ "${#JD_CLEANED}" -lt 30 ]; then
  emit_failure "JD too short or empty (len=${#JD_CLEANED})"
  exit 0
fi

# Substitute {{JD_CLEANED}} in template
PROMPT=$(awk -v jd="$JD_CLEANED" "
  {
    n = index(\$0, \"{{JD_CLEANED}}\")
    if (n > 0) {
      print substr(\$0, 1, n-1) jd substr(\$0, n + length(\"{{JD_CLEANED}}\"))
    } else {
      print \$0
    }
  }
" "$PROMPT_TEMPLATE")

echo "[singleshot] prompt chars: ${#PROMPT}  jd chars: ${#JD_CLEANED}" >&2

START_TS=$(date +%s)
STDOUT_TMP="$OUTPUT_DIR/$JOB_ID.stdout"

printf "%s" "$PROMPT" | stdbuf -o0 "$CLAUDE_BIN" \
  --model "$MODEL" \
  --dangerously-skip-permissions \
  --output-format text \
  -p \
  > "$STDOUT_TMP" 2> "$STDERR_FILE"
RC=$?

END_TS=$(date +%s)
DUR=$((END_TS - START_TS))
echo "[singleshot] done rc=$RC duration_s=$DUR" >&2

cp "$STDERR_FILE" "$LOG_FILE.stderr" 2>/dev/null || true
cp "$STDOUT_TMP" "$LOG_FILE" 2>/dev/null || true

if [ "$RC" -ne 0 ]; then
  emit_failure "claude exit $RC"
  exit 0
fi

CV=$(cat "$STDOUT_TMP")
if [ -z "$CV" ] || [ "${#CV}" -lt 200 ]; then
  emit_failure "empty or too-short CV output (len=${#CV})"
  exit 0
fi

# Try to parse claude stdout as JSON (new prompt mode).
# If valid JSON object, merge it into the envelope so cv_content stays an object
# (and meta/extras/scores flow through). Otherwise fall back to legacy string mode.
# __BATCH16_A3__ strip ```json fences & isolate outermost JSON object
CV_STRIPPED=$(echo "$CV" | sed -E 's/^```(json)?[[:space:]]*//; s/[[:space:]]*```[[:space:]]*$//')
CV_STRIPPED_TRIM=$(echo "$CV_STRIPPED" | awk '/^[[:space:]]*\{/{flag=1} flag{print} /^[[:space:]]*\}[[:space:]]*$/{flag=0}')
if [ -n "$CV_STRIPPED_TRIM" ] && echo "$CV_STRIPPED_TRIM" | jq -e 'type=="object"' >/dev/null 2>&1; then
  CV="$CV_STRIPPED_TRIM"
fi
if echo "$CV" | jq -e 'type=="object"' >/dev/null 2>&1; then
  echo "$CV" | jq -c \
    --arg j "$JOB_ID" --arg m "$MODEL" --argjson dur "$DUR" \
    '{ok:true} + . + {model:$m, duration_s:$dur, job_id:$j, mode:"single_shot_opus"}'
else
  jq -cn --arg cv "$CV" --arg j "$JOB_ID" --arg m "$MODEL" --argjson dur "$DUR" \
    "{ok:true,cv_content:\$cv,model:\$m,duration_s:\$dur,job_id:\$j,mode:\"single_shot_opus\"}"
fi

exit 0
