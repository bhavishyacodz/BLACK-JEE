# BLACK JEE — NO MERCY

A dark, mobile-friendly daily JEE challenge site. It includes a daily question board, start-to-submit timer, optional handwritten-photo upload, a public Hall of Proof for approved attempts, and an owner console for posting questions and reviewing submissions.

**Live website:** https://bhavishyacodz.github.io/BLACK-JEE/#challenge  
**Date-wise results archive:** https://bhavishyacodz.github.io/BLACK-JEE/archive.html  
**Repository:** https://github.com/bhavishyacodz/BLACK-JEE  
**Correct Supabase project:** https://supabase.com/dashboard/project/yeydvwnihpwoixytcgek

## Quick start — using the website

1. Open the live website and wait for the daily question to load.
2. Tap **START ATTEMPT**; the timer should begin.
3. Select an option if the question has choices, then tap **SUBMIT ATTEMPT**.
4. Enter a display name or nickname. You can attach a photo of handwritten work or skip the photo.
5. The attempt stays private until the owner approves it in Admin.

The daily challenge closes at **12:00 PM IST**. Each challenge runs for **24 hours: 12:00 PM IST to 12:00 PM IST the next day**. Correct/incorrect feedback appears immediately after submission. The correct option, approved top-three winners, and worked solution (if published) are released at **6:00 PM IST on the closing date**. Schedule the next question in advance; it will go live automatically at noon.

## Quick start — owner/Admin

1. Tap **ADMIN** on the website; the owner dashboard opens in a separate browser tab.
2. Enter your owner email and password, then choose **OPEN ADMIN DASHBOARD**.
3. If you see an admin-role warning, follow section 2 below to grant your owner account the admin role.
4. Open **Question Studio** from the site. Enter the closing date, title, tags, difficulty, question, options, **correct option letter**, and worked solution; then tap **SAVE & GO LIVE**. Leave the results-release checkbox on to reveal the worked solution at 6:00 PM IST.
5. The current `index.html` already contains the project's publishable key. Do not replace it unless you deliberately rotate the key.
6. The site code is already connected to this project.

