# BLACK-JEE question images

Store question diagrams and figure crops in this folder so they can be versioned with the website.

## Naming convention

Use one file per question, for example:

- `jee-main-2026-apr-4-shift-1/images/BJ-JM-20260404-S1-PHY-032-diagram-1.png`
- `jee-main-2026-apr-4-shift-1/images/BJ-JM-20260404-S1-PHY-038-diagram-1.png`
- `jee-main-2026-apr-4-shift-1/images/BJ-JM-20260404-S1-CHE-064-reaction-1.png`

Use the exact existing asset path recorded in the April 4 manifest; never infer or reuse a diagram from another question.

Create the subfolder in GitHub if needed. Keep the original question number in the filename; do not renumber by subject or crop order.

## Connect an image to a question

1. Open the repository and upload the image into the matching folder.
2. Open the BLACK-JEE Admin page and choose the written-question editor.
3. Paste the exact relative path into **Optional Question Image / Diagram Path**, for example `assets/questions/your-question-diagram.svg` for a new daily-challenge diagram. For the April 4 PYQ assets, use the exact path from that shift's manifest.
4. Check the preview, then publish the question.
5. Open the student attempt page and confirm the diagram matches the question.

The question record stores the path in `daily_questions.image_url`. Leave the field blank for questions without a diagram. Do not use a diagram for a different question just because its subject is the same.

Only use images you have permission to upload. If an image is missing or the path is wrong, the page hides the broken image instead of leaving a broken-image icon.
