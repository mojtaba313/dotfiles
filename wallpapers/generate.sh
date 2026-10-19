#!/usr/bin/env bash
# ============================================
# generate.sh — Abyss Cyan wallpapers
# Rebuild with:  bash wallpapers/generate.sh
#
# Glows are built from radial gradients rather than blurred circles:
# visually equivalent, and ~30x faster than ImageMagick's large blurs.
# Grain is applied at render scale (before upscale) for the same reason.
# ============================================
set -euo pipefail

cd "$(dirname "$0")"

RW=1280   # render size
RH=720
W=2560    # final size
H=1440

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

magick -size "${RW}x${RH}" gradient:'#04080d-#08111b' "$TMP/base.png"

# glow <rgba(r,g,b,a)> <center-x> <center-y> <diameter> <tag>
glow() {
  local inner="$1" cx="$2" cy="$3" d="$4" tag="$5"
  local rgb="${inner#rgba(}"
  rgb="${rgb%,*}"                       # "r,g,b"
  local outer="rgba(${rgb},0)"
  magick -size "${d}x${d}" radial-gradient:"${inner}-${outer}" "$TMP/g${tag}.png"
  magick "$TMP/base.png" "$TMP/g${tag}.png" \
    -geometry "+$(( cx - d / 2 ))+$(( cy - d / 2 ))" \
    -compose screen -composite "$TMP/c.png"
  mv "$TMP/c.png" "$TMP/base.png"
}

glow 'rgba(0,229,255,0.62)'   300 250 560 0
glow 'rgba(45,212,191,0.46)'  980 520 620 1
glow 'rgba(29,111,255,0.28)'  900 170 420 2
glow 'rgba(122,240,255,0.14)' 420 610 380 3

# faint contour arcs for texture
magick -size "${RW}x${RH}" xc:none -fill none \
  -stroke 'rgba(0,229,255,0.07)' -strokewidth 2 \
  -draw "circle 300,250 300,-60" \
  -draw "circle 300,250 610,250" \
  -draw "circle 980,520 980,270" \
  "$TMP/arcs.png"
magick "$TMP/base.png" "$TMP/arcs.png" -compose screen -composite "$TMP/base.png"

# vignette
magick -size "${RW}x${RH}" radial-gradient:'white-black' \
  -evaluate multiply 0.78 "$TMP/vig.png"
magick "$TMP/base.png" "$TMP/vig.png" -compose multiply -composite "$TMP/base.png"

# grain at render scale, then upscale
magick "$TMP/base.png" -attenuate 0.3 +noise Gaussian -modulate 112,115,100 "$TMP/base.png"

# JPEG keeps the grain cheap: ~500 KB instead of ~17 MB as PNG
magick "$TMP/base.png" -filter Lanczos -resize "${W}x${H}!" \
  -quality 92 -sampling-factor 4:2:0 "abyss-cyan.jpg"

magick "abyss-cyan.jpg" -resize 1440x2560^ -gravity center -extent 1440x2560 \
  -quality 92 -sampling-factor 4:2:0 "abyss-cyan-vertical.jpg"

echo "wrote abyss-cyan.jpg + abyss-cyan-vertical.jpg"