import os
from pathlib import Path

import I2MC
import pandas as pd

import numpy as np
import matplotlib.pyplot as plt


# =============================================================================
# Import data from Tobii TX300
# =============================================================================

def tobii_TX300(fname, res=[1920,1080]):

    # Load all data
    raw_df = pd.read_csv(fname, delimiter=',')
    df = pd.DataFrame()
    
    # Extract required data
    df['time'] = raw_df['time_frame']
    df['L_X'] = raw_df['Gaze_point_left_X']
    df['L_Y'] = raw_df['Gaze_point_left_Y']
    df['R_X'] = raw_df['Gaze_point_right_X']
    df['R_Y'] = raw_df['Gaze_point_right_Y']
    
    # Check bounds and validity
    lMiss1 = (df['L_X'] < -res[0]) | (df['L_X']>2*res[0])
    lMiss2 = (df['L_Y'] < -res[1]) | (df['L_Y']>2*res[1])
    lMiss  = lMiss1 | lMiss2 | (raw_df['Validity_left'] != "Valid")
    df.loc[lMiss,'L_X'] = np.nan
    df.loc[lMiss,'L_Y'] = np.nan
    
    rMiss1 = (df['R_X'] < -res[0]) | (df['R_X']>2*res[0])
    rMiss2 = (df['R_Y'] < -res[1]) | (df['R_Y']>2*res[1])
    rMiss  = rMiss1 | rMiss2 | (raw_df['Validity_right'] != "Valid")
    df.loc[rMiss,'R_X'] = np.nan
    df.loc[rMiss,'R_Y'] = np.nan

    return df



#%% Preparation

# Settign the working directory
os.chdir(r'C:/Users/voelterc/Documents/_git/PET1_adult_pilot')

# Find the files
data_files = list(Path().glob('data/chimp_example_data.csv'))

# define the output folder
output_folder = Path('data') / 'i2mc_output'  # define folder path\name

# Create the folder (will do nothing if it already exists)
output_folder.mkdir(parents=True, exist_ok=True)


# =============================================================================
# NECESSARY VARIABLES

opt = {}
# General variables for eye-tracking data
opt['xres']         = 1920.0                # maximum value of horizontal resolution in pixels
opt['yres']         = 1080.0                # maximum value of vertical resolution in pixels
opt['missingx']     = np.nan                # missing value for horizontal position in eye-tracking data (example data uses -xres). used throughout the algorithm as signal for data loss
opt['missingy']     = np.nan                # missing value for vertical position in eye-tracking data (example data uses -yres). used throughout algorithm as signal for data loss
opt['freq']         = 300.0                 # sampling frequency of data (check that this value matches with values actually obtained from measurement!)

# Variables for the calculation of visual angle
# These values are used to calculate noise measures (RMS and BCEA) of
# fixations. The may be left as is, but don't use the noise measures then.
# If either or both are empty, the noise measures are provided in pixels
# instead of degrees.
opt['scrSz']        = [50.9174, 28.6411]    # screen size in cm
opt['disttoscreen'] = 65.0                  # distance to screen in cm.

# Options of example script
do_plot_data = True # if set to True, plot of fixation detection for each trial will be saved as png-file in output folder.
# the figures works best for short trials (up to around 20 seconds)

# =============================================================================
# OPTIONAL VARIABLES
# The settings below may be used to adopt the default settings of the
# algorithm. Do this only if you know what you're doing.

# # STEFFEN INTERPOLATION
opt['windowtimeInterp']     = 0.1                           # max duration (s) of missing values for interpolation to occur
opt['edgeSampInterp']       = 2                             # amount of data (number of samples) at edges needed for interpolation
opt['maxdisp']              = opt['xres']*0.2*np.sqrt(2)    # maximum displacement during missing for interpolation to be possible

# # K-MEANS CLUSTERING
opt['windowtime']           = 0.2                           # time window (s) over which to calculate 2-means clustering (choose value so that max. 1 saccade can occur)
opt['steptime']             = 0.02                          # time window shift (s) for each iteration. Use zero for sample by sample processing
opt['maxerrors']            = 100                           # maximum number of errors allowed in k-means clustering procedure before proceeding to next file
opt['downsamples']          = [2, 5, 10]
opt['downsampFilter']       = False                         # use chebychev filter when downsampling? Its what matlab's downsampling functions do, but could cause trouble (ringing) with the hard edges in eye-movement data

# # FIXATION DETERMINATION
opt['cutoffstd']            = 2.0                           # number of standard deviations above mean k-means weights will be used as fixation cutoff
opt['onoffsetThresh']       = 3.0                           # number of MAD away from median fixation duration. Will be used to walk forward at fixation starts and backward at fixation ends to refine their placement and stop algorithm from eating into saccades
opt['maxMergeDist']         = 30.0                          # maximum Euclidean distance in pixels between fixations for merging
opt['maxMergeTime']         = 30.0                          # maximum time in ms between fixations for merging
opt['minFixDur']            = 40.0                          # minimum fixation duration after merging, fixations with shorter duration are removed from output



#%% Run I2MC

for file_idx, file in enumerate(data_files):
    print('Processing file {} of {}'.format(file_idx + 1, len(data_files)))

    # Extract the name form the file path
    name = file.stem    
    
    # Create the folder for the specific subject
    subj_folder = output_folder / name
    subj_folder.mkdir(exist_ok=True)
       
    # Import data
    data = tobii_TX300(file, [opt['xres'], opt['yres']])

    # Run I2MC on the data
    fix,_,_ = I2MC.I2MC(data,opt)

    ## Create a plot of the result and save them
    if do_plot_data:
        # pre-allocate name for saving file
        save_plot = subj_folder / f"{name}.png"
        f = I2MC.plot.data_and_fixations(data, fix, fix_as_line=True, res=[opt['xres'], opt['yres']])
        # save figure and close
        f.savefig(save_plot)
        plt.close(f)

    # Write data to file after make it a dataframe
    fix['participant'] = name
    fix_df = pd.DataFrame(fix)
    save_file = subj_folder / f"{name}.csv"
    fix_df.to_csv(save_file)