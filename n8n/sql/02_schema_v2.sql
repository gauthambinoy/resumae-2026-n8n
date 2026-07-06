-- Set 2 additions: app_config table for master profile + any future global config

CREATE TABLE IF NOT EXISTS app_config (
  key         TEXT PRIMARY KEY,
  value       JSONB NOT NULL,
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

-- Seed placeholder master profile (user edits via SQL later)
INSERT INTO app_config (key, value) VALUES (
  'master_profile',
  '{
    "name": "Gautham Binoy",
    "location": "Dublin, Ireland",
    "current_role": "Full-stack AI Engineer",
    "experience_years": 1,
    "graduated": true,
    "wants": {
      "roles": ["AI Engineer", "ML Engineer", "Full-stack Engineer", "Python Developer", "GenAI Engineer", "Data Engineer", "Software Engineer Graduate"],
      "seniority": ["graduate", "junior", "0-2 years", "0-3 years", "early career"],
      "exclude": ["senior", "lead", "principal", "staff", "manager", "director", "10+ years", "clearance"],
      "locations": ["Ireland", "Dublin", "Remote EU"]
    },
    "skills": ["Python", "TypeScript", "React", "Node.js", "PostgreSQL", "LLM", "LangChain", "OpenRouter", "n8n", "AWS", "Docker"],
    "tone": "Practical builder, ships fast, prefers automation over manual work."
  }'::jsonb
)
ON CONFLICT (key) DO NOTHING;
