# R Script: Create Missing Raw Data from SDTM
# This script demonstrates how to reverse-engineer raw data from SDTM datasets

# ==============================================================================
# Setup
# ==============================================================================

library(haven)
library(dplyr)
library(tidyr)
library(stringr)
library(lubridate)

# Define paths
sdtm_path <- "../esub-benchmark-repos/sdtm-adam-pilot-project/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm"
output_path <- "."

# ==============================================================================
# Helper Functions
# ==============================================================================

#' Add EDC-style metadata to raw data
#' @param data Dataset to enhance
#' @param folder_name EDC folder name
#' @return Enhanced dataset
add_edc_metadata <- function(data, folder_name) {
  data %>%
    mutate(
      FOLDER = folder_name,
      FOLDERL = toupper(folder_name),
      INSTANCE = folder_name,
      COL_DT = Sys.Date()
    )
}

#' Convert SDTM date to raw date format
#' @param dtc SDTM date character (--DTC format)
#' @return Date in raw format
convert_date <- function(dtc) {
  if (is.na(dtc) || dtc == "") return(NA_character_)
  # Handle partial dates
  dtc <- str_replace(dtc, "T.*", "")  # Remove time component
  return(dtc)
}

#' Add IT. prefix to item variables
#' @param data Dataset
#' @param vars Variables to rename
#' @return Dataset with renamed variables
add_it_prefix <- function(data, vars) {
  for (var in vars) {
    if (var %in% names(data)) {
      new_name <- paste0("IT.", var)
      data <- data %>% rename(!!new_name := !!var)
    }
  }
  return(data)
}

# ==============================================================================
# Create lb_raw from LB
# ==============================================================================

create_lb_raw <- function() {
  message("Creating lb_raw from SDTM LB domain...")

  lb <- read_xpt(file.path(sdtm_path, "lb.xpt"))

  lb_raw <- lb %>%
    # Select and rename variables
    transmute(
      STUDY = STUDYID,
      PATNUM = as.character(SUBJID),
      VISITNAME = VISIT,
      FOLDER = "LABORATORY",
      FOLDERL = "LABORATORY",
      INSTANCE = VISIT,
      `IT.LBTEST` = LBTEST,
      `IT.LBTESTCD` = LBTESTCD,
      `IT.LBCAT` = LBCAT,
      `IT.LBORRES` = LBORRES,
      `IT.LBORRESU` = LBORRESU,
      `IT.LBSTRESC` = LBSTRESC,
      `IT.LBSTRESN` = LBSTRESN,
      `IT.LBSTRESU` = LBSTRESU,
      `IT.LBNRIND` = LBNRIND,
      DTCOL = convert_date(LBDTC)
    ) %>%
    # Add some realistic data quality artifacts
    mutate(
      # Occasionally missing results (simulating pending results)
      `IT.LBORRES` = ifelse(runif(n()) < 0.02, NA_character_, `IT.LBORRES`)
    )

  # Save as RDA
  save(lb_raw, file = file.path(output_path, "lb_raw.rda"))

  message(paste("Created lb_raw with", nrow(lb_raw), "records"))
  return(lb_raw)
}

# ==============================================================================
# Create mh_raw from MH
# ==============================================================================

create_mh_raw <- function() {
  message("Creating mh_raw from SDTM MH domain...")

  mh <- read_xpt(file.path(sdtm_path, "mh.xpt"))

  mh_raw <- mh %>%
    transmute(
      STUDY = STUDYID,
      PATNUM = as.character(SUBJID),
      FOLDER = "MEDICAL HISTORY",
      FOLDERL = "MEDICAL HISTORY",
      INSTANCE = "MEDHIST",
      `IT.MHTERM` = MHTERM,
      `IT.MHDECOD` = MHDECOD,
      `IT.MHBODSYS` = MHBODSYS,
      `IT.MHHLT` = MHHLT,
      `IT.MHHLGT` = MHHLGT,
      `IT.MHSTDAT` = convert_date(MHSTDTC),
      `IT.MHENDAT` = convert_date(MHENDTC),
      `IT.MHOSTXT` = MHOSTXT,
      DTCOL = convert_date(MHDTC)
    )

  save(mh_raw, file = file.path(output_path, "mh_raw.rda"))

  message(paste("Created mh_raw with", nrow(mh_raw), "records"))
  return(mh_raw)
}

