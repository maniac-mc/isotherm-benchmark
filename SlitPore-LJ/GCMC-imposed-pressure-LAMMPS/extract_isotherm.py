#!/usr/bin/env python
# coding: utf-8

import os
import numpy as np
import matplotlib.pyplot as plt

base = "."

number_vs_pressure = []

for folder in os.listdir(base): # Loop through folders

    if folder.startswith("pressure_") and folder.endswith("atom"):

        # Extract numeric pressure (e.g., "pressure_0.001atom")
        p_str = folder.replace("pressure_", "").replace("atom", "")
        p_flt = np.float32(p_str)

        # Read data file
        nb_path = os.path.join(base, folder, "nb.dat")
        if not os.path.exists(nb_path):
            continue

        # Read last non-empty line
        step, number= np.loadtxt(nb_path).T
        ten_percent = len(number)//10
        number = np.mean(number[ten_percent:])

        number_vs_pressure.append([p_flt, number])

number_vs_pressure = np.array(number_vs_pressure)

np.savetxt("number_vs_pressure.dat", number_vs_pressure, 
           header="# p (atm)    N (average particle number)", 
           comments='')
