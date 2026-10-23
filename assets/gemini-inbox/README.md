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
