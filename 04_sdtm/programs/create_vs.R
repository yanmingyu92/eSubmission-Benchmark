# Program: create_vs.R
# Purpose: Create SDTM VS (Vital Signs) domain from raw data
# Author: eSubmission Benchmark
# Date: 2024

# ==============================================================================
# Setup
# ==============================================================================

library(admiral)
library(admiraldev)
library(haven)
library(dplyr)
library(tidyr)
library(lubridate)
library(xportr)

source("path.R")

# ==============================================================================
# Read Raw Data
# ==============================================================================

message("Reading raw data...")

vs_raw <- haven::read_rds(file.path(path$raw, "vs_raw.rda"))
dm <- haven::read_xpt(file.path(path$sdtm, "dm.xpt"))

# ==============================================================================
# Define Vital Signs Parameters
# ==============================================================================

vs_param_lookup <- tibble::tribble(
  ~raw_test,     ~VSTESTCD, ~VSTEST,            ~VSORRESU, ~VSSTRESU,
  "HEIGHT",      "HEIGHT",  "Height",           "cm",      "cm",
  "WEIGHT",      "WEIGHT",  "Weight",           "kg",      "kg",
  "TEMP",        "TEMP",    "Temperature",      "C",       "C",
  "PULSE",       "PULSE",   "Pulse Rate",       "beats/min", "beats/min",
  "SYS_BP",      "SYSBP",   "Systolic Blood Pressure", "mmHg", "mmHg",
  "DIA_BP",      "DIABP",   "Diastolic Blood Pressure", "mmHg", "mmHg"
)

# ==============================================================================
# SDTM Variable Mapping
# ==============================================================================

message("Mapping SDTM variables...")

vs <- vs_raw %>%
  # Study and domain identifiers
  mutate(
    STUDYID = "CDISCPILOT01",
    DOMAIN = "VS"
  ) %>%

  # Subject identifiers
  mutate(
    SUBJID = as.character(PATNUM),
    SITEID = substr(as.character(PATNUM), 1, 3),
    USUBJID = paste(STUDYID, SITEID, SUBJID, sep = "-")
  )

# ==============================================================================
# Reshape to Long Format (Findings structure)
# ==============================================================================

# Gather vital signs measurements
vs_long <- vs %>%
  pivot_longer(
    cols = c(IT.HEIGHT_VSORRES, IT.WEIGHT, IT.TEMP, PULSE, SYS_BP, DIA_BP),
    names_to = "raw_test",
    values_to = "VSORRES",
    values_drop_na = TRUE
  ) %>%
  mutate(
    raw_test = case_when(
      raw_test == "IT.HEIGHT_VSORRES" ~ "HEIGHT",
      raw_test == "IT.WEIGHT" ~ "WEIGHT",
      raw_test == "IT.TEMP" ~ "TEMP",
      raw_test == "PULSE" ~ "PULSE",
      raw_test == "SYS_BP" ~ "SYS_BP",
      raw_test == "DIA_BP" ~ "DIA_BP",
      TRUE ~ raw_test
    )
  ) %>%
  left_join(vs_param_lookup, by = "raw_test")

# ==============================================================================
# Complete Variable Mapping
# ==============================================================================

vs_sdtm <- vs_long %>%
  mutate(
    # Visit information
    VISITNUM = NA_real_,
    VISIT = INSTANCE,
    VISITDY = NA_integer_,

    # Results
    VSORRES = as.character(VSORRES),
    VSSTRESC = VSORRES,
    VSSTRESN = as.numeric(VSORRES),

    # Location (for temperature, blood pressure)
    VSLOC = ifelse(VSTESTCD == "TEMP", IT.TEMP_LOC, NA_character_),
    VSLOC = ifelse(VSTESTCD %in% c("SYSBP", "DIABP"), "ARM", VSLOC),

    # Position
    VSPOS = ifelse(VSTESTCD %in% c("SYSBP", "DIABP", "PULSE"), "STANDING", NA_character_),

    # Date/Time
    VSDTC = format(VTLD, "%Y-%m-%d"),
    VSDY = NA_integer_,

    # Status
    VSSTAT = NA_character_,
    VSREASND = NA_character_,

    # Flags
    VSBLFL = NA_character_,
    VSDRVFL = NA_character_
  ) %>%

  # Filter invalid records
  filter(!is.na(VSORRES), VSORRES != "")

# ==============================================================================
# Derive Sequence Number
# ==============================================================================

vs_sdtm <- vs_sdtm %>%
  derive_var_obs_number(
    by_vars = exprs(USUBJID),
    order = exprs(VISITNUM, VSTESTCD),
    check_type = "none"
  ) %>%
  rename(VSSEQ = AO)

# ==============================================================================
# Derive Study Day
# ==============================================================================

dm_ref <- dm %>%
  select(USUBJID, RFSTDTC)

vs_sdtm <- vs_sdtm %>%
  left_join(dm_ref, by = "USUBJID") %>%
  derive_vars_dy(
    reference_date = RFSTDTC,
    source_vars = exprs(VSDTC)
  ) %>%
  rename(VSDY = VSDTC_DY) %>%
  select(-RFSTDTC)

# ==============================================================================
# Set Variable Order
# ==============================================================================

vs_sdtm_vars <- c(
  "STUDYID", "DOMAIN", "USUBJID", "VSSEQ", "VISITNUM", "VISIT",
  "VISITDY", "VSTESTCD", "VSTEST", "VSPOS", "VSORRES", "VSORRESU",
  "VSSTRESC", "VSSTRESN", "VSSTRESU", "VSLOC", "VSBLFL", "VSDRVFL",
  "VSSTAT", "VSREASND", "VSDTC", "VSDY"
)

vs_sdtm <- vs_sdtm %>%
  select(any_of(vs_sdtm_vars))

# ==============================================================================
# Export
# ==============================================================================

message("Exporting vs.xpt...")

xportr_write(
  vs_sdtm,
  file = file.path(path$sdtm, "vs.xpt"),
  label = "Vital Signs"
)

message(paste("Created vs.xpt with", nrow(vs_sdtm), "records"))

# ==============================================================================
# QC Summary
# ==============================================================================

cat("\n=== VS Domain Summary ===\n")
cat(sprintf("Total records: %d\n", nrow(vs_sdtm)))
cat(sprintf("Unique subjects: %d\n", n_distinct(vs_sdtm$USUBJID)))
cat("\nRecords by parameter:\n")
print(table(vs_sdtm$VSTESTCD, useNA = "ifany"))

message("\nvs.xpt created successfully!")
