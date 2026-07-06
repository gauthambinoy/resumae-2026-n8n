#!/usr/bin/env python3
"""JD Clean Runner — Claude Sonnet (low effort) via CLI with --json-schema.
Replaces the OpenRouter gpt-4.1 chainLlm path that ran out of credits.

POST /run-jd-clean  body: {"jd": "<raw jd text>"}
returns: {"ok": true, "data": {<cleaned schema>}, "duration_s": N, "model": "..."}
"""
import json
import os
import re
import subprocess
import time
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

HOST = os.environ.get("JD_CLEAN_HOST", "0.0.0.0")
PORT = int(os.environ.get("JD_CLEAN_PORT", "8789"))
CLAUDE_BIN = os.environ.get("CLAUDE_BIN", "/usr/local/bin/claude")
MODEL = os.environ.get("JD_CLEAN_MODEL", "sonnet")
EFFORT = os.environ.get("JD_CLEAN_EFFORT", "low")
TIMEOUT_S = int(os.environ.get("JD_CLEAN_TIMEOUT", "180"))

SYSTEM_PROMPT = """You are a JD cleaner & ENRICHER. Given a raw Job Description, return STRICT JSON matching the provided schema (no markdown fences, no preamble).

TASKS:
1. CLEAN: strip HTML, recruiter fluff/signature, EEO/legal/cookie/About-Us boilerplate, ads, social links, salary teasers. Keep: title, responsibilities, required & preferred skills/tools/frameworks, constraints. Keep cleaned_jd under ~1500 chars.
2. EXTRACT structured meta (company, role, location, seniority).
3. LIST tools & skills mentioned IN the JD (top_tools, top_skills) — 8-15 each.
4. ENRICH (most important): suggest tools & skills NOT in the JD that recruiters love to see on a CV for this exact role/seniority. Aim for 8-12 each in additional_tools + additional_skills.

  Use these per-domain catalogs as the source pool (pick what fits the role):

  SOFTWARE / BACKEND / CLOUD / SRE / GENAI:
    Languages: Python, Go, TypeScript, Rust, Java, C#, Kotlin, SQL
    Frameworks: FastAPI, Django, Spring Boot, Next.js, React, Vue, Express, .NET 8, ASP.NET Core, EF Core
    Cloud: AWS (EKS, ECS, Lambda, RDS, S3, MSK), GCP, Azure (App Service, Functions, Service Bus, Key Vault)
    IaC: Terraform, Pulumi, Helm, ArgoCD, CloudFormation
    Containers: Docker, Kubernetes, containerd
    Data: Postgres (partitioning, replicas), Snowflake, BigQuery, DuckDB, Redis, MongoDB, Elasticsearch, pgvector
    Streaming: Kafka, NATS, RabbitMQ, MSK, Kinesis
    Observability: OpenTelemetry, Prometheus, Thanos, Grafana, Loki, Tempo, Datadog, Sentry, New Relic
    CI/CD: GitHub Actions, GitLab CI, ArgoCD, Buildkite, Jenkins, Azure DevOps
    Testing: pytest, vitest, Jest, Playwright, Cypress, xUnit, Moq, FluentAssertions
    SRE: SLO design, Pyrra, Sloth, PagerDuty, Statuspage, Chaos Mesh, DORA metrics
    GenAI: LangGraph, LangSmith, Ragas, LangFuse, Inspect AI, Promptfoo, vLLM, LoRA, PEFT, Hugging Face Transformers, OpenAI/Anthropic SDKs, pgvector, ChromaDB, Pinecone
    Security: OWASP, OAuth2, JWT, mTLS, Vault, Snyk
    Certs (only if held): AWS SAA/SAP/DevOps Pro, CKA, HashiCorp Terraform Associate, AZ-204, AZ-400, GCP PCA

  DATA / ML / RESEARCH:
    Methods: mixed-effects (lme4), Bayesian estimation, bootstrap, power analysis, pre-registration (OSF)
    Tooling: R (lme4, tidyverse), Python (statsmodels, scipy, scikit-learn, statsforecast), Jupyter, papermill, nbdev
    ML: PyTorch, PyTorch Lightning, TensorFlow, Hugging Face (Transformers, Datasets, Accelerate), XGBoost, scikit-learn
    LLM/Eval: Inspect AI, LM-Evaluation-Harness, Promptfoo, LangFuse, Weights & Biases, MLflow
    Geospatial: rasterio, GeoPandas, xarray, Google Earth Engine, Sentinel Hub
    Writing: LaTeX, Overleaf, BibTeX, Zotero, NVivo, Atlas.ti
    Data eng: dbt, Snowflake, Airflow, Fivetran, Airbyte, OpenLineage
    Certs: SnowPro Core, dbt Fundamentals, GCP Data Engineer, DeepLearning.AI specializations

  RETAIL / OFF-LICENCE / FORECOURT / CONVENIENCE:
    POS: Tesco EPOS, Centra POS, SAM4S, Verifone fuel POS, Zebra TC52 scan-gun
    Compliance: HACCP Level 2, RSA (Responsible Service of Alcohol), Manual Handling, Public Health Alcohol Act, MUP, Tobacco Products Directive, NSAI inspection
    Operations: FIFO rotation, IDDSI labelling, planogram resets, age verification (18+ / Challenge-25), Brand Standards Manual, mystery-shop response, stocktake variance, drive-off log
    Service: Café Local barista, deli prep, allergen matrix, refusal-book entries
    Safety: First-aid responder, fire safety, chiller temperature logger
    Optional certs: WSET Level 1 Wines, Cicerone Certified Beer Server, forklift counterbalance licence

  HEALTHCARE / HSE / NURSING HOME / DEMENTIA / PALLIATIVE:
    Frameworks: NEWS2, MEWS, GCS, IDDSI, SBAR handover, NMBI guidelines, Waterlow, Norton
    Equipment: Arjo Maxi Sky 2 hoist, sensor mats (CareCall), pivot transfer, sliding sheet, PPE donning
    Charting: EPIC Care, paper care plan, MAR sheet, observation chart, daily care book, incident-book
    Compliance: QQI Level 5 Healthcare Support, HSeLanD Manual Handling + Hand Hygiene + Fire Safety + Children First, Garda vetting, CPR BLS Heartsaver
    Care specialisms: dementia (DCAAW), palliative (IHF Palliative Care Foundation Programme), stroke (ESO modules), PEG tube familiarity
    Soft: family liaison, bereavement support, de-escalation, end-of-life presence, validation therapy

  HOSPITALITY / 4★-5★ HOTEL / FINE-DINING / FUNCTIONS:
    POS/PMS: Micros Simphony 18, Lightspeed Restaurant, Silverware POS, OnQ, Opera Cloud, Opera PMS, OpenTable, SevenRooms, Resy
    Service standards: LQA standards, Forbes 5-Star benchmarks, AA Rosette service, Kipsu guest messaging, EU 1169 allergens
    Compliance: HACCP Level 2, Manual Handling, RSA, Allergen Awareness, IDDSI awareness
    Wine/Bev: WSET Level 1 / Level 2 Wines, sommelier guild, by-the-glass varietals, cellar log discipline, Untappd for Business
    Operations: BEO (Banquet Event Order) reading, 86 management, two-sitting wedding turnaround, mise en place, kitchen pass timing, Forbes pause-two-second pickup
    Workforce: Harri scheduling, Fourth Hospitality, rota planning, new-starter onboarding

LINKEDIN/INDEED CHROME STRIP (mandatory before cleaning):
- Remove lines like 'X logo', 'Company alumni from X', 'People you can reach out to', 'Promoted by hirer', 'Your AI-powered job assessment', "You'd be a top applicant", 'X people clicked apply', 'Responses managed off LinkedIn', 'Easy Apply', 'Job match', 'View More Jobs', 'job post', '3.7 out of 5 stars'.
- These are platform chrome, NOT part of the JD content. They mislead the role/company extraction.
- Company name is ALWAYS the FIRST proper-noun mention in the cleaned JD — pick that, not any company name appearing later in 'alumni' / 'people you know' noise.

SENIORITY MAPPING (must match downstream CR18 voice ladder):
- "intern" / "graduate" / "junior" / "entry-level"     -> "junior"
- "mid-level" / "2-5 yrs" / "engineer II"              -> "mid"
- "senior" / "senior engineer" / "5+ yrs hands-on"     -> "senior IC"
- "staff" / "principal" / "tech lead"                  -> "tech lead"
- "engineering manager" / "head of"                    -> "mgmt-track"
If unclear, pick the closest band. NEVER leave empty.

TITLE-PREFIX GUARD (2026-05-23 — anti-overshoot):
- The role_title is the SOURCE OF TRUTH for seniority. Read it first.
- If role_title does NOT begin with one of: "Senior", "Staff", "Principal",
  "Lead", "Head", "Director", "VP", "Chief" — then seniority MUST be
  "junior" or "mid" regardless of what the JD body says.
- "Cloud Engineer", "Data Engineer", "Software Engineer" alone (no
  seniority prefix) = "mid" by default, "junior" only if explicitly named
  ("Junior", "Graduate", "Intern", "Entry-level") or salary <= EUR 45k.
- A 12-month contract role IS NOT automatically senior. Use the title.
- Do NOT infer "senior IC" from responsibility scope alone.

RULES for additional_*:
- Must NOT duplicate top_skills / top_tools.
- Must be genuinely standard for this role (e.g. for GenAI: LangGraph, Ragas, LangSmith, pgvector, vLLM, LoRA — not random buzzwords).
- Vary across categories: framework, eval/observability, serving, vector store, fine-tuning, infra/MLOps.
- No marketing words. Real tool/skill names only.

COMPANY FALLBACK:
- If JD is recruiter-anonymized ("Our client is X", "My client is..."), use X.
- If no company can be extracted at all, output "" (empty string). NEVER hallucinate a company name.
"""

