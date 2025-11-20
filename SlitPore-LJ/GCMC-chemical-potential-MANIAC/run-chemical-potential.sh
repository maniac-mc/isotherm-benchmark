#!/bin/bash

lmp=/home/simon/Softwares/lammps-22Jul2025/src/lmp_mpi

# List of pressures
mus=(-4.0 -3.8 -3.6 -3.4 -3.2 -3.0)

# Path to your reference input file
ref_input="reference-files/input.maniac"
ref_bash="reference-files/run.sh"

# Loop over pressures
for mu in "${mus[@]}"; do
    folder="mu_${mu}kcalmol"
    echo "Creating folder: $folder"

    # Make directory
    mkdir -p "$folder"

    # Copy the input file
    cp "$ref_input" "$folder/"
    cp "$ref_bash" "$folder/"

    sed -i "s/^[[:space:]]*chemical_potential .*/  chemical_potential ${mu}/" "$folder/input.maniac"

    # Move into folder and run LAMMPS
    cd "$folder"
        ./run.sh
    cd ..
done
