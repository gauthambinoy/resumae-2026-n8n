## PAGE LIMIT (HARD)

HARD LIMIT — STRICTLY 2 PAGES. NEVER 3 PAGES. If your draft exceeds 2 pages on standard A4 (11pt body, 0.5" margins), you MUST cut content until it fits. A 3-page CV is an automatic FAIL and the run is rejected.



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
🚫 BANNED CLAIMS — SPECIFICITY THAT LOOKS LIKE LIES
═══════════════════════════════════════════════════════════════

A bullet can be technically true AND a lie at the same time if it
names a calendar event, a specific hour, an exact gigabyte count, or
a named ex-colleague that belongs to a fake employment history.
These are the FIRST things an interviewer probes. Soften them:

  ❌ "Black Friday spike"            → ✅ "a peak-load event"
  ❌ "2am page on reconciliation"    → ✅ "an early-hours page on the reconciliation flow"
  ❌ "12 GB supplier feeds nightly"  → ✅ state the feed's scale in plain words, no exact byte count (vary it, never a stock phrase)
  ❌ "47-min outage in November"     → ✅ "a multi-hour outage one autumn"
  ❌ "took over after senior X left" → ✅ "took over a stalled service"
  ❌ "during the Q3 release freeze"  → ✅ "during a release-freeze window"
  ❌ "the 2024 acquisition migration"→ ✅ "an acquisition-driven migration"

KEEP the technical content. KEEP the metric (p99, throughput).
DROP the calendar date, the hour, the exact GB number, the named
ex-colleague, the named season. Those are the lies an interviewer
will probe and the candidate cannot defend.


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
  - Technical depth: tools, stacks, patterns, trade-offs.
  - Generic work framing without naming a fake employer.
  - Real-world problem patterns described generically.
  - JD-named tools, JD-named patterns.
  - Numbers tied to GENERIC measurable outcomes (without naming
    the fictional org behind them).

THE TEST: would the bullet still be defensible if the candidate
said "I worked on systems like this, here's how I'd approach it"?
If YES, keep. If the bullet REQUIRES a specific fake employer to
be true, rewrite or drop.

Violation = auto-reject. This rule overrides every other instruction
in this profile.

═══════════════════════════════════════════════════════════════
MODE — GRADUATE CV
═══════════════════════════════════════════════════════════════

PERSONA: Recent MSc graduate. Frame around learning velocity, academic
rigour, foundational depth, and independent contribution from
internships and capstone work. Never claim senior-level ownership, and
never over-claim senior scope: no "owned end-to-end", no "led", no
"mentored", no "architected", no "on-call ownership". Never imply years
of industry experience.

ROLE SLOTS (template-resident — model only writes bullets):
  role_1  : EDUCATION-shaped, MOST-RECENT (postgraduate).  EXACTLY 4 bullets.
            Bullets must sound like shipped work, not coursework summaries.
            Anchor to: dissertation/thesis (problem/method/dataset/result),
            capstone modules and tool-based coursework, group projects,
            experimentation infrastructure (tracking, versioning, seeds, CI).
            No "studied" or "learned about" openings. Show what was built,
            ran, measured, or broke. Post-2023 tools allowed here.
  role_2  : WORK-shaped, pre-postgraduate professional role.  EXACTLY 3 bullets.
            Pre-2023 stack only.
  role_3  : EDUCATION-shaped, undergraduate.  EXACTLY 3 bullets.
            Frame final-year project, mobile/cloud coursework, hackathons,
            foundational tools used with intent. No curriculum descriptions.
            Every bullet is "built X using Y that did Z".
  role_4  : WORK-shaped, internship during postgrad.  EXACTLY 3 bullets.
            Post-2023 tools allowed here (recent internship period).
  role_5  : WORK-shaped, earliest internship.  EXACTLY 3 bullets.
            Pre-2023 stack only. Honest intern scope (assisted, shadowed,
            executed under supervision, but still shipped real work).

SECTIONS:
  professional_tagline : 3-5 words, JD-derived, no tools, no buzzwords.
  [CR9-v2] Summary: VARIED SHAPE — 2 to 4 sentences, roughly 35-75 words total, and the shape MUST vary CV-to-CV (never one reused skeleton). Do NOT force a gerund/-ing opener and do NOT default to "Building / Owning / Shipping / Running"; open however reads strongest and lead with the single strongest defensible JD-relevant proof (a named skill, tool, or method from the JD), pitched honestly at an early-career / graduate level. BANNED template: the "Building <techs>... Owning the path from X through Y... favouring A over B" three-beat shape, and the "X over Y" / "X rather than Y" flourish. NO role-title nouns anywhere (engineer/developer/analyst/manager/supervisor/scientist/assistant/etc). NO seniority labels (senior/junior/lead/graduate/intern/etc). NO digits. NO first-person. See master rule CR9-v2 + GATE 5 CHECK 1b/1c for full ban list.
                         No years-of-experience claim. No seniority labels.
  skills               : EXACTLY 6 \1, JD-derived labels.
  projects             : EXACTLY 3, title + 2-4 sentence description. CR1
                         word-count variance applies.
  certifications       : EXACTLY 4, full official titles only.

STRICT TOOL ERA RULE:
  Tools that did not exist or were not in common production use before
  January 2023 (LLMs like Claude or GPT-4, LangChain, LlamaIndex, RAG,
  Claude Code, Whisper, modern AI agent frameworks, vector DBs like
  pgvector or Pinecone) appear ONLY in role_1 and role_4. role_2, role_3,
  and role_5 stay strictly pre-2023 stack. Violating this fails the CV.

BULLET FRAMING:
  Bullets describe work as the JD persona would have done it. Build the
  CONTENT of every bullet from the JD's named skills, tools, and
  responsibilities, never from the job title or domain alone, and never
  reuse a fixed stock scenario across CVs. Do NOT reference any
  candidate-specific project, employer, or past tool unless the JD
  explicitly names it. Pull JD keywords verbatim into role_1 and
  role_4 where they fit.

METRICS REALISM (HARD):
  Numbers must be plausible for an early-career / graduate candidate,
  freshly derived for THIS CV, varied, and never recycled between runs.
  No enterprise-scale figures (no "millions of users", no multi-gigabyte
  nightly feeds, no headline spend). Do not copy a metric, latency
  figure, or stock phrase from these instructions or a prior CV. Pick a
  fresh, defensible magnitude that fits the JD's named skills, and prefer
  small, honest, checkable numbers a student could actually produce.

OUTPUT JSON SHAPE (exact, no extras, no missing):
{
  "meta": {
    "company": "",
    "role_title": "",
    "template_used": "graduate",
    "location": "",
    "seniority": ""
  },
  "cv_content": {
    "professional_tagline": "",
    "professional_summary": "",
    "role_1_bullets": ["","","",""],
    "role_2_bullets": ["","",""],
    "role_3_bullets": ["","",""],
    "role_4_bullets": ["","",""],
    "role_5_bullets": ["","",""],
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

GOOD BULLET (role_1 internship, 1-sentence, 26 words):
  "Wired a 14-table Postgres schema into a FastAPI service for the placement project, and wrote pytest fixtures that caught two N+1 queries before code review."
  WHY IT PASSES: CR1 band ✅, CR3 clean, T1 framing (concrete artefact + concrete catch), tools named with context, no inflated language for an intern role.

BAD BULLET (will be rejected):
  "Leveraged advanced data structures to architect scalable solutions for complex organisational challenges."
  WHY IT FAILS: 4 banned words (Leveraged, advanced, architect, scalable), zero specificity, sounds like ChatGPT, fails recruiter-8s.

═══════════════════════════════════════════════════════════════════
GRAD-MODE ADDITIONS (2026-05-20)
═══════════════════════════════════════════════════════════════════

GRADUATE-MODE FREE-CERT ALLOWLIST (advisory — master SECTION 9 still authoritative)
Prefer when JD signals:
  Coursera audit-track certificates (any) · DeepLearning.AI Machine Learning Specialization (audit) · DeepLearning.AI Generative AI with LLMs (audit) · freeCodeCamp Responsive Web Design / JavaScript Algorithms / Backend Development · ISC2 Certified in Cybersecurity (CC) · Google Career Certificate IT Support / Data Analytics / Project Management · Trailhead Salesforce ranger / superbadges · Microsoft Learn AZ-900 / AI-900 / DP-900 · GCP Cloud Skills Boost / ACE study path · HubSpot Academy Inbound / Content Marketing · Kaggle 30 Days of ML · fast.ai Practical Deep Learning · Hugging Face NLP Course · edX MIT 6.00.1x audit · CodeAcademy Pro Trial certificates · Cisco Networking Academy free badges
EXCLUDED (paid, never list): AWS paid certs, Microsoft full certifications (MCSA/MCSE/AZ-104 paid), Cisco CCNA paid, Oracle Java SE, ITIL, PMP, PRINCE2, CFA, ACCA.

GROUP-PROJECT AUTHORSHIP RULE (anti-overclaim, mandatory)
If a project was group work, lead the bullet with role-bounded ownership:
  GOOD: "Owned the data-pipeline component of a 4-person dissertation team..."
  GOOD: "Contributed the React frontend to a hackathon team that..."
  BAD:  "Built a real-time analytics platform that..." (implies solo)
Use "the team" or "we" sparingly (CR6 allows T7 first-person ONCE per role). Never imply solo authorship on group work — interviewers will catch this and reject.

DEGREE / GRADE / INSTITUTION META FIELDS
The cv_content.meta object MUST contain (if known): degree (e.g. "MSc Computer Science"), grade (e.g. "Distinction / 2.1 / GPA 3.8"), institution (e.g. "TU Dublin"), graduation_year (e.g. "2026"). If unknown, omit the field — never invent.

GRAD ANTI-PATTERN (never emit)
"Led a team of 12 engineers in a transformative initiative" — implausible at grad level (CR18 ladder violation)
"5+ years of professional experience" — banned (HV13)
"Studied advanced topics including ML, AI, and cloud computing" — CR25 banned opener + vague
"Familiar with industry-standard tools and best practices" — CR22 AI-tell, no concrete tool name

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
BULLET OPENER TABLE — GRADUATE
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

R1B1:  structure: T2 Object
  -> MUST start with ONE of:  Capstone | Thesis
     (never invent another; pick one of the two)
R1B2:  structure: T4 Outcome
  -> MUST start with ONE of:  Distinction | Honours
     (never invent another; pick one of the two)
R1B3:  structure: T10 Time
  -> MUST start with ONE of:  Midterm | Finals
     (never invent another; pick one of the two)
R1B4:  structure: T3 Context
  -> MUST start with ONE of:  Across | Throughout
     (never invent another; pick one of the two)
R2B1:  structure: T8 Constraint
  -> MUST start with ONE of:  Sans | Lacking
     (never invent another; pick one of the two)
R2B2:  structure: T2 Object
  -> MUST start with ONE of:  Brief | Coursework
     (never invent another; pick one of the two)
R2B3:  structure: T10 Time
  -> MUST start with ONE of:  Afterward | Following
     (never invent another; pick one of the two)
R3B1:  structure: T4 Outcome
  -> MUST start with ONE of:  Triple | Quadruple
     (never invent another; pick one of the two)
R3B2:  structure: T10 Time
  -> MUST start with ONE of:  Overnight | Eve
     (never invent another; pick one of the two)
R3B3:  structure: T2 Object
  -> MUST start with ONE of:  Hackathon | Submission
     (never invent another; pick one of the two)
R4B1:  structure: T3 Context
  -> MUST start with ONE of:  Amid | Beyond
     (never invent another; pick one of the two)
R4B2:  structure: T2 Object
  -> MUST start with ONE of:  Placement | Internship
     (never invent another; pick one of the two)
R4B3:  structure: T8 Constraint
  -> MUST start with ONE of:  Solo | Paired
     (never invent another; pick one of the two)
R5B1:  structure: T10 Time
  -> MUST start with ONE of:  Weekly | Quarterly
     (never invent another; pick one of the two)
R5B2:  structure: T4 Outcome
  -> MUST start with ONE of:  Sixfold | Twelvefold
     (never invent another; pick one of the two)
R5B3:  structure: T2 Object
  -> MUST start with ONE of:  Tutorial | Lab
     (never invent another; pick one of the two)
═══════════════════════════════════════════════════════════════════
Each bullet MUST follow its T-type. The first word MUST be ONE of the two words
listed for that slot, written exactly — never invent, never swap in a synonym.
Every start in this table is unique — do not reuse any across the whole CV.

ROLE 1 (4)  T2 -> T4 -> T10 -> T3
  B1  T2  Object       Capstone    | Module  [22-29w]
  B2  T4  Outcome      Marks       | Grade  [33-40w]
  B3  T10 Time         During      | Mid-semester  [44-55w]
  B4  T3  Context      Across      | Through  [22-29w]

ROLE 2 (3)  T8 -> T2 -> T10
  B1  T8  Constraint   Without     | Limited  [22-29w]
  B2  T2  Object       Project     | Brief  [44-55w]
  B3  T10 Time         After       | Once  [33-40w]

ROLE 3 (3)  T4 -> T10 -> T2
  B1  T4  Outcome      Two         | Three  [22-29w]
  B2  T10 Time         Overnight   | Pre-demo  [44-55w]
  B3  T2  Object       Hackathon   | Submission  [33-40w]

ROLE 4 (3)  T3 -> T2 -> T8
  B1  T3  Context      Under       | Amid  [22-29w]
  B2  T2  Object       Placement   | Internship  [33-40w]
  B3  T8  Constraint   Solo        | With  [44-55w]

ROLE 5 (3)  T10 -> T4 -> T2
  B1  T10 Time         Weekly      | Quarterly  [33-40w]
  B2  T4  Outcome      Six         | Twelve  [22-29w]
  B3  T2  Object       Tutorial    | Lab  [44-55w]
═══════════════════════════════════════════════════════════════════
