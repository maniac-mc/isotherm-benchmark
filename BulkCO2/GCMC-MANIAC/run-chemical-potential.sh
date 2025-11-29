#!/bin/bash

# List of pressures
mus=(-8.8 -8.6 -8.4 -8.2 -8.0 -7.8)

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

    # Move into folder and run Maniac in background
    (
        cd "$folder"
        ln -s ../../Shared/co2.mol .
        ln -s ../../Shared/parameters.inc .
        ln -s ../reference-files/topology.data .
        ./run.sh    
    ) &
done
