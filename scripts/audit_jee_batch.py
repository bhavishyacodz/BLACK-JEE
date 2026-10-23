#!/usr/bin/env python3
"""Fast, deterministic QA for BLACK-JEE's staged JEE Main question batches.

Run from repository root:
  python scripts/audit_jee_batch.py
  python scripts/audit_jee_batch.py path/to/batch.json --json-out audit-report.json
  python scripts/audit_jee_batch.py --all-json

This catches structural defects and obvious asset problems. It cannot prove source fidelity,
scientific correctness, or that a diagram matches the official paper; those need review.
"""
from __future__ import annotations

import argparse
import json
import re
import sys
from collections import Counter, defaultdict
from pathlib import Path
from urllib.parse import urlparse

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_BATCH = ROOT / "assets/questions/jee-main-2026-apr-2-shift-2/full-shift-2-75-draft.json"
CROSSWALK_PATH = ROOT / "assets/questions/jee-main-2026-apr-2-shift-2/SOURCE_CROSSWALK.json"
REQUIRED = (
    "year", "session", "subject", "chapter", "source_question_number",
    "question_text", "question_type", "options", "marks_correct", "marks_wrong",
    "is_published", "image_url", "correct_answer", "solution",
)
SUBJECTS = {"Physics", "Chemistry", "Mathematics"}
LETTERS = {"A", "B", "C", "D"}
RAW_PREFIX = "https://raw.githubusercontent.com/bhavishyacodz/BLACK-JEE/main/"


def issue(report, level, code, where, message):
    report["issues"].append({
        "level": level, "code": code, "where": str(where), "message": message
    })


def asset_path(url):
    if not url:
        return None
    if url.startswith(RAW_PREFIX):
        return ROOT / url[len(RAW_PREFIX):]
    parsed = urlparse(url)
    if parsed.scheme in ("", "file"):
        return (ROOT / url.lstrip("/")) if not parsed.scheme else Path(parsed.path)
    return None


