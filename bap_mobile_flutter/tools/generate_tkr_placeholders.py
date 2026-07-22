"""
Generate labelled placeholder PNGs for every TKR carousel slide.

Each image is rendered as a 1000x1000 educational-diagram-style placeholder
so the carousel in the app shows real image assets (not the grid fallback).
The user can drop real PNGs over these files later — the carousel wiring in
tkr.dart already points at these exact paths.

NOTE: This script reflects the real-image set bundled in assets/tkr/ from
docs/assets/TKR imgs/ (Picture1.png … Picture19.png). One PNG per logical
image — the carousels in tkr.dart now group them in 1/2/3-slide carousels
that match the new asset count. Filenames use a stable `m{1-4}_*` prefix so
they line up with the existing carousel references in tkr.dart.
"""

import os
import math
from PIL import Image, ImageDraw, ImageFont

# Try to load a font; fall back to default if not available.
def load_font(size):
    candidates = [
        "C:/Windows/Fonts/segoeuib.ttf",
        "C:/Windows/Fonts/segoeui.ttf",
        "C:/Windows/Fonts/arialbd.ttf",
        "C:/Windows/Fonts/arial.ttf",
        "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
        "/System/Library/Fonts/Helvetica.ttc",
    ]
    for c in candidates:
        if os.path.exists(c):
            try:
                return ImageFont.truetype(c, size)
            except Exception:
                pass
    return ImageFont.load_default()

FONT_TITLE = load_font(40)
FONT_LABEL = load_font(22)
FONT_SMALL = load_font(16)
FONT_CAPTION = load_font(18)

OUT_DIR = r"C:\Users\manas\bap_mobile_flutter\assets\tkr"
os.makedirs(OUT_DIR, exist_ok=True)

