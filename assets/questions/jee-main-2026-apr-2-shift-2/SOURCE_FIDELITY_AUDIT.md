# Source-Fidelity Audit — JEE Main 2 April 2026 Shift 2

## Status: HOLD — not ready to publish

The staged file `assets/questions/jee-main-2026-apr-2-shift-2/full-shift-2-75-draft.json` is not yet a faithful, source-ordered transcription of the shift paper. Do not publish it or import it into the live database until this audit is resolved.

## Official source order and audit correction

The official NTA PDF displays the paper in this order:

- Mathematics: displayed questions 1–25
- Physics: displayed questions 26–50
- Chemistry: displayed questions 51–75

The staged JSON uses those same subject/global-number blocks. A previous version of this audit and its validators incorrectly claimed Physics came first; that was an audit error, not a defect in the staged numbering. The validators and crosswalk order have now been corrected against the official NTA PDF.

**This correction does not certify the question content.** The draft still has substantive text/value/option/diagram mismatches listed below, and the 75 source-to-draft mappings remain unverified. Publication remains on HOLD. In the tables below, “source Q1–Q25” for Physics or Chemistry means the subject-local position; the NTA displayed/global numbers are Physics 26–50 and Chemistry 51–75, respectively.

## Additional content mismatches found by direct text comparison

Examples below show why merely swapping subject labels or renumbering records is not safe:

- Source Physics Q1 is the Atwood-machine centre-of-mass displacement problem; the matching draft record is currently labelled Physics Q28.
- Source Physics Q3 is the rotating-cylinder friction problem; the matching draft record is currently labelled Physics Q27.
- Source Physics Q4 is the rising air-bubble viscosity problem; the matching draft record is currently labelled Physics Q35, but the draft answer/rounding needs comparison with the source options.
- Source Physics Q5 is a photoelectric-effect question with work function 2.3 eV and kinetic energy 0.18 eV; a similar question is currently stored as Chemistry Q71 with a different numerical presentation.
- Source Physics Q7 gives specific proton/neutron/atomic masses for bismuth binding energy; the draft Physics Q44 uses a different proton mass and gives a different derived answer. This must be corrected from the actual source and trusted final key.
- Source Physics Q10 specifies the rod/sphere axes with a 9 m separation; the draft Physics Q50 says 3 m. Do not use the current answer until reconciled.
- Source Chemistry Q3 is a sulfuric-acid molarity/density/molality question; no matching record has yet been confirmed in the staged batch.
- Source Chemistry Q7 states heat absorbed = 2 J and work done by the gas = 10 J; the draft Chemistry Q54 has different numbers, so it is not an exact transcription.
- Source Chemistry Q9 concerns H₂S/HS⁻ with Ka values 8.3×10⁻⁸ and 10⁻¹³; the draft Chemistry Q52 uses a different dibasic acid and different constants.
- Source Chemistry Q11 lists Gd²⁺ among the ions for the paramagnetism count; the draft Chemistry Q74 lists Gd³⁺.
- Source Chemistry Q17 lists Zn²⁺, Fe³⁺, Fe²⁺ and Co²⁺ for the borax-bead/ionisation question; the draft Chemistry Q70 instead lists Cr²⁺ and Zn²⁺ among its options.
- Source Chemistry Q24 states that the second structure involves the +R effect of NO₂; the draft Chemistry Q63 instead describes a carbanion stabilised by the −R effect of NO₂. These are not equivalent statements.

These examples are enough to establish that a simple reorder would preserve incorrect source content. The correct next step is to rebuild/reconcile records question-by-question against the paper, preserving each original question's exact wording, option order, diagrams, subject and global source number.

## Release gate

1. Map each of the 75 source questions to exactly one canonical record by content, not by its current draft number.
2. Replace altered text, constants, choices and diagrams with source-faithful versions; keep any uncertain transcription explicitly flagged.
3. Check each key against the final NTA answer key where available and independently recalculate numerical answers.
4. Run the updated audit and verify all referenced diagram files visually.
5. Keep `is_published` false and do not write to the live database until the entire source-fidelity gate passes.

## Reference used

