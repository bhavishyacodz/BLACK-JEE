# JEE Main 2026 — 2 April Shift 2 diagram audit

This folder contains custom SVG redraws and draft metadata for diagram-based PYQ work. The question numbers refer to the displayed numbers in the source paper.

| Question | Topic | Asset |
|---|---|---|
| Q28 | Atwood machine with 2 kg and 1 kg blocks | [q28.svg](q28.svg) |
| Q30 | NAND logic circuit / equivalent gate (Semiconductor Electronics) | [q30.svg](q30.svg) |
| Q41 | Equilateral prism with painted face / total internal reflection | [q41.svg](q41.svg) |
| Q42 | LCR series circuit with switches S1 and S2 | [q42.svg](q42.svg) |
| Q50 | Moment of inertia: rod and sphere, parallel axes | [q50.svg](q50.svg) |
| Q57 | Reaction-order graph, ln([R₀]/[R]) against time | [q57.svg](q57.svg) |
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
- Q57: https://raw.githubusercontent.com/bhavishyacodz/BLACK-JEE/main/assets/questions/jee-main-2026-apr-2-shift-2/q57.svg
- Q63: https://raw.githubusercontent.com/bhavishyacodz/BLACK-JEE/main/assets/questions/jee-main-2026-apr-2-shift-2/q63.svg
- Q66: https://raw.githubusercontent.com/bhavishyacodz/BLACK-JEE/main/assets/questions/jee-main-2026-apr-2-shift-2/q66.svg
- Q67: https://raw.githubusercontent.com/bhavishyacodz/BLACK-JEE/main/assets/questions/jee-main-2026-apr-2-shift-2/q67.svg
- Q68: https://raw.githubusercontent.com/bhavishyacodz/BLACK-JEE/main/assets/questions/jee-main-2026-apr-2-shift-2/q68.svg
- Q75: https://raw.githubusercontent.com/bhavishyacodz/BLACK-JEE/main/assets/questions/jee-main-2026-apr-2-shift-2/q75.svg

## Current database attachment status

The latest recorded database audit found **23 rows** for this shift: **22 published and 1 draft**. That count is historical and has not been rechecked in this session because the available Supabase tool returned a permissions error. The recorded audit said Q30 is published with a diagram URL; Q28 had an SVG but no database row; Q57 and Q63 had URLs in draft metadata; and Q66, Q67, Q68 and Q75 had SVGs but no retained draft records. Treat these attachment details as unverified until database access is restored.

The PYQ browse pages and Prep Studio now retry a failed raw-GitHub diagram request using the GitHub Pages asset URL, then show an explicit fallback link if both loads fail.

## Source wording note

The prior audit flagged Q41's “minimum” refractive-index wording as potentially inconsistent with the TIR upper-limit condition; the original question and options must be rechecked before changing the wording. Do not silently rewrite the exam question.


## Verification log — 2026-10-23

- Repository path check: all 11 SVG paths listed above were retrievable from the default branch.
- Q30 and Q42 SVG source files were re-fetched and exist; this is not a live-browser render test or proof of source-paper fidelity.
- Q63 SVG was corrected in commit [e6f99e83920d9ad9814c615d80ee91d1ebd36724](https://github.com/bhavishyacodz/BLACK-JEE/commit/e6f99e83920d9ad9814c615d80ee91d1ebd36724) to make the diarylmethyl central-carbon/ring connections explicit.
- The responsive gallery at [diagram-audit.html](../../../../diagram-audit.html) is an asset-loading preview only; its status badges do not certify scientific correctness.
- Supabase table inspection was denied in this session. No database writes were made.

## Outstanding before calling the shift complete

1. Compare every diagram and its labels/values against the original JEE Main 2026 April 2 Shift 2 paper.
2. Verify all 75 question statements, options, answer keys and explanations against a reliable source.
3. Restore authorized read access and reconcile question records, publication status and image URLs; confirm Q28 and chemistry records.
4. Open the live student experience and verify the correct image appears on each question.
5. Do not describe the shift as complete until all checks above pass.
