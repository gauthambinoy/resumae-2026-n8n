#!/usr/bin/env python3
# github_corpus.py — SCAFFOLD (inert until token added).
# When ~/cv-gen/credentials/github.token exists: reads your repos, summarizes each
# into a project card via gpt-oss-120b (free), and appends new cards to the
# "Projects" tab of the Source-of-Truth Sheet (dedup by repo name).
# Intended to run on a daily cron once you've added your token. Wired into nothing yet.
import json, os, sys, urllib.request, urllib.parse
CRED = os.path.expanduser("~/cv-gen/credentials")
GH_TOKEN = os.path.join(CRED, "github.token")
OR_KEY   = os.path.join(CRED, "openrouter.key")   # openai/gpt-oss-120b:free
GCREDS   = os.path.expanduser("~/cv-gen/.gsheets.json")
SHEET    = "1ZrGAVXISvMliotzx3WLMDxM5NUIkBcE8u6tC7CCcNx4"

def read(p):
    try: return open(p).read().strip()
    except Exception: return ""

def gh(path, tok):
    req = urllib.request.Request("https://api.github.com" + path,
        headers={"Authorization": "Bearer " + tok, "Accept": "application/vnd.github+json",
                 "User-Agent": "cv-gen-corpus"})
    return json.loads(urllib.request.urlopen(req, timeout=30).read())

def gh_raw(url, tok):
    try:
        req = urllib.request.Request(url, headers={"Authorization": "Bearer " + tok, "User-Agent": "cv-gen-corpus"})
        return urllib.request.urlopen(req, timeout=30).read().decode("utf-8", "ignore")
    except Exception:
        return ""

def summarize_llm(repo, readme, langs, orkey):
    if not orkey:
        # no LLM key -> basic card from metadata only
        return {"domains": [], "stack": list(langs.keys())[:8],
                "what": (repo.get("description") or repo.get("name") or "")[:200], "outcome": ""}
    prompt = ("You turn a GitHub repo into a resume project card. Output ONLY minified JSON: "
              '{"domains":[..2-4 like AI/LLM,data,backend,frontend,cloud..],"stack":[..real tools..],'
              '"what":"one honest sentence of what it does","outcome":"a real, modest result if any, else empty"}. '
              "No hype, no invented metrics.\nREPO: " + (repo.get("name") or "") +
              "\nDESC: " + (repo.get("description") or "") + "\nLANGS: " + ",".join(langs.keys()) +
              "\nREADME(first 1500):\n" + readme[:1500])
    body = json.dumps({"model": "openai/gpt-oss-120b:free",
                       "messages": [{"role": "user", "content": prompt}], "temperature": 0.2}).encode()
    req = urllib.request.Request("https://openrouter.ai/api/v1/chat/completions", data=body,
        headers={"Authorization": "Bearer " + orkey, "Content-Type": "application/json"})
    try:
        r = json.loads(urllib.request.urlopen(req, timeout=60).read())
        txt = r["choices"][0]["message"]["content"].strip().strip("`")
        if txt.startswith("json"): txt = txt[4:]
        return json.loads(txt)
    except Exception as e:
        sys.stderr.write("LLM fail for %s: %s\n" % (repo.get("name"), e))
        return {"domains": [], "stack": list(langs.keys())[:8], "what": (repo.get("description") or "")[:200], "outcome": ""}

def gtoken():
    c = json.load(open(GCREDS))
    b = urllib.parse.urlencode({"client_id": c["client_id"], "client_secret": c["client_secret"],
                                "refresh_token": c["refresh_token"], "grant_type": "refresh_token"}).encode()
    return json.loads(urllib.request.urlopen("https://oauth2.googleapis.com/token", b, timeout=20).read())["access_token"]

def sheet_get(rng, T):
    u = "https://sheets.googleapis.com/v4/spreadsheets/%s/values/%s" % (SHEET, urllib.parse.quote(rng))
    return json.loads(urllib.request.urlopen(urllib.request.Request(u, headers={"Authorization": "Bearer " + T}), timeout=30).read()).get("values", [])

def sheet_append(rows, T):
    u = "https://sheets.googleapis.com/v4/spreadsheets/%s/values/Projects!A1:append?valueInputOption=RAW&insertDataOption=INSERT_ROWS" % SHEET
    urllib.request.urlopen(urllib.request.Request(u, data=json.dumps({"values": rows}).encode(), method="POST",
        headers={"Authorization": "Bearer " + T, "Content-Type": "application/json"}), timeout=40).read()

def main():
    tok = read(GH_TOKEN)
    if not tok:
        print("github_corpus: no token at %s — inert, nothing to do." % GH_TOKEN); return
    orkey = read(OR_KEY)
    me = gh("/user", tok)["login"]
    print("github user:", me)
    repos = gh("/user/repos?per_page=100&sort=updated&affiliation=owner", tok)
    T = gtoken()
    existing = set()
    for r in sheet_get("Projects!A2:A500", T):
        if r: existing.add(r[0].strip().lower())
    new_rows = []
    for repo in repos:
        if repo.get("fork"): continue
        name = repo.get("name", "")
        if name.lower() in existing: continue
        langs = {}
        try: langs = gh("/repos/%s/%s/languages" % (me, name), tok)
        except Exception: pass
        readme = gh_raw("https://raw.githubusercontent.com/%s/%s/%s/README.md" % (me, name, repo.get("default_branch", "main")), tok)
        card = summarize_llm(repo, readme, langs, orkey)
        new_rows.append([name, "Personal/GitHub", ", ".join(card.get("domains", [])),
                         ", ".join(card.get("stack", [])), card.get("what", ""),
                         card.get("outcome", ""), repo.get("html_url", "")])
        print("  card:", name)
    if new_rows:
        sheet_append(new_rows, T)
        print("appended %d new project cards to the Projects tab" % len(new_rows))
    else:
        print("no new repos to add")

if __name__ == "__main__":
    main()
