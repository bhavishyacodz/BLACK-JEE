# Physics audit — JEE Main 2026, 4 April Shift 1

Audit date: 2026-10-23  
Scope: all 25 Physics slots in `shift-manifest.json` (Physics Q26–Q50 / slots physics-01–physics-25).  
Release decision: **KEEP DRAFT-ONLY. Do not publish this subject yet.**

## Round-one findings

- 25/25 Physics slots exist in the staging manifest.
- 18 are marked `content_added`; 7 are marked `needs_review`. Neither status means approved or source-verified.
- Six questions require a visual asset: physics-07, physics-13, physics-14, physics-17, physics-18 and physics-20. Their manifest flags all remain `source_verified: false` and `render_verified: false`.
- All 25 questions have `math_render_checked: false` and `mobile_render_checked: false`. These are still required before approval.
- Physics slots 21–25 are numerical-answer questions and intentionally have no MCQ options; verify their numeric answer and units against the source.
- Correct answers are recorded against a user-supplied simplified answer key in this batch; they must not be treated as official-key verified.

## Per-question review queue

| Slot | Source question | Current status | Required next check |
|---|---:|---|---|
| physics-01 | 26 | content_added | Verify source wording, options, unit and least-count calculation; math/mobile render |
| physics-02 | 27 | content_added | Verify percentage decrease and unit handling; math/mobile render |
| physics-03 | 28 | content_added | Recheck rough-vs-smooth incline timing derivation; math/mobile render |
| physics-04 | 29 | content_added | Recheck binding-energy arithmetic and answer-option mapping; math/mobile render |
| physics-05 | 30 | content_added | Recheck mass/radius conversion and numerical result; math/mobile render |
| physics-06 | 31 | content_added | Recheck projectile-range ratio and option mapping; math/mobile render |
| physics-07 | 32 | content_added | **Graph asset exists in repository but is not source/render verified.** Confirm x-intercepts/metal labels against source PDF and ensure the live student page renders the graph and all four options. Do not approve based only on the current answer key. |
| physics-08 | 33 | content_added | Recheck first-to-third diffraction minima separation; math/mobile render |
| physics-09 | 34 | content_added | Recheck string combination/frequency calculation and units; math/mobile render |
| physics-10 | 35 | content_added | Recheck gas-mixture expression and variable definitions; math/mobile render |
| physics-11 | 36 | needs_review | Re-derive the thermodynamic process integral and independently verify the answer; math/mobile render |
| physics-12 | 37 | content_added | Recheck voltmeter range-extension circuit and resistor connection; math/mobile render |
| physics-13 | 38 | needs_review | Logic-circuit visual exists but is not source/render verified; compare gates and wire connections to source before evaluating output |
| physics-14 | 39 | needs_review | Mirror/rod diagram exists but is not source/render verified; confirm object endpoints and principal-axis placement before checking image length |
| physics-15 | 40 | content_added | Recheck capacitor plate-separation rate and sign convention; math/mobile render |
| physics-16 | 41 | content_added | Recheck magnetic field of the multi-turn flat coil and units; math/mobile render |
| physics-17 | 42 | content_added | Circuit visual exists but is not source/render verified; confirm diode orientation and circuit topology |
| physics-18 | 43 | needs_review | Circuit visual exists but is not source/render verified; redraw/check connections and then recalculate voltage/current |
| physics-19 | 44 | content_added | Recheck telescope resolution formula and diameter units; math/mobile render |
| physics-20 | 45 | needs_review | Brewster-angle visual exists but is not source/render verified; verify incidence/refraction labels and polarization direction before validating the wave expression |
| physics-21 | 46 | content_added | Numerical answer: independently recompute work from vector dot product and verify units |
| physics-22 | 47 | content_added | Numerical answer: verify soap-bubble surface-energy change and whether the two surfaces are counted |
| physics-23 | 48 | needs_review | Numerical answer: re-derive SHM period from the velocity-displacement equation; check whether the stored answer is in the requested form/unit |
| physics-24 | 49 | content_added | Numerical answer: integrate the time-dependent force twice as needed and verify displacement/work wording |
| physics-25 | 50 | needs_review | Numerical answer: independently check the series RLC calculation, frequency units and requested quantity |

## Immediate issue: physics-07 / source Q32

The manifest contains the complete stem, four answer options, an expected graph image path (`images/BJ-JM-20260404-S1-PHY-032-diagram-1.png`) and answer `X_1`. However, both `source_verified` and `render_verified` are false. The frontend's existing question-image helper renders `q.image_url`; the manifest's `diagram.asset_path` alone will not display unless the import pipeline maps it to a usable image URL. Confirm that mapping and the deployed page before considering this fixed.

## Approval gate

Do not mark the 25 Physics questions verified or publish them until each question's source wording, options/numeric response, answer key, solution, required visual, mathematical rendering and mobile student view have been checked. Fix individual records rather than changing the whole subject to approved.
