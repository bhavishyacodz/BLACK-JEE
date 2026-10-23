# Content audit log — April 2, 2026 Shift 2

This log records content-level findings that structural validation alone cannot catch. It is intentionally short so future review passes can load only the active issues.

## Confirmed correction

### Mathematics Q1 — answer-key sign error
- **Status:** Fixed in the staged JSON.
- **Finding:** The solution computed the two roots as −27 and 21, whose product is −567. For (x^2+6x=m), the corresponding polynomial is (x^2+6x-m=0), so the product of roots is −m. Therefore (m=567), option D, not −567, option B.
- **Change:** Set `correct_answer` to `D` and corrected the final reasoning.
- **Verification:** Re-run the structural CI check; independent/source validation remains a separate step.

## Manual review queue

### Physics Q41 — source wording vs. threshold
- **Status:** Needs official-source/final-answer-key review; do not silently rewrite.
- **Finding:** The question says “minimum value” of the coating refractive index, while the stated limiting expression (n_2=n_1\sin60^\circ=4\sqrt3/5) acts as a maximum permissible coating index for the described total-internal-reflection condition.
- **Next check:** Compare the official paper image and final NTA answer key. Preserve the source wording unless source evidence justifies a correction.

### Chemistry Q70 — compound condition / answer-key interpretation
- **Status:** Needs independent chemistry review against the official paper and answer key.
- **Finding:** The stem combines a positive borax-bead-test condition with a highest-ionisation-enthalpy condition. Confirm that the intended comparison and keyed ion satisfy both parts, rather than relying only on a qualitative explanation.
- **Next check:** Verify the exact source wording, relevant ionisation step, borax-bead colours, and final key before publication.

## Audit policy
- Structural CI success means the data shape and local assets passed automated checks. It does **not** certify official wording, chemistry/physics correctness, or diagram fidelity.
- Keep items in the manual review queue unpublished until resolved.
- When a finding is fixed, add the evidence and change summary here, then rerun CI.

## Independent calculation pass — Mathematics Q21–Q25

- **Status:** Internal calculations checked; official wording and key still need source comparison.
- **Q21:** Counted 8 valid divisor pairs and 15 ordered pairs satisfying the second coordinate condition; product 120 matches the draft key.
- **Q22:** Recomputed the trace using the given matrices; the requested absolute trace is 34, matching the draft key.
- **Q23:** The tangency locus is an ellipse with foci at (±3, 0), semi-major axis 6, and eccentricity 1/2; 72e² = 18.
- **Q24:** Integrating between the upper hyperbola branch and line on x ∈ [3,5] gives A = 8 − 6 ln 3; requested value is 24.
- **Q25:** The increasing expression crosses integer levels 2 through 11 on [2,4], giving 10 discontinuities.
- **Boundary:** These checks validate the displayed mathematics only; they do not prove transcription fidelity to the official paper or the final NTA key.

## Independent calculation pass — Mathematics Q16–Q20

- **Status:** Independent calculations checked against the displayed draft statements; official transcription and final-key comparison remain outstanding.
- **Q16:** The side vectors have dot product −1 and equal squared magnitudes 2, giving included angle 120°. A 30° rotation makes them perpendicular; the expression evaluates to √3/2 (option B).
- **Q17:** The average of sin⁴x + cos⁴x over full periods is 3/4. On [0, 20π], the integral is 15π (option C).
- **Q18:** The limit and extrema conditions yield f(x) = 3x⁵ − 5x³, so f(2) − f(−2) = 112 (option D).
- **Q19:** Partial fractions give 7/(x+5) + 9/(x−3). Applying f(4) fixes the constant at zero; f(7) = 32 ln 2 + 7 ln 3, so α + β = 39 (option C).
- **Q20:** Substitution x = yz gives x = 2y/(1 + ln y); hence x(e²) = 2e²/3 (option B).
- **Boundary:** This is a mathematical consistency pass only. Do not treat it as official source/key verification.
