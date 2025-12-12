#!/bin/bash
set -e

input="input.maniac"
data="topology.data"
inc="parameters.inc"
# res="../../Reservoir/topology.data"
outputs="outputs/"

maniac="/home/simon/Git/Maniac/maniac-mc.github.io/build/maniac"

# Silent run
$maniac -i "$input" -d "$data" -p "$inc" -o "$outputs" ${res:+-r "$res"} > /dev/null 2>&1

rm -f fort.10
