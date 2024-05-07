#!/usr/bin/env bash

script_dir="$(dirname "$(readlink -f "$0")")"
source "$script_dir"/get-current-directory.sh

cd "${itppy_absolute_path}" || exit

rm -rf slides/_freeze
rm -rf slides/content/.aggregate/*

./.py-venv/bin/python3 ./resources/scripts/sys-ops/slides/merge-qmd.py
