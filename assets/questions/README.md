# BLACK-JEE question images

Store question diagrams and figure crops in this folder so they can be versioned with the website.

## Naming convention

Use one file per question, for example:

- `jee-main-2026-apr-2-shift-2/q30.svg` (Q30 logic-circuit diagram)
- `jee-main-2026-apr-2-shift-2/q42.svg` (Q42 LCR circuit)
- `jee-main-2026-apr-2-shift-2/q50.svg` (Q50 moment-of-inertia figure)
- `jee-main-2026-apr-2-shift-2/q32.png`
- `jee-main-2026-apr-2-shift-2/q42.png`

Create the subfolder in GitHub if needed. Keep the original question number in the filename; do not renumber by subject or crop order.

## Connect an image to a question

1. Open the repository and upload the image into the matching folder.
2. Open the BLACK-JEE Admin page and choose the written-question editor.
3. Paste the exact relative path into **Optional Question Image / Diagram Path**, for example `assets/questions/jee-main-2026-apr-2-shift-2/q30.svg`, `assets/questions/jee-main-2026-apr-2-shift-2/q42.svg`, or `assets/questions/jee-main-2026-apr-2-shift-2/q50.svg`.
4. Check the preview, then publish the question.
5. Open the student attempt page and confirm the diagram matches the question.

The question record stores the path in `daily_questions.image_url`. Leave the field blank for questions without a diagram. Do not use a diagram for a different question just because its subject is the same.

Only use images you have permission to upload. If an image is missing or the path is wrong, the page hides the broken image instead of leaving a broken-image icon.
