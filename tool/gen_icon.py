#!/usr/bin/env python3
"""Generate the OpenChat app icon set (Android mipmaps + web icons + favicon).

The icon is a rounded-corner square with a purple→teal diagonal gradient and a
white speech-bubble glyph, matching the in-app brand colors.
"""
import math
import os

from PIL import Image, ImageDraw

# Brand colors (see lib/presentation/themes/colors.dart).
PRIMARY = (140, 92, 255)   # #8C5CFF
ACCENT = (0, 217, 192)     # #00D9C0
WHITE = (243, 243, 245)

PROJECT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def lerp(a, b, t):
    return tuple(int(a[i] + (b[i] - a[i]) * t) for i in range(3))


def make_icon(size, *, rounded=True, padding_ratio=0.0, bg=True):
    """Render the icon at `size` px. padding_ratio insets the glyph/bg for
    maskable/adaptive safe zones."""
    scale = 4
    s = size * scale
    img = Image.new("RGBA", (s, s), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    pad = int(s * padding_ratio)
    box = (pad, pad, s - pad, s - pad)
    bw = box[2] - box[0]

    if bg:
        # Diagonal gradient via per-row blend (cheap and smooth enough at 4x).
        grad = Image.new("RGBA", (s, s), (0, 0, 0, 0))
        gd = grad.load()
        for y in range(box[1], box[3]):
            for x in range(box[0], box[2]):
                t = ((x - box[0]) + (y - box[1])) / (2 * bw)
                gd[x, y] = lerp(PRIMARY, ACCENT, max(0.0, min(1.0, t))) + (255,)

        # Rounded mask.
        mask = Image.new("L", (s, s), 0)
        md = ImageDraw.Draw(mask)
        radius = int(bw * 0.22) if rounded else 0
        md.rounded_rectangle(box, radius=radius, fill=255)
        img.paste(grad, (0, 0), mask)
        draw = ImageDraw.Draw(img)

    # Speech bubble glyph.
    cx0 = box[0] + bw * 0.24
    cy0 = box[1] + bw * 0.26
    cx1 = box[0] + bw * 0.76
    cy1 = box[1] + bw * 0.66
    r = bw * 0.10
    draw.rounded_rectangle([cx0, cy0, cx1, cy1], radius=r, fill=WHITE + (255,))
    # Tail.
    tail_x = box[0] + bw * 0.36
    tail_y = cy1 - 1
    draw.polygon(
        [
            (tail_x, tail_y),
            (tail_x + bw * 0.14, tail_y),
            (tail_x, box[1] + bw * 0.80),
        ],
        fill=WHITE + (255,),
    )
    # Three dots.
    dot_r = bw * 0.035
    dot_y = (cy0 + cy1) / 2
    for i, frac in enumerate((0.38, 0.5, 0.62)):
        dx = box[0] + bw * frac
        col = lerp(PRIMARY, ACCENT, i / 2) + (255,)
        draw.ellipse([dx - dot_r, dot_y - dot_r, dx + dot_r, dot_y + dot_r], fill=col)

    return img.resize((size, size), Image.LANCZOS)


def save(img, path):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    img.save(path)
    print("wrote", path)


def main():
    # Android legacy launcher icons.
    android_sizes = {
        "mdpi": 48,
        "hdpi": 72,
        "xhdpi": 96,
        "xxhdpi": 144,
        "xxxhdpi": 192,
    }
    for dpi, px in android_sizes.items():
        icon = make_icon(px, rounded=True)
        save(
            icon,
            os.path.join(
                PROJECT, "android/app/src/main/res", f"mipmap-{dpi}", "ic_launcher.png"
            ),
        )

    # Web icons.
    for px in (192, 512):
        save(
            make_icon(px, rounded=True),
            os.path.join(PROJECT, "web/icons", f"Icon-{px}.png"),
        )
        # Maskable variants need extra safe-zone padding.
        save(
            make_icon(px, rounded=False, padding_ratio=0.10),
            os.path.join(PROJECT, "web/icons", f"Icon-maskable-{px}.png"),
        )

    # Favicon.
    save(make_icon(64, rounded=True), os.path.join(PROJECT, "web/favicon.png"))

    # macOS/desktop and a high-res master.
    save(make_icon(1024, rounded=True), os.path.join(PROJECT, "assets/icon.png"))


if __name__ == "__main__":
    main()
