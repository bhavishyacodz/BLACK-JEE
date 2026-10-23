# Source-Fidelity Audit — JEE Main 2 April 2026 Shift 2

## Status: HOLD — not ready to publish

The staged file `assets/questions/jee-main-2026-apr-2-shift-2/full-shift-2-75-draft.json` is not yet a faithful, source-ordered transcription of the shift paper. Do not publish it or import it into the live database until this audit is resolved.

## Source order confirmed from the paper

The source paper is arranged as:

- Physics: source questions 1–25
- Chemistry: source questions 26–50
- Mathematics: source questions 51–75

The staged JSON instead labels Mathematics as 1–25, Physics as 26–50, and Chemistry as 51–75. This is a critical mismatch. The deterministic audit has been updated to expect the source order, so it should fail on the current draft rather than falsely passing it.

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
