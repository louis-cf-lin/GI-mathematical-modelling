# GI-mathematical-modelling

> Author: Louis Lin \
> Department of Engineering Science \
> University of Auckland \
> Date created: November 1, 2020 \
> Last modified: 3 November 3, 2020

This folder contains all the scripts, code, and data used for **Project 37: Understanding the Spatiotemporal Activity at the Microscale**. Please read this file before proceeding with any work.

<hr>

### Table of Folders

- [`batch_scripts`](#batch_scripts)
- [`corrias_buist`](#corrias_buist)
- [`images`](#images)
- [`MATLAB_scripts`](#matlab_scripts)
- [`MEA_simulation`](#mea_simulation)
- [`raw_data`](#raw_data)
- [`raw_figures`](#raw_figures)
- [`screenshots`](#screenshots)

<hr>

### `root`
Main root folder containing all subfolders and files for this project.

**`log.md`**\
Day-to-day operations log.

**`README.md`**\
This file.

<hr>

### `avi`
Folder containing rendered heat map simulations of slow wave activity, as outputted by `animate_heatmap.m`.

**`smooth-bloom.avi`**\
Example of animation.

<hr>

### `batch_scripts`

Folder containing batch scripts and command files for automating ssh connection and transferring files.

**`login.bat`**\
Command file for logging into HPC cluster. Calls `server_command.txt` to run commands on remote server.

**`run_cm.txt`**\
Runs CMISS on remote server.

**`run_cm_matlab.txt`**\
Runs CMISS then MATLAB on remote server.

**`server_command.txt`**\
Navigates to main directory on remote server.

**`sync.bat`**\
Transfers `example_2d.com` and `2d_slice.ipcell` to remote server, calls `run_cm.txt` to run CMISS, then transfers `stomach.iphist` back to local machine.

<hr>

### `corrias_buist`
[Deprecated] Folder containing cell model adapted from Corrias, Buist, 2007. 

<hr>

### `images`

Folder containing screenshots and images during the progression of the project.

<hr>

### `MATLAB_scripts`
Folder containing MATLAB scripts for exploration, calibration, and rendering.

**`animate_heatmap.m`**\
Reads in `stomach.iphist` and creates animated rendering of simulated slow wave activity.

**`animate_raw_signal.m`**\
Reads in raw data from `.mat` files and creates animated rendering of electrical signals.

**`calibrate_model.m`**\
Calibrates the cell model.

**`current_conductance.m`**
Perturbation analysis of current conductance ions on cell model.

**`explore_model.m`**
Exploration of the cell model.

**`mea_config.mat`**
Contains arrangement of simulated data in MEA.

**`pulse_characs.m`**
Investigate activity of baseline cell model.

<hr>

### `MEA_simulation`
Folder containing tissue model parameter and simulation files. The code in this folder was provided by Dr. Peng Du of the Auckland Bioengineering Institute, NZ. Files not explicitly mentioned in this document were not modified for this project.

**mfiles**\
Subfolder containing `.ipmatc` files. Also contains `generate_list.m` which programmatically writes  `.ipmatc` files.

**`2d_slice.ipcell`**\
File that determines which parameters are modified.

**`example_2d.com`**\
Master ommand file to run simulations in CMISS.

<hr>

### `raw_data`
Folder containing raw data in `.mat` files (courtesy of Dr. Peng Du).

**`data_summary.xlsx`**\
Statistical summary of raw data.

<hr>

### `raw_figures`
Folder containing figures generated for the final report of this project.

<hr>

### `screenshots`
Folder containing screenshots of outputs for reference.