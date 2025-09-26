# PET1_adult_pilot

Data, scripts, and analyses for the **Primate Eye-tracking Network Study 1 (Adult Pilot / Chimp Ngamba data)**.  

* **Human pilot data** collected with an **EyeLink 1000plus** eye tracker  
* **Chimpanzee data** collected with a **Tobii** eye tracker  

## Structure
---

.
├── .gitignore
├── .Rhistory
├── convert_txt_to_parquet.r         # Script for converting txt to parquet format
├── calculating_luminance_data.r     # Script determining the luminance values of the stimuli
├── convert_txt_to_parquet.r         # Convert raw EyeLink/Tobii txt files to Parquet
├── data                             # Directory containing the data files (not the original chimp data, file too large)
├── graphs                           # Directory for storing generated graphs (preprocessing and analysis)
├── PET1_adult_pilot.Rproj           # R project file
├── PET1_adult_pilot_aoi_analysis.Rmd # AOI analysis report
├── PET1_adult_pilot_counterbalancing.Rmd # Script for counterbalancing of stimuli
├── PET1_adult_pilot_pupil_size_continuity1_analysis.Rmd # Pupil size continuity-version1 analysis 
├── PET1_adult_pilot_pupil_size_continuity2_analysis.Rmd # Pupil size continuity-version2 analysis
├── PET1_adult_pilot_pupil_size_gravity1_analysis.Rmd # Gravity-version1 analysis
├── PET1_adult_pilot_pupil_size_gravity2_analysis.Rmd # Gravity-version2 analysis
├── PET1_adult_pilot_pupil_size_preprocessing.Rmd # Data preprocessing for pupil size
├── PET1_adult_pilot_pupil_size_solidity1_analysis.Rmd # Solidity-version1 analysis 
├── PET1_adult_pilot_pupil_size_solidity2_analysis.Rmd # Solidity-version2 analysis
├── tobii_data_exploration.Rmd        # Preprocessing for the chimp data
├── saves                             # Directory for saving outputs
└── screenshots                       #Directory for storing screenshots
```

## Description of main data files
* InterestAreas subfolder: coordinates of interest areas
* PET1_adultpilot_sampleReport* parquet files: individual sample reports exported via Eyelink Dataviewer
* PET1_adult_pilot_basecorrected_downsampled.parquet: preprocessed and downsampled pupil size data (human pilot)
* PET1_adultpilot_AoIReport.txt: Interest area report for all experiments and different interest periods exported from Eyelink DataViewer.
* PET1_adult_pilot_demo_data.csv: demographic data of participants
* PET1_adult_pilot_demo_data.xlsx: demographic data of participants
* PET_adult_pilot_counterbalancing.csv: counterbalancing of stimuli across participants
* PET_adult_pilot_video_list.csv: information about video stimuli (duration etc)
* PET_adult_pilot_video_list.xlsx: information about video stimuli (duration etc)
* PET1_chimp_Ngamba_basecorrected_downsampled.parquet preprocessed and downsampled pupil size data (Ngamba chimps)

## Structure of PET1_adult_pilot_basecorrected_downsampled.parquet

| Column Name                    | Description                                                        |
|--------------------------------|--------------------------------------------------------------------|
| RECORDING_SESSION_LABEL        | Unique identifier for each recording session.                      |
| childlab_ID                    | Identifier for each  participant.                                  |
| trial                          | The trial number within the experiment.                            |
| video_file                     | The name of the video file viewed during the trial.                |
| experiment                     | The name of the experiment.                                        |
| condition                      | Specific experimental condition (e.g., control, test).             |
| version                        | Version identifier for the experiment.                             |
| bin_low                        | The lower time bin (in milliseconds) for gaze data.                |
| LEFT.pupil.base.corrected      | Baseline corrected pupil size for the left eye.                    |
| RIGHT.pupil.base.corrected     | Baseline corrected pupil size for the right eye.                   |
| Xgaze_LEFT                     | Horizontal gaze position of the left eye in pixels (median in the time bin).                |
| Ygaze_LEFT                     | Vertical gaze position of the left eye in pixels (median in the time bin).                  |
| Xgaze_RIGHT                    | Horizontal gaze position of the right eye in pixels (median in the time bin).               |
| Ygaze_RIGHT                    | Vertical gaze position of the right eye in pixels (median in the time bin).                 |
| speed_left_pupil               | Speed of left pupil movement.                                      |
| speed_right_pupil              | Speed of right pupil movement.                                     |
| MAD_left_pupil                 | Median absolute deviation (MAD) of left pupil size.                |
| MAD_right_pupil                | Median absolute deviation (MAD) of right pupil size.               |
| LEFT_pupil.ds.noArtefact       | Downsampled (10 Hz) left pupil size without artifacts.             |
| RIGHT_pupil.ds.noArtefact      | Downsampled (10Hz) right pupil size without artifacts.             |
| LEFT_pupil.ds.inter            | Interpolated (downsampled and artefact corrected) left pupil size. |
| RIGHT_pupil.ds.inter           | Interpolated  (downsampled and artefact corrected)right pupil size.|
| subject                        | Subject identifier (e.g., "subj.34").                              |
| test_date                      | Date of the test (e.g., "09.09.2024").                             |
| birth_date                     | Participant’s birth date (e.g., "10.08.2005").                     |
| gender                         | Participant’s gender (e.g., "f" for female).                       |
| average_validation_value_left  | Average validation value for the left eye.                         |
| average_validation_value_right | Average validation value for the right eye.                        |
| maximal_validation_value_left  | Maximum validation value for the left eye.                         |
| maximal_validation_value_right | Maximum validation value for the right eye.                        |
| eyewear                        | Information on whether the participant wore eyewear                |
| pupil_size_avg                 | Average pupil size across both eyes.                               |
| Xgaze                          | Average horizontal gaze position across both eyes in pixels.       |
| Ygaze                          | Average vertical gaze position across both eyes in pixels.         |


