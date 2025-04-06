library(readxl)
library(openxlsx)
processed_data <- read_excel("Project 256 Final Processed Dataset.xlsx")
set.seed(123)
sampled_data <- processed_data[sample(nrow(processed_data), 1000), ]
cat("Summary of Sampled Data:\n")
print(summary(sampled_data))
output_sampled_file_path <- "Project 256 Final Sampled Dataset.xlsx"
# Write the sampled data to a new Excel file
write.xlsx(sampled_data, file = output_sampled_file_path, colNames = TRUE)

# Print a message indicating that the file has been created
cat("The sampled data has been saved to", output_sampled_file_path, "\n")