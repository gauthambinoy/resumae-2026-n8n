#!/usr/bin/env python3
"""llm_free.py — reusable helper: call a chain of FREE OpenRouter models with
automatic fallback so a 429 rate-limit on one model never kills the job.

Every model in the chain is a ":free" variant, so each call costs $0.
Only the Python standard library is used (urllib) — no pip installs required.

Module use:
    from llm_free import free_chat
    text = free_chat("summarise this", system="Be concise.")   # -> str | None

Smoke test (prints which model answered + the text):
    python3 llm_free.py "reply with exactly PONG"
"""
import json
import os
import sys
import time
import urllib.request
import urllib.error

ENDPOINT = "https://openrouter.ai/api/v1/chat/completions"
KEY_PATH = os.path.expanduser("~/cv-gen/credentials/openrouter.key")

# Free model fallback chain — tried STRICTLY in this order. First non-empty wins.
MODEL_CHAIN = [
    "openai/gpt-oss-120b:free",
    "openai/gpt-oss-20b:free",
    "meta-llama/llama-3.3-70b-instruct:free",
    "qwen/qwen3-coder:free",
]

# Backoff (seconds) between retries of the SAME model. Length == retries after
# the first attempt, so each model gets 1 try + len(BACKOFFS) retries.
BACKOFFS = [3, 6]


def _load_key():
    try:
        with open(KEY_PATH) as f:
            return f.read().strip()
    except Exception as e:
        print("[llm_free] cannot read key %s: %s" % (KEY_PATH, e), file=sys.stderr)
        return None


def _log(model, code):
    print("[llm_free] model=%s -> HTTP %s" % (model, code), file=sys.stderr)


def _call_once(model, key, messages, max_tokens, temperature, timeout):
    """One HTTP attempt. Returns (content_or_None, code_str) for logging."""
    body = json.dumps({
        "model": model,
        "messages": messages,
        "max_tokens": max_tokens,
        "temperature": temperature,
    }).encode("utf-8")
    req = urllib.request.Request(
        ENDPOINT, data=body, method="POST",
        headers={
            "Authorization": "Bearer " + key,
            "Content-Type": "application/json",
            # OpenRouter courtesy headers (optional, help attribution/limits):
            "HTTP-Referer": "https://cv-gen.local",
            "X-Title": "cv-gen",
        },
    )
    try:
        with urllib.request.urlopen(req, timeout=timeout) as r:
            code = r.getcode()
            raw = r.read().decode("utf-8", "ignore")
        try:
            data = json.loads(raw)
        except Exception:
            return None, "%s+badjson" % code
        # Some providers return HTTP 200 with an {"error": ...} body.
        if isinstance(data, dict) and data.get("error"):
            return None, "%s+err" % code
        content = ""
        try:
            content = (data["choices"][0]["message"]["content"] or "").strip()
        except Exception:
            content = ""
        return (content if content else None), str(code)
    except urllib.error.HTTPError as e:
        # Covers 429 and other 4xx/5xx. Drain body so JSON errors are handled
        # gracefully and the connection is released.
        try:
            e.read()
        except Exception:
            pass
        return None, str(e.code)
    except Exception as e:
        # Timeout / URLError / socket error / etc.
        return None, "ERR(%s)" % type(e).__name__


def _run_chain(messages, max_tokens, temperature, timeout):
    """Walk MODEL_CHAIN, retrying each model on failure. Returns
    (winning_model, content) or (None, None) if the whole chain fails."""
    key = _load_key()
    if not key:
        return None, None
    for model in MODEL_CHAIN:
        for attempt in range(len(BACKOFFS) + 1):
            content, code = _call_once(
                model, key, messages, max_tokens, temperature, timeout)
            _log(model, code)
            if content:
                return model, content
            # Failed (429 / error / timeout). Back off, then retry SAME model.
            if attempt < len(BACKOFFS):
                time.sleep(BACKOFFS[attempt])
        # Model exhausted -> fall through to the next one in the chain.
    return None, None


def free_chat(prompt, system=None, max_tokens=1200, temperature=0.4, timeout=60):
    """Try each free model in MODEL_CHAIN in order; return the first non-empty
    text response, or None if every model fails (so callers can fall back to a
    heuristic). Never raises for network/HTTP problems."""
    messages = []
    if system:
        messages.append({"role": "system", "content": system})
    messages.append({"role": "user", "content": prompt})
    _, content = _run_chain(messages, max_tokens, temperature, timeout)
    return content


if __name__ == "__main__":
    q = sys.argv[1] if len(sys.argv) > 1 else "reply with exactly PONG"
    model, text = _run_chain([{"role": "user", "content": q}], 200, 0.2, 60)
    if model:
        print("ANSWERED BY: %s" % model)
        print("TEXT: %s" % text)
    else:
        print("ALL MODELS FAILED (chain exhausted)")
        sys.exit(1)
