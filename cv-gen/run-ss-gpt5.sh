#!/bin/bash
# GPT-5 fallback runner — mirrors run-ss-claude.sh output shape
# Uses OpenRouter (openai/gpt-5) so quality stays ~95% of Opus
set -uo pipefail

# Load OPENROUTER_KEY
[ -f /home/ubuntu/n8n/.env ] && set -a && . /home/ubuntu/n8n/.env && set +a
: "${OPENROUTER_KEY:?OPENROUTER_KEY missing}"

BASE="/home/ubuntu/cv-gen"
PROMPTS_DIR="$BASE/prompts"
MODES_DIR="$BASE/modes"
OUTPUT_DIR="$BASE/output"

MODE="${MODE:-professional}"
case "$MODE" in professional|graduate|retail|research) ;; *) MODE="professional" ;; esac
TIER="${TIER:-balanced}"
OR_MODEL="${OR_MODEL:-openai/gpt-5}"
OUTPUT_CAP="${OUTPUT_CAP:-32000}"
REASONING_EFFORT="${REASONING_EFFORT:-low}"

mkdir -p "$OUTPUT_DIR"
JOB_ID="${JOB_ID:-$(date -u +%Y-%m-%dT%H-%M-%S)-$(uuidgen | cut -c1-6)-or-$MODE}"
LOG_FILE="$OUTPUT_DIR/$JOB_ID.gpt5.log"
STDERR_FILE="$OUTPUT_DIR/$JOB_ID.gpt5.stderr"
echo "[gpt5-fallback] tier=$TIER mode=$MODE model=$OR_MODEL cap=$OUTPUT_CAP job=$JOB_ID" >&2

emit_failure() {
  local err="$1" tail; tail=$(tail -c 4000 "$STDERR_FILE" 2>/dev/null || echo "")
  jq -cn --arg e "$err" --arg s "$tail" --arg j "$JOB_ID" --arg m "$MODE" \
    '{ok:false,error:$e,stderr:$s,job_id:$j,mode:$m,engine:"openrouter"}'
}

PROMPT_TEMPLATE="$PROMPTS_DIR/master_single_shot.md"
PROFILE_FILE="$MODES_DIR/$MODE.profile.md"
[ -f "$PROMPT_TEMPLATE" ] || { emit_failure "missing prompt"; exit 0; }
[ -f "$PROFILE_FILE" ]   || { emit_failure "missing profile"; exit 0; }
[ -n "${JD_PATH:-}" ] && [ -f "$JD_PATH" ] || { emit_failure "no JD"; exit 0; }
JD_CLEANED=$(cat "$JD_PATH")
[ "${#JD_CLEANED}" -ge 30 ] || { emit_failure "JD too short"; exit 0; }

PROFILE_CONTENT=$(cat "$PROFILE_FILE")
PROMPT=$(awk -v jd="$JD_CLEANED" -v prof="$PROFILE_CONTENT" -v eff="medium" '
  BEGIN { profile_inserted=0 }
  {
    line=$0
    gsub(/\{\{THINKING_LEVEL\}\}/, "Reasoning effort = " eff, line)
    gsub(/\{\{WEBSEARCH_MAX\}\}/, "0", line)
    n = index(line, "{{JD_CLEANED}}")
    if (n > 0) { print substr(line,1,n-1) jd substr(line,n+length("{{JD_CLEANED}}")); next }
    if (!profile_inserted && line ~ /^═+$/) {
      print line; print ""; print prof; print ""; profile_inserted=1; next
    }
    print line
  }
' "$PROMPT_TEMPLATE")

REQ=$(jq -cn --arg model "$OR_MODEL" --arg sys "Output ONLY a single valid JSON object matching the requested CV schema. No markdown fences, no commentary." --arg user "$PROMPT" --argjson cap "$OUTPUT_CAP" --arg eff "$REASONING_EFFORT" \
  '{model:$model, max_tokens:$cap, temperature:0.4, response_format:{type:"json_object"}, reasoning:{effort:$eff}, messages:[{role:"system",content:$sys},{role:"user",content:$user}]}')

START_TS=$(date +%s)
RESP=$(curl -sS --http1.1 --retry 3 --retry-all-errors --max-time 600 https://openrouter.ai/api/v1/chat/completions \
  -H "Authorization: Bearer $OPENROUTER_KEY" \
  -H "Content-Type: application/json" \
  -H "HTTP-Referer: https://n8n.local" \
  -H "X-Title: CV Fallback" \
  -d "$REQ" 2>"$STDERR_FILE")
DUR=$(( $(date +%s) - START_TS ))
echo "$RESP" > "$LOG_FILE"

CV=$(echo "$RESP" | jq -r '.choices[0].message.content // empty')
[ "${#CV}" -ge 200 ] || { emit_failure "empty CV (len=${#CV})"; exit 0; }

IN_TOK=$(echo "$RESP" | jq -r '.usage.prompt_tokens // 0')
OUT_TOK=$(echo "$RESP" | jq -r '.usage.completion_tokens // 0')

CV_S=$(echo "$CV" | sed -E 's/^```(json)?[[:space:]]*//; s/[[:space:]]*```[[:space:]]*$//')
if echo "$CV_S" | jq -e 'type=="object"' >/dev/null 2>&1; then
  echo "$CV_S" | jq -c --arg j "$JOB_ID" --arg m "$OR_MODEL" --arg mode "$MODE" --arg tier "$TIER" --argjson dur "$DUR" \
    --argjson in_tok "$IN_TOK" --argjson out_tok "$OUT_TOK" \
    '{ok:true} + . + {model:$m, mode:$mode, tier:$tier, effort:"medium", duration_s:$dur, job_id:$j, engine:"openrouter", generation_mode:"single_shot_fallback", _usage:{input_tokens:$in_tok,output_tokens:$out_tok,cache_read:0,cache_create:0,cost_usd:0}}'
else
  jq -cn --arg cv "$CV" --arg j "$JOB_ID" --arg m "$OR_MODEL" --arg mode "$MODE" --arg tier "$TIER" --argjson dur "$DUR" \
    --argjson in_tok "$IN_TOK" --argjson out_tok "$OUT_TOK" \
    '{ok:true,cv_content:$cv,model:$m,mode:$mode,tier:$tier,effort:"medium",duration_s:$dur,job_id:$j,engine:"openrouter",generation_mode:"single_shot_fallback",_usage:{input_tokens:$in_tok,output_tokens:$out_tok,cache_read:0,cache_create:0,cost_usd:0}}'
fi
exit 0
