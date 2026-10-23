# Content audit log — April 2, 2026 Shift 2

> **CURRENT RELEASE GATE (2026-10-23): HOLD.** The official printed source order is Physics Q1–25, Chemistry Q1–25, Mathematics Q1–25; the legacy draft uses a different internal global numbering scheme. Current crosswalk statuses: 15 `confirmed_mismatch`, 54 `needs_exact_review`, 6 `source_extraction_unresolved`; all 75 remain non-publishable and none is certified exact. Older calculations, candidate matches, and answer-key notes below are historical draft notes only and are **not verified source matches**. Follow `SOURCE_FIDELITY_AUDIT.md` for current status. Do not publish or write this batch to the live database until all 75 questions, diagrams, and final keys are reconciled.

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

## Independent calculation pass — Mathematics Q11–Q15

- **Status:** Calculations checked against the displayed draft statements; source-paper transcription and official answer-key comparison remain outstanding.
- **Q11:** The midpoint relation gives Q = (1 − x, −1 − y); combining both points on xy = 12 gives x − y = 1. The points are (4,3) and (−3,−4), so the triangle area is 7/2 (option C).
- **Q12:** The vertex height is −1 − (p + 2)²/4, minimized in absolute value at p = −2, q = 0; p² + q² = 4 (option B).
- **Q13:** On the stated domain, the expression simplifies to 2 − sin²2θ, strictly greater than 1 and at most 2. No integer square lies in that interval; answer 0 (option A).
- **Q14:** The two dot-product equations yield λ = 1, μ = −1, hence c = (−2, −2, 2) and |c|² = 12 (option B).
- **Q15:** Midpoint, line-membership and perpendicularity conditions give a = b = 0 and α = 1; requested value is 1 (option A).
- **Boundary:** Mathematical consistency only; official source/key verification is still needed.

## Independent calculation pass — Mathematics Q6–Q10

- **Status:** Calculations checked against the displayed draft statements; official source transcription and final answer-key comparison remain outstanding.
- **Q6:** By symmetry of binomial coefficients and Vandermonde's identity, the sum is C(33,r), so m = 33 (option C).
- **Q7:** C(n+1,3) − C(n,3) = C(n,2) = 66 gives n = 12; distinct prime divisors sum to 5 (option C).
- **Q8:** The score equation is 2H + T = 6. The possible head counts H = 0,1,2,3 contribute probabilities 1/64, 10/64, 24/64, 8/64; total 43/64 and m+n = 107 (option C).
- **Q9:** Variance gives total square sum 80n. Equating the last observation and its square yields 4n² − 53n + 175 = 0; the only integer solution is n = 7 (option D).
- **Q10:** Perpendicularity gives k = −1; the circle centre is (1,2), radius squared 5, and line distance squared 1/2. Chord squared is 18 (option C).
- **Boundary:** These are independent mathematical checks, not proof of official paper transcription or answer-key fidelity.


## Independent calculation pass — Physics Q26–Q40

- **Status:** Arithmetic and physics reasoning checked against the current draft statements. Official wording/key and diagram fidelity are not certified by this pass.
- **Q26:** Dimensional matching gives \([G]=[h]T^{-1}LM^{-2}\), option B.
- **Q27:** At the limiting friction condition, \(\mu=g/(\omega^2r)=0.1\), option A.
- **Q28:** Atwood acceleration is \(10/3\,\mathrm{m/s^2}\); centre-of-mass displacement magnitude after 2 s is \(20/9\approx2.22\,\mathrm m\), option C.
- **Q29:** Lorentz-force components give \(v_x=50\) and \(v_y=100\,\mathrm{m/s}\), option A.
- **Q30:** The described NAND/inverter arrangement yields NOR (option D) if the SVG wiring matches the text; visually compare the actual circuit with the official paper before publication.
- **Q31:** Energy conservation gives \(v\approx11.2\,\mathrm{km/s}\) and \(K\approx6.27\times10^7\,\mathrm J\), option A.
- **Q32:** Least count is 0.001 mm; correcting a +0.005 mm zero error gives 5.045 mm, option A.
- **Q33:** Accounting for both soap-bubble surfaces gives \(W=1.92\pi\times10^{-4}\,\mathrm J\), so \(\alpha=1.92\), option C.
- **Q34:** Ideal-gas total is 1/3 mol; combining total moles and 13.2 g gives about 0.211 mol CO₂ and 0.122 mol O₂, option C.
- **Q35:** Stokes-law calculation gives about 0.889 Pa·s = 8.89 poise. Draft key B (8.8) is the nearest listed choice, but check the official statement/rounding convention before publication.
- **Q36:** Work-energy over the 10.1 m fall gives average sand force 2020 N, option B.
- **Q37:** \(E=cB=60\,\mathrm{V/m}\); with propagation along +x and B along +y, E points −z, option B.
- **Q38:** Rated bulb resistance is 400 Ω; parallel branch becomes 200 Ω, giving 50 V across the bulb, option B.
- **Q39:** Levitation requires a 480 V potential difference; the lower plate must be at higher potential for positive droplets, option A.
- **Q40:** Gauss's law gives enclosed charges 8 μC and 6 μC, so the flux ratio is 4:3, option C.
- **Boundary:** This is a calculation pass only. Do not treat it as official paper transcription/key verification.

