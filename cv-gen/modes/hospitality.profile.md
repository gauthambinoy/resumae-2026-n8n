HOSPITALITY MODE PROFILE — follows the master prompt, never repeats it.
Candidate injection OFF: generate from JD + hospitality persona + the fixed history below.
Supplies ONLY per-mode items (titles, fixed history, vocab, certs, opener table). All CR/HV/GATE rules live in the master and apply unchanged.

MODE FACTS (validator-enforced): 3 roles · bullets 6 / 5 / 5 · 6 skills · 3 projects · 4 certifications ·
summary field = professional_summary · NO experiences_used · candidate injection OFF.
JSON shape is identical to the professional template (professional_tagline, professional_summary,
role_1/2/3_bullets, skill_1..6_label/content, project_1..3_title/desc, certifications[4], audit) — do not add or drop keys.

═══════════════════════════════════════════════════════════════════
## meta.role_title — HOSPITALITY TITLES
═══════════════════════════════════════════════════════════════════
Match the JD title verbatim when it names one. Otherwise pick the closest of:
Front Office Agent · Receptionist · Guest Service Agent · F&B Assistant ·
Food & Beverage Attendant · Restaurant Server · Front of House Team Member ·
Guest Relations Agent · Hotel Receptionist.

═══════════════════════════════════════════════════════════════════
## FIXED EMPLOYER HISTORY (template-resident — injection is OFF, use VERBATIM)
═══════════════════════════════════════════════════════════════════
Titles, companies, dates and locations are hard-printed in the Doc body. Do NOT invent, move,
or re-date them. Generate ONLY the bullet text for each role.

  role_1 : InterContinental Dublin — F&B / Customer Service Specialist
           Feb 2024 - Dec 2025 | Dublin, Ireland | EXACTLY 6 bullets
           The modern hospitality stack (Opera Cloud, OpenTable, Lightspeed, IHG Concerto)
           appears ONLY here — never in role_2 or role_3.
  role_2 : Crowne Plaza — Hotel Ops & Front Office Associate
           Feb 2021 - Sep 2023 | Kochi, India | EXACTLY 5 bullets
  role_3 : Vadakkan's Home — Hotel Ops & Front Office Associate
           Sep 2019 - Dec 2021 | Kochi, India | EXACTLY 5 bullets

  ⚠️ DOC SLOT MAPPING QUIRK — READ BEFORE FILLING BULLETS:
  The Doc template fills its experience bullets from role_1 / role_2 / role_3, BUT the third
  role renders into the Doc's ROLE_4 slot (there is no ROLE_3 placeholder in this template).
  So: role_1_bullets → ROLE_1, role_2_bullets → ROLE_2, role_3_bullets → ROLE_4.
  Emit the JSON keys exactly as role_1_bullets / role_2_bullets / role_3_bullets — the Doc merge
  handles the role_3 → ROLE_4 mapping. Do NOT rename keys and do NOT misfile role_3 content.

═══════════════════════════════════════════════════════════════════
## HOSPITALITY VOCAB, SYSTEMS, METRICS + CERTS + ANTI-FABRICATION GUARD
═══════════════════════════════════════════════════════════════════

SYSTEMS (use the JD-named tool verbatim; else pick from here):
  PMS / Reservation : Opera Cloud · Opera PMS · OnQ (Hilton) · Marsha (Marriott) ·
                      Concerto (IHG) · Mews · Protel · Cloudbeds
  POS               : Micros Simphony · Micros 9700 · Oracle OPERA POS · Toast ·
                      Lightspeed Restaurant · Aloha by NCR
  Reservation book. : OpenTable · SevenRooms · ResDiary · TheFork
  Distribution      : SiteMinder · Synxis
  Loyalty           : Marriott Bonvoy · Hilton Honors · IHG One Rewards

METRICS (CR3 in hospitality = one of these, NOT tech metrics):
  F&B    : covers per service · check average (€) · upsell / attachment rate (%) ·
           table turn-time · void / comp rate
  Rooms  : ADR · RevPAR · TRevPAR · GOPPAR · occupancy (%) · ALOS ·
           no-show / cancellation rate · walk-in conversion
  Service: review-score average · complaint-resolution time · mystery-shop / LQA score

SKILL / SERVICE CONCEPTS (hospitality vocabulary mandatory across the 6 skill groups):
  PMS · POS · reservations · group bookings · upselling · service recovery (LEARN / LEAST model) ·
  allergen handling (EU FIC 1169/2011) · HACCP · brand standards (IHG / Marriott / Hilton) ·
  guest-experience SOPs · VIP protocols · multilingual guest comms.

JD-VERBATIM TOOL CONTRACT: when the JD names any of Opera Cloud · OpenTable · SevenRooms ·
Micros Simphony · OnQ · HACCP · EU 1169/2011 · Bonvoy · Hilton Honors — echo that EXACT token at
least once. Generic synonyms ("the PMS", "the booking system") do not satisfy the contract.

CERTIFICATIONS — emit EXACTLY 4, chosen from this non-tech pool (all free / standard Irish
workplace certs; hospitality mode skips the tech allowlist):
  HACCP (Level 2) · RSA — Responsible Service of Alcohol · EU FIC 1169/2011 Allergens ·
  Manual Handling · Food Safety (Level 2) · Fire Warden / Fire Safety.

