# BLACK-JEE fast question audit system

The goal is to spend model tokens on judgment calls, not on repeatedly recounting fields or checking whether files exist. Run deterministic checks first, then ask for targeted human/AI review only where the report flags uncertainty.

## One-command audit

From the repository root:

\`\`\`bash
python scripts/audit_jee_batch.py --expect 75 --json-out audit-report.json
\`\`\`

The default target is \`assets/questions/jee-main-2026-apr-2-shift-2/full-shift-2-75-draft.json\`.

To check every JSON batch in that folder:

\`\`\`bash
python scripts/audit_jee_batch.py --all-json --json-out audit-report.json
\`\`\`

The report prints a short summary and can write a machine-readable JSON report. Exit code is non-zero when structural errors are found, so it can be used in CI.

## What it checks automatically

- JSON parses and the root is an array.
- Required fields exist and key text fields are non-empty.
- Subject/type counts, question-number validity, and duplicate subject/question pairs.
- MCQs have four options and an A/B/C/D answer key.
- Numerical questions have a plain numeric key where possible.
- Draft batches do not silently contain published records.
- Every referenced repository SVG exists and has a basic SVG root/closing tag.
- Suspicious SVG active content, placeholder text, and simple math-delimiter issues are flagged for review.

## What it deliberately does not claim

A clean report is **not** proof that a question matches the official paper, that the answer key is mathematically correct, that an explanation is valid, or that a diagram is pixel-faithful. Those require source comparison and independent solving. The script never auto-corrects questions and never publishes anything.

## CI workflow

\`.github/workflows/jee-pyq-audit.yml\` runs the 75-record structural audit when relevant files change and can be started manually from GitHub Actions. It uploads \`audit-report.json\` as a short-lived artifact, including when the checks fail.

## Token-efficient review protocol

1. Run the deterministic audit and share only the summary plus flagged records.
2. Review source fidelity in small numbered batches (for example, 5–10 questions), citing official-paper page/question numbers.
3. Recalculate answers independently; keep statement/key disagreements as explicit blockers.
4. Review diagrams separately for geometry, labels, values, readability, and answer leakage.
5. Change a record only when the source evidence supports the correction; log the change and rerun the audit.
6. Keep unresolved items unpublished. A green structural audit must never auto-publish a question.

## Severity labels for the next review pass

- **ERROR** — structural issue or missing local asset; fix before importing/publishing.
- **WARN** — suspicious or ambiguous item; inspect against the official source.
- **MANUAL SOURCE CHECK** — exact wording, answer, explanation, diagram fidelity, and whether the diagram gives away the answer. These remain human-review tasks even if the script reports no issues.
