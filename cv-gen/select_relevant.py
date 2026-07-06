#!/usr/bin/env python3
# select_relevant.py — given a JD (text on stdin or a file arg), pick the most
# JD-relevant experiences + projects from source_of_truth.json.
# Rule (per user): role_1 = most-recent role always; role_2/role_3 = the 2 most
# JD-relevant of the rest (reverse-chronological); top ~4 projects by overlap.
# If real coverage < 0.5 -> flag fallback=True so the generator fills the gap
# with best-aligned realistic content (still under all writing rules).
# Standalone; wired into nothing yet.
import json, sys, os, re
SOT = os.path.expanduser("~/cv-gen/source_of_truth.json")

STOP = set("and or the a an of to in for with on at by from as is are be this that your you will we our their build built using use work role team".split())

def toks(s):
    return set(t for t in re.split(r"[^a-zA-Z0-9+#.]+", str(s).lower()) if len(t) > 1 and t not in STOP)

def score(item_tokens, jd_tokens):
    if not item_tokens: return 0.0
    return len(item_tokens & jd_tokens) / max(6, len(item_tokens))

def main():
    jd = ""
    if len(sys.argv) > 1 and os.path.exists(sys.argv[1]):
        jd = open(sys.argv[1]).read()
    else:
        jd = sys.stdin.read()
    jt = toks(jd)
    try:
        sot = json.load(open(SOT))
    except Exception:
        print(json.dumps({"error": "no source_of_truth.json yet", "fallback": True})); return
    exps = sot.get("experiences", [])
    # role_1 = most_recent (or first) ; others scored
    recent = [e for e in exps if e.get("most_recent")]
    role1 = recent[0] if recent else (exps[0] if exps else None)
    rest = [e for e in exps if e is not role1 and e.get("start") and "CONFIRM" not in (e.get("start", "") + e.get("end", ""))]
    def exp_score(e):
        et = toks(" ".join(e.get("domains", []) + e.get("titles", []) + [e.get("notes", "")]))
        return score(et, jt)
    rest_sorted = sorted(rest, key=exp_score, reverse=True)
    selected_exps = ([role1] if role1 else []) + rest_sorted[:2]
    # keep reverse-chronological display order among selected (by start year desc, best-effort)
    def yr(e):
        m = re.search(r"(19|20)\d{2}", e.get("end", "") or e.get("start", ""))
        return int(m.group(0)) if m else 0
    selected_exps = sorted([e for e in selected_exps if e], key=yr, reverse=True)
    # projects
    projs = sot.get("projects", [])
    def prj_score(p):
        pt = toks(" ".join(p.get("domains", []) + p.get("stack", []) + [p.get("name", ""), p.get("what", "")]))
        return score(pt, jt)
    projs_sorted = sorted(projs, key=prj_score, reverse=True)
    top_projs = [p for p in projs_sorted if prj_score(p) > 0][:4]
    # coverage estimate = how much of the JD tokens are covered by selected real material
    covered = set()
    for e in selected_exps:
        covered |= toks(" ".join(e.get("domains", []) + e.get("titles", [])))
    for p in top_projs:
        covered |= toks(" ".join(p.get("domains", []) + p.get("stack", [])))
    coverage = round(len(covered & jt) / max(8, len(jt)), 2) if jt else 0.0
    out = {
        "selected_experiences": selected_exps,
        "selected_projects": top_projs,
        "coverage": coverage,
        "fallback": coverage < 0.5,
        "note": "fallback=True -> generator writes best-aligned realistic content under all rules",
    }
    print(json.dumps(out, indent=1, ensure_ascii=False))

if __name__ == "__main__":
    main()
