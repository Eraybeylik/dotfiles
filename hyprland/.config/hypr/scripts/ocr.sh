#!/usr/bin/env bash
# OCR capture: select a region, extract its text with tesseract, copy to
# clipboard. Bound to SUPER+CTRL+Print.

if ! command -v tesseract >/dev/null; then
    notify-send -e "OCR" "tesseract is not installed (pacman -S tesseract tesseract-data-eng tesseract-data-tur)"
    exit 1
fi

tmp=$(mktemp --suffix=.png)
trap 'rm -f "$tmp"' EXIT

grimblast save area "$tmp" || exit 1

text=$(tesseract "$tmp" - -l tur+eng 2>/dev/null)

if [ -z "${text//[[:space:]]/}" ]; then
    notify-send -e "OCR" "No text found in selection"
    exit 0
fi

printf '%s' "$text" | wl-copy
notify-send -e "OCR" "Copied to clipboard:\n${text:0:200}"
