#!/usr/bin/env bash

itppy_absolute_path="${HOME}/core/projects/itppy"

export itppy_absolute_path

if [[ ! "${PWD}" == "${itppy_absolute_path}" ]]; then
    echo "run commands from ${itppy_absolute_path}"
fi
