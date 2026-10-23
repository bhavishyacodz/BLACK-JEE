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
