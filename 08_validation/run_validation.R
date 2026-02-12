# ==============================================================================
# eSubmission Benchmark - Comprehensive Validation Script
# ==============================================================================

# ==============================================================================
# Setup
# ==============================================================================

# Load required packages
required_packages <- c("haven", "dplyr", "tidyr", "stringr", "lubridate")

for (pkg in required_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    cat(sprintf("Installing %s...\n", pkg))
    install.packages(pkg, repos = "https://cloud.r-project.org/")
  }
  suppressPackageStartupMessages(library(pkg, character.only = TRUE))
}

# Define paths - using absolute paths
base_path <- "C:/Users/yanmi/Downloads/clinagent_new"

paths <- list(
  raw = file.path(base_path, "esub-benchmark-repos/pharmaverseraw/data"),
  sdtm = file.path(base_path, "esub-benchmark-repos/sdtm-adam-pilot-project/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm"),
  adam = file.path(base_path, "esub-benchmark-repos/submissions-pilot3-adam/submission/adam"),
  pilot1_adam = file.path(base_path, "esub-benchmark-repos/submissions-pilot1/adam"),
  benchmark = file.path(base_path, "esub-benchmark")
)

# Initialize results storage
validation_results <- data.frame(
  Check_ID = character(),
  Category = character(),
  Description = character(),
  Expected = character(),
  Actual = character(),
  Status = character(),
  Details = character(),
  stringsAsFactors = FALSE
)

# Helper function to add result
add_result <- function(check_id, category, description, expected, actual, status, details = "") {
  validation_results <<- rbind(validation_results, data.frame(
    Check_ID = check_id,
    Category = category,
    Description = description,
    Expected = as.character(expected),
    Actual = as.character(actual),
    Status = status,
    Details = details,
    stringsAsFactors = FALSE
  ))
}

cat(paste(rep("=", 70), collapse=""), "\n")
cat("  eSubmission Benchmark - Comprehensive Validation\n")
cat("  Protocol: CDISCPilot01\n")
cat("  Date:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n")
cat(paste(rep("=", 70), collapse=""), "\n\n")

# ==============================================================================
# SECTION 1: DATA LOADING
# ==============================================================================

cat("SECTION 1: Loading Data...\n")
cat(paste(rep("-", 70), collapse=""), "\n")

data_loaded <- TRUE
load_errors <- character()

# Load datasets with error handling
load_dataset <- function(path, name) {
  tryCatch({
    if (grepl("\\.rda$", path)) {
      env <- new.env()
      load(path, envir = env)
      as.data.frame(env[[ls(env)[1]]])
    } else {
      haven::read_xpt(path)
    }
  }, error = function(e) {
    load_errors <<- c(load_errors, paste(name, ":", e$message))
    NULL
  })
}

# Raw data
dm_raw <- load_dataset(file.path(paths$raw, "dm_raw.rda"), "dm_raw")
ae_raw <- load_dataset(file.path(paths$raw, "ae_raw.rda"), "ae_raw")
vs_raw <- load_dataset(file.path(paths$raw, "vs_raw.rda"), "vs_raw")

# SDTM data
dm <- load_dataset(file.path(paths$sdtm, "dm.xpt"), "dm")
ae <- load_dataset(file.path(paths$sdtm, "ae.xpt"), "ae")
vs <- load_dataset(file.path(paths$sdtm, "vs.xpt"), "vs")
lb <- load_dataset(file.path(paths$sdtm, "lb.xpt"), "lb")
qs <- load_dataset(file.path(paths$sdtm, "qs.xpt"), "qs")
ex <- load_dataset(file.path(paths$sdtm, "ex.xpt"), "ex")
ds <- load_dataset(file.path(paths$sdtm, "ds.xpt"), "ds")

# ADaM data
adsl <- load_dataset(file.path(paths$adam, "adsl.xpt"), "adsl")
adae <- load_dataset(file.path(paths$adam, "adae.xpt"), "adae")
adadas <- load_dataset(file.path(paths$adam, "adadas.xpt"), "adadas")
adlbc <- load_dataset(file.path(paths$adam, "adlbc.xpt"), "adlbc")
adtte <- load_dataset(file.path(paths$adam, "adtte.xpt"), "adtte")
advs <- load_dataset(file.path(paths$adam, "advs.xpt"), "advs")