# (filename, title, subtitle, labels)
SLIDES = [
    # M1 Screen 1.1 — Human knee anatomy (3 slides)
    (
        "m1_anatomy_overview.png",
        "Human Knee Anatomy",
        "Anterior view of the knee",
        [
            ("Femur", 0.50, 0.10),
            ("Patella", 0.50, 0.32),
            ("Tibia", 0.50, 0.65),
            ("Menisci", 0.30, 0.55),
            ("ACL", 0.62, 0.45),
            ("Synovial layer", 0.78, 0.50),
        ],
    ),
    (
        "m1_ligaments_of_knee.png",
        "Ligaments of the Knee",
        "ACL, PCL, MCL and surrounding structures",
        [
            ("ACL", 0.30, 0.45),
            ("PCL", 0.70, 0.45),
            ("MCL", 0.50, 0.65),
            ("LCL", 0.12, 0.55),
            ("Patella", 0.50, 0.18),
            ("Tibia", 0.50, 0.85),
        ],
    ),
    (
        "m1_bones_and_cartilage.png",
        "Bones & Cartilage",
        "Femur, patella, tibia with articular cartilage",
        [
            ("Femur", 0.50, 0.18),
            ("Articular Cartilage", 0.65, 0.32),
            ("Patella", 0.32, 0.36),
            ("Lateral Meniscus", 0.20, 0.55),
            ("Medial Meniscus", 0.78, 0.55),
            ("Tibia", 0.50, 0.80),
        ],
    ),
    # M1 Screen 1.5 — Menisci & cartilage in context (3 slides)
    (
        "m1_menisci_anterior.png",
        "Menisci — Anterior View",
        "Medial and lateral menisci on the tibial plateau",
        [
            ("Medial Meniscus", 0.30, 0.55),
            ("Lateral Meniscus", 0.70, 0.55),
            ("Tibial Plateau", 0.50, 0.65),
            ("Femoral Condyles", 0.50, 0.30),
        ],
    ),
    (
        "m1_menisci_cross_section.png",
        "Menisci — Cross Section",
        "C-shaped fibrocartilage pads in cross section",
        [
            ("Lateral Meniscus", 0.28, 0.55),
            ("Medial Meniscus", 0.72, 0.55),
            ("Articular Cartilage", 0.50, 0.40),
            ("Tibia", 0.50, 0.78),
        ],
    ),
    (
        "m1_cartilage_wear.png",
        "Healthy vs Worn Cartilage",
        "Cartilage thins, joint space narrows, bone-on-bone",
        [
            ("Healthy Cartilage", 0.25, 0.40),
            ("Worn Cartilage", 0.75, 0.40),
            ("Narrowed Joint Space", 0.75, 0.55),
            ("Bone-on-Bone", 0.75, 0.70),
        ],
    ),
    # M2 Screen 2.1 — Healthy vs OA (3 slides)
    (
        "m2_normal_knee.png",
        "Normal Knee",
        "Even joint space, smooth cartilage, intact synovium",
        [
            ("Cartilage", 0.30, 0.30),
            ("Synovial Membrane", 0.30, 0.65),
            ("Femur", 0.50, 0.18),
            ("Tibia", 0.50, 0.85),
        ],
    ),
    (
        "m2_osteoarthritis_knee.png",
        "Knee Osteoarthritis",
        "Cartilage loss, bone spurs, narrowed joint space",
        [
            ("Cartilage", 0.72, 0.30),
            ("Narrowed Joint Space", 0.72, 0.50),
            ("Bone", 0.72, 0.65),
            ("Osteophytes (bone spurs)", 0.72, 0.80),
            ("Thickened Synovium", 0.25, 0.80),
        ],
    ),
    (
        "m2_oa_progression.png",
        "OA Progression",
        "Side-by-side: healthy → arthritic",
        [
            ("NORMAL", 0.25, 0.12),
            ("OSTEOARTHRITIS", 0.75, 0.12),
            ("Healthy Cartilage", 0.25, 0.45),
            ("Cartilage Loss", 0.75, 0.45),
            ("Bone Spurs", 0.75, 0.72),
        ],
    ),
    # M2 Screen 2.3 — Varus/Valgus/Normal (3 slides)
    (
        "m2_alignment_normal.png",
        "Normal Alignment",
        "Mechanical axis runs straight through the centre of the knee",
        [
            ("Normal", 0.50, 0.92),
            ("Mechanical Axis", 0.20, 0.45),
            ("Hip", 0.50, 0.10),
            ("Knee Joint", 0.50, 0.50),
            ("Ankle", 0.50, 0.88),
        ],
    ),
    (
        "m2_alignment_varus.png",
        "Varus — Bow-Legged",
        "Load shifts onto the medial (inner) compartment",
        [
            ("Varus", 0.50, 0.92),
            ("Medial Overload", 0.72, 0.55),
            ("Hip", 0.40, 0.10),
            ("Knee", 0.55, 0.50),
            ("Ankle", 0.60, 0.88),
        ],
    ),
    (
        "m2_alignment_valgus.png",
        "Valgus — Knock-Knees",
        "Load shifts onto the lateral (outer) compartment",
        [
            ("Knock Knees (valgus)", 0.50, 0.92),
            ("Lateral Overload", 0.28, 0.55),
            ("Hip", 0.60, 0.10),
            ("Knee", 0.45, 0.50),
            ("Ankle", 0.40, 0.88),
        ],
    ),
    # M3 Screen 3.1 — Assembled Freedom Knee (3 slides)
    (
        "m3_freedom_anterior.png",
        "Freedom Total Knee — Anterior",
        "Femoral component, polyethylene insert, tibial baseplate",
        [
            ("Femoral Component", 0.50, 0.25),
            ("Polyethylene Insert", 0.50, 0.55),
            ("Tibial Baseplate", 0.50, 0.80),
        ],
    ),
    (
        "m3_freedom_lateral.png",
        "Freedom Total Knee — Lateral",
        "Multi-radius femoral geometry with poly insert seated",
        [
            ("Multi-Radius Femur", 0.50, 0.30),
            ("Poly Insert", 0.50, 0.55),
            ("Tibial Baseplate", 0.50, 0.80),
        ],
    ),
    (
        "m3_freedom_ps_box_cut.png",
        "Freedom PS — Box Cut",
        "Posterior view of PS femur showing the post-and-cam box cut",
        [
            ("Post", 0.50, 0.40),
            ("Cam", 0.50, 0.65),
            ("Box Cut", 0.50, 0.50),
        ],
    ),
    # M3 Screen 3.3 — Surgical approaches (3 slides)
    (
        "m3_approach_medial_parapatellar.png",
        "Medial Parapatellar Approach",
        "Standard approach used in most Freedom Total Knee procedures",
        [
            ("Quadriceps Tendon", 0.50, 0.20),
            ("Patella", 0.50, 0.40),
            ("Medial Arthrotomy", 0.40, 0.55),
            ("Tibial Tubercle", 0.50, 0.78),
        ],
    ),
    (
        "m3_approach_midvastus.png",
        "Mid-Vastus Approach",
        "Splits the vastus medialis; balances exposure and quad preservation",
        [
            ("Vastus Medialis", 0.35, 0.30),
            ("Mid-Vastus Split", 0.50, 0.50),
            ("Patella", 0.65, 0.45),
            ("Tibial Tubercle", 0.50, 0.80),
        ],
    ),
    (
        "m3_approach_subvastus.png",
        "Sub-Vastus Approach",
        "Preserves the quadriceps insertion; faster recovery",
        [
            ("Quadriceps", 0.35, 0.25),
            ("Sub-Vastus Plane", 0.55, 0.50),
            ("Patella (lateralised)", 0.65, 0.45),
            ("Tibial Tubercle", 0.50, 0.80),
        ],
    ),
    # M3 Screen 3.4 — Femoral preparation tools (3 slides)
    (
        "m3_ap_sizing_guide.png",
        "A/P Femoral Sizing Guide",
        "Selects the correct femoral component size",
        [
            ("Sizing Guide", 0.50, 0.30),
            ("Femur", 0.50, 0.55),
            ("Selected Size", 0.50, 0.78),
        ],
    ),
    (
        "m3_5in1_cutting_block.png",
        "5-in-1 Femoral Cutting Block",
        "Anterior, posterior, chamfer and trochlear cuts in one guided step",
        [
            ("5-in-1 Block", 0.50, 0.40),
            ("Anterior Cut", 0.30, 0.20),
            ("Posterior Cut", 0.30, 0.65),
            ("Chamfer Cuts", 0.70, 0.50),
        ],
    ),
    (
        "m3_ps_box_cut_prep.png",
        "PS Box Cut Preparation",
        "Intercondylar space for the post-and-cam mechanism",
        [
            ("Box Cut", 0.50, 0.45),
            ("Post", 0.50, 0.30),
            ("Femoral Condyles", 0.30, 0.55),
            ("Distal Femur", 0.50, 0.75),
        ],
    ),
    # M3 Screen 3.5 — Tibial preparation tools (3 slides)
    (
        "m3_tibial_em_guide.png",
        "Extramedullary Tibial Guide",
        "Sets the proximal tibial cut perpendicular to the mechanical axis",
        [
            ("EM Alignment Rod", 0.50, 0.15),
            ("Cutting Guide", 0.50, 0.45),
            ("Tibia", 0.50, 0.80),
        ],
    ),
    (
        "m3_keel_reaming.png",
        "Reaming & Broaching",
        "Preparing the keel space for the tibial baseplate",
        [
            ("Broach", 0.45, 0.35),
            ("Keel Space", 0.50, 0.55),
            ("Tibial Metaphysis", 0.50, 0.80),
        ],
    ),
    (
        "m3_tibial_prepared.png",
        "Tibial Preparation Complete",
        "Keel/boss space ready for cement and baseplate insertion",
        [
            ("Prepared Plateau", 0.50, 0.40),
            ("Keel Slot", 0.50, 0.62),
            ("Tibia", 0.50, 0.85),
        ],
    ),
    # M3 Screen 3.6 — Trial reduction (3 slides)
    (
        "m3_trial_components.png",
        "Trial Components",
        "Femur, poly insert and tibial tray in trial",
        [
            ("Trial Femur", 0.50, 0.25),
            ("Trial Poly Insert", 0.50, 0.55),
            ("Trial Tibial Tray", 0.50, 0.80),
        ],
    ),
    (
        "m3_trial_rom.png",
        "Trial ROM Assessment",
        "Knee ranged through flexion and extension to assess balance",
        [
            ("Flexion", 0.30, 0.50),
            ("Extension", 0.70, 0.50),
            ("Patellar Tracking", 0.50, 0.30),
        ],
    ),
    (
        "m3_gap_balancing.png",
        "Final Gap Assessment",
        "Equal rectangular flexion and extension gaps",
        [
            ("Extension Gap", 0.50, 0.30),
            ("Flexion Gap", 0.50, 0.65),
            ("Balanced Rectangular Gaps", 0.50, 0.85),
        ],
    ),
    # M4 Screen 4.2 — Design philosophy diagram (2 slides)
    (
        "m4_design_attributes.png",
        "Five Critical Market Attributes",
        "Size · Shape · Bone Conservation · Flexion Range · Clinical Environment",
        [
            ("SIZE", 0.25, 0.20),
            ("SHAPE", 0.75, 0.20),
            ("FLEXION RANGE", 0.18, 0.55),
            ("BONE CONSERVATION", 0.78, 0.55),
            ("CLINICAL ENVIRONMENT", 0.48, 0.85),
        ],
    ),
    (
        "m4_femoral_tibial_sizing.png",
        "Femoral Component Size",
        "Sizes A–H bridging Asian and Caucasian anatomy",
        [
            ("A", 0.10, 0.40),
            ("B", 0.22, 0.40),
            ("C", 0.34, 0.40),
            ("D", 0.46, 0.40),
            ("E", 0.58, 0.40),
            ("F", 0.70, 0.40),
            ("G", 0.82, 0.40),
            ("H", 0.92, 0.40),
            ("Tibial Liner Thickness", 0.50, 0.78),
        ],
    ),
    # M4 Screen 4.3 — Seven tangential radii (3 slides)
    (
        "m4_seven_radii_lateral.png",
        "Seven Tangential Radii — Lateral",
        "Multi-radius design follows the knee through its arc of motion",
        [
            ("Radius 1", 0.50, 0.12),
            ("Radius 2", 0.50, 0.22),
            ("Radius 3", 0.50, 0.32),
            ("Radius 4", 0.50, 0.45),
            ("Radius 5", 0.50, 0.55),
            ("Radius 6", 0.50, 0.65),
            ("Radius 7", 0.50, 0.75),
        ],
    ),
    (
        "m4_patellar_groove.png",
        "Patellar Groove",
        "6° patellar groove angle for natural tracking",
        [
            ("Trochlear Groove", 0.50, 0.35),
            ("6° Patellar Angle", 0.50, 0.55),
            ("Chamfer Cuts", 0.65, 0.70),
        ],
    ),
    (
        "m4_radii_transition.png",
        "Multi-Radius Transition Zone",
        "Radii 3–4 hand off between patellofemoral and rollback control",
        [
            ("Patellofemoral Zone", 0.30, 0.35),
            ("Rollback Zone", 0.70, 0.65),
            ("Transition (R3–R4)", 0.50, 0.50),
        ],
    ),
    # M4 Screen 4.5 — Freedom family at a glance (4 slides)
    (
        "m4_freedom_total_knee.png",
        "Freedom Total Knee",
        "Flagship primary TKR · CR or PS · all-poly or metal-backed tibia",
        [
            ("Femoral Component", 0.50, 0.25),
            ("Poly Insert", 0.50, 0.55),
            ("Tibial Baseplate", 0.50, 0.80),
        ],
    ),
    (
        "m4_freedom_partial.png",
        "Freedom Partial / Renew",
        "Bone-sparing single-compartment & resurfacing options",
        [
            ("Femoral Resurfacing", 0.50, 0.30),
            ("Tibial Inlay", 0.50, 0.65),
        ],
    ),
    (
        "m4_freedom_titan.png",
        "Freedom Titan (TiNbN)",
        "Hard, low-ion coating for metal-sensitive patients",
        [
            ("TiNbN Coating", 0.50, 0.30),
            ("CoCr Substrate", 0.50, 0.65),
        ],
    ),
    (
        "m4_freedom_porous.png",
        "Freedom Porous",
        "Cementless fixation with AsymMatrix® porous coating",
        [
            ("AsymMatrix® Coating", 0.50, 0.30),
            ("Bone In-Growth Surface", 0.50, 0.60),
            ("Femoral Component", 0.50, 0.85),
        ],
    ),
    # M4 Screen 4.6 — MC insert (2 slides)
    (
        "m4_mc_assembled.png",
        "Freedom MC Insert — Assembled",
        "Note the heightened anterior lip on the medial congruent insert",
        [
            ("Heightened Anterior Lip", 0.50, 0.30),
            ("MC Insert", 0.50, 0.55),
            ("Femoral Component", 0.50, 0.78),
        ],
    ),
    (
        "m4_mc_insert_only.png",
        "Freedom MC Insert — Detail",
        "Conforming medial side · lateral rollback-friendly surface",
        [
            ("Conforming Medial Side", 0.32, 0.50),
            ("Lateral Rollback Surface", 0.68, 0.50),
            ("Anterior Lip", 0.50, 0.25),
        ],
    ),
]


