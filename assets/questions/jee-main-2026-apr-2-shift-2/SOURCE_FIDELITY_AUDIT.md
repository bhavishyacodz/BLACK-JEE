# Source-Fidelity Audit — JEE Main 2 April 2026 Shift 2

## Status: HOLD — source verification reset

The source-order review exposed a foundational mismatch between the printed NTA paper and the legacy draft's internal global numbering.

- **Official printed paper order:** Physics Q1–25, Chemistry Q1–25, Mathematics Q1–25.
- **Legacy draft global slots:** Mathematics 1–25, Physics 26–50, Chemistry 51–75.
- **Corrected crosswalk:** source rows are ordered Physics → Chemistry → Mathematics and candidates are aligned to the draft by subject and subject-local question number.
- **Verification status:** all 75 crosswalk rows have been reset to `needs_exact_review`. This is intentionally conservative: a matching subject and local number is only a candidate mapping, not proof of matching text, values, options, diagrams, or answers.

Official source documents:
- [NTA question-paper PDF](https://cdnbbsr.s3waas.gov.in/s3f8e59f4b2fe7c5705bf878bbd494ccdf/uploads/2026/04/20260409481957146.pdf)
- [NTA final answer key PDF](https://cdnbbsr.s3waas.gov.in/s3f8e59f4b2fe7c5705bf878bbd494ccdf/uploads/2026/04/20260420409057044.pdf)

A published transcription of the paper identifies the parts as Physics, Chemistry, then Mathematics; the repository's prior audit text incorrectly stated Mathematics, Physics, then Chemistry. That earlier statement and its 62/75 verified count are withdrawn. The old Chemistry answer-key table labelled source Q63–Q75 is also not authoritative for global source order and must not be used as proof of exact matches.

## Audit gates

1. Compare each source question with the subject-local draft candidate, including every value, option, diagram and question type.
2. Check the exact question's official final answer key; independently recompute numerical answers where practical.
3. Verify MathJax/diagram rendering, mobile layout, answer submission, scoring and solution behavior in the student UI.
4. Keep every row `publishable: false` and publication status `HOLD` until all 75 mappings and end-to-end tests pass.

Structural CI only validates data shape, asset paths, mapping consistency and release guards. A passing structural audit is not source-fidelity approval.
