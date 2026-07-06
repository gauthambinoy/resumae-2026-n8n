#!/bin/bash
# make-resumae-git-snapshot.sh
# Produces a CLEAN, SECRET-FREE, REDACTED tarball of the Resumae system for the
# git backup repo (top-resumae-2026-n8n). Refuses to emit if any secret survives.
# The box never holds the git push token — Windows pulls this tarball and pushes.
set -uo pipefail
S=/tmp/resumae-git-stage
OUT=/tmp/resumae-git-snapshot.tar.gz
rm -rf "$S" "$OUT"; mkdir -p "$S/cv-gen" "$S/n8n"

# 1) cv-gen source (exclude secrets, junk, .bak clutter)
rsync -a --prune-empty-dirs \
  --exclude='*.bak*' --exclude='__pycache__' --exclude='output' --exclude='backups' \
  --exclude='deliverables' --exclude='tmp' --exclude='qa' --exclude='test-jds-*' \
  --exclude='snapshot-*' --exclude='*.log' \
  --exclude='.gsheets.json' --exclude='credentials/github.token' \
  --exclude='credentials/openrouter.key' --exclude='.claude-auth-state' \
  --exclude='wf-backup*.json' --exclude='workflow_backup*.json' --exclude='*.tar.gz' \
  "$HOME/cv-gen/" "$S/cv-gen/"

# 2) n8n stack (NO .env)
cp -a "$HOME/n8n/docker-compose.yml" "$HOME/n8n/Dockerfile" "$S/n8n/" 2>/dev/null || true
cp -a "$HOME/n8n/sql" "$S/n8n/" 2>/dev/null || true

# 3) all workflows exported (recoverable without the DB)
if docker exec n8n n8n export:workflow --all --output=/tmp/wf_all.json >/dev/null 2>&1; then
  docker exec n8n cat /tmp/wf_all.json > "$S/n8n/workflows_all.json" 2>/dev/null || true
fi

# 4) delete any secret-shaped FILE that slipped in
find "$S" \( -name '*.env' -o -name '*.env.*' -o -name '*.token' -o -name '*.key' \
  -o -name '.gsheets.json' -o -name '*.sqlite' -o -name '*.tar.gz' -o -name '.claude-auth-state' \) -delete 2>/dev/null

# 5) redact known hardcoded secrets in scripts + generic value sweep
sed -i -E 's#(OPENROUTER_KEY="\$\{OPENROUTER_KEY:-)[^}"]*(\}")#\1\2#' "$S/cv-gen/run-haiku-rate.sh" 2>/dev/null || true
sed -i -E 's#(TG_TOKEN=")[0-9]{6,}:[A-Za-z0-9_-]+(")#\1\2#; s#(TG_CHAT=")[0-9]{5,}(")#\1\2#' "$S/cv-gen/claude-auth-watchdog.sh" 2>/dev/null || true
grep -rlIE 'sk-or-v1-[A-Za-z0-9]{20}|sk-ant-[A-Za-z0-9]{20}|[0-9]{8,10}:[A-Za-z0-9_-]{35}|AKIA[0-9A-Z]{16}|ghp_[A-Za-z0-9]{30}|AIza[A-Za-z0-9_-]{20}' "$S" 2>/dev/null | while read -r f; do
  sed -i -E 's/sk-or-v1-[A-Za-z0-9]{20,}/REDACTED/g; s/sk-ant-[A-Za-z0-9-]{20,}/REDACTED/g; s/[0-9]{8,10}:[A-Za-z0-9_-]{35,}/REDACTED/g; s/AKIA[0-9A-Z]{16}/REDACTED/g; s/ghp_[A-Za-z0-9]{30,}/REDACTED/g; s/AIza[A-Za-z0-9_-]{20,}/REDACTED/g' "$f"
done

# 6) FINAL GATE — refuse to emit if any secret pattern survives
if grep -rIE 'sk-or-v1-[A-Za-z0-9]{20}|sk-ant-[A-Za-z0-9]{20}|[0-9]{8,10}:[A-Za-z0-9_-]{35}|AKIA[0-9A-Z]{16}|ghp_[A-Za-z0-9]{30}|AIza[A-Za-z0-9_-]{20}' "$S" >/dev/null 2>&1; then
  echo "SNAPSHOT_ABORT: secret still present after redaction — refusing to emit"; exit 3
fi

tar -czf "$OUT" -C "$S" .
sha256sum "$OUT" | awk '{print $1}' > "$OUT.sha256"
echo "SNAPSHOT_OK $OUT size=$(du -h "$OUT"|cut -f1) files=$(find "$S" -type f|wc -l) sha256=$(cat "$OUT.sha256")"
rm -rf "$S"
