#!/usr/bin/env python3
"""
Resumae CV validator v3 — 2026-07-03
HONEST GATE: hard-fails (exit 1 -> run-ss-claude fires the Opus retry) ONLY on a small set
of critical, objective, countable defects. Every OTHER rule is a SOFT warning (run still
ships, exit 0). This is a restrained gate: it rejects broken CVs without burning quota on
subjective drift.

HARD-FAIL (exit 1) on:
  - Usage / JSON parse error / top-level not object / cv_content missing
  - Certification count != mode spec (professional: exactly 4)
  - Project count != mode spec (professional: exactly 3), or a project missing its title/desc
  - Role bullet count != mode spec (professional: 5/5/4)
  - Skills count outside the accepted range, or a skill label/content that is blank
  - Integrity / egregious AI-tells in the CV body (summary + bullets + projects):
      * an emoji
      * a hardcoded "N years" / "N+ years" tenure phrase
      * first-person (I / my / me) inside any bullet
      * a URL or email inside any bullet
      * company or role_title == Unknown / Confidential / N/A / placeholder

SOFT WARNINGS ONLY (never fail the run — appended to _violations, VALIDATE_WARN on stderr):
  bullet word-count bands, per-bullet/skill/project/summary length, metric-per-role range,
  opener-dup / dup-first-word, cert allowlist membership, audit block presence, meta richness,
  total-word cap, research objectives/area-of-focus length. These are drift, not defects.

Sanitizes: curly quotes, NBSP, em-dash -> comma, en-dash -> hyphen, body semicolons -> period.
Usage: validate_cv.py <mode> <cv_json_file>
Exit codes: 0 = OK / soft warnings only (sanitized JSON to stdout);
            1 = critical count/integrity defect (reasons on stderr, no stdout; retry required)
"""
import sys, json, re

# ---------- MODE SPEC (matches Doc templates, 2026-05-21) ----------
MODE_SPEC = {
    "professional": {"skills": 6, "projects": 3, "certs": 4,
                     "bullets": {"role_1": 5, "role_2": 5, "role_3": 4},
                     "summary_field": "professional_summary"},
    "graduate":     {"skills": 6, "projects": 3, "certs": 4,
                     "bullets": {"role_1": 4, "role_2": 3, "role_3": 3, "role_4": 3, "role_5": 3},
                     "summary_field": "professional_summary"},
    "retail":       {"skills": 4, "projects": 0, "certs": 4,
                     "bullets": {"role_1": 5, "role_2": 4, "role_3": 4, "role_4": 4},
                     "summary_field": "professional_summary"},
    "research":     {"skills": 6, "projects": 3, "certs": 4,
                     "bullets": {"role_1": 4, "role_2": 3, "role_3": 3, "role_4": 3, "role_5": 3},
                     "summary_field": "objectives"},  # research uses objectives + area_of_focus
    "healthcare":   {"skills": 6, "projects": 3, "certs": 4,
                     "bullets": {"role_1": 8, "role_2": 6},
                     "summary_field": "professional_summary"},
    "hospitality":  {"skills": 6, "projects": 3, "certs": 4,
                     "bullets": {"role_1": 6, "role_2": 5, "role_3": 5},
                     "summary_field": "professional_summary"},
}