def audit_file(path):
    report = {
        "file": str(path.relative_to(ROOT) if path.is_relative_to(ROOT) else path),
        "records": 0, "subjects": {}, "types": {}, "published": 0,
        "images": 0, "errors": 0, "warnings": 0, "issues": [],
    }
    try:
        records = json.loads(path.read_text(encoding="utf-8"))
    except Exception as exc:
        issue(report, "ERROR", "JSON_PARSE", path, f"Cannot parse JSON: {exc}")
        return finalize(report)

    if not isinstance(records, list):
        issue(report, "ERROR", "ROOT_NOT_ARRAY", path, "Batch root must be a JSON array.")
        return finalize(report)

    report["records"] = len(records)
    subject_counts, type_counts = Counter(), Counter()
    seen = defaultdict(list)

    # Preserve source-paper order: the canonical shift batch must not silently
    # shuffle questions between tabs/subjects during import.
    ordered_numbers = [
        q.get("source_question_number") if isinstance(q, dict) else None
        for q in records
    ]
    if all(isinstance(n, int) for n in ordered_numbers):
        if ordered_numbers != sorted(ordered_numbers):
            issue(report, "ERROR", "SOURCE_ORDER", path.name,
                  "Records are not in ascending source_question_number order; restore original paper order.")
        if len(set(ordered_numbers)) != len(ordered_numbers):
            issue(report, "ERROR", "DUPLICATE_GLOBAL_NUMBER", path.name,
                  "Duplicate source question numbers found across the batch.")
    for index, q in enumerate(records, 1):
        where = f"{path.name}[{index}]"
        if not isinstance(q, dict):
            issue(report, "ERROR", "RECORD_NOT_OBJECT", where, "Each record must be an object.")
            continue

        missing = [key for key in REQUIRED if key not in q]
        if missing:
            issue(report, "ERROR", "MISSING_FIELDS", where, "Missing: " + ", ".join(missing))

        subject = q.get("subject")
        if subject:
            subject_counts[subject] += 1
            if subject not in SUBJECTS:
                issue(report, "WARN", "UNKNOWN_SUBJECT", where, f"Unexpected subject label: {subject!r}")

        qtype = q.get("question_type")
        if qtype:
            type_counts[qtype] += 1
        number = q.get("source_question_number")
        if number is not None:
            seen[(subject, number)].append(index)
            if not isinstance(number, int) or number < 1:
                issue(report, "ERROR", "BAD_QUESTION_NUMBER", where, f"Invalid source question number: {number!r}")

        for field in ("question_text", "chapter", "session", "correct_answer", "solution"):
            value = q.get(field)
            if not isinstance(value, str) or not value.strip():
                issue(report, "ERROR", "EMPTY_REQUIRED_TEXT", where, f"{field} must be a non-empty string.")

        options = q.get("options")
        if not isinstance(options, list):
            issue(report, "ERROR", "OPTIONS_NOT_ARRAY", where, "options must be an array.")
            options = []
        if qtype == "MCQ":
            if len(options) != 4:
                issue(report, "ERROR", "MCQ_OPTION_COUNT", where, f"MCQ has {len(options)} options; expected 4.")
            if str(q.get("correct_answer", "")).strip().upper() not in LETTERS:
                issue(report, "ERROR", "MCQ_BAD_KEY", where, "MCQ correct_answer must be A, B, C, or D.")
        elif qtype == "Numerical":
            if options:
                issue(report, "WARN", "NUMERICAL_HAS_OPTIONS", where, "Numerical question has options; confirm question type.")
            answer = str(q.get("correct_answer", "")).strip()
            if answer and not re.fullmatch(r"[+-]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?", answer):
                issue(report, "WARN", "NUMERICAL_KEY_FORMAT", where, f"Numerical key is not a plain number: {answer!r}.")
        elif qtype:
            issue(report, "WARN", "UNKNOWN_QUESTION_TYPE", where, f"Review unsupported type {qtype!r}.")

        if q.get("is_published") is True:
            report["published"] += 1
            issue(report, "WARN", "PUBLISHED_IN_DRAFT", where, "Staging batch contains a published record.")

        image_url = q.get("image_url", "")
        if image_url:
            report["images"] += 1
            local = asset_path(image_url)
            if local is None:
                issue(report, "WARN", "UNRECOGNIZED_IMAGE_URL", where, "Image URL is not a repository raw URL; verify it manually.")
            elif not local.is_file():
                issue(report, "ERROR", "MISSING_IMAGE_FILE", where, f"Referenced asset not found: {local.relative_to(ROOT) if local.is_relative_to(ROOT) else local}")
            elif local.suffix.lower() == ".svg":
                try:
                    svg = local.read_text(encoding="utf-8")
                    if "<svg" not in svg[:1000] or "</svg>" not in svg:
                        issue(report, "ERROR", "SVG_STRUCTURE", where, f"SVG root/closing tag missing in {local.name}.")
                    if re.search(r"<script\b|<foreignObject\b", svg, re.I):
                        issue(report, "WARN", "SVG_ACTIVE_CONTENT", where, f"Review active SVG content in {local.name}.")
                except Exception as exc:
                    issue(report, "ERROR", "SVG_READ", where, f"Cannot read {local.name}: {exc}")

        text = str(q.get("question_text", ""))
        if text.count(r"\(") != text.count(r"\)"):
            issue(report, "WARN", "MATH_DELIMITER_COUNT", where, "Unequal inline MathJax delimiter counts; inspect notation.")
        if "undefined" in text.lower() or "todo" in text.lower() or "[insert" in text.lower():
            issue(report, "WARN", "PLACEHOLDER_TEXT", where, "Question contains a possible placeholder.")

    for key, indexes in seen.items():
        if len(indexes) > 1:
            issue(report, "ERROR", "DUPLICATE_SUBJECT_NUMBER", path.name,
                  f"{key[0]} Q{key[1]} appears {len(indexes)} times (records {indexes}).")

    report["subjects"] = dict(sorted(subject_counts.items()))
    report["types"] = dict(sorted(type_counts.items()))
    return finalize(report)



