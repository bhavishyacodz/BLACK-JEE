# JEE Main 2026 — 2 April Shift 2 diagram audit

This folder contains custom SVG redraws and draft metadata for diagram-based PYQ work. The question numbers refer to the displayed numbers in the source paper.

| Question | Topic | Asset |
|---|---|---|
| Q28 | Atwood machine with 2 kg and 1 kg blocks | [q28.svg](q28.svg) |
| Q30 | NAND logic circuit / equivalent gate (Semiconductor Electronics) | [q30.svg](q30.svg) |
| Q41 | Equilateral prism with painted face / total internal reflection | [q41.svg](q41.svg) |
| Q42 | LCR series circuit with switches S1 and S2 | [q42.svg](q42.svg) |
| Q50 | Moment of inertia: rod and sphere, parallel axes | [q50.svg](q50.svg) |
| Q57 | Chemical kinetics statements (no diagram in the source question) | No image asset |
| Q63 | Diarylmethyl carbocation / carbanion resonance statements | [q63.svg](q63.svg) |
| Q66 | Organic product structure options | [q66.svg](q66.svg) |
| Q67 | Enol-ether substrate for hydrolysis | [q67.svg](q67.svg) |
| Q68 | Aromatic substitution / diazotisation / oxidation sequence | [q68.svg](q68.svg) |
| Q75 | p-Nitrotoluene reaction sequence / Carius analysis | [q75.svg](q75.svg) |

## Diagram URLs

Use raw GitHub URLs for the database's `image_url` field:

- Q28: https://raw.githubusercontent.com/bhavishyacodz/BLACK-JEE/main/assets/questions/jee-main-2026-apr-2-shift-2/q28.svg
- Q30: https://raw.githubusercontent.com/bhavishyacodz/BLACK-JEE/main/assets/questions/jee-main-2026-apr-2-shift-2/q30.svg
- Q41: https://raw.githubusercontent.com/bhavishyacodz/BLACK-JEE/main/assets/questions/jee-main-2026-apr-2-shift-2/q41.svg
- Q42: https://raw.githubusercontent.com/bhavishyacodz/BLACK-JEE/main/assets/questions/jee-main-2026-apr-2-shift-2/q42.svg
- Q50: https://raw.githubusercontent.com/bhavishyacodz/BLACK-JEE/main/assets/questions/jee-main-2026-apr-2-shift-2/q50.svg
- Q63: https://raw.githubusercontent.com/bhavishyacodz/BLACK-JEE/main/assets/questions/jee-main-2026-apr-2-shift-2/q63.svg
- Q66: https://raw.githubusercontent.com/bhavishyacodz/BLACK-JEE/main/assets/questions/jee-main-2026-apr-2-shift-2/q66.svg
- Q67: https://raw.githubusercontent.com/bhavishyacodz/BLACK-JEE/main/assets/questions/jee-main-2026-apr-2-shift-2/q67.svg
- Q68: https://raw.githubusercontent.com/bhavishyacodz/BLACK-JEE/main/assets/questions/jee-main-2026-apr-2-shift-2/q68.svg
- Q75: https://raw.githubusercontent.com/bhavishyacodz/BLACK-JEE/main/assets/questions/jee-main-2026-apr-2-shift-2/q75.svg

## Current database attachment status

Rechecked directly against Supabase on 2026-10-23 for `year=2026`, `session='2 April Shift 2'`:

| Subject | Rows | Published | Drafts | Rows with image URL |
|---|---:|---:|---:|---:|
| Chemistry | 25 | 0 | 25 | 5 |
| Mathematics | 25 | 18 | 7 | 0 |
| Physics | 26 | 3 | 23 | 6 |
| **Total** | **76** | **21** | **55** | **11** |

The 76 rows represent the 75 source-question batch plus one additional legacy Q41 duplicate. All 75 JSON draft records had previously been reconciled to database rows with answer keys and solutions. This does not mean all wording/options are verified against the official paper.

Current diagram attachment check:
- **Published with image URLs:** Q30 semiconductor circuit, Q42 LCR circuit and Q50 rod/sphere moment-of-inertia diagram.
- **Image attached but unpublished:** Q28 Atwood machine; both Q41 prism versions; Q63, Q66, Q67, Q68 and Q75 chemistry diagrams.
- **Q41:** both duplicate/alternate records remain unpublished because of the source wording/key inconsistency.
- The published count is 21 total records (18 Mathematics, 3 Physics); no Chemistry record from this batch is published. No publication change was made during this audit.

