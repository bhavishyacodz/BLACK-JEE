#!/usr/bin/env python3
"""Regression-test the actual OCR-to-math normalizers used by BLACK-JEE pages."""
from __future__ import annotations
import json
import re
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CASES = [
    ("negative power", "10 ki minus 9", r"10^{-9}"),
    ("spoken negative power", "10 to the power minus 9", r"10^{-9}"),
    ("compact subscript", "PsmallA", r"P_{A}"),
    ("spaced subscript", "P small A", r"P_{A}"),
    ("numbered subscript", "Tsmall1", r"T_{1}"),
    ("squared variable", "r square", r"r^2"),
]

def extract_function(source: str, signature: str) -> str:
    match = re.search(signature + r"\s*\{", source)
    if not match:
        raise ValueError("normalizer function not found")
    start = match.start()
    brace = source.find("{", match.start())
    depth, quote, escaped = 0, None, False
    for i in range(brace, len(source)):
        ch = source[i]
        if quote:
            if escaped:
                escaped = False
            elif ch == "\\\\":
                escaped = True
            elif ch == quote:
                quote = None
            continue
        if ch in ("'", '"', "`"):
            quote = ch
        elif ch == "{":
            depth += 1
        elif ch == "}":
            depth -= 1
            if depth == 0:
                return source[start:i + 1]
    raise ValueError("normalizer function has unbalanced braces")

def main() -> int:
    pages = {
        "pyq.html": ("prettyQuestionText", r"function\s+prettyQuestionText\(value\)"),
        "pyq-admin.html": ("prettyQuestionText", r"function\s+prettyQuestionText\(value\)"),
        "shift-workbench.html": ("mathMarkup", r"function\s+mathMarkup\(value,forceMath=false\)"),
    }
    failures, total = [], 0
    for filename, (name, signature) in pages.items():
        try:
            source = (ROOT / filename).read_text(encoding="utf-8")
            fn = extract_function(source, signature)
        except (OSError, ValueError) as exc:
            failures.append(f"{filename}: {exc}")
            continue
        prelude = 'const esc=s=>String(s??"").replace(/[&<>]/g,c=>({"&":"&amp;","<":"&lt;",">":"&gt;"}[c]));\n' if name == "mathMarkup" else ""
        tests = []
        for label, raw, expected in CASES:
            call = name + "(" + json.dumps(raw) + (",true" if name == "mathMarkup" else "") + ")"
            tests.append("(()=>{const out=String(" + call + ");if(!out.includes(" + json.dumps(expected) + "))throw Error(" + json.dumps(label + " failed: ") + "+out);})();")
            total += 1
        harness = prelude + fn + "\n" + "\n".join(tests) + "\nconsole.log('PASS');\n"
        with tempfile.NamedTemporaryFile("w", suffix=".cjs", encoding="utf-8", delete=False) as tmp:
            tmp.write(harness)
            temp_path = Path(tmp.name)
        try:
            result = subprocess.run(["node", str(temp_path)], text=True, capture_output=True, check=False)
            if result.returncode:
                detail = (result.stderr or result.stdout).strip().splitlines()
                failures.append(f"{filename}: " + (detail[-1] if detail else "Node test failed"))
        finally:
            temp_path.unlink(missing_ok=True)
    if failures:
        print("BLACK-JEE math-rendering regression tests: FAIL")
        print("\n".join("- " + item for item in failures))
        return 1
    print(f"BLACK-JEE math-rendering regression tests: PASS ({total} cases across {len(pages)} production renderers)")
    return 0

if __name__ == "__main__":
    sys.exit(main())