def audit_crosswalk(report, batch_records):
    """Validate the source-to-draft crosswalk without treating candidates as verified."""
    if not CROSSWALK_PATH.is_file():
        issue(report, "ERROR", "CROSSWALK_MISSING", CROSSWALK_PATH,
              "Source crosswalk is missing; every shift needs a reconciliation ledger.")
        return
    try:
        manifest = json.loads(CROSSWALK_PATH.read_text(encoding="utf-8"))
    except Exception as exc:
        issue(report, "ERROR", "CROSSWALK_PARSE", CROSSWALK_PATH,
              f"Cannot parse source crosswalk: {exc}")
        return
    rows = manifest.get("rows") if isinstance(manifest, dict) else None
    if not isinstance(rows, list):
        issue(report, "ERROR", "CROSSWALK_ROWS", CROSSWALK_PATH,
              "Crosswalk must contain a rows array.")
        return
    expected_subject = ["Mathematics"] * 25 + ["Physics"] * 25 + ["Chemistry"] * 25
    orders = [row.get("paper_order") if isinstance(row, dict) else None for row in rows]
    if orders != list(range(1, 76)):
        issue(report, "ERROR", "CROSSWALK_ORDER", CROSSWALK_PATH,
              "Crosswalk must contain exactly paper_order 1..75 in ascending order.")
    by_number = {
        q.get("source_question_number"): q for q in batch_records
        if isinstance(q, dict) and isinstance(q.get("source_question_number"), int)
    }
    status_counts = Counter()
    for index, row in enumerate(rows, 1):
        where = f"{CROSSWALK_PATH.name}.rows[{index}]"
        if not isinstance(row, dict):
            issue(report, "ERROR", "CROSSWALK_ROW_TYPE", where, "Each crosswalk row must be an object.")
            continue
        order = row.get("paper_order")
        if isinstance(order, int) and 1 <= order <= 75:
            expected = expected_subject[order - 1]
            if row.get("subject") != expected:
                issue(report, "ERROR", "CROSSWALK_SUBJECT_ORDER", where,
                      f"Paper position {order} must be {expected}, not {row.get('subject')!r}.")
            local_number = ((order - 1) % 25) + 1
            if row.get("subject_question_number") != local_number:
                issue(report, "ERROR", "CROSSWALK_LOCAL_NUMBER", where,
                      f"Expected subject_question_number {local_number}.")
            expected_section = "A" if local_number <= 20 else "B"
            if row.get("section") != expected_section:
                issue(report, "ERROR", "CROSSWALK_SECTION", where,
                      f"Expected section {expected_section} for subject question {local_number}.")
        status = row.get("status")
        status_counts[status] += 1
        candidate = row.get("draft_candidate_global_number")
        if candidate is not None:
            draft = by_number.get(candidate)
            if draft is None:
                issue(report, "ERROR", "CROSSWALK_CANDIDATE_MISSING", where,
                      f"Draft candidate global number {candidate} does not exist.")
            elif draft.get("subject") != row.get("subject"):
                issue(report, "ERROR", "CROSSWALK_CANDIDATE_SUBJECT", where,
                      f"Candidate {candidate} is {draft.get('subject')!r}, not {row.get('subject')!r}.")
        if status == "verified" and not str(row.get("verification_evidence", "")).strip():
            issue(report, "ERROR", "CROSSWALK_VERIFICATION_EVIDENCE", where,
                  "Verified rows require a source citation/page and answer-key check note.")
    allowed_statuses = {"unmatched", "candidate_needs_exact_review", "verified"}
    for status in status_counts:
        if status not in allowed_statuses:
            issue(report, "ERROR", "CROSSWALK_UNKNOWN_STATUS", CROSSWALK_PATH.name,
                  f"Unsupported crosswalk status: {status!r}.")
    pending = sum(count for status, count in status_counts.items() if status != "verified")
    if pending:
        issue(report, "ERROR", "SOURCE_FIDELITY_PENDING", CROSSWALK_PATH.name,
              f"{pending} of {len(rows)} source rows are not verified; publication gate must fail.")
    report["crosswalk"] = {
        "rows": len(rows),
        "statuses": dict(sorted((str(k), v) for k, v in status_counts.items())),
        "verified_rows": status_counts.get("verified", 0),
    }


def finalize(report):
    report["errors"] = sum(i["level"] == "ERROR" for i in report["issues"])
    report["warnings"] = sum(i["level"] == "WARN" for i in report["issues"])
    return report


def main():
    parser = argparse.ArgumentParser(description="Run fast structural QA on BLACK-JEE question JSON.")
    parser.add_argument("batch", nargs="?", help="JSON batch path, relative to repo root or absolute.")
    parser.add_argument("--all-json", action="store_true", help="Audit every JSON file in the April 2 Shift 2 folder.")
    parser.add_argument("--json-out", help="Write full machine-readable report to this path.")
    parser.add_argument("--expect", type=int, default=None, help="Expected record count for the selected batch.")
    parser.add_argument("--expect-per-subject", type=int, default=None, help="Require the expected global source-number ranges for each subject.")
    args = parser.parse_args()

    folder = ROOT / "assets/questions/jee-main-2026-apr-2-shift-2"
    if args.all_json:
        paths = sorted(folder.glob("*.json"))
    else:
        paths = [Path(args.batch).resolve() if args.batch else DEFAULT_BATCH.resolve()]
    if not paths:
        print("ERROR: no JSON files selected", file=sys.stderr)
        return 2

    reports = [audit_file(p) for p in paths]
    if args.expect_per_subject is not None and len(reports) == 1:
        path = paths[0]
        report = reports[0]
        try:
            records = json.loads(path.read_text(encoding="utf-8"))
        except Exception:
            records = []
        if isinstance(records, list):
            # JEE Main Paper 1 source order for this shift: Physics, Chemistry,
            # Mathematics. Keep global source numbers aligned with the original paper.
            subject_starts = {"Physics": 1, "Chemistry": args.expect_per_subject + 1,
                              "Mathematics": 2 * args.expect_per_subject + 1}
            for subject in sorted(SUBJECTS):
                numbers = sorted(q.get("source_question_number") for q in records
                                 if isinstance(q, dict) and q.get("subject") == subject
                                 and isinstance(q.get("source_question_number"), int))
                start = subject_starts[subject]
                end = start + args.expect_per_subject - 1
                expected_numbers = list(range(start, end + 1))
                if numbers != expected_numbers:
                    issue(report, "ERROR", "SUBJECT_COVERAGE", report["file"],
                          f"{subject}: expected global question numbers {start}..{end}; found {numbers}.")
            if path.resolve() == DEFAULT_BATCH.resolve():
                audit_crosswalk(report, records)
            finalize(report)
    if args.expect is not None and len(reports) == 1 and reports[0]["records"] != args.expect:
        issue(reports[0], "ERROR", "UNEXPECTED_RECORD_COUNT", reports[0]["file"],
              f"Expected {args.expect} records, found {reports[0]['records']}.")
        finalize(reports[0])

    combined = {
        "tool": "BLACK-JEE deterministic batch audit",
        "scope": "Structural/data/asset checks only; not proof of source or answer correctness.",
        "files": reports,
        "summary": {
            "files": len(reports),
            "records": sum(r["records"] for r in reports),
            "errors": sum(r["errors"] for r in reports),
            "warnings": sum(r["warnings"] for r in reports),
            "published_records": sum(r["published"] for r in reports),
        },
    }
    print("BLACK-JEE FAST AUDIT")
    for r in reports:
        crosswalk = r.get("crosswalk")
        crosswalk_text = f" | crosswalk={crosswalk['verified_rows']}/{crosswalk['rows']} verified" if crosswalk else ""
        print(f"- {r['file']}: {r['records']} records | subjects={r['subjects']} | types={r['types']} | images={r['images']} | published={r['published']}{crosswalk_text} | errors={r['errors']} | warnings={r['warnings']}")
        for i in r["issues"]:
            print(f"  {i['level']} {i['code']} [{i['where']}]: {i['message']}")
    s = combined["summary"]
    print(f"SUMMARY: {s['files']} file(s), {s['records']} record(s), {s['errors']} error(s), {s['warnings']} warning(s).")
    if args.json_out:
        output = Path(args.json_out)
        if not output.is_absolute():
            output = ROOT / output
        output.parent.mkdir(parents=True, exist_ok=True)
        output.write_text(json.dumps(combined, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
        print(f"Machine report: {output}")
    return 1 if s["errors"] else 0


if __name__ == "__main__":
    raise SystemExit(main())
