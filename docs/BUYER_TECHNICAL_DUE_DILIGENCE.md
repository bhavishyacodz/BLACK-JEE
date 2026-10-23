# BLACK-JEE — Buyer Technical Due-Diligence Review

**Review date:** 2026-10-23  
**Repository:** https://github.com/bhavishyacodz/BLACK-JEE  
**Production Supabase project:** `yeydvwnihpwoixytcgek` (region `ap-south-1`)  
**Decision:** **Not yet buyer-ready.** The PYQ solution RPC has now been hardened and the new CI guardrails are in place. Leaked-password protection, remaining database-advisor findings, and full integration/visual testing remain open.

## What was inspected

- Browser entrypoints and their Supabase project references.
- Active Supabase project metadata, public/private table metadata, migration history, security/performance advisor findings, and deployed Edge Functions.
- The `grade_jee_pyq` SQL function and its consumers in `pyq.html`, `chapterwise.html`, and `chapter-practice.html`.
- Existing GitHub Actions coverage for the JEE question batch.

## Confirmed positives

- All scanned HTML entrypoints point to the same Supabase project.
- The static scan did not find a known `sb_secret_*`, service-role JWT, or JWT-shaped credential embedded in the scanned browser files. The publishable key in browser code is expected; it is not a service-role secret.
- The inspected application tables have Row Level Security enabled.
- The deployed `released-solution` Edge Function reads the release timestamp from the database and checks that six hours have passed after the challenge ends before returning a solution. Its service-role key is read from server-side environment variables, not the browser bundle.
- The active project has migration history and separate server-side functions for challenge start, submit, archive, and admin operations.

## Findings to fix before a sale

### P1 — PYQ grading RPC previously returned the answer key and solution immediately — remediation deployed, tests still required

The database function `public.grade_jee_pyq(uuid, text)` previously returned `correct_answer` and `solution` to any caller. A database migration now records wrong attempts against the authenticated user and question in the private schema. Anonymous users can still check correctness but receive no answer key or solution; signed-in users receive the worked solution only after two incorrect attempts. The attempt table has RLS enabled and direct table privileges revoked. The front-end practice page supports retrying incorrect answers and offers Google sign-in for server-side tracking.

**Regression test executed:** `supabase/tests/secure_jee_pyq_solution_gate.sql` passed against the active database inside a transaction and rolled back its test writes. It checks anonymous key/solution withholding, no unlock after one wrong answer, unlock after two wrong answers, and cross-user attempt isolation. This test is committed but not yet wired into CI because CI has no database credentials; rerun it in staging after future database changes.

### P1 — Leaked-password protection is disabled

Supabase's security advisor reports that leaked-password protection is disabled. Enable it in Supabase Auth settings and verify the configuration after changing it.

### P2 — Security-definer RPCs need an explicit allowlist review

The advisor still flags several `SECURITY DEFINER` functions callable by public or authenticated roles. The PYQ grader now has a fixed empty `search_path` and returns no answer key to anonymous callers; the archive RPC only returns challenges after the release time, while admin/attempt RPCs check role or identity internally. These warnings still require a documented per-function grant review rather than blindly revoking legitimate application calls.

### P2 — CI does not yet validate the whole product

The existing PYQ workflow validates question-batch structure and crosswalk data; it is not an end-to-end application test. A passing batch audit does not prove login, attempt uniqueness, grading, private photo storage, admin permissions, solution-release timing, or mobile UI behavior.

**Required remediation:** add browser/integration tests for anonymous vs signed-in access, duplicate attempts, incorrect/correct answers, the two-error solution gate, storage privacy, admin denial for ordinary users, and release timing. Run security/performance advisors after database changes.

### P2 — Source audit documentation is stale

`SOURCE_FIDELITY_AUDIT.md` still says 62/75 verified and says Chemistry Q63–Q75 remain unresolved, while the latest crosswalk update and successful automated batch-audit run indicate the source-mapping work was updated. Reconcile the report with the actual canonical crosswalk and distinguish **source mapping verification** from **rendered UI/scoring verification**. Do not publish the shift solely because the structural batch audit passes.

## New automated guardrails

- `scripts/audit_browser_security.py` scans root-level HTML/JS for common embedded-secret patterns and enforces one consistent Supabase project reference.
- `scripts/check_inline_js.py` extracts inline scripts and asks Node.js to syntax-check them.
- `supabase/tests/secure_jee_pyq_solution_gate.sql` is a transaction-wrapped database regression test for answer withholding and per-user attempt isolation.
- `.github/workflows/browser-security.yml` runs both checks when browser files or the guardrail scripts change.

The new browser guardrail workflow passed on commit `68f9f812`, including inline JavaScript syntax validation. The question-batch audit also passed on commit `db08c1a9`. These checks are intentionally narrow. They do **not** prove that RLS policies are correct, that RPCs are safe, or that a buyer-facing penetration test would pass.

## Release / sale gate

Do not claim “security audited” or “buyer-ready” until:
1. The PYQ answer/solution RPC regression tests pass for anonymous, authenticated, and cross-user scenarios.
2. Leaked-password protection is enabled.
3. RLS, Storage policies, all security-definer grants, and admin role checks are reviewed.
4. Automated integration tests cover attempt uniqueness, scoring, photo privacy, and timed release.
5. The 75-question content, diagrams, rendered math, and answer scoring pass a real student-side smoke test.
6. Backup/restore, environment ownership, domain/project access, and secret-rotation procedures are documented for handover.
