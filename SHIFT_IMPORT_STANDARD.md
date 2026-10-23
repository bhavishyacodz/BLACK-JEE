# BLACK-JEE Shift Import Standard

## Core rule: two views, one source of truth

Every shift has one canonical dataset containing one record per source question. Student UI, admin UI, chapter filters, preview pages, and review tools should all read from these records; do not maintain separate copies of the same question in different tabs. Different views are only projections of the same question record — two bodies, one soul.

## Fast, repeatable pipeline

1. **Ingest once:** preserve the official question text, options, numerical answer format, subject, source question number, and diagram references in one JSON batch.
2. **Preserve source order:** do not reorder questions for convenience. Keep each question's source number as a stable identifier; for a 75-question paper, expect 1–25 Mathematics, 26–50 Physics, and 51–75 Chemistry only when that matches the source paper.
3. **Keep diagrams as files:** save each diagram as a version-controlled asset and reference it from the canonical question. Missing or uncertain diagrams must be flagged, never invented.
4. **Run fast automated checks:** JSON schema, required fields, option/key formats, duplicates, source-number order, subject coverage, image existence, and draft publication status.
5. **Run subject checks in parallel-sized chunks:** independently calculate answers and units; record uncertain wording or ambiguous keys in `CONTENT_REVIEW_LOG.md`.
6. **Compare with the trusted paper/key:** verify exact wording, options, diagrams, and final answer key. Automated calculations alone cannot establish source fidelity.
7. **Release gate:** keep every record unpublished until all critical issues are resolved and CI passes. Do not write to the live database as part of draft ingestion.

## Quality guarantees and limits

The goal is to make imports fast, repeatable, and auditable. Structural checks can catch omissions, duplicates, reordering, broken assets, and malformed records; they cannot guarantee that a transcription or diagram is perfect without comparison to the source. When the source is unclear, flag it instead of guessing.

## Current command

```bash
python scripts/audit_jee_batch.py --expect 75 --expect-per-subject 25 --json-out audit-report.json
```

For a different shift, update the canonical batch path and expected counts to match that exam's actual structure before running the audit.


## Numbering convention (important)

Keep two concepts separate in every future import:

- `paper_order`: one unique 1–75 sequence for the entire source document, preserving its actual page/section order.
- `subject_question_number`: the number printed within that subject/section, normally 1–25 for this shift, including Section B's printed question positions as specified by the source.

Do not overload one field to represent both. The current legacy draft uses `source_question_number` as its unique global sequence, so the current audit checks subject ranges against that legacy convention. When migrating the application schema, update the importer, filters, UI labels, and tests together; do not silently rename the field in the JSON alone.
