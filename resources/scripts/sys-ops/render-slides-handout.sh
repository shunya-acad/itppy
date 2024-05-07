#!/usr/bin/env bash

script_dir="$(dirname "$(readlink -f "$0")")"
source "$script_dir"/get-current-directory.sh

cd "${itppy_absolute_path}" || exit

bash resources/scripts/sys-ops/prepare-slides-aggregate.sh
time quarto render slides --profile handout
