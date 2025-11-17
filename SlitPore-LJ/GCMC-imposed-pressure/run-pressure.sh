#!/bin/bash

lmp=/home/simon/Softwares/lammps-22Jul2025/src/lmp_mpi

# List of pressures
pressures=(0.00031 0.001 0.0031 0.01 0.031 0.1)

# Path to your reference input file
ref_input="reference-files/input.lmp"

# Loop over pressures
for P in "${pressures[@]}"; do
    folder="pressure_${P}atom"
    echo "Creating folder: $folder"

    # Make directory
    mkdir -p "$folder"

    # Copy the input file
    cp "$ref_input" "$folder/"

    # Modify the pressure line
    # Changes: variable pressure equal X
    sed -i "s/^variable pressure equal .*/variable pressure equal ${P}/" "$folder/input.lmp"

    # Move into folder and run LAMMPS
    cd "$folder"
        echo "Running LAMMPS for pressure $P ..."
        mpirun -np 4 ${lmp} -in input.lmp
    cd ..
done
