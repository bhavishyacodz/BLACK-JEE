# Source-Fidelity Audit — JEE Main 2 April 2026 Shift 2

## Status: HOLD — source verification reset

The source-order review exposed a foundational mismatch between the printed NTA paper and the legacy draft's internal global numbering.

- **Official printed paper order:** Physics Q1–25, Chemistry Q1–25, Mathematics Q1–25.
- **Legacy draft global slots:** Mathematics 1–25, Physics 26–50, Chemistry 51–75.
- **Corrected crosswalk:** source rows are ordered Physics → Chemistry → Mathematics and candidates are aligned to the draft by subject and subject-local question number.
- **Current verification status:** 10 rows are marked `confirmed_mismatch`, 59 remain `needs_exact_review`, and 6 are `source_extraction_unresolved`. All 75 remain non-publishable; none is marked `verified_exact_match`. These are preliminary content-comparison statuses based on a readable transcription, not final answer-key certification.

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


## Correction pass — five Physics candidates updated (2026-10-23)

Updated legacy draft candidates for Physics source Q1, Q2, Q3, Q4 and Q24 (legacy Q28, Q37, Q27, Q35 and Q36 respectively) to match the readable transcription's values, question format and answer options. The Atwood, rotating-cylinder, bubble-viscosity, falling-ball and electromagnetic-wave entries were edited. These rows were moved from `confirmed_mismatch` to `needs_exact_review`, not marked verified: final NTA answer-key checks and source-image checks are still required. Publication remains HOLD.


## Correction pass — Physics Q9 candidate (2026-10-23)

Legacy draft Q31 was corrected to match source Physics Q9: the question asks only for the speed of a 1 kg object falling from a long distance, with options 12.5, 11.2, 9.8 and 2.4 km/s. The prior draft incorrectly also asked for kinetic energy and had paired speed/energy options. The row is now `needs_exact_review`, not verified, pending the official final answer key.


## Correction pass — Physics Q15 (2026-10-23)

Legacy Q29 was aligned to the readable transcription's force vector, magnetic field (2×10⁻³ k̂ T), and velocity options. Recalculation gives 50 î + 100 ĵ m/s (option A). The crosswalk status changed from `confirmed_mismatch` to `needs_exact_review`; the official final answer key has not yet been independently confirmed. Publication remains HOLD.


## Correction pass — Physics Q11 (2026-10-23)

Legacy Q33 now preserves the source's numerical-response format instead of presenting four MCQ options. For the soap bubble, W=8πT(r₂²−r₁²)=1.92π×10⁻⁴ J, so α=1.92. Crosswalk status moved to `needs_exact_review`; official answer-key confirmation is still pending and publication remains HOLD.


## Correction pass — Chemistry Q11 and Q17 (2026-10-23)

- **Chemistry Q11 / legacy Q74:** corrected the source ion list to include Gd²⁺ rather than Gd³⁺. The calculated paramagnetic count is 3; final answer-key confirmation remains open.
- **Chemistry Q17 / legacy Q70:** corrected the options to Zn²⁺, Fe³⁺, Fe²⁺ and Co²⁺. Candidate answer is Fe³⁺ (option B), pending official key verification.

Both crosswalk rows moved to `needs_exact_review`. Publication remains HOLD.


## Diagram correction — Physics Q23 / legacy Q42 (2026-10-23)

The previous `q42.svg` incorrectly drew the inductors as shunt branches rather than as series elements with switch bypasses. It has been redrawn as one series RLC loop containing C, R, L₂ and L₁, with S₂ across L₂ and S₁ across L₁. The stem was corrected to request numerical `3L₂ − L₁` (not `3L₁ − L₂`), and the MCQ options were removed to preserve the numerical-response format. The circuit relations give the candidate value `2/9 H`. This remains `needs_exact_review`: original NTA figure and final key must still be independently checked. Do not treat the redraw as source-certified.


## Test-order view (2026-10-23)

Created `paper-order-75-audit-view.json` to inspect the paper in the printed sequence: Physics Q1–25, Chemistry Q1–25, Mathematics Q1–25. Rows with no candidate remain explicitly unfilled instead of being guessed. This is an audit-only view: it preserves legacy candidates and attaches source-order/crosswalk metadata, but does not certify or publish question content. All 75 entries remain `publishable: false` pending source fidelity and final-key verification.


## Correction pass — Chemistry Q9 (2026-10-23)

Legacy Q52 was aligned to the readable source transcription: H₂S in 0.1 M HCl, Ka₁=8.3×10⁻⁸, Ka₂=1.0×10⁻¹³, and the requested species [HS⁻]. The equilibrium estimate gives 8.3×10⁻⁸ M. The option list is only a candidate reconstruction; exact source options and official final-key verification remain open. Status moved to `needs_exact_review`; publication remains HOLD.


## Mock-test source-order correction (2026-10-23)

Updated `mock-tests.html` to sort a full shift by Physics → Chemistry → Mathematics, with Section A before Section B in each subject, and by the explicit source-paper question number from a local crosswalk keyed to each candidate question stem. Sorting occurs before the question-count limit is applied, preventing a 10/20/30-question test from being selected from an arbitrary database order. The ordering map is derived from the audit-only paper-order view and does not certify question content. Questions absent from the candidate crosswalk still require source extraction and must not be treated as verified. The app query does not depend on a newly assumed database column. Build/deployment and browser-level verification remain pending.


## Full-shift structure gate diagnostic (2026-10-23)

A structural audit of the 75-record draft found that the current legacy candidate set is not valid JEE Main Paper 1 section structure: Physics has 18 MCQ + 7 Numerical, while Chemistry and Mathematics each have 20 MCQ + 5 Numerical. Crosswalk sections classify Physics Q1–20 as Section A and Q21–25 as Section B, so the mismatch appears to include incorrectly typed candidate records. Do not force types or invent options without source confirmation. Updated `mock-tests.html` validation errors to report per-subject MCQ/numerical counts and keep a full-shift start blocked until the structure is corrected.
