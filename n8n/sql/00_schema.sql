-- Job Hunter Discovery — schema v1
-- 2026-04-29

CREATE TABLE IF NOT EXISTS jobs (
  id              BIGSERIAL PRIMARY KEY,
  hash            TEXT UNIQUE NOT NULL,
  country         CHAR(2) NOT NULL,
  source          TEXT NOT NULL,
  source_job_id   TEXT,
  title           TEXT NOT NULL,
  title_normalized TEXT NOT NULL,
  company         TEXT NOT NULL,
  company_domain  TEXT,
  location        TEXT,
  remote_type     TEXT,
  url             TEXT NOT NULL,
  jd_text         TEXT,
  jd_html         TEXT,
  raw_payload     JSONB,
  posted_at       TIMESTAMPTZ,
  scraped_at      TIMESTAMPTZ DEFAULT NOW(),
  filter_status   TEXT DEFAULT 'pending',
  filter_reason   TEXT,
  keyword_score   NUMERIC,
  llm_score       INT,
  llm_reason      TEXT,
  recency_score   NUMERIC,
  diversity_bonus NUMERIC,
  total_score     NUMERIC,
  recruiter_name      TEXT,
  recruiter_email     TEXT,
  recruiter_linkedin  TEXT,
  email_source        TEXT,
  status              TEXT DEFAULT 'new',
  shortlisted_at      TIMESTAMPTZ,
  telegram_msg_id     BIGINT,
  approved_at         TIMESTAMPTZ,
  applied_at          TIMESTAMPTZ,
  cv_url              TEXT,
  cl_url              TEXT,
  notes               TEXT
);
CREATE INDEX IF NOT EXISTS idx_jobs_status      ON jobs(country, status, scraped_at DESC);
CREATE INDEX IF NOT EXISTS idx_jobs_filter      ON jobs(filter_status);
CREATE INDEX IF NOT EXISTS idx_jobs_total_score ON jobs(total_score DESC NULLS LAST);

CREATE TABLE IF NOT EXISTS companies (
  id              SERIAL PRIMARY KEY,
  name            TEXT NOT NULL,
  domain          TEXT,
  ats_type        TEXT NOT NULL,
  ats_slug        TEXT NOT NULL,
  countries       TEXT[] NOT NULL DEFAULT '{}',
  priority        INT DEFAULT 5,
  active          BOOLEAN DEFAULT true,
  last_fetched_at TIMESTAMPTZ,
  last_error      TEXT,
  notes           TEXT,
  UNIQUE (ats_type, ats_slug)
);
CREATE INDEX IF NOT EXISTS idx_companies_active ON companies(active, priority DESC);

CREATE TABLE IF NOT EXISTS keywords (
  id        SERIAL PRIMARY KEY,
  keyword   TEXT NOT NULL,
  category  TEXT NOT NULL,
  weight    NUMERIC DEFAULT 1.0,
  countries TEXT[],
  active    BOOLEAN DEFAULT true,
  UNIQUE (keyword, category)
);

CREATE TABLE IF NOT EXISTS country_config (
  country           CHAR(2) PRIMARY KEY,
  active            BOOLEAN DEFAULT true,
  telegram_chat_id  TEXT,
  location_filter   JSONB,
  top_n             INT DEFAULT 5,
  llm_score_floor   INT DEFAULT 60,
  cooldown_days     INT DEFAULT 14
);

CREATE TABLE IF NOT EXISTS runs (
  id              BIGSERIAL PRIMARY KEY,
  country         CHAR(2),
  trigger_type    TEXT,
  started_at      TIMESTAMPTZ DEFAULT NOW(),
  finished_at     TIMESTAMPTZ,
  total_fetched   INT DEFAULT 0,
  new_jobs        INT DEFAULT 0,
  passed_filter   INT DEFAULT 0,
  shortlisted     INT DEFAULT 0,
  errors          JSONB,
  source_stats    JSONB
);

CREATE TABLE IF NOT EXISTS recruiter_cache (
  domain      TEXT PRIMARY KEY,
  emails      JSONB,
  fetched_at  TIMESTAMPTZ DEFAULT NOW(),
  source      TEXT
);

CREATE TABLE IF NOT EXISTS applications (
  id            BIGSERIAL PRIMARY KEY,
  job_id        BIGINT REFERENCES jobs(id) ON DELETE CASCADE,
  applied_at    TIMESTAMPTZ DEFAULT NOW(),
  cv_url        TEXT,
  cl_url        TEXT,
  email_sent_to TEXT,
  email_subject TEXT,
  outcome       TEXT,
  outcome_at    TIMESTAMPTZ,
  notes         TEXT
);
CREATE INDEX IF NOT EXISTS idx_applications_job ON applications(job_id);

CREATE TABLE IF NOT EXISTS feedback (
  id          BIGSERIAL PRIMARY KEY,
  job_id      BIGINT REFERENCES jobs(id) ON DELETE CASCADE,
  decision    TEXT NOT NULL,
  features    JSONB,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS rate_limits (
  host            TEXT PRIMARY KEY,
  tokens          NUMERIC NOT NULL,
  capacity        NUMERIC NOT NULL,
  refill_per_sec  NUMERIC NOT NULL,
  updated_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS api_usage (
  id        BIGSERIAL PRIMARY KEY,
  source    TEXT NOT NULL,
  used_at   TIMESTAMPTZ DEFAULT NOW(),
  units     INT DEFAULT 1,
  meta      JSONB
);
CREATE INDEX IF NOT EXISTS idx_api_usage_source_time ON api_usage(source, used_at DESC);
