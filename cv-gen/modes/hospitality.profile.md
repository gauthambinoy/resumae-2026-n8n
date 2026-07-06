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
MODE — HOSPITALITY & HOTELS CV
═══════════════════════════════════════════════════════════════

PERSONA: Front-of-house hotel + F&B professional. Frame around guest
experience, multi-shift operations, PMS systems (Opera, OnQ, Protel),
POS (Micros, Lightspeed), reservations, group bookings, upselling,
service recovery, brand standards (IHG/Marriott/Hilton), HACCP,
allergen handling, multilingual guest comms, VIP protocols, and the
calm under-pressure rhythm of a 200-cover dinner service or a 95%
occupancy weekend. Tone: confident hospitality lifer telling a
fellow ops manager what they actually fixed last week.

ROLE SLOTS (template-resident — fixed titles/dates in doc body):
  role_1 : InterContinental Dublin (F&B / Customer Service Specialist).
           Feb 2024 - Dec 2025 | Dublin, Ireland. EXACTLY 6 bullets.
           Modern hospitality stack (Opera Cloud, OpenTable, Lightspeed,
           IHG Concerto) appears ONLY here.
  role_2 : Crowne Plaza (Hotel Ops & Front Office Associate).
           Feb 2021 - Sep 2023 | Kochi, India. EXACTLY 5 bullets.
  role_3 : Vadakkan's Home (Hotel Ops & Front Office Associate).
           Sep 2019 - Dec 2021 | Kochi, India. EXACTLY 5 bullets.

SECTIONS:
  [CR9-v2] Summary: open Sentence 1 with a GERUND (-ing verb describing work, e.g. Building / Shipping / Owning / Running / Leading / Delivering). EXACTLY 3 sentences total (S1≤22w, S2≤28w, S3≤32w, ≤80w total). NO role-title nouns anywhere (engineer/developer/analyst/manager/supervisor/scientist/assistant/etc). NO seniority labels (senior/junior/lead/graduate/intern/etc). NO digits. NO first-person. See master rule CR9-v2 + GATE 5 CHECK 1b/1c for full ban list.
                         JD vocabulary (hotel brand, role family).
                         Second = outcome (guest satisfaction lift,
                         RevPAR contribution, complaint-resolution speed,
                         upsell conversion). Third = brand-standards +
                         tools authenticity.
  skills               : EXACTLY 6 categories, JD-derived labels.
                         8-10 items each. Hospitality vocabulary
                         mandatory: PMS, POS, reservations, group
                         bookings, HACCP, allergen training, brand
                         standards, GuestExperience SOPs, service
                         recovery (LEARN model), upselling.
  projects             : EXACTLY 3, hospitality-relevant initiatives
                         the candidate ran (theme nights, SOP rewrites,
                         service-recovery wins, training rollouts).
  certifications       : EXACTLY 4 from the free-cert allowlist
                         (HACCP basic, IHG Concerto onboarding,
                         Trailhead Service Cloud, Google Hospitality
                         Career Certificate equivalents).

BULLET FRAMING:
  Every bullet describes a real shift-floor moment. Cover at minimum:
  guest interaction + system used + outcome. Examples: "Re-routed a
  late-arriving wedding group of 24 through Opera Cloud after the
  block release window had closed, holding ADR and avoiding a comp."
  Avoid: vague "customer service" sentences with no system, brand, or
  outcome.