The NTA JEE Main documents page lists “B Tech 2nd Apr 2026 Shift 2” under Question Papers. The text comparison in this report used an accessible text-rendered copy of that paper to locate source questions; final publication should still be cross-checked against the official NTA-hosted paper and final answer key.


## Mathematics cross-map findings

A content-based scan of the source paper shows that several mathematical records exist in the batch but are assigned a different draft number, while others have altered values or no confirmed match. Examples:

- Source Mathematics Q1 (mean/variance) resembles draft Mathematics Q9.
- Source Mathematics Q2 (degree-5 polynomial and limit) resembles draft Mathematics Q18.
- Source Mathematics Q4 (nested circles in the complex plane) resembles draft Mathematics Q2.
- Source Mathematics Q5 (parabola through (1,−1)) resembles draft Mathematics Q12.
- Source Mathematics Q6 (circle-diameter locus/eccentricity) resembles draft Mathematics Q23.
- Source Mathematics Q7 (sum of a cubic-sum series) resembles draft Mathematics Q5.
- Source Mathematics Q9 (integral of sin⁴x + cos⁴x) resembles draft Mathematics Q17.
- Source Mathematics Q10 (regular-polygon triangle count) resembles draft Mathematics Q7.
- Source Mathematics Q11 (relation on A×A) resembles draft Mathematics Q21.
- Source Mathematics Q13 (partial-fraction integral) resembles draft Mathematics Q19.
- Source Mathematics Q14 (circle chord) resembles draft Mathematics Q10.
- Source Mathematics Q15 (differential equation) resembles draft Mathematics Q20.
- Source Mathematics Q16 (hyperbola and line area) resembles draft Mathematics Q24.

“Resembles” is not a verification result. Examples of substantive differences still present include the system of equations in source Mathematics Q8 not matching the staged system; the greatest-integer function in source Q12 differing from draft Q25; and source Section-B Q1's trigonometric expression differing from draft Q13. Source Section-B Q4's matrix B also differs from draft Q22. These need exact reconciliation before records are renumbered.


## Expanded comparison against the text-rendered shift paper

The official NTA PDF explicitly orders Mathematics first (displayed 1–25), Physics second (26–50), and Chemistry third (51–75). It confirms the standard subject structure (20 MCQs plus 5 numerical questions per subject). The earlier statement in this report that the source ordered Physics first was incorrect and has been superseded above. The following are **content-level differences**, not mere numbering differences:

### Physics: subject-local questions 1–25 (NTA displayed numbers 26–50)

| Source Q | Draft candidate | Comparison result |
|---|---|---|
| 1 | Physics Q28 | Same Atwood-machine/centre-of-mass concept; verify all mass and timing details before accepting as a match. |
| 2 | Physics Q37 | Similar electric/magnetic-field relationship, but the source and draft statements are not identical. |
| 3 | Physics Q27 | Critical mismatch: source cylinder radius is 1 m and angular speed is 10 rad/s; draft uses a different radius/setup. |
| 4 | Physics Q35 | Same rising-bubble viscosity concept and equivalent 1 mm radius; verify the answer unit and option set. |
| 5 | No confirmed exact match | Source is a photoelectric calculation with work function 2.3 eV and kinetic energy 0.18 eV. Do not substitute a superficially similar question without exact comparison. |
| 6 | Physics Q45 | Same SHM/time-zero conditions; verify the phase and answer options. |
| 7 | Physics Q44 | Critical mismatch: source proton mass is 1.007276 u and source options include 5.8908729, 3.0008729, 4.2506229 and 7.6408729 MeV/nucleon; draft uses a different proton mass and a different computed answer. |
| 8 | Physics Q32 | Same screw-gauge concept; source reading/zero-error details must be transcribed exactly. |
| 9 | Physics Q31 | Same gravitational fall-from-infinity concept; verify all givens and the paired kinetic-energy result. |
| 10 | Physics Q50 | Critical mismatch: source axis separation is 9 m; draft states 3 m. |
| 11 | Physics Q33 | Same soap-bubble surface-energy concept; verify constants and answer formatting. |
| 12 | Physics Q49 | Same convex-lens focal-length/refractive-index concept; verify curvature and requested parameter. |
| 13 | Physics Q47 | Same Bohr-orbit magnetic-field ratio concept; verify which orbit is numerator/denominator. |
| 14 | Physics Q38 | Similar bulb/circuit concept; compare the diagram and exact ratings before accepting. |
| 15 | Physics Q29 | Critical mismatch: source force components and magnetic-field magnitude differ from the draft. |
| 16 | Physics Q41 | Similar prism/layer refraction concept; compare the diagram and whether the prompt asks for minimum or limiting index. |
| 17 | Physics Q26 | Same dimensional-analysis concept; preserve the source's exact variables and answer forms. |
| 18 | Physics Q30 | Same logic-gate/circuit concept; diagram fidelity remains a release blocker. |
| 19 | Physics Q40 | Same electric-flux concept, but the source uses charges/spheres; verify sign, radii and ratio. |
| 20 | Physics Q43 | Same mutual-inductance geometry; verify the loop orientation, diagram and option factors. |
| 21 | Physics Q46 | Same YDSE intensity/path-difference concept; verify the diagram and requested integer. |
| 22 | Physics Q48 | Same ideal-gas internal-energy concept; verify gas amount, heat capacity and temperature change. |
| 23 | Physics Q42 | Similar two-switch LCR/capacitor circuit; exact diagram and switch states must be compared. |
| 24 | Physics Q36 | Critical mismatch: source ball mass is 1 kg and fall height is 20 m; draft uses 2 kg and 10 m. |
| 25 | No confirmed exact match | Reconcile the source Section-B questions against the staged numerical records; do not assume topic similarity means exact transcription. |

