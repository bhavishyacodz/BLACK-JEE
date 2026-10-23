# BLACK-JEE Shift Import Standard

## Core rule: two views, one source of truth

Every shift has one canonical dataset containing one record per source question. Student UI, admin UI, chapter filters, preview pages, and review tools should all read from these records; do not maintain separate copies of the same question in different tabs. Different views are only projections of the same question record — two bodies, one soul.

## Fast, repeatable pipeline

1. **Ingest once:** preserve the official question text, options, numerical answer format, subject, source question number, and diagram references in one JSON batch.
2. **Preserve the actual paper order:** do not reorder questions for convenience. For this 2 April 2026 Shift 2 source, the paper order is Physics Q1–25, Chemistry Q26–50, then Mathematics Q51–75. Other shifts must be checked against their own source rather than assuming this order.
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

Keep three concepts separate in the canonical dataset:

- `paper_order`: unique position 1–75 in the full paper, following the actual document order.
- `subject_question_number`: position within the subject section, following the printed question numbering.
- `source_question_number`: legacy field in the current draft; it is presently used as a global paper position by the audit script and must not be confused with a subject-local number.

For this shift, global paper positions 1–25 are Physics, 26–50 Chemistry, and 51–75 Mathematics. Preserve the original Section A/Section B identity separately if the UI needs it. Do not bulk-renumber the existing draft until each question has been matched by exact content, options, diagram, and answer to the source. When migrating the application schema, update importer, filters, UI labels, and tests together; do not silently rename fields in the JSON alone.


## Source crosswalk gate

For source reconciliation, maintain `assets/questions/<shift>/source-to-draft-crosswalk.json` as an audit-only index. Every source slot must be present in source order and classified with a status; a candidate mapping is only a pointer for review, never proof of equivalence. The crosswalk must not set `publishable: true` and must not trigger automatic renumbering.

Run both fast validators before a manual source review:

```bash
python scripts/audit_source_crosswalk.py
python scripts/audit_jee_batch.py --expect 75 --expect-per-subject 25 --json-out audit-report.json
```

The crosswalk validator checks 75 unique paper positions, 25 slots per subject, correct subject-local/global order, legacy candidate blocks, allowed review states, and the non-publication gate. The batch validator checks the draft's structural integrity. Both are required; passing either one alone is insufficient. For a new shift, parameterize the expected subject order and question counts from that shift's actual paper, rather than copying the April 2 Shift 2 assumptions.

### Review-state meanings

- `candidate_matches_core_setup`: similar core setup found; exact text/options/diagram/key still require review.
- `confirmed_mismatch`: a concrete content discrepancy is already known.
- `needs_exact_review`: plausible relationship, but exact matching is not established.
- `needs_diagram_review`: the figure must be compared against the source.
- `no_candidate_confirmed`: no likely draft record identified.
- `source_diagram_unresolved`: a source structure/figure has not been reconciled.
- `source_extraction_unresolved`: the available source text does not establish this slot; inspect original page images or another authoritative copy, do not guess.
