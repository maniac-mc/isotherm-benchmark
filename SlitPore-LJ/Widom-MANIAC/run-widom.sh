#!/usr/bin/env bash

# Select LAMMPS
lmp_serial=$(../Shared/select-lammps.sh)

# List of pressures
npart=(1 2 6 10 20 50)

# Path to your reference input file
ref_input="reference-files/input.lmp"
ref_input2="reference-files/input.maniac"
ref_bash="reference-files/run.sh"

# Loop over pressures
for nb in "${npart[@]}"; do
    folder="nb_${nb}"
    echo "Creating folder: $folder"

    # Make directory
    mkdir -p "$folder"

    # Copy the input file
    cp "$ref_input" "$folder/"
    cp "$ref_input2" "$folder/"
    cp "$ref_bash" "$folder/"

    # Modify the pressure line
    # Changes: variable pressure equal X
    sed -i "s/^variable number equal .*/variable number equal ${nb}/" "$folder/input.lmp"
    # Generate a random seed between 10000 and 99999
    seed=$((RANDOM + 10000))
    sed -i "s/^variable seed equal .*/variable seed equal ${seed}/" "$folder/input.lmp"

    # Move into folder and run LAMMPS (just to place molecule) then Maniac in the background
    (
        cd "$folder"
        ln -s ../../Shared/empty-pore.data .
        ln -s ../../Shared/header.lmp .
        ln -s ../../Shared/parameters.inc .
        ${lmp_serial} -in input.lmp > lammps.log 2>&1
        ./run.sh > maniac.log 2>&1
    ) &

done
