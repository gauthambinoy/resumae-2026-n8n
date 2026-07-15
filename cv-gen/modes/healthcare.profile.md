HEALTHCARE MODE PROFILE — follows the master prompt, never repeats it.
Candidate injection OFF: generate from JD + care persona + the fixed history below.
Slim by design: only per-mode items live here; every universal rule stays in the master.

═══════════════════════════════════════════════════════════════
COUNTS (this mode) — 2 roles ONLY · bullets role_1=8, role_2=6 · NO role_3 ·
6 skills · 3 projects · EXACTLY 4 certifications · summary field = professional_summary ·
NO experiences_used · candidate injection OFF.
═══════════════════════════════════════════════════════════════

## meta.role_title
Use the JD's title VERBATIM (validator needs >=12 chars, must mirror the posting).
Healthcare title families this mode serves:
  Lane B (hands-on care): Healthcare Assistant · Care Assistant · Health Care Support
    Worker · Support Worker · Care Worker · HCA · Home Care Assistant.
  Lane A (tech-in-health): Health Data Analyst · Clinical Systems Support — ONLY when
    the JD explicitly names software / data / systems.

## LANE A / LANE B SWITCH  (read the JD first, pick ONE lane, commit fully)

LANE A — JD names software / data / systems (EHR, FHIR, HL7, integration engine,
  clinical data, developer, analyst, informatics, interoperability, Epic, Cerner,
  MEDITECH, OMOP, ETL, API, SQL, Python).
  → Tech framing: dual-layer bullets (real bedside action + clinical-data analogue).
  → Skill labels (use EXACTLY these 6, no drift, no synonyms):
      1  Clinical Workflows and Patient Care
      2  Healthcare Data and EHR Concepts
      3  Regulatory and Privacy
      4  Care Documentation and Reporting
      5  Safety and Compliance Training
      6  Specialist Care and Multidisciplinary Practice

LANE B — JD names hands-on care (patient hygiene, vitals, mobility/transfers, ward,
  nurse supervision, QQI Level 5, manual handling, infection control, hoist, dementia
  or elderly/paediatric care) and does NOT name software / EHR vendor / developer /
  API / FHIR / HL7.
  → HCA framing: plain bedside bullets in Irish HCA voice. SUPPRESS ALL tech vocabulary
    (no FHIR / HL7 / SNOMED / LOINC / Epic / Cerner / MEDITECH / HIPAA / ISO 13485 /
    MDR / GDPR Article 9 / OMOP / EHR / integration engine / "audit-trail discipline").
  → Skill labels (use EXACTLY these 6):
      1  Patient Care and Hygiene
      2  Vital Signs and Charting (under nurse supervision)
      3  Manual Handling and Safe Patient Transfers
      4  Infection Control and Hand Hygiene
      5  QQI Level 5 Healthcare Support (in progress)
      6  Communication, Handover and Garda Vetting Readiness

Each skill_N_content = 8-10 comma-separated REAL items for the chosen lane.

## BULLET FRAMING + ANTI-FABRICATION GUARD
Dual-layer (LANE A): every bullet works on two levels at once —
  (a) a REAL care activity from the fixed history (handover sheet, MAR sheet, incident
      book, parent consent form, hoist transfer, observation chart, hygiene round), plus
  (b) the clinical-data concept it MIRRORS (structured patient record, audit trail,
      Article 9 lawful basis, FHIR Encounter shape, clinical risk classification).
  The relevance lives in the LANGUAGE, never in a fake claim.
Single-layer (LANE B): plain bedside bullets only — no tech analogue at all.

ANTI-FABRICATION (hard, both lanes): the candidate has CARE experience ONLY (Kripalaya,
Vadakkan). They have NEVER used Epic, Cerner, MEDITECH, EMIS, a FHIR server, OMOP tools,
or any clinical software in production, and hold NO real clinical incident history.
  NEVER invent: a specific clinical incident, a named patient, a ward outcome, a software
    action, or a calendar date / exact hour / exact GB pinned to the fixed roles.
  ALLOWED: paper logs, MAR / handover / incident books, consent forms, observation charts,
    and analogue framing ("the format mirrored...", "structured the same way...").
  FORBIDDEN phrasing: "used Epic to chart", "logged into Cerner", "exported HL7 messages",
    "built a FHIR profile", "configured OMOP ETL", "designed Clarity SQL views".
Generate every bullet from the JD + the care persona + the fixed history — nothing else.