The PYQ browse pages and Prep Studio retry a failed raw-GitHub diagram request using the GitHub Pages asset URL, then show an explicit fallback link if both loads fail.

A complete 75-record JSON batch is stored at [full-shift-2-75-draft.json](full-shift-2-75-draft.json). Newly staged records remain drafts and are not visible to students.

## Source wording note

The official [NTA question paper PDF](https://cdnbbsr.s3waas.gov.in/s3f8e59f4b2fe7c5705bf878bbd494ccdf/uploads/2026/04/20260409481957146.pdf) confirms that Q41 says “minimum value of n₂ required for total internal reflection”. The physics threshold n₂ = 1.6 sin 60° = 4√3/5 is the **maximum permissible** coating refractive index, so the source wording appears internally inconsistent. The JSON draft now preserves the official wording and explicitly flags the inconsistency instead of silently rewriting the question.


## Verification log — 2026-10-23

- Repository path check: all SVG paths listed in the table above were retrievable from the default branch.
- Restored the 75-record JSON draft archive to the default branch; static validation found 25 records per subject, no duplicate question numbers within each subject sequence, all required fields present, and all 75 records unpublished. These structural checks do not establish that the questions reproduce the official paper or that every answer is correct.
- Compared the following question content and diagram topics against the official NTA PDF: Q28 Atwood machine, Q30 NAND circuit, Q41 prism, Q42 LCR circuit, Q50 rod/sphere axes, Q57 chemical kinetics, Q63 substituted diarylmethyl ions, Q66 product structures, Q67 enol ether, Q68 reaction sequence and Q75 Carius-analysis sequence. These spot checks do not establish that the entire 75-question bank and every answer key are correct.
- Q30 and Q42 SVG source files were re-fetched and exist; live-browser rendering is still unverified.
- Q63 SVG was corrected in commit [e6f99e83920d9ad9814c615d80ee91d1ebd36724](https://github.com/bhavishyacodz/BLACK-JEE/commit/e6f99e83920d9ad9814c615d80ee91d1ebd36724) to make the diarylmethyl central-carbon/ring connections explicit.
- The responsive gallery at [diagram-audit.html](../../../../diagram-audit.html) is an asset-loading preview only; its status badges do not certify scientific correctness.
- Correct Supabase project identified from `pyq.html`: `yeydvwnihpwoixytcgek` (the earlier project reference was not the PYQ uploader's configured project).
- Imported the missing batch records in chunks as unpublished drafts. Database verification: 76 total rows for this shift/session label and 76 answer-key rows; 75 source questions matched, with 21 matching rows already published and 54 matching rows unpublished. One additional legacy Q41 “maximum” version remains as an unpublished duplicate; it was taken out of publication because the official paper says “minimum”.
- **Q57 corrected in commit [0cf4c7f](https://github.com/bhavishyacodz/BLACK-JEE/commit/0cf4c7f78a14d697862066e66140aae6065c4cf4):** matched the kinetics statements to the source paper, set the correct statement set to (i) and (iii), answer B, and removed the unrelated logarithmic-plot SVG. The database question/options/answer key/solution were updated and confirmed returned answer B. It remains unpublished pending the broader bank audit.
- No newly imported question was published during this step because the full answer-key and diagram audit is not complete.


### Chunk 19 — Mathematics solution audit (Q7–Q25)

- Independently recalculated the draft answers and main derivation steps for Q7–Q25, covering combinations/probability/statistics, coordinate geometry, trigonometry, integration, polynomials, differential equations, vectors, matrices, conics, area under curves and greatest-integer discontinuities.
- The checked results agree with the draft keys: Q7 C (5), Q8 C (107), Q9 D (7), Q10 C (18), Q11 C (7/2), Q12 B (4), Q13 A (0), Q14 B (12), Q15 A (1), Q16 B (√3/2), Q17 C (15π), Q18 D (112), Q19 C (39), Q20 B (2e²/3), Q21 120, Q22 34, Q23 18, Q24 24 and Q25 10.
- No answer-key changes were needed in this mathematical recalculation pass. This is a calculation audit of the draft, **not** proof that every question statement/options exactly match the official paper. These rows remain under the existing publication state; no new question was published.

## Outstanding before calling the shift complete

1. Compare every diagram and its labels/values against the original JEE Main 2026 April 2 Shift 2 paper.
2. Verify all 75 question statements, options, answer keys and explanations against a reliable source.
3. Continue verifying every answer key against the official paper; Q57's statement set has been corrected, but the other answer keys remain unaudited.
4. Open the live student experience and verify the correct image appears on each question.
5. Do not describe the shift as complete until all checks above pass.


## Verification log — Chunk 20: Physics Q26–Q50 calculation and diagram audit (2026-10-23)

Independently checked the draft calculations and keyed responses for Physics Q26–Q50. The numerical/algebraic checks agree with the stored answers for this pass, including Q26–Q40 and Q43–Q50. This is a calculation audit of the current draft wording, not proof that every reconstructed statement matches the official paper verbatim.

- **Q30 semiconductor circuit:** inspected the SVG topology. The two input NAND gates feed a NAND, whose output is inverted by the final tied-input NAND; the depicted network implements NOR, consistent with option D. The diagram is present in the JSON.
- **Q41 prism/TIR:** remains **blocked from publication**. The preserved source wording says “minimum” although the critical-angle condition gives the maximum permissible coating index, (n_2 = 1.6\sin 60^\circ = 4\sqrt{3}/5). The source wording and answer are inconsistent and need an authoritative key/diagram check.
- **Q42 LCR circuit:** the redrawn SVG includes the source (v=V_0\sin(300t)), (C=100\,\mu F), both inductors and switches. The stored result (3L_1-L_2=2/(\omega^2 C)=2/9\,H) follows from the two phase-angle conditions under the depicted switch-bypass arrangement. The SVG is a redraw, not a pixel-verified copy of the official figure.
- **Q49 lens-maker calculation:** the stored answer α=20 follows if the lens is symmetric biconvex with both radii of curvature of magnitude 60 cm. The draft wording should be checked against the official diagram/text to ensure that this assumption is stated or shown.
- **Q28, Q30, Q41, Q42 and Q50:** their SVG assets were inspected. Q28/Q50 are schematic redraws; Q41 preserves the stated incidence geometry; Q42 includes the circuit labels and source details. They have not been claimed as pixel-perfect reproductions.
- **Publication decision:** no additional questions were published by this audit. Continue holding Q41 and any item whose exact source wording/diagram is not yet verified.

Next: compare the remaining Physics/Chemistry/Mathematics drafts line-by-line against the official paper and reconcile the Q41 source/key contradiction before a broader publication.


## Verification log — Chunk 21: Chemistry Q51–Q75 calculation/concept audit (2026-10-23)

Checked the current draft solutions and keyed answers for Chemistry Q51–Q75 against the written chemistry/math in the draft. The checked calculations and conceptual classifications agree with the stored answers in this pass, including combustion stoichiometry (Q51, Q62), acid equilibrium (Q52), molecular shape (Q53), first-law sign convention (Q54), osmotic pressure (Q55), titration at half-equivalence (Q56), kinetics order (Q57), oxide classification (Q58), ionisation-enthalpy trend (Q59), coordination isomerism (Q61), organic reaction logic (Q64–Q68), photoelectric effect (Q71), reaction-pressure stoichiometry (Q72), electrochemical work (Q73), paramagnetism (Q74), and Carius analysis (Q75).

- **Q57:** retained as an unpublished draft; the earlier unrelated kinetics graph is not linked to the question.
- **Q63, Q66, Q67, Q68 and Q75:** the associated SVGs are present in the repository and their intended subject matter matches the question topics. This is a topic/structure check, not a pixel-by-pixel match to the official figures.
- **Source-fidelity limitation:** this pass validates the logic of the draft as currently written. It does not establish that every option, compound name, diagram detail, or statement is transcribed verbatim from the official question paper.
- **Publication decision:** no questions were published by this audit. Continue keeping the batch staged as drafts until the source transcription and official answer-key reconciliation are complete; Q41 remains a known wording/key conflict.


## Verification log — Chunk 22: Official-paper diagram comparison (2026-10-23)

Compared the available rendered pages of the official NTA PDF with the custom redraws for Physics Q28, Q30, Q41, Q42 and Q50.

- **Q28 Atwood machine:** pulley, 2 kg/1 kg masses and release-from-same-level condition match the official figure's essentials. Improved the redraw so mass labels sit clearly below the blocks rather than inside them.
- **Q30 logic circuit:** verified the source's tied-input NAND topology. The circuit reduces to NOR, matching the option in the draft; the SVG is a simplified redraw rather than a pixel-perfect copy.
- **Q41 prism:** the official PDF visibly says “minimum value of n₂”, and its ray is incident normally on the prism face. The physical condition gives (n_2 \le 1.6\sin 60^\circ = 4\sqrt{3}/5), i.e. a **maximum** permissible index. This is a source-level inconsistency; both Q41 records remain unpublished.
- **Q42 LCR circuit:** the official figure confirms the capacitor/resistor top branch, L₂ and S₁ in the left shunt, L₁ and S₂ in the right shunt, and the source (v=V_0\sin(300t)). The redraw includes these elements and values; it is not pixel-identical.
- **Q50 rod/sphere moment of inertia:** the official figure shows a 40 kg, 3 m rod about axis AB and a 10 kg sphere of radius R with its parallel axis 3 m away. The redraw was corrected to include the sphere's missing **10 kg** label and clearer dimensions.

The original PDF's chemistry pages were not consistently retrievable as screenshots in this audit pass, so chemistry diagram assets are still treated as topic-level redraws rather than source-verified copies. No publication status was changed. This audit records direct visual comparison where the official pages were available, and does not claim that all 75 questions have been fully transcribed or answer-key verified.


## Verification log — Chunk 23: Chemistry numerical and concept spot-check (Q51–Q75)

Performed a second, item-by-item consistency check on the currently stored Chemistry questions, using the written stems/options and recalculating numerical values where possible.

Checked numerical outcomes:
- **Q51:** (3.38\,g) of (C_2H_2) gives (11.44\,g) of (CO_2), option B.
- **Q52:** ([HA^-]\approx K_{a1}[H_2A]/[H^+]=8.1\times10^{-8}\,M), option C.
- **Q54:** reverse-process work is 14 J done on the gas, option D.
- **Q55:** both initial osmotic pressures are (9.96\times10^{-4}\,bar); after mixing, the concentration and pressure remain the same, option B.
- **Q56:** initial pH is about 2.0 and half-equivalence pH is 3.3, option B.
- **Q62:** sample mass is about (0.273\,g), so the requested integer is 273.
- **Q71:** the wavelength is approximately 500 nm, giving (x=5).
- **Q72:** calculated partial pressure of C after 30 minutes is 20 mm Hg.
- **Q73:** 80% of the six-electron fuel-cell work is approximately 560 kJ; at 1 kPa this corresponds to about 560 m³.
- **Q74:** three listed ions are paramagnetic.
- **Q75:** one gram of the brominated product yields approximately 1 g of AgBr (nearest integer).

Concept checks also support the current keyed choices for Q53, Q58–Q61, Q63–Q70. These are internal consistency checks of the current draft, not confirmation of the official answer key.

### Remaining source-fidelity caution

- Q41 remains blocked due to the “minimum” versus “maximum” refractive-index inconsistency already recorded.
- Q68's SVG is a schematic reaction-sequence redraw. Its positional labels need a clearer source-page comparison before treating it as a faithful official-paper diagram.
- Q66's option SVG is a candidate-structure panel; it is not the original source figure.
- No publication status was changed by this chunk.


## Publication status — 23 October 2026

Following the owner's instruction to publish first and correct issues iteratively, all database rows for **2026 / 2 April Shift 2** were switched to `is_published = true`.

Verified database counts after the update:
- Mathematics: 25 published / 25 rows
- Chemistry: 25 published / 25 rows
- Physics: 26 published / 26 rows
- Total: **76 published rows**.

**Important:** the intended shift set is 75 questions; Physics has one extra legacy duplicate row, so the live database currently contains 76 published rows. This is flagged for deduplication during the correction pass. Publishing was an owner's explicit choice and does not mean all source text, answers, or diagrams have been independently verified. Corrections will be made one by one; Q41 wording/key and diagram-source fidelity remain priorities.


## Duplicate cleanup — 23 October 2026

Removed the extra Physics record `ea58f588-c951-458b-8537-b09443a2735d` (the alternate Q41 draft) so only one Q41 record remains in the shift set. Kept the record matching the official source wording for now; the wording-versus-physics issue remains flagged for correction.

Post-cleanup database verification:
- Physics: 25 rows, all published
- Chemistry: 25 rows, all published
- Mathematics: 25 rows, all published
- **Total: exactly 75 published rows**

## Verification log — Chunk 24: Q68 diagram answer-leak fix (2026-10-23)

- Replaced the Q68 schematic that displayed the intermediate substituents and final 2-bromobenzoic-acid identity, which exposed the answer to a question asking students to identify A and E.
- The revised diagram shows the p-ethylnitrobenzene starting material, the reaction conditions, and placeholders for unknown A and E. It intentionally does not display the answer structures.
- Added a clearer aromatic-ring depiction and accessible SVG title/description text.
- Re-fetched the committed SVG and checked its root element, viewBox, closing tag, and presence of the A/E placeholders. The checks passed.
- Commits: [1cafae2](https://github.com/bhavishyacodz/BLACK-JEE/commit/1cafae2d256cff5607ecb5579aa2f6cb625c39e8) (answer-leak fix) and [819f07d](https://github.com/bhavishyacodz/BLACK-JEE/commit/819f07d5dbe09bd9fa29de804bfca5cc03461de3) (ring depiction polish).
- The SVG source is structurally validated; actual browser/device rendering and comparison against the official Q68 page remain pending. No database or publication status was changed.

## Verification log — Chunk 25: Diagram accessibility answer-leak audit (2026-10-23)

- Audited the SVG title/description text as well as visible labels, because screen readers can expose text in SVG descriptions even when it is not visibly rendered.
- **Q30:** removed the conclusion naming the equivalent logic gate from the accessible description; it now describes the circuit connections without giving the answer.
- **Q67:** removed the visible sentence naming the hydrolysis products and changed it to neutral Y/Z wording. Updated the accessible description so it describes the substrate without revealing the products.
- **Q75:** changed the accessible description to identify the reaction-sequence context without naming the product class.
- Commits: [Q30](https://github.com/bhavishyacodz/BLACK-JEE/commit/9d38821d98840556fcd2682011f2ac709cd6741a), [Q67](https://github.com/bhavishyacodz/BLACK-JEE/commit/727ce5e23f8532683092beee0eb9b3d52d81103d), [Q75](https://github.com/bhavishyacodz/BLACK-JEE/commit/61045f8ebd21d17b72f1525e499e8196be1e4b97).
- This was a source-level content/accessibility audit. SVGs were re-fetched for validation; a live screen-reader and mobile browser pass is still pending. No database rows or publication statuses were changed.

- Follow-up check found that Q67's visible SVG label still named the products even after its accessible description was corrected. Removed that visible answer leak in [commit 53a511a](https://github.com/bhavishyacodz/BLACK-JEE/commit/53a511a6392258b26927d42199dd73dedcc7a29b); the diagram now says only that hydrolysis produces Y and Z.

## Verification log — Chunk 26: Diagram QA gallery stale asset fix (2026-10-23)

- Found a stale Q57 gallery entry in `diagram-audit.html`. Q57 has no source-paper diagram and its former SVG had already been removed, so the QA page would show a false load failure for a non-existent asset.
- Removed Q57 from the gallery, changed the displayed total to 10 assets, and made the count derive from the actual gallery list to prevent future count drift.
- Re-fetched the committed gallery and all 10 referenced SVGs. Every referenced file exists and has an SVG root and closing tag; no stale Q57 reference remains.
- Commits: [e1bd53b](https://github.com/bhavishyacodz/BLACK-JEE/commit/e1bd53bd4573124ce5ef4087d9af4a6eca890d80) (remove stale entry) and [d687a97](https://github.com/bhavishyacodz/BLACK-JEE/commit/d687a976745aa322c65d0da29a9666207e0bd4d6) (dynamic asset count).
- This is source-level validation. Browser rendering and actual mobile load behavior remain to be tested. No question records or publication states were changed.
