# Source-Fidelity Audit — JEE Main 2 April 2026 Shift 2

## Status: HOLD — 75/75 source mappings checked; student-side visual/scoring validation remains

Official source documents:
- [NTA question-paper PDF](https://cdnbbsr.s3waas.gov.in/s3f8e59f4b2fe7c5705bf878bbd494ccdf/uploads/2026/04/20260409481957146.pdf)
- [NTA final answer key PDF](https://cdnbbsr.s3waas.gov.in/s3f8e59f4b2fe7c5705bf878bbd494ccdf/uploads/2026/04/20260420409057044.pdf)

## Correct source order

The NTA question-paper PDF displays Mathematics Q1–25, Physics Q26–50, then Chemistry Q51–75. The legacy draft uses the same displayed global numbering blocks. Answer-key question IDs are a separate identifier system; do not infer source order from the numeric appearance of answer-key IDs.

## Verified Physics chunk

Mathematics Q1–Q16 and Q21–Q25, Physics Q26–Q50, and Chemistry Q51–Q62 have been compared against the original paper and final answer key. For Q46–Q50, the numerical answers were independently checked as 6, 32, 300, 20, and 60. The Q41 prism, Q42 LCR circuit, and Q50 rod/sphere diagram were visually compared with the source where applicable. Mathematics Q1–Q5 statements, options, and official answer-key IDs were matched; their key answers for Q1–Q5 are D, C, B, D, and B; Q6–Q10 are C, C, C, D, and C. The verified rows remain audit-only; this does not authorize publication of the full shift.

## Remaining work

The source crosswalk now records all 75 question mappings as verified, including Chemistry Q63–Q75 after reconciliation with the available source transcription and the official NTA final answer key. The automated question-batch audit has passed for the latest crosswalk commit. This is **source mapping and structural validation**, not proof that every diagram, mathematical rendering, answer interaction, scoring result, or mobile layout has passed in the live student experience. Keep the shift unpublished until those end-to-end checks are completed.

## Chemistry answer-key cross-check (source questions 63–75)

The official final answer-key mappings for Chemistry Q63–Q75 are recorded in `SOURCE_CROSSWALK.json` and cross-checked against the reconciled draft mapping:

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

The mapping and answer-key reconciliation is complete for these rows. The separate release hold remains until the live student interface passes diagram rendering, mathematical formatting, answer selection, scoring, and mobile layout checks.

## Release gate

Keep the shift unpublished until all 75 source mappings have explicit evidence, all diagrams are checked, the answer key is reconciled, and the student mock passes end-to-end rendering and scoring tests.
