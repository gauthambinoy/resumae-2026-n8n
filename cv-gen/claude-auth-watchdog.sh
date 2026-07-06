#!/usr/bin/env bash
# Claude CLI OAuth watchdog — alerts via Telegram if auth dies.
set -u
TG_TOKEN="${TG_TOKEN:-}"   # backup copy: real token redacted — set via env/secret store on restore
TG_CHAT="${TG_CHAT:-}"     # backup copy: real chat id redacted — set via env/secret store on restore
STATE=/home/ubuntu/cv-gen/.claude-auth-state
LOG=/home/ubuntu/cv-gen/claude-auth-watchdog.log
TS="$(date -u +%FT%TZ)"

OUT="$(timeout 30 /usr/local/bin/claude -p "ok" 2>&1 | tail -3)"
if echo "$OUT" | grep -qiE "401|invalid authentication|failed to authenticate"; then
  STATUS="DOWN"
elif echo "$OUT" | grep -qiE "429|session limit|rate limit|too many requests"; then
  STATUS="QUOTA"
else
  STATUS="UP"
fi

PREV="$(cat "$STATE" 2>/dev/null || echo UNKNOWN)"
echo "$STATUS" > "$STATE"
echo "$TS $STATUS  prev=$PREV  out=$(echo "$OUT" | tr "\n" " " | cut -c1-200)" >> "$LOG"

# Alert on DOWN or on transition UP->DOWN, and on recovery DOWN->UP
if [ "$STATUS" = "DOWN" ] && [ "$PREV" != "DOWN" ]; then
  MSG="🚨 Resumae Claude OAuth EXPIRED on EC2 ($TS UTC)%0A%0ASSH in and run:%0Assh ubuntu@52.212.112.133%0Aclaude → /login%0Asudo systemctl restart jd-clean-runner"
  curl -s -m 15 "https://api.telegram.org/bot${TG_TOKEN}/sendMessage" -d chat_id="${TG_CHAT}" -d text="$MSG" >/dev/null
elif [ "$STATUS" = "QUOTA" ] && [ "$PREV" != "QUOTA" ]; then
  RESET=$(echo "$OUT" | grep -oE "resets [0-9:apm]+ (UTC)?" | head -1)
  MSG="⏳ Resumae Claude Max QUOTA hit ($TS UTC)%0A%0AReset: $RESET%0AJD CLEAN runs will 429 until reset.%0ANo action needed — auto-recovers."
  curl -s -m 15 "https://api.telegram.org/bot${TG_TOKEN}/sendMessage" -d chat_id="${TG_CHAT}" -d text="$MSG" >/dev/null
elif [ "$STATUS" = "UP" ] && [ "$PREV" = "DOWN" ]; then
  MSG="✅ Resumae Claude OAuth RESTORED on EC2 ($TS UTC) — pipeline back online."
  curl -s -m 15 "https://api.telegram.org/bot${TG_TOKEN}/sendMessage" -d chat_id="${TG_CHAT}" -d text="$MSG" >/dev/null
fi
