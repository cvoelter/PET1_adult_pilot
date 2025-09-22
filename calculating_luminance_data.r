library(tidyverse)


# Define the folder containing the .txt files
folder_path <- "C:/Users/voelterc/Nextcloud2/Eyetracking/Eyelink/ExperimenterProjects/PET1_adult_pilot_materials/PET_adult_pilot_stimuli/matched-videos_frame_by_frame_29-97fps"

# Get a list of all .txt files in the folder
file_list <- list.files(path = folder_path, pattern = "*.txt", full.names = TRUE)

# Function to process each file
process_file <- function(file) {
  df <- read_csv(file, col_types = cols()) %>%
    pivot_wider(names_from = Video, values_from = c(`Original Mean Luminance`, `Adjusted Mean Luminance`), names_sep = "_") %>%
    rename_with(~ gsub(" ", "_", .x), everything()) %>%  # Ensure column names are valid
    mutate(
      Difference_Original = .[[grep("Original_Mean_Luminance_", names(.))[1]]] - .[[grep("Original_Mean_Luminance_", names(.))[2]]],
      Difference_Adjusted = .[[grep("Adjusted_Mean_Luminance_", names(.))[1]]] - .[[grep("Adjusted_Mean_Luminance_", names(.))[2]]]
    ) %>%
    pivot_longer(cols = starts_with("Difference"), names_to = "Metric", values_to = "Value") %>%
    mutate(File = basename(file))
  return(df)
}

# Read and combine all files
data <- bind_rows(lapply(file_list, process_file))

# Aggregate per original file
aggregated_data <- data %>%
  group_by(File, Metric) %>%
  summarise(
    Mean = mean(Value, na.rm = TRUE),
    Median = median(Value, na.rm = TRUE),
    Min = min(Value, na.rm = TRUE),
    Max = max(Value, na.rm = TRUE),
    SD = sd(Value, na.rm = TRUE),
    .groups = "drop"
  )

# View the aggregated data
print(aggregated_data)

# Save the result
write_csv(aggregated_data, "aggregated_luminance_data.csv")
