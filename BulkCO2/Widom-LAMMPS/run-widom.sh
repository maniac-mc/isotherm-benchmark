#!/bin/bash

# Select LAMMPS
lmp_serial=$(../Shared/select-lammps.sh)

# List of pressures
npart=(5 10 20 50 100 150 250)

# Path to your reference input file
ref_input="reference-files/input.lmp"

# Number of parallel jobs
max_jobs=10
job_count=0

# Loop over pressures
for nb in "${npart[@]}"; do
    folder="nb_${nb}"
    echo "Creating folder: $folder"

    # Make directory
    mkdir -p "$folder"

    # Copy the input file
    cp "$ref_input" "$folder/"

    # Modify the pressure line
    # Changes: variable pressure equal X
    sed -i "s/^variable number equal .*/variable number equal ${nb}/" "$folder/input.lmp"
    # Generate a random seed between 10000 and 99999
    seed=$((RANDOM + 10000))
    sed -i "s/^variable seed equal .*/variable seed equal ${seed}/" "$folder/input.lmp"

    # Run LAMMPS in the background, redirect output to log
    (
        cd "$folder"
        ln -s ../../Shared/co2.mol .
        ln -s ../../Shared/header.lmp .
        ln -s ../../Shared/parameters.inc .
        ln -s ../../Shared/widom.lmp .
        echo "Running LAMMPS for mu=${mu} ..."
        ${lmp_serial} -in input.lmp > lammps.log 2>&1
    ) &

    ((job_count++))
    # Limit the number of parallel jobs
    if (( job_count % max_jobs == 0 )); then
        wait
    fi

done
