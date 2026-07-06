## PAGE LIMIT (HARD)

HARD LIMIT — STRICTLY 2 PAGES. NEVER 3 PAGES. If your draft exceeds 2 pages on standard A4 (11pt body, 0.5" margins), you MUST cut content until it fits. A 3-page CV is an automatic FAIL and the run is rejected.



═══════════════════════════════════════════════════════════════
🚫 BANNED CLAIMS (HARD — ZERO TOLERANCE)
═══════════════════════════════════════════════════════════════

These violations cause auto-reject. Apply to EVERY bullet, summary,
project, and skill content.

NEVER NAME (inside any bullet/summary/project text):
  - Fictional employers, agencies, or clients ("at Acme Corp",
    "for the Department of Health", "Bank of Ireland", "HSE",
    "Revenue", "Microsoft Ireland", "AIB", "any named company
    not in the JD itself")
  - Fictional government, regulator, or public-sector clients of any
    kind (departments, ministries, councils, hospitals by name)
  - Fictional specific incidents tied to a made-up employer
    ("47-minute outage", "took over after senior engineer left
    mid-migration", "joined after the 2022 acquisition", "led the
    post-mortem on the November cluster failure")
  - Fictional tenant / cohort / scale numbers pinned to a fake
    org ("23-tenant AKS", "350m users I personally supported",
    "managed €4M cloud spend across 12 BUs")
  - Demo or placeholder strings ("XYZ Corp", "[Company Name]",
    "Confidential Client", "Client A", "Project Alpha",
    "<insert here>")
  - Specific named teams at fake employers ("the platform team
    at FAANG-co", "the 8-person SRE squad")

WHAT IS ALLOWED (write freely):
  - Technical depth: tools, stacks, patterns, trade-offs, architecture
    choices, language idioms, framework details. Go deep. Candidate
    will defend at interview.
  - Generic work framing: "designed", "built", "shipped", "rewrote",
    "migrated" — without naming a fake employer.
  - Real-world problem patterns described generically: "a tenant
    isolation problem", "a CI pipeline that kept stalling",
    "a vector retrieval latency cliff".
  - JD-named tools, JD-named patterns, JD-derived domain language.
  - Numbers tied to GENERIC measurable outcomes ("p99 from 4.2s to
    380ms", "deploy time from 38m to 11m") WITHOUT naming the
    fictional org behind them.

THE TEST (apply to every bullet before emitting):
  Would the bullet still be defensible if the candidate said
  "I worked on systems like this, here's how I'd approach it"?
  If YES -> keep. If the bullet REQUIRES a specific fake employer
  to be true -> rewrite or drop.

Violation = auto-reject. This rule overrides every other instruction
in this profile.


═══════════════════════════════════════════════════════════════
🚫 BANNED CLAIMS — SPECIFICITY THAT LOOKS LIKE LIES
═══════════════════════════════════════════════════════════════

A bullet can be technically true AND a lie at the same time if it
names a calendar event, a specific hour, an exact gigabyte count, or
a named ex-colleague that belongs to a fake employment history.
These are the FIRST things an interviewer probes. Soften them:

  ❌ "Black Friday spike"            → ✅ "a peak-load event"
  ❌ "2am page on reconciliation"    → ✅ "an early-hours page on the reconciliation flow"
  ❌ "12 GB supplier feeds nightly"  → ✅ "multi-gigabyte nightly supplier feeds"
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
🎯 PROJECTS — HUMAN VOICE + VARIED OPENERS (HARD)
═══════════════════════════════════════════════════════════════

Projects are where recruiters spend 20+ seconds. Make them count.

FORMAT:
  project_N_title : 3-6 words. Specific, JD-relevant.
                    No "Project X", no buzzwords, no version numbers
                    unless they matter ("Phase 2", "v3 Rewrite").
  project_N_desc  : 2-3 sentences, 35-60 words total.
                    Plain English. Sentence variety required.

OPENER VARIETY (HARD):
  The first 3-4 words of each project_desc MUST be DIFFERENT in
  shape across the 3 projects. NEVER three projects all starting
  with "Built a..." or "A small tool that...". Mix:

    Project 1: action-opener        ("Built a small Python CLI that...")
    Project 2: noun-phrase opener   ("A nightly cron job that...")
    Project 3: situation opener     ("After hitting rate limits on...")

  Other valid opener shapes:
    - "When the team needed X, ..."
    - "The dissertation lab had a problem with..."
    - "A weekend project that grew into..."
    - "Two months into the role, ..."

HUMAN VOICE RULES:
  - Short sentences. 8-18 words each.
  - One idea per sentence.
  - Concrete nouns. No abstractions ("scalable", "robust", "leveraged").
  - Name the tool, name the outcome, name the size.
  - Tell a tiny story: problem → what you did → what changed.
  - Numbers with baseline: "from 4.2s to 380ms" beats "significantly faster".
  - End on the outcome, not the tooling.

GOOD EXAMPLE (project_1):
  title: "Terraform Landing Zone for MSc Lab"
  desc:  "Built a Terraform module that stood up hub-and-spoke vNETs,
          NSG baselines, and Entra role assignments across four
          dissertation subscriptions. The plan ran through Checkov in
          GitHub Actions before any apply. Lab spin-up dropped from
          half a day to twelve minutes."

GOOD EXAMPLE (project_2 — different opener shape):
  title: "Azure Cost Telemetry Dashboard"
  desc:  "A nightly PowerShell job exported Azure Cost Management
          data into Log Analytics for two subscriptions. Grafana read
          the workspace and surfaced spend per resource group.
          The capstone tenant caught a 38 percent untagged-spend
          leak in the first week."

BAD EXAMPLES (DO NOT EMIT):
  ❌ "Built a robust, scalable system that leveraged best practices"
     (buzzwords, no specifics)
  ❌ "Designed and implemented a comprehensive solution for..."
     (Latinate verbs, vague)
  ❌ Three projects all starting with "Built a..."
     (no opener variety)
  ❌ One 80-word sentence with five clauses
     (no rhythm; recruiter glazes)

THE TEST: read your 3 projects aloud. If they sound like a press
release, rewrite. If they sound like a tired senior engineer telling
a peer what they shipped last quarter — KEEP.


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
🌟 STAND-OUT RULE — BEAT 100 OTHER CANDIDATES (HARD)
═══════════════════════════════════════════════════════════════

This CV will land in a stack of 100. The recruiter reads each for
6 seconds. Generic verbs and generic outcomes = pile of 100 = REJECT.

You must do TWO things this CV usually fails at:

(1) NEVER REPEAT THE SAME OPENER VERB ACROSS THE WHOLE CV.
    Across role_1..role_5 + projects, NO opener word may appear twice.
    "Built" used once = banned for the rest of the CV. "Wrote" used
    once = banned. "Ran" used once = banned. Pick a fresh opener
    every bullet from a wide vocabulary.

    Wide opener vocabulary (each used ONCE max across the whole CV):
      Built, Wrote, Cut, Ran, Took, Set up, Stood up, Dug into,
      Tore out, Pushed, Rewrote, Hooked, Tuned, Threw together,
      Stitched, Wove, Spun up, Sketched, Caught, Held, Sat with,
      Pulled, Got, Saw, Sent, Hit, Tracked down, Walked, Brought in,
      Threw out, Bent, Lifted, Pinned, Pushed back, Crawled through,
      Sliced, Carved, Forked, Branched off, Wired up, Drove, Led.

(2) EACH ROLE MUST CONTAIN AT LEAST ONE "STAND-OUT BULLET" — one of:

    (a) An explicit TRADE-OFF: "Took a 6% recall hit for a 90%
        latency win on the chat surface."
    (b) A COUNTER-INTUITIVE CHOICE: "Pulled out the Redis cache —
        it was making the cold path slower under stampede."
    (c) A FAILURE → RECOVERY moment: "First attempt deadlocked
        on broker rebalance; second went through after switching
        commit-async to commit-sync."
    (d) A HUMAN DETAIL: "Sat with the SRE who'd been paged four
        nights running, paired on the HikariCP tuning pass that
        let them sleep."
    (e) A DOMAIN INSIGHT: a sentence that proves you understood
        the business, not just the tech. ("The 38-minute deploy
        was eating Friday afternoon releases — moved to declarative
        Jenkins so the team could ship before close-of-business.")

NO bullet may be of the form:
  "<Verb> a <tool> that <did thing> on <stack> with <number>."
That is the generic shape every Java CV uses. Mix in narrative.

THE TEST: read each role's bullets aloud. If they all sound like the
same sentence with the words swapped, REWRITE one of them to a
stand-out shape above.

This rule overrides every earlier verb/format suggestion.

═══════════════════════════════════════════════════════════════
MODE — RETAIL / HOSPITALITY CV
═══════════════════════════════════════════════════════════════

PERSONA: Shop-floor, hospitality, and service work. Frame around
reliability, speed under pressure, cash accuracy, customer-facing calm,
stock discipline, shift coverage, and compliance awareness. Never claim
office or engineering experience.

DOMAIN VOCABULARY: customers, stock, tills, shifts, teams, safety,
cleaning, cash handling, complaints, openings, closings, peak hours,
deliveries, hygiene, age verification, allergens, queues. If a bullet
drifts toward Python, APIs, frameworks, or model accuracy, stop and
restart that bullet from the retail context.

ROLE SLOTS (template-resident — model only writes bullets):
  role_1  : MOST-RECENT retail/service slot.  EXACTLY 5 bullets.  Highest JD weight.
  role_2  : Recent high-volume service slot.  EXACTLY 4 bullets.
  role_3  : Supervisory retail slot.          EXACTLY 4 bullets.
  role_4  : Hospitality slot.                  EXACTLY 4 bullets.

SECTIONS:
  professional_tagline : 3-5 words, JD-derived (e.g. "Front-of-house
                         Customer-Service Lead"). No tools.
  professional_summary : 3 sentences exact (CR9-v2). JD-derived role identity, retail
                         vocabulary only.
  skills               : EXACTLY 4 categories, retail/service-domain labels
                         (e.g. "Floor & Stock", "Cash & Compliance",
                         "Customer & Communication", "Shift & Safety").
  certifications       : EXACTLY 4. Real retail/hospitality-relevant
                         certifications only (Manual Handling, HACCP,
                         RSA Responsible Service of Alcohol, First Aid,
                         Food Safety, etc.).

BULLET FRAMING:
  Bullets describe service work as the JD's employer would expect.
  Do NOT reference any candidate-specific employer or past role detail.
  Use JD's exact retail vocabulary verbatim where it fits.

OUTPUT JSON SHAPE (exact, no extras, no missing):
{
  "meta": {
    "company": "",
    "role_title": "",
    "template_used": "retail",
    "location": "",
    "seniority": ""
  },
  "cv_content": {
    "professional_tagline": "",
    "professional_summary": "",
    "role_1_bullets": ["","","","",""],
    "role_2_bullets": ["","","",""],
    "role_3_bullets": ["","","",""],
    "role_4_bullets": ["","","",""],
    "skill_1_label": "", "skill_1_content": "",
    "skill_2_label": "", "skill_2_content": "",
    "skill_3_label": "", "skill_3_content": "",
    "skill_4_label": "", "skill_4_content": "",
    "certifications": ["","","",""]
  }
}

═══════════════════════════════════════════════════════════════
WORKED EXAMPLES — STUDY THESE BEFORE WRITING
═══════════════════════════════════════════════════════════════

GOOD BULLET (role_1, 1-sentence, 24 words):
  "Ran the Friday close-down for a 14-staff Centra; cash variance stayed under €2 across 11 weeks because I double-counted the float before lift."
  WHY IT PASSES: real shop detail, real number, sounds like an actual employee not a CV template, CR3 clean, no buzzwords.

BAD BULLET (will be rejected):
  "Delivered exceptional customer service experiences while leveraging strong communication skills."
  WHY IT FAILS: Delivered + exceptional + leveraging banned, zero verifiable detail, generic.

═══════════════════════════════════════════════════════════════════
RETAIL-MODE ADDITIONS (2026-05-20)
═══════════════════════════════════════════════════════════════════

RETAIL METRIC VOCABULARY (use these in CR3 metric bullets — replaces tech metrics)
UPT (Units Per Transaction) · ATV (Average Transaction Value) · conversion rate (%) · footfall · basket size · mystery-shop score (%) · NPS · CSAT · shrinkage (%) · cash variance (€) · queue wait-time (sec/min) · complaint resolution time · upsell rate (%) · click-and-collect handover time · stock-out incidents · planogram compliance (%) · sell-through rate · markdown % · GMROI · attachment rate
A "CR3 improvement metric" in retail means: % lift in UPT/ATV/conversion vs prior period · % reduction in shrink/wait-time/cash variance · mystery-shop or NPS score climb · stock-out drop.

POS / SYSTEM ALLOWLIST (use exact JD-named tool, else pick from this list when CV mentions a POS)
Square POS · Lightspeed Retail · Shopify POS · Oracle Retail Xstore · Oracle Symphony · SAP Retail / S/4HANA Retail · Centra · SymphonyEYC · Vend (now Lightspeed X-Series) · NCR Counterpoint · Clover · Toast (hospitality crossover) · iZettle · SumUp · Erply · LS Retail · Cegid Retail
Loyalty / CRM: Salesforce Service Cloud · HubSpot · Klaviyo · Endear · Yotpo · Loyalty Lion
Inventory: Brightpearl · Cin7 · Stocky (Shopify) · Fishbowl

SAAS-LEAK BAN (NEVER emit in retail bullets — these are engineering/tech words)
sprint · scrum · stand-up (acceptable: morning huddle) · SLA · p95 · p99 · latency · throughput · pipeline (CI/CD sense) · deployment · stakeholders · roadmap · backlog · velocity · story points · KPI dashboard (acceptable: daily figures, weekly numbers) · prod · staging · ETL · API · webhook · OAuth · JWT
Use shop-floor language instead: "morning briefing", "daily figures", "weekly numbers", "shift handover", "rota change".

PROJECTS-COUNT NOTE
The Retail document template does NOT contain a Projects section. The model MUST OMIT cv_content.projects entirely. Do not invent a projects array.

ANTI-PATTERN (NEVER emit)
"Architected a customer-facing scalable solution" — engineering jargon, banned
"Achieved 100% perfect mystery-shop scores across all visits" — implausible (HV12 round numbers)
"Passionate about delivering exceptional customer experiences" — CR22 AI-tell + CR9 banned passion phrase
"Drove year-over-year double-digit growth single-handedly" — overclaim + HV13 indirect years

═══════════════════════════════════════════════════════════════════
RET-MODE SCHEMA LOCK (2026-05-20 — FIXES CR27 LEAK)
═══════════════════════════════════════════════════════════════════
HARD-LOCKED SCHEMA (cv_content shape — exactly these fields, NO MORE NO LESS):
  professional_tagline · professional_summary
  role_1_bullets[5]  (EXACTLY 5 — never 6, never 4)
  role_2_bullets[4]  (EXACTLY 4)
  role_3_bullets[4]  (EXACTLY 4)
  role_4_bullets[4]  (EXACTLY 4)
  skill_1_label..skill_4_content (EXACTLY 4 categories)
  certifications[4]
  (NO projects field — DO NOT EMIT a projects key under any circumstance)
EMPLOYER NAMES ARE LOCKED to template: role_1=Musgrave Group · role_2=Supermac's Dublin Airport · role_3=CircleK Store Supervisor · role_4=Intercontinental Dublin F&B Assistant
NEVER substitute Dunnes/Carphone Warehouse/Henry Street/any other employer. CR29 applies.
REJECTION: projects array present → CV REJECTED · employer-name mismatch → CV REJECTED · bullet count off → CV REJECTED.

═══════════════════════════════════════════════════════════════════
MASTER RULE SYNC (appended 2026-05-21 — verbatim from master_single_shot.md)
Do not edit below by hand; re-sync via /home/ubuntu/cv-gen/prompts/master_single_shot.md.
═══════════════════════════════════════════════════════════════════

═══════════════════════════════════════════════════════════════════
CR1 — WORD COUNT AND SENTENCE BANDS (synced verbatim from master)
═══════════════════════════════════════════════════════════════════
CR1 — WORD COUNT AND SENTENCE BANDS: Every bullet must be exactly 1, 2, or 3 sentences. 1-sentence means: 22 to 29 words. 2-sentence means: 33 to 40 words. 3-sentence means: 44 to 55 words. No bullet outside these three bands. Never two consecutive bullets from the same band and the same length. Every consecutive pair must also differ by at least 10 words. Bands randomised across roles. Count before outputting. Fail either check = rewrite.

═══════════════════════════════════════════════════════════════════
CR4 — STRUCTURE VARIATION T1-T8 (synced verbatim from master)
═══════════════════════════════════════════════════════════════════
CR4 — STRUCTURE VARIATION: Each role uses at least 6 of these 8 types. No type twice consecutively and never repeat. No type more than once per role. Type positions randomised across roles, if T5 is bullet 3 in one role it cannot be bullet 3 in another. Types: T1 Verb-first ("Shipped a Kotlin module that...") T2 Object-first ("The PostgreSQL schema powering...") T3 Context-first ("Under tight deadline pressure...") T4 Outcome-first ("P95 response time dropped to...") T5 Short declarative ("The webhook processor handled Stripe and Twilio callbacks reliably across the idempotency rewrite.") — T5 GUARD: NEVER place a T5 bullet as the LAST bullet of a role. The closing bullet of every role must end on an engineering outcome, decision, or impact — not on a trivia/duration brag. BANNED closing-bullet patterns: "ran for N months without a single X", "stayed up N days without Y", "never paged once", "without a single restart/rollback/page". These patterns are colloquial and read as casual social-media voice, unacceptable for an enterprise CV. T6 Narrative ("What started as a quick fix turned into...") T7 First-person ("I configured CloudWatch alarms...") exactly once per role T8 Constraint-first ("With no existing test suite..."). Not every bullet gets a full arc. At least 2 bullets per role must have no outcome clause, just the action and what it touched. At least 1 bullet per role must have no context or setup, just raw result or raw fact. If every bullet in a role follows "why then what then result," that role fails CR4 regardless of types used. If two consecutive bullets read with similar rhythm or cadence, even using different types, one must be rewritten. COUNT BEFORE OUTPUT: tag each bullet mentally with its type (T1-T8), then count distinct types in the role. If distinct-count < 6, change the type of the bullet that duplicates a sibling's type. Do not output the role until distinct types ≥ 6 AND no type repeats.

═══════════════════════════════════════════════════════════════════
CR5 — AUTHENTICITY (synced verbatim from master_single_shot.md)
═══════════════════════════════════════════════════════════════════
CR5 — AUTHENTICITY (strictest): CV must pass GPTZero, Originality.ai, It's AI, hireEZ ResumeSense, and Pangram with 0% AI score. Write like a real engineer recalling Tuesday work, not marketing copy.
  PERPLEXITY: pick correct-but-surprising next word, not the statistically obvious one.
  BURSTINESS: consecutive bullets visibly different length.
  TEXTURE: include rough edges — compressed thought, abrupt short sentence, recalled-detail clause.
  PATTERN BAN: never repeat sentence rhythm, clause structure, or transition pattern anywhere in CV.
  UNIQUENESS: if a sentence could appear on 100+ engineers' CVs unchanged, rewrite until only this candidate could claim it.
  ANTI-SIGNATURE: AI writes balanced, hedged, symmetrical sentences. Mix short punchy with one longer messy thought per role.
  SENTENCE UNIQUENESS: every sentence in the CV must be entirely different from every other in structure, rhythm, clause order, and opening pattern. No two sentences may share the same skeleton even if words differ. If two sentences could be diagrammed identically, one must be rewritten.

═══════════════════════════════════════════════════════════════════
BANNED VOCABULARY + BANNED PHRASES (synced verbatim from master)
═══════════════════════════════════════════════════════════════════
**HV1 — BANNED CORPORATE/AI VOCABULARY (zero instances anywhere):**
leveraged, leveraging, leverage (as verb), spearheaded, orchestrated, championed, ideated, synergy, synergized, robust, comprehensive, innovative, cutting-edge, state-of-the-art, best-in-class, holistic, paradigm, paradigm-shift, ecosystem (unless literally the tech term), seamlessly, seamless, streamlined (as adj — verb OK once max), end-to-end (max 1 use across whole CV), utilized, utilize (use "used"), facilitated, empowered, enablement, optimal, optimized (verb past tense OK once per role max), enhanced (max 1 use across whole CV), implemented (max 2 uses across whole CV), delivered (max 2), drove (max 1), strategic, strategically, scalable solutions, mission-critical, value-add, impactful, key stakeholder. ZERO instances. Use plain verbs: built, wrote, shipped, cut, broke, fixed, killed, swapped, replaced, ripped out, moved, ran, owned, debugged, profiled, traced, rolled back, hot-patched.

BANNED PHRASES (case-insensitive, ZERO instances anywhere in CV — summary,
bullets, projects, skills, anywhere):
  leveraged, leveraging, spearheaded, spearheading, synergy, synergies,
  passionate, passion for, results-driven, results-oriented, dynamic,
  proven track record, hit the ground running, think outside the box,
  go-getter, self-starter, detail-oriented, team player, deep dive,
  cutting-edge, state-of-the-art, transformative, best-in-class,
  world-class, robust solution, scalable solution, end-to-end solution,
  not just X but Y, more than just, at the end of the day.

BANNED PUNCTUATION in bullets: em-dash (—), semicolons (;), exclamation marks.
Use plain commas and full stops only.

═══════════════════════════════════════════════════════════════════
AUDIT SCORE BLOCK incl. interview_promise (synced verbatim from master)
═══════════════════════════════════════════════════════════════════
AUDIT SCORE BLOCK — emit AT THE END inside the JSON as a top-level "audit" field:
  "audit": {
    "ats_match_pct": <0-100, % of must_appear_in_bullets present in bullets>,
    "ai_detection_risk_pct": <0-100, count of cadence-uniform or banned-pattern bullets / total bullets * 100>,
    "recruiter_scan_pct": <0-100, % of top_5_keywords hit in summary+first-3-bullets>,
    "interview_promise": <0-100, qualitative score>,
    "missing_jd_keywords": [<list, or [] if none>],
    "gate5_passes_used": <1-3>,
    "gate5_status": "passed"
  }
This audit field is REQUIRED. Missing audit = malformed output.

═══════════════════════════════════════════════════════════════════
RETAIL MODE OVERRIDE (final, supersedes any conflicting rule above)
═══════════════════════════════════════════════════════════════════
BULLET COUNT — ABSOLUTE, NON-NEGOTIABLE, OVERRIDES CR4 AND MASTER LINE 1089:
  role_1_bullets MUST be an array of EXACTLY 5 strings. NEVER 6. NEVER 4.
  role_2_bullets MUST be an array of EXACTLY 4 strings. NEVER 5. NEVER 3.
  role_3_bullets MUST be an array of EXACTLY 4 strings. NEVER 5. NEVER 3.
  role_4_bullets MUST be an array of EXACTLY 4 strings. NEVER 5. NEVER 3.
  After drafting each role, count `role_N_bullets.length` and DELETE the
  weakest bullet if over, or ADD a bullet if under, before output.
  The validator hard-rejects on count mismatch. Master's "role_1=6" line
  applies ONLY to professional mode and is overridden here.

CR4 SCALING FOR SHORT ROLES — OVERRIDES MASTER CR4:
  Master CR4 demands ≥6 distinct T1-T8 types per role. For retail roles
  with fewer than 6 bullets this is mathematically impossible. In retail
  mode the requirement becomes: distinct types per role = `bullet_count`
  (i.e. every bullet uses a DIFFERENT type from T1-T8). For role_1 (5
  bullets) → 5 distinct types. For role_2/3/4 (4 bullets) → 4 distinct
  types. Do NOT add a 6th bullet to satisfy CR4. The bullet count rule
  above is supreme.

CR3 NUMERIC-BULLET CAP — REINFORCED:
  Each role MUST contain 0, 1, or 2 numeric/digit-bearing bullets. NEVER
  3 or more. Numeric = any bullet with a digit 0-9, %, or $. Count
  digit-bearing bullets per role before output. If a role has 3+, rewrite
  the extras to qualitative service outcomes (customer comment, manager
  feedback, regional callout). Validator hard-rejects 3+ numeric per role.


═══════════════════════════════════════════════════════════════════
BULLET OPENER TABLE — RETAIL
═══════════════════════════════════════════════════════════════════

Each bullet has a REQUIRED sentence structure (T#) and 2 START options.
You MUST start the bullet with ONE of the two words listed for that slot,
written EXACTLY as shown. NEVER invent a different opener and NEVER substitute
a synonym. These required start words OVERRIDE every other opener instruction in
this profile (including the verb list above) and in the master prompt.
Word counts are NOT fixed per slot: follow the CR1 bands (22-29 / 33-40 / 44-55)
from the master, span at least 2 of the 3 bands in each role, and vary bullet
lengths so they are never uniform.
Every START word is unique across the whole CV — do not reuse any.

R1B1:  structure: T8 Constraint
  -> MUST start with ONE of:  Solo | Unaided
     (never invent another; pick one of the two)
R1B2:  structure: T2 Object
  -> MUST start with ONE of:  Till | EPOS
     (never invent another; pick one of the two)
R1B3:  structure: T4 Outcome
  -> MUST start with ONE of:  Faultless | Spotless
     (never invent another; pick one of the two)
R1B4:  structure: T10 Time
  -> MUST start with ONE of:  Dawn | Lockup
     (never invent another; pick one of the two)
R1B5:  structure: T3 Context
  -> MUST start with ONE of:  Across | Through
     (never invent another; pick one of the two)
R2B1:  structure: T4 Outcome
  -> MUST start with ONE of:  Endcap | Pallets
     (never invent another; pick one of the two)
R2B2:  structure: T2 Object
  -> MUST start with ONE of:  Aisle | Planogram
     (never invent another; pick one of the two)
R2B3:  structure: T10 Time
  -> MUST start with ONE of:  Overnight | Weekly
     (never invent another; pick one of the two)
R2B4:  structure: T8 Constraint
  -> MUST start with ONE of:  Skeleton | Lean
     (never invent another; pick one of the two)
R3B1:  structure: T3 Context
  -> MUST start with ONE of:  Under | Amid
     (never invent another; pick one of the two)
R3B2:  structure: T10 Time
  -> MUST start with ONE of:  Peak | Holidays
     (never invent another; pick one of the two)
R3B3:  structure: T2 Object
  -> MUST start with ONE of:  Chiller | Forecourt
     (never invent another; pick one of the two)
R3B4:  structure: T4 Outcome
  -> MUST start with ONE of:  Shrink | Wastage
     (never invent another; pick one of the two)
R4B1:  structure: T10 Time
  -> MUST start with ONE of:  Quarterly | Monthly
     (never invent another; pick one of the two)
R4B2:  structure: T4 Outcome
  -> MUST start with ONE of:  SKUs | Variance
     (never invent another; pick one of the two)
R4B3:  structure: T2 Object
  -> MUST start with ONE of:  Stocktake | Rota
     (never invent another; pick one of the two)
R4B4:  structure: T3 Context
  -> MUST start with ONE of:  Within | Despite
     (never invent another; pick one of the two)
═══════════════════════════════════════════════════════════════════
Each bullet MUST follow its T-type. The first word MUST be ONE of the two words
listed for that slot, written exactly — never invent, never swap in a synonym.
Every start in this table is unique — do not reuse any across the whole CV.

ROLE 1 (5)  T8 -> T2 -> T4 -> T10 -> T3
  B1  T8  Constraint   Without     | Solo  [22-29w]
  B2  T2  Object       Floor       | Till  [44-55w]
  B3  T4  Outcome      Two         | Variance  [33-40w]
  B4  T10 Time         During      | Mid-shift  [22-29w]
  B5  T3  Context      Through     | Across  [33-40w]

ROLE 2 (4)  T4 -> T2 -> T10 -> T8
  B1  T4  Outcome      Forty       | Eight  [33-40w]
  B2  T2  Object       Aisle       | Bay  [22-29w]
  B3  T10 Time         After       | Once  [44-55w]
  B4  T8  Constraint   With        | Limited  [33-40w]

ROLE 3 (4)  T3 -> T10 -> T2 -> T4
  B1  T3  Context      Under       | Amid  [22-29w]
  B2  T10 Time         Overnight   | Weekly  [33-40w]
  B3  T2  Object       Chiller     | Promo  [44-55w]
  B4  T4  Outcome      Three       | Twelve  [22-29w]

ROLE 4 (4)  T10 -> T4 -> T2 -> T3
  B1  T10 Time         Quarterly   | Daily  [44-55w]
  B2  T4  Outcome      Six         | Sixty  [22-29w]
  B3  T2  Object       Stocktake   | Rota  [33-40w]
  B4  T3  Context      Within      | Despite  [22-29w]
═══════════════════════════════════════════════════════════════════
