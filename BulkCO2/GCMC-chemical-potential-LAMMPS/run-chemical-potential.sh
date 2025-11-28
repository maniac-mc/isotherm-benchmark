#!/bin/bash

lmp=/home/simon/Softwares/lammps-22Jul2025/src/lmp_mpi

# List of pressures
mus=(-8.6 -8.4 -8.2 -8.0 -7.8 -7.6)

# Path to your reference input file
ref_input="reference-files/input.lmp"

# Number of parallel jobs
max_jobs=6   # change this depending on CPU/MPI resources
job_count=0

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

    cd "$folder"
    mpirun -np 4 ${lmp} -in input.lmp
    cd ..

    # # Run LAMMPS in the background, redirect output to log
    # (
    #     cd "$folder"
    #     echo "Running LAMMPS for mu=${mu} ..."
    #     mpirun -np 4 ${lmp} -in input.lmp > lammps.log 2>&1
    # ) &

    # ((job_count++))
    # # Limit the number of parallel jobs
    # if (( job_count % max_jobs == 0 )); then
    #     wait
    # fi
done
