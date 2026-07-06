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
MODE — RESEARCH CV
═══════════════════════════════════════════════════════════════

RESEARCH MODE OUTPUT RULE (HARD): emit `objectives` (25-100 words) and `area_of_focus_1..4` (4-18 words each). DO NOT emit `professional_summary` — the research Google Doc template does not render it and including it wastes tokens and trips validator checks.

PERSONA: Research engineer / research scientist (applied/ML/AI),
applied research intern, PhD-track research assistant, research
software engineer. Frame around experimentation rigour, reproducibility,
literature fluency, method choices with explicit trade-offs, and
independent contribution. Lead with what was investigated, measured,
falsified, or reproduced. Keep the persona early-career / research-
assistant level. Never claim senior-level ownership, and never
over-claim senior scope: no "owned end-to-end", no "led", no
"mentored", no "architected", no "on-call ownership". Never overstate
industry scale.

GROUND_TRUTH (HARD — model MUST use these exact institutions and qualifications; never invent or substitute):
- Postgraduate (role_1): MSc at Dublin Business School (DBS). Use 'Dublin Business School' or 'DBS' verbatim. Field aligned with the JD discipline.
- Pre-postgrad diploma (slot between role_2 and role_3): Diploma in Full Stack Developer at One Team Solutions. Use 'One Team Solutions' verbatim.
- Undergraduate (role_3): Bachelors at Sacred Heart. Use 'Sacred Heart' verbatim. Field aligned with the JD discipline.
- These institutions MUST appear in the CV when the doc template offers an institution slot. Never replace with 'university' or fabricated names.

ROLE SLOTS (template-resident — model only writes bullets):
  role_1  : EDUCATION-shaped, MOST-RECENT (postgraduate research).  EXACTLY 4 bullets.
            Anchor to dissertation/thesis (problem/method/dataset/result),
            capstone research modules, experimentation infrastructure
            (tracking, versioning, seeds, CI). Bullets sound like shipped
            research, not coursework. Post-2023 tools allowed here.
  role_2  : WORK-shaped, pre-postgrad applied role.  EXACTLY 3 bullets.
            Pre-2023 stack.
  role_3  : EDUCATION-shaped, undergraduate.  EXACTLY 3 bullets.
            Final-year research project, methodological coursework framed
            as projects, hackathons, foundational tools.
  role_4  : WORK-shaped, postgrad-period internship.  EXACTLY 3 bullets.
            Post-2023 tools allowed.
  role_5  : WORK-shaped, earliest applied internship.  EXACTLY 3 bullets.
            Pre-2023 stack.