# Check what was loaded
datasets_loaded <- c(
  !is.null(dm_raw), !is.null(ae_raw), !is.null(vs_raw),
  !is.null(dm), !is.null(ae), !is.null(vs), !is.null(lb), !is.null(qs),
  !is.null(adsl), !is.null(adae), !is.null(adadas), !is.null(adlbc)
)

if (length(load_errors) > 0) {
  cat("  [WARNING] Some datasets could not be loaded:\n")
  for (err in load_errors) {
    cat("    ", err, "\n")
  }
}

cat(sprintf("  [OK] Loaded %d/%d core datasets\n\n", sum(datasets_loaded), length(datasets_loaded)))

# ==============================================================================
# SECTION 2: SUBJECT TRACEABILITY
# ==============================================================================

cat("SECTION 2: Subject Traceability Validation\n")
cat(paste(rep("-", 70), collapse=""), "\n")

if (!is.null(dm_raw) && !is.null(dm)) {
  # Map raw to SDTM format
  dm_raw_mapped <- dm_raw %>%
    mutate(
      SITEID = substr(as.character(PATNUM), 1, 3),
      SUBJID = as.character(PATNUM),
      USUBJID = paste0("CDISCPILOT01-", SITEID, "-", SUBJID)
    )

  raw_n <- dplyr::n_distinct(dm_raw_mapped$USUBJID)
  sdtm_n <- dplyr::n_distinct(dm$USUBJID)

  add_result("D-001", "Subject", "Raw vs SDTM subject count", raw_n, sdtm_n,
             ifelse(raw_n == sdtm_n, "PASS", "FAIL"), sprintf("Raw: %d, SDTM: %d", raw_n, sdtm_n))
  cat(sprintf("  D-001: Raw vs SDTM - %s (%d vs %d)\n", ifelse(raw_n == sdtm_n, "PASS", "FAIL"), raw_n, sdtm_n))
} else {
  add_result("D-001", "Subject", "Raw vs SDTM subject count", "N/A", "N/A", "SKIP", "Data not available")
  cat("  D-001: SKIPPED (data not available)\n")
}

if (!is.null(dm) && !is.null(adsl)) {
  sdtm_n <- dplyr::n_distinct(dm$USUBJID)
  adam_n <- dplyr::n_distinct(adsl$USUBJID)

  add_result("D-002", "Subject", "SDTM vs ADaM subject count", sdtm_n, adam_n,
             ifelse(sdtm_n == adam_n, "PASS", "FAIL"), sprintf("SDTM: %d, ADaM: %d", sdtm_n, adam_n))
  cat(sprintf("  D-002: SDTM vs ADaM - %s (%d vs %d)\n", ifelse(sdtm_n == adam_n, "PASS", "FAIL"), sdtm_n, adam_n))

  # USUBJID format check
  usubjid_pattern <- "^CDISCPILOT01-[0-9]{3}-[0-9]{3}$"
  dm_format_ok <- all(grepl(usubjid_pattern, dm$USUBJID))
  adam_format_ok <- all(grepl(usubjid_pattern, adsl$USUBJID))

  add_result("D-003", "Subject", "USUBJID format consistency", "Pattern: CDISCPILOT01-XXX-XXX",
             sprintf("DM: %s, ADaM: %s", dm_format_ok, adam_format_ok),
             ifelse(dm_format_ok && adam_format_ok, "PASS", "FAIL"))
  cat(sprintf("  D-003: USUBJID format - %s\n", ifelse(dm_format_ok && adam_format_ok, "PASS", "FAIL")))

  # All ADaM subjects in SDTM
  adam_only <- setdiff(adsl$USUBJID, dm$USUBJID)
  add_result("D-004", "Subject", "All ADaM subjects in SDTM", "0", length(adam_only),
             ifelse(length(adam_only) == 0, "PASS", "FAIL"))
  cat(sprintf("  D-004: ADaM subjects in SDTM - %s (missing: %d)\n",
              ifelse(length(adam_only) == 0, "PASS", "FAIL"), length(adam_only)))
}

