#!/usr/bin/env python3
"""Process reviewed screenshot crop coordinates into permanent BLACK-JEE draft assets."""
import json, os, re, sys
from pathlib import Path
from PIL import Image

ROOT = Path(".")
INBOX = ROOT / "assets/gemini-inbox"
SHIFT = ROOT / "assets/questions/jee-main-2026-apr-4-shift-1"
MANIFEST = INBOX / "crop-manifest.json"
SHIFT_MANIFEST = SHIFT / "shift-manifest.json"
QUESTION_MANIFEST = SHIFT / "manifest.json"

def fail(msg):
    print("ERROR:", msg, file=sys.stderr)
    raise SystemExit(1)

if not MANIFEST.exists():
    fail("assets/gemini-inbox/crop-manifest.json is missing")
data = json.loads(MANIFEST.read_text(encoding="utf-8"))
if data.get("shift_folder") != SHIFT.name:
    fail("crop manifest shift_folder does not match the configured shift")
crops = data.get("crops")
if not isinstance(crops, list) or not crops:
    fail("crop manifest must contain a non-empty crops array")

shift_data = json.loads(SHIFT_MANIFEST.read_text(encoding="utf-8"))
question_data = json.loads(QUESTION_MANIFEST.read_text(encoding="utf-8"))
questions_by_id = {}
for q in shift_data.get("questions", []):
    qid = (q.get("source_reference") or {}).get("question_id")
    if qid:
        questions_by_id[qid] = q
manifest_by_subject_number = {(q.get("subject"), int(q.get("paper_question_number", -1))): q for q in question_data if q.get("question_id") and str(q.get("paper_question_number", "")).isdigit()}

validated = []
source_paths = set()
used_names = set()
for index, item in enumerate(crops, 1):
    qid = item.get("question_id", "")
    if qid not in questions_by_id:
        fail(f"crop #{index}: unknown question_id {qid!r} in shift-manifest.json")
    target_q = questions_by_id[qid]
    source_number = int(qid.rsplit("-", 1)[-1])
    target_key = (target_q.get("subject"), source_number)
    if target_key not in manifest_by_subject_number:
        fail(f"crop #{index}: no matching question in manifest.json for {target_key!r}")
    source = item.get("source_screenshot", "")
    if not source.startswith("assets/gemini-inbox/") or Path(source).parent.as_posix() != "assets/gemini-inbox":
        fail(f"crop #{index}: source_screenshot must be a filename directly inside {INBOX}")
    source_path = ROOT / source
    if not source_path.is_file():
        fail(f"crop #{index}: source screenshot not found: {source}")
    box = item.get("crop") or {}
    try:
        x, y, w, h = (float(box[k]) for k in ("x", "y", "width", "height"))
    except (KeyError, TypeError, ValueError):
        fail(f"crop #{index}: invalid crop rectangle")
    if any(v < 0 or v > 1 for v in (x, y, w, h)) or w <= 0 or h <= 0 or x+w > 1.000001 or y+h > 1.000001:
        fail(f"crop #{index}: crop rectangle must be normalized within the image")
    filename = item.get("asset_filename") or f"{qid}-{index}.png"
    filename = re.sub(r"[^A-Za-z0-9_.-]", "-", Path(filename).name)
    if not filename.lower().endswith(".png"):
        fail(f"crop #{index}: output filename must end in .png")
    if filename in used_names:
        fail(f"duplicate output filename: {filename}")
    used_names.add(filename)
    validated.append((item, source_path, qid, filename, (x, y, w, h), target_key))
    source_paths.add(source_path)

# Validate every crop before writing or deleting anything.
for item, source_path, qid, filename, (x, y, w, h), target_key in validated:
    try:
        with Image.open(source_path) as im:
            im.verify()
    except Exception as exc:
        fail(f"cannot read source image {source_path.name}: {exc}")

asset_dir = SHIFT / "images"
asset_dir.mkdir(parents=True, exist_ok=True)
for item, source_path, qid, filename, (x, y, w, h), target_key in validated:
    with Image.open(source_path) as original:
        im = original.convert("RGB")
        left, top = round(x*im.width), round(y*im.height)
        right, bottom = round((x+w)*im.width), round((y+h)*im.height)
        right, bottom = min(im.width, max(left+1, right)), min(im.height, max(top+1, bottom))
        crop = im.crop((left, top, right, bottom))
        if crop.width < 24 or crop.height < 24:
            fail(f"crop too small for {qid}: {crop.width}x{crop.height}")
        out = asset_dir / filename
        crop.save(out, "PNG", optimize=True)
    rel = f"images/{filename}"
    q = questions_by_id[qid]
    visual = {"kind": item.get("kind", "question_visual"), "asset_path": rel, "alt_text": item.get("alt_text") or f"Source-paper visual for {qid}", "source_screenshot": source_path.name, "source_verified": False, "render_verified": False}
    q.setdefault("visual_assets", []).append(visual)
    if item.get("kind") in ("diagram", "reaction", "matching", "question_visual") and not (q.get("diagram") or {}).get("asset_path"):
        q["diagram"] = {"required": True, "asset_path": rel, "alt_text": visual["alt_text"], "source_verified": False, "render_verified": False}
    qm = manifest_by_subject_number[target_key]
    qm["visual_required"] = True
    assets = qm.setdefault("assets", [])
    option_match = re.search(r"option[_-]([a-d])", filename, re.I)
    filename_lower = filename.lower()
    asset_type = (
        "option_image" if option_match else
        "matching" if "matching" in filename_lower else
        "reaction" if "reaction" in filename_lower else
        item.get("kind", "diagram")
    )
    asset_record = {
        "filename": filename,
        "asset_type": asset_type,
        "belongs_to": "option" if option_match else "question",
        "option_letter": option_match.group(1).upper() if option_match else None,
        "source_pdf_page": qm.get("source_pdf_page"),
        "extraction_status": "CROP_PRESENT_UNVERIFIED",
        "visual_details_verified": False,
    }
    if not any(isinstance(existing, dict) and existing.get("filename") == filename for existing in assets):
        assets.append(asset_record)
    # Keep all existing unresolved issues until a human confirms they are resolved.

SHIFT_MANIFEST.write_text(json.dumps(shift_data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
QUESTION_MANIFEST.write_text(json.dumps(question_data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

# Only remove source screenshots after all outputs and both metadata files have been written.
# The workflow commits these changes atomically; on any earlier failure, it exits before this section.
if data.get("delete_sources_after_success", False):
    for source_path in sorted(source_paths):
        source_path.unlink(missing_ok=True)
    data["processed_sources_deleted"] = sorted(p.name for p in source_paths)
    data["processed_asset_count"] = len(validated)
    data["processing_status"] = "processed_and_sources_removed"
else:
    data["processed_asset_count"] = len(validated)
    data["processing_status"] = "processed_sources_retained"
MANIFEST.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
print(f"Processed {len(validated)} crop(s) for {len(set(v[2] for v in validated))} question(s).")
print(f"Created assets under {asset_dir}.")
print(f"Source screenshots removed: {len(source_paths) if data.get('delete_sources_after_success') else 0}.")
print("All visual assets remain draft-only; source/render verification flags are false.")