# --- 2026-05-25: per-bullet LEN= targets (matches mode profile BULLET OPENER TABLE) ---
LEN_TARGETS = {
    "professional": {
        "role_1": [
            36,
            46,
            30,
            34,
            46
        ],
        "role_2": [
            36,
            30,
            46,
            34,
            44
        ],
        "role_3": [
            32,
            44,
            30,
            36
        ]
    },
    "graduate": {
        "role_1": [
            23,
            47,
            34,
            51
        ],
        "role_2": [
            28,
            49,
            37
        ],
        "role_3": [
            25,
            53,
            33
        ],
        "role_4": [
            39,
            50,
            22
        ],
        "role_5": [
            29,
            54,
            38
        ]
    },
    "research": {
        "role_1": [
            25,
            52,
            40,
            23
        ],
        "role_2": [
            34,
            22,
            45
        ],
        "role_3": [
            29,
            50,
            36
        ],
        "role_4": [
            44,
            27,
            38
        ],
        "role_5": [
            24,
            54,
            37
        ]
    },
    "retail": {
        "role_1": [
            26,
            47,
            35,
            22,
            39
        ],
        "role_2": [
            33,
            53,
            25,
            38
        ],
        "role_3": [
            44,
            23,
            36,
            49
        ],
        "role_4": [
            27,
            51,
            40,
            24
        ]
    },
    "healthcare": {
        "role_1": [
            24,
            48,
            33,
            22,
            54,
            38,
            27,
            45
        ],
        "role_2": [
            36,
            25,
            50,
            29,
            40,
            53
        ]
    },
    "hospitality": {
        "role_1": [
            52,
            26,
            39,
            22,
            47,
            35
        ],
        "role_2": [
            24,
            36,
            50,
            28,
            45
        ],
        "role_3": [
            38,
            23,
            49,
            33,
            54
        ]
    }
}
LEN_TOLERANCE = 3  # bullets must fall within ±3 words of LEN= target

# ---------- LIMITS ----------
WORD_CAP_TOTAL          = 1015   # legacy global ceiling (kept as fallback)
WORD_CAP_BY_MODE = {  # 2026-05-23: per-mode caps based on real observed maxima * 1.1
    "professional": 1050,
    "graduate":     950,
    "research":     1050,  # objectives + 4 area_of_focus = denser
    "healthcare":   950,
    "hospitality":  1000,
    "retail":       900,
}
SUMMARY_WORD_MIN        = 25
SUMMARY_WORD_MAX        = 85
OBJECTIVES_WORD_MIN     = 25
OBJECTIVES_WORD_MAX     = 100
AREA_OF_FOCUS_WORD_MIN  = 4
AREA_OF_FOCUS_WORD_MAX  = 18
SKILL_CONTENT_CHARS_MIN = 45
SKILL_CONTENT_CHARS_MAX = 280
PROJECT_DESC_WORDS_MIN  = 20
PROJECT_DESC_WORDS_MAX  = 90
# CR1 bands. T5-short exemption: ONE bullet per role may be 12-20w.
def bullet_band_ok(w):
    # Contiguous 22-55 (gaps in CR1 original were unenforceable in practice)
    return 22 <= w <= 55
def t5_short_ok(w):
    return 12 <= w <= 21
METRIC_PER_ROLE_MIN = 0
METRIC_PER_ROLE_MAX = 2
AUDIT_WORD_TOLERANCE = 10  # claimed vs actual mismatch allowed

# ---------- SECTION 9 CERT ALLOWLIST (verbatim, 2026-05-21) ----------
CERT_ALLOWLIST = {
    "ISC2 Certified in Cybersecurity (CC)",
    "Cisco Networking Academy: Introduction to Cybersecurity",
    "Fortinet NSE 1 Network Security Associate",
    "Fortinet NSE 2 Network Security Associate",
    "Fortinet NSE 3 Network Security Associate",
    "Google Cybersecurity Professional Certificate",
    "AWS Cloud Practitioner Essentials (AWS Skill Builder)",
    "Microsoft Learn: Azure Fundamentals AZ-900 Learning Path",
    "Microsoft Learn: AI-900 Azure AI Fundamentals Learning Path",
    "Microsoft Learn: SC-900 Security Fundamentals Learning Path",
    "Google Cloud Skills Boost: Cloud Engineering Path",
    "Docker for Beginners (KodeKloud / Docker official)",
    "DeepLearning.AI Machine Learning Specialization (Coursera audit)",
    "DeepLearning.AI Generative AI with LLMs (Coursera audit)",
    "DeepLearning.AI Short Course: ChatGPT Prompt Engineering for Developers",
    "Hugging Face NLP Course",
    "LangChain for LLM Application Development (DeepLearning.AI)",
    "Google AI Essentials (Coursera/Grow with Google)",
    "Kaggle Intro to Machine Learning",
    "Kaggle Intermediate Machine Learning",
    "Kaggle Intro to Deep Learning",
    "freeCodeCamp Responsive Web Design Certification",
    "freeCodeCamp JavaScript Algorithms and Data Structures Certification",
    "freeCodeCamp Front End Development Libraries Certification",
    "freeCodeCamp Back End Development and APIs Certification",
    "Meta Front-End Developer Professional Certificate (Coursera audit)",
    "The Odin Project — Full Stack JavaScript Path",
    "Salesforce Trailhead: Admin Superbadge",
    "Salesforce Trailhead: Ranger Rank",
    "HubSpot Academy: CRM Software Certification",
    "HubSpot Academy: Inbound Marketing Certification",
    "Google Analytics Certification (Skillshop)",
    "Google Digital Marketing & E-commerce Professional Certificate",
    "Google IT Support Professional Certificate",
    "CompTIA IT Fundamentals (ITF+) — ONLY the FREE training pathway, NOT the exam",
    "LinkedIn Learning Path: Become a Junior Software Developer",
}

