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


## Source comparison pass — Physics Q1–Q25 (2026-10-23)

**Source used:** [Readable transcription of the NTA paper](https://image-static.collegedunia.com/public/image/JEE_Main_2026_April_2_Shift_2_Question_Paper_a61eefd575669441bcfedf17fe413c6c.pdf), checked against the staged JSON. This is a transcription aid, not a substitute for inspecting the original source figure and final NTA key.

The subject-local mapping assumption has been replaced for Physics with topic-based candidate links. This pass found clear source/draft differences at Physics Q1–Q4, Q9–Q11, Q15, Q19 and Q24 (option format, question type, signs, values or geometry differ). Those rows are marked `confirmed_mismatch`, not verified. Other topic candidates remain `needs_exact_review` until exact wording, diagrams and the final answer key are checked. Source Physics Q5 has no correctly classified Physics candidate; a work-function question appears in the Chemistry-labelled draft at legacy Q71 and needs triage. The available transcription omits Physics Q25, so it remains `source_extraction_unresolved` with no guessed candidate.

**Result:** no Physics row is promoted to verified; all remain non-publishable. Publication status stays HOLD.


## Source comparison pass — Chemistry Q1–Q25 (2026-10-23)

**Source used:** [Readable transcription of the NTA paper](https://image-static.collegedunia.com/public/image/JEE_Main_2026_April_2_Shift_2_Question_Paper_a61eefd575669441bcfedf17fe413c6c.pdf). Candidate links below are topic-based leads, not exact-match certification.

This pass found clear differences in Chemistry Q9 (H₂S vs H₂A and changed Ka), Q11 (Gd²⁺ vs Gd³⁺), Q15 (different coordination-complex list) and Q17 (Co²⁺ vs Cr²⁺). Those rows are marked `confirmed_mismatch`. Chemistry Q3 has no matching draft candidate; Q25 is incomplete in the available transcription. Other links remain pending exact statement, options/diagram and official-key review. Chemistry Q4's work-function item appears to correspond to legacy Q71; it is distinct from Physics Q5's different photoelectric-effect question.

**Result:** no Chemistry row is promoted to verified; publication remains HOLD.


## Source comparison pass — Mathematics Q1–Q25 (2026-10-23)

**Source used:** [Readable transcription of the NTA paper](https://image-static.collegedunia.com/public/image/JEE_Main_2026_April_2_Shift_2_Question_Paper_a61eefd575669441bcfedf17fe413c6c.pdf). Candidate links are content-based leads, not exact-match certification.

Clear differences were found in Mathematics Q3 (different vectors), Q8 (different linear-system coefficients), Q12 (different greatest-integer expression), Q15 (different requested expression), Q16 (different requested area expression), Section-B Q1 (different trigonometric expression), and Section-B Q4 (matrix B entries differ). Those rows are marked `confirmed_mismatch`. The available transcription omits Section-A Q17–Q20, so those four source rows have no guessed candidates and remain `source_extraction_unresolved`. Other candidates still require exact statement/options and final-key verification.

**Result:** no Mathematics row is promoted to verified; publication remains HOLD.

## Audit gates

1. Compare each source question with the subject-local draft candidate, including every value, option, diagram and question type.
2. Check the exact question's official final answer key; independently recompute numerical answers where practical.
3. Verify MathJax/diagram rendering, mobile layout, answer submission, scoring and solution behavior in the student UI.
4. Keep every row `publishable: false` and publication status `HOLD` until all 75 mappings and end-to-end tests pass.

Structural CI only validates data shape, asset paths, mapping consistency and release guards. A passing structural audit is not source-fidelity approval.
