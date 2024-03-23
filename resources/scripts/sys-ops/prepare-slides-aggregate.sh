#!/usr/bin/env bash

source ./resources/scripts/sys-ops/check-current-directory.sh

cd "${itppy_absolute_path}" || exit

rm -rf slides/_freeze
rm -rf slides/content/.aggregate/*

./.py-venv/bin/python3 ./resources/scripts/sys-ops/slides/merge-qmd.py
