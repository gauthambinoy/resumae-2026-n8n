# Source-of-Truth / Real-Experience feature — STATUS (built while you were away)

## What is LIVE and safe (nothing in your working CV pipeline was touched)
- Google Sheet "library" — 3 new tabs on your existing sheet:
  Experience, Education, Projects.
  URL: https://docs.google.com/spreadsheets/d/1aaBiwgS_zw3IZ0gkKKbLJpo_98bkzIPVx7vgbv-fxjM
  Seeded with what I know; cells marked CONFIRM need you.
- Standalone scripts (wired into NOTHING yet, tested):
  - sheet_to_json.py     : Sheet -> ~/cv-gen/source_of_truth.json  (tested: 5 exp, 2 edu)
  - select_relevant.py   : JD -> picks most-relevant experiences+projects (tested)
  - github_corpus.py     : (inert until token) repos -> Projects tab via gpt-oss-120b

## What I still need from YOU (leave answers / do these when back)
1. Fill the CONFIRM cells in the Sheet: One Team + Sappio dates/location; MSc field+dates; any diploma.
2. Add GitHub token -> ~/cv-gen/credentials/github.token  (see credentials/README.txt)
3. SHARE the CV template doc with jobhunter20266@gmail.com as EDITOR so I can add
   header/title/education tokens (needed for dynamic title + experiences + education).
   Template: docs.google.com/document/d/174Ys9ROqEFVFeI8TB3tUBlNWgiUa7einpCENF-ZyabY

## What is NOT done yet (needs your input / template access — Phase B)
- Wiring the selector + a Form ON/OFF toggle into the live n8n workflow.
- Real projects into the Projects section of the CV.
- Making the printed TITLE flex, and dynamic experiences/education (needs template tokens).
