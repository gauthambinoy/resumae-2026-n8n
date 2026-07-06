#!/usr/bin/env python3
# github_corpus_v3.py — RICH project cards. Heuristic base (README + description + langs),
# OPTIONALLY upgraded per-card via a chain of FREE OpenRouter models (see llm_free.free_chat).
import json,os,re,sys,urllib.request,urllib.parse
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))  # allow `from llm_free import ...`
try:
    from llm_free import free_chat   # free-model chain w/ 429 fallback; None on total failure
except Exception:
    def free_chat(*a, **k): return None  # if helper missing, silently keep pure heuristic
CRED=os.path.expanduser("~/cv-gen/credentials")
GH=open(os.path.join(CRED,"github.token")).read().strip()
GCREDS=os.path.expanduser("~/cv-gen/.gsheets.json")
SHEET="1ZrGAVXISvMliotzx3WLMDxM5NUIkBcE8u6tC7CCcNx4"
def gh(p): return json.loads(urllib.request.urlopen(urllib.request.Request("https://api.github.com"+p,headers={"Authorization":"Bearer "+GH,"Accept":"application/vnd.github+json","User-Agent":"cv"}),timeout=30).read())
def raw(u):
    try: return urllib.request.urlopen(urllib.request.Request(u,headers={"Authorization":"Bearer "+GH,"User-Agent":"cv"}),timeout=30).read().decode("utf-8","ignore")
    except Exception: return ""
FRAMEWORKS=["FastAPI","LangChain","LlamaIndex","OpenAI","Anthropic","pgvector","Pinecone","FAISS","ChromaDB","Weaviate","Redis","PostgreSQL","MongoDB","Kafka","Snowflake","Airflow","Spark","PyTorch","TensorFlow","scikit-learn","Hugging Face","Transformers","spaCy","NLTK","React","Next.js","Vue","Node.js","Express","Django","Flask","Tailwind","Three.js","Docker","Kubernetes","Terraform","AWS","GCP","Azure","Celery","Streamlit","Gradio","SQLite","DuckDB","Playwright","Selenium"]
def detect(text):
    low=text.lower(); return [f for f in FRAMEWORKS if f.lower() in low]
def infer_type(langs,text):
    t=(text or "").lower()
    if any(k in t for k in ["langchain","llm","rag","agent","openai","anthropic","retrieval","embedding","gpt","prompt"]): return "AI / LLM app"
    if any(k in t for k in ["pandas","jupyter","dataset","sentiment","forecast","machine learning","ml ","classifier","prediction"]) or "Jupyter Notebook" in langs: return "ML / Data"
    if any(k in t for k in ["three.js","game","fps","canvas"]): return "Game / interactive"
    if any(k in t for k in ["terraform","kubernetes","cloud","infra","devops"]): return "Cloud / DevOps"
    if any(l in langs for l in ["TypeScript","JavaScript"]) and any(k in t for k in ["react","next","frontend","dashboard","ui","web app"]): return "Full-stack web"
    if "Python" in langs: return "Backend / tool"
    return "Software project"
def features(readme):
    feats=[]
    for line in readme.splitlines():
        m=re.match(r"^\s*[-*•]\s+(.{6,90})",line)
        if m:
            f=re.sub(r"[`*_#]","",m.group(1)).strip()
            if f and not f.lower().startswith(("http","license","clone","git ","npm ","pip ")): feats.append(f)
        if len(feats)>=5: break
    return feats
def summary(readme,desc):
    for para in re.split(r"\n\s*\n",readme):
        p=re.sub(r"[#>`*_]"," ",para).strip()
        p=re.sub(r"\s+"," ",p)
        if len(p)>40 and not p.lower().startswith(("http","!","|","-")) and "badge" not in p.lower(): return p[:400]
    return desc
def enrich(nm,desc,langs,readme,fallback):
    # OPTIONAL free-LLM upgrade of the "what it does" / "core idea" text.
    # Returns a crisp 1-2 sentence description, or the heuristic `fallback` on any failure.
    try:
        sysp=("You write concise, factual project descriptions for a CV. Reply with 1-2 plain "
              "sentences stating what the project does and its core idea. No markdown, no first "
              "person, no marketing fluff.")
        usrp=("Project name: %s\nLanguages: %s\nGitHub description: %s\nREADME (truncated):\n%s"
              %(nm, ", ".join(langs) or "unknown", desc or "(none)", (readme or "")[:2500]))
        out=(free_chat(usrp,system=sysp,max_tokens=160,temperature=0.3,timeout=45) or "").strip()
        return out if out else fallback
    except Exception:
        return fallback
def gtok():
    c=json.load(open(GCREDS)); b=urllib.parse.urlencode({"client_id":c["client_id"],"client_secret":c["client_secret"],"refresh_token":c["refresh_token"],"grant_type":"refresh_token"}).encode()
    return json.loads(urllib.request.urlopen("https://oauth2.googleapis.com/token",b,timeout=20).read())["access_token"]
T=gtok()
def clear(r): urllib.request.urlopen(urllib.request.Request("https://sheets.googleapis.com/v4/spreadsheets/%s/values/%s:clear"%(SHEET,urllib.parse.quote(r)),data=b"{}",method="POST",headers={"Authorization":"Bearer "+T,"Content-Type":"application/json"}),timeout=30).read()
def sget(r): return json.loads(urllib.request.urlopen(urllib.request.Request("https://sheets.googleapis.com/v4/spreadsheets/%s/values/%s"%(SHEET,urllib.parse.quote(r)),headers={"Authorization":"Bearer "+T}),timeout=30).read()).get("values",[])
def sappend(rows): urllib.request.urlopen(urllib.request.Request("https://sheets.googleapis.com/v4/spreadsheets/%s/values/Projects!A1:append?valueInputOption=RAW&insertDataOption=INSERT_ROWS"%SHEET,data=json.dumps({"values":rows}).encode(),method="POST",headers={"Authorization":"Bearer "+T,"Content-Type":"application/json"}),timeout=40).read()
me=gh("/user")["login"]; rows=[]
existing=set(r[0].strip().lower() for r in sget("Projects!J2:J300") if r)  # ADDITIVE dedup by GitHub URL (col J) — Name col now holds display titles
for repo in gh("/user/repos?per_page=100&sort=updated&affiliation=owner"):
    if repo.get("fork"): continue
    nm=repo["name"]; desc=repo.get("description") or ""
    if (repo.get("html_url","") or "").strip().lower() in existing: continue  # already in sheet -> leave as-is
    langs=list(gh("/repos/%s/%s/languages"%(me,nm)).keys())
    readme=raw("https://raw.githubusercontent.com/%s/%s/%s/README.md"%(me,nm,repo.get("default_branch","main")))
    blob=desc+" "+readme[:3000]
    stack=list(dict.fromkeys(detect(blob)+langs))[:12]
    heur=summary(readme,desc)                       # existing heuristic "core idea"
    core=enrich(nm,desc,langs,readme,heur)          # free-LLM upgrade; falls back to `heur`
    short=desc or (core[:120] if core else "")      # never leave "what it does" worse than the heuristic
    rows.append([nm, infer_type(langs,blob), short, "",
                 ", ".join(stack), " | ".join(features(readme)), core, "", "", repo.get("html_url","")])
    print("  card:",nm,"->",rows[-1][1],"(llm)" if core!=heur else "(heuristic)")
sappend(rows)   # ADDITIVE: append only the new (deduped) cards; never wipe existing/manual rows
print("DONE:",len(rows),"cards appended (LLM-enriched where a free model responded)")
