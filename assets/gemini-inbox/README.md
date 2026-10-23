# BLACK-JEE EXTRACTION PACKAGE

## Environmental Limitations
I am an AI text model. I do not have access to the original visual PDF file. I searched the connected Google Drive for `JEE-Main-2026-Question-Paper-B-Tech-4th-Apr-Shift-1.pdf` but the original PDF does not exist in the environment (only OCR text was provided in the previous prompts, and a partial text fragment named `001` was found in Drive). 

Because of this limitation, **I cannot physically extract image crops (PNGs), draw bounding boxes, or create the visual contact sheet.**

## Contents Provided
*   `manifest.json`: Full metadata map of all 75 questions, identifying exactly which questions require visual assets and flagging known OCR issues.
*   `extraction-report.json`: Quality control summary of the extraction process.
*   `assets/`: Empty (Placeholder to preserve repository structure).
*   `source-crops/`: Empty (Placeholder to preserve repository structure).

## Critical Unresolved Questions
*   **Mathematics Q19 (`BJ-JM-20260404-S1-MAT-019`)**: The OCR text around the greatest integer function is scrambled and corrupted. A full source crop is required to determine the exact limits and integrand. Unresolved.
*   **Physics Q38 (`BJ-JM-20260404-S1-PHY-038`)**: The logic circuit diagram is completely missing from the text transcript, rendering the boolean evaluation impossible. Unresolved.
*   **Chemistry Q64 (`BJ-JM-20260404-S1-CHE-064`)**: The alkene structure and all option images (A, B, C, D) failed to parse and were replaced by stray artifacts like "☆" and "Ο". Unresolved.
*   **Chemistry Q72 (`BJ-JM-20260404-S1-CHE-072`)**: The numerical question is missing the starting reactant for the multi-step synthesis (likely Benzene, but requires visual confirmation). Unresolved.

Please use the provided JSON files to orchestrate the automated download and manual image cropping process in your local environment.

## Screenshot-to-question crop workflow

Use the published crop studio:
- https://bhavishyacodz.github.io/BLACK-JEE/image-crop-studio.html

1. Open the studio. It reads screenshots currently in this inbox and the shift question IDs.
2. Select the screenshot and drag around the exact region to preserve. Choose the correct source question ID and crop type. Add more than one crop when a question has separate option diagrams.
3. Export `crop-manifest.json`.
4. Upload/commit that file to `assets/gemini-inbox/crop-manifest.json`.
5. GitHub Actions validates the crop coordinates and IDs, creates PNGs under `assets/questions/jee-main-2026-apr-4-shift-1/images/`, and attaches them to the shift's **draft** metadata.
6. Only after the processor completes successfully, it deletes the source screenshots referenced by that manifest. Unreferenced screenshots are retained.

Safety rules:
- The crop manifest must use the question ID shown by the studio. Do not guess or manually renumber IDs.
- A crop is a source image asset, not proof that its text/answer has been verified. Source/render verification remains false until checked.
- Processing does not publish questions or write to Supabase.
- If a workflow fails, source screenshots remain in GitHub; fix the reported error and rerun.
- After a successful run, the manifest records the processed source names and the number of generated assets.

