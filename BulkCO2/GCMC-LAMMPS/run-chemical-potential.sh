#!/bin/bash

# Select LAMMPS
lmp_serial=$(../Shared/select-lammps.sh)

# List of chemical potential
mus=(-10.0 -9.5 -9.0 -8.5 -8.0)

# Path to your reference input file
ref_input="reference-files/input.lmp"

# Number of parallel jobs
max_jobs=10   # change this depending on CPU/MPI resources
job_count=0

# Loop over chemical potential
for mu in "${mus[@]}"; do

    folder="mu_${mu}kcalmol"
    echo "Creating folder: $folder"

    # Make directory
    mkdir -p "$folder"

    # Copy the input file
    cp "$ref_input" "$folder/"

    # Modify the pressure line
    sed -i "s/^variable mu equal .*/variable mu equal ${mu}/" "$folder/input.lmp"

    # Run LAMMPS in the background, redirect output to log
    (
        cd "$folder"
        ln -s ../../Shared/co2.mol .
        ln -s ../../Shared/header.lmp .
        ln -s ../../Shared/parameters.inc .
        ln -s ../../Shared/gcmc.lmp .
        echo "Running LAMMPS for mu=${mu} ..."
        ${lmp_serial} -in input.lmp > lammps.log 2>&1
    ) &

    ((job_count++))
    # Limit the number of parallel jobs
    if (( job_count % max_jobs == 0 )); then
        wait
    fi
done
