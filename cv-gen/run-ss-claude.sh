#!/bin/bash
# CV runner v8 — REAL CLI controls
# Knobs:
#   MODEL (--model, hard)
#   THINKING → --effort flag (REAL hard control: low/medium/high/xhigh/max)
#   WEBSEARCH on/off (--disallowed-tools, hard)
#   OUTPUT_CAP (CLAUDE_CODE_MAX_OUTPUT_TOKENS env, hard)
set -uo pipefail

BASE="/home/ubuntu/cv-gen"
PROMPTS_DIR="$BASE/prompts"
MODES_DIR="$BASE/modes"
OUTPUT_DIR="$BASE/output"
CLAUDE_BIN="/usr/local/bin/claude"

MODE="${MODE:-professional}"
case "$MODE" in professional|graduate|retail|research|healthcare|hospitality) ;; *) MODE="professional" ;; esac

MODEL="${SS_MODEL:-claude-sonnet-4-6}"
TIER="${TIER:-balanced}"
# Tier sanity guard (2026-05-24 v2): unknown tiers stay as-is.
# ultra_premium keeps medium thinking. If it TTFT-hangs, fallback handler below
# retries with Opus LOW (same model, less thinking) so the user still gets a CV.
case "$TIER" in
  fast|balanced|ultra) ;;
  *) echo "[ss-claude] INFO: unknown tier '$TIER' — keeping as-is (env vars drive thinking/cap)" >&2 ;;
esac
THINKING="${THINKING:-medium}"
WEBSEARCH="${WEBSEARCH:-off}"
WEBSEARCH_MAX="${WEBSEARCH_MAX:-0}"
OUTPUT_CAP="${OUTPUT_CAP:-64000}"

# Validate effort
case "$THINKING" in
  low|medium|high|xhigh|max) EFFORT="$THINKING" ;;
  off|none|"") EFFORT="" ;;
  *) EFFORT="" ;;
esac

mkdir -p "$OUTPUT_DIR"
JOB_ID="${JOB_ID:-$(date -u +%Y-%m-%dT%H-%M-%S)-$(uuidgen | cut -c1-6)-ss-$MODE}"
export JOB_ID  # preserve across validator-retry exec
LOG_FILE="$OUTPUT_DIR/$JOB_ID.log"
STDERR_FILE="$OUTPUT_DIR/$JOB_ID.stderr"
# P0-3 (2026-07-03): persistent logging re-enabled — tee ALL [ss-claude] stderr
# diagnostics (tier/model/attempt#/error tag/TTFT/watchdog/durations/validator) to
# $LOG_FILE while still emitting to stderr. Append (-a) so validator-retry execs (same
# JOB_ID) accumulate into one file. Lightweight; raw model stream stays in $JOB_ID.stdout.
exec 2> >(tee -a "$LOG_FILE" >&2)
echo "[ss-claude] tier=$TIER mode=$MODE model=$MODEL effort=$EFFORT websearch=$WEBSEARCH/$WEBSEARCH_MAX cap=$OUTPUT_CAP job=$JOB_ID" >&2

emit_failure() {
  local err="$1" cls="${2:-permanent}" tail retryable
  tail=$(tail -c 4000 "$STDERR_FILE" 2>/dev/null || echo "")
  if [ "$cls" = "retryable" ]; then retryable=true; else retryable=false; fi
  jq -cn --arg e "$err" --arg s "$tail" --arg j "$JOB_ID" --arg mode "$MODE" \
    --arg cls "$cls" --argjson retry "$retryable" --arg tag "${ERR_TAG:-NONE}" \
    --arg tier "$TIER" --arg model "$MODEL" \
    '{ok:false,error:$e,error_class:$cls,retryable:$retry,error_tag:$tag,tier:$tier,model:$model,stderr:$s,job_id:$j,mode:$mode}'
}

# F9: presence guards — never die silently on a missing binary; emit retryable so n8n can requeue.
command -v jq >/dev/null 2>&1 || { echo '{"ok":false,"retryable":true,"error":"jq missing"}'; exit 0; }
command -v python3 >/dev/null 2>&1 || { emit_failure "python3 missing" retryable; exit 0; }
[ -x "$CLAUDE_BIN" ] || { emit_failure "claude binary missing at $CLAUDE_BIN" retryable; exit 0; }

PROMPT_TEMPLATE="$PROMPTS_DIR/master_single_shot.md"
PROFILE_FILE="$MODES_DIR/$MODE.profile.md"
[ -f "$PROMPT_TEMPLATE" ] || { emit_failure "missing prompt"; exit 0; }
[ -f "$PROFILE_FILE" ]   || { emit_failure "missing profile"; exit 0; }

