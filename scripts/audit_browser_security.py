#!/usr/bin/env python3
"""Static guardrails for browser-facing BLACK-JEE files."""
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BROWSER_FILES = sorted(ROOT.glob("*.html")) + sorted(ROOT.glob("*.js"))
PROJECT_RE = re.compile(r"https://([a-z0-9]+)\.supabase\.co", re.I)
SECRET_PATTERNS = [
    re.compile(r"sb_secret_[A-Za-z0-9_-]{16,}"),
    re.compile(r"service_role.{0,100}eyJ[A-Za-z0-9_-]{30,}", re.I | re.S),
    re.compile(r"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9\.[A-Za-z0-9_-]{30,}\.[A-Za-z0-9_-]{20,}"),
]

def main() -> int:
    errors: list[str] = []
    refs: dict[str, list[str]] = {}
    if not BROWSER_FILES:
        print("ERROR: no browser-facing HTML/JS files found")
        return 1
    for path in BROWSER_FILES:
        text = path.read_text(encoding="utf-8", errors="replace")
        rel = path.relative_to(ROOT).as_posix()
        for pattern in SECRET_PATTERNS:
            if pattern.search(text):
                errors.append(f"{rel}: possible embedded secret or service token")
                break
        for ref in set(PROJECT_RE.findall(text)):
            refs.setdefault(ref.lower(), []).append(rel)
    if len(refs) != 1:
        errors.append("expected exactly one Supabase project reference across browser files; found " +
                      (", ".join(sorted(refs)) if refs else "none"))
    if errors:
        print("BLACK-JEE browser security surface audit: FAIL")
        for error in errors:
            print(f"- {error}")
        return 1
    ref = next(iter(refs))
    print(f"BLACK-JEE browser security surface audit: PASS")
    print(f"Scanned {len(BROWSER_FILES)} root-level HTML/JS files.")
    print(f"Supabase project reference is consistent: {ref}")
    print("No known service-role/secret-key or JWT-shaped credential patterns found.")
    print("Note: this is a static guardrail, not a penetration test or proof of database security.")
    return 0

if __name__ == "__main__":
    sys.exit(main())
