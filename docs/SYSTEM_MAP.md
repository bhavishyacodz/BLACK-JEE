# BLACK-JEE System Map

This is the operator guide to the existing pages and the intended content workflow. It documents repository files and does not claim that every live Supabase/browser flow has passed end-to-end testing.

## 1. Student-facing pages

| Page | Purpose |
|---|---|
| `index.html` | Student home / daily challenge entry point |
| `attempt.html` | Focused challenge attempt; also contains the admin Question Studio route when opened with `?admin=1` |
| `archive.html` | Past daily challenges / archive |
| `pyq.html` | PYQ browsing and practice entry |
| `chapterwise.html` | Chapter-wise PYQ browsing |
| `chapter-practice.html` | Focused chapter practice |
| `mock-tests.html` | Timed mock tests |
| `profile.html` | Student profile |
| `prep.html` | Preparation/resources area |
| `rules.html` | Rules and usage guidance |

## 2. Owner/admin and question operations

| Page | Purpose | Safe workflow |
|---|---|---|
| `owner-dashboard.html` | Owner overview / management entry | Start here to find owner tools |
| `admin.html` | Daily Challenge Admin: schedule/publish challenges and review submissions | Check date and live state before publishing |
| `pyq-admin.html` | PYQ Admin / upload and question-bank management | Import as drafts, validate, then review before publishing |
| `shift-workbench.html` | Shift-level 75-slot tracking for a specific exam paper | Use the manifest and subject counts to find missing/unreviewed slots |
| `diagram-audit.html` | Diagram audit view | Compare each referenced diagram against the official source paper |
| `draft-image-review.html` | Review extracted/cropped question images | Verify crop boundaries, readability, and question association |
| `image-crop-studio.html` | Crop question/option/diagram images | Crop, save, then verify the resulting image mapping in the manifest |

## 3. April 4, 2026 Shift 1 staging area

Data and audit files live in `assets/questions/jee-main-2026-apr-4-shift-1/`.

- `shift-manifest.json`: 75 subject-local slots and their review status.
- `manifest.json`: question/image manifest used by the import and audit workflow.
- `extraction-report.json`: extraction output/report.
- `PHYSICS_AUDIT_ROUND1.md`, `SECOND_AUDIT_ROUND2.md`, `THIRD_AUDIT_ROUND3.md`: physics review notes and follow-up findings.
- `images/`: extracted question, option, reaction, matching, and diagram assets.

The manifest workflow checks structure, subject counts, and whether referenced assets exist. Passing that check does **not** establish official wording, correct answer keys, solution quality, or faithful diagram reproduction.

## 4. Recommended end-to-end PYQ workflow

1. **Import/stage** the shift through PYQ Admin or the supported import workflow.
2. **Track completeness** in Shift Workbench: target 75 slots total, 25 each for Physics, Chemistry, and Mathematics.
3. **Crop and associate assets** in Image Crop Studio; verify each crop in Draft Image Review.
4. **Audit diagrams** in Diagram Audit against the official source paper.
5. **Review question quality**: wording, options, answer key, chapter mapping, math/chemical notation, and explanation.
6. **Publish only after review**. A complete manifest is not a publication approval.
7. **Verify student rendering** on mobile and desktop, including images, equations, options, and navigation.

## 5. Daily Challenge workflow

1. Open Owner Dashboard / Admin.
2. Create or schedule the question and confirm its date.
3. Preview the question and solution; keep the solution unpublished until intended.
4. Save and publish; verify the live status from the student-facing home/attempt page.
5. Review submissions in Admin. Keep work private unless explicitly approved for public display.
6. Export records before bulk cleanup; check the filtered CSV before deleting anything.

## 6. Automation and engineering checks

- `.github/workflows/jee-pyq-audit.yml`: manifest/asset structural audit.
- `.github/workflows/process-question-crops.yml`: crop-processing workflow.
- `scripts/audit_static_references.py`: static-reference checks.
- `scripts/audit_jee_batch.py`: question-batch audit helper.
- `scripts/process_question_crops.py`: crop processing.
- `supabase/migrations/`: database policy/schema changes; review migration history before making database changes.
- `sw.js`: service-worker/cache behavior.

## 7. Current known release gates

Before calling the April 4 Shift 1 set production-ready, still verify in the actual deployed student UI and database:

- all 75 questions' source wording, options, answer keys, and chapter tags;
- every diagram/crop against the official source, including option-level images;
- math/chemical notation and mobile layout;
- draft-vs-published visibility and no accidental release of unreviewed questions;
- student-side loading, attempt flow, and Supabase access policies;
- deployed GitHub Pages version and browser console/network errors.

## 8. Important security rule

Never place a Supabase service-role/secret key in client-side HTML or JavaScript. Browser access must rely on the publishable/anon key plus correctly enforced Row Level Security and server-side checks for privileged cleanup.
