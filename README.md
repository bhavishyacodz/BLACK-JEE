# BLACK JEE — NO MERCY

A dark, mobile-friendly daily JEE challenge site. It includes a daily question board, start-to-submit timer, optional handwritten-photo upload, a public Hall of Proof for approved attempts, and an owner console for posting questions and reviewing submissions.

## 1. Connect Supabase

Project URL is already set in \`index.html\`:
\`https://tmrrlbdyaldyomgiiwfc.supabase.co\`

1. Open your [Supabase project](https://supabase.com/dashboard/project/tmrrlbdyaldyomgiiwfc).
2. Go to **SQL Editor → New query**.
3. Copy all of \`supabase/schema.sql\` into the editor and run it once.
4. Open **Project Settings → API Keys** and copy the **publishable key** (often begins with \`sb_publishable_\`; the legacy anon key also works).
5. In \`index.html\`, replace \`PASTE_YOUR_SUPABASE_PUBLISHABLE_KEY_HERE\` with that key.
6. Commit the changed \`index.html\` to GitHub.

**Never put a Supabase service-role or secret key in \`index.html\`.** The publishable/anon key is intended for browser apps; Row Level Security (RLS) controls what it can access.

The SQL creates:
- \`daily_questions\` — daily prompt, options, tags and official solution.
- \`attempt_submissions\` — name, time taken, optional photo path, review/publication state.
- A **private** Storage bucket named \`attempt-photos\`. Photo URLs are signed for viewing; pending work is not publicly listed.
- RLS policies so visitors can read live questions and submit attempts, the public sees only approved submissions, and only an account with the admin app-metadata role can manage questions or review submissions.
- A sample challenge for the date the SQL is run. The owner can replace it in Admin.

## 2. Give your account admin access

1. Publish the site and configure its URL under **Supabase → Authentication → URL Configuration → Redirect URLs**. Add your GitHub Pages URL, for example:
   \`https://bhavishyacodz.github.io/BLACK-JEE/**\`
2. In the site's **Admin** panel, enter your owner email and choose **Send sign-in link**. Open the email link on the same browser/device.
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

## 5. Verify the setup

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

## Notes

- The timer starts only when **Start Attempt** is clicked and stops on **Submit Attempt**.
- Photo upload is optional. Supported images: JPG, PNG, WEBP, up to 6 MB.
- An attempt is private until an admin approves it. The private Storage bucket also prevents direct public viewing of pending images.
- This first version stores attempts without student accounts. The display name is self-entered and is not verified.
- The sample problem is seeded once for the date on which you run the SQL. Use the Admin panel to create the next day's challenge.
