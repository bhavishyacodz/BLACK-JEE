# JEE Main 2026 — 4 April — Shift 1

Safe staging area only. `shift-manifest.json` contains 75 tracking slots (25 per subject), not actual questions. Every slot is awaiting source content. Do not import this manifest into the live question table or publish it.

## Per-question workflow
1. Add exact question wording and options from the supplied source.
2. Add a source reference.
3. Add and independently check the correct answer.
4. Add the worked solution and check each step against the question.
5. Record whether a diagram is required. If required, add its real asset path and alt text.
6. Verify the diagram against the source and check its rendering.
7. Check math notation, options, units, subject/chapter metadata, and mobile layout.
8. Mark as verified draft only after the checks pass.

## Release gate
All 75 real questions must be present; subject counts, source wording, answer keys, solutions, required diagrams, and student-facing rendering must be checked before publishing. A status flag alone is not proof of correctness.


## Extraction handoff status

The previous extraction attempt produced metadata only, not image files. Do not treat this package as diagram-complete.

Known blocked items:
- Mathematics Q19: missing/corrupted mathematical expression.
- Physics Q38: logic-circuit diagram missing.
- Chemistry Q64: alkene structure and option images missing/unreadable.
- Chemistry Q72: starting reactant missing.
- Extraction report currently records 0 visual assets, 0 complete question crops, and 10 unresolved visual/quality concerns.

## Gemini ZIP handoff

When the original question-paper PDF is available, place genuine image outputs in `assets/` and full-question crops in `source-crops/`. Keep filenames stable and update `manifest.json` with the exact relative paths. Include a contact sheet and extraction notes only if they were actually generated. Never create placeholder images or mark assets verified without checking them against the source PDF.

Upload the resulting ZIP to the project maintainer for inspection before any integration or publication.
