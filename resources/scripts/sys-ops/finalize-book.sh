#!/usr/bin/env bash

script_dir="$(dirname "$(readlink -f "$0")")"
source "$script_dir"/get-current-directory.sh

cd "${itppy_absolute_path}" || exit

rm -rf book/_freeze
rm -rf book/content/**/*cache/

time quarto render book
