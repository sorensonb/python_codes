#!/usr/bin/env python
"""


"""
import os
import sys

base_dir = "/home/bsorenson/Research/"
dest_dir = "/home/bsorenson/Arctic_codes/"

# ---------------------------------------------------------------------------- 
# Backup the backup script
# ---------------------------------------------------------------------------- 
print("code_backup.py")
cmnd = "cp /home/bsorenson/code_backup.py "+dest_dir
print(cmnd)
os.system(cmnd)
# ---------------------------------------------------------------------------- 
# Ice analysis
# ---------------------------------------------------------------------------- 
print("Ice_analysis")
cmnd = "cp "+base_dir+"Ice_analysis/*.py "+dest_dir
print(cmnd)
os.system(cmnd)
# ---------------------------------------------------------------------------- 
# CERES raw codes
# ---------------------------------------------------------------------------- 
print("CERES")
cmnd = "cp "+base_dir+"CERES/*.py "+dest_dir
print(cmnd)
os.system(cmnd)
cmnd = "cp "+base_dir+"CERES/*.c "+dest_dir
print(cmnd)
os.system(cmnd)
cmnd = "cp "+base_dir+"CERES/Make* "+dest_dir
print(cmnd)
os.system(cmnd)
# ---------------------------------------------------------------------------- 
# CERES_Ice_comparison codes
# ---------------------------------------------------------------------------- 
print("CERES_Ice_comparison")
cmnd = "cp "+base_dir+"CERES_Ice_comparison/*.py "+dest_dir
print(cmnd)
os.system(cmnd)
# ---------------------------------------------------------------------------- 
# OMI Codes
# ---------------------------------------------------------------------------- 
print("OMI")
cmnd = "cp "+base_dir+"OMI/*.py "+dest_dir
print(cmnd)
os.system(cmnd)
cmnd = "cp "+base_dir+"OMI/*.pro "+dest_dir
print(cmnd)
os.system(cmnd)
cmnd = "cp "+base_dir+"OMI/*.idl "+dest_dir
print(cmnd)
os.system(cmnd)
cmnd = "cp "+base_dir+"OMI/run_Average_AerosolIndexCalculator "+dest_dir
print(cmnd)
os.system(cmnd)
# ---------------------------------------------------------------------------- 
# Siphon/Metpy Codes
# ---------------------------------------------------------------------------- 
print("Siphon/Metpy")
smcodes = '/home/bsorenson/Programs/Python/auto_weather_codes/'
cmnd = "cp "+smcodes+"*.py "+dest_dir
print(cmnd)
os.system(cmnd)