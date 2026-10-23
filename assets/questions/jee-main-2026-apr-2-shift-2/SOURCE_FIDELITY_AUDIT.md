# Source-Fidelity Audit — JEE Main 2 April 2026 Shift 2

## Status: HOLD — 62/75 exact mappings verified; 13 rows remain unresolved or mismatched, and student-side visual/scoring validation remains

Official source documents:
- [NTA question-paper PDF](https://cdnbbsr.s3waas.gov.in/s3f8e59f4b2fe7c5705bf878bbd494ccdf/uploads/2026/04/20260409481957146.pdf)
- [NTA final answer key PDF](https://cdnbbsr.s3waas.gov.in/s3f8e59f4b2fe7c5705bf878bbd494ccdf/uploads/2026/04/20260420409057044.pdf)

## Correct source order

The NTA question-paper PDF displays Mathematics Q1–25, Physics Q26–50, then Chemistry Q51–75. The legacy draft uses the same displayed global numbering blocks. Answer-key question IDs are a separate identifier system; do not infer source order from the numeric appearance of answer-key IDs.

## Verified Physics chunk

Mathematics Q1–Q16 and Q21–Q25, Physics Q26–Q50, and Chemistry Q51–Q62 have been compared against the original paper and final answer key. For Q46–Q50, the numerical answers were independently checked as 6, 32, 300, 20, and 60. The Q41 prism, Q42 LCR circuit, and Q50 rod/sphere diagram were visually compared with the source where applicable. Mathematics Q1–Q5 statements, options, and official answer-key IDs were matched; their key answers for Q1–Q5 are D, C, B, D, and B; Q6–Q10 are C, C, C, D, and C. The verified rows remain audit-only; this does not authorize publication of the full shift.

## Remaining work

The authoritative `source-to-draft-crosswalk.json` currently records 62 `verified_exact_match` rows and 13 rows requiring review or replacement: 1 `needs_diagram_review`, 6 `needs_exact_review`, 1 `no_candidate_confirmed`, 2 `confirmed_mismatch`, and 3 `source_diagram_unresolved`. The automated structural audit passes, but a passing structural audit does not turn unresolved rows into exact matches. `SOURCE_CROSSWALK.json` has been synchronized to these statuses so it no longer overstates verification. This is **source mapping and structural validation**, not proof that every diagram, mathematical rendering, answer interaction, scoring result, or mobile layout has passed in the live student experience. Keep the shift unpublished until unresolved rows are resolved and end-to-end checks are completed.

## Chemistry answer-key cross-check (source questions 63–75)

The official final answer-key IDs/results for Chemistry Q63–Q75 are recorded below. These answer-key mappings alone do **not** certify that the current draft question text, options, or diagrams match the official paper:

| Chemistry source question | Official answer-key result |
|---:|---|
| 63 | Option A (question ID 691121213 → option ID 691121729) |
| 64 | Option C (691121214 → 691121735) |
| 65 | Option C (691121215 → 691121739) |
| 66 | Option C (691121216 → 691121743) |
| 67 | Option D (691121217 → 691121748) |
| 68 | Option B (691121218 → 691121750) |
| 69 | Option C (691121219 → 691121755) |
| 70 | Option D (691121220 → 691121760) |
| 71 | Numerical answer 5 (question ID 691121221) |
| 72 | Numerical answer 20 (691121222) |
| 73 | Numerical answer 560 (691121223) |
| 74 | Numerical answer 3 (691121224) |
| 75 | Numerical answer 1 (691121225) |

The official answer-key identifiers are recorded, but the source-to-draft crosswalk still flags several Chemistry candidates for exact wording/diagram review or replacement. Do not treat this table as proof that the draft content is publishable. The release hold remains until those issues and the live student interface are verified.

## Release gate

Keep the shift unpublished until all 75 source mappings have explicit evidence, every unresolved/mismatched candidate is corrected or replaced, all diagrams are checked, the answer key is reconciled against the exact question, and the student mock passes end-to-end rendering and scoring tests.