SCHEMA = {
    "type": "object",
    "properties": {
        "cleaned_jd": {"type": "string"},
        "company": {"type": "string"},
        "role_title": {"type": "string"},
        "location": {"type": "string"},
        "seniority": {
            "type": "string",
            "enum": ["junior", "mid", "senior IC", "tech lead", "mgmt-track"],
        },
        "top_skills": {"type": "array", "items": {"type": "string"}},
        "top_tools": {"type": "array", "items": {"type": "string"}},
        "additional_skills": {"type": "array", "items": {"type": "string"}},
        "additional_tools": {"type": "array", "items": {"type": "string"}},
    },
    "required": [
        "cleaned_jd",
        "company",
        "role_title",
        "location",
        "seniority",
        "top_skills",
        "top_tools",
        "additional_skills",
        "additional_tools",
    ],
}



import datetime as _dt
_FAIL_LOG = os.environ.get("JD_CLEAN_FAIL_LOG", "/home/ubuntu/cv-gen/jd-clean-failures.log")

def _log_failure(kind, result_msg, stderr_msg):
    try:
        ts = _dt.datetime.utcnow().isoformat() + "Z"
        with open(_FAIL_LOG, "a") as f:
            f.write(f"{ts}\t{kind}\tresult={result_msg!r}\tstderr={stderr_msg!r}\n")
    except Exception:
        pass