## FIXED EMPLOYER HISTORY  (template-resident, injection OFF)
Reproduce VERBATIM — never rewrite titles, companies, dates, or locations. These are
template chrome; the model writes ONLY the bullets, summary, skills, projects, certs.
  role_1:  Volunteer Care Assistant – Kripalaya Special School
           FEBRUARY 2022 – AUGUST 2023 | KOCHI, INDIA          (8 bullets)
  role_2:  Volunteer Care Assistant – Vadakkan's Home
           FEBRUARY 2019 – DECEMBER 2021 | KOCHI, INDIA         (6 bullets)
  NO role_3. Do NOT echo these into meta.company / meta.role_title (those are the TARGET job).

## CERTIFICATIONS + ANTI-FABRICATION  (emit EXACTLY 4)
Healthcare is allowlist-SKIPPED by the validator, so HSE/QQI titles pass cleanly. Pick
EXACTLY 4 that align to the JD lane, from this HSE/QQI list only (never invent one off-list):
  - Care Skills (QQI Level 5) — The Open College
  - Patient Moving & Handling — HSE / Open College
  - Hand Hygiene — HSEland
  - Infection Prevention & Control (IPC) — HSEland
  - Children First / Safeguarding — HSE Tusla
  - Manual Handling (People) — Open College
  - First Aid Responder (FAR) — Pre-Hospital Emergency Care Council
  - Dementia Care — Dementia Services Information & Development Centre (Trinity)
  - GDPR for Healthcare — HSE eLearning
FORMAT: full official cert title only — NO years, NO dates, NO scores. These are real,
free/low-cost Irish certs; do NOT fabricate an incident, grade, or issue date around them.

## BULLET OPENER TABLE  (role_1 = 8, role_2 = 6 → 14 bullets)
Start each bullet with ONE of the two words listed — written EXACTLY, no synonym, no
invention. These first words OVERRIDE every other opener rule in the master. Follow the
slot's T-type and its word-count band.
Bands:  1 sentence = 22-29w  ·  2 sentences = 33-40w  ·  3 sentences = 44-55w.
Every opener word below is GLOBALLY UNIQUE — never reuse one across the CV. No -ed openers.

ROLE 1 (8)   rhythm: b1 · b3 · b2 · b1 · b3 · b2 · b1 · b3
  B1  T4  Outcome     Twelve     | Fourteen     24w  (band 1)
  B2  T2  Object      Ward       | Bedside      48w  (band 3)
  B3  T8  Constraint  Without    | Solo         33w  (band 2)
  B4  T10 Time        During     | Daybreak     22w  (band 1)
  B5  T3  Context     Through    | Across       54w  (band 3)
  B6  T6  Scale       Every      | Each         38w  (band 2)
  B7  T5  Punch       Dignity    | Comfort      27w  (band 1)
  B8  T1  Action      Assisting  | Escorting    45w  (band 3)

ROLE 2 (6)   rhythm: b2 · b1 · b3 · b1 · b2 · b3
  B1  T3  Context     Under      | Amid         36w  (band 2)
  B2  T8  Constraint  Alone      | Despite      25w  (band 1)
  B3  T2  Object      Chart      | Hoist        50w  (band 3)
  B4  T10 Time        Nightly    | Mornings     29w  (band 1)
  B5  T4  Outcome     Sixteen    | Ninety       40w  (band 2)
  B6  T1  Action      Feeding    | Turning      53w  (band 3)

T-type coverage: role_1 uses 8 distinct (T1,T2,T3,T4,T5,T6,T8,T10); role_2 uses 6 distinct
(T1,T2,T3,T4,T8,T10). No T-type repeats adjacently in either role.

═══════════════════════════════════════════════════════════════
SELF-CHECK (all must hold before emit)
═══════════════════════════════════════════════════════════════
[x] Bullet counts: role_1 = 8, role_2 = 6. TWO roles only — NO role_3.
[x] Certifications: EXACTLY 4, all from the HSE/QQI list (allowlist-skipped, so they pass).
[x] Word counts all 14 UNIQUE: 24,48,33,22,54,38,27,45 | 36,25,50,29,40,53.
[x] Consecutive bullets differ ≥10w; no two same-band bullets adjacent in either role.
[x] Each role a DIFFERENT rhythm; neither role closes on a 1-sentence (band-1) bullet —
    role_1 ends 45w (3 sentences), role_2 ends 53w (3 sentences).
[x] 14 opener FIRST-WORDS globally unique (28 options, all distinct); none end in -ed.
[x] No "certs INERT" / "no cert section" language anywhere — healthcare needs EXACTLY 4.
[x] Fixed employer history preserved VERBATIM (titles / companies / dates / locations).
[x] Anti-fabrication guard present: no invented clinical incidents, patients, or software use.
