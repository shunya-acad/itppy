#!/usr/bin/env bash

script_dir="$(dirname "$(readlink -f "$0")")"
cd "${script_dir}" || exit
cd ../../../

./.py-venv/bin/activate

./.py-venv/bin/python3 resources/scripts/sys-ops/finalize-offline-material.py

