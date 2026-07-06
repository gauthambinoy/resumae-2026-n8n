-- Minimal seed for plumbing tests. Real data goes in Set 2 once user provides 100+ companies / 200+ keywords.

INSERT INTO companies (name, domain, ats_type, ats_slug, countries, priority, notes) VALUES
  ('Stripe',     'stripe.com',     'greenhouse', 'stripe',    ARRAY['IE','AU','AE'], 9, 'seed'),
  ('Workhuman',  'workhuman.com',  'greenhouse', 'workhuman', ARRAY['IE'],            8, 'seed'),
  ('Tines',      'tines.com',      'lever',      'tines',     ARRAY['IE'],            8, 'seed')
ON CONFLICT (ats_type, ats_slug) DO NOTHING;

INSERT INTO keywords (keyword, category, weight) VALUES
  ('python',        'tech',          1.0),
  ('machine learning','tech',        1.5),
  ('graduate',      'seniority_yes', 2.0),
  ('senior',        'seniority_no',  3.0),
  ('clearance',     'exclude',       5.0)
ON CONFLICT (keyword, category) DO NOTHING;

INSERT INTO country_config (country, active, top_n, llm_score_floor, cooldown_days) VALUES
  ('IE', true, 5, 60, 14),
  ('AE', false, 5, 60, 14),
  ('AU', false, 5, 60, 14)
ON CONFLICT (country) DO UPDATE SET active = EXCLUDED.active;
