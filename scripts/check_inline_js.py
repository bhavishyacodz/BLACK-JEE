#!/usr/bin/env python3
"""Extract and syntax-check inline JavaScript in root-level HTML pages."""
from __future__ import annotations

import subprocess
import sys
import tempfile
from html.parser import HTMLParser
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

class InlineScriptParser(HTMLParser):
    def __init__(self) -> None:
        super().__init__(convert_charrefs=False)
        self.in_script = False
        self.external = False
        self.current: list[str] = []
        self.scripts: list[str] = []

    def handle_starttag(self, tag, attrs):
        if tag.lower() == "script":
            self.in_script = True
            self.external = any(k.lower() == "src" for k, _ in attrs)
            self.current = []

    def handle_data(self, data):
        if self.in_script and not self.external:
            self.current.append(data)

    def handle_endtag(self, tag):
        if tag.lower() == "script" and self.in_script:
            code = "".join(self.current).strip()
            if code:
                self.scripts.append(code)
            self.in_script = False
            self.external = False
            self.current = []

def main() -> int:
    pages = sorted(ROOT.glob("*.html"))
    if not pages:
        print("ERROR: no HTML pages found")
        return 1
    failures: list[str] = []
    checked = 0
    with tempfile.TemporaryDirectory(prefix="blackjee-js-check-") as tmp:
        tmpdir = Path(tmp)
        for page in pages:
            parser = InlineScriptParser()
            parser.feed(page.read_text(encoding="utf-8", errors="replace"))
            for index, code in enumerate(parser.scripts, start=1):
                checked += 1
                source = tmpdir / f"inline-{checked}.mjs"
                source.write_text(code, encoding="utf-8")
                result = subprocess.run(
                    ["node", "--check", str(source)],
                    text=True, capture_output=True, check=False,
                )
                if result.returncode:
                    detail = (result.stderr or result.stdout).strip().splitlines()
                    failures.append(f"{page.name} inline script {index}: " +
                                    (detail[-1] if detail else "syntax check failed"))
    if failures:
        print("BLACK-JEE inline JavaScript syntax audit: FAIL")
        for failure in failures:
            print(f"- {failure}")
        return 1
    print(f"BLACK-JEE inline JavaScript syntax audit: PASS ({checked} scripts across {len(pages)} pages)")
    return 0

if __name__ == "__main__":
    sys.exit(main())
