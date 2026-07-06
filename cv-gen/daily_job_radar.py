#!/usr/bin/env python3
# Daily Job Radar — sources fresh junior/mid roles (LinkedIn guest search), dedupes ("never twice"),
# filters, cap-aware, assigns tier + cap-window RUN AT, appends to the n8n CV queue sheet.
# Cron: 0 5 * * *  (05:00 UTC = 06:00 Dublin).  DRY_RUN=1 env -> source+plan only, no writes.
import json, os, re, sys, time, urllib.request, urllib.parse, html
from datetime import datetime, timezone

BASE = "/home/ubuntu/cv-gen"
SHEET = "1aaBiwgS_zw3IZ0gkKKbLJpo_98bkzIPVx7vgbv-fxjM"
SEEN_FILE = BASE + "/seen_jobs.json"
GCREDS = BASE + "/.gsheets.json"
LOG = BASE + "/job-radar.log"
DRY = os.environ.get("DRY_RUN") == "1"
DAILY_TARGET = 20
MAX_PENDING = 30          # don't pile on if the queue already has this many pending
UA = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"

# keyword -> role_type (for JD building + skills)
KEYWORDS = [
 ("graduate software engineer","software"),("data analyst","data_analyst"),
 ("junior data scientist","ml_ai"),("data engineer","data_engineer"),
 ("python developer","software"),("machine learning engineer","ml_ai"),
 ("ai engineer","ml_ai"),("cloud engineer","devops"),("mlops engineer","devops"),
]
LOCATIONS = [("Dublin, Ireland","Ireland"),("Dubai, United Arab Emirates","Dubai, UAE")]
EXCLUDE = re.compile(r"\b(senior|sr\.?|lead|principal|staff|director|head|vice\s*president|vp|chief|manager|architect|iii|iv|emirati|uae national)\b", re.I)
INCLUDE = re.compile(r"data|software|python|engineer|analyst|developer|scientist|machine learning|\bml\b|\bai\b|cloud|devops|mlops|sre|backend|full ?stack|bi\b|analytics", re.I)

RESP = {
 "software":"You will design, build, test, and ship software features, collaborate with cross-functional teams, write clean maintainable code, and contribute to architecture and code reviews.",
 "data_analyst":"You will analyze data, build dashboards and reports, write SQL queries, validate data quality, and deliver actionable insights to stakeholders.",
 "data_engineer":"You will design and build data pipelines and platforms, model data, implement ETL and ELT, and ensure data quality and reliability.",
 "ml_ai":"You will build, train, and deploy machine learning and AI models, develop data pipelines, integrate large language models, and move models from prototype to production.",
 "devops":"You will build and maintain CI/CD pipelines, infrastructure as code, cloud deployments, observability, and automate operational tasks.",
}
SKILLS = {
 "software":"Python, Java, REST APIs, SQL, algorithms, cloud, Git",
 "data_analyst":"SQL, Python, Power BI, Tableau, Excel, data visualization",
 "data_engineer":"Python, SQL, Kafka, ETL, Spark, cloud, data pipelines",
 "ml_ai":"Python, machine learning, PyTorch, TensorFlow, LLMs, SQL, MLOps",
 "devops":"AWS, Azure, GCP, Kubernetes, Docker, Terraform, CI/CD, Linux",
}

