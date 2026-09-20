#!/usr/bin/env python3
"""
Diagonal text watermark tool.

Only dependency: Pillow  ->  pip install Pillow

Usage:
    python watermark.py photo.jpg "CONFIDENTIAL"
    python watermark.py photo.png "© Me 2026" -o out.png --opacity 0.4 --tile
"""
import argparse
import sys
from PIL import Image, ImageDraw, ImageFont, ImageColor


def find_font(size):
    return ImageFont.truetype("DejaVuSans.ttf", size)  # always works, but doesn't scale nicely

def ink_box(font, text):
    """Ink bounds (left, top, right, bottom) of text drawn at the origin."""
    if hasattr(font, "getbbox"):
        return font.getbbox(text)
    w, h = font.getsize(text)  # older Pillow: no offset available
    return (0, 0, w, h)


def text_size(font, text):
    """Text width/height, compatible across Pillow versions."""
    left, top, right, bottom = ink_box(font, text)
    return right - left, bottom - top


def watermark(in_path, out_path, text, opacity=0.30, angle=30, tile=False, scale=0.08, color="white"):
    base = Image.open(in_path).convert("RGBA")
    w, h = base.size

    # Font size scales with the image's smaller side, so it adapts to any size/shape.
    font_size = max(12, int(min(w, h) * scale))
    font = find_font(font_size)

    overlay = Image.new("RGBA", base.size, (0, 0, 0, 0))
    r, g, b = ImageColor.getrgb(color)[:3]
    fill = (r, g, b, int(255 * opacity))

    if tile:
        # Repeat the text across a big square, rotate it, then crop the center.
        tw, th = text_size(font, text)
        step_x, step_y = tw + int(tw * 0.4), th + int(th * 2.0)
        diag = int((w ** 2 + h ** 2) ** 0.5)  # square this big always covers the center after rotation

        layer = Image.new("RGBA", (diag, diag), (0, 0, 0, 0))
        d = ImageDraw.Draw(layer)
        for y in range(0, diag, step_y):
            for x in range(0, diag, step_x):
                d.text((x, y), text, font=font, fill=fill)

        layer = layer.rotate(angle, resample=Image.BICUBIC, expand=False)
        left, top = (layer.width - w) // 2, (layer.height - h) // 2
        overlay.alpha_composite(layer.crop((left, top, left + w, top + h)))
    else:
        # Single diagonal line of text, centered.
        left, top, right, bottom = ink_box(font, text)
        tw, th = right - left, bottom - top
        pad = max(4, font_size // 10)
        txt_layer = Image.new("RGBA", (tw + 2 * pad, th + 2 * pad), (0, 0, 0, 0))
        # Shift by -left, -top so the glyphs sit fully inside the canvas at any size.
        ImageDraw.Draw(txt_layer).text((pad - left, pad - top), text, font=font, fill=fill)
        txt_layer = txt_layer.rotate(angle, resample=Image.BICUBIC, expand=True)
        pos = ((w - txt_layer.width) // 2, (h - txt_layer.height) // 2)
        overlay.alpha_composite(txt_layer, pos)

    result = Image.alpha_composite(base, overlay)

    # JPEG can't store transparency, so flatten to RGB for jpg/jpeg outputs.
    ext = out_path.lower().rsplit(".", 1)[-1] if "." in out_path else ""
    if ext in ("jpg", "jpeg"):
        result = result.convert("RGB")
    result.save(out_path)
    print("Saved:", out_path)


def main():
    p = argparse.ArgumentParser(description="Apply a diagonal text watermark to an image.")
    p.add_argument("image", help="input image path")
    p.add_argument("text", help="watermark text")
    p.add_argument("-o", "--output", help="output path (default: <name>_wm.<ext>)")
    p.add_argument("--opacity", type=float, default=0.30, help="0.0-1.0 (default 0.30)")
    p.add_argument("--angle", type=float, default=30, help="rotation in degrees (default 30)")
    p.add_argument("--scale", type=float, default=0.40,
                   help="font size as fraction of the image's smaller side (default 0.08)")
    p.add_argument("--color", default="black",
                   help="text color: name (black, white, red) or hex (#000000) (default white)")
    p.add_argument("--tile", action="store_true", help="repeat the watermark across the whole image")
    args = p.parse_args()

    out = args.output
    if not out:
        if "." in args.image:
            name, ext = args.image.rsplit(".", 1)
            out = f"{name}_wm.{ext}"
        else:
            out = args.image + "_wm.png"

    try:
        watermark(args.image, out, args.text, args.opacity, args.angle, args.tile, args.scale, args.color)
    except FileNotFoundError:
        sys.exit(f"Error: file not found: {args.image}")
    except ValueError:
        sys.exit(f"Error: unknown color: {args.color!r} (try a name like 'black' or hex like '#000000')")


if __name__ == "__main__":
    main()
