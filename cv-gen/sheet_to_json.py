#!/usr/bin/env python3
# sheet_to_json.py — reads the Source-of-Truth Sheet (Experience/Education/Projects tabs)
# and writes ~/cv-gen/source_of_truth.json. Standalone; wired into nothing yet.
import json, urllib.parse, urllib.request, os, sys, shutil, time
CREDS = os.path.expanduser("~/cv-gen/.gsheets.json")
SHEET = "1ZrGAVXISvMliotzx3WLMDxM5NUIkBcE8u6tC7CCcNx4"
OUT   = os.path.expanduser("~/cv-gen/source_of_truth.json")

def token():
    c = json.load(open(CREDS))
    b = urllib.parse.urlencode({"client_id": c["client_id"], "client_secret": c["client_secret"],
                                "refresh_token": c["refresh_token"], "grant_type": "refresh_token"}).encode()
    return json.loads(urllib.request.urlopen("https://oauth2.googleapis.com/token", b, timeout=20).read())["access_token"]

def get(tab, T):
    u = "https://sheets.googleapis.com/v4/spreadsheets/%s/values/%s" % (SHEET, urllib.parse.quote(tab + "!A1:Z200"))
    req = urllib.request.Request(u, headers={"Authorization": "Bearer " + T})
    return json.loads(urllib.request.urlopen(req, timeout=30).read()).get("values", [])

def rows_to_dicts(rows):
    if not rows: return []
    hdr = [h.strip() for h in rows[0]]
    out = []
    for r in rows[1:]:
        if not any(str(x).strip() for x in r): continue
        d = {hdr[i]: (r[i].strip() if i < len(r) and r[i] is not None else "") for i in range(len(hdr))}
        out.append(d)
    return out

def splitlist(s):
    return [x.strip() for x in str(s).replace(";", ",").split(",") if x.strip()]

def main():
    T = token()
    exp = rows_to_dicts(get("Experience", T))
    edu = rows_to_dicts(get("Education", T))
    prj = rows_to_dicts(get("Projects", T))
    experiences = []
    for e in exp:
        notes = " ".join(x for x in [e.get("What I built (detail)",""), e.get("How I Build",""), e.get("Key facts / notes","")] if x)
        experiences.append({
            "company": e.get("Company", ""),
            "titles": splitlist(e.get("Title options (AI picks closest to JD)", e.get("Title options", ""))),
            "start": e.get("Start", ""), "end": e.get("End", ""),
            "location": e.get("Location", ""),
            "domains": splitlist(e.get("Domains","") + ", " + e.get("Tech stack","")),
            "notes": notes,
            "most_recent": "most recent" in notes.lower(),
        })
    def _cln(v):
        return ", ".join(m.strip().lstrip("\u2022").strip() for m in str(v).replace("\n","|").split("|") if m.strip())
    education = [{
        "degree": x.get("Degree", ""), "field": x.get("Field", ""),
        "institution": x.get("Institution", ""), "start": x.get("Start", ""),
        "end": x.get("End", ""), "location": x.get("Location", ""),
        "modules": _cln(x.get("Key modules", "")),
        "tools": _cln(x.get("Tools learned", "")),
        "thesis": x.get("Thesis", ""), "big_project": x.get("Big project", ""),
        "highlights": " | ".join(v for v in [
            x.get("Field",""),
            ("modules: " + _cln(x.get("Key modules",""))) if x.get("Key modules","").strip() else "",
            ("tools: " + _cln(x.get("Tools learned",""))) if x.get("Tools learned","").strip() else "",
            ("thesis: " + x.get("Thesis","")) if x.get("Thesis","").strip() else "",
            ("project: " + x.get("Big project","")) if x.get("Big project","").strip() else "",
            x.get("Notes",""),
        ] if str(v).strip()),
    } for x in edu if x.get("Degree", "") and not x.get("Degree", "").startswith("(")]
    projects = [{
        "name": p.get("Name", ""), "type": p.get("Type",""),
        "domains": splitlist(p.get("Type","") + ", " + p.get("Domains","")),
        "stack": splitlist(p.get("Stack", "")),
        "core_idea": p.get("Core Idea",""), "problem": p.get("Problem it solves",""),
        "features": p.get("Key features",""),
        "what": " ".join(x for x in [p.get("Core Idea",""), p.get("What it does","")] if x),
        "how": p.get("How it Does",""), "outcome": p.get("Outcome", ""),
        "github": p.get("GitHub URL", ""),
    } for p in prj if p.get("Name", "") and not p.get("Name", "").startswith("<<")]
    doc = {"experiences": experiences, "education": education, "projects": projects}

    # ---- WIPE-PROOF write safeguards -------------------------------------------
    # The Sheets API can return HTTP-200-with-empty-values on a transient blip or a
    # cleared/rearranged tab. Without guards the old unconditional json.dump() would
    # silently overwrite source_of_truth.json with empty arrays, destroying the whole
    # profile (which the 04:30 cron would then propagate). Guard, back up, write atomically.
    new_exp, new_edu, new_prj = len(experiences), len(education), len(projects)

    # 1. SANITY GUARD: read existing counts, then refuse an empty/partial overwrite.
    old_exp = old_prj = 0
    if os.path.exists(OUT):
        try:
            _old = json.load(open(OUT))
            old_exp = len(_old.get("experiences", []))
            old_prj = len(_old.get("projects", []))
        except Exception as _e:
            sys.stderr.write("WARN: could not parse existing %s (%s); guarding on new counts only\n" % (OUT, _e))
    if new_exp == 0 or new_prj == 0 or new_exp < 0.6 * old_exp or new_prj < 0.6 * old_prj:
        sys.stderr.write(
            "ABORT: refusing to overwrite %s (sanity guard tripped). "
            "new experiences=%d projects=%d education=%d vs old experiences=%d projects=%d. "
            "Sheet likely returned empty/partial data; source_of_truth.json left UNTOUCHED.\n"
            % (OUT, new_exp, new_prj, new_edu, old_exp, old_prj))
        sys.exit(1)

    # 2. BACKUP: preserve the previous good copy before overwriting.
    if os.path.exists(OUT):
        bdir = os.path.expanduser("~/cv-gen/backups")
        os.makedirs(bdir, exist_ok=True)
        stamp = time.strftime("%Y%m%dT%H%M%SZ", time.gmtime(os.path.getmtime(OUT)))
        bpath = os.path.join(bdir, "source_of_truth.%s.json" % stamp)
        if not os.path.exists(bpath):
            shutil.copy2(OUT, bpath)
        # prune to last ~10 (timestamp names sort chronologically)
        kept = sorted(f for f in os.listdir(bdir)
                      if f.startswith("source_of_truth.") and f.endswith(".json"))
        for stale in kept[:-10]:
            try: os.remove(os.path.join(bdir, stale))
            except OSError: pass

    # 3. ATOMIC WRITE: write to a temp file then os.replace() into place.
    tmp = OUT + ".tmp"
    json.dump(doc, open(tmp, "w"), indent=1, ensure_ascii=False)
    os.replace(tmp, OUT)
    # ---------------------------------------------------------------------------
    print("wrote %s  (experiences=%d education=%d projects=%d)" % (OUT, len(experiences), len(education), len(projects)))

if __name__ == "__main__":
    main()
