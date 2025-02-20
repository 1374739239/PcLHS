# Load required libraries
library(raster)
library(dplyr)
library(clhs)
library(readxl)
library(data.table)  # For efficient data writing

# Define input file and output directory (replace with your actual paths)
input_file <- "path/to/your/input_data.xlsx"  # Replace with your input file path
output_dir <- "path/to/your/output_directory"  # Replace with your output directory

# Read the input data
data <- read_excel(input_file)
ori_data <- as.data.frame(data)

# Set the sample size
sizes <- your sample size

# Create the output directory if it does not exist
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

# Set a fixed seed for reproducibility
seed <- 100  # Fixed seed value
set.seed(seed)

# Run the clhs algorithm
clhs_result <- clhs(ori_data, size = sizes, must.include = NULL,
                    cost = NULL, progress = FALSE, use.cpp = TRUE,
                    iter = 20000, simple = FALSE)

# Extract the indices of the selected samples
index <- clhs_result$index_samples

# Subset the original data using the selected indices
result <- data[index, ]

# Save the result to a CSV file
output_file <- file.path(output_dir, paste0("clhs_result_seed_", seed, ".csv"))
fwrite(result, file = output_file)

# Print completion message
cat("Processing completed! Results saved to:", output_file, "\n")