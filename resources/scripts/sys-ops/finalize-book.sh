#!/usr/bin/env bash

source ./resources/scripts/sys-ops/check-current-directory.sh

cd "${itppy_absolute_path}" || exit

rm -rf book/_freeze
rm -rf book/content/**/*cache/

time quarto render book