cat("\n")

# ==============================================================================
# SECTION 3: TREATMENT CONSISTENCY
# ==============================================================================

cat("SECTION 3: Treatment Consistency Validation\n")
cat(paste(rep("-", 70), collapse=""), "\n")

if (!is.null(dm) && !is.null(adsl)) {
  expected_arms <- c("Placebo", "Xanomeline Low Dose", "Xanomeline High Dose")
  expected_armcd <- c("0", "54", "81")

  dm_arms <- sort(unique(dm$ARM[dm$ARMCD %in% expected_armcd]))
  adsl_trts <- sort(unique(adsl$TRT01P))

  arms_match <- all(expected_arms %in% dm_arms) && all(dm_arms %in% expected_arms)
  trts_match <- all(expected_arms %in% adsl_trts) && all(adsl_trts %in% expected_arms)

  add_result("D-010", "Treatment", "Treatment arm values", paste(expected_arms, collapse = ", "),
             sprintf("DM: %s, ADSL: %s", paste(dm_arms, collapse = ", "), paste(adsl_trts, collapse = ", ")),
             ifelse(arms_match && trts_match, "PASS", "FAIL"))
  cat(sprintf("  D-010: Treatment values - %s\n", ifelse(arms_match && trts_match, "PASS", "FAIL")))

  # Treatment N values
  dm_n_by_arm <- dm %>%
    filter(ARMCD %in% expected_armcd) %>%
    count(ARM) %>%
    arrange(ARM)

  adsl_n_by_trt <- adsl %>%
    count(TRT01P) %>%
    arrange(TRT01P)

  cat("  D-011: Treatment N values\n")
  for (trt in expected_arms) {
    adsl_n <- adsl_n_by_trt %>% filter(TRT01P == trt) %>% pull(n)
    dm_n <- dm_n_by_arm %>% filter(ARM == trt) %>% pull(n)
    if (length(adsl_n) == 0) adsl_n <- 0
    if (length(dm_n) == 0) dm_n <- 0

    match_status <- ifelse(adsl_n == dm_n, "PASS", "FAIL")
    add_result(paste0("D-011-", gsub(" ", "-", trt)), "Treatment", paste("N for", trt),
               dm_n, adsl_n, match_status)
    cat(sprintf("    %s: DM=%d, ADSL=%d - %s\n", trt, dm_n, adsl_n, match_status))
  }

  # ARM to TRT01P mapping
  mapping_check <- dm %>%
    select(USUBJID, ARMCD, ARM) %>%
    inner_join(adsl %>% select(USUBJID, TRT01PN, TRT01P), by = "USUBJID") %>%
    mutate(
      code_match = case_when(
        ARMCD == "0" & TRT01PN == 0 ~ TRUE,
        ARMCD == "54" & TRT01PN == 54 ~ TRUE,
        ARMCD == "81" & TRT01PN == 81 ~ TRUE,
        TRUE ~ FALSE
      )
    )

  mismatches <- sum(!mapping_check$code_match)
  add_result("D-012", "Treatment", "ARM to TRT01P mapping", "0 mismatches", mismatches,
             ifelse(mismatches == 0, "PASS", "FAIL"))
  cat(sprintf("  D-012: ARM to TRT01P mapping - %s (%d mismatches)\n",
              ifelse(mismatches == 0, "PASS", "FAIL"), mismatches))
}

cat("\n")

# ==============================================================================
# SECTION 4: POPULATION CONSISTENCY
# ==============================================================================

cat("SECTION 4: Population Consistency Validation\n")
cat(paste(rep("-", 70), collapse=""), "\n")

