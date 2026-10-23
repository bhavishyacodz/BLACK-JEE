# BLACK-JEE — Buyer Technical Due-Diligence Review

**Review date:** 2026-10-23  
**Repository:** https://github.com/bhavishyacodz/BLACK-JEE  
**Production Supabase project:** `yeydvwnihpwoixytcgek` (region `ap-south-1`)  
**Decision:** **Not yet buyer-ready.** The browser bundle has no obvious embedded service-role secret in the static scan, but at least one database RPC defeats the intended answer/solution reveal boundary.

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

### P1 — PYQ grading RPC returns the answer key and solution immediately

The database function `public.grade_jee_pyq(uuid, text)` is executable by both `anon` and `authenticated`. It returns `is_correct`, `correct_answer`, and `solution` in the same response. A caller can invoke the RPC directly without using the intended UI flow, so any UI rule such as “show the solution after two incorrect attempts” is not enforceable by the current backend.

**Required remediation:** move attempt counting and solution-release authorization server-side; use a trustworthy user/session identity; return only the minimum result needed at each step; release the answer/solution only when the server-side attempt policy allows it. Update all three consumer pages and add integration tests before deployment. Do not treat a client-side counter as security.

### P1 — Leaked-password protection is disabled

Supabase's security advisor reports that leaked-password protection is disabled. Enable it in Supabase Auth settings and verify the configuration after changing it.

### P2 — Security-definer RPCs need an explicit allowlist review

The advisor flags several `SECURITY DEFINER` functions callable by public or authenticated roles. Some are intentionally public and enforce a release window or role check in the function body; that should be documented and tested, not blindly revoked. Review each function's grants, fixed `search_path`, input validation, authorization, and returned columns. The PYQ grading RPC is the confirmed high-priority issue.

### P2 — CI does not yet validate the whole product

The existing PYQ workflow validates question-batch structure and crosswalk data; it is not an end-to-end application test. A passing batch audit does not prove login, attempt uniqueness, grading, private photo storage, admin permissions, solution-release timing, or mobile UI behavior.

**Required remediation:** add browser/integration tests for anonymous vs signed-in access, duplicate attempts, incorrect/correct answers, the two-error solution gate, storage privacy, admin denial for ordinary users, and release timing. Run security/performance advisors after database changes.

### P2 — Source audit documentation is stale

`SOURCE_FIDELITY_AUDIT.md` still says 62/75 verified and says Chemistry Q63–Q75 remain unresolved, while the latest crosswalk update and successful automated batch-audit run indicate the source-mapping work was updated. Reconcile the report with the actual canonical crosswalk and distinguish **source mapping verification** from **rendered UI/scoring verification**. Do not publish the shift solely because the structural batch audit passes.

## New automated guardrail

`scripts/audit_browser_security.py` scans root-level HTML/JS for common embedded-secret patterns and enforces one consistent Supabase project reference. `.github/workflows/browser-security.yml` runs it when browser files change.

This check is intentionally narrow. It does **not** prove that RLS policies are correct, that RPCs are safe, or that a buyer-facing penetration test would pass.

## Release / sale gate

Do not claim “security audited” or “buyer-ready” until:
1. The PYQ answer/solution RPC is fixed server-side and regression-tested.
2. Leaked-password protection is enabled.
3. RLS, Storage policies, all security-definer grants, and admin role checks are reviewed.
4. Automated integration tests cover attempt uniqueness, scoring, photo privacy, and timed release.
5. The 75-question content, diagrams, rendered math, and answer scoring pass a real student-side smoke test.
6. Backup/restore, environment ownership, domain/project access, and secret-rotation procedures are documented for handover.
