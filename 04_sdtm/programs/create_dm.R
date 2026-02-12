# Program: create_dm.R
# Purpose: Create SDTM DM (Demographics) domain from raw data
# Author: eSubmission Benchmark
# Date: 2024

# ==============================================================================
# Setup
# ==============================================================================

# Load required packages
library(admiral)
library(admiraldev)
library(haven)
library(dplyr)
library(tidyr)
library(lubridate)
library(xportr)

# Source path configuration
source("path.R")

# ==============================================================================
# Read Raw Data
# ==============================================================================

message("Reading raw data...")

# Read raw demographics data
dm_raw <- haven::read_rds(file.path(path$raw, "dm_raw.rda"))

# ==============================================================================
# SDTM Variable Mapping
# ==============================================================================

message("Mapping SDTM variables...")

dm <- dm_raw %>%
  # Study identifier
  mutate(
    STUDYID = "CDISCPILOT01",
    DOMAIN = "DM"
  ) %>%

  # Subject identifiers
  mutate(
    SUBJID = as.character(PATNUM),
    USUBJID = paste(STUDYID, SITEID, SUBJID, sep = "-")
  ) %>%

  # Site identifier (extract from PATNUM or derive)
  mutate(
    SITEID = substr(as.character(PATNUM), 1, 3)
  ) %>%

  # Demographics
  mutate(
    BRTHDTC = NA_character_,  # Birth date typically not collected
    AGE = as.integer(IT.AGE),
    AGEU = "YEARS",
    SEX = IT.SEX,
    RACE = IT.RACE,
    ETHNIC = IT.ETHNIC,
    COUNTRY = COUNTRY %||% "USA"
  ) %>%

  # Treatment variables
  mutate(
    ARM = case_when(
      PLANNED_ARM == 0 ~ "Placebo",
      PLANNED_ARM == 54 ~ "Xanomeline Low Dose",
      PLANNED_ARM == 81 ~ "Xanomeline High Dose",
      TRUE ~ "Screen Failure"
    ),
    ARMCD = as.character(PLANNED_ARM),
    ACTARM = ARM,
    ACTARMCD = ARMCD
  ) %>%

  # Date variables
  mutate(
    RFSTDTC = NA_character_,
    RFENDTC = NA_character_,
    RFXSTDTC = NA_character_,
    RFXENDTC = NA_character_,
    RICDTC = format(IC_DT, "%Y-%m-%d"),
    DMDTC = format(COL_DT, "%Y-%m-%d")
  ) %>%

  # Additional variables
  mutate(
    INVID = NA_character_,
    INVNAM = NA_character_,
    DMDY = NA_integer_
  )

# ==============================================================================
# Add Sequence Number
# ==============================================================================

dm <- dm %>%
  derive_var_obs_number(
    by_vars = exprs(STUDYID, USUBJID),
    order = exprs(USUBJID),
    check_type = "none"
  ) %>%
  rename(DMSEQ = AO) %>%
  mutate(DMSEQ = 1L)  # DM has one record per subject

# ==============================================================================
# Set Variable Order and Labels
# ==============================================================================

# Define variable order per SDTM DM specification
dm <- dm %>%
  select(
    STUDYID, DOMAIN, USUBJID, SUBJID, RFSTDTC, RFENDTC,
    RFXSTDTC, RFXENDTC, RICDTC, RFXDTC, SITEID, INVID, INVNAM,
    BRTHDTC, AGE, AGEU, SEX, RACE, ETHNIC, ARMCD, ARM, ACTARMCD,
    ACTARM, COUNTRY, DMDTC, DMDY, DMSEQ
  )

# ==============================================================================
# Apply CDISC Metadata
# ==============================================================================

message("Applying CDISC metadata...")

# Apply variable labels
dm <- dm %>%
  xportr_df_label(
    label = "Demographics"
  ) %>%
  xportr_variable_name_check()

# ==============================================================================
# Export
# ==============================================================================

message("Exporting dm.xpt...")

# Export to XPT format
xportr_write(
  dm,
  file = file.path(path$sdtm, "dm.xpt"),
  label = "Demographics"
)

message(paste("Created dm.xpt with", nrow(dm), "records"))

# ==============================================================================
# QC Check
# ==============================================================================

cat("\n=== DM Domain Summary ===\n")
cat(sprintf("Number of subjects: %d\n", nrow(dm)))
cat(sprintf("Unique USUBJIDs: %d\n", n_distinct(dm$USUBJID)))
cat("\nTreatment distribution:\n")
print(table(dm$ARM, useNA = "ifany"))

# Check for required variables
required_vars <- c("STUDYID", "DOMAIN", "USUBJID", "SUBJID", "SITEID",
                   "AGE", "SEX", "ARMCD", "ARM", "DMSEQ")
missing_vars <- setdiff(required_vars, names(dm))
if (length(missing_vars) > 0) {
  warning(paste("Missing required variables:", paste(missing_vars, collapse = ", ")))
}

message("\ndm.xpt created successfully!")