### Chemistry: subject-local questions 1–25 (NTA displayed numbers 51–75)

| Source Q | Draft candidate | Comparison result |
|---|---|---|
| 1 | Chemistry Q72 | Same first-order gas decomposition/partial-pressure concept; check the exact reaction and time units. |
| 2 | Chemistry Q55 | Same protein osmotic-pressure concept; source options distinguish the mixed-solution pressure, so preserve all options exactly. |
| 3 | No confirmed exact match | Source is H₂SO₄ molarity, density, molality and mole fraction; add only after exact source transcription. |
| 4 | Chemistry Q71 | Similar photoelectric calculation, but source belongs to Chemistry Q4 and specifies the radiation wavelength as y × 10² nm; verify whether the draft is the same question or a separate item. |
| 5 | Chemistry Q51 | Same hydrocarbon combustion calculation; source options and mass should be preserved exactly. |
| 6 | Chemistry Q73 | Same electrochemical cell/work-to-expansion concept; verify the half-reactions and cell efficiency. |
| 7 | Chemistry Q54 | Critical mismatch: source says 10 J work by gas and 2 J heat absorbed; draft uses different thermodynamic values. |
| 8 | Chemistry Q57 | Same second-order kinetics statements; compare all five statements and options. |
| 9 | Chemistry Q52 | Critical mismatch: source uses H₂S/HS⁻ and Ka₁ = 8.3×10⁻⁸, Ka₂ = 10⁻¹³; draft uses a different acid. |
| 10 | Chemistry Q56 | Similar weak-acid/strong-base titration; preserve the source's 20 mL acid, 10 mL base and log value. |
| 11 | Chemistry Q74 | Critical mismatch: source ion list includes Gd²⁺; draft list uses Gd³⁺ and a different list. |
| 12 | Chemistry Q53 | Similar SF₄-isostructural species question; source includes BrF₄⁺ as rendered in the paper copy, while draft uses BrF₄⁻. Verify the source image before correction. |
| 13 | Chemistry Q58 | Same oxide-classification concept; verify the exact option sequence. |
| 14 | Chemistry Q59 | Same ionisation-energy statements; verify the complete trend wording and answer options. |
| 15 | Chemistry Q61 | Same coordination-isomerism concept, but complex pairings/options differ; must be transcribed from source. |
| 16 | No confirmed exact match | Source asks for increasing CFSE order of three cobalt complexes; no exact matching draft record has been confirmed. |
| 17 | Chemistry Q70 | Critical mismatch: source options are Zn²⁺, Fe³⁺, Fe²⁺, Co²⁺; draft substitutes Cr²⁺ for at least one source option. |
| 18 | Chemistry Q69 | Same amino-acid/hormone identification concept; verify the source options and one-letter codes. |
| 19 | No confirmed exact match | Source shows an organic conversion with KOH/H⁺ and asks for product P; the matching diagram and options need source review. |
| 20 | Chemistry Q75 | Similar Carius-method AgBr calculation; source product structure and bromine count must be confirmed from the diagram. |
| 21 | Chemistry Q67 | Similar product-X/product-Y test statements; verify exact structures and all four statements. |
| 22 | Chemistry Q65 | Same haloalkane/haloarene statements theme; compare every statement and option grouping. |
| 23 | Chemistry Q68 | Same reaction-sequence identification theme; verify the exact starting structure, reagents and labels. |
| 24 | Chemistry Q63 | Critical mismatch: source states +R effects for the specified substituents; draft's second statement describes a different effect. |
| 25 | No confirmed exact match | The source question is image/structure dependent; do not infer the structure from a text-only fragment. |

