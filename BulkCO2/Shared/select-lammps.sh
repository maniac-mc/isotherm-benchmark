#!/usr/bin/env bash

# Directory where lammps-* versions live
base="/home/simon/Softwares"

# Find all lammps-* dirs
dirs=( "$base"/lammps-* )

# Sort newest first by date encoded in folder name
latest_dirs=$(printf '%s\n' "${dirs[@]}" | sort -t- -k2,2r)

# Pick the first directory containing lmp_serial
for d in $latest_dirs; do
    if [[ -x "$d/src/lmp_serial" ]]; then
        echo "$d/src/lmp_serial"
        exit 0
    fi
done

echo "ERROR: No lmp_serial found." >&2
exit 1
