#!/usr/bin/env python
# coding: utf-8

import os
import numpy as np
import matplotlib.pyplot as plt

base = "."

number_vs_mu = []

for folder in os.listdir(base): # Loop through folders

    if folder.startswith("mu_") and folder.endswith("kcalmol"):

        # Extract numeric pressure (e.g., "pressure_0.001atom")
        mu_str = folder.replace("mu_", "").replace("kcalmol", "")
        mu_flt = np.float32(mu_str)

        # Read data file
        nb_path = os.path.join(base, folder, "outputs/number_co2.dat")
        if not os.path.exists(nb_path):
            continue

        # Read last non-empty line
        step, number= np.loadtxt(nb_path).T
        ten_percent = len(number)//10
        number = np.mean(number[ten_percent:])

        number_vs_mu.append([mu_flt, number])

number_vs_mu = np.array(number_vs_mu)

np.savetxt("number_vs_mu.dat", number_vs_mu, 
           header="# mu (kcal/mol)    N (average particle number)", 
           comments='')
