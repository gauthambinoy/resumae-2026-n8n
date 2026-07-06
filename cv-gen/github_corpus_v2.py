#!/usr/bin/env python3
# github_corpus_v2.py — deep repo analysis via gpt-oss-120b:free -> RICH Projects schema.
import json,os,sys,urllib.request,urllib.parse,time
CRED=os.path.expanduser("~/cv-gen/credentials")
GH=open(os.path.join(CRED,"github.token")).read().strip()
OR=open(os.path.join(CRED,"openrouter.key")).read().strip()
GCREDS=os.path.expanduser("~/cv-gen/.gsheets.json")
SHEET="1ZrGAVXISvMliotzx3WLMDxM5NUIkBcE8u6tC7CCcNx4"
def gh(path):
    return json.loads(urllib.request.urlopen(urllib.request.Request("https://api.github.com"+path,headers={"Authorization":"Bearer "+GH,"Accept":"application/vnd.github+json","User-Agent":"cv"}),timeout=30).read())
def raw(url):
    try: return urllib.request.urlopen(urllib.request.Request(url,headers={"Authorization":"Bearer "+GH,"User-Agent":"cv"}),timeout=30).read().decode("utf-8","ignore")
    except Exception: return ""
def llm(repo,desc,langs,topics,readme):
    prompt=("You analyse a GitHub repo into a rich, HONEST resume project card. Use the README + metadata. "
      "Output ONLY minified JSON with EXACTLY these keys: "
      '{"type":"","core_idea":"","problem":"","stack":[],"key_features":[],"what_it_does":"","how_it_does":"","outcome":""}. '
      "type = short category (AI/LLM app, ML, full-stack web, data, cloud/devops, game, tool, etc). "
      "core_idea = one crisp sentence. problem = the real problem it solves. stack = real tools/langs actually used. "
      "key_features = 3-5 concrete features. what_it_does = 2-3 concrete honest sentences. how_it_does = 2-3 sentences on the technical approach/architecture. "
      "outcome = a real modest result or current state; empty string if unknown. No hype, no invented metrics.\n"
      "REPO: %s\nDESC: %s\nLANGS: %s\nTOPICS: %s\nREADME (first 5000):\n%s"%(repo,desc,",".join(langs),",".join(topics),readme[:5000]))
    body=json.dumps({"model":"openai/gpt-oss-120b:free","messages":[{"role":"user","content":prompt}],"temperature":0.2}).encode()
    for attempt in range(3):
        try:
            r=json.loads(urllib.request.urlopen(urllib.request.Request("https://openrouter.ai/api/v1/chat/completions",data=body,headers={"Authorization":"Bearer "+OR,"Content-Type":"application/json"}),timeout=90).read())
            txt=r["choices"][0]["message"]["content"].strip().strip("`")
            if txt.lower().startswith("json"): txt=txt[4:]
            i=txt.find("{"); j=txt.rfind("}")
            return json.loads(txt[i:j+1])
        except Exception as e:
            wait=[10,30,75][attempt] if attempt<3 else 75
            sys.stderr.write("llm retry %d %s: %s (wait %ds)\n"%(attempt,repo,e,wait)); time.sleep(wait)
    return {}
# google token + sheet write
def gtok():
    c=json.load(open(GCREDS)); b=urllib.parse.urlencode({"client_id":c["client_id"],"client_secret":c["client_secret"],"refresh_token":c["refresh_token"],"grant_type":"refresh_token"}).encode()
    return json.loads(urllib.request.urlopen("https://oauth2.googleapis.com/token",b,timeout=20).read())["access_token"]
T=gtok()
def clear(rng): urllib.request.urlopen(urllib.request.Request("https://sheets.googleapis.com/v4/spreadsheets/%s/values/%s:clear"%(SHEET,urllib.parse.quote(rng)),data=b"{}",method="POST",headers={"Authorization":"Bearer "+T,"Content-Type":"application/json"}),timeout=30).read()
def put(rng,rows): urllib.request.urlopen(urllib.request.Request("https://sheets.googleapis.com/v4/spreadsheets/%s/values/%s?valueInputOption=RAW"%(SHEET,urllib.parse.quote(rng)),data=json.dumps({"values":rows}).encode(),method="PUT",headers={"Authorization":"Bearer "+T,"Content-Type":"application/json"}),timeout=40).read()
me=gh("/user")["login"]
repos=gh("/user/repos?per_page=100&sort=updated&affiliation=owner")
rows=[]
for repo in repos:
    if repo.get("fork"): continue
    nm=repo["name"]
    langs=list(gh("/repos/%s/%s/languages"%(me,nm)).keys()) if True else []
    topics=repo.get("topics",[]) or []
    readme=raw("https://raw.githubusercontent.com/%s/%s/%s/README.md"%(me,nm,repo.get("default_branch","main")))
    card=llm(nm,repo.get("description") or "",langs,topics,readme)
    rows.append([nm, card.get("type",""), card.get("core_idea",""), card.get("problem",""),
                 ", ".join(card.get("stack",[]) or langs), " | ".join(card.get("key_features",[]) or []),
                 card.get("what_it_does",""), card.get("how_it_does",""), card.get("outcome",""), repo.get("html_url","")])
    print("  analysed:",nm,"->",card.get("type",""),flush=True)
    time.sleep(7)  # stay under gpt-oss-120b:free per-minute rate limit
clear("Projects!A2:Z200")
if rows: put("Projects!A2",rows)
print("DONE: wrote %d rich project cards"%len(rows),flush=True)
