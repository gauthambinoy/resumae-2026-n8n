# TOP RESUMAE 2026 — Disaster-Recovery Runbook

This private repo is the **complete, secret-free backup of the Resumae CV-generation system** (the n8n workflow + the `cv-gen` engine that the Claude CLI runs on the host). If the AWS box ("cobra") is lost, you can rebuild the whole system on any Ubuntu machine from this repo **plus your secrets** (kept separately — see below).

> The repo intentionally contains **no secrets**. Code, prompts, schemas, the workflow, and the source-of-truth data are here; keys are not. Restoring needs both.

---

## What's in here

```
cv-gen/                     The CV-generation "brain" (runs on the host, called by Claude CLI)
  prompts/                    master_single_shot.md (the ~123KB master prompt) + _fast variant
  modes/                      6 mode profiles (professional, graduate, research, retail, healthcare, hospitality)
  schemas/                    per-mode JSON schemas
  run-ss-claude.sh            the single-shot runner (Claude CLI) — the main engine
  validate_cv.py              the hard-gate CV validator
  sheet_to_json.py            Google Sheet (source-of-truth) -> source_of_truth.json
  select_relevant.py          picks JD-relevant experiences/projects
  github_corpus_v3.py         syncs GitHub repos -> Projects tab
  llm_free.py                 free-model fallback chain
  source_of_truth.json        the generated profile data (experiences / education / projects)
n8n/
  docker-compose.yml          the n8n + postgres + autoheal stack
  Dockerfile, sql/            custom image + DB schema
  workflows_all.json          ALL n8n workflows exported as JSON (incl. TOP RESUMAE 2026, id S5UYbSbCFhMFpCWc)
  .env.example                environment template — fill with real values on restore
```

## What is NOT here (you must supply on restore) — your SECRETS

Keep these in your password manager / secure store. They are the ONLY things this repo can't hold:

| Secret | Restore location on the new box |
|---|---|
| Google Sheets OAuth (client_id, client_secret, refresh_token) | `~/cv-gen/.gsheets.json` |
| GitHub PAT (repo-corpus sync) | `~/cv-gen/credentials/github.token` |
| OpenRouter API key | `~/cv-gen/credentials/openrouter.key` |
| Claude CLI login (`claude /login`) | interactive — run `claude` then `/login` |
| n8n `.env` (Postgres pw, OpenRouter, Telegram, API keys, N8N_API_KEY) | `~/n8n/.env` (from `.env.example`) |
| n8n credentials (Google Docs/Drive/Sheets, Gmail SMTP, Telegram, Postgres) | re-enter in n8n UI, OR restore the Postgres dump (see below) |

---

## Restore procedure (fresh Ubuntu box)

1. **Install Docker + Docker Compose + git.**
2. **Clone this repo:** `git clone <this-repo-url> ~/resumae && cd ~/resumae`
3. **Restore cv-gen:** `cp -a cv-gen ~/cv-gen`
4. **Drop in the cv-gen secrets** from your store (the 3 files in the table above), then `claude` -> `/login`.
5. **Restore n8n:** `cp -a n8n ~/n8n && cd ~/n8n && cp .env.example .env` — fill `.env` with real values.
6. **Bring up n8n:** `docker compose up -d` (starts n8n + postgres + autoheal).
7. **Import the workflows:** `docker cp workflows_all.json n8n:/tmp/ && docker exec n8n n8n import:workflow --input=/tmp/workflows_all.json`
   - ⚠️ import DEACTIVATES workflows. Re-activate: `docker exec n8n n8n update:workflow --id=S5UYbSbCFhMFpCWc --active=true` then `docker restart n8n`.
8. **Re-enter n8n credentials** in the UI (Google Docs/Drive/Sheets OAuth, Gmail SMTP, Telegram, Postgres), OR restore a Postgres dump if you have one (`docker exec -i postgres psql -U <user> <db> < n8n_pg.sql`).
9. **Re-issue the n8n public API key** (Settings -> API) and set it as `N8N_API_KEY` in `.env` (the Error-Format node uses it).
10. **Verify:** open the Form URL, submit one test JD, confirm a CV PDF/DOCX is emailed.

## Notes

- The CV template Google Docs live on the user's personal Google account (bot creds are sheets-scope-only) — doc IDs are inside `workflows_all.json` config nodes.
- The job-radar is intentionally PAUSED (it fabricated JDs). Primary input is the manual Form.
- This repo is refreshed by the daily backup (see the repo's daily-sync setup) — treat `main` as the latest good snapshot.
