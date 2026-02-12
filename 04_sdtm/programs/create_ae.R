# Program: create_ae.R
# Purpose: Create SDTM AE (Adverse Events) domain from raw data
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
library(stringr)
library(xportr)

source("path.R")

# ==============================================================================
# Read Raw Data
# ==============================================================================

message("Reading raw data...")

ae_raw <- haven::read_rds(file.path(path$raw, "ae_raw.rda"))
dm <- haven::read_xpt(file.path(path$sdtm, "dm.xpt"))

# ==============================================================================
# SDTM Variable Mapping
# ==============================================================================

message("Mapping SDTM variables...")

ae <- ae_raw %>%
  # Study and domain identifiers
  mutate(
    STUDYID = "CDISCPILOT01",
    DOMAIN = "AE"
  ) %>%

  # Subject identifiers
  mutate(
    SUBJID = as.character(PATNUM),
    SITEID = substr(as.character(PATNUM), 1, 3),
    USUBJID = paste(STUDYID, SITEID, SUBJID, sep = "-")
  ) %>%

  # Adverse event details
  mutate(
    AESEQ = NA_integer_,  # Will be derived later
    AESPID = NA_character_,  # Sponsor ID

    # Event terms
    AETERM = IT.AETERM,
    AELLT = AELLT,
    AELLTCD = as.character(AELLTCD),
    AEDECOD = AEDECOD,
    AEPTCD = as.character(AEPTCD),
    AEHLT = AEHLT,
    AEHLTCD = as.character(AEHLTCD),
    AEHLGT = AEHLGT,
    AEHLGTCD = as.character(AEHLGTCD),
    AEBODSYS = AEBODSYS,
    AEBDSYCD = as.character(AEBDSYCD),
    AESOC = AESOC,
    AESOCCD = as.character(AESOCCD),

    # Severity and seriousness
    AESEV = IT.AESEV,
    AESER = IT.AESER,

    # Causality
    AEREL = IT.AEREL,

    # Action taken
    AEACN = IT.AEACN,
    AEACNOTH = NA_character_,

    # Outcome
    AEOUT = AEOUTCOME,

    # Seriousness criteria
    AESCAN = AESCAN,
    AESCNO = AESCNO,
    AESDTH = IT.AESDTH,
    AESHOSP = IT.AESHOSP,
    AESLIFE = IT.AESLIFE,
    AESOD = AESOD,
    AEDIS = AEDIS,

    # Dates
    AESTDTC = convert_dtc_to_dtc(IT.AESTDAT),
    AEENDTC = convert_dtc_to_dtc(IT.AEENDAT),
    AEDTC = NA_character_
  )

# ==============================================================================
# Derive Sequence Number
# ==============================================================================

ae <- ae %>%
  derive_var_obs_number(
    by_vars = exprs(USUBJID),
    order = exprs(AESTDTC, AETERM),
    check_type = "none"
  ) %>%
  rename(AESEQ = AO)

# ==============================================================================
# Derive Study Day Variables
# ==============================================================================

# Get reference dates from DM
dm_ref <- dm %>%
  select(USUBJID, RFSTDTC)

ae <- ae %>%
  left_join(dm_ref, by = "USUBJID") %>%
  derive_vars_dy(
    reference_date = RFSTDTC,
    source_vars = exprs(AESTDTC, AEENDTC)
  ) %>%
  rename(AESTDY = AESTDTC_DY, AEENDY = AEENDTC_DY) %>%
  select(-RFSTDTC)

# ==============================================================================
# Set Variable Order
# ==============================================================================

ae_sdtm_vars <- c(
  "STUDYID", "DOMAIN", "USUBJID", "AESEQ", "AESPID",
  "AETERM", "AELLT", "AELLTCD", "AEDECOD", "AEPTCD",
  "AEHLT", "AEHLTCD", "AEHLGT", "AEHLGTCD",
  "AEBODSYS", "AEBDSYCD", "AESOC", "AESOCCD",
  "AESEV", "AESER", "AEACN", "AEACNOTH", "AEREL",
  "AEOUT", "AESTDTC", "AESTDY", "AEENDTC", "AEENDY",
  "AEDTC", "AESCAN", "AESCNO", "AESDTH", "AESHOSP",
  "AESLIFE", "AESOD", "AEDIS"
)

ae <- ae %>%
  select(any_of(ae_sdtm_vars))

# ==============================================================================
# Export
# ==============================================================================

message("Exporting ae.xpt...")

xportr_write(
  ae,
  file = file.path(path$sdtm, "ae.xpt"),
  label = "Adverse Events"
)

message(paste("Created ae.xpt with", nrow(ae), "records"))

# ==============================================================================
# QC Summary
# ==============================================================================

cat("\n=== AE Domain Summary ===\n")
cat(sprintf("Total records: %d\n", nrow(ae)))
cat(sprintf("Unique subjects with AEs: %d\n", n_distinct(ae$USUBJID)))
cat("\nAE by Severity:\n")
print(table(ae$AESEV, useNA = "ifany"))
cat("\nSerious AEs:\n")
print(table(ae$AESER, useNA = "ifany"))

# Helper function for date conversion
convert_dtc_to_dtc <- function(dt) {
  if (is.null(dt) || all(is.na(dt))) return(rep(NA_character_, length(dt)))
  dt <- as.character(dt)
  dt <- str_replace(dt, " ", "T")  # Add time separator if needed
  return(dt)
}

message("\nae.xpt created successfully!")
