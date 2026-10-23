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

The latest recorded database audit found **23 rows** for this shift: **22 published and 1 draft**. That count is historical and has not been rechecked in this session because the available Supabase tool returned a permissions error. The recorded audit said Q30 is published with a diagram URL; Q28 had an SVG but no database row; Q57 and Q63 had URLs in draft metadata; and Q66, Q67, Q68 and Q75 were not attached to live database rows. Treat these attachment details as unverified until database access is restored.

A complete 75-record JSON batch is stored at [full-shift-2-75-draft.json](full-shift-2-75-draft.json). It has now been reconciled against the configured BLACK-JEE PYQ database by normalized question text: all 75 source records match a database row, and all have answer keys and solutions. The batch is not fully source-verified; newly staged records remain drafts and are not visible to students.

The PYQ browse pages and Prep Studio now retry a failed raw-GitHub diagram request using the GitHub Pages asset URL, then show an explicit fallback link if both loads fail.

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
