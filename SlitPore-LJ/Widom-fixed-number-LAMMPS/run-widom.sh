#!/bin/bash

lmp=/home/simon/Softwares/lammps-22Jul2025/src/lmp_serial

# List of pressures
npart=(150 250)

# Path to your reference input file
ref_input="reference-files/input.lmp"

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

    # Move into folder and run LAMMPS
    cd "$folder"
        echo "Running LAMMPS for chemical potential ${nb} ..."
        ${lmp} -in input.lmp &
    cd ..
done
