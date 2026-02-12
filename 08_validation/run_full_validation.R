# ==============================================================================
# eSubmission Benchmark - Comprehensive Validation Script
# ==============================================================================
# This script runs all consistency checks across data, documents, and analysis
# ==============================================================================

# ==============================================================================
# Setup
# ==============================================================================

# Load required packages
required_packages <- c("haven", "dplyr", "tidyr", "stringr", "lubridate", "emmeans")

for (pkg in required_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  }
  library(pkg, character.only = TRUE)
}

# Define paths
paths <- list(
  raw = "../esub-benchmark-repos/pharmaverseraw/data",
  sdtm = "../esub-benchmark-repos/sdtm-adam-pilot-project/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm",
  adam = "../esub-benchmark-repos/submissions-pilot3-adam/submission/adam",
  pilot1_adam = "../esub-benchmark-repos/submissions-pilot1/adam",
  benchmark = "../esub-benchmark"
)

# Initialize results storage
validation_results <- tibble(
  Check_ID = character(),
  Category = character(),
  Description = character(),
  Expected = character(),
  Actual = character(),
  Status = character(),
  Details = character()
)

# Helper function to add result
add_result <- function(check_id, category, description, expected, actual, status, details = "") {
  validation_results <<- validation_results %>%
    add_row(
      Check_ID = check_id,
      Category = category,
      Description = description,
      Expected = expected,
      Actual = actual,
      Status = status,
      Details = details
    )
}

cat("=" , rep("=", 70), "=\n", sep="")
cat("  eSubmission Benchmark - Comprehensive Validation\n")
cat("  Protocol: CDISCPilot01\n")
cat("  Date:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n")
cat("=", rep("=", 70), "=\n\n")

# ==============================================================================
# SECTION 1: DATA LOADING
# ==============================================================================

cat("SECTION 1: Loading Data...\n")
cat("-" , rep("-", 70), "-\n", sep="")

tryCatch({
  # Raw data
  dm_raw <- read_rds(file.path(paths$raw, "dm_raw.rda"))
  ae_raw <- read_rds(file.path(paths$raw, "ae_raw.rda"))
  vs_raw <- read_rds(file.path(paths$raw, "vs_raw.rda"))
  cat("  [OK] Raw data loaded\n")

  # SDTM data
  dm <- read_xpt(file.path(paths$sdtm, "dm.xpt"))
  ae <- read_xpt(file.path(paths$sdtm, "ae.xpt"))
  vs <- read_xpt(file.path(paths$sdtm, "vs.xpt"))
  lb <- read_xpt(file.path(paths$sdtm, "lb.xpt"))
  qs <- read_xpt(file.path(paths$sdtm, "qs.xpt"))
  ex <- read_xpt(file.path(paths$sdtm, "ex.xpt"))
  ds <- read_xpt(file.path(paths$sdtm, "ds.xpt"))
  cat("  [OK] SDTM data loaded\n")

  # ADaM data
  adsl <- read_xpt(file.path(paths$adam, "adsl.xpt"))
  adae <- read_xpt(file.path(paths$adam, "adae.xpt"))
  adadas <- read_xpt(file.path(paths$adam, "adadas.xpt"))
  adlbc <- read_xpt(file.path(paths$adam, "adlbc.xpt"))
  adtte <- read_xpt(file.path(paths$adam, "adtte.xpt"))
  advs <- read_xpt(file.path(paths$adam, "advs.xpt"))
  cat("  [OK] ADaM data loaded\n")

  data_loaded <- TRUE
}, error = function(e) {
  cat("  [ERROR] Data loading failed:", e$message, "\n")
  data_loaded <<- FALSE
})

cat("\n")

if (!data_loaded) {
  stop("Cannot proceed without data. Please check file paths.")
}

# ==============================================================================
# SECTION 2: SUBJECT TRACEABILITY
# ==============================================================================

cat("SECTION 2: Subject Traceability Validation\n")
cat("-" , rep("-", 70), "-\n", sep="")

# --- D-001: Raw vs SDTM subject count ---
dm_raw_mapped <- dm_raw %>%
  mutate(
    SITEID = substr(as.character(PATNUM), 1, 3),
    SUBJID = as.character(PATNUM),
    USUBJID = paste0("CDISCPILOT01-", SITEID, "-", SUBJID)
  )

raw_n <- n_distinct(dm_raw_mapped$USUBJID)
sdtm_n <- n_distinct(dm$USUBJID)

