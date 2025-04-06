# Install and load required packages

library(openxlsx)

# Replace these paths with your actual file paths
input_file_path <- "D:/Project 256/ONE.xlsx"
output_file_path <- "D:/Project 256/New folder/Process.xlsx"

# Read all sheets from the Excel file into a list
all_sheets <- getSheetNames(input_file_path)

# Initialize an empty data frame to store the combined data
combined_data <- NULL

# Loop through each sheet and combine the data
for (sheet_name in all_sheets) {
  # Read the current sheet
  current_sheet <- read.xlsx(input_file_path, sheet = sheet_name)
  
  # Print column names for debugging
  print(paste("Columns in", sheet_name, ":", toString(colnames(current_sheet))))
  
  # Check if "Code" column is present
  if (!("Code" %in% colnames(current_sheet))) {
    stop(paste("Error: 'Code' column not found in sheet", sheet_name))
  }
  
  # Perform left join based on "Code"
  if (is.null(combined_data)) {
    # If combined_data is empty, directly assign the data from the first sheet
    combined_data <- current_sheet
  } else {
    # Otherwise, perform the left join
    combined_data <- left_join(combined_data, current_sheet, by = "Code", suffix = c("", paste0("_", sheet_name)))
  }
}

# Export the combined data to a new Excel file
write.xlsx(combined_data, output_file_path)
