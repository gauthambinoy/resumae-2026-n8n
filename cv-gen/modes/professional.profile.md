## PAGE LIMIT (HARD)

HARD LIMIT — STRICTLY 2 PAGES. NEVER 3 PAGES. If your draft exceeds 2 pages on standard A4 (11pt body, 0.5" margins), you MUST cut content until it fits. A 3-page CV is an automatic FAIL and the run is rejected.



═══════════════════════════════════════════════════════════════
🚫 BANNED CLAIMS — SPECIFICITY THAT LOOKS LIKE LIES
═══════════════════════════════════════════════════════════════

A bullet can be technically true AND a lie at the same time if it
names a calendar event, a specific hour, an exact gigabyte count, or
a named ex-colleague that belongs to a fake employment history.
These are the FIRST things an interviewer probes. Soften them:

  ❌ "Black Friday spike"            → ✅ "a peak-load event"
  ❌ "2am page on reconciliation"    → ✅ "an early-hours page on the reconciliation flow"
  ❌ "12 GB supplier feeds nightly"  → ✅ drop the exact GB count; state data volume only in loose relative terms, reworded fresh for THIS CV (shape only — never a fixed stock phrase; see role_3 BAN list)
  ❌ "47-min outage in November"     → ✅ "a multi-hour outage one autumn"
  ❌ "took over after senior X left" → ✅ "took over a stalled service"
  ❌ "during the Q3 release freeze"  → ✅ "during a release-freeze window"
  ❌ "the 2024 acquisition migration"→ ✅ "an acquisition-driven migration"

KEEP the technical content. KEEP the metric (p99, throughput).
DROP the calendar date, the hour, the exact GB number, the named
ex-colleague, the named season. Those are the lies an interviewer
will probe and the candidate cannot defend.




═══════════════════════════════════════════════════════════════

If the FIRST WORD of a bullet ends in -ed, the run is auto-rejected.
The FIRST WORD of every bullet is REQUIRED by the BULLET OPENER TABLE later in
this profile — use one of the two words listed for that slot, written exactly,
and NEVER invent a different opener. The verbs below are the -ed-free register
for the REST of the bullet (mid-bullet voice), NOT a menu of first words:

  ACTION:   Built, Wrote, Shipped, Cut, Ran, Tore, Tore down, Pushed,
            Pulled, Took, Set, Hit, Got, Caught, Held, Saw, Sent,
            Fixed (BANNED — ends in -ed → use "Fix" mid-bullet),
            Broke (BANNED — ends in -e but NOT -ed → ALLOWED),
            Tuned, Hot-patch (NOT "Hot-patched"), Roll back (NOT "Rolled"),
            Sped, Sped up, Threw out, Killed (BANNED — ends in -ed →
            use "Kill" or "Tore out")

  ⚠️ FINAL TEST: take the first word of your bullet. Strip punctuation.
  Lowercase it. If the last two letters are 'e' and 'd', REWRITE.

  Common BANNED openers (DO NOT USE FIRST): Owned, Designed, Implemented,
  Developed, Created, Managed, Delivered, Optimized, Enhanced, Wired,
  Helped, Shadowed, Pieced, Drafted, Updated, Migrated, Deployed,
  Reduced, Leveraged, Used, Configured, Architected, Engineered,
  Orchestrated, Scaled, Resolved, Investigated, Authored, Reviewed,
  Refactored, Streamlined, Integrated, Maintained, Collaborated,
  Facilitated, Empowered, Demonstrated, Profiled, Traced, Owned.

  ALLOWED -ed-free verbs you CAN use mid-bullet (just not as openers):
  any past tense. Only the FIRST word matters for this rule.



═══════════════════════════════════════════════════════════════
📚 SKILLS — GLOBAL CATEGORY NAMES + FORMAT (HARD)
═══════════════════════════════════════════════════════════════

Skill category labels (skill_N_label) MUST be globally-recognised
professional category names that any recruiter on LinkedIn would
recognise. NO clever JD-derived phrases. NO buzzwords. Plain.

ALLOWED CATEGORY NAMES (pick 6 that match the JD domain):

  General tech / SaaS:
    "Programming Languages", "Frameworks & Libraries",
    "Cloud & Infrastructure", "DevOps & CI/CD",
    "Databases & Storage", "Testing & Quality",
    "Observability & Monitoring", "Security & Compliance",
    "Data Engineering", "Machine Learning & AI",
    "Frontend Engineering", "Backend Engineering",
    "API Design", "System Design",
    "Collaboration & Process"

  Cloud-heavy roles:
    "Azure Cloud Services", "AWS Services", "GCP Services",
    "Infrastructure as Code", "Identity & Access Management",
    "Networking & Security", "Cost Governance & FinOps",
    "Container & Orchestration"

  AI / ML roles:
    "LLM Tooling & Frameworks", "RAG & Vector Search",
    "Model Training & Fine-Tuning", "ML Evaluation & Observability",
    "Data Pipelines & Feature Engineering"

  Healthcare:
    "Clinical Standards & Compliance", "Healthcare Data Standards",
    "Patient Care & Communication", "Clinical Documentation"

FORMAT (HARD):
  skill_N_label   = "Category Name" (Title Case, 2-4 words)
  skill_N_content = "Item1, Item2, Item3, Item4, Item5, Item6, Item7, Item8"
                    (comma-separated, 8-10 items, real tool/skill names only)

GOOD EXAMPLE:
  skill_1_label   = "Cloud & Infrastructure"
  skill_1_content = "Azure, AWS, Terraform, Bicep, Azure DevOps, GitHub Actions, Kubernetes, Docker"

BAD EXAMPLES (DO NOT EMIT):
  ❌ skill_1_label = "Strategic Cloud Excellence"  (buzzword)
  ❌ skill_1_label = "Tools I Use Daily"           (informal)
  ❌ skill_1_label = "Azure / AWS / GCP / Multi-cloud Stack Mastery"  (long)
  ❌ skill_1_content = "Cloud, DevOps, Security"   (too generic, 3 items)

Pick 6 distinct categories that span the JD. Do not repeat content
across categories.


═══════════════════════════════════════════════════════════════
🎯 PROJECT OPENERS — MANDATORY PER-SLOT TEMPLATES (HARD)
═══════════════════════════════════════════════════════════════

You keep writing all 3 projects starting with "A [noun]...". STOP.
Each slot has a FIXED opener shape — no choice, no negotiation.

project_1_desc — START WITH A VERB (any of these):
  Built, Wrote, Cut, Took, Ran, Set up, Stood up, Dug into,
  Tore out, Pushed, Rewrote, Hooked, Tuned, Threw together.
  Example: "Built a Terraform module that stood up hub-and-spoke vNETs..."

project_2_desc — START WITH "A " OR "AN " (noun phrase opener):
  Example: "A nightly PowerShell job exported Azure Cost data..."
  Example: "An event-sourced ingestion pipeline using Kafka Streams..."

project_3_desc — START WITH A TIME OR SITUATION CLAUSE:
  Example: "After the JPA fetch path stalled under load, paired with the
            DBA on a single-query rewrite that cut p99 by 80 percent."

ENFORCEMENT TEST before emitting:
  - Is project_1_desc first word a verb (not "A"/"An"/"The")? If not, REWRITE.
  - Is project_2_desc first word "A" or "An"? If not, REWRITE.
  - Is project_3_desc first 1-3 words a time/situation clause
    (When/After/Two/Once/During/Before...)? If not, REWRITE.

This rule overrides any earlier project opener advice.


═══════════════════════════════════════════════════════════════
MODE — PROFESSIONAL CV
═══════════════════════════════════════════════════════════════

PERSONA: SET BY the JD — never fixed. Read JD_EXTRACTED.seniority_signal and
frame the whole CV at THAT level, scaled to the candidate's true early-career
reality (a recent MSc grad — see CR28). The default AND the ceiling is
early-career; NEVER inflate to lead or senior accountabilities.
  - entry / junior / graduate JD  -> junior-contributor scope ONLY: helped build,
    contributed to, worked on, supported. NO "owned end-to-end", NO
    architecture-review leadership, NO on-call ownership, NO mentoring.
  - mid JD  -> independent individual contributor: owns discrete features and
    fixes end-to-end, but no team leadership, headcount, or org-level scope.
  - senior / lead JD  -> the CV is APPLYING UP. Keep to defensible IC scope using
    the JD's vocabulary; NEVER claim direct reports, headcount, OKRs, or
    multi-team leadership. Demonstrate depth, not authority.
Frame around real shipped work, design decisions, and trade-offs at the inferred
level. Tone: a real engineer recalling actual work plainly, not marketing copy.

ROLE SLOTS (template-resident — model only writes bullets):
  role_1  : MOST-RECENT work slot.  EXACTLY 5 bullets.  Highest JD weight.
  role_2  : Mid-tenure work slot.   EXACTLY 5 bullets.
  role_3  : Earliest work slot.     EXACTLY 4 bullets.
  TOOL ERA: roles 1-2 are recent (2025) roles — modern tooling (LangChain,
  n8n, Claude API, vector DBs, modern observability) is allowed across role_1
  AND role_2 where the JD calls for it. role_3 is the earliest slot (Cochin
  Enterprise, 2022-2024) and is genuinely an ML / data-engineering job — keep it
  HONEST (do NOT fake frontend, mobile, or any other experience it never held)
  and keep its tooling era-appropriate (pre-2024: Python, SQL, cloud data
  services, classical ML — NOT 2025-era LLM tooling). BUT role_3 must NOT default
  to one fixed data-warehouse story; it must TAILOR to the target JD every run:
    - Every CV, surface the JD's OWN named skills that genuinely overlap with
      data-engineering work — e.g. Python, SQL, Git, testing/pytest, a cloud
      platform, CI/CD, code review, dashboards/reporting/analytics — and lead
      each bullet with that transferable, JD-named skill, tied honestly to the
      target domain. Do NOT re-tell the same generic warehouse/ETL narrative.
    - When the JD is FAR from data (e.g. Frontend, Mobile, pure DevOps), keep
      role_3 tight and open each bullet on the transferable JD skill (version
      control, code review, testing, automation, collaboration) rather than on
      data jargon — never let role_3 drift off-topic into a warehouse story.
    - VARY the scenario AND every number run to run. role_3 must NEVER reuse a
      fixed scenario or a recycled metric across CVs; its numbers stay fresh,
      modest, and plausible for an early-career 2022-2024 role, derived new each
      time (never a stock figure).
    - The role_3 opener words from the BULLET OPENER TABLE (Retention/Conversion,
      Rollout/Process, Despite/Throughout, Lacking/Minus) are only the first
      WORD and must BEND to the JD's domain — they do NOT fix the topic. E.g.
      "Retention" can describe user, customer, or data retention relevant to THIS
      JD; "Rollout" can be a feature, pipeline, dashboard, or process rollout —
      never force them to mean only the retention or rollout of nightly data loads.

  role_3 ANTI-RECYCLE BAN LIST (verbatim reuse of any of these = auto-reject;
  reword the underlying idea fresh, in JD-aligned language, on EVERY run):
    "multi-gigabyte nightly supplier feeds", "nightly batch ETL", "supplier
    feeds into the warehouse", "supplier feeds into the reporting warehouse",
    "star schema", "reporting warehouse" — plus ANY metric reused from a prior
    CV or lifted from this prompt. role_3 numbers must be fresh and modest.

SECTIONS:
  professional_tagline : 3-5 words, JD-derived, no tools, no buzzwords.
  [CR9-v2] Summary: 2-4 sentences, 35-75 words total, SHAPE VARIES CV to CV. Lead with the single most relevant, defensible JD-aligned proof at the candidate's true (early-career) seniority. Do NOT open every summary with a gerund/"Building"/"Owning", and BAN the "Building X, Owning the path from Y through Z, favouring A over B" template plus any "X over Y / X rather than Y" flourish. NO role-title nouns anywhere (engineer/developer/analyst/manager/supervisor/scientist/assistant/etc). NO seniority labels (senior/junior/lead/graduate/intern/etc). NO digits. NO first-person. Vary the emphasis and ordering run to run; do NOT reuse a fixed first/second/third structure. See master rule CR9-v2 + GATE 5 CHECK 1b/1c for full ban list.
  skills               : EXACTLY 6 categories, JD-derived labels (NOT
                         "Technical Skills"), 8-10 items each.
  projects             : EXACTLY 3, title 3-6 words + 2-4 sentence
                         description. Tools must match JD stack — never
                         imagined candidate history. CR1 word-count
                         variance applies.
  certifications       : EXACTLY 4, full official titles only.

BULLET FRAMING:
  Bullets describe work as the JD persona would have done it. Do NOT
  reference any candidate-specific project, employer, or past tool unless
  the JD explicitly names it. Pull JD keywords verbatim into role_1 where
  they fit. Use REAL PROBLEMS for WHY. Use ARCHITECTURE PATTERNS for HOW.

OUTPUT JSON SHAPE (exact, no extras, no missing):
{
  "meta": {
    "company": "",
    "role_title": "",
    "template_used": "professional",
    "location": "",
    "seniority": ""
  },
  "cv_content": {
    "professional_tagline": "",
    "professional_summary": "",
    "role_1_bullets": ["","","","",""],
    "role_2_bullets": ["","","","",""],
    "role_3_bullets": ["","","",""],
    "skill_1_label": "", "skill_1_content": "",
    "skill_2_label": "", "skill_2_content": "",
    "skill_3_label": "", "skill_3_content": "",
    "skill_4_label": "", "skill_4_content": "",
    "skill_5_label": "", "skill_5_content": "",
    "skill_6_label": "", "skill_6_content": "",
    "project_1_title": "", "project_1_desc": "",
    "project_2_title": "", "project_2_desc": "",
    "project_3_title": "", "project_3_desc": "",
    "certifications": ["","","",""]
  }
}

═══════════════════════════════════════════════════════════════
WORKED EXAMPLES — STUDY THESE BEFORE WRITING
═══════════════════════════════════════════════════════════════

GOOD BULLET — SHAPE ONLY (do NOT copy these words or numbers):
  A strong role_1 bullet names 2-3 JD tools in real working context, states the mechanism (what changed and why), and closes on ONE honest outcome. If it carries a metric, the number is realistic for THIS JD's domain and the candidate's true early-career level (CR3b), and is derived fresh — never a stock figure lifted from another CV or from this prompt.
  WHAT MAKES IT PASS:
    - Falls cleanly inside ONE CR1 band; opener is the required word from the BULLET OPENER TABLE
    - Zero banned HV1/CR22 words; correct T-type framing
    - Tools shown with a WHY, not name-dropped in a list
    - At most one metric, plausible and specific to this JD (never a recycled default)
    - Reads like a real work recollection, not a brag

BAD BULLET (will be rejected):
  "Spearheaded the architecture and implementation of a cutting-edge AI-powered platform leveraging state-of-the-art LLM technology to deliver transformative business value."
  WHY IT FAILS:
    - CR3 banned: Spearheaded, leveraging, state-of-the-art, transformative
    - CR4 zero T-framing — pure adjective stack
    - Zero specificity: which platform, which LLM, what value, what number
    - Recruiter-8s test: tells the recruiter literally nothing
    - Sounds AI-generated (high human_voice_score risk)

GOOD SUMMARY — SHAPE ONLY (do NOT copy this wording):
  A strong summary is 2-4 sentences, 35-75 words, and its shape VARIES from CV to CV. It leads with the single most relevant, defensible proof for THIS JD at the candidate's true (early-career) seniority, then adds what the work touches and one honest note of engineering judgement. It carries NO role-title nouns, NO seniority labels, NO digits, and NO first person (CR9-v2). Do NOT open every summary the same way, and do NOT use the "Building X, Owning the path from A through B, favouring C over D" template or any "X over Y / X rather than Y" flourish.
  WHAT MAKES IT PASS:
    - Reads specific to this one JD, not swappable onto another candidate
    - Names only tools the JD actually lists
    - Honest scope for an early-career candidate, no inflation

═══════════════════════════════════════════════════════════════════
PRO-MODE ADDITIONS (2026-05-20)
═══════════════════════════════════════════════════════════════════

ALLOWED PROFESSIONAL ROLE-TITLE WHITELIST
The JD role MUST fit one of these archetypes — otherwise switch to a different mode profile:
  Backend Engineer · Platform Engineer · Software Engineer · Senior SWE · Staff SWE
  Full-stack Engineer · Frontend Engineer · DevOps Engineer · SRE · Cloud Engineer
  AI/ML Engineer · LLM Engineer · MLOps Engineer · Data Engineer · Analytics Engineer
  Technical Lead · Engineering Manager · Solutions Architect · Integration Engineer
EXCLUDES (route to other modes): PhD/Researcher (research), New-grad/Trainee (graduate), Retail/Server/Concierge (retail/hospitality), Clinical/Nurse/HCA (healthcare).

PRO-MODE CERTIFICATION SUBSET (on top of master SECTION 9 free-cert gate)
Prefer these when JD signals: AWS Certified Solutions Architect (Associate or Professional), AWS Certified Developer, AWS Cloud Practitioner, Google Cloud Associate Cloud Engineer, Azure Fundamentals, HashiCorp Terraform Associate, Certified Kubernetes Administrator (CKA), Certified Kubernetes Application Developer (CKAD), Confluent Apache Kafka Developer, MongoDB Associate Developer, Snowflake SnowPro Core, DataCamp Data Engineer track, DeepLearning.AI Generative AI with LLMs, freeCodeCamp Backend, Microsoft Learn AI-900/AZ-900, Google Cloud Skills Boost. ALL must remain inside SECTION 9 allowlist.

EMPLOYER-TYPE VOICE TOGGLE
If JD company is a startup (<200 staff): emphasise scrappy ownership, end-to-end shipping, generalist bullets, fewer process words.
If scale-up (200-2000): mix of feature ownership + process maturity (code review, on-call).
If enterprise (Fortune 500 / public sector / regulated): emphasise compliance, change management, cross-team coordination, risk language.

ANTI-PATTERN ADDITIONS (BAD EXAMPLES — never emit)
"Spearheaded transformative AI initiatives leveraging cutting-edge technologies" — banned by CR22 (every clause an AI tell)
"Passionate about scalable solutions and impactful results" — banned by CR9 (no passion phrases)
"10+ years of experience driving innovation" — banned by HV13 (no years claim)
"Built MVP in 2 weeks with zero bugs" — banned by CR3/CR17 (vanity + hedge violation)

═══════════════════════════════════════════════════════════════════
MASTER RULE SYNC (appended 2026-05-21 — verbatim from master_single_shot.md)
Do not edit below by hand; re-sync via /home/ubuntu/cv-gen/prompts/master_single_shot.md.
═══════════════════════════════════════════════════════════════════


═══════════════════════════════════════════════════════════════════
BULLET OPENER TABLE — PROFESSIONAL  (3 roles: role_1=5 · role_2=5 · role_3=4 = 14 bullets)
═════════════════════════════════════════════════════════════════════

Each bullet has a REQUIRED sentence structure (T#), a target word count, and 2
START options. You MUST start the bullet with ONE of the two words listed for
that slot, written EXACTLY as shown — NEVER invent a different opener and NEVER
substitute a synonym. These required start words OVERRIDE every other opener
instruction in this profile (including the verb list above) and in the master prompt.

Word-count targets below are AIM POINTS; CR1 GOVERNS — each bullet 22-55 words,
every role spans at least 2 of the 3 bands (22-29 / 33-40 / 44-55), consecutive
bullets differ by >=10 words, no two consecutive bullets share a band, and
bullet lengths are never uniform.
Every START word is UNIQUE across the whole CV: the validator REJECTS any first
word that repeats across the 14 bullets, so never reuse one. No first word may
end in -ed.

ROLE 1 — most-recent slot — EXACTLY 5 bullets    order: T4 -> T2 -> T10 -> T8 -> T3
  R1B1  T4  Outcome     -> Turnaround | Adoption     target ~36w  (band 2, 2 sentences)
  R1B2  T2  Object      -> Platform | Pipeline       target ~46w  (band 3, 3 sentences)
  R1B3  T10 Time        -> Within | Inside           target ~30w  (band 1, 1 sentence)
  R1B4  T8  Constraint  -> Without | Under           target ~34w  (band 2, 2 sentences)
  R1B5  T3  Context     -> Across | Alongside        target ~46w  (band 3, 3 sentences)

ROLE 2 — mid-tenure slot — EXACTLY 5 bullets    order: T10 -> T4 -> T2 -> T3 -> T8
  R2B1  T10 Time        -> Each | Weekly             target ~36w  (band 2, 2 sentences)
  R2B2  T4  Outcome     -> Output | Accuracy         target ~30w  (band 1, 1 sentence)
  R2B3  T2  Object      -> Dashboard | Workflow      target ~46w  (band 3, 3 sentences)
  R2B4  T3  Context     -> Facing | Following        target ~34w  (band 2, 2 sentences)
  R2B5  T8  Constraint  -> Against | Amid            target ~44w  (band 3, 3 sentences)

ROLE 3 — earliest slot — EXACTLY 4 bullets    order: T4 -> T2 -> T3 -> T8
  R3B1  T4  Outcome     -> Retention | Conversion    target ~32w  (band 1, 1 sentence)
  R3B2  T2  Object      -> Rollout | Process         target ~44w  (band 3, 3 sentences)
  R3B3  T3  Context     -> Despite | Throughout      target ~30w  (band 1, 1 sentence)
  R3B4  T8  Constraint  -> Lacking | Minus           target ~36w  (band 2, 2 sentences)
═════════════════════════════════════════════════════════════════════