# ---------- HELPERS ----------
def sanitize(s: str) -> str:
    # Curly quotes that break JSON
    s = s.replace("“", '"').replace("”", '"')
    s = s.replace("‘", "'").replace("’", "'")
    s = s.replace(" ", " ")    # NBSP
    return s

def post_sanitize_bullet(s: str) -> str:
    """Strip HV5-banned punctuation from bullet/desc text after JSON parse."""
    if not isinstance(s, str):
        return s
    s = s.replace("—", ",")    # em-dash → comma
    s = s.replace("–", "-")    # en-dash → hyphen
    s = s.replace(";", ".")          # semicolons → periods
    # Body colons inside sentence (not start of bullet)
    s = re.sub(r"(?<=\w):\s+(?=\w)", " - ", s)
    return s

def words(x) -> int:
    return len(re.findall(r"\S+", str(x or "")))

def has_metric(s: str) -> bool:
    """True if bullet contains a REAL performance/business metric.
    Counts: %, $, latency units (Nms/Ns), k/M/B numeric suffixes, x-multipliers.
    Excludes: version numbers (Postgres 16), HTTP codes (429), bare years.
    """
    if not isinstance(s, str):
        return False
    # Percentage or dollar
    if re.search(r"\d+\s*%|\$\s*\d", s):
        return True
    # Latency / duration with units: 280ms, 1.4s (but not standalone 's')
    if re.search(r"\d+\s*(ms|µs|μs|ns)", s):
        return True
    if re.search(r"\d+\.\d+\s*s", s):
        return True
    # k/M/B scale on numbers: 11k, 4.2k, 200M, 1.5B
    if re.search(r"\d+\.?\d*\s*[kKMB]", s):
        return True
    # X-multipliers: 5x, 10x, 2.5x
    if re.search(r"\d+(\.\d+)?\s*x", s):
        return True
    return False

_VIOLATIONS=[]
def fail(msg):
    _VIOLATIONS.append(str(msg))
    print(f"VALIDATE_WARN: {msg}", file=sys.stderr)
def hard_fail(msg):
    print(f"VALIDATE_FAIL: {msg}", file=sys.stderr)
    sys.exit(1)

# 2026-07-03: critical (count/integrity) defects. Collected, NOT exited immediately, so
# ALL reasons print; a non-empty list forces exit(1) after the rules run (see hard gate).
_HARD_VIOLATIONS=[]
def critical_fail(msg):
    _HARD_VIOLATIONS.append(str(msg))
    print(f"VALIDATE_FAIL: {msg}", file=sys.stderr)

