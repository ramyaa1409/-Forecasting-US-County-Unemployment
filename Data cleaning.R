library(readxl)
library(readxl)
Project_256_Pre_prossesed_Dataset <- read_excel("Project Final/Process.xlsx")

# Perform data cleaning (remove NA values and empty rows)
cleaned_data <- na.omit(Project_256_Pre_prossesed_Dataset)
cleaned_data <- cleaned_data[complete.cases(cleaned_data), ]

# Print a summary of the cleaned data
cat("Summary of Cleaned Data:\n")
print(summary(cleaned_data))

# Optionally, you can display the cleaned data
# print(head(cleaned_data))

# Specify the output file path
output_file_path <- "Project 256 Final Processed Dataset.xlsx"

# Write the cleaned data to a new Excel file
write.xlsx(cleaned_data, file = output_file_path, colNames = TRUE)

# Print a message indicating that the file has been created
cat("The cleaned data has been saved to", output_file_path, "\n")