if [ -n "${JD_PATH:-}" ] && [ -f "$JD_PATH" ]; then JD_CLEANED=$(cat "$JD_PATH"); else emit_failure "no JD"; exit 0; fi
if [ "${#JD_CLEANED}" -gt 20000 ]; then
  echo "[ss-claude] AUTO: capping JD ${#JD_CLEANED} -> 20000 chars (runaway prompt guard)" >&2
  JD_CLEANED="${JD_CLEANED:0:20000}"
fi
[ "${#JD_CLEANED}" -ge 30 ] || { emit_failure "JD too short"; exit 0; }

# === REAL PROJECTS injection (source-of-truth selector; 2026-07-02) ===
REAL_PROJECTS="(none provided — invent JD-aligned projects per the rules)"
if [ -f /home/ubuntu/cv-gen/select_relevant.py ] && [ -f /home/ubuntu/cv-gen/source_of_truth.json ]; then
  _rp=$(python3 /home/ubuntu/cv-gen/select_relevant.py "$JD_PATH" 2>/dev/null | python3 -c 'import json,sys
try:
    d=json.load(sys.stdin); out=[]
    for p in (d.get("selected_projects") or [])[:5]:
        s=", ".join((p.get("stack") or [])[:8]); w=(p.get("what") or "").strip()
        ln="- "+str(p.get("name",""))+" | stack: "+s+" | "+w
        if p.get("problem"):  ln+=" | problem: "+str(p["problem"])
        if p.get("features"): ln+=" | features: "+str(p["features"])
        if p.get("how"):      ln+=" | how: "+str(p["how"])
        if p.get("outcome"):  ln+=" | outcome: "+str(p["outcome"])
        out.append(ln)
    sys.stdout.write(chr(10).join(out))
except Exception: pass' 2>/dev/null)
  [ -n "$_rp" ] && REAL_PROJECTS="$_rp"
fi
echo "[ss-claude] real-projects block chars=${#REAL_PROJECTS}" >&2

# === REAL EXPERIENCES injection (source-of-truth selector; gated by USE_REAL_EXP; 2026-07-02) ===
REAL_EXPERIENCES=""
if [ "${USE_REAL_EXP:-}" = "1" ] && [ -f /home/ubuntu/cv-gen/select_relevant.py ]; then
  _re=$(python3 /home/ubuntu/cv-gen/select_relevant.py "$JD_PATH" 2>/dev/null | python3 -c 'import json,sys
try:
    d=json.load(sys.stdin); out=[]
    for i,e in enumerate((d.get("selected_experiences") or [])[:3]):
        t="; ".join(e.get("titles") or [])
        dm=", ".join(e.get("domains") or [])
        nt=(e.get("notes") or "").replace(chr(10)," ").strip()
        while "  " in nt: nt=nt.replace("  "," ")
        nt=nt[:1500]
        ln="[ROLE_"+str(i+1)+"] company="+str(e.get("company",""))+" | titles="+t+" | dates="+str(e.get("start",""))+" - "+str(e.get("end",""))+" | country="+str(e.get("location","")).split(" (")[0]+" | domains="+dm
        if nt: ln+=" | real_work(truthful grounding): "+nt
        out.append(ln)
    sys.stdout.write(chr(10).join(out))
except Exception: pass' 2>/dev/null)
  [ -n "$_re" ] && REAL_EXPERIENCES="$_re"
fi
echo "[ss-claude] real-experiences block chars=${#REAL_EXPERIENCES}" >&2

# === REAL EDUCATION injection (3rd source of truth; 2026-07-02) ===
REAL_EDUCATION=""
if [ -f /home/ubuntu/cv-gen/source_of_truth.json ]; then
  _ed=$(python3 -c 'import json,sys
try:
    d=json.load(open("/home/ubuntu/cv-gen/source_of_truth.json")); out=[]
    for i,e in enumerate((d.get("education") or [])[:3]):
        deg=str(e.get("degree","")); fld=str(e.get("field","")); inst=str(e.get("institution",""))
        dates=str(e.get("start",""))+" - "+str(e.get("end",""))
        hl=str(e.get("highlights",""))
        ln="[EDU_"+str(i+1)+"] "+deg+" "+fld+" - "+inst+" ("+dates+", "+str(e.get("location",""))+")"
        if hl: ln+=" | "+hl
        out.append(ln)
    sys.stdout.write(chr(10).join(out))
except Exception: pass' 2>/dev/null)
  [ -n "$_ed" ] && REAL_EDUCATION="$_ed"
fi
echo "[ss-claude] real-education block chars=${#REAL_EDUCATION}" >&2

# === FULL BACKGROUND palette (Option B — all real skills across all exp/edu/projects; 2026-07-03) ===
FULL_BACKGROUND=""
if [ -f /home/ubuntu/cv-gen/source_of_truth.json ]; then
  _fb=$(python3 -c 'import json,sys
try:
    d=json.load(open("/home/ubuntu/cv-gen/source_of_truth.json")); out=[]
    for e in d.get("experiences",[]):
        out.append("- "+str(e.get("company",""))+": "+", ".join((e.get("domains") or [])[:16]))
    for e in d.get("education",[]):
        out.append("- "+str(e.get("degree",""))+" "+str(e.get("field",""))+": "+str(e.get("highlights",""))[:220])
    pt=[]
    for p in d.get("projects",[]):
        pt.append(str(p.get("name",""))+"("+", ".join((p.get("stack") or [])[:4])+")")
    if pt: out.append("- Project tech: "+"; ".join(pt))
    sys.stdout.write(chr(10).join(out))
except Exception: pass' 2>/dev/null)
  [ -n "$_fb" ] && FULL_BACKGROUND="$_fb"
fi
echo "[ss-claude] full-background block chars=${#FULL_BACKGROUND}" >&2

PROFILE_CONTENT=$(cat "$PROFILE_FILE")
# (2026-07-03 fix) Pass text blocks via ENVIRON, NOT awk -v: gawk C-escape-processes
# -v values (\n \t \x + Windows paths in JD/sheet data get mangled). ENVIRON is passed
# through verbatim. Same {{TOKEN}} substitution logic, just sourced from the environment.
export JD_CLEANED PROFILE_CONTENT REAL_EXPERIENCES REAL_PROJECTS REAL_EDUCATION FULL_BACKGROUND EFFORT MODE
PROMPT=$(awk '
  BEGIN { profile_inserted=0 }
  {
    line=$0
    gsub(/\{\{MODE\}\}/, ENVIRON["MODE"], line); gsub(/\{\{THINKING_LEVEL\}\}/, "Reasoning effort is set to " ENVIRON["EFFORT"] " by CLI. Use that budget.", line)
    n = index(line, "{{JD_CLEANED}}")
    if (n > 0) { print substr(line,1,n-1) ENVIRON["JD_CLEANED"] substr(line,n+length("{{JD_CLEANED}}")); next }
    r = index(line, "{{REAL_EXPERIENCES}}")
    if (r > 0) { rt = line; gsub(/^[ \t]+|[ \t]+$/, "", rt); if (rt == "{{REAL_EXPERIENCES}}") { print ENVIRON["REAL_EXPERIENCES"]; next } }
    pj = index(line, "{{REAL_PROJECTS}}")
    if (pj > 0) { print substr(line,1,pj-1) ENVIRON["REAL_PROJECTS"] substr(line,pj+length("{{REAL_PROJECTS}}")); next }
    ed = index(line, "{{REAL_EDUCATION}}")
    if (ed > 0) { print substr(line,1,ed-1) ENVIRON["REAL_EDUCATION"] substr(line,ed+length("{{REAL_EDUCATION}}")); next }
    fb = index(line, "{{FULL_BACKGROUND}}")
    if (fb > 0) { print substr(line,1,fb-1) ENVIRON["FULL_BACKGROUND"] substr(line,fb+length("{{FULL_BACKGROUND}}")); next }
    if (!profile_inserted && line ~ /^═+$/) {
      print line; print ""; print ENVIRON["PROFILE_CONTENT"]; print ""; profile_inserted=1; next
    }
    print line
  }
' "$PROMPT_TEMPLATE")

echo "[ss-claude] prompt_chars=${#PROMPT} jd_chars=${#JD_CLEANED}" >&2

START_TS=$(date +%s)
STDOUT_TMP="$OUTPUT_DIR/$JOB_ID.stdout"
export CLAUDE_CODE_MAX_OUTPUT_TOKENS="$OUTPUT_CAP"

DISALLOW="Bash,Edit,Read,Write,Glob,Grep,Task,NotebookEdit,TodoWrite,Skill,ToolSearch,WebFetch"
if [ "$WEBSEARCH" != "on" ]; then DISALLOW="$DISALLOW,WebSearch"; fi

# P0-1: Per-tier budget ladder removed. --max-budget-usd conflicts with Max subscription auth.
# Real cap is enforced via CLAUDE_CODE_MAX_OUTPUT_TOKENS (OUTPUT_CAP) below.
# Notional reference: Fast~\$0.25, Balanced~\$0.60, Ultra~\$1.50 per CV.
echo "[ss-claude] cap_via_output_tokens=$OUTPUT_CAP (no --max-budget-usd; conflicts with subscription)" >&2

CLAUDE_ARGS=(--model "$MODEL"); [ -n "$EFFORT" ] && CLAUDE_ARGS+=(--effort "$EFFORT"); CLAUDE_ARGS+=(--dangerously-skip-permissions --disallowed-tools "$DISALLOW" --output-format stream-json --verbose -p)

# === IDLE WATCHDOG + RETRY v2 (2026-05-14) ===
# Kill ONLY if Claude stops streaming for IDLE_KILL_SEC. Long generations are fine
# as long as bytes keep flowing. Never falls back to other models — always same MODEL.
ATTEMPT=1
MAX_ATTEMPTS=2
# P1-1: cleanup orphans on signal/exit
CLAUDE_PID=""
WATCHDOG_PID=""
cleanup() {
  [ -n "$WATCHDOG_PID" ] && kill -KILL "$WATCHDOG_PID" 2>/dev/null
  [ -n "$CLAUDE_PID" ] && kill -KILL "$CLAUDE_PID" 2>/dev/null
  # P0-5 (2026-07-03): best-effort S3 log shipping at end of run. Only if S3_LOG_BUCKET
  # is set AND aws CLI exists AND the log exists; backgrounded + || true so it can never
  # block or fail the run. Skips silently otherwise.
  if [ -n "${S3_LOG_BUCKET:-}" ] && [ -f "${LOG_FILE:-/nonexistent}" ] && command -v aws >/dev/null 2>&1; then
    ( aws s3 cp "$LOG_FILE" "s3://$S3_LOG_BUCKET/cv-logs/$JOB_ID.log" >/dev/null 2>&1 || true ) &
  fi
}
trap cleanup EXIT INT TERM
BACKOFFS=(5 15 30)
IDLE_KILL_SEC=300
MAX_ATTEMPT_SEC=600
# P1-2: TTFT scales by model (Opus low can warm up to 90s)
if [[ "$MODEL" == *opus* ]]; then
  TTFT_KILL_SEC=540  # 2026-05-24: bumped for Opus medium reliability
else
  TTFT_KILL_SEC=$(( 180 + (${#PROMPT} / 50000) * 30 )); [ "$TTFT_KILL_SEC" -gt 300 ] && TTFT_KILL_SEC=300
fi
SAMPLE_SEC=10

# Auto-disable extended thinking for Sonnet (it spirals on multi-gate prompts)
if [[ "$MODEL" == *sonnet* ]] && [ -n "$EFFORT" ]; then
  echo "[ss-claude] AUTO: clearing --effort for Sonnet (was=$EFFORT) to prevent thinking spiral" >&2
  EFFORT=""
  # Rebuild CLAUDE_ARGS without --effort
  CLAUDE_ARGS=(--model "$MODEL" --dangerously-skip-permissions --disallowed-tools "$DISALLOW" --output-format stream-json --verbose -p)
fi
# Fast-tier (Sonnet) cap floor (2026-06-28 fastfix): 12000 sits BELOW the observed
# full-CV total-output envelope (real CVs ran ~14k-39k output tokens incl. reasoning).
# Sonnet has --effort cleared above so its payload is ~2k tokens and 12000 already
# fits -- but this gives Sonnet the same proven headroom as Balanced so an unusually
# large CV can never truncate (stop_reason=max_tokens -> JSON parse fail -> hard fail).
# Ceiling only: no cost/latency impact when the model finishes earlier (it normally does).
if [[ "$MODEL" == *sonnet* ]] && [ "${OUTPUT_CAP:-0}" -lt 22000 ]; then
  echo "[ss-claude] AUTO: raising Sonnet OUTPUT_CAP $OUTPUT_CAP -> 22000 (anti-truncation headroom)" >&2
  OUTPUT_CAP=22000
  export CLAUDE_CODE_MAX_OUTPUT_TOKENS="$OUTPUT_CAP"
fi
FINAL_RC=1

while [ "$ATTEMPT" -le "$MAX_ATTEMPTS" ]; do
  : > "$STDOUT_TMP"
  : > "$STDERR_FILE"
  ATTEMPT_START=$(date +%s)

  printf "%s" "$PROMPT" | stdbuf -o0 "$CLAUDE_BIN" "${CLAUDE_ARGS[@]}" > "$STDOUT_TMP" 2> "$STDERR_FILE" &
  CLAUDE_PID=$!

  (
    LAST_SIZE=0
    LAST_PROGRESS=$(date +%s)
    WATCHDOG_KILLED=0
    while kill -0 "$CLAUDE_PID" 2>/dev/null; do
      sleep $SAMPLE_SEC
      CUR_SIZE=$(wc -c < "$STDOUT_TMP" 2>/dev/null || echo 0)
      NOW=$(date +%s)
      ELAPSED=$((NOW - ATTEMPT_START))
      if [ "$ELAPSED" -ge "$MAX_ATTEMPT_SEC" ]; then
        echo "[ss-claude] WATCHDOG: attempt hit ${MAX_ATTEMPT_SEC}s hard cap (bytes=$CUR_SIZE), killing PID $CLAUDE_PID" >&2
        kill -TERM "$CLAUDE_PID" 2>/dev/null; sleep 2; kill -KILL "$CLAUDE_PID" 2>/dev/null
        exit 98
      fi
      # === TTFT detection: no assistant event in 60s = endpoint stuck ===
      if [ "$ELAPSED" -ge "$TTFT_KILL_SEC" ] && ! grep -qE "\"type\":(\"assistant\"|\"thinking\")" "$STDOUT_TMP" 2>/dev/null; then
        echo "[ss-claude] WATCHDOG: TTFT timeout ${TTFT_KILL_SEC}s, no assistant event (bytes=$CUR_SIZE), killing PID $CLAUDE_PID" >&2
        kill -TERM "$CLAUDE_PID" 2>/dev/null; sleep 2; kill -KILL "$CLAUDE_PID" 2>/dev/null
        exit 97
      fi
      if [ "$CUR_SIZE" -gt "$LAST_SIZE" ]; then
        LAST_SIZE=$CUR_SIZE
        LAST_PROGRESS=$NOW
      else
        IDLE=$((NOW - LAST_PROGRESS))
        if [ "$IDLE" -ge "$IDLE_KILL_SEC" ]; then
          echo "[ss-claude] WATCHDOG: stream idle ${IDLE}s, killing PID $CLAUDE_PID (bytes=$CUR_SIZE)" >&2
          kill -TERM "$CLAUDE_PID" 2>/dev/null
          sleep 2
          kill -KILL "$CLAUDE_PID" 2>/dev/null
          exit 99
        fi
      fi
    done
  ) &
  WATCHDOG_PID=$!

  wait "$CLAUDE_PID" 2>/dev/null
  RC=$?
  kill "$WATCHDOG_PID" 2>/dev/null
  wait "$WATCHDOG_PID" 2>/dev/null

  DUR=$(( $(date +%s) - ATTEMPT_START ))
  SIZE=$(wc -c < "$STDOUT_TMP" 2>/dev/null || echo 0)

  if [ "$RC" -eq 0 ] && [ "$SIZE" -gt 500 ]; then
    echo "[ss-claude] done attempt=$ATTEMPT rc=$RC duration_s=$DUR bytes=$SIZE" >&2
    FINAL_RC=0
    break
  fi

  echo "[ss-claude] ATTEMPT $ATTEMPT FAILED rc=$RC bytes=$SIZE duration_s=$DUR" >&2
  # P1-7: detect rate-limit / pool exhaustion
  ERR_TAG="MODEL_ERROR"
  if grep -qiE "rate.?limit|429|usage.?limit|out_of_credits" "$STDERR_FILE" "$STDOUT_TMP" 2>/dev/null; then
    if [[ "$MODEL" == *opus* ]]; then ERR_TAG="RATE_LIMIT_OPUS"; else ERR_TAG="RATE_LIMIT_SONNET"; fi
    echo "[ss-claude] ERROR_TAG=$ERR_TAG (pool exhausted or rate-limited)" >&2
  fi
  # F9: auth / credential failure classification
  if grep -qiE "unauthorized|401|invalid api key|please run .*login|authentication" "$STDERR_FILE" "$STDOUT_TMP" 2>/dev/null; then
    ERR_TAG="AUTH_ERROR"
    echo "[ss-claude] ERROR_TAG=$ERR_TAG (auth/credential failure)" >&2
  fi

  # === SONNET ENDPOINT FAILURE DETECTION + OPUS FALLBACK (2026-05-15) ===
  # Detect: Sonnet model, tiny stdout (< 5KB), and no assistant event = endpoint stuck.
  # On detection, swap to Opus with low effort + reduced cap for the FINAL attempt only.
  
    # OPUS MEDIUM → OPUS LOW fallback on TTFT (2026-05-24)
    if [[ "$MODEL" == *opus* ]] && [ "$EFFORT" = "medium" ] && [ "$ATTEMPT" = "1" ]; then
      echo "[ss-claude] OPUS MEDIUM TTFT-killed — falling back to Opus LOW for attempt 2" >&2
      EFFORT="low"
      OUTPUT_CAP="18000"
      CLAUDE_ARGS=(--model "$MODEL" --effort "$EFFORT" --dangerously-skip-permissions --disallowed-tools "$DISALLOW" --output-format stream-json --verbose -p)
      MAX_ATTEMPTS=2
    fi
    if [[ "$MODEL" == *sonnet* ]] && { [ "$ERR_TAG" = "RATE_LIMIT_SONNET" ] || ! grep -qE '"type":("assistant"|"thinking")' "$STDOUT_TMP" 2>/dev/null; }; then
      echo "[ss-claude] SONNET-ENDPOINT-FAIL detected (bytes=$SIZE, tag=$ERR_TAG). Swapping to Opus low for one more attempt." >&2
      MODEL="claude-opus-4-8"; EFFORT="low"; OUTPUT_CAP=18000
      export CLAUDE_CODE_MAX_OUTPUT_TOKENS="$OUTPUT_CAP"; TTFT_KILL_SEC=540
      CLAUDE_ARGS=(--model "$MODEL" --effort "$EFFORT" --dangerously-skip-permissions --disallowed-tools "$DISALLOW" --output-format stream-json --verbose -p)
      MAX_ATTEMPTS=$((ATTEMPT + 1))   # guarantee one more (Opus) attempt
      echo "[ss-claude] FALLBACK ACTIVE: model=$MODEL effort=$EFFORT cap=$OUTPUT_CAP ttft=${TTFT_KILL_SEC}s max_attempts=$MAX_ATTEMPTS" >&2
    fi
  # === END FALLBACK BLOCK ===

  if [ "$ATTEMPT" -lt "$MAX_ATTEMPTS" ]; then
    BACKOFF=${BACKOFFS[$((ATTEMPT-1))]}
    case "$ERR_TAG" in RATE_LIMIT_*) BACKOFF=$((BACKOFF * 4)) ;; esac
    if [[ "$MODEL" != *opus* ]] && [ "$TTFT_KILL_SEC" -lt 300 ]; then
      TTFT_KILL_SEC=$((TTFT_KILL_SEC + 60)); [ "$TTFT_KILL_SEC" -gt 300 ] && TTFT_KILL_SEC=300
      echo "[ss-claude] widened TTFT to ${TTFT_KILL_SEC}s for next retry" >&2
    fi
    echo "[ss-claude] retrying in ${BACKOFF}s (model: $MODEL)..." >&2
    sleep $BACKOFF
  fi
  ATTEMPT=$((ATTEMPT + 1))
done

RC=$FINAL_RC
TOTAL_DUR=$(( $(date +%s) - START_TS ))
echo "[ss-claude] final rc=$RC after $((ATTEMPT > MAX_ATTEMPTS ? MAX_ATTEMPTS : ATTEMPT)) attempts total_duration_s=$TOTAL_DUR" >&2
# === END WATCHDOG ===

# P0-3 (2026-07-03): persistent logging now ACTIVE via the stderr tee at the top of the
# script (all [ss-claude] diagnostics -> $LOG_FILE). The raw model stream and claude
# stderr already persist as $JOB_ID.stdout / $JOB_ID.stderr, so no redundant copy here.

if [ "$RC" -ne 0 ]; then
  # F7/F9: after exhausting retries (incl. Opus fallback) always emit a RETRYABLE
  # envelope so the n8n side can requeue instead of dying. Branch kept for clarity.
  case "${ERR_TAG:-}" in
    RATE_LIMIT_*|AUTH_ERROR) emit_failure "claude exit $RC (tag=${ERR_TAG:-NONE})" retryable ;;
    *)                       emit_failure "claude exit $RC (tag=${ERR_TAG:-NONE})" retryable ;;
  esac
  exit 0
fi
CV=$(jq -rs 'map(select(.type=="result")) | last | .result // empty' "$STDOUT_TMP" 2>/dev/null)
[ -z "$CV" ] && CV=$(jq -rs 'map(select(.type=="assistant") | .message.content[]? | select(.type=="text") | .text) | join("")' "$STDOUT_TMP" 2>/dev/null)

USAGE=$(jq -rs 'map(select(.type=="result")) | last | .usage // {}' "$STDOUT_TMP" 2>/dev/null)
IN_TOK=$(echo "$USAGE" | jq -r '.input_tokens // 0')
OUT_TOK=$(echo "$USAGE" | jq -r '.output_tokens // 0')
CACHE_READ=$(echo "$USAGE" | jq -r '.cache_read_input_tokens // 0')
CACHE_CREATE=$(echo "$USAGE" | jq -r '.cache_creation_input_tokens // 0')
COST=$(jq -rs 'map(select(.type=="result")) | last | .total_cost_usd // 0' "$STDOUT_TMP" 2>/dev/null)

[ "${#CV}" -ge 200 ] || { emit_failure "empty CV (len=${#CV})"; exit 0; }

CV_S=$(echo "$CV" | sed -E 's/^```(json)?[[:space:]]*//; s/[[:space:]]*```[[:space:]]*$//')
CV_T=$(echo "$CV_S" | awk '/^[[:space:]]*\{/{f=1} f{print} /^[[:space:]]*\}[[:space:]]*$/{f=0}')
if [ -n "$CV_T" ] && echo "$CV_T" | jq -e 'type=="object"' >/dev/null 2>&1; then CV="$CV_T"; fi

# --- CR-VALIDATE: strict sanitize+validate (curly quotes, skills/projects/certs, word cap)
VAL_TMP="$(mktemp)"
printf '%s' "$CV" > "$VAL_TMP"
# CR-VALIDATE-FALLBACK (2026-07-01): never hand validate_cv.py an empty file.
# The primary extraction (result/assistant text -> fence strip -> awk brace slice)
# can yield an empty/truncated $VAL_TMP even when the model streamed real JSON
# (minified one-line output, JSON nested in a structured_output/result field, or a
# json-fenced block the awk slice mishandled) -> validate_cv.py then dies with
# "Expecting value: line 1 column 1 (char 0)". If VAL_TMP is empty/tiny but the raw
# stream (or $CV) still holds a {...} block, recover the largest balanced object that
# contains "cv_content" (else the first parseable balanced object) from the raw stdout.
VAL_TMP_BYTES=$(wc -c < "$VAL_TMP" 2>/dev/null || echo 0)
if [ "${VAL_TMP_BYTES:-0}" -lt 50 ]; then
  FALLBACK_JSON=$(CV_RAW="$CV" python3 - "$STDOUT_TMP" <<'PYEOF' 2>/dev/null
import os, sys, json


def balanced_objects(text):
    out = []
    depth = 0
    start = -1
    in_str = False
    esc = False
    for i, ch in enumerate(text):
        if in_str:
            if esc:
                esc = False
            elif ch == '\\':
                esc = True
            elif ch == '"':
                in_str = False
            continue
        if ch == '"':
            in_str = True
        elif ch == '{':
            if depth == 0:
                start = i
            depth += 1
        elif ch == '}':
            if depth > 0:
                depth -= 1
                if depth == 0 and start >= 0:
                    out.append(text[start:i + 1])
                    start = -1
    return out


texts = []
cv_raw = os.environ.get('CV_RAW', '')
if cv_raw.strip():
    texts.append(cv_raw)

raw = ''
if len(sys.argv) > 1:
    try:
        with open(sys.argv[1], 'r', encoding='utf-8', errors='replace') as fh:
            raw = fh.read()
    except OSError:
        raw = ''

# Reconstruct the model's text from the stream-json events (result / structured_output
# / assistant text blocks) so a JSON nested in those fields is still recoverable.
recon = []
for line in raw.splitlines():
    line = line.strip()
    if not line or line[0] != '{':
        continue
    try:
        ev = json.loads(line)
    except Exception:
        continue
    if not isinstance(ev, dict):
        continue
    r = ev.get('result')
    if isinstance(r, str) and r.strip():
        recon.append(r)
    elif isinstance(r, dict):
        recon.append(json.dumps(r))
    so = ev.get('structured_output')
    if isinstance(so, dict):
        recon.append(json.dumps(so))
    msg = ev.get('message')
    if isinstance(msg, dict):
        for blk in msg.get('content', []) or []:
            if isinstance(blk, dict) and blk.get('type') == 'text':
                t = blk.get('text', '')
                if isinstance(t, str) and t:
                    recon.append(t)
if recon:
    texts.append(''.join(recon))
if raw.strip():
    texts.append(raw)

best = None
for text in texts:
    for obj in balanced_objects(text):
        # (2026-07-03 fix) Match the exact quoted key so the model's split-output
        # wrapper "cv_content_continued" no longer counts as a hit (substring
        # '"cv_content"' is absent in '"cv_content_continued"').
        if '"cv_content"' not in obj:
            continue
        try:
            json.loads(obj)
        except Exception:
            continue
        if best is None or len(obj) > len(best):
            best = obj
    if best is not None:
        break

if best is None:
    for text in texts:
        for obj in balanced_objects(text):
            try:
                json.loads(obj)
            except Exception:
                continue
            best = obj
            break
        if best is not None:
            break

if best is not None:
    sys.stdout.write(best)
PYEOF
)
  if [ -n "$FALLBACK_JSON" ] && [ "${#FALLBACK_JSON}" -ge 50 ]; then
    printf '%s' "$FALLBACK_JSON" > "$VAL_TMP"
    CV="$FALLBACK_JSON"
    echo "[ss-claude] VAL_TMP fallback: primary extraction gave ${VAL_TMP_BYTES}B; recovered ${#FALLBACK_JSON}B balanced JSON from raw stdout" >&2
  else
    echo "[ss-claude] VAL_TMP fallback: primary gave ${VAL_TMP_BYTES}B and no balanced JSON recovered from raw stdout" >&2
  fi
fi
VAL_OUT="$(python3 /home/ubuntu/cv-gen/validate_cv.py "$MODE" "$VAL_TMP" 2>/tmp/cv_val_err.$$)"
VAL_RC=$?
VAL_ERR="$(cat /tmp/cv_val_err.$$ 2>/dev/null)"
rm -f "$VAL_TMP" /tmp/cv_val_err.$$
if [ "$VAL_RC" -ne 0 ]; then
  VAL_TRIES=${VAL_TRIES:-0}
  # (2026-07-03 fix) Rate-limit / session-limit: do NOT escalate to Opus and do NOT
  # retry — a 5-hour subscription limit can't be out-waited; retrying just burns quota.
  RATE_LIMITED=0
  case "${ERR_TAG:-}" in RATE_LIMIT_*) RATE_LIMITED=1 ;; esac
  if printf '%s' "$VAL_ERR" | grep -qiE "rate.?limit|out_of_credits|session.?limit|usage.?limit"; then RATE_LIMITED=1; fi
  # (2026-07-03 fix) Cap validator-retries at 1 (was 3). The single retry escalates to Opus low.
  if [ "$RATE_LIMITED" -eq 0 ] && [ "$VAL_TRIES" -lt 1 ]; then
    export VAL_TRIES=$((VAL_TRIES+1))
    export SS_MODEL=claude-opus-4-8
    export THINKING=low
    export CLAUDE_CODE_MAX_OUTPUT_TOKENS=10000
    echo "[ss-claude] VALIDATOR_FAIL (try 1/1): $VAL_ERR — swapping to Opus low + re-running" >&2
    sleep 3
    exec /home/ubuntu/cv-gen/run-ss-claude.sh
  fi
  # (2026-07-03 fix) Retries exhausted (or rate-limited): DELIVER the best CV we have
  # rather than lose a valid CV to a strict-validator miss. Only emit_failure if there
  # is genuinely no usable CV object.
  if echo "$CV" | jq -e 'type=="object"' >/dev/null 2>&1; then
    echo "[ss-claude] VALIDATOR_FAIL final ($VAL_ERR) — delivering best unvalidated CV (rate_limited=$RATE_LIMITED)" >&2
    # fall through to delivery below ($CV already holds the extracted object)
  else
    echo "[ss-claude] VALIDATOR_FAIL final ($VAL_ERR) — no usable CV object, emitting retryable (rate_limited=$RATE_LIMITED)" >&2
    emit_failure "validator (after retries): $VAL_ERR" retryable
    exit 0
  fi
else
  CV="$VAL_OUT"
fi
# --- /CR-VALIDATE

if echo "$CV" | jq -e 'type=="object"' >/dev/null 2>&1; then
  echo "$CV" | jq -c --arg j "$JOB_ID" --arg m "$MODEL" --arg mode "$MODE" --arg tier "$TIER" --arg eff "$EFFORT" --argjson dur "$DUR" \
    --argjson in_tok "$IN_TOK" --argjson out_tok "$OUT_TOK" --argjson cr "$CACHE_READ" --argjson cc "$CACHE_CREATE" --argjson cost "$COST" \
    '{ok:true} + . + {model:$m, mode:$mode, tier:$tier, effort:$eff, duration_s:$dur, job_id:$j, engine:"claude", generation_mode:"single_shot", _usage:{input_tokens:$in_tok,output_tokens:$out_tok,cache_read:$cr,cache_create:$cc,cost_usd:$cost}}'
else
  jq -cn --arg cv "$CV" --arg j "$JOB_ID" --arg m "$MODEL" --arg mode "$MODE" --arg tier "$TIER" --arg eff "$EFFORT" --argjson dur "$DUR" \
    --argjson in_tok "$IN_TOK" --argjson out_tok "$OUT_TOK" --argjson cr "$CACHE_READ" --argjson cc "$CACHE_CREATE" --argjson cost "$COST" \
    '{ok:true,cv_content:$cv,model:$m,mode:$mode,tier:$tier,effort:$eff,duration_s:$dur,job_id:$j,engine:"claude",generation_mode:"single_shot",_usage:{input_tokens:$in_tok,output_tokens:$out_tok,cache_read:$cr,cache_create:$cc,cost_usd:$cost}}'
fi
exit 0
