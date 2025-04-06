# Load the required library
library(openxlsx)
library(caret)

# Replace 'D:/Project 256/Project Final/Project 256 Final Processed Dataset.xlsx' with the correct file path
input_file_path <- "D:/Project 256/Project Final/Project 256 Final Processed Dataset.xlsx"

# Read the entire dataset
full_data <- read.xlsx(input_file_path)
# Calculate the average of each variable
variable_means <- colMeans(full_data, na.rm = TRUE)

# Display the results
print(variable_means)

# Set seed for reproducibility
set.seed(123)

# Randomly sample 1000 data points
sampled_index <- sample(1:nrow(full_data), size = 1000)
sampled_data <- full_data[sampled_index, ]
remaining_data <- full_data[-sampled_index, ]

# Split the sampled data into training (80%) and testing (20%) sets
train_index <- createDataPartition(sampled_data$Unemployed_2022, p = 0.8, list = FALSE)
train_data <- sampled_data[train_index, ]
test_data <- sampled_data[-train_index, ]
# Define model 1
model1 <- lm(Unemployed_2022 ~ Estimate_of_people_age_0_17_in_poverty_2021 + Labour_force_that_are_in_poverty + 
               Bachelor_degree_or_higher + GDP_2021 + Civilian_labor_force_2021 + Population_Estimate +
               Population_change_in_2021 + Number_of_people_born_in_2021 + Number_of_people_died_in_2021 +
               Net_international_migration + Net_domestic_migration + Residual + Estimate_of_female +
               Estimate_of_male + Estimate_Agriculture + estimate_Finance + Estimate_of_Information +
               Estimate_of_Manufacturing + Median_family_income + Taxes + Rent + Food + Health_care +
               Violent_Crime_Rate + Smokers + Teen_Birth_Rate, data = train_data)

# Define model 2
model2 <- lm(Unemployed_2022 ~ GDP_2021 + Net_domestic_migration + Estimate_Agriculture + 
               Median_family_income + Taxes + Rent + Food + Health_care + Violent_Crime_Rate, data = train_data)

# Define model 3
model3 <- lm(Unemployed_2022 ~ Bachelor_degree_or_higher + GDP_2021, data = train_data)

# Define model 4
model4 <- lm(Unemployed_2022 ~ Population_change_in_2021 + GDP_2021 + Net_domestic_migration + 
               Estimate_Agriculture + Median_family_income + Taxes + Rent + Food + Health_care + 
               Violent_Crime_Rate, data = train_data)

# Define model 5
model5 <- lm(Unemployed_2022 ~ Less_than_a_high_school_diploma + Some_college_or_associate_degree +
               Estimate_of_female + Estimate_of_male + Teen_Birth_Rate + Smokers, data = train_data)

# List of models
model_list <- list(model1, model2, model3, model4, model5)

# Initialize a dataframe to store results
results_df <- data.frame(Model = character(), R2 = numeric(), Accuracy = numeric(), RMSE = numeric(), Percentage_within_tolerance = numeric(), stringsAsFactors = FALSE)

# Loop through each model
for (i in 1:length(model_list)) {
  model <- model_list[[i]]
  
  # Make predictions on the test set
  predictions <- predict(model, newdata = test_data)
  
  # Calculate R-squared
  r_squared <- summary(model)$r.squared
  
  # Calculate the percentage of predictions within the tolerance
  tolerance <- 1000  # You can adjust this value
  within_tolerance <- sum(abs(predictions - test_data$Unemployed_2022) <= tolerance)
  percentage_within_tolerance <- within_tolerance / nrow(test_data) * 100
  
  # Calculate RMSE
  rmse <- sqrt(mean((predictions - test_data$Unemployed_2022)^2))
  
  # Append results to the dataframe
  results_df <- rbind(results_df, data.frame(Model = paste("Model", i), R2 = r_squared,Accuracy = accuracy, RMSE = rmse, Accuracy  = percentage_within_tolerance))
}

# Print results
print(results_df)



# ... (previous code)

# Specify the control parameters for cross-validation
ctrl <- trainControl(method = "cv", number = 10)  # 10-fold cross-validation

# Initialize a dataframe to store cross-validation results
cv_results_df <- data.frame(Model = character(), R2 = numeric(), RMSE = numeric(), Accuracy = numeric(), stringsAsFactors = FALSE)

# Loop through each model
for (i in 1:length(model_list)) {
  model <- model_list[[i]]
  
  # Use the train function for cross-validation
  cv_results <- train(
    Unemployed_2022 ~ .,  # Use all predictors in the model
    data = train_data,
    method = "lm",  # Linear regression method
    trControl = ctrl
  )
  
  # Extract cross-validation results
  r_squared_cv <- max(cv_results$resample$Rsquared)  # Maximum R-squared across folds
  rmse_cv <- min(cv_results$resample$RMSE)  # Minimum RMSE across folds
  accuracy_cv <- max(cv_results$resample$Accuracy)  # Maximum Accuracy across folds
  
  # Append results to the dataframe
  cv_results_df <- rbind(cv_results_df, data.frame(Model = paste("Model", i), R2 = r_squared_cv, RMSE = rmse_cv, Accuracy = accuracy_cv))
}

# Print cross-validation results
print(cv_results_df)

# Check for missing values
print("Missing Values:")
print(colSums(is.na(train_data)))

# Check data types
print("Data Types:")
print(sapply(train_data, class))

# Check for constant variables
print("Constant Variables:")
print(sapply(train_data, function(x) length(unique(x))))

# Summary statistics
summary(train_data)

