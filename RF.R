# Load required libraries
library(randomForestSRC)
library(ggplot2)
library(readxl)
library(tidyverse)

# Set random seed for reproducibility
set.seed(123)

# Define the target variable and feature columns
target_variable <- "target"  # Replace with your target variable name
feature_columns <- "column indices of your features"     # Replace with the column indices of your features

# Define input and output paths (replace with your actual paths)
input_file <- "path/to/your/test_data.xlsx"  # Replace with your test data path
output_dir <- "path/to/your/output_directory"  # Replace with your output directory

# Create the output directory if it does not exist
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

# Read the test data
data_test <- read_excel(input_file, col_types = "numeric")
data_test <- data.frame(data_test)

# Prepare the test data (features only, excluding the target variable)
test_pred <- data_test[feature_columns]

# Read the training data (replace with your actual training data path)
training_file <- "path/to/your/training_data.csv"  # Replace with your training data path
data_train <- read.csv(training_file, header = TRUE)

# Prepare the training data (features and target variable)
data_train <- data_train[c(target_variable, colnames(data_train)[feature_columns])]

# Set seed for random forest model reproducibility
set.seed(1)

# Train the random forest model
rf_model <- rfsrc(as.formula(paste(target_variable, "~ .")), data = data_train, ntree = 500)

# Make predictions on the test set
predictions <- predict(rf_model, newdata = test_pred)
predicted_values <- as.numeric(predictions$predicted)

# Calculate model evaluation metrics
mse <- mean((data_test[[target_variable]] - predicted_values)^2)
rmse <- sqrt(mse)
sst <- sum((data_test[[target_variable]] - mean(data_test[[target_variable]]))^2)
sse <- sum((data_test[[target_variable]] - predicted_values)^2)
rsquared <- 1 - (sse / sst)
mae <- mean(abs(data_test[[target_variable]] - predicted_values))

# Calculate Lin's Concordance Correlation Coefficient (LCCC)
mean_X <- mean(data_test[[target_variable]])
mean_Y <- mean(predicted_values)
sd_X <- sd(data_test[[target_variable]])
sd_Y <- sd(predicted_values)
corr <- cor(data_test[[target_variable]], predicted_values)
LCCC <- (2 * corr * sd_X * sd_Y) / (sd_X^2 + sd_Y^2 + (mean_X - mean_Y)^2)

# Add predicted values to the test data
data_test$predicted_values <- predicted_values

# Save the test data with predictions to a CSV file
output_file <- file.path(output_dir, "predictions.csv")
write_csv(data_test, output_file)

# Print evaluation metrics
cat("Model Evaluation Metrics:\n")
cat("MSE:", mse, "\n")
cat("RMSE:", rmse, "\n")
cat("R-squared:", rsquared, "\n")
cat("MAE:", mae, "\n")
cat("LCCC:", LCCC, "\n")
cat("Predictions saved to:", output_file, "\n")