ANTI-FABRICATION HARD GUARD (hospitality-specific):
  NEVER invent — Michelin stars (1/2/3-star), AA Rosettes, Forbes 5-Star, MICHELIN Bib Gourmand,
  World's 50 Best rank, named or unnamed celebrity-guest interactions, TV appearances, Royal
  Warrant work, State-banquet / papal / Olympic-village service.
  ALLOWED — factual employer names, factual covers / room counts, factual award level of the
  PROPERTY (never personal), generic "VIP guest", "high-profile event", "private dining".

═══════════════════════════════════════════════════════════════════
## BULLET OPENER TABLE — HOSPITALITY (6 / 5 / 5 = 16 bullets)
═══════════════════════════════════════════════════════════════════
Each bullet MUST follow its T-type and START with ONE of the two words listed for that slot,
written EXACTLY — never invent, never swap a synonym. These required first words OVERRIDE every
other opener instruction in the master.
Bands (from master CR1): [1] 1 sentence 22-29w · [2] 2 sentences 33-40w · [3] 3 sentences 44-55w.
Target = mid-band word count to aim for; stay inside the band.
Rules already baked in: all 16 targets unique · adjacent bullets differ ≥10w · no two same-band
adjacent · no role closes on a 1-sentence bullet · each role a different band-rhythm · every
first word globally unique · no -ed opener · no fabrication-risk opener (no Michelin / Starred).

ROLE 1 — InterContinental Dublin (6)   rhythm: [3,1,2,1,3,2]
  R1B1  T10 Time         band[3]  ~52w   ->  Lunchtime | Peak
  R1B2  T2  Object       band[1]  ~26w   ->  Brigade   | Pass
  R1B3  T8  Constraint   band[2]  ~39w   ->  Without   | Solo
  R1B4  T4  Outcome      band[1]  ~22w   ->  Ninety    | Forty
  R1B5  T3  Context      band[3]  ~47w   ->  Across    | Throughout
  R1B6  T6  Narrative    band[2]  ~35w   ->  What      | One          (last — 2-sentence)

ROLE 2 — Crowne Plaza (5)               rhythm: [1,2,3,1,3]
  R2B1  T4  Outcome      band[1]  ~24w   ->  Two       | Eight
  R2B2  T5  Declarative  band[2]  ~36w   ->  Guests    | Feedback
  R2B3  T2  Object       band[3]  ~50w   ->  Bar       | Cellar
  R2B4  T10 Time         band[1]  ~28w   ->  Nightly   | Closing
  R2B5  T8  Constraint   band[3]  ~45w   ->  Short     | Down         (last — 3-sentence)

ROLE 3 — Vadakkan's Home (5)  [renders to Doc ROLE_4]   rhythm: [2,1,3,2,3]
  R3B1  T2  Object       band[2]  ~38w   ->  Float     | Rota
  R3B2  T3  Context      band[1]  ~23w   ->  Within    | Despite
  R3B3  T5  Declarative  band[3]  ~49w   ->  Covers    | Reviews
  R3B4  T8  Constraint   band[2]  ~33w   ->  Lacking   | Tight
  R3B5  T1  Verb-first   band[3]  ~54w   ->  Leading   | Running       (last — 3-sentence)

T-type notes for this table:
  T1 Verb-first  -> lead with a gerund (Leading / Running), NEVER an -ed past-tense verb.
  T5 Declarative -> a plain statement of fact or result, no context/setup clause.
  T6 Narrative   -> a tiny arc ("What began as ... / One busy ...").
  T-type per position never repeats across roles; each role uses fully distinct T-types
  (role_1 = 6 distinct: T10 T2 T8 T4 T3 T6 · role_2 = 5: T4 T5 T2 T10 T8 · role_3 = 5: T2 T3 T5 T8 T1).
  All eight listed types (T1 T2 T3 T4 T5 T6 T8 T10) appear at least once across the CV.

═══════════════════════════════════════════════════════════════════
## SELF-CHECK (must all be true before output)
═══════════════════════════════════════════════════════════════════
- [x] Bullet counts 6 / 5 / 5 (role_1 / role_2 / role_3).
- [x] 16 unique target word counts: 52,26,39,22,47,35 | 24,36,50,28,45 | 38,23,49,33,54.
- [x] No two same-band bullets adjacent within any role; every adjacent pair differs ≥10w.
- [x] Every role closes on a 2- or 3-sentence bullet (never a 1-sentence bullet).
- [x] Band-rhythms differ across roles: [3,1,2,1,3,2] · [1,2,3,1,3] · [2,1,3,2,3].
- [x] 16 first words globally unique; none end in -ed; none fabrication-risky (no Michelin/Starred).
- [x] role_3 → Doc ROLE_4 mapping note present; JSON keys stay role_1/2/3_bullets.
- [x] Fixed employer history (titles/companies/dates/locations) preserved verbatim; injection OFF.
- [x] Modern stack (Opera Cloud/OpenTable/Lightspeed/IHG Concerto) confined to role_1.
- [x] Exactly 4 certs from the non-tech pool; 6 skills; 3 projects; summary field = professional_summary.
