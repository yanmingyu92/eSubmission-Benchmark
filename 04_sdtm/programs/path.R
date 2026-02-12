# Program: path.R
# Purpose: Define paths for SDTM creation programs
# Author: eSubmission Benchmark
# Date: 2024

# ==============================================================================
# Path Configuration
# ==============================================================================

# Define base paths
path <- list()

# Raw data location
path$raw <- "../esub-benchmark-repos/pharmaverseraw/data"

# SDTM output location
path$sdtm <- "../esub-benchmark/04_sdtm/datasets"

# ADaM output location (for reference)
path$adam <- "../esub-benchmark/05_adam/datasets"

# Reference data (CDISC pilot)
path$reference <- "../esub-benchmark-repos/sdtm-adam-pilot-project/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm"

# Output location for programs
path$output <- "../esub-benchmark/04_sdtm/output"

# Validation output
path$validation <- "../esub-benchmark/08_validation"

# ==============================================================================
# Create directories if they don't exist
# ==============================================================================

for (p in path) {
  if (!dir.exists(p)) {
    dir.create(p, recursive = TRUE, showWarnings = FALSE)
  }
}

# ==============================================================================
# Print paths for verification
# ==============================================================================

message("Paths configured:")
for (name in names(path)) {
  message(sprintf("  %s: %s", name, path[[name]]))
}