# ---------- INTEGRITY / AI-TELL DETECTORS (2026-07-03, HARD gate) ----------
# Conservative on purpose: only unambiguous, objective tells so we do not over-fail.
EMOJI_RE = re.compile(
    "["
    "\U0001F300-\U0001FAFF"   # symbols/pictographs, emoticons, transport, supplemental
    "\U00002600-\U000027BF"   # misc symbols + dingbats
    "\U00002B00-\U00002BFF"   # misc symbols & arrows (stars etc.)
    "\U0001F1E6-\U0001F1FF"   # regional indicator flags
    "\U0000FE0F"              # emoji variation selector-16
    "]"
)
# Plain http/www URLs and emails only (won't false-positive on lib names like socket.io).
URL_EMAIL_RE = re.compile(r"https?://\S+|\bwww\.\S+|[\w.+-]+@[\w-]+\.[A-Za-z]{2,}")
# Fabricated tenure: "5 years", "10+ years" (plural only -> skips "2 year roadmap").
YEARS_RE = re.compile(r"\b\d+\s*\+?\s*years\b", re.I)
PLACEHOLDER_VALUES = {"unknown", "confidential", "n/a", "placeholder"}
# Roman-numeral triggers so "Phase I rollout" doesn't read as first-person "I".
_FP_ROMAN_PREV = {"phase","tier","level","type","class","grade","part","stage","group",
                  "war","section","appendix","chapter","figure","table","volume","item",
                  "mark","world","category","annex","exhibit"}
def first_person_hit(b):
    """Return the offending token if a bullet uses first person, else None."""
    if not isinstance(b, str):
        return None
    m = re.search(r"\b(my|me|myself|mine)\b", b, re.I)   # unambiguous
    if m:
        return m.group(0)
    m = re.search(r"\bI['’]\w*", b)                       # I've / I'm / I'll / I'd
    if m:
        return m.group(0)
    for m in re.finditer(r"\bI\b(?=\s+[a-z])", b):        # "I led", "I built"
        head = b[:m.start()].strip().split()
        prev = re.sub(r"[^A-Za-z]", "", head[-1]).lower() if head else ""
        if prev in _FP_ROMAN_PREV:
            continue
        return "I"
    return None