def log(msg):
    line = "%s  %s" % (datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"), msg)
    print(line)
    if not DRY:
        try: open(LOG,"a").write(line+"\n")
        except Exception: pass

def fetch(keyword, location):
    url = "https://www.linkedin.com/jobs-guest/jobs/api/seeMoreJobPostings/search?" + urllib.parse.urlencode(
        {"keywords":keyword,"location":location,"f_E":"2","f_TPR":"r86400","start":"0"})
    try:
        req=urllib.request.Request(url, headers={"User-Agent":UA})
        return urllib.request.urlopen(req, timeout=25).read().decode("utf-8","ignore")
    except Exception as e:
        log("fetch FAIL %s/%s: %s" % (keyword, location, str(e)[:80])); return ""

def parse(htmltext, rtype, loclabel):
    out=[]
    for card in re.split(r"<li[ >]", htmltext)[1:]:
        m=re.search(r"jobPosting:(\d+)", card) or re.search(r"/jobs/view/[^\"?]*-(\d+)", card)
        if not m: continue
        jid=m.group(1)
        t=re.search(r'base-search-card__title"[^>]*>\s*(.+?)\s*<', card, re.S)
        co=re.search(r'base-search-card__subtitle"[^>]*>(?:\s*<a[^>]*>)?\s*(.+?)\s*<', card, re.S)
        u=re.search(r'(https://[a-z]{2,3}\.linkedin\.com/jobs/view/[^\"?]+)', card)
        title=html.unescape(re.sub(r"\s+"," ",t.group(1)).strip()) if t else ""
        company=html.unescape(re.sub(r"\s+"," ",co.group(1)).strip()) if co else "the company"
        url=u.group(1) if u else "https://www.linkedin.com/jobs/view/"+jid
        if not title: continue
        out.append({"id":jid,"title":title,"company":company,"url":url,"rtype":rtype,"loc":loclabel})
    return out

TODAY = datetime.now(timezone.utc).strftime("%Y-%m-%d")
def slot(h, m, i, gap):
    tot=h*60+m+i*gap
    return "%s %02d:%02d" % (TODAY, (tot//60)%24, tot%60)  # schedule same-day (run date)

def gtoken():
    c=json.load(open(GCREDS))
    body=urllib.parse.urlencode({"client_id":c["client_id"],"client_secret":c["client_secret"],
        "refresh_token":c["refresh_token"],"grant_type":"refresh_token"}).encode()
    return json.loads(urllib.request.urlopen("https://oauth2.googleapis.com/token", body, timeout=20).read())["access_token"]

def sheet_get(token, rng):
    req=urllib.request.Request("https://sheets.googleapis.com/v4/spreadsheets/%s/values/%s"%(SHEET,urllib.parse.quote(rng)),
        headers={"Authorization":"Bearer "+token})
    return json.loads(urllib.request.urlopen(req,timeout=30).read()).get("values",[])

def sheet_append(token, rows):
    url="https://sheets.googleapis.com/v4/spreadsheets/%s/values/Sheet1!A1:append?valueInputOption=RAW&insertDataOption=INSERT_ROWS"%SHEET
    req=urllib.request.Request(url, data=json.dumps({"values":rows}).encode(), method="POST",
        headers={"Authorization":"Bearer "+token,"Content-Type":"application/json"})
    return json.loads(urllib.request.urlopen(req,timeout=40).read())

# 1) source
log("=== Job Radar run (DRY_RUN=%s) ===" % DRY)
roles=[]
for kw,rt in KEYWORDS:
    for loc,lbl in LOCATIONS:
        h=fetch(kw,loc); roles+=parse(h,rt,lbl); time.sleep(1)
log("sourced %d raw cards" % len(roles))

# 2) dedup within run + filter
byid={}
for r in roles:
    if r["id"] in byid: continue
    t=r["title"]
    if EXCLUDE.search(t) or not INCLUDE.search(t): continue
    byid[r["id"]]=r
cand=list(byid.values())
log("after filter/dedup-in-run: %d" % len(cand))

# 3) dedup vs seen ledger ("never twice")
seen={}
try: seen=json.load(open(SEEN_FILE))
except Exception: seen={}
fresh=[r for r in cand if r["id"] not in seen]
log("fresh (never seen before): %d" % len(fresh))

# 4) cap-aware: check current pending
token=None
pending=0
try:
    token=gtoken()
    col=sheet_get(token,"Sheet1!H2:H1000")
    pending=sum(1 for v in col if v and v[0].strip().lower()=="pending")
except Exception as e:
    log("sheet read warn: %s" % str(e)[:80])
log("currently pending in queue: %d" % pending)
room=max(0, min(DAILY_TARGET, MAX_PENDING - pending))
batch = fresh[:DAILY_TARGET] if DRY else fresh[:room]   # dry-run shows full plan regardless of cap
log("room today: %d (dry shows up to %d)" % (room, len(batch)))

# 5) assign tier + window + build rows
def mk(r):
    return "%s is hiring a %s based in %s. %s Required skills: %s." % (
        r["company"], r["title"], r["loc"], RESP[r["rtype"]], SKILLS[r["rtype"]])
rows=[]; planned=[]
for i,r in enumerate(batch):
    if i<4:   tier,(bh,bm,g)="Ultra Premium",(7,0,15)
    elif i<12: tier,(bh,bm,g)="Balanced",(11,0,12); i2=i-4
    else:     tier,(bh,bm,g)="Fast",(18,0,6); i2=i-12
    idx = i if tier=="Ultra Premium" else (i-4 if tier=="Balanced" else i-12)
    runat=slot(bh,bm,idx,g)
    rows.append(["radar "+datetime.now(timezone.utc).strftime("%m-%d"), mk(r), r["url"],
                 "Professional", tier, "Gautham", runat, "pending", "FALSE", r["loc"]])
    planned.append("  %s | %s | %s @ %s | %s" % (tier, r["loc"], r["title"], runat, r["company"]))
log("PLAN:\n"+"\n".join(planned) if planned else "PLAN: nothing to queue")

# 6) write (unless dry run)
if DRY:
    log("DRY_RUN: no writes."); sys.exit(0)
if not batch:
    log("nothing to queue today."); sys.exit(0)
try:
    sheet_append(token, rows)
    for r in batch: seen[r["id"]]={"t":r["title"],"d":datetime.now(timezone.utc).strftime("%Y-%m-%d")}
    json.dump(seen, open(SEEN_FILE,"w"))
    log("QUEUED %d, seen ledger now %d ids" % (len(batch), len(seen)))
except Exception as e:
    log("WRITE FAIL: %s" % str(e)[:120]); sys.exit(1)
