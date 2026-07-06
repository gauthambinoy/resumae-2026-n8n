#!/bin/bash
# MiMo Pro scorer (replaces Haiku): rates a generated CV 0-100 against the JD.
# Calls OpenRouter xiaomi/mimo-v2-pro via curl. Same I/O contract as old haiku script.
# Inputs (env): CV_JSON_PATH, JD_PATH, JOB_ID
# Output: JSON envelope { ok, score, breakdown, ... } on stdout
set -uo pipefail
BASE="/home/ubuntu/cv-gen"
OUTPUT_DIR="$BASE/output"
JOB_ID="${JOB_ID:-rate-$(date +%s)}"
LOG="$OUTPUT_DIR/$JOB_ID.mimo.log"
ERR="$OUTPUT_DIR/$JOB_ID.mimo.stderr"
STDOUT="$OUTPUT_DIR/$JOB_ID.mimo.stdout"
mkdir -p "$OUTPUT_DIR"

OPENROUTER_KEY="${OPENROUTER_KEY:-}"
MIMO_MODEL="${MIMO_MODEL:-xiaomi/mimo-v2-flash}"

emit_failure(){ jq -cn --arg e "$1" --arg j "$JOB_ID" '{ok:false,error:$e,job_id:$j}'; }

[ -n "${CV_JSON_PATH:-}" ] && [ -f "$CV_JSON_PATH" ] || { emit_failure "missing CV_JSON_PATH"; exit 0; }
[ -n "${JD_PATH:-}" ] && [ -f "$JD_PATH" ]           || { emit_failure "missing JD_PATH"; exit 0; }

CV=$(cat "$CV_JSON_PATH")
JD=$(cat "$JD_PATH")

RUBRIC='You are a strict CV reviewer. Rate the generated CV against the target JD.
Return ONLY JSON, no fences, no preamble:
{
  "score": 0-100 integer (overall match quality),
  "interview_promise": 0-100 integer,
  "ats_coverage": 0-100 integer,
  "ai_risk": 0-100 integer (lower is better),
  "breakdown": {
    "jd_keyword_coverage": 0-25,
    "evidence_strength": 0-25,
    "metric_density": 0-15,
    "narrative_voice": 0-15,
    "ats_safety": 0-10,
    "no_fabrication_risk": 0-10
  },
  "verdict": "EXCELLENT" | "STRONG" | "ACCEPTABLE" | "WEAK" | "BLOCKED",
  "top_3_strengths": ["...","...","..."],
  "top_3_weaknesses": ["...","...","..."],
  "one_line_summary": "single sentence verdict"
}
Be honest. 95+ = exceptional, 85-94 = strong, 70-84 = ok, <70 = needs rework.'

USER_MSG=$(jq -n --arg r "$RUBRIC" --arg jd "$JD" --arg cv "$CV" \
  '$r + "\n\nJOB DESCRIPTION:\n" + $jd + "\n\nGENERATED CV (JSON):\n" + $cv + "\n\nNow output the rating JSON only."')

PAYLOAD=$(jq -n --arg model "$MIMO_MODEL" --argjson msg "$USER_MSG" \
  '{model:$model, messages:[{role:"user",content:$msg}], response_format:{type:"json_object"}, temperature:0.2, max_tokens:2000}')

START=$(date +%s)
HTTP_CODE=$(curl -sS -o "$STDOUT" -w '%{http_code}' \
  -X POST https://openrouter.ai/api/v1/chat/completions \
  -H "Authorization: Bearer $OPENROUTER_KEY" \
  -H "Content-Type: application/json" \
  --max-time 60 \
  -d "$PAYLOAD" 2>"$ERR")
RC=$?
DUR=$(( $(date +%s) - START ))
cp "$STDOUT" "$LOG" 2>/dev/null || true

if [ "$RC" -ne 0 ] || [ "$HTTP_CODE" != "200" ]; then
  jq -cn --arg e "openrouter http=$HTTP_CODE rc=$RC" --arg j "$JOB_ID" --arg s "$(cat $STDOUT $ERR 2>/dev/null | tail -c 2000)" '{ok:false,error:$e,stderr:$s,job_id:$j}'
  exit 0
fi

# Extract the model's message content (the JSON rating)
CONTENT=$(jq -r '.choices[0].message.content // ""' "$STDOUT")
[ -z "$CONTENT" ] && { jq -cn --arg j "$JOB_ID" --arg raw "$(cat $STDOUT | head -c 2000)" '{ok:false,error:"empty content",raw:$raw,job_id:$j}'; exit 0; }

# Strip fences if present, isolate first JSON object
CONTENT_T=$(printf '%s' "$CONTENT" | sed -E 's/^```(json)?[[:space:]]*//; s/[[:space:]]*```[[:space:]]*$//')
CONTENT_T=$(printf '%s' "$CONTENT_T" | awk '/^[[:space:]]*\{/{f=1} f{print} /^[[:space:]]*\}[[:space:]]*$/ && f{print "__END__"; exit}' | sed '/__END__/d')

OUT="$CONTENT_T"
echo "$OUT" | jq -e '.score' >/dev/null 2>&1 || OUT="$CONTENT"

if echo "$OUT" | jq -e '.score' >/dev/null 2>&1; then
  echo "$OUT" | jq -c --arg j "$JOB_ID" --argjson dur "$DUR" --arg m "$MIMO_MODEL" '{ok:true} + . + {job_id:$j,duration_s:$dur,rater:$m}'
else
  jq -cn --arg raw "$OUT" --arg j "$JOB_ID" --argjson dur "$DUR" '{ok:false,error:"unparseable",raw:$raw,job_id:$j,duration_s:$dur}'
fi
exit 0