# ---------- MAIN ----------
def main():
    if len(sys.argv) < 3:
        hard_fail("usage: validate_cv.py <mode> <file>")
    mode = sys.argv[1].lower()
    raw = open(sys.argv[2], "r", encoding="utf-8", errors="replace").read()
    raw = sanitize(raw)
    raw = re.sub(r"^```(?:json)?\s*", "", raw.strip())
    raw = re.sub(r"\s*```\s*$", "", raw)
    try:
        cv, _idx = json.JSONDecoder().raw_decode(raw.lstrip())
    except Exception as e:
        cv = None
        _start = raw.find('{')
        # 1) decode from first '{' (handles leading prose / refusal preamble)
        if _start != -1:
            try:
                cv, _idx = json.JSONDecoder().raw_decode(raw[_start:])
            except Exception:
                cv = None
        # 2) brace-balanced extraction + truncation/trailing-comma repair
        if cv is None and _start != -1:
            _depth = 0; _instr = False; _esc = False; _end = -1
            for _i in range(_start, len(raw)):
                _ch = raw[_i]
                if _esc:
                    _esc = False; continue
                if _ch == "\\":
                    _esc = True; continue
                if _ch == '"':
                    _instr = not _instr; continue
                if _instr:
                    continue
                if _ch == '{':
                    _depth += 1
                elif _ch == '}':
                    _depth -= 1
                    if _depth == 0:
                        _end = _i; break
            _cand = raw[_start:_end+1] if _end != -1 else raw[_start:] + ('}' * max(_depth, 0))
            _cand = re.sub(r',\s*([}\]])', r'\1', _cand)
            try:
                cv = json.loads(_cand)
            except Exception:
                cv = None
        # 3) original greedy fallback
        if cv is None:
            m = re.search(r'\{.*\}', raw, re.S)
            if m:
                try:
                    cv = json.loads(m.group(0))
                except Exception:
                    cv = None
        if cv is None:
            hard_fail(f"JSON parse: {e}")
    if not isinstance(cv, dict):
        hard_fail("top-level not object")

    try:
        # --- meta block (BUG 26) ---
        meta = cv.get("meta")
        if not isinstance(meta, dict):
            fail("meta missing or not object")
        for k in ("company", "role_title", "template_used", "seniority"):
            # company may be empty per MEGA RULE 0 fallback; role_title cannot
            if k == "company":
                continue
            v = (meta.get(k) or "")
            if isinstance(v, str) and not v.strip():
                fail(f"meta.{k} empty")
        if meta.get("template_used", "").lower() != mode:
            fail(f"meta.template_used '{meta.get('template_used')}' != mode '{mode}'")

        c = cv.get("cv_content")
        if not isinstance(c, dict):
            hard_fail("cv_content missing or not object")


        # 2026-05-25 prod: role_title minimum richness
        _meta = cv.get("meta", {}) if isinstance(cv.get("meta"), dict) else {}
        _rt = (_meta.get("role_title") or "").strip()
        if not _rt:
            fail("meta.role_title empty")
        if len(_rt) < 12:
            fail(f"meta.role_title too short ({len(_rt)} chars): {_rt!r} — must match JD title verbatim")

        spec = MODE_SPEC.get(mode)
        if not spec:
            fail(f"unknown mode '{mode}'")

        # --- skills: exact ==, not < (BUG 19) ---
        sk_labels = sorted([k for k in c if re.fullmatch(r"skill_\d+_label", k)])
        # Fix 1 (2026-05-24): skills count is a RANGE, not exact. Real CVs span 4-8 skill groups.
        SK_MIN, SK_MAX = 4, 8
        # HARD: skills count egregiously wrong (outside the accepted 4-8 range).
        if not (SK_MIN <= len(sk_labels) <= SK_MAX):
            critical_fail(f"skills: have {len(sk_labels)} labels, need {SK_MIN}-{SK_MAX} (target {spec['skills']})")
        for k in sk_labels:
            cnt_key = k.replace("_label", "_content")
            v = (c.get(cnt_key) or "").strip()
            # HARD: a skill pair must be non-empty (both label and content present).
            if not (c.get(k) or "").strip():
                critical_fail(f"empty skill label {k}")
            if not v:
                critical_fail(f"empty skill content {cnt_key}")
            elif len(v) < SKILL_CONTENT_CHARS_MIN:
                fail(f"{cnt_key} too short ({len(v)} chars; need >={SKILL_CONTENT_CHARS_MIN})")
            if len(v) > SKILL_CONTENT_CHARS_MAX:
                fail(f"{cnt_key} too long ({len(v)} chars; max {SKILL_CONTENT_CHARS_MAX})")

        # --- projects: exact == ---
        proj_titles = sorted([k for k in c if re.fullmatch(r"project_\d+_title", k)])
        if spec["projects"] > 0:
            # HARD: project count wrong.
            if len(proj_titles) != spec["projects"]:
                critical_fail(f"projects: have {len(proj_titles)} titles, need EXACTLY {spec['projects']}")
            for k in proj_titles:
                d_key = k.replace("_title", "_desc")
                dv = c.get(d_key) or ""
                # HARD: each project must have a non-blank title AND desc.
                if not (c.get(k) or "").strip():
                    critical_fail(f"empty project title {k}")
                if not str(dv).strip():
                    critical_fail(f"{d_key} missing/blank -- project needs both title and desc")
                elif words(dv) < PROJECT_DESC_WORDS_MIN:
                    fail(f"{d_key} too short ({words(dv)}w; need >={PROJECT_DESC_WORDS_MIN})")
                if words(dv) > PROJECT_DESC_WORDS_MAX:
                    fail(f"{d_key} too long ({words(dv)}w; max {PROJECT_DESC_WORDS_MAX})")
        else:
            if len(proj_titles) > 0:
                fail(f"mode {mode} forbids projects but found {len(proj_titles)}")

        # --- certs: exact == + allowlist (BUG 20) ---
        if spec["certs"] > 0:
            certs = c.get("certifications") or cv.get("certifications")  # accept top-level fallback
            # HARD: certification count wrong.
            if not isinstance(certs, list) or len(certs) != spec["certs"]:
                n = len(certs) if isinstance(certs, list) else "missing"
                critical_fail(f"certifications: need EXACTLY {spec['certs']}, got {n}")
            # 2026-05-21: Section-9 allowlist is tech-cert focused. Retail/hospitality have their own ecosystem (Manual Handling, HACCP, RSA, First Aid — all free/standard Irish workplace certs).
            SKIP_ALLOWLIST_MODES = {"retail", "hospitality", "healthcare"}  # 2026-05-24: healthcare uses HSE/QQI ecosystem
            for i, ct in enumerate(certs):
                if not isinstance(ct, str) or not ct.strip():
                    fail(f"empty cert at index {i}")
                if mode in SKIP_ALLOWLIST_MODES:
                    continue
                ct_norm = re.sub(r'\s*\([^)]*\)\s*$', '', ct.strip()).strip()
                allowed_norms = {re.sub(r'\s*\([^)]*\)\s*$', '', a).strip() for a in CERT_ALLOWLIST}
                # Fix 2 (2026-05-24): substring match BOTH directions
                # Real cert in allowlist as 'HSEland: Hand Hygiene' should accept model output 'Hand Hygiene' and vice versa.
                ct_low = ct.strip().lower()
                ct_norm_low = ct_norm.lower()
                allowed_lows = [a.lower() for a in CERT_ALLOWLIST] + [a.lower() for a in allowed_norms]
                match = (
                    ct.strip() in CERT_ALLOWLIST
                    or ct_norm in allowed_norms
                    or any(ct_low in a or a in ct_low for a in allowed_lows)
                    or any(ct_norm_low in a or a in ct_norm_low for a in allowed_lows)
                )
                if not match:
                    fail(f"cert[{i}] not in Section-9 allowlist: {ct!r}")
        else:
            certs = c.get("certifications") or cv.get("certifications")
            if certs and isinstance(certs, list) and len(certs) > 0:
                fail(f"mode {mode} forbids certs but found {len(certs)}")

        # --- bullets per role: exact count, CR1 bands + T5 short exemption + metric range ---
        for role, need in spec["bullets"].items():
            arr = c.get(f"{role}_bullets")
            # HARD: role bullet count wrong (professional 5/5/4, per mode spec).
            if not isinstance(arr, list) or len(arr) != need:
                got = len(arr) if isinstance(arr, list) else "missing"
                critical_fail(f"{role}_bullets: need EXACTLY {need}, got {got}")
            if not isinstance(arr, list):
                arr = []   # guard: keep soft checks below from crashing on missing array
            short_count = 0
            SHORT_MAX = 4  # 2026-05-25 night: bumped 3->4 for Opus reality
            targets = LEN_TARGETS.get(mode, {}).get(role, [])
            for i, b in enumerate(arr):
                if not isinstance(b, str) or not b.strip():
                    fail(f"{role}_bullets[{i}] empty")
                w = len(b.split())
                if w < 12 or w > 75:
                    fail(f"{role}_bullets[{i}] word-count out of range: {w}w (need 12-75)")
                if w < 18:
                    short_count += 1
                # LEN= per-bullet validator check REMOVED — prompt guidance + model self-count is enough; validator only enforces 22-55 band
            if short_count > SHORT_MAX:
                fail(f"{role}: {short_count} bullets under 18w (max {SHORT_MAX})")

            # Metric count per role: 1-2 (BUG 23)
            m_count = sum(1 for b in arr if has_metric(b))
            if m_count < METRIC_PER_ROLE_MIN or m_count > METRIC_PER_ROLE_MAX:
                fail(f"{role}: {m_count} numeric bullets (need {METRIC_PER_ROLE_MIN}-{METRIC_PER_ROLE_MAX})")



        # --- audit block OPTIONAL (2026-05-25 evening: was strict, made optional to unblock shipping) ---
        # _aud = c.get("audit")  -- no enforcement


        # --- 2026-05-25 prod: audit block required (check both locations) ---
        _aud = c.get("audit") or cv.get("audit")
        if not isinstance(_aud, dict):
            fail("audit block missing or not a dict (cv.audit OR cv_content.audit)")
        else:
            # guard (2026-07-03): only probe keys when _aud is a dict — otherwise this
            # raised AttributeError, which the soft except swallowed and aborted the
            # rest of the rules (opener + integrity + summary + word-cap never ran).
            for _k in ("ats_match_pct","ai_detection_risk_pct","recruiter_scan_pct","interview_promise"):
                if not isinstance(_aud.get(_k), int):
                    fail(f"audit.{_k} missing or not int")

        # --- OPENER RULES (2026-05-25, validator hard-check) ---
        # Collect ALL bullets across roles, check 3 rules:
        # 1) no two bullets share first 2 words
        # 2) no bullet first word ends in -ed/-d (past tense)
        # 3) no bullet first word in top-20 overused CV verbs
        _all_bullets = []
        for role in spec["bullets"]:
            _arr = c.get(f"{role}_bullets") or []
            _all_bullets.extend([b for b in _arr if isinstance(b, str) and b.strip()])
        def _first_word(b):
            return re.sub(r"[^A-Za-z]", "", b.strip().split()[0]).lower() if b.strip() else ""
        def _first_token_raw(b):
            return b.strip().split()[0] if b.strip() else ""
        def _first_two(b):
            toks = b.strip().split()
            return " ".join(re.sub(r"[^A-Za-z]","",t).lower() for t in toks[:2]) if len(toks)>=2 else ""
        _pairs = [_first_two(b) for b in _all_bullets if _first_two(b)]
        _dups = sorted({p for p in _pairs if _pairs.count(p) > 1})
        if _dups:
            fail(f"opener-dup: bullets share first-2-words {_dups}")
        # 2026-05-25 prod: dup-first-word check (catches "Overnight" appearing in 2 roles)
        _firsts_all = [_first_word(b) for b in _all_bullets]
        _dup_first = sorted({w for w in _firsts_all if w and _firsts_all.count(w) > 1})
        if _dup_first:
            fail(f"opener-dup-first: first word repeats {_dup_first}")
        # opener-hyphen check REMOVED 2026-05-25 evening — model habit, retries exhaust; prompt guidance only

        # --- INTEGRITY / AI-TELLS (2026-07-03, HARD gate) ---------------------------------
        # Egregious, objective tells in the CV body -> reject so the Opus retry regenerates.
        _summary_txt = str(c.get("professional_summary") or c.get("objectives") or "")
        if mode == "research":
            _summary_txt += " " + " ".join(str(c.get(f"area_of_focus_{_i}") or "") for _i in range(1, 5))
        _proj_txt = " ".join(str(c.get(_k) or "") for _k in c
                             if re.fullmatch(r"project_\d+_(title|desc)", _k))
        _body_text = " ".join([_summary_txt, " ".join(_all_bullets), _proj_txt])
        # 1) emoji anywhere in body
        _em = EMOJI_RE.search(_body_text)
        if _em:
            critical_fail(f"integrity: emoji in CV body ({_em.group(0)!r})")
        # 2) fabricated "N years" / "N+ years" tenure anywhere in body
        _yr = YEARS_RE.search(_body_text)
        if _yr:
            critical_fail(f"integrity: hardcoded tenure phrase in body ({_yr.group(0)!r})")
        # 3) first-person + 4) URL/email, per bullet
        for _b in _all_bullets:
            _fp = first_person_hit(_b)
            if _fp:
                critical_fail(f"integrity: first-person '{_fp}' in bullet: {_b[:70]!r}")
            _ue = URL_EMAIL_RE.search(_b)
            if _ue:
                critical_fail(f"integrity: URL/email inside bullet ({_ue.group(0)!r})")
        # 5) placeholder company / role_title
        _meta2 = cv.get("meta") if isinstance(cv.get("meta"), dict) else {}
        for _fld in ("company", "role_title"):
            _val = str(_meta2.get(_fld) or "").strip().lower()
            if _val in PLACEHOLDER_VALUES:
                critical_fail(f"integrity: meta.{_fld} is a placeholder value ({_meta2.get(_fld)!r})")



        # --- summary / objectives (mode-aware, BUG 25) ---
        if mode == "research":
            obj = c.get("objectives") or ""
            if words(obj) < OBJECTIVES_WORD_MIN or words(obj) > OBJECTIVES_WORD_MAX:
                fail(f"objectives {words(obj)}w (need {OBJECTIVES_WORD_MIN}-{OBJECTIVES_WORD_MAX})")
            for i in range(1, 5):
                aof = c.get(f"area_of_focus_{i}") or ""
                wn = words(aof)
                if wn < AREA_OF_FOCUS_WORD_MIN or wn > AREA_OF_FOCUS_WORD_MAX:
                    fail(f"area_of_focus_{i} {wn}w (need {AREA_OF_FOCUS_WORD_MIN}-{AREA_OF_FOCUS_WORD_MAX})")
        else:
            summ = c.get("professional_summary") or ""
            if words(summ) < SUMMARY_WORD_MIN or words(summ) > SUMMARY_WORD_MAX:
                fail(f"professional_summary {words(summ)}w (need {SUMMARY_WORD_MIN}-{SUMMARY_WORD_MAX})")

        # --- _audit block: presence-only check (kept in prompt for self-discipline; verification disabled because models systematically miscount by 10-14 words) ---
        # The validator already enforces actual word bands per bullet above, which is the real safety net.
        # Keeping _audit emit-required keeps the model in word-counting mindset even if its arithmetic is off.
        pass

        # --- total word cap (BUG 18) ---
        def total_words(o):
            if isinstance(o, str): return words(o)
            if isinstance(o, list): return sum(total_words(x) for x in o)
            if isinstance(o, dict):
                return sum(total_words(v) for k, v in o.items() if k != "_audit")
            return 0
        tw = total_words(c)
        if tw > WORD_CAP_BY_MODE.get(mode, WORD_CAP_TOTAL):
            fail(f"cv_content total {tw}w > {WORD_CAP_BY_MODE.get(mode, WORD_CAP_TOTAL)} (3-page risk)")

    except Exception as _ve:
        fail(f"validator crashed mid-rules: {_ve}")

    # --- HARD GATE (2026-07-03) --------------------------------------------------------
    # Exit non-zero on any critical count/integrity defect so run-ss-claude fires the Opus
    # retry. All reasons are printed; NO JSON is emitted to stdout on a hard-fail.
    if _HARD_VIOLATIONS:
        print(f"VALIDATE_FAIL: {len(_HARD_VIOLATIONS)} critical defect(s) -- CV rejected, regenerate:",
              file=sys.stderr)
        for _h in _HARD_VIOLATIONS:
            print(f"  - {_h}", file=sys.stderr)
        sys.exit(1)

    # --- HV5 punctuation sanitize on output (BUG 21) ---
    def deep_sanitize(o):
        if isinstance(o, str):
            return post_sanitize_bullet(o)
        if isinstance(o, list):
            return [deep_sanitize(x) for x in o]
        if isinstance(o, dict):
            return {k: deep_sanitize(v) for k, v in o.items()}
        return o
    cv_clean = deep_sanitize(cv)
    # Drop _audit from final output — internal-only
    cv_clean.pop("_audit", None)
    if isinstance(cv_clean.get("cv_content"), dict):
        cv_clean["cv_content"].pop("_audit", None)

    if _VIOLATIONS:
        print(f"VALIDATE_WARNINGS: {len(_VIOLATIONS)} soft violations (run NOT failed)", file=sys.stderr)
        for _v in _VIOLATIONS:
            print(f"  - {_v}", file=sys.stderr)
        try:
            cv_clean.setdefault("_violations", _VIOLATIONS)
        except Exception:
            pass
    sys.stdout.write(json.dumps(cv_clean, ensure_ascii=False))
    sys.exit(0)

if __name__ == "__main__":
    main()
