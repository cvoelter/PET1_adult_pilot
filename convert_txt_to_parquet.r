
library(arrow)
# Set the directory path
dir_path <- "C:/Users/Christoph Voelter/MPIcloud/Eyetracking/Eyelink/DataViewerProjects/PET1_dataviewer/Output"

# List all RESULTS_FILE.txt files in subdirectories
file_list <- list.files(path = dir_path, pattern = "PET1_adultpilot_sampleReport_", recursive = TRUE, full.names = TRUE)

sample.data <- file_list %>%
  lapply(function(file) {
    df <- read.table(file,
                     header = TRUE,
                     na.strings = ".",
                     sep = "\t",
                     fill = TRUE)
    df <- df %>%
      mutate(
        RECORDING_SESSION_LABEL = as.character(RECORDING_SESSION_LABEL),
        Session_Name_ = as.character(Session_Name_)
      )
    df
  }) %>%
  bind_rows()


# sample.data <- read.table("C:/Users/christoph_voelter/MPI_Nextcloud/Eyetracking/Eyelink/DataViewerProjects/fluidreasoning1/Output/fluidreasoning_samplereport.txt", header = TRUE, na.strings = ".", sep = "\t", fill = TRUE)

library(arrow)
write_parquet(sample.data, "data/fluidreasoning1.parquet")

############### save as separate files

library(arrow)
library(dplyr)

# Set the directory path
dir_path <- "C:/Users/Christoph Voelter/MPIcloud/Eyetracking/Eyelink/DataViewerProjects/PET1_dataviewer/Output"

# List all RESULTS_FILE.txt files in subdirectories
file_list <- list.files(path = dir_path, pattern = "PET1_adultpilot_sampleReport_", recursive = TRUE, full.names = TRUE)

# Loop through each file and save as a separate parquet file
lapply(file_list, function(file) {
  df <- read.table(file,
                   header = TRUE,
                   na.strings = ".",
                   sep = "\t",
                   fill = TRUE)
  
  df <- df %>%
    mutate(
      RECORDING_SESSION_LABEL = as.character(RECORDING_SESSION_LABEL),
      Session_Name_ = as.character(Session_Name_)
    )
  
  # Extract the file name without extension to use in the parquet file
  file_name <- tools::file_path_sans_ext(basename(file))
  
  # Write each dataframe to a separate parquet file
  parquet_path <- paste0("data/", file_name, ".parquet")
  write_parquet(df, parquet_path)
})