def render_image(filename, title, subtitle, labels, idx, total):
    """Render a single labelled placeholder PNG."""
    W, H = 1000, 1000
    # Use a soft warm educational-tone background
    bg = (252, 251, 248)
    img = Image.new("RGB", (W, H), bg)
    draw = ImageDraw.Draw(img)

    # Soft border
    draw.rectangle([(10, 10), (W - 10, H - 10)], outline=(220, 215, 200), width=2)

    # Title bar
    draw.rectangle([(10, 10), (W - 10, 80)], fill=(28, 42, 60))
    title_text = title
    bbox = draw.textbbox((0, 0), title_text, font=FONT_TITLE)
    tw = bbox[2] - bbox[0]
    draw.text(((W - tw) // 2, 22), title_text, fill=(255, 255, 255), font=FONT_TITLE)

    # Subtitle
    if subtitle:
        bbox = draw.textbbox((0, 0), subtitle, font=FONT_LABEL)
        sw = bbox[2] - bbox[0]
        draw.text(((W - sw) // 2, 95), subtitle, fill=(80, 80, 80), font=FONT_LABEL)

    # Central diagram area
    cx, cy = W // 2, H // 2 + 30
    # Draw a stylised knee/femur/tibia silhouette in the middle
    draw_diagram(draw, filename, cx, cy)

    # Labels with leader lines
    for label, fx, fy in labels:
        x = int(fx * W)
        y = int(fy * H)
        # Leader dot
        r = 6
        draw.ellipse([(x - r, y - r), (x + r, y + r)], fill=(220, 80, 50), outline=(255, 255, 255), width=2)
        # Label box
        bbox = draw.textbbox((0, 0), label, font=FONT_CAPTION)
        lw = bbox[2] - bbox[0]
        lh = bbox[3] - bbox[1]
        # Place label to the side, depending on horizontal position
        side_x = x + 12 if fx < 0.5 else x - 12 - lw
        label_box = (side_x - 6, y - lh // 2 - 3, side_x + lw + 6, y + lh // 2 + 3)
        # Pick a side for the leader line target
        target_x = side_x if fx < 0.5 else side_x + lw
        # Draw leader line
        draw.line([(x, y), (target_x, y)], fill=(220, 80, 50), width=2)
        draw.rectangle(label_box, fill=(255, 255, 255), outline=(220, 80, 50), width=1)
        draw.text((side_x, y - lh // 2 - 1), label, fill=(40, 40, 40), font=FONT_CAPTION)

    # Footer with filename and slide number
    footer = f"Slide {idx} / {total}  ·  {filename}"
    bbox = draw.textbbox((0, 0), footer, font=FONT_SMALL)
    fw = bbox[2] - bbox[0]
    draw.text(((W - fw) // 2, H - 35), footer, fill=(140, 140, 140), font=FONT_SMALL)

    out_path = os.path.join(OUT_DIR, filename)
    img.save(out_path, "PNG", optimize=True)
    return out_path


def draw_diagram(draw, filename, cx, cy):
    """Draw a stylised diagram appropriate to the slide topic."""
    name = filename.lower()

    if "approach" in name:
        # Draw a leg outline with the approach plane highlighted
        # Femur
        draw.polygon([(cx - 60, cy - 280), (cx + 60, cy - 280),
                      (cx + 55, cy - 50), (cx + 75, cy - 30),
                      (cx + 75, cy + 30), (cx + 55, cy + 50),
                      (cx - 55, cy + 50), (cx - 75, cy + 30),
                      (cx - 75, cy - 30), (cx - 55, cy - 50)],
                     fill=(245, 230, 210), outline=(120, 90, 60), width=2)
        # Knee joint
        draw.rectangle([(cx - 75, cy - 30), (cx + 75, cy + 30)], fill=(220, 200, 180), outline=(120, 90, 60), width=2)
        # Tibia
        draw.polygon([(cx - 55, cy + 30), (cx + 55, cy + 30),
                      (cx + 50, cy + 280), (cx - 50, cy + 280)],
                     fill=(245, 230, 210), outline=(120, 90, 60), width=2)
        # Approach plane highlight
        if "medial" in name:
            color = (220, 80, 50)
            for i in range(0, 280, 12):
                draw.line([(cx - 55 - i, cy + 30 + i), (cx - 50 - i, cy + 80 + i)], fill=color, width=3)
        elif "midvastus" in name:
            color = (50, 130, 220)
            draw.line([(cx - 20, cy - 280), (cx - 20, cy - 30)], fill=color, width=6)
            draw.line([(cx + 10, cy - 280), (cx + 10, cy - 30)], fill=color, width=2)
        elif "subvastus" in name:
            color = (60, 180, 100)
            draw.line([(cx - 50, cy - 50), (cx - 50, cy - 20)], fill=color, width=8)
    elif "5in1" in name or "cutting" in name:
        # Cutting block with multiple cut slots
        draw.rectangle([(cx - 140, cy - 90), (cx + 140, cy + 90)], fill=(180, 180, 190), outline=(60, 60, 60), width=2)
        # Cut slots
        for i, y in enumerate([cy - 70, cy - 35, cy, cy + 35, cy + 70]):
            color = (220, 80, 50) if i % 2 == 0 else (50, 130, 220)
            draw.line([(cx - 130, y), (cx + 130, y)], fill=color, width=4)
        # Mounting pins
        draw.ellipse([(cx - 100, cy - 110), (cx - 80, cy - 90)], fill=(120, 120, 120), outline=(60, 60, 60), width=2)
        draw.ellipse([(cx + 80, cy - 110), (cx + 100, cy - 90)], fill=(120, 120, 120), outline=(60, 60, 60), width=2)
    elif "titan" in name:
        # Gold-tinted knee
        draw.ellipse([(cx - 130, cy - 130), (cx + 130, cy + 130)], fill=(218, 165, 32), outline=(120, 90, 20), width=3)
        draw.ellipse([(cx - 110, cy - 110), (cx + 110, cy + 110)], fill=(240, 200, 100), outline=(140, 100, 30), width=2)
        draw.text((cx - 35, cy - 18), "TiNbN", fill=(80, 60, 20), font=FONT_LABEL)
    elif "porous" in name:
        # Femoral component with porous texture
        draw.ellipse([(cx - 140, cy - 140), (cx + 140, cy + 140)], fill=(180, 180, 185), outline=(80, 80, 90), width=3)
        # Porous dot texture
        import random
        random.seed(42)
        for _ in range(300):
            rx = random.randint(-130, 130)
            ry = random.randint(-130, 130)
            if rx * rx + ry * ry < 130 * 130:
                draw.ellipse([(cx + rx - 2, cy + ry - 2), (cx + rx + 2, cy + ry + 2)], fill=(60, 60, 70))
    elif "freedom" in name and ("total" in name or "mc_assembled" in name or "anterior" in name or "lateral" in name):
        # Femur (top)
        draw.polygon([(cx - 90, cy - 200), (cx + 90, cy - 200),
                      (cx + 95, cy - 80), (cx + 70, cy - 20),
                      (cx + 80, cy + 20), (cx + 70, cy + 60),
                      (cx - 70, cy + 60), (cx - 80, cy + 20),
                      (cx - 70, cy - 20), (cx - 95, cy - 80)],
                     fill=(220, 220, 225), outline=(80, 80, 90), width=2)
        # Poly insert
        draw.rectangle([(cx - 80, cy + 60), (cx + 80, cy + 130)],
                       fill=(245, 230, 200), outline=(120, 100, 60), width=2)
        # Tibial baseplate
        draw.rectangle([(cx - 100, cy + 130), (cx + 100, cy + 180)],
                       fill=(200, 200, 210), outline=(80, 80, 90), width=2)
        # Stem
        draw.rectangle([(cx - 15, cy + 180), (cx + 15, cy + 240)],
                       fill=(180, 180, 190), outline=(60, 60, 70), width=2)
    elif "radii" in name or "groove" in name or "transition" in name:
        # Femur with arc radii shown
        # Outer femur shape
        draw.ellipse([(cx - 150, cy - 180), (cx + 150, cy + 180)], fill=(220, 220, 225), outline=(80, 80, 90), width=3)
        # Concentric arcs for the radii
        for i, (r, color) in enumerate(zip([140, 120, 100, 80, 60, 40, 20],
                                            [(220, 80, 50), (240, 130, 50), (245, 180, 60),
                                             (120, 180, 80), (60, 160, 200), (90, 100, 200), (140, 80, 200)])):
            draw.arc([(cx - r, cy - r), (cx + r, cy + r)], 200, 340, fill=color, width=4)
    elif "design_attributes" in name:
        # Venn-like overlapping circles (no transparency)
        positions = [(cx - 110, cy - 60, (220, 80, 50)),
                     (cx + 110, cy - 60, (240, 130, 50)),
                     (cx, cy + 30, (60, 160, 200)),
                     (cx - 110, cy + 100, (120, 180, 80)),
                     (cx + 110, cy + 100, (180, 80, 200))]
        for x, y, color in positions:
            draw.ellipse([(x - 100, y - 70), (x + 100, y + 70)], outline=color, width=4)
    elif "sizing" in name and "femoral" in name:
        # 8 size boxes
        sizes = ["A", "B", "C", "D", "E", "F", "G", "H"]
        box_w = (700 - 7 * 6) // 8
        start_x = cx - 350
        for i, s in enumerate(sizes):
            x = start_x + i * (box_w + 6)
            color = (245, 165, 50)
            draw.rectangle([(x, cy - 80), (x + box_w, cy + 80)], fill=color, outline=(80, 50, 20), width=2)
            bbox = draw.textbbox((0, 0), s, font=FONT_TITLE)
            sw = bbox[2] - bbox[0]
            draw.text((x + (box_w - sw) // 2, cy - 20), s, fill=(40, 30, 10), font=FONT_TITLE)
    elif "trial" in name:
        draw.rectangle([(cx - 100, cy - 80), (cx + 100, cy + 80)],
                       fill=(220, 220, 225), outline=(80, 80, 90), width=2)
        draw.line([(cx, cy - 80), (cx, cy + 80)], fill=(60, 60, 70), width=3)
        draw.text((cx - 35, cy - 18), "TRIAL", fill=(60, 60, 70), font=FONT_LABEL)
    elif "keel" in name or "reaming" in name:
        draw.rectangle([(cx - 100, cy - 100), (cx + 100, cy + 100)],
                       fill=(245, 230, 210), outline=(120, 90, 60), width=2)
        draw.polygon([(cx - 30, cy + 30), (cx + 30, cy + 30),
                      (cx + 40, cy + 100), (cx - 40, cy + 100)],
                     fill=(180, 150, 110), outline=(100, 70, 40), width=2)
        draw.text((cx - 40, cy - 90), "Broach", fill=(80, 60, 30), font=FONT_CAPTION)
    elif "em_guide" in name or "extramed" in name:
        # Long alignment rod over tibia
        draw.polygon([(cx - 60, cy + 150), (cx + 60, cy + 150),
                      (cx + 50, cy - 250), (cx - 50, cy - 250)],
                     fill=(245, 230, 210), outline=(120, 90, 60), width=2)
        draw.line([(cx, cy - 250), (cx, cy + 200)], fill=(180, 80, 50), width=6)
        draw.ellipse([(cx - 70, cy - 70), (cx + 70, cy - 10)], fill=(60, 60, 70), outline=(40, 40, 50), width=2)
    elif "anatomy" in name or "ligament" in name or "knee_anatomy" in name:
        # Stylised knee
        # Femur
        draw.polygon([(cx - 80, cy - 250), (cx + 80, cy - 250),
                      (cx + 75, cy - 60), (cx + 90, cy - 20),
                      (cx + 75, cy + 20), (cx + 90, cy + 60),
                      (cx - 90, cy + 60), (cx - 75, cy + 20),
                      (cx - 90, cy - 20), (cx - 75, cy - 60)],
                     fill=(245, 230, 210), outline=(120, 90, 60), width=2)
        # Knee joint with menisci
        draw.rectangle([(cx - 90, cy - 30), (cx + 90, cy + 30)], fill=(220, 200, 180), outline=(120, 90, 60), width=2)
        # Menisci (left/right C shapes)
        draw.pieslice([(cx - 90, cy - 25), (cx - 10, cy + 25)], 270, 90, fill=(180, 220, 240), outline=(80, 110, 140), width=2)
        draw.pieslice([(cx + 10, cy - 25), (cx + 90, cy + 25)], 90, 270, fill=(180, 220, 240), outline=(80, 110, 140), width=2)
        # Patella
        draw.ellipse([(cx - 30, cy - 130), (cx + 30, cy - 70)], fill=(255, 240, 220), outline=(120, 90, 60), width=2)
        # Tibia
        draw.polygon([(cx - 60, cy + 30), (cx + 60, cy + 30),
                      (cx + 55, cy + 250), (cx - 55, cy + 250)],
                     fill=(245, 230, 210), outline=(120, 90, 60), width=2)
        # Ligament lines
        draw.line([(cx - 40, cy - 50), (cx - 20, cy + 30)], fill=(220, 80, 50), width=3)
        draw.line([(cx + 40, cy - 50), (cx + 20, cy + 30)], fill=(50, 130, 220), width=3)
    elif "cartilage" in name or "menisci" in name or "wear" in name:
        # Top-down menisci view
        draw.rectangle([(cx - 160, cy - 130), (cx + 160, cy + 130)], fill=(220, 200, 180), outline=(120, 90, 60), width=2)
        draw.pieslice([(cx - 160, cy - 120), (cx - 20, cy + 120)], 270, 90, fill=(180, 220, 240), outline=(80, 110, 140), width=2)
        draw.pieslice([(cx + 20, cy - 120), (cx + 160, cy + 120)], 90, 270, fill=(180, 220, 240), outline=(80, 110, 140), width=2)
        if "wear" in name or "worn" in name:
            draw.line([(cx - 20, cy), (cx + 20, cy)], fill=(60, 60, 70), width=4)
    elif "osteo" in name or "oa" in name:
        # Two knees side by side, healthy vs arthritic
        for i, (x, label, color, spur) in enumerate([
            (cx - 130, "NORMAL", (245, 230, 210), False),
            (cx + 130, "OA", (230, 210, 190), True),
        ]):
            draw.polygon([(x - 60, cy - 150), (x + 60, cy - 150),
                          (x + 55, cy - 30), (x + 70, cy),
                          (x + 55, cy + 30), (x + 60, cy + 150),
                          (x - 60, cy + 150), (x - 55, cy + 30),
                          (x - 70, cy), (x - 55, cy - 30)],
                         fill=color, outline=(120, 90, 60), width=2)
            # Joint space
            if spur:
                draw.rectangle([(x - 70, cy - 8), (x + 70, cy + 8)], fill=(80, 60, 40))
                # Bone spurs
                draw.polygon([(x + 70, cy - 25), (x + 95, cy - 35),
                              (x + 95, cy + 35), (x + 70, cy + 25)],
                             fill=(220, 180, 130), outline=(120, 90, 60), width=2)
            else:
                draw.rectangle([(x - 70, cy - 15), (x + 70, cy + 15)], fill=(255, 240, 220), outline=(120, 90, 60), width=2)
            bbox = draw.textbbox((0, 0), label, font=FONT_LABEL)
            lw = bbox[2] - bbox[0]
            draw.text((x - lw // 2, cy + 170), label, fill=(40, 40, 40), font=FONT_LABEL)
    elif "alignment" in name:
        # Two legs (pelvis + femurs + tibias)
        draw.ellipse([(cx - 180, cy - 240), (cx + 180, cy - 180)], fill=(245, 230, 210), outline=(120, 90, 60), width=2)
        if "normal" in name:
            l_knee = (cx - 80, cy)
            r_knee = (cx + 80, cy)
        elif "varus" in name:
            l_knee = (cx - 100, cy)
            r_knee = (cx + 100, cy)
        else:
            l_knee = (cx - 60, cy)
            r_knee = (cx + 60, cy)
        # Femurs
        for hip_x in [cx - 130, cx + 130]:
            knee = l_knee if hip_x < cx else r_knee
            draw.line([(hip_x, cy - 180), knee], fill=(245, 230, 210), width=40)
            ankle_x = cx - 50 if hip_x < cx else cx + 50
            draw.line([knee, (ankle_x, cy + 240)], fill=(245, 230, 210), width=40)
        # Knees
        for k in [l_knee, r_knee]:
            draw.ellipse([(k[0] - 22, k[1] - 22), (k[0] + 22, k[1] + 22)],
                         fill=(220, 200, 180), outline=(120, 90, 60), width=2)
    elif "partial" in name:
        draw.polygon([(cx - 90, cy - 180), (cx + 90, cy - 180),
                      (cx + 90, cy - 30), (cx + 50, cy + 30),
                      (cx - 50, cy + 30), (cx - 90, cy - 30)],
                     fill=(245, 230, 210), outline=(120, 90, 60), width=2)
        draw.ellipse([(cx - 80, cy - 130), (cx + 80, cy - 50)],
                     fill=(220, 220, 225), outline=(80, 80, 90), width=2)
    else:
        # Generic knee outline
        draw.polygon([(cx - 80, cy - 230), (cx + 80, cy - 230),
                      (cx + 75, cy - 60), (cx + 90, cy - 20),
                      (cx + 75, cy + 20), (cx + 90, cy + 60),
                      (cx - 90, cy + 60), (cx - 75, cy + 20),
                      (cx - 90, cy - 20), (cx - 75, cy - 60)],
                     fill=(245, 230, 210), outline=(120, 90, 60), width=2)
        draw.rectangle([(cx - 90, cy - 30), (cx + 90, cy + 30)], fill=(220, 200, 180), outline=(120, 90, 60), width=2)
        draw.polygon([(cx - 60, cy + 30), (cx + 60, cy + 30),
                      (cx + 55, cy + 230), (cx - 55, cy + 230)],
                     fill=(245, 230, 210), outline=(120, 90, 60), width=2)


def main():
    total = len(SLIDES)
    print(f"Rendering {total} placeholder images to {OUT_DIR}")
    for idx, (filename, title, subtitle, labels) in enumerate(SLIDES, 1):
        path = render_image(filename, title, subtitle, labels, idx, total)
        size_kb = os.path.getsize(path) / 1024
        print(f"  [{idx:2d}/{total}] {filename:<45s} {size_kb:6.1f} KB")
    print("Done.")


if __name__ == "__main__":
    main()