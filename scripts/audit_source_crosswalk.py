#!/usr/bin/env python3
"""Fast integrity checks for the audit-only source-to-draft crosswalk."""
from __future__ import annotations

import json
import sys
from collections import Counter
from pathlib import Path

CROSSWALK = Path("assets/questions/jee-main-2026-apr-2-shift-2/source-to-draft-crosswalk.json")
SUBJECTS = ("Physics", "Chemistry", "Mathematics")
ALLOWED_STATUSES = {
    "candidate_matches_core_setup",
    "verified_exact_match",
    "confirmed_mismatch",
    "needs_exact_review",
    "needs_diagram_review",
    "no_candidate_confirmed",
    "source_diagram_unresolved",
    "source_extraction_unresolved",
}
EXPECTED_LEGACY_BLOCKS = {
    "Mathematics": range(1, 26),
    "Physics": range(26, 51),
    "Chemistry": range(51, 76),
}


def main() -> int:
    data = json.loads(CROSSWALK.read_text(encoding="utf-8"))
    records = data.get("records", [])
    errors: list[str] = []
    if len(records) != 75:
        errors.append(f"expected 75 records, found {len(records)}")

    seen_orders: list[int] = []
    seen_slots: set[tuple[str, int]] = set()
    observed_record_order: list[int] = []
    counts: Counter[str] = Counter()
    status_counts: Counter[str] = Counter()

    for i, record in enumerate(records, start=1):
        source = record.get("source", {})
        subject = source.get("subject")
        local = source.get("subject_question_number")
        paper_order = source.get("paper_order")
        status = record.get("status")
        counts[str(subject)] += 1
        status_counts[str(status)] += 1

        if subject not in SUBJECTS:
            errors.append(f"record {i}: unknown subject {subject!r}")
            continue
        if not isinstance(local, int) or not 1 <= local <= 25:
            errors.append(f"record {i}: invalid subject_question_number {local!r}")
        if not isinstance(paper_order, int) or not 1 <= paper_order <= 75:
            errors.append(f"record {i}: invalid paper_order {paper_order!r}")
        else:
            seen_orders.append(paper_order)
            observed_record_order.append(paper_order)
        slot = (subject, local)
        if slot in seen_slots:
            errors.append(f"duplicate source slot {slot}")
        seen_slots.add(slot)

        expected_order = {"Physics": 0, "Chemistry": 25, "Mathematics": 50}[subject] + local
        if paper_order != expected_order:
            errors.append(f"record {i}: {subject} Q{local} should have paper_order {expected_order}, got {paper_order!r}")
        if status not in ALLOWED_STATUSES:
            errors.append(f"record {i}: unknown status {status!r}")
        if record.get("publishable") is not False:
            errors.append(f"record {i}: audit-only crosswalk record must remain publishable=false")

        candidate = record.get("draft_candidate")
        if candidate is not None:
            if candidate.get("subject") != subject:
                errors.append(f"record {i}: candidate subject does not match source subject")
            candidate_number = candidate.get("legacy_global_question_number")
            if candidate_number not in EXPECTED_LEGACY_BLOCKS[subject]:
                errors.append(f"record {i}: candidate global number {candidate_number!r} is outside legacy {subject} block")
        if subject == "Mathematics" and local in range(17, 21):
            if status != "source_extraction_unresolved" or candidate is not None:
                errors.append(f"Mathematics Q{local}: unresolved source slots must not have a guessed candidate")

    if sorted(seen_orders) != list(range(1, 76)):
        errors.append("paper_order must contain each integer 1..75 exactly once")
    if observed_record_order != list(range(1, 76)):
        errors.append("records must be stored in source PDF order: Physics Q1–25, Chemistry Q1–25, Mathematics Q1–25")
    expected_slots = {(subject, number) for subject in SUBJECTS for number in range(1, 26)}
    missing_slots = sorted(expected_slots - seen_slots)
    if missing_slots:
        errors.append(f"missing source slots: {missing_slots}")
    for subject in SUBJECTS:
        if counts[subject] != 25:
            errors.append(f"{subject}: expected 25 records, found {counts[subject]}")

    print("BLACK-JEE SOURCE CROSSWALK AUDIT")
    print(f"- records={len(records)}")
    print(f"- subjects={dict(counts)}")
    print(f"- statuses={dict(status_counts)}")
    print("- all records are audit-only; no candidate can trigger automatic publication")
    if errors:
        for error in errors:
            print(f"ERROR: {error}")
        print(f"FAILED: {len(errors)} error(s)")
        return 1
    print("PASSED: crosswalk structure and safety gates are valid")
    return 0


if __name__ == "__main__":
    sys.exit(main())
