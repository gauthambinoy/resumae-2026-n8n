# daily-git-refresh.ps1 — refreshes the private backup repo from the cobra box.
# Pulls a clean, redacted, secret-scanned snapshot, then commits + pushes IF changed.
# Has its own pre-push secret gate (defense in depth). Push token stays in Windows Cred Mgr.
$ErrorActionPreference = 'Stop'
$repo   = 'C:\Users\gauth\top-resumae-2026-n8n'
$log    = Join-Path $repo 'daily-git-refresh.log'
$systar = Join-Path $env:SystemRoot 'System32\tar.exe'   # Windows bsdtar handles C:\ paths
$rx     = 'sk-or-v1-[A-Za-z0-9]{20}|sk-ant-[A-Za-z0-9]{20}|[0-9]{8,10}:[A-Za-z0-9_-]{35}|AKIA[0-9A-Z]{16}|ghp_[A-Za-z0-9]{30}|AIza[A-Za-z0-9_-]{20}'
function Log($m){ $line = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  $m"; Add-Content -LiteralPath $log -Value $line -Encoding UTF8; Write-Output $line }

try {
  Log '=== refresh start ==='
  # 1) build the clean snapshot on the box (redacts + secret-gates; refuses to emit if a secret survives)
  $snap = (ssh cobra-n8n 'bash ~/make-resumae-git-snapshot.sh' 2>&1 | Out-String).Trim()
  Log "box: $snap"
  if ($snap -notmatch 'SNAPSHOT_OK') { Log 'ABORT: box snapshot did not report OK'; exit 1 }

  # 2) pull it
  $tar = Join-Path $env:TEMP 'resumae-git-snapshot.tar.gz'
  if (Test-Path $tar) { Remove-Item $tar -Force }
  & scp cobra-n8n:/tmp/resumae-git-snapshot.tar.gz $tar 2>&1 | Out-Null
  if (-not (Test-Path $tar)) { Log 'ABORT: scp failed'; exit 1 }

  # 3) extract over the working tree (Windows tar.exe; no destructive pre-delete)
  & $systar -xzf $tar -C $repo
  if ($LASTEXITCODE -ne 0) { Log 'ABORT: tar extract failed'; git -C $repo reset --hard HEAD 2>&1 | Out-Null; exit 1 }

  Set-Location $repo
  git add -A 2>&1 | Out-Null

  # 4) PRE-PUSH SECRET GATE (defense in depth)
  $scan = git grep -nIE $rx -- . 2>$null
  if ($scan) { Log ("ABORT: secret detected pre-push: " + ($scan -join '; ')); git reset --hard HEAD 2>&1 | Out-Null; exit 2 }

  # 5) commit + push only if something changed
  $status = git status --porcelain
  if ([string]::IsNullOrWhiteSpace($status)) { Log 'no changes — nothing to push'; Log '=== done ==='; exit 0 }
  $stamp = Get-Date -Format 'yyyy-MM-dd'
  git -c commit.gpgsign=false commit -q -m "daily snapshot $stamp" 2>&1 | Out-Null
  git push -q origin main 2>&1 | Out-Null
  if ($LASTEXITCODE -ne 0) { Log 'ERROR: git push failed'; exit 3 }
  Log "pushed daily snapshot $stamp"
  Log '=== done ==='
} catch {
  Log ("ERROR: " + $_.Exception.Message)
  exit 9
}