OUTPUT JSON SHAPE (exact, no extras, no missing) — SAME AS PROFESSIONAL:
{
  "meta": {
    "company": "",
    "role_title": "",
    "template_used": "hospitality",
    "location": "",
    "seniority": ""
  },
  "cv_content": {
    "professional_tagline": "",
    "professional_summary": "",
    "role_1_bullets": ["","","","","",""],
    "role_2_bullets": ["","","","",""],
    "role_3_bullets": ["","","","",""],
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

ALL CR rules apply unchanged (CR0/SACRED, CR1-CR24, HV11-HV19).

═══════════════════════════════════════════════════════════════════
HS-MODE ADDITIONS (2026-05-20)
═══════════════════════════════════════════════════════════════════

HOSPITALITY METRIC VOCABULARY (CR3 override — use these, NOT tech metrics)
F&B / Restaurant: covers per service · check average (€) · upsell rate (%) · attachment rate · table turn-time · seat utilisation · F&B GOP · wine attachment · dessert attachment · void rate · comp rate
Hotel / Rooms: ADR (Average Daily Rate) · RevPAR · TRevPAR · GOPPAR · occupancy (%) · capture ratio · ALOS · ARI · MPI · RGI · cancellation rate · no-show rate · walk-in conversion
Service quality: Forbes inspection score · AA rating · TripAdvisor rank · Google review average · Medallia score · LQA score · mystery-shop · GuestRevu · ReviewPro GRI · complaint resolution time · service recovery cost (€)
A "CR3 improvement metric" in hospitality means: % lift in upsell/attachment/check-avg · ADR/RevPAR climb vs prior period · Forbes/AA rating uplift · review-score increase · waste/comp/void reduction (%) · turn-time drop (min).

HOSPITALITY SYSTEM ALLOWLIST (use exact JD-named tool or pick from this list)
POS: Micros Simphony · Micros 9700 · Oracle Hospitality OPERA POS · Toast · Lightspeed Restaurant (formerly K-Series) · Square for Restaurants · TouchBistro · Aloha by NCR · Revel Systems · PAR Brink
PMS / Reservation: Opera Cloud · Opera PMS · OnQ (Hilton) · Marsha (Marriott) · Concerto (IHG) · Maestro · Mews · Cloudbeds · Protel Air · Apaleo · RoomKeyPMS · LightSpeed Hotel
Reservation booking: OpenTable · SevenRooms · ResDiary · Quandoo · TheFork (LaFourchette) · Eveve · TableAgent
Distribution / channel: Synxis · SiteMinder · DerbySoft · Cendyn · Pegasus · Expedia Partner Central · Booking.com Extranet
Loyalty: Marriott Bonvoy · Hilton Honors · IHG One Rewards · World of Hyatt · Accor Live Limitless

HOSPITALITY-RELEVANT CERT ALLOWLIST (free issuers only)
HACCP Level 1/2/3 · WSET Level 1/2 in Wines · WSET Level 1 in Spirits · WSET Level 1 in Sake · Responsible Service of Alcohol (RSA / Bar Service course) · EU FIC 1169/2011 Allergens course · Manual Handling certificate · Fire Warden / Fire Safety · Patrol/Door Supervisor · Food Safety Level 2/3 · Marriott LearningZone modules · Hilton University free badges · AHLEI Certified Hospitality Supervisor (free intro) · Typsy free hospitality courses · Trailhead Service Cloud Hospitality · Coursera Hotel Management audit · Google Hospitality Career Certificate (audit) · Salesforce Trailhead Concierge Service Cloud
PAID / EXCLUDED (never list): WSET Level 3+ (paid only), AHLEI full certs (paid), Cornell HEC certificates.

ANTI-FABRICATION HARD GUARD (HS SPECIFIC)
NEVER invent: Michelin stars (1/2/3-star) at properties the candidate did not work at · AA Rosettes (1/2/3/4/5) · Forbes 5-Star rating without proof · MICHELIN Bib Gourmand · World 50 Best ranking · celebrity guest interactions (named or unnamed) · TV appearances · Royal Warrant work · Olympic Village service · papal visit service · State Banquet service
ALLOWED: factual employer names, factual covers/room counts, factual award levels of the PROPERTY (not personal), generic "VIP guest", "high-profile event", "private dining".

JD-VERBATIM TOOL CONTRACT
When the JD names ANY of these, the CV MUST echo the EXACT same token verbatim at least once: Micros Simphony · OpenTable · SevenRooms · Opera Cloud · OnQ · WSET · HACCP · EU 1169/2011 · Forbes 5-Star · AA · Bonvoy · Hilton Honors. Generic synonyms ("the POS system", "the reservation platform") do not count.

WORKED GOOD EXAMPLES (add to existing)
1. "The wedding block at the InterContinental ran 220 covers across a 4-hour service window with three dietary subsets handled through SevenRooms VIP tags; capture ratio held at 87% on the upsell." (35 words · CR1 2-sentence band · concrete tool · real KPI)
2. "Forbes inspectors flagged glassware polish during the spring audit; the floor team rebuilt the side-station rota by Monday and the next pass cleared without callback." (26 words · CR1 1-sentence band · service-recovery narrative)
3. "Check average climbed from EUR48 to EUR62 across the Saturday dinner cover over six weeks after the team rebuilt the wine pairing section with WSET Level 2 attachments." (30 words · CR3 metric · WSET verbatim · real F&B math)
4. "The OpenTable VIP tag system caught a guest preference conflict five minutes before service; the kitchen swapped two amuse-bouches and the table never noticed." (25 words · service-recovery + tool verbatim)

BAD ANTI-PATTERN (NEVER emit)
"Delivered exceptional 5-star service to VIP clientele" — CR22 AI-tell + vague + likely fabrication
"Achieved Michelin star recognition during tenure" — FABRICATION GUARD violation
"Passionate about creating memorable guest experiences" — CR9 + CR22 banned
"Increased revenue by 50% through innovative service strategies" — HV12 round-number + CR17 vague metric

═══════════════════════════════════════════════════════════════════
MASTER RULE SYNC (appended 2026-05-21 — verbatim from master_single_shot.md)
Do not edit below by hand; re-sync via /home/ubuntu/cv-gen/prompts/master_single_shot.md.
═══════════════════════════════════════════════════════════════════

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
HOSPITALITY MODE OVERRIDE (final, supersedes any conflicting rule above)
═══════════════════════════════════════════════════════════════════
BULLET COUNT — ABSOLUTE, NON-NEGOTIABLE:
  role_1_bullets MUST be an array of EXACTLY 6 strings.
  role_2_bullets MUST be an array of EXACTLY 5 strings.
  role_3_bullets MUST be an array of EXACTLY 5 strings.
  Count `role_N_bullets.length` after drafting; trim or pad before output.

CR4 SCALING FOR 5-BULLET ROLES — OVERRIDES MASTER CR4:
  Master CR4 demands ≥6 distinct T1-T8 types per role. For hospitality
  role_2 and role_3 (5 bullets each) this is impossible. The requirement
  becomes: 5 distinct types in role_2 and role_3 (every bullet uses a
  different T1-T8 type). role_1 still uses 6 distinct types across its 6
  bullets. Do NOT add a 6th bullet to role_2 or role_3 to satisfy CR4.

CR3 NUMERIC-BULLET CAP — REINFORCED (this caused the last validator fail):
  Each role MUST contain 0, 1, or 2 numeric/digit-bearing bullets. NEVER
  3 or more. Numeric = any bullet with a digit 0-9, %, or $. After
  drafting role_3, count digit-bearing bullets. If 3+, rewrite the extras
  to qualitative service outcomes (guest comment-card, GM callout,
  TripAdvisor mention, banquet captain feedback) — keep at most 2 with
  digits. Validator hard-rejects 3+ numeric per role.


═══════════════════════════════════════════════════════════════════
BULLET OPENER TABLE — HOSPITALITY
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

R1B1:  structure: T10 Time
  -> MUST start with ONE of:  Lunchtime | Briefing
     (never invent another; pick one of the two)
R1B2:  structure: T2 Object
  -> MUST start with ONE of:  Brigade | Pass
     (never invent another; pick one of the two)
R1B3:  structure: T8 Constraint
  -> MUST start with ONE of:  Solo | Shorthanded
     (never invent another; pick one of the two)
R1B4:  structure: T4 Outcome
  -> MUST start with ONE of:  Michelin | Starred
     (never invent another; pick one of the two)
R1B5:  structure: T3 Context
  -> MUST start with ONE of:  Across | Throughout
     (never invent another; pick one of the two)
R1B6:  structure: T2 Object
  -> MUST start with ONE of:  Cover | Banquet
     (never invent another; pick one of the two)
R2B1:  structure: T4 Outcome
  -> MUST start with ONE of:  Seconds | Nil
     (never invent another; pick one of the two)
R2B2:  structure: T3 Context
  -> MUST start with ONE of:  Amid | Beneath
     (never invent another; pick one of the two)
R2B3:  structure: T2 Object
  -> MUST start with ONE of:  Tab | Cellar
     (never invent another; pick one of the two)
R2B4:  structure: T10 Time
  -> MUST start with ONE of:  Closing | Nightly
     (never invent another; pick one of the two)
R2B5:  structure: T8 Constraint
  -> MUST start with ONE of:  Understaffed | Walkins
     (never invent another; pick one of the two)
R3B1:  structure: T2 Object
  -> MUST start with ONE of:  Float | Sommelier
     (never invent another; pick one of the two)
R3B2:  structure: T8 Constraint
  -> MUST start with ONE of:  Allergens | Voided
     (never invent another; pick one of the two)
R3B3:  structure: T4 Outcome
  -> MUST start with ONE of:  LQA | HACCP
     (never invent another; pick one of the two)
R3B4:  structure: T10 Time
  -> MUST start with ONE of:  Overnight | Weekly
     (never invent another; pick one of the two)
R3B5:  structure: T3 Context
  -> MUST start with ONE of:  Within | Despite
     (never invent another; pick one of the two)
═══════════════════════════════════════════════════════════════════
Each bullet MUST follow its T-type. The first word MUST be ONE of the two words
listed for that slot, written exactly — never invent, never swap in a synonym.
Every start in this table is unique — do not reuse any across the whole CV.

ROLE 1 (6)  T10 -> T2 -> T8 -> T4 -> T3 -> T2
  B1  T10 Time         During      | Mid-rush  [44-55w]
  B2  T2  Object       Service     | Function  [22-29w]
  B3  T8  Constraint   Without     | Solo  [33-40w]
  B4  T4  Outcome      Hundred     | Forty  [22-29w]
  B5  T3  Context      Through     | Across  [44-55w]
  B6  T2  Object       Pass        | Cover  [33-40w]

ROLE 2 (5)  T4 -> T3 -> T2 -> T10 -> T8
  B1  T4  Outcome      Two         | Eight  [22-29w]
  B2  T3  Context      Under       | Amid  [33-40w]
  B3  T2  Object       Bar         | Tab  [44-55w]
  B4  T10 Time         After       | Once  [22-29w]
  B5  T8  Constraint   With        | Limited  [33-40w]

ROLE 3 (5)  T2 -> T8 -> T4 -> T10 -> T3
  B1  T2  Object       Banquet     | Float  [33-40w]
  B2  T8  Constraint   Tight       | Lacking  [44-55w]
  B3  T4  Outcome      Three       | Six  [22-29w]
  B4  T10 Time         Overnight   | Weekly  [33-40w]
  B5  T3  Context      Within      | Despite  [22-29w]
═══════════════════════════════════════════════════════════════════