add_result(
  "D-001", "Subject", "Raw vs SDTM subject count",
  raw_n, sdtm_n,
  ifelse(raw_n == sdtm_n, "PASS", "FAIL"),
  sprintf("Raw: %d, SDTM: %d", raw_n, sdtm_n)
)
cat(sprintf("  D-001: Raw vs SDTM - %s (%d vs %d)\n",
    ifelse(raw_n == sdtm_n, "PASS", "FAIL"), raw_n, sdtm_n))

# --- D-002: SDTM vs ADaM subject count ---
adam_n <- n_distinct(adsl$USUBJID)

add_result(
  "D-002", "Subject", "SDTM vs ADaM subject count",
  sdtm_n, adam_n,
  ifelse(sdtm_n == adam_n, "PASS", "FAIL"),
  sprintf("SDTM: %d, ADaM: %d", sdtm_n, adam_n)
)
cat(sprintf("  D-002: SDTM vs ADaM - %s (%d vs %d)\n",
    ifelse(sdtm_n == adam_n, "PASS", "FAIL"), sdtm_n, adam_n))

# --- D-003: USUBJID format ---
usubjid_pattern <- "^CDISCPILOT01-[0-9]{3}-[0-9]{3}$"
dm_format_ok <- all(grepl(usubjid_pattern, dm$USUBJID))
adam_format_ok <- all(grepl(usubjid_pattern, adsl$USUBJID))

add_result(
  "D-003", "Subject", "USUBJID format consistency",
  "Pattern: CDISCPILOT01-XXX-XXX",
  sprintf("DM: %s, ADaM: %s", dm_format_ok, adam_format_ok),
  ifelse(dm_format_ok && adam_format_ok, "PASS", "FAIL")
)
cat(sprintf("  D-003: USUBJID format - %s\n",
    ifelse(dm_format_ok && adam_format_ok, "PASS", "FAIL")))

# --- D-004: All ADaM subjects in SDTM ---
adam_only <- setdiff(adsl$USUBJID, dm$USUBJID)

add_result(
  "D-004", "Subject", "All ADaM subjects in SDTM",
  "0", length(adam_only),
  ifelse(length(adam_only) == 0, "PASS", "FAIL"),
  ifelse(length(adam_only) > 0, paste(head(adam_only, 5), collapse = ", "), "")
)
cat(sprintf("  D-004: ADaM subjects in SDTM - %s (missing: %d)\n",
    ifelse(length(adam_only) == 0, "PASS", "FAIL"), length(adam_only)))

cat("\n")

# ==============================================================================
# SECTION 3: TREATMENT CONSISTENCY
# ==============================================================================

cat("SECTION 3: Treatment Consistency Validation\n")
cat("-" , rep("-", 70), "-\n", sep="")

# --- D-010: Treatment coding ---
expected_arms <- c("Placebo", "Xanomeline Low Dose", "Xanomeline High Dose")
expected_armcd <- c("0", "54", "81")

dm_arms <- sort(unique(dm$ARM[dm$ARMCD %in% expected_armcd]))
adsl_trts <- sort(unique(adsl$TRT01P))

arms_match <- all(expected_arms %in% dm_arms) && all(dm_arms %in% expected_arms)
trts_match <- all(expected_arms %in% adsl_trts) && all(adsl_trts %in% expected_arms)

add_result(
  "D-010", "Treatment", "Treatment arm values",
  paste(expected_arms, collapse = ", "),
  sprintf("DM: %s, ADSL: %s", paste(dm_arms, collapse = ", "), paste(adsl_trts, collapse = ", ")),
  ifelse(arms_match && trts_match, "PASS", "FAIL")
)
cat(sprintf("  D-010: Treatment values - %s\n",
    ifelse(arms_match && trts_match, "PASS", "FAIL")))

# --- D-011: Treatment N values ---
dm_n_by_arm <- dm %>%
  filter(ARMCD %in% expected_armcd) %>%
  count(ARM) %>%
  arrange(ARM)

adsl_n_by_trt <- adsl %>%
  count(TRT01P) %>%
  arrange(TRT01P)

cat("  D-011: Treatment N values\n")
for (i in 1:nrow(adsl_n_by_trt)) {
  trt <- adsl_n_by_trt$TRT01P[i]
  adsl_n <- adsl_n_by_trt$n[i]
  dm_n <- dm_n_by_arm %>% filter(ARM == trt) %>% pull(n)
  if (length(dm_n) == 0) dm_n <- 0

  match_status <- ifelse(adsl_n == dm_n, "PASS", "FAIL")
  add_result(
    paste0("D-011-", i), "Treatment", paste("N for", trt),
    dm_n, adsl_n, match_status
  )
  cat(sprintf("    %s: DM=%d, ADSL=%d - %s\n", trt, dm_n, adsl_n, match_status))
}

