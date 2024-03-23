#!/usr/bin/env bash

source ./resources/scripts/sys-ops/check-current-directory.sh

cd "${itppy_absolute_path}" || exit

bash ./resources/scripts/sys-ops/prepare-slides-aggregate.sh
time quarto render slides --profile handout