### Mathematics: confirmed source-to-draft candidates

The source-paper comparison supports these candidate links, but “candidate” does not mean the draft is publishable:

- Source Math Q1 → draft Math Q9 (mean/variance).
- Source Math Q2 → draft Math Q18 (degree-five polynomial).
- Source Math Q3 → draft Math Q16, **but vector components differ**.
- Source Math Q4 → draft Math Q2 (nested complex-plane circles).
- Source Math Q5 → draft Math Q12 (parabola through (1, −1)).
- Source Math Q6 → draft Math Q23 (circle-diameter locus).
- Source Math Q7 → draft Math Q5 (series sum).
- Source Math Q8 → draft Math Q3, **but the second equation differs**.
- Source Math Q9 → draft Math Q17 (integral of sin⁴x + cos⁴x).
- Source Math Q10 → draft Math Q7 (polygon triangle count).
- Source Math Q11 → draft Math Q21 (relation on A × A).
- Source Math Q12 → draft Math Q25, **but the greatest-integer expression differs**.
- Source Math Q13 → draft Math Q19 (partial-fraction integral).
- Source Math Q14 → draft Math Q10 (circle chord).
- Source Math Q15 → draft Math Q20, **but the requested expression differs**.
- Source Math Q16 → draft Math Q24, **but the requested area expression differs**.
- Source Section-B Q1 → draft Math Q13, **but the trigonometric expression differs**.
- Source Section-B Q2 → draft Math Q6 (binomial identity).
- Source Section-B Q3 → draft Math Q15 (3D foot/midpoint).
- Source Section-B Q4 → draft Math Q22, **but matrix B differs**.
- Source Section-B Q5 → draft Math Q8 (coin probability).

These mappings establish where to inspect first; they are not permission to change question numbers without fixing each mismatch. Keep the batch unpublished until each source record is reconciled with the exact source image and final answer key.


## Asset-path integrity check

A repository-directory check confirmed that all 10 image references currently present in the staged JSON resolve to files in the shift asset folder: q28.svg, q30.svg, q41.svg, q42.svg, q50.svg, q63.svg, q66.svg, q67.svg, q68.svg and q75.svg. This only verifies file existence, not correctness against the original question diagrams. Several assets may be attached to a draft question whose source numbering/content is wrong; visually compare each asset after the question-to-source mapping is corrected.

## Automated gate result

The structural audit run for commit `77ba2f35c8a7258bdd9b495b5c962a337d53bea4` failed with the three expected `SUBJECT_COVERAGE` errors: Chemistry was numbered 51–75 instead of 26–50, Mathematics 1–25 instead of 51–75, and Physics 26–50 instead of 1–25. This is an intentional publication blocker: the gate is detecting the source-order mismatch rather than passing an incorrectly arranged batch. Do not relabel the existing records en masse; reconcile their content first.


## Machine-readable reconciliation index

