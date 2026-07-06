CV-GEN — where to put credentials (for the real-experience/git feature)

1) GitHub read-only token  ->  ~/cv-gen/credentials/github.token
   Create at github.com/settings/tokens  (scope: public_repo, or repo if private).
   Put ONLY the token string in the file, then: chmod 600 ~/cv-gen/credentials/github.token
   Once present, github_corpus.py pulls your repos into the Projects tab.

2) (optional) OpenRouter key -> ~/cv-gen/credentials/openrouter.key
   Enables gpt-oss-120b:free to write nicer project cards.
   Without it, cards are built from repo metadata (still works).

These files are git-ignored and never leave this box.