## Repeatable shift-import rule — single source of truth

- Every uploaded shift must have **one canonical ordered dataset** (one question record per source question); student tabs, admin tabs, previews, chapter filters and review views must consume that same record rather than maintaining separate copies.
- Preserve the original source question number and source order. For a 75-question B.E./B.Tech shift, validate exactly 25 Mathematics, then 25 Physics, then 25 Chemistry if that is the source-paper ordering; use the source's actual numbering/order rather than reordering by convenience.
- Keep diagrams as separate version-controlled assets referenced by stable paths from the canonical records. Never replace a missing diagram with a guess; flag it and block publication.
- Run automated structure/order/duplicate/asset checks first, then calculation/key checks and official-paper visual comparison. Publish only after the review gate passes; keep the staging dataset unpublished while any critical issue remains.
- Target: fast ingestion and deterministic checks, with uncertain content flagged rather than silently “fixed.” Automated checks reduce avoidable mistakes but cannot guarantee perfection without source comparison.


## Independent calculation pass — Physics Q41–Q50 and Chemistry Q51–Q60

- **Status:** Internal checks against the staged wording only. Official source transcription, answer-key match and diagram fidelity still require direct source comparison.
- **Physics Q41:** The calculation n₂ = 1.6 sin 60° = 4√3/5 is the critical upper limit for the coating index in the described setup, not a minimum. Existing warning retained; do not publish until official wording/key are resolved.
- **Physics Q42:** The stated circuit result is not independently certified from text alone; verify switch wiring and values in q42.svg against the official diagram.
- **Physics Q43:** The large-square-loop central field approximation gives M ≈ 2√2 μ₀R²/L, option D, under the stated L ≫ R approximation.
- **Physics Q44:** Using the supplied atomic masses gives binding energy per nucleon about 7.84 MeV, option B.
- **Physics Q45:** First positive velocity-zero time is π/300 s; first positive zero-acceleration time is π/75 s, option A.
- **Physics Q46:** Equal-slit interference gives the smallest positive path difference λ/6, so x = 6.
- **Physics Q47:** In the Bohr model, the orbital field scales as n⁻⁵; B₂/B₄ = 32.
- **Physics Q48:** With R ≈ 2 cal mol⁻¹ K⁻¹, Cᵥ ≈ 6 cal mol⁻¹ K⁻¹ and ΔU = 300 cal.
- **Physics Q49:** The symmetric thin-lens formula gives n = 2, so α = 20, assuming the two radii have equal magnitude as implied by the draft.
- **Physics Q50:** The draft's result α = 60 follows if the rod axis is through its end and the sphere axis passes through its centre. Verify both axes and the 3 m separation against q50.svg and the official paper.
- **Chemistry Q51:** The mass ratio gives C₂H₂; 3.38 g yields 11.44 g CO₂, option B.
- **Chemistry Q52:** In 0.1 M HCl, the first dissociation estimate gives [HA⁻] ≈ 8.1×10⁻⁸ M, option C.
- **Chemistry Q53:** Electron-domain analysis gives seesaw structures for IF₄⁺ and XeO₂F₂; draft option B, subject to source/key confirmation.
- **Chemistry Q54:** The reverse path has ΔU = +8 J and Q = −6 J, so 14 J of work is done on the gas, option D.
- **Chemistry Q55:** Both starting solutions and their mixture have the same protein molarity, giving x = y = z = 9.96×10⁻⁴ bar, option B.
- **Chemistry Q56:** Initial pH is about 2.0; at half-equivalence pH = pKa = 3.3, option B.
- **Chemistry Q57:** Second-order units imply statements (i) and (iii) only, option B; the unrelated graph asset was removed from this record.
- **Chemistry Q58:** K₂O, Cl₂O₇, As₂O₃ and NO represent basic, acidic, amphoteric and neutral oxides, respectively, option C.
- **Chemistry Q59:** Both periodic-trend statements are false using the usual first/second ionisation data, option B; check source values and phrasing before release.
- **Chemistry Q60:** The draft's qualitative explanation supports both statements as true, option A; verify the exact phrase “third valence electron” and official key.
- **Boundary:** These are internal consistency checks, not source-paper transcription or official-key verification. Q41, Q42 and Q50 remain explicit manual-review items.