if (!is.null(adsl)) {
  pop_summary <- adsl %>%
    summarise(
      Total = n(),
      ITT = sum(ITTFL == "Y", na.rm = TRUE),
      SAF = sum(SAFFL == "Y", na.rm = TRUE),
      EFF = sum(EFFFL == "Y", na.rm = TRUE)
    )

  cat(sprintf("  Total subjects: %d\n", pop_summary$Total))
  cat(sprintf("  ITT (ITTFL=Y): %d (%.1f%%)\n", pop_summary$ITT, 100*pop_summary$ITT/pop_summary$Total))
  cat(sprintf("  Safety (SAFFL=Y): %d (%.1f%%)\n", pop_summary$SAF, 100*pop_summary$SAF/pop_summary$Total))
  cat(sprintf("  Efficacy (EFFFL=Y): %d (%.1f%%)\n", pop_summary$EFF, 100*pop_summary$EFF/pop_summary$Total))

  # Logical checks
  saf_ok <- pop_summary$SAF <= pop_summary$ITT
  eff_ok <- pop_summary$EFF <= pop_summary$ITT

  add_result("D-020", "Population", "SAF <= ITT", "TRUE", saf_ok, ifelse(saf_ok, "PASS", "FAIL"))
  add_result("D-021", "Population", "EFF <= ITT", "TRUE", eff_ok, ifelse(eff_ok, "PASS", "FAIL"))

  cat(sprintf("  D-020: SAF <= ITT - %s\n", ifelse(saf_ok, "PASS", "FAIL")))
  cat(sprintf("  D-021: EFF <= ITT - %s\n", ifelse(eff_ok, "PASS", "FAIL")))

  # Population by treatment
  pop_by_trt <- adsl %>%
    group_by(TRT01P) %>%
    summarise(N = n(), ITT = sum(ITTFL == "Y"), SAF = sum(SAFFL == "Y"), EFF = sum(EFFFL == "Y"), .groups = "drop")

  add_result("D-022", "Population", "Population breakdown by treatment", "Check output",
             "See details", "INFO", capture.output(print(pop_by_trt)))
}

cat("\n")

# ==============================================================================
# SECTION 5: ANALYSIS DATA CHECKS
# ==============================================================================

cat("SECTION 5: Analysis Data Validation\n")
cat(paste(rep("-", 70), collapse=""), "\n")

if (!is.null(adadas)) {
  # Primary endpoint data
  primary_anl <- adadas %>%
    filter(PARAMCD == "ACTOT" & ANL01FL == "Y" & EFFFL == "Y" & ITTFL == "Y")

  primary_n <- dplyr::n_distinct(primary_anl$USUBJID)
  primary_visits <- sort(unique(primary_anl$AVISITN))

  add_result("A-001", "Analysis", "Primary endpoint subject count", "Expected > 0", primary_n,
             ifelse(primary_n > 0, "PASS", "FAIL"), sprintf("Visits: %s", paste(primary_visits, collapse = ", ")))
  cat(sprintf("  A-001: Primary endpoint subjects: %d\n", primary_n))
  cat(sprintf("        Visits available: %s\n", paste(primary_visits, collapse = ", ")))

  # Baseline and Week 24 data
  baseline_n <- primary_anl %>% filter(AVISITN == 0) %>% dplyr::n_distinct(.$USUBJID)
  week24_n <- primary_anl %>% filter(AVISITN == 24) %>% dplyr::n_distinct(.$USUBJID)

  add_result("A-002", "Analysis", "Baseline and Week 24 data", "Both > 0",
             sprintf("Baseline: %d, Week24: %d", baseline_n, week24_n),
             ifelse(baseline_n > 0 && week24_n > 0, "PASS", "FAIL"))
  cat(sprintf("  A-002: Baseline: %d, Week 24: %d - %s\n",
              baseline_n, week24_n, ifelse(baseline_n > 0 && week24_n > 0, "PASS", "FAIL")))

  # CHG values
  chg_n <- primary_anl %>% filter(AVISITN == 24, !is.na(CHG)) %>% nrow()
  add_result("A-003", "Analysis", "Change from baseline calculated", "Should have CHG", chg_n,
             ifelse(chg_n > 0, "PASS", "FAIL"))
  cat(sprintf("  A-003: Records with CHG at Week 24: %d - %s\n", chg_n, ifelse(chg_n > 0, "PASS", "FAIL")))

  # LOCF
  locf_n <- primary_anl %>% filter(DTYPE == "LOCF") %>% nrow()
  add_result("A-004", "Analysis", "LOCF imputation records", ">= 0", locf_n, "INFO")
  cat(sprintf("  A-004: LOCF records: %d - INFO\n", locf_n))
}

cat("\n")

# ==============================================================================
# SECTION 6: VARIABLE LINEAGE
# ==============================================================================

