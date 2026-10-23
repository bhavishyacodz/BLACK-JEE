#!/usr/bin/env python3
"""Check local href/src/poster references in root-level BLACK-JEE HTML pages.

This is a structural check only: it does not fetch external URLs or prove runtime
behavior, authentication, Supabase policies, or visual correctness.
"""
from __future__ import annotations

import posixpath
import sys
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import unquote, urlsplit

ROOT = Path(__file__).resolve().parents[1]
ATTRIBUTES = {"href", "src", "poster"}
SKIP_SCHEMES = {"http", "https", "mailto", "tel", "javascript", "data", "blob"}


class ReferenceParser(HTMLParser):
    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self.references: list[str] = []

    def handle_starttag(self, tag: str, attrs) -> None:
        for key, value in attrs:
            if key and key.lower() in ATTRIBUTES and value:
                self.references.append(value.strip())

    def handle_startendtag(self, tag: str, attrs) -> None:
        self.handle_starttag(tag, attrs)


def resolve_local_reference(page: Path, raw: str) -> str | None:
    ref = raw.strip()
    if not ref or ref.startswith("#") or any(token in ref for token in ("{", "}", "${")):
        return None

    parsed = urlsplit(ref)
    if parsed.scheme.lower() in SKIP_SCHEMES or parsed.netloc:
        return None
    path = unquote(parsed.path)
    if not path:
        return None

    if path.startswith("/"):
        target = path.lstrip("/")
    else:
        target = posixpath.normpath(posixpath.join(page.parent.as_posix(), path))

    if target in ("", "."):
        target = "index.html"
    if target.endswith("/"):
        target += "index.html"
    return target


def main() -> int:
    pages = sorted(ROOT.glob("*.html"))
    if not pages:
        print("ERROR: no root-level HTML pages found")
        return 1

    failures: list[str] = []
    checked = 0
    for page in pages:
        parser = ReferenceParser()
        try:
            parser.feed(page.read_text(encoding="utf-8"))
        except (OSError, UnicodeError) as exc:
            failures.append(f"{page.name}: could not read HTML ({exc})")
            continue

        for raw in parser.references:
            target = resolve_local_reference(page.relative_to(ROOT), raw)
            if target is None:
                continue
            checked += 1
            candidate = ROOT / target
            if not candidate.is_file() and not (candidate.is_dir() and (candidate / "index.html").is_file()):
                failures.append(f"{page.name}: {raw!r} resolves to missing {target!r}")

    if failures:
        print("BLACK-JEE local HTML reference audit: FAIL")
        for failure in failures:
            print(f"- {failure}")
        return 1

    print(f"BLACK-JEE local HTML reference audit: PASS ({checked} local references across {len(pages)} pages)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