## Independent calculation pass — Chemistry Q61–Q75

- **Status:** Internal consistency checks against the draft wording only; official transcription and answer-key matching remain outstanding.
- **Q61:** Coordination-isomerism reasoning supports B, D and E only (option B), pending source/key comparison.
- **Q62:** Carbon- and hydrogen-percentage calculations independently give X ≈ 0.273 g, so the requested nearest integer is 273 (option A).
- **Q63:** The resonance-effect explanation supports both statements as true if the source structures are transcribed correctly; compare q63.svg with the original diagram.
- **Q64:** Heptane is consistent with the stated C₇ transformations; verify the exact reaction conditions/source wording.
- **Q65:** Statements A and E are true while B–D are false, supporting option C.
- **Q66:** C₂H₂O₂ is consistent with the equal molar amounts and 58 g mol⁻¹; glyoxal disproportionation gives glycolic acid, supporting option C, subject to reaction-condition/source verification.
- **Q67:** The described hydrolysis products propanal and acetone have equal molar masses and both react with 2,4-DNP; A and D only, option D, if q67.svg matches the source.
- **Q68:** The described sequence supports 2-bromobenzoic acid as E and option A; verify regiochemistry and diagram labels against q68.svg/source.
- **Q69:** Tyrosine (Y) is the precursor for thyroid hormones such as thyroxine, option C.
- **Q70:** Remains unresolved: verify the exact ionisation-enthalpy meaning and borax-bead observation against official source/key. Do not publish based only on the current qualitative rationale.
- **Q71:** Photon-energy balance gives wavelength 500 nm, so x = 5.
- **Q72:** Stoichiometric total-pressure calculation gives partial pressure of C = 20 mm Hg.
- **Q73:** Using the stated standard potentials and 80% efficiency gives useful work ≈ 560472 J; at 1 kPa this corresponds to |ΔV| ≈ 560 m³.
- **Q74:** Mn²⁺, Cu²⁺ and Gd³⁺ are paramagnetic; count = 3.
- **Q75:** Monobrominated toluidine C₇H₈BrN gives about 1.01 g AgBr per 1.0 g product; nearest integer = 1, if q75.svg confirms a single bromination.
- **Boundary:** All results above are draft-level calculations, not certification of official wording, answer keys, or diagram fidelity. Q63, Q66–Q70 and Q75 need source-specific checks where noted.


## Critical source-fidelity gate — 2 April 2026 Shift 2

**HOLD publication.** The official printed paper order is Physics Q1–25, Chemistry Q1–25, then Mathematics Q1–25, while the legacy draft uses internal global slots Mathematics 1–25, Physics 26–50, Chemistry 51–75. The source-to-draft crosswalk has been reordered to official paper order and candidate links remapped by subject-local question number. All 75 rows are now marked `needs_exact_review`; previous claims of 62 verified matches and the old Chemistry global-Q63–75 answer-key table are withdrawn pending exact source-by-source reconciliation. Do not publish or write to the live database until all 75 questions, diagrams and final keys have been verified.


## Physics transcription-alignment pass — 2026-10-23
- **Updated candidates:** legacy Q27 (rotating cylinder), Q28 (Atwood machine), Q35 (air-bubble viscosity), Q36 (falling ball into sand), Q37 (electromagnetic-wave field).
- **Scope:** question stems, numerical values, options, and candidate answers were aligned with the readable transcription where legible.
- **Gate:** these five are still `needs_exact_review`; official final-key verification and source-image comparison remain open. Do not publish yet.


## Physics Q9 candidate correction — 2026-10-23
- **Updated:** legacy Q31 now asks only for speed from a long distance and uses the source transcription's four speed options.
- **Reason:** the previous draft asked for speed and kinetic energy, which did not match the source.
- **Gate:** `needs_exact_review`; official final-key verification is still pending.