cat("SECTION 6: Variable Lineage Validation\n")
cat(paste(rep("-", 70), collapse=""), "\n")

if (!is.null(dm) && !is.null(adsl)) {
  # AGE consistency
  age_check <- dm %>%
    inner_join(adsl, by = "USUBJID", suffix = c("_dm", "_adsl")) %>%
    filter(AGE_dm != AGE_adsl)

  add_result("L-001", "Lineage", "AGE consistency DM to ADSL", "0 mismatches", nrow(age_check),
             ifelse(nrow(age_check) == 0, "PASS", "FAIL"))
  cat(sprintf("  L-001: AGE consistency - %s (%d mismatches)\n",
              ifelse(nrow(age_check) == 0, "PASS", "FAIL"), nrow(age_check)))

  # SEX consistency
  sex_check <- dm %>%
    inner_join(adsl, by = "USUBJID", suffix = c("_dm", "_adsl")) %>%
    filter(SEX_dm != SEX_adsl)

  add_result("L-002", "Lineage", "SEX consistency DM to ADSL", "0 mismatches", nrow(sex_check),
             ifelse(nrow(sex_check) == 0, "PASS", "FAIL"))
  cat(sprintf("  L-002: SEX consistency - %s (%d mismatches)\n",
              ifelse(nrow(sex_check) == 0, "PASS", "FAIL"), nrow(sex_check)))

  # RACE consistency
  race_check <- dm %>%
    inner_join(adsl, by = "USUBJID", suffix = c("_dm", "_adsl")) %>%
    filter(RACE_dm != RACE_adsl)

  add_result("L-003", "Lineage", "RACE consistency DM to ADSL", "0 mismatches", nrow(race_check),
             ifelse(nrow(race_check) == 0, "PASS", "FAIL"))
  cat(sprintf("  L-003: RACE consistency - %s (%d mismatches)\n",
              ifelse(nrow(race_check) == 0, "PASS", "FAIL"), nrow(race_check)))
}

cat("\n")

# ==============================================================================
# SUMMARY
# ==============================================================================

cat(paste(rep("=", 70), collapse=""), "\n")
cat("  VALIDATION SUMMARY\n")
cat(paste(rep("=", 70), collapse=""), "\n\n")

# Count by status
status_counts <- table(validation_results$Status)
cat("Status Distribution:\n")
for (status in names(status_counts)) {
  cat(sprintf("  %s: %d\n", status, status_counts[status]))
}

# Count by category
cat("\nResults by Category:\n")
for (cat_name in unique(validation_results$Category)) {
  cat_data <- validation_results[validation_results$Category == cat_name, ]
  pass_count <- sum(cat_data$Status == "PASS")
  total_count <- nrow(cat_data)
  cat(sprintf("  %s: %d/%d PASS (%.0f%%)\n", cat_name, pass_count, total_count, 100*pass_count/total_count))
}

# Overall result
overall_pass <- sum(validation_results$Status == "PASS")
overall_total <- nrow(validation_results)
overall_pct <- 100 * overall_pass / overall_total

cat(sprintf("\nOVERALL: %d/%d checks passed (%.0f%%)\n", overall_pass, overall_total, overall_pct))

if (overall_pct >= 90) {
  cat("\n  [RESULT] VALIDATION PASSED\n")
} else if (overall_pct >= 70) {
  cat("\n  [RESULT] VALIDATION PASSED WITH WARNINGS\n")
} else {
  cat("\n  [RESULT] VALIDATION FAILED\n")
}

# Save results
output_file <- file.path(base_path, "esub-benchmark/08_validation/validation_results.csv")
write.csv(validation_results, output_file, row.names = FALSE)
cat(sprintf("\n  Results saved to: %s\n", output_file))

# Print detailed results
cat("\n")
cat(paste(rep("=", 70), collapse=""), "\n")
cat("  DETAILED RESULTS\n")
cat(paste(rep("=", 70), collapse=""), "\n\n")
print(validation_results)

cat("\n")
cat(paste(rep("=", 70), collapse=""), "\n")
cat("  Validation complete:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n")
cat(paste(rep("=", 70), collapse=""), "\n")
