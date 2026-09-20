# TOP RESUMAE 2026 — Disaster-Recovery Runbook

This private repo is the **complete, secret-free backup of the Resumae CV-generation system** (the n8n workflow + the `cv-gen` engine that the Claude CLI runs on the host). If the AWS box is lost, you can rebuild the whole system on any Ubuntu machine from this repo **plus your secrets** (kept separately — see below).

> The repo intentionally contains **no secrets**. Code, prompts, schemas, the workflow, and the source-of-truth data are here; keys are not. Restoring needs both.

> ⚠️ **Read this first — five things live only on the old box and are NOT in this repo.** Following the old runbook blindly will fail. Each is handled explicitly in the steps below:
> 1. The **custom Docker image** `local/n8n-python:2.16.1` — on no registry; **build it** (Step 3).
> 2. The **external Docker volume** `n8n_n8n_data` — holds n8n's workflows + credentials as SQLite; **create or restore it** (Step 4).
> 3. The **patched `node-types.js`** — bind-mounted into n8n by `docker-compose.yml`; recreate or drop the mount (Step 5).
> 4. The **Caddy config** (the HTTPS front door) — reproduced here as [`n8n/Caddyfile.example`](n8n/Caddyfile.example) (Step 9).
> 5. Your **secrets** — see the table below.

---

## Two ways to restore — pick one

- **Path A — Full restore from the essential backup tarball (recommended, keeps everything).** If you have a recent `n8n-essential-*.tar.gz` (the daily pull, e.g. `C:\Users\gauth\n8n-backup\n8n-latest.tar.gz`), it contains n8n's SQLite DB — i.e. the workflows **and** the encrypted credentials. Restoring it means you do **not** have to re-import workflows or re-enter n8n credentials.
- **Path B — Clean rebuild from `workflows_all.json`.** Start from an empty n8n, import the workflows from this repo, and re-enter every n8n credential by hand.

Both paths share Steps 1–5 and 8–10; Step 6 (Path A) and Step 7 (Path B) differ.

---

## Clarifying the data stores (this trips people up)

- **n8n's own data — workflows + credentials — is SQLite**, inside the Docker volume `n8n_n8n_data` at `/home/node/.n8n/database.sqlite`. This is what you back up and restore to keep credentials.
- **Postgres ("jobhunter") is a *separate* application database** — the job-queue for the (paused) Job Radar. It is seeded from `n8n/sql/`. It does **not** hold n8n credentials.

---

## What is NOT here (you must supply on restore) — your SECRETS

Keep these in your password manager / secure store. They are the only things this repo can't hold:

| Secret | Restore location on the new box |
|---|---|
| Google Sheets OAuth (client_id, client_secret, refresh_token) | `~/cv-gen/.gsheets.json` |
| GitHub PAT (repo-corpus sync) | `~/cv-gen/credentials/github.token` |
| OpenRouter API key | `~/cv-gen/credentials/openrouter.key` |
| Claude CLI login (`claude /login`) | interactive — run `claude` then `/login` |
| n8n `.env` (Postgres pw, OpenRouter, Telegram, API keys, N8N_API_KEY) | `~/n8n/.env` (from `.env.example`) |
| n8n credentials (Google Docs/Drive/Sheets, Gmail SMTP, Telegram, Postgres) | Path A restores these automatically; Path B = re-enter in the n8n UI |

---

## Restore procedure (fresh Ubuntu box)

1. **Install prerequisites:** Docker + Docker Compose plugin, `git`, and (for the front door) `caddy`.
2. **Clone this repo:** `git clone <this-repo-url> ~/resumae && cd ~/resumae`
3. **Build the custom n8n image** (n8n + Python bundled — it is **not** on any registry, so `docker compose up` will fail without this):
   ```bash
   docker build -t local/n8n-python:2.16.1 n8n/
   ```
4. **Create the external n8n data volume** (docker-compose declares it `external`, so compose will NOT create it for you):
   ```bash
   docker volume create n8n_n8n_data
   ```
   *(Path A will overwrite its contents in Step 6.)*
5. **Handle the `node-types.js` bind-mount.** `docker-compose.yml` mounts `/home/ubuntu/node-types.js` into the n8n container read-only. That patched file is **not** in this repo. Either:
   - restore it from a box backup to `/home/ubuntu/node-types.js`, **or**
   - if you don't have it and don't need the patch, **remove that one volume line** from `docker-compose.yml` before starting (stock n8n works without it).
6. **Restore cv-gen + drop in secrets:**
   ```bash
   cp -a cv-gen ~/cv-gen
   # copy the 3 secret files from your store into ~/cv-gen/ (.gsheets.json)
   # and ~/cv-gen/credentials/ (github.token, openrouter.key), then:
   claude        # → /login   (interactive Claude CLI auth)
   ```
7. **Set up n8n config:**
   ```bash
   cp -a n8n ~/n8n && cd ~/n8n
   cp .env.example .env          # fill EVERY value from your secret store
   ```

   **— Path A (full restore):** stop any running n8n, then unpack the essential tarball into the volume so the workflows + credentials come back intact:
   ```bash
   # example — adjust the tar layout to your backup:
   docker run --rm -v n8n_n8n_data:/data -v "$PWD":/backup alpine \
     sh -c "cd /data && tar xzf /backup/n8n-latest.tar.gz"
   docker compose up -d          # n8n + postgres + autoheal
   ```
   Skip Step 8 (workflows are already present and active).

   **— Path B (clean rebuild):**
   ```bash
   docker compose up -d
   ```

8. **(Path B only) Import the workflows:**
   ```bash
   docker cp workflows_all.json n8n:/tmp/
   docker exec n8n n8n import:workflow --input=/tmp/workflows_all.json
   # ⚠️ import DEACTIVATES workflows. Re-activate the main one, THEN restart:
   docker exec n8n n8n update:workflow --id=S5UYbSbCFhMFpCWc --active=true
   docker restart n8n
   ```
   Then re-enter n8n credentials in the UI (Google Docs/Drive/Sheets OAuth, Gmail SMTP, Telegram, Postgres).

9. **Put the HTTPS front door up.** n8n only listens on `127.0.0.1:5678`, so it is unreachable until Caddy proxies to it:
   ```bash
   sudo cp n8n/Caddyfile.example /etc/caddy/Caddyfile
   sudo nano /etc/caddy/Caddyfile        # set your domain / nip.io host + IP
   sudo systemctl reload caddy           # Caddy auto-provisions Let's Encrypt TLS
   ```
   If you use a new IP/hostname, also update `N8N_HOST`, `WEBHOOK_URL` and `N8N_EDITOR_BASE_URL` in `docker-compose.yml` (or via `.env`) and `docker restart n8n`.
10. **Re-issue the n8n public API key** (n8n UI → Settings → API) and set it as `N8N_API_KEY` in `.env` — the `Error · Format` node calls the executions API with it.
11. **Verify:** open the Form URL in a **browser** (a bare `curl` returns 401 — that's normal, the form checks the UA), submit one test JD, and confirm a CV PDF + DOCX is emailed.

## Notes

- The CV template Google Docs live on the user's personal Google account (bot creds are Sheets-scope-only) — the doc IDs are inside `workflows_all.json` config nodes.
- The Job Radar is intentionally **paused** (it used to fabricate JDs). Primary input is the manual Form.
- Treat `main` as the latest good snapshot. The git snapshots run to 2026-07-20; the essential tarball to 2026-08-02.