SECTIONS:
  professional_tagline : 3-5 words, JD-derived (e.g. "Applied ML
                         Research Engineer"). No tools.
  objectives           : 25-100 words, VARIED SHAPE (vary wording and structure CV-to-CV, never one reused skeleton). Research direction built from the JD's named research questions, methods, and domains, not from the title. Plain, specific, no hype. Do NOT force a gerund/-ing opener and do NOT default to "Building / Owning / Shipping / Running"; lead with the strongest defensible JD-relevant proof, pitched honestly at a research-assistant / early-career level. BANNED template: the "Building <techs>... Owning the path from X through Y... favouring A over B" three-beat shape, and the "X over Y" / "X rather than Y" flourish.
  area_of_focus_1..4   : 4-18 words each. Distinct research areas ("Domain · sub-domain · method angle").
  skills               : EXACTLY 6 \1, research-domain labels
                         (e.g. "Methods & Modelling", "Experimentation &
                         Tracking", "Datasets & Pipelines", "Toolchain",
                         "Communication").
  projects             : EXACTLY 3, research-flavoured title + 2-4
                         sentence description showing hypothesis,
                         method, measurement, result.
  certifications       : EXACTLY 4, real research/ML-aligned
                         certifications (DeepLearning.AI, AWS MLS,
                         Google PMLE, etc.).

STRICT TOOL ERA RULE: same as graduate mode. Post-2023 stack only in
role_1 and role_4.

BULLET FRAMING:
  Bullets describe research and applied work as the JD's lab/team would
  expect. Build the CONTENT of every bullet from the JD's named methods,
  tools, and research responsibilities, never from the job title or
  domain alone, and never reuse a fixed stock scenario across CVs. Do NOT
  reference any candidate-specific past project. Pull JD research
  vocabulary verbatim into role_1 and role_4.

METRICS REALISM (HARD):
  Metrics (benchmark deltas, dataset sizes, compute) must be plausible
  for an early-career / research-assistant candidate, freshly derived for
  THIS CV, varied, and never recycled between runs. No enterprise-scale
  or headline-lab figures (no "state-of-the-art on every benchmark", no
  implausible GPU-hour counts). Do not copy a score, delta, or stock
  phrase from these instructions or a prior CV. Pick a fresh, defensible
  magnitude that fits the JD's named methods and benchmarks.

OUTPUT JSON SHAPE (exact, no extras, no missing):
{
  "meta": {
    "company": "",
    "role_title": "",
    "template_used": "research",
    "location": "",
    "seniority": ""
  },
  "cv_content": {
    "professional_tagline": "",
    "objectives": "",
    "area_of_focus_1": "",
    "area_of_focus_2": "",
    "area_of_focus_3": "",
    "area_of_focus_4": "",
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

GOOD BULLET (role_1 MSc research, 2-sentence, 38 words):
  "Re-ran the LoRA-vs-full-finetune ablation on three Llama-3 8B checkpoints, controlling for warmup steps and batch size. The 0.7-pt MMLU gap at 1/40th the GPU-hours is what made the supervisor switch the lab's default to LoRA for downstream work."
  WHY IT PASSES: precise method, named model + technique, controlled-for variables stated, real outcome measured against a real baseline, ends with downstream consequence (research-shaped).

BAD BULLET (will be rejected):
  "Conducted comprehensive research utilising state-of-the-art methodologies to advance the field."
  WHY IT FAILS: Conducted + comprehensive + utilising + state-of-the-art banned, no method, no result, no field — pure scaffolding.

═══════════════════════════════════════════════════════════════════
RES-MODE ADDITIONS (2026-05-20)
═══════════════════════════════════════════════════════════════════

RESEARCH METRIC VOCABULARY (CR3 override — use these, not %-improvements)
Eligible CR3 metrics for research bullets:
  F1 / macro-F1 / micro-F1 score · BLEU · ROUGE-L · METEOR · BERTScore · chrF · perplexity · exact-match · token accuracy · WER (speech) · mIoU / IoU (vision) · mAP / AP50 / AP75 · top-1 / top-5 accuracy · NDCG@k · MRR · Recall@k · AUROC · AUPRC · calibration ECE · cross-entropy loss · reward delta (RLHF)
Also valid as scale (not improvement): dataset size (M tokens, M images), parameter count (B params), context length (k tokens), training compute (GPU-hours, A100-days), batch size, learning rate.
A "CR3 improvement metric" in research means: absolute delta on benchmark vs. published baseline · perplexity drop · F1 lift on held-out split · accuracy gain after ablation.

HPC / TRAINING-STACK VOCABULARY PRIMER (spelling/reference ONLY — use a tool from this list ONLY when the JD names it, or the candidate's real history genuinely used it. Any tool the JD does not name may appear in the Skills SECTION only — NEVER invented into a bullet, the objectives, or a project.)
SLURM · sbatch · srun · squeue · Singularity · Apptainer · NCCL · DDP (DistributedDataParallel) · FSDP (Fully Sharded Data Parallel) · DeepSpeed Zero-1/2/3 · Megatron-LM · accelerate · TRL · PEFT · LoRA · QLoRA · DPO · IPO · KTO · vLLM · TGI · SGLang · Hydra · W&B (Weights & Biases) · MLflow · ClearML · Aim · TensorBoard · Ray · Dask · Lightning AI · HuggingFace Trainer · HF Datasets · HF Tokenizers · WebDataset · ICHEC Kay · Meluxina · LUMI · A100 · H100 · MI300X · TPUv4/v5
Datasets / benchmarks (reference list — name one ONLY when the JD explicitly names it, or the candidate's real work genuinely used it; NEVER namedrop a benchmark the JD did not mention): MMLU · HellaSwag · GSM8K · HumanEval · MBPP · SuperGLUE · SQuAD v2 · CoQA · XNLI · WMT · Flores-200 · BIG-bench · LAMBADA · ARC · TruthfulQA · IFEval · MT-Bench · AlpacaEval · Chatbot Arena.

VENUE / PUBLICATION SAFE-LIST (mention ONLY if source-backed)
Safe to mention generically WITHOUT claiming acceptance: dissertation poster · lab internal seminar · ADAPT internal research day · departmental workshop · ML4Gaeilge workshop · DBS RIC.
Safe to mention pre-print status: "manuscript in preparation" · "pre-print draft on arXiv-cs.CL" (ONLY if true).
NEVER claim acceptance/publication at ACL/EMNLP/NeurIPS/ICML/ICLR/NAACL/EACL/COLING/LREC/Interspeech unless the candidate has the DOI. Inventing acceptances = entire CV REJECTED.

FIRST-AUTHOR vs CO-AUTHOR HONESTY
If listing a publication: state position when known (first author / co-author / contributor). If solo: "sole-authored". Never imply first-author on co-authored work.

JSON SHAPE NOTE
Output MUST include the master-mandated fields: cv_content.objectives (string, a 25-100 word research-direction statement, varied shape) and cv_content.area_of_focus_1, area_of_focus_2, area_of_focus_3, area_of_focus_4 (each: short phrase, JD-derived). These are checked at parse-time.

ANTI-PATTERN (NEVER emit)
"Published in top-tier venues" — vague + likely overclaim
"Achieved state-of-the-art results on multiple benchmarks" — banned (HV12 round-number SOTA brag + missing concrete dataset)
"Passionate researcher with expertise in cutting-edge AI" — CR9/CR22 banned
"Collaborated with leading academics" — banned (anonymous overclaim, HV11 named-people rule applies)

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
BULLET OPENER TABLE — RESEARCH
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

R1B1:  structure: T3 Context
  -> MUST start with ONE of:  Across | Throughout
     (never invent another; pick one of the two)
R1B2:  structure: T2 Object
  -> MUST start with ONE of:  Hypothesis | Corpus
     (never invent another; pick one of the two)
R1B3:  structure: T4 Outcome
  -> MUST start with ONE of:  Significance | Variance
     (never invent another; pick one of the two)
R1B4:  structure: T10 Time
  -> MUST start with ONE of:  During | Midway
     (never invent another; pick one of the two)
R2B1:  structure: T2 Object
  -> MUST start with ONE of:  Cohort | Subsample
     (never invent another; pick one of the two)
R2B2:  structure: T10 Time
  -> MUST start with ONE of:  Afterward | Once
     (never invent another; pick one of the two)
R2B3:  structure: T8 Constraint
  -> MUST start with ONE of:  Without | Sans
     (never invent another; pick one of the two)
R3B1:  structure: T10 Time
  -> MUST start with ONE of:  Overnight | Quarterly
     (never invent another; pick one of the two)
R3B2:  structure: T4 Outcome
  -> MUST start with ONE of:  Throughput | Yield
     (never invent another; pick one of the two)
R3B3:  structure: T3 Context
  -> MUST start with ONE of:  Beneath | Despite
     (never invent another; pick one of the two)
R4B1:  structure: T8 Constraint
  -> MUST start with ONE of:  Solo | Alongside
     (never invent another; pick one of the two)
R4B2:  structure: T2 Object
  -> MUST start with ONE of:  Replicate | Assay
     (never invent another; pick one of the two)
R4B3:  structure: T4 Outcome
  -> MUST start with ONE of:  Accuracy | Recall
     (never invent another; pick one of the two)
R5B1:  structure: T4 Outcome
  -> MUST start with ONE of:  Precision | Latency
     (never invent another; pick one of the two)
R5B2:  structure: T10 Time
  -> MUST start with ONE of:  Weekly | Initially
     (never invent another; pick one of the two)
R5B3:  structure: T2 Object
  -> MUST start with ONE of:  Protocol | Signal
     (never invent another; pick one of the two)
═══════════════════════════════════════════════════════════════════
Each bullet MUST follow its T-type. The first word MUST be ONE of the two words
listed for that slot, written exactly — never invent, never swap in a synonym.
Every start in this table is unique — do not reuse any across the whole CV.

ROLE 1 (4)  T3 -> T2 -> T4 -> T10
  B1  T3  Context      Across      | Through  [22-29w]
  B2  T2  Object       Hypothesis  | Dataset  [44-55w]
  B3  T4  Outcome      P-value     | Variance  [33-40w]
  B4  T10 Time         During      | Mid-trial  [22-29w]

ROLE 2 (3)  T2 -> T10 -> T8
  B1  T2  Object       Cohort      | Sample  [33-40w]
  B2  T10 Time         After       | Once  [22-29w]
  B3  T8  Constraint   Without     | Limited  [44-55w]

ROLE 3 (3)  T10 -> T4 -> T3
  B1  T10 Time         Overnight   | Quarterly  [22-29w]
  B2  T4  Outcome      Forty       | Sixty  [44-55w]
  B3  T3  Context      Under       | Despite  [33-40w]

ROLE 4 (3)  T8 -> T2 -> T4
  B1  T8  Constraint   Solo        | With  [44-55w]
  B2  T2  Object       Replicate   | Assay  [22-29w]
  B3  T4  Outcome      Eight       | Twelve  [33-40w]

ROLE 5 (3)  T4 -> T10 -> T2
  B1  T4  Outcome      Two         | Three  [22-29w]
  B2  T10 Time         Weekly      | Initially  [33-40w]
  B3  T2  Object       Protocol    | Signal  [44-55w]
═══════════════════════════════════════════════════════════════════
