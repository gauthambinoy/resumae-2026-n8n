#!/bin/bash
# Codex single-shot wrapper. Builds prompt (master + mode profile + JD), calls
# the existing run-codex-cv.sh in single-pass mode. Returns same JSON envelope
# shape as run-ss-claude.sh so downstream nodes don't care which engine ran.
set -uo pipefail

BASE="/home/ubuntu/cv-gen"
PROMPTS_DIR="$BASE/prompts"
MODES_DIR="$BASE/modes"
SCHEMAS_DIR="$BASE/schemas"
OUTPUT_DIR="$BASE/output"

MODE="${MODE:-professional}"
case "$MODE" in professional|graduate|retail|research) ;; *) MODE="professional";; esac

MODEL="${SS_MODEL:-gpt-5.5}"
THINKING="${THINKING:-high}"
WEBSEARCH="${WEBSEARCH:-on}"

mkdir -p "$OUTPUT_DIR"
JOB_ID="${JOB_ID:-$(date -u +%Y-%m-%dT%H-%M-%S)-$(uuidgen | cut -c1-6)-ss-codex-$MODE}"
LOG_FILE="$OUTPUT_DIR/$JOB_ID.log"
STDERR_FILE="$OUTPUT_DIR/$JOB_ID.stderr"
echo "[ss-codex] start mode=$MODE model=$MODEL job=$JOB_ID" >&2

emit_failure(){ local err="$1" tail; tail=$(tail -c 4000 "$STDERR_FILE" 2>/dev/null || echo "")
  jq -cn --arg e "$err" --arg s "$tail" --arg j "$JOB_ID" --arg m "$MODE" \
    '{ok:false,error:$e,stderr:$s,job_id:$j,mode:$m}'; }

PROMPT_TEMPLATE="$PROMPTS_DIR/master_single_shot.md"
PROFILE_FILE="$MODES_DIR/$MODE.profile.md"
SCHEMA_FILE="$SCHEMAS_DIR/$MODE.schema.json"
[ -f "$PROMPT_TEMPLATE" ] || { emit_failure "missing $PROMPT_TEMPLATE"; exit 0; }
[ -f "$PROFILE_FILE" ]   || { emit_failure "missing $PROFILE_FILE"; exit 0; }

if [ -n "${JD_PATH:-}" ] && [ -f "$JD_PATH" ]; then JD_CLEANED=$(cat "$JD_PATH")
elif [ -n "${JD_B64:-}" ]; then JD_CLEANED=$(printf "%s" "$JD_B64" | base64 -d 2>/dev/null) || { emit_failure "b64 decode failed"; exit 0; }
else emit_failure "no JD"; exit 0; fi
[ "${#JD_CLEANED}" -ge 30 ] || { emit_failure "JD too short"; exit 0; }

# Build the merged prompt
PROFILE_CONTENT=$(cat "$PROFILE_FILE")
PF="/tmp/codex-prompt.$JOB_ID.txt"
JF="/tmp/codex-jd.$JOB_ID.txt"
awk -v jd="$JD_CLEANED" -v prof="$PROFILE_CONTENT" '
  BEGIN { ins=0 }
  { n=index($0,"{{JD_CLEANED}}");
    if (n>0){ print substr($0,1,n-1) jd substr($0,n+length("{{JD_CLEANED}}")); next }
    if (!ins && $0 ~ /^═+$/){ print $0; print ""; print prof; print ""; ins=1; next }
    print $0
  }' "$PROMPT_TEMPLATE" > "$PF"
cp "$PF" "/tmp/codex-prompt-debug.$JOB_ID.txt" 2>/dev/null || true
cat <<<"$JD_CLEANED" > "$JF"

START_TS=$(date +%s)
STDOUT_TMP="$OUTPUT_DIR/$JOB_ID.stdout"

# Call existing codex runner: prompt jd model thinking websearch schema job_id session
"$BASE/run-codex-cv.sh" "$PF" "$JF" "$MODEL" "$THINKING" "$WEBSEARCH" "${SCHEMA_FILE:-}" "$JOB_ID" "" \
  > "$STDOUT_TMP" 2> "$STDERR_FILE"
RC=$?
DUR=$(( $(date +%s) - START_TS ))
echo "[ss-codex] done rc=$RC duration_s=$DUR" >&2

cp "$STDERR_FILE" "$LOG_FILE.stderr" 2>/dev/null || true
cp "$STDOUT_TMP" "$LOG_FILE" 2>/dev/null || true

[ "$RC" -eq 0 ] || { emit_failure "codex exit $RC"; exit 0; }
CV=$(cat "$STDOUT_TMP")
[ "${#CV}" -ge 200 ] || { emit_failure "empty CV (len=${#CV})"; exit 0; }

CV_S=$(echo "$CV" | sed -E 's/^```(json)?[[:space:]]*//; s/[[:space:]]*```[[:space:]]*$//')
CV_T=$(echo "$CV_S" | awk '/^[[:space:]]*\{/{f=1} f{print} /^[[:space:]]*\}[[:space:]]*$/{f=0}')
if [ -n "$CV_T" ] && echo "$CV_T" | jq -e 'type=="object"' >/dev/null 2>&1; then CV="$CV_T"; fi

if echo "$CV" | jq -e 'type=="object"' >/dev/null 2>&1; then
  echo "$CV" | jq -c --arg j "$JOB_ID" --arg m "$MODEL" --arg mode "$MODE" --argjson dur "$DUR" \
    '{ok:true} + . + {model:$m, mode:$mode, duration_s:$dur, job_id:$j, engine:"codex", generation_mode:"single_shot"}'
else
  jq -cn --arg cv "$CV" --arg j "$JOB_ID" --arg m "$MODEL" --arg mode "$MODE" --argjson dur "$DUR" \
    '{ok:true,cv_content:$cv,model:$m,mode:$mode,duration_s:$dur,job_id:$j,engine:"codex",generation_mode:"single_shot"}'
fi
exit 0