**Never put a Supabase service-role or secret key in \`index.html\`.** The publishable/anon key is intended for browser apps; Row Level Security (RLS) controls what it can access.

The SQL creates:
- \`daily_questions\` — daily prompt, options, tags and official solution.
- \`attempt_submissions\` — name, time taken, optional photo path, review/publication state.
- A **private** Storage bucket named \`attempt-photos\`. Photo URLs are signed for viewing; pending work is not publicly listed. The public question query cannot read the official \`solution\` column; \`get_released_solution\` releases it at 6 PM IST.
- RLS policies so visitors can read live questions and submit attempts, the public sees only approved submissions, and only an account with the admin app-metadata role can manage questions or review submissions.
- An index for submission/question joins. Official solutions are served through the `released-solution` Edge Function after the release gate; the database RPC is restricted to `service_role`.
- A sample challenge for the active challenge's closing date. Publish the next day's challenge in Admin before noon.

## 2. Give your account admin access

1. Publish the site and configure its URL under **Supabase → Authentication → URL Configuration → Redirect URLs**. Add your GitHub Pages URL, for example:
   \`https://bhavishyacodz.github.io/BLACK-JEE/**\`
2. Enter your owner email and password and choose **OPEN ADMIN DASHBOARD**.
3. After your account exists in Supabase Auth, open **SQL Editor** and run this query, replacing the email with your own:
   \`\`\`sql
   update auth.users
   set raw_app_meta_data = coalesce(raw_app_meta_data, '{}'::jsonb)
       || '{"role":"admin"}'::jsonb
   where email = 'YOUR_EMAIL@example.com';
   \`\`\`
4. Sign out and sign back in so the refreshed session token contains the new role. If the dashboard still says you are not an admin, check the email and repeat the sign-in.

This role is stored in \`app_metadata\`, not editable user metadata. Do not grant the admin role to student accounts.

## 3. Publish the website with GitHub Pages

1. Open [BLACK-JEE repository settings](https://github.com/bhavishyacodz/BLACK-JEE/settings/pages).
2. Under **Build and deployment**, choose **Deploy from a branch**.
3. Select branch \`main\` and folder \`/ (root)\`, then save.
4. Wait for GitHub Pages to finish publishing. The likely URL is:
   \`https://bhavishyacodz.github.io/BLACK-JEE/\`
5. Add that exact site URL to Supabase Authentication's redirect allow-list.

GitHub Pages serves this static site; Supabase supplies the database, auth and photo storage.

## 4. Daily owner workflow

- Open the site and click **Admin**.
- Sign in with the account marked \`app_metadata.role = admin\`.
- Set a date, title, tags, difficulty, full question statement, optional answer choices, and official solution.
- Select **Publish solution now** only when you want the official solution visible. Click **Save & Go Live**.
- Review submitted attempts in the owner console. **Approve & publish** adds the student's name, time and optional photo to the public Hall of Proof.

Question statements and solutions are plain text; line breaks are preserved. Answer options are one per line. Keep student names to nicknames/first names if you want to minimize personal information.

## 5. Question Studio and bulk scheduling

The Admin **Question Studio** has a **Load Grand Unification Challenge** button that fills the editor with the integrated Electromagnetic Induction, Mechanics, Ray Optics, and Photoelectric Effect problem plus its worked solution. Review the date and wording before saving. The solution is kept unpublished by default.

To schedule multiple questions, prepare a UTF-8 CSV with this exact header row:

```csv
question_date,title,statement,option_a,option_b,option_c,option_d,tags,difficulty,solution
2026-10-24,"Example question","Question text goes here","A","B","C","D","Physics|Mechanics","JEE Advanced","Worked solution goes here"
```

Use ISO dates (`YYYY-MM-DD`). Quote any field containing commas or line breaks. Tags can be separated with `|`. In Admin, use **Get CSV Template**, select your file, choose **Validate & Preview**, check row-level errors, then **Import New Dates**. The import adds only dates that are not already present; existing dates are skipped rather than overwritten. Imported solutions remain unpublished. Keep CSV batches under 2 MB and fix duplicate dates before importing.

## 6. Submission review and cleanup

The Admin dashboard includes search, status filters, total/pending/reviewed/published counts, and page controls. Approve & publish adds work to Hall of Proof; Mark reviewed keeps it private; Unpublish removes it from the public list. CSV export downloads the currently filtered records. Individual deletion downloads a CSV first and removes the submission plus its associated photo. Clear Pending and Clear Reviewed also export first; Clear Reviewed excludes published work. Clear All includes published submissions and requires typing `CLEAR ALL BLACK JEE`, followed by a second confirmation after the CSV export starts.

Deletion runs through the `admin-cleanup` Edge Function. It verifies the current signed-in user's server-managed `app_metadata.role = admin` before using server-only credentials. Never put a service-role key in this repository or browser code.

For additional authentication hardening, open **Supabase Dashboard → Authentication → Settings / Security and Protection** and enable **Leaked password protection**. This setting must be switched on in the dashboard.

## 7. Verify the setup

After running the SQL, check the seeded question:
\`\`\`sql
select question_date, title, is_live, solution_published
from public.daily_questions
order by question_date desc
limit 5;
\`\`\`

After submitting a test attempt, check:
\`\`\`sql
select display_name, elapsed_seconds, is_reviewed, is_public, photo_path
from public.attempt_submissions
order by created_at desc
limit 10;
\`\`\`

If tables appear in the database but the browser reports a table/API permission error, check Supabase **Integrations → Data API** and ensure the \`public\` schema is exposed as intended. Keep RLS enabled.

## 9. April 4 Shift 1 PYQ staging and audit

The active repository staging package for JEE Main 2026, 4 April Shift 1 is:

- [Shift manifest](assets/questions/jee-main-2026-apr-4-shift-1/shift-manifest.json) — 75 subject-local tracking slots and review status.
- [Question metadata manifest](assets/questions/jee-main-2026-apr-4-shift-1/manifest.json) — source question IDs and referenced visual assets.
- [Physics audit](assets/questions/jee-main-2026-apr-4-shift-1/PHYSICS_AUDIT_ROUND1.md), [round-two audit](assets/questions/jee-main-2026-apr-4-shift-1/SECOND_AUDIT_ROUND2.md), and [round-three follow-up](assets/questions/jee-main-2026-apr-4-shift-1/THIRD_AUDIT_ROUND3.md) — known review gaps, verified follow-ups, and release gates.
- [Shift Workbench](https://bhavishyacodz.github.io/BLACK-JEE/shift-workbench.html) — inspect the question-management workflow.

The GitHub Actions **April 4 Shift 1 manifest audit** checks the 75-slot structure, subject counts, draft-only staging policy, and existence of referenced assets. It is a structural check only; it does not prove official question wording, answer-key correctness, solution quality, or source-diagram fidelity.

The generic `scripts/audit_jee_batch.py` validator is retained for future imported question JSON batches and now requires an explicit input path. The April 2-specific crosswalk validator and its default batch data were removed; use the April 4 manifest audit for the active staging package.

## Notes

- The visible timer starts only when **Start Attempt** is clicked. The server records the start time and calculates completion time independently for leaderboard ranking.
- Photo upload is optional. Supported images: JPG, PNG, WEBP, up to 6 MB.
- An attempt is private until an admin approves it. The private Storage bucket also prevents direct public viewing of pending images.
- This first version stores attempts without student accounts. The display name is self-entered and is not verified.
- The sample problem is seeded once for the date on which you run the SQL. Use the Admin panel to create the next day's challenge.

## 8. Student and owner interface refresh

The student home, focused attempt page, and owner dashboard share the same responsive visual system and remain static GitHub Pages files. The focused attempt page loads the current live written question first, then falls back to the active external question link. If it says there is no live question, check the Owner Dashboard's live status and the browser's connection to Supabase.

- Student home: https://bhavishyacodz.github.io/BLACK-JEE/
- Focused attempt page: https://bhavishyacodz.github.io/BLACK-JEE/attempt.html
- Owner dashboard: https://bhavishyacodz.github.io/BLACK-JEE/admin.html?admin=1  
Question Studio: https://bhavishyacodz.github.io/BLACK-JEE/attempt.html?admin=1
- Deployment history: https://github.com/bhavishyacodz/BLACK-JEE/actions

After changing HTML, wait for the GitHub Pages deployment to finish successfully before testing. On Android, if an older version appears, open the direct attempt link with a fresh query string or refresh the page.


## Engineering quality and buyer review

BLACK-JEE includes a technical due-diligence log and lightweight automated guardrails:

- [Buyer technical due-diligence review](docs/BUYER_TECHNICAL_DUE_DILIGENCE.md) — current findings, remediations, and remaining release gates.
- [Browser security scan](scripts/audit_browser_security.py) — checks root-level HTML/JS for common embedded-secret patterns and inconsistent Supabase project references.
- [Inline JavaScript syntax check](scripts/check_inline_js.py) — syntax-checks inline scripts with Node.js.
- [PYQ solution-gate database regression test](supabase/tests/secure_jee_pyq_solution_gate.sql) — checks anonymous answer withholding, the two-incorrect-attempt unlock, and per-user attempt isolation. Run in a transaction against a staging database after database changes.

These checks are guardrails, not a certification or a substitute for end-to-end browser testing, a full RLS/Storage review, backups/restore drills, and an independent security review. The PYQ solution gate stores authenticated users' attempt counts in the private database schema; anonymous users can check correctness but cannot retrieve the answer key or worked solution through the grading RPC.