cat("\n")

# ==============================================================================
# SECTION 4: POPULATION CONSISTENCY
# ==============================================================================

cat("SECTION 4: Population Consistency Validation\n")
cat("-" , rep("-", 70), "-\n", sep="")

pop_summary <- adsl %>%
  summarise(
    Total = n(),
    ITT = sum(ITTFL == "Y", na.rm = TRUE),
    SAF = sum(SAFFL == "Y", na.rm = TRUE),
    EFF = sum(EFFFL == "Y", na.rm = TRUE)
  )

cat(sprintf("  Total: %d\n", pop_summary$Total))
cat(sprintf("  ITT: %d (%.1f%%)\n", pop_summary$ITT, 100*pop_summary$ITT/pop_summary$Total))
cat(sprintf("  Safety: %d (%.1f%%)\n", pop_summary$SAF, 100*pop_summary$SAF/pop_summary$Total))
cat(sprintf("  Efficacy: %d (%.1f%%)\n", pop_summary$EFF, 100*pop_summary$EFF/pop_summary$Total))

# Logical checks
saf_ok <- pop_summary$SAF <= pop_summary$ITT
eff_ok <- pop_summary$EFF <= pop_summary$ITT

add_result("D-020", "Population", "SAF <= ITT", "TRUE", saf_ok, ifelse(saf_ok, "PASS", "FAIL"))
add_result("D-021", "Population", "EFF <= ITT", "TRUE", eff_ok, ifelse(eff_ok, "PASS", "FAIL"))

cat(sprintf("  D-020: SAF <= ITT - %s\n", ifelse(saf_ok, "PASS", "FAIL")))
cat(sprintf("  D-021: EFF <= ITT - %s\n", ifelse(eff_ok, "PASS", "FAIL")))

cat("\n")

# ==============================================================================
# SECTION 5: ANALYSIS CONSISTENCY
# ==============================================================================

cat("SECTION 5: Analysis Consistency Validation\n")
cat("-" , rep("-", 70), "-\n", sep="")

# --- A-001: Primary endpoint data ---
primary_anl <- adadas %>%
  filter(
    PARAMCD == "ACTOT",
    ANL01FL == "Y",
    EFFFL == "Y",
    ITTFL == "Y"
  )

primary_n <- n_distinct(primary_anl$USUBJID)
primary_visits <- sort(unique(primary_anl$AVISITN))

add_result(
  "A-001", "Analysis", "Primary endpoint subject count",
  "Expected > 0", primary_n,
  ifelse(primary_n > 0, "PASS", "FAIL"),
  sprintf("Visits: %s", paste(primary_visits, collapse = ", "))
)
cat(sprintf("  A-001: Primary endpoint subjects: %d\n", primary_n))
cat(sprintf("        Visits available: %s\n", paste(primary_visits, collapse = ", ")))

# --- A-002: Baseline values exist ---
baseline_n <- primary_anl %>%
  filter(AVISITN == 0) %>%
  n_distinct(.$USUBJID)

week24_n <- primary_anl %>%
  filter(AVISITN == 24) %>%
  n_distinct(.$USUBJID)

add_result(
  "A-002", "Analysis", "Baseline and Week 24 data",
  "Both should have data",
  sprintf("Baseline: %d, Week24: %d", baseline_n, week24_n),
  ifelse(baseline_n > 0 && week24_n > 0, "PASS", "FAIL")
)
cat(sprintf("  A-002: Baseline subjects: %d, Week 24 subjects: %d - %s\n",
    baseline_n, week24_n, ifelse(baseline_n > 0 && week24_n > 0, "PASS", "FAIL")))

# --- A-003: Change from baseline exists ---
chg_n <- primary_anl %>%
  filter(AVISITN == 24, !is.na(CHG)) %>%
  nrow()

add_result(
  "A-003", "Analysis", "Change from baseline calculated",
  "Should have CHG values", chg_n,
  ifelse(chg_n > 0, "PASS", "FAIL")
)
cat(sprintf("  A-003: Records with CHG at Week 24: %d - %s\n",
    chg_n, ifelse(chg_n > 0, "PASS", "FAIL")))

# --- A-004: LOCF records ---
locf_n <- primary_anl %>%
  filter(DTYPE == "LOCF") %>%
  nrow()