def _call_once(jd_text):
    user_msg = f"{SYSTEM_PROMPT}" + "\n\nRAW JD:\n" + jd_text + "\n\nReturn JSON ONLY matching the schema."
    cmd = [
        CLAUDE_BIN, "-p",
        "--model", MODEL,
        "--effort", EFFORT,
        "--output-format", "json",
        "--json-schema", json.dumps(SCHEMA),
        "--no-session-persistence",
    ]
    t0 = time.time()
    proc = subprocess.run(cmd, input=user_msg, capture_output=True, text=True, timeout=TIMEOUT_S)
    return proc, round(time.time() - t0, 1)


def run_claude(jd_text: str) -> dict:
    last_err = None
    delays = [0, 8, 30]
    for attempt, delay in enumerate(delays, 1):
        if delay:
            time.sleep(delay)
        try:
            proc, dur = _call_once(jd_text)
        except subprocess.TimeoutExpired as te:
            last_err = RuntimeError("timeout after %ss" % TIMEOUT_S)
            _log_failure("timeout", "", str(te)[:400])
            continue
        envelope = None
        try:
            envelope = json.loads(proc.stdout) if proc.stdout.strip() else None
        except Exception:
            envelope = None
        if envelope and envelope.get("is_error"):
            api_status = envelope.get("api_error_status")
            result_msg = (envelope.get("result") or "")[:300]
            _log_failure(api_status, result_msg, proc.stderr[:400])
            if api_status == 429 or (isinstance(api_status, int) and 500 <= api_status < 600):
                last_err = RuntimeError("claude_transient_%s: %s" % (api_status, result_msg))
                continue
            if api_status == 401:
                raise RuntimeError("claude_auth_failed_401: %s" % result_msg)
            raise RuntimeError("claude_api_error_%s: %s" % (api_status, result_msg))
        if proc.returncode != 0:
            _log_failure("rc" + str(proc.returncode), "", proc.stderr[:400])
            last_err = RuntimeError("claude rc=%s stderr=%s" % (proc.returncode, proc.stderr[:200]))
            continue
        if envelope is None:
            last_err = RuntimeError("envelope parse failed head=%s" % proc.stdout[:200])
            continue
        data = envelope.get("structured_output")
        if not data:
            raw = envelope.get("result", "")
            m = re.search(r"\{[\s\S]*\}", raw)
            if not m:
                last_err = RuntimeError("no structured_output: %s" % raw[:200])
                continue
            try:
                data = json.loads(m.group(0))
            except Exception as je:
                last_err = RuntimeError("json salvage fail: %s" % je)
                continue
        return {"data": data, "duration_s": dur, "model": MODEL, "effort": EFFORT, "attempts": attempt}
    raise last_err or RuntimeError("unknown failure after retries")

