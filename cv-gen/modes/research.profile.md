RESEARCH MODE PROFILE — follows the master prompt, never repeats it.
The master holds every universal rule (bands CR1, structure CR4, authenticity CR5, banned vocab HV1, page limit, skills/projects/certs format). This file adds ONLY the research-specific items below.
Research is the one mode that DROPS `professional_summary` and replaces it with `objectives` + four `area_of_focus_*` fields — that is the biggest difference from professional, so read section 3 first.


## meta.role_title
Allowed titles (pick the one closest to the JD, written verbatim where the JD uses it):
Research Engineer · Applied Research Scientist · Research Software Engineer · Machine Learning Engineer · Research Scientist · ML Research Engineer · Applied Scientist · Data Scientist (Research) · Research Assistant · ML Research Intern.
Honest-match rule: choose the single title that matches the JD at an early-career / research-assistant level; never inflate to Senior / Lead / Principal / Staff / Head, and never invent a title outside this list.


## SUMMARY FIELDS  (research-specific — REPLACES professional_summary)
Research mode does NOT emit `professional_summary`. Emit these instead:
- `objectives` — 25–100 words. Evidence-led research direction built from the JD's named research questions, methods, and domains. Plain and specific, pitched at an early-career / research-assistant level. No career-objective clichés ("seeking a role where…", "eager to leverage…"), no hype, no first person, no digits-as-tenure.
- `area_of_focus_1` .. `area_of_focus_4` — 4–18 words EACH. Four distinct short research-theme labels ("Domain · sub-domain · method angle"). Each names a different area; do not restate the objectives sentence.
One line to remember: in research mode, DO NOT emit `professional_summary` — the research Doc template never renders it, and emitting it trips validator checks and wastes tokens.


## publication honesty
Real venues only — never claim acceptance/publication at ACL / EMNLP / NeurIPS / ICML / ICLR / NAACL / LREC / Interspeech (or any venue) without a real DOI; generic mentions (dissertation poster, lab seminar, workshop, "manuscript in preparation") are fine when true.
State authorship position honestly (first author / co-author / contributor / sole-authored) and never imply first-author on co-authored work; never invent papers, citations, or acceptances.


## BULLET OPENER TABLE — RESEARCH  (5 roles: role_1=4 · role_2=3 · role_3=3 · role_4=3 · role_5=3 = 16 bullets)

Each bullet has a REQUIRED structure (T#) and 2 START options. Start the bullet with ONE of the two words shown for that slot, written EXACTLY — never invent another, never substitute a synonym. These start words OVERRIDE every other opener rule (master included).
Sentence↔word bands (from master CR1): 1 sentence = 22–29w · 2 sentences = 33–40w · 3 sentences = 44–55w. Word counts below are aim points inside those bands.
Per-mode table guarantees already baked in: every role has a DIFFERENT length rhythm · all 16 word counts are unique · consecutive bullets differ by ≥10w · no two adjacent bullets share a band · no role's band-sequence repeats another · no role closes on a 1-sentence bullet. All 32 start words are globally unique, single tokens, and none is a past-tense -ed verb, so any pick yields 16 unique first words.

Role 1 — postgraduate research, most recent (education-shaped) — EXACTLY 4 bullets   order: T2 -> T3 -> T4 -> T10
  R1B1  T2  Object      -> Hypothesis | Corpus         2 sentences   ~34w  (band 33-40)
  R1B2  T3  Context     -> Across | Throughout         3 sentences   ~50w  (band 44-55)
  R1B3  T4  Outcome     -> Significance | Variance     1 sentence    ~24w  (band 22-29)
  R1B4  T10 Time        -> During | Midway             2 sentences   ~38w  (band 33-40)

Role 2 — pre-postgrad applied role (work-shaped) — EXACTLY 3 bullets   order: T3 -> T4 -> T8
  R2B1  T3  Context     -> Beneath | Amid              1 sentence    ~22w  (band 22-29)
  R2B2  T4  Outcome     -> Precision | Recall          3 sentences   ~47w  (band 44-55)
  R2B3  T8  Constraint  -> Without | Sans              2 sentences   ~33w  (band 33-40)

Role 3 — undergraduate (education-shaped) — EXACTLY 3 bullets   order: T4 -> T8 -> T10
  R3B1  T4  Outcome     -> Accuracy | Sensitivity      2 sentences   ~37w  (band 33-40)
  R3B2  T8  Constraint  -> Lacking | Absent            1 sentence    ~26w  (band 22-29)
  R3B3  T10 Time        -> Overnight | Nightly         3 sentences   ~44w  (band 44-55)

Role 4 — postgrad-period internship (work-shaped) — EXACTLY 3 bullets   order: T8 -> T10 -> T2
  R4B1  T8  Constraint  -> Barring | Minus             3 sentences   ~53w  (band 44-55)
  R4B2  T10 Time        -> Initially | Once            1 sentence    ~28w  (band 22-29)
  R4B3  T2  Object      -> Dataset | Pipeline          2 sentences   ~39w  (band 33-40)

Role 5 — earliest applied internship (work-shaped) — EXACTLY 3 bullets   order: T10 -> T2 -> T3
  R5B1  T10 Time        -> Weekly | Quarterly          1 sentence    ~23w  (band 22-29)
  R5B2  T2  Object      -> Benchmark | Checkpoint      2 sentences   ~35w  (band 33-40)
  R5B3  T3  Context     -> Within | Alongside          3 sentences   ~55w  (band 44-55)

T-type key: T2 object-first · T3 context-first · T4 outcome-first · T8 constraint-first · T10 time-first. Types never repeat inside a role.


## SELF-CHECK (verify before output)
- Bullet counts: role_1=4, role_2=3, role_3=3, role_4=3, role_5=3.  ✓
- 16 word-count aim points all unique (34,50,24,38 / 22,47,33 / 37,26,44 / 53,28,39 / 23,35,55).  ✓
- No two adjacent bullets share a band; consecutive bullets differ ≥10w.  ✓
- Every role closes on a 2- or 3-sentence bullet (never a 1-sentence bullet).  ✓
- 16 opener first-words globally unique (all 32 options disjoint); none ends in -ed.  ✓
- Summary fields = `objectives` (25–100w) + `area_of_focus_1..4` (4–18w each); `professional_summary` NOT emitted.  ✓