add_result(
  "A-004", "Analysis", "LOCF imputation applied",
  "Expected >= 0", locf_n,
  "PASS",
  sprintf("%d LOCF records", locf_n)
)
cat(sprintf("  A-004: LOCF records: %d - %s\n", locf_n, "INFO"))

cat("\n")

# ==============================================================================
# SECTION 6: VARIABLE LINEAGE
# ==============================================================================

cat("SECTION 6: Variable Lineage Validation\n")
cat("-" , rep("-", 70), "-\n", sep="")

# --- L-001: AGE consistency ---
age_check <- dm %>%
  inner_join(adsl, by = "USUBJID") %>%
  filter(AGE.x != AGE.y)

add_result(
  "L-001", "Lineage", "AGE consistency DM to ADSL",
  "0 mismatches", nrow(age_check),
  ifelse(nrow(age_check) == 0, "PASS", "FAIL")
)
cat(sprintf("  L-001: AGE consistency - %s (%d mismatches)\n",
    ifelse(nrow(age_check) == 0, "PASS", "FAIL"), nrow(age_check)))

# --- L-002: SEX consistency ---
sex_check <- dm %>%
  inner_join(adsl, by = "USUBJID") %>%
  filter(SEX.x != SEX.y)

add_result(
  "L-002", "Lineage", "SEX consistency DM to ADSL",
  "0 mismatches", nrow(sex_check),
  ifelse(nrow(sex_check) == 0, "PASS", "FAIL")
)
cat(sprintf("  L-002: SEX consistency - %s (%d mismatches)\n",
    ifelse(nrow(sex_check) == 0, "PASS", "FAIL"), nrow(sex_check)))

# --- L-003: RACE consistency ---
race_check <- dm %>%
  inner_join(adsl, by = "USUBJID") %>%
  filter(RACE.x != RACE.y)

add_result(
  "L-003", "Lineage", "RACE consistency DM to ADSL",
  "0 mismatches", nrow(race_check),
  ifelse(nrow(race_check) == 0, "PASS", "FAIL")
)
cat(sprintf("  L-003: RACE consistency - %s (%d mismatches)\n",
    ifelse(nrow(race_check) == 0, "PASS", "FAIL"), nrow(race_check)))

cat("\n")

# ==============================================================================
# SECTION 7: SUMMARY REPORT
# ==============================================================================

cat("=", rep("=", 70), "=\n", sep="")
cat("  VALIDATION SUMMARY\n")
cat("=", rep("=", 70), "=\n\n")

# Count by status
status_summary <- validation_results %>%
  count(Status) %>%
  mutate(Percentage = 100 * n / sum(n))

cat("Status Distribution:\n")
for (i in 1:nrow(status_summary)) {
  cat(sprintf("  %s: %d (%.1f%%)\n",
      status_summary$Status[i],
      status_summary$n[i],
      status_summary$Percentage[i]))
}

cat("\n")

# Count by category
category_summary <- validation_results %>%
  count(Category, Status)

cat("Results by Category:\n")
for (cat_name in unique(validation_results$Category)) {
  cat_data <- validation_results %>% filter(Category == cat_name)
  pass_count <- sum(cat_data$Status == "PASS")
  total_count <- nrow(cat_data)
  cat(sprintf("  %s: %d/%d PASS (%.0f%%)\n",
      cat_name, pass_count, total_count, 100*pass_count/total_count))
}

cat("\n")

# Overall result
overall_pass <- sum(validation_results$Status == "PASS")
overall_total <- nrow(validation_results)
overall_pct <- 100 * overall_pass / overall_total

cat(sprintf("OVERALL: %d/%d checks passed (%.0f%%)\n",
    overall_pass, overall_total, overall_pct))

if (overall_pct >= 90) {
  cat("\n  [RESULT] VALIDATION PASSED\n")
} else if (overall_pct >= 70) {
  cat("\n  [RESULT] VALIDATION PASSED WITH WARNINGS\n")
} else {
  cat("\n  [RESULT] VALIDATION FAILED\n")
}

# Save results
write.csv(validation_results, "validation_results.csv", row.names = FALSE)
cat("\n  Results saved to: validation_results.csv\n")

# ==============================================================================
# SECTION 8: DETAILED RESULTS
# ==============================================================================

cat("\n")
cat("=", rep("=", 70), "=\n", sep="")
cat("  DETAILED RESULTS\n")
cat("=", rep("=", 70), "=\n\n")

print(validation_results)

cat("\n")
cat("=", rep("=", 70), "=\n", sep="")
cat("  Validation complete:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n")
cat("=", rep("=", 70), "=\n", sep="")