class Handler(BaseHTTPRequestHandler):
    def _send(self, code, payload):
        b = json.dumps(payload).encode("utf-8")
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(b)))
        self.end_headers()
        self.wfile.write(b)

    def do_GET(self):
        if self.path == "/health":
            self._send(200, {"ok": True, "model": MODEL, "effort": EFFORT})
        else:
            self._send(404, {"ok": False, "error": "not_found"})

    def do_POST(self):
        if self.path != "/run-jd-clean":
            self._send(404, {"ok": False, "error": "not_found"})
            return
        length = int(self.headers.get("Content-Length", "0"))
        body = self.rfile.read(length).decode("utf-8", "replace") if length else "{}"
        try:
            payload = json.loads(body)
        except Exception:
            self._send(400, {"ok": False, "error": "invalid_json"})
            return
        jd = (payload.get("jd") or "").strip()
        if not jd:
            self._send(400, {"ok": False, "error": "missing_jd"})
            return
        try:
            result = run_claude(jd)
            self._send(200, {"ok": True, **result})
        except subprocess.TimeoutExpired:
            self._send(504, {"ok": False, "error": "claude_timeout"})
        except Exception as e:
            self._send(500, {"ok": False, "error": str(e)[:500]})

    def log_message(self, fmt, *args):
        return


if __name__ == "__main__":
    print(f"jd-clean-runner listening on {HOST}:{PORT} model={MODEL} effort={EFFORT}", flush=True)
    ThreadingHTTPServer((HOST, PORT), Handler).serve_forever()