# ==============================================================================
# Create cm_raw from CM
# ==============================================================================

create_cm_raw <- function() {
  message("Creating cm_raw from SDTM CM domain...")

  cm <- read_xpt(file.path(sdtm_path, "cm.xpt"))

  cm_raw <- cm %>%
    transmute(
      STUDY = STUDYID,
      PATNUM = as.character(SUBJID),
      VISITNAME = ifelse(is.na(VISIT), "UNSCHEDULED", VISIT),
      FOLDER = "CONMED",
      FOLDERL = "CONMED",
      INSTANCE = "CONMED",
      `IT.CMTRT` = CMTRT,
      `IT.CMDECOD` = CMDECOD,
      `IT.CMINDC` = CMINDC,
      `IT.CMCLAS` = CMCLAS,
      `IT.CMDOSE` = as.character(CMDOSE),
      `IT.CMDOSU` = CMDOSU,
      `IT.CMFRQ` = CMFRQ,
      `IT.CMROUTE` = CMROUTE,
      `IT.CMSTDAT` = convert_date(CMSTDTC),
      `IT.CMENDAT` = convert_date(CMENDTC),
      DTCOL = convert_date(CMDTC)
    )

  save(cm_raw, file = file.path(output_path, "cm_raw.rda"))

  message(paste("Created cm_raw with", nrow(cm_raw), "records"))
  return(cm_raw)
}

# ==============================================================================
# Create qs_raw from QS
# ==============================================================================

create_qs_raw <- function() {
  message("Creating qs_raw from SDTM QS domain...")

  qs <- read_xpt(file.path(sdtm_path, "qs.xpt"))

  qs_raw <- qs %>%
    transmute(
      STUDY = STUDYID,
      PATNUM = as.character(SUBJID),
      VISITNAME = VISIT,
      FOLDER = "QUESTIONNAIRE",
      FOLDERL = "QUESTIONNAIRE",
      INSTANCE = VISIT,
      `IT.QSCAT` = QSCAT,
      `IT.QSSCAT` = QSSCAT,
      `IT.QSTEST` = QSTEST,
      `IT.QSTESTCD` = QSTESTCD,
      `IT.QSORRES` = QSORRES,
      `IT.QSSTRESC` = QSSTRESC,
      `IT.QSSTRESN` = QSSTRESN,
      `IT.QSDRVFL` = QSDRVFL,
      DTCOL = convert_date(QSDTC)
    )

  save(qs_raw, file = file.path(output_path, "qs_raw.rda"))

  message(paste("Created qs_raw with", nrow(qs_raw), "records"))
  return(qs_raw)
}

# ==============================================================================
# Execute
# ==============================================================================

# Create all missing raw datasets
lb_raw <- create_lb_raw()
mh_raw <- create_mh_raw()
cm_raw <- create_cm_raw()
qs_raw <- create_qs_raw()

message("\nAll raw datasets created successfully!")
message("Files saved to: ", normalizePath(output_path))

# Summary
cat("\n=== Summary ===\n")
cat(sprintf("lb_raw: %d records, %d variables\n", nrow(lb_raw), ncol(lb_raw)))
cat(sprintf("mh_raw: %d records, %d variables\n", nrow(mh_raw), ncol(mh_raw)))
cat(sprintf("cm_raw: %d records, %d variables\n", nrow(cm_raw), ncol(cm_raw)))
cat(sprintf("qs_raw: %d records, %d variables\n", nrow(qs_raw), ncol(qs_raw)))
