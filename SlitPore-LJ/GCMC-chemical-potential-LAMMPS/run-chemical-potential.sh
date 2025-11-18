#!/bin/bash

lmp=/home/simon/Softwares/lammps-22Jul2025/src/lmp_mpi

# List of pressures
mus=(-4.0 -3.8 -3.6 -3.4 -3.2 -3.0)

# Path to your reference input file
ref_input="reference-files/input.lmp"

# Loop over pressures
for mu in "${mus[@]}"; do
    folder="mu_${mu}kcalmol"
    echo "Creating folder: $folder"

    # Make directory
    mkdir -p "$folder"

    # Copy the input file
    cp "$ref_input" "$folder/"

    # Modify the pressure line
    # Changes: variable pressure equal X
    sed -i "s/^variable mu equal .*/variable mu equal ${mu}/" "$folder/input.lmp"

    # Move into folder and run LAMMPS
    cd "$folder"
        echo "Running LAMMPS for chemical potential ${mu} ..."
        mpirun -np 4 ${lmp} -in input.lmp
    cd ..
done
