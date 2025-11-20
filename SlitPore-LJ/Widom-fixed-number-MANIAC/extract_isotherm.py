#!/usr/bin/env python
# coding: utf-8

import os
import numpy as np
import matplotlib.pyplot as plt

base = "."

number_vs_muex = []

for folder in os.listdir(base): # Loop through folders

    if folder.startswith("nb_"):

        # Extract numeric pressure (e.g., "pressure_0.001atom")
        nb_str = folder.replace("nb_", "").replace("kcalmol", "")
        nb_flt = np.float32(nb_str)

        # Read data file
        widom_path = os.path.join(base, folder, "outputs/widom_fluid.dat")
        if not os.path.exists(widom_path):
            continue

        # Read last non-empty line
        step, muex, deltaU, volume = np.loadtxt(widom_path).T

        mean_muex = np.mean(muex)
        mean_deltaU = np.mean(deltaU)
        mean_volume = np.mean(volume)

        number_vs_muex.append([mean_muex, nb_flt])

number_vs_muex = np.array(number_vs_muex)

np.savetxt("number_vs_muex.dat", number_vs_muex, 
           header="# muex (kcal/mol) N (average particle number)", 
           comments='')