Added `source-to-draft-crosswalk.json`, containing 75 source slots in source order. It records candidate draft links only where a prior comparison identified a plausible item; otherwise it records `no_candidate_confirmed`. Every record remains `publishable: false` and carries required verification gates for exact wording/values, options or numerical format, diagrams, and official final answer key. This is an audit index, not a source transcription and not an instruction to auto-renumber.

## Latest automation observation

GitHub Actions runs were still queued during the latest status check, so the newest crosswalk commit has not yet received a confirmed audit result. The last completed structural audit failed on the expected subject-number ranges. Do not describe the current branch as passing CI until a completed run confirms it.


## Machine-readable crosswalk and stronger CI checks

Added [`SOURCE_CROSSWALK.json`](./SOURCE_CROSSWALK.json), with 75 source-position rows. It records the expected source order, subject-local question number, Section A/B, a draft candidate when one was identified, and the reason it remains unverified.

Current ledger counts:
- Candidate links requiring exact review: 65
- No draft candidate confirmed: 10
- Fully verified rows: 0

These are candidate links only; the ledger deliberately does not mark any record as source-verified.

The batch audit now checks the crosswalk's 1–75 order, expected subject sequence, subject-local numbering, Section A/B placement, and whether each draft candidate exists under the same subject. Any row marked `verified` must include verification evidence. Any unverified row now raises a hard CI error, so the batch cannot pass the release gate while source reconciliation remains incomplete. This makes the reconciliation queue machine-readable without allowing a topic-level similarity to masquerade as a verified match.


## Re-audit: source text and numbering corrections

A fresh line-by-line pass was made against the text-rendered 25-page paper PDF: [JEE Main 2026 April 2 Shift 2 question paper](https://image-static.collegedunia.com/public/image/JEE_Main_2026_April_2_Shift_2_Question_Paper_a61eefd575669441bcfedf17fe413c6c.pdf). The PDF states 75 questions and identifies the subject order as Physics, Chemistry, Mathematics; it also describes Section A as 1–20 and Section B as 21–25 (PDF extracted lines 5–16).

### Corrected crosswalk statuses

The crosswalk now records 75 slots and explicit audit notes:

- 27 `candidate_matches_core_setup` — plausible content-level matches only, still not publication approval.
- 21 `confirmed_mismatch` — at least one concrete difference in values, expression, options, requested output or numbering.
- 12 `needs_exact_review` — topic is related but exact statement/options have not been confirmed.
- 4 `needs_diagram_review` — diagrams are essential to determine equivalence.
- 3 `no_candidate_confirmed` — no likely draft record identified.
- 3 `source_diagram_unresolved` — source relies on a structure/diagram that has not been reconciled.
- 5 `source_extraction_unresolved` — source question slots are not represented in the available text extraction.

All 75 remain `publishable: false`. The categories are triage states, not verified correctness claims.

### Corrections to earlier candidate mapping

- Physics Q3 draft candidate differs in cylinder radius/setup; Physics Q7 differs in proton mass; Physics Q10 uses a different axis separation; Physics Q15 differs in force/field values; Physics Q19 describes a different electric-flux geometry; Physics Q24 differs in mass and drop height.
- Chemistry Q1 has a time-unit mismatch (source: seconds, draft: minutes); Q7 differs in thermodynamic values; Q9 is H₂S/HS⁻ in the source rather than the draft's different acid; Q11 differs in the gadolinium ion charge; Q12 differs in the charge on BrF₄; Q17 has a different option set; Q24 has a different statement/effect.
- Mathematics Q3 has different vectors; Q8 has a different second linear equation; Q12 has a different greatest-integer expression; Q15 asks for a different final expression; Q16's area transformation differs.
- The Mathematics Section-B items must be indexed as subject-local questions 21–25, not 17–21. The previous crosswalk had incorrectly placed these candidates at 17–21. This has now been corrected.
- The available text extraction shows Mathematics questions 1–16 followed by Section B questions 1–5, leaving source slots 17–20 unresolved in this extracted representation. Do not invent or infer those four questions. Obtain/inspect the original page images or an authoritative complete transcription before declaring the shift complete.

The machine-readable file `source-to-draft-crosswalk.json` is the current audit index. It must not be used to automatically renumber or publish draft records.
