# ==============================================================================
# eSubmission Benchmark - Corrected Validation Script
# ==============================================================================
# Uses actual expected values from CDISC pilot data
# ==============================================================================

# Load required packages
required_packages <- c("haven", "dplyr", "tidyr", "stringr")

for (pkg in required_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg, repos = "https://cloud.r-project.org/")
  }
  suppressPackageStartupMessages(library(pkg, character.only = TRUE))
}

# Define paths
base_path <- "C:/Users/yanmi/Downloads/clinagent_new"

paths <- list(
  raw = file.path(base_path, "esub-benchmark-repos/pharmaverseraw/data"),
  sdtm = file.path(base_path, "esub-benchmark-repos/sdtm-adam-pilot-project/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm"),
  adam = file.path(base_path, "esub-benchmark-repos/submissions-pilot3-adam/submission/adam"),
  benchmark = file.path(base_path, "esub-benchmark")
)

# Ground truth values from actual TLFs
GROUND_TRUTH <- list(
  itt_total = 254,
  itt_placebo = 86,
  itt_low = 84,
  itt_high = 84,
  sdtm_total = 306,  # includes screen failures
  screen_failures = 52,
  age_placebo_mean = 75.21,
  age_placebo_sd = 8.59,
  usubjid_pattern = "^[0-9]{2}-[0-9]{3}-[0-9]{4}$",
  armcd_values = c("Pbo", "Xan_Lo", "Xan_Hi", "Scrnfail"),
  trt01pn_values = c(0, 54, 81)
)

# Initialize results
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

add_result <- function(check_id, category, description, expected, actual, status, details = "") {
  validation_results <<- rbind(validation_results, data.frame(
    Check_ID = check_id, Category = category, Description = description,
    Expected = as.character(expected), Actual = as.character(actual),
    Status = status, Details = details, stringsAsFactors = FALSE
  ))
}

cat(paste(rep("=", 70), collapse=""), "\n")
cat("  eSubmission Benchmark - CORRECTED Validation\n")
cat("  Protocol: CDISCPilot01\n")
cat("  Date:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n")
cat(paste(rep("=", 70), collapse=""), "\n\n")

# ==============================================================================
# Load Data
# ==============================================================================

cat("SECTION 1: Loading Data...\n")
cat(paste(rep("-", 70), collapse=""), "\n")

load_dataset <- function(path, name) {
  tryCatch({
    if (grepl("\\.rda$", path)) {
      env <- new.env()
      load(path, envir = env)
      as.data.frame(env[[ls(env)[1]]])
    } else {
      haven::read_xpt(path)
    }
  }, error = function(e) NULL)
}

dm_raw <- load_dataset(file.path(paths$raw, "dm_raw.rda"), "dm_raw")
dm <- load_dataset(file.path(paths$sdtm, "dm.xpt"), "dm")
adsl <- load_dataset(file.path(paths$adam, "adsl.xpt"), "adsl")
adadas <- load_dataset(file.path(paths$adam, "adadas.xpt"), "adadas")

cat(sprintf("  Loaded: dm_raw(%s), dm(%s), adsl(%s), adadas(%s)\n\n",
    !is.null(dm_raw), !is.null(dm), !is.null(adsl), !is.null(adadas)))

# ==============================================================================
# SECTION 2: Subject Traceability (CORRECTED)
# ==============================================================================

cat("SECTION 2: Subject Traceability\n")
cat(paste(rep("-", 70), collapse=""), "\n")

if (!is.null(dm)) {
  sdtm_n <- n_distinct(dm$USUBJID)
  sdtm_itt <- dm %>% filter(ARMCD != "Scrnfail") %>% n_distinct(.$USUBJID)

  add_result("D-001", "Subject", "SDTM total subjects", GROUND_TRUTH$sdtm_total, sdtm_n,
             ifelse(sdtm_n == GROUND_TRUTH$sdtm_total, "PASS", "FAIL"))
  cat(sprintf("  D-001: SDTM total = %d - %s\n", sdtm_n,
      ifelse(sdtm_n == GROUND_TRUTH$sdtm_total, "PASS", "FAIL")))

  add_result("D-002", "Subject", "SDTM ITT subjects (no screen failures)", GROUND_TRUTH$itt_total, sdtm_itt,
             ifelse(sdtm_itt == GROUND_TRUTH$itt_total, "PASS", "FAIL"))
  cat(sprintf("  D-002: SDTM ITT = %d - %s\n", sdtm_itt,
      ifelse(sdtm_itt == GROUND_TRUTH$itt_total, "PASS", "FAIL")))
}

if (!is.null(adsl)) {
  adam_n <- n_distinct(adsl$USUBJID)

  add_result("D-003", "Subject", "ADaM ITT subjects", GROUND_TRUTH$itt_total, adam_n,
             ifelse(adam_n == GROUND_TRUTH$itt_total, "PASS", "FAIL"))
  cat(sprintf("  D-003: ADaM ITT = %d - %s\n", adam_n,
      ifelse(adam_n == GROUND_TRUTH$itt_total, "PASS", "FAIL")))
}

if (!is.null(dm) && !is.null(adsl)) {
  # Check all ADaM subjects exist in SDTM
  adam_only <- setdiff(adsl$USUBJID, dm$USUBJID)
  add_result("D-004", "Subject", "All ADaM subjects in SDTM", 0, length(adam_only),
             ifelse(length(adam_only) == 0, "PASS", "FAIL"))
  cat(sprintf("  D-004: ADaM in SDTM - %s (missing: %d)\n",
      ifelse(length(adam_only) == 0, "PASS", "FAIL"), length(adam_only)))

  # USUBJID format
  usubjid_ok <- all(grepl(GROUND_TRUTH$usubjid_pattern, dm$USUBJID))
  add_result("D-005", "Subject", "USUBJID format (XX-XXX-XXXX)", "Valid pattern", usubjid_ok,
             ifelse(usubjid_ok, "PASS", "FAIL"))
  cat(sprintf("  D-005: USUBJID format - %s\n", ifelse(usubjid_ok, "PASS", "FAIL")))
}

cat("\n")

# ==============================================================================
# SECTION 3: Treatment Consistency (CORRECTED)
# ==============================================================================

cat("SECTION 3: Treatment Consistency\n")
cat(paste(rep("-", 70), collapse=""), "\n")

if (!is.null(dm)) {
  # Check ARMCD values
  actual_armcd <- sort(unique(dm$ARMCD))
  expected_armcd <- sort(GROUND_TRUTH$armcd_values)
  armcd_match <- all(actual_armcd %in% expected_armcd)

  add_result("D-010", "Treatment", "ARMCD values", paste(expected_armcd, collapse=", "),
             paste(actual_armcd, collapse=", "), ifelse(armcd_match, "PASS", "FAIL"))
  cat(sprintf("  D-010: ARMCD values - %s\n", ifelse(armcd_match, "PASS", "FAIL")))
  cat(sprintf("        Actual: %s\n", paste(actual_armcd, collapse=", ")))
}

if (!is.null(adsl)) {
  # Check TRT01PN values
  actual_trt01pn <- sort(unique(adsl$TRT01PN))
  expected_trt01pn <- sort(GROUND_TRUTH$trt01pn_values)
  trt_match <- all(actual_trt01pn %in% expected_trt01pn)

  add_result("D-011", "Treatment", "TRT01PN values", paste(expected_trt01pn, collapse=", "),
             paste(actual_trt01pn, collapse=", "), ifelse(trt_match, "PASS", "FAIL"))
  cat(sprintf("  D-011: TRT01PN values - %s\n", ifelse(trt_match, "PASS", "FAIL")))

  # Treatment N values (compare with ground truth from TLF)
  trt_n <- adsl %>% count(TRT01P) %>% arrange(TRT01P)

  placebo_n <- trt_n %>% filter(TRT01P == "Placebo") %>% pull(n)
  low_n <- trt_n %>% filter(TRT01P == "Xanomeline Low Dose") %>% pull(n)
  high_n <- trt_n %>% filter(TRT01P == "Xanomeline High Dose") %>% pull(n)

  add_result("D-012a", "Treatment", "Placebo N", GROUND_TRUTH$itt_placebo,
             ifelse(length(placebo_n)>0, placebo_n, 0),
             ifelse(placebo_n == GROUND_TRUTH$itt_placebo, "PASS", "FAIL"))
  add_result("D-012b", "Treatment", "Xanomeline Low N", GROUND_TRUTH$itt_low,
             ifelse(length(low_n)>0, low_n, 0),
             ifelse(low_n == GROUND_TRUTH$itt_low, "PASS", "FAIL"))
  add_result("D-012c", "Treatment", "Xanomeline High N", GROUND_TRUTH$itt_high,
             ifelse(length(high_n)>0, high_n, 0),
             ifelse(high_n == GROUND_TRUTH$itt_high, "PASS", "FAIL"))

  cat(sprintf("  D-012: Treatment N values\n"))
  cat(sprintf("        Placebo: %d - %s\n", placebo_n,
      ifelse(placebo_n == GROUND_TRUTH$itt_placebo, "PASS", "FAIL")))
  cat(sprintf("        Xan Low: %d - %s\n", low_n,
      ifelse(low_n == GROUND_TRUTH$itt_low, "PASS", "FAIL")))
  cat(sprintf("        Xan High: %d - %s\n", high_n,
      ifelse(high_n == GROUND_TRUTH$itt_high, "PASS", "FAIL")))
}

cat("\n")

# ==============================================================================
# SECTION 4: Population Consistency
# ==============================================================================

cat("SECTION 4: Population Consistency\n")
cat(paste(rep("-", 70), collapse=""), "\n")

if (!is.null(adsl)) {
  pop <- adsl %>%
    summarise(Total = n(), ITT = sum(ITTFL=="Y"), SAF = sum(SAFFL=="Y"), EFF = sum(EFFFL=="Y"))

  cat(sprintf("  Total: %d, ITT: %d, Safety: %d, Efficacy: %d\n",
      pop$Total, pop$ITT, pop$SAF, pop$EFF))

  # Population logic checks
  saf_ok <- pop$SAF <= pop$ITT
  eff_ok <- pop$EFF <= pop$ITT
  itt_ok <- pop$ITT == GROUND_TRUTH$itt_total

  add_result("D-020", "Population", "SAF <= ITT", TRUE, saf_ok, ifelse(saf_ok, "PASS", "FAIL"))
  add_result("D-021", "Population", "EFF <= ITT", TRUE, eff_ok, ifelse(eff_ok, "PASS", "FAIL"))
  add_result("D-022", "Population", "ITT count matches TLF", GROUND_TRUTH$itt_total, pop$ITT,
             ifelse(itt_ok, "PASS", "FAIL"))

  cat(sprintf("  D-020: SAF <= ITT - %s\n", ifelse(saf_ok, "PASS", "FAIL")))
  cat(sprintf("  D-021: EFF <= ITT - %s\n", ifelse(eff_ok, "PASS", "FAIL")))
  cat(sprintf("  D-022: ITT matches TLF - %s\n", ifelse(itt_ok, "PASS", "FAIL")))
}

cat("\n")

# ==============================================================================
# SECTION 5: Ground Truth Comparison
# ==============================================================================

cat("SECTION 5: Ground Truth Comparison\n")
cat(paste(rep("-", 70), collapse=""), "\n")

if (!is.null(adsl)) {
  # Compare demographics with TLF output
  demo_check <- adsl %>%
    filter(ITTFL == "Y") %>%
    group_by(TRT01P) %>%
    summarise(N = n(), Age_Mean = mean(AGE, na.rm=TRUE), Age_SD = sd(AGE, na.rm=TRUE), .groups="drop")

  # Placebo age check
  placebo_age <- demo_check %>% filter(TRT01P == "Placebo") %>% pull(Age_Mean)
  age_match <- abs(placebo_age - GROUND_TRUTH$age_placebo_mean) < 0.01

  add_result("G-001", "GroundTruth", "Placebo Age Mean", GROUND_TRUTH$age_placebo_mean,
             sprintf("%.2f", placebo_age), ifelse(age_match, "PASS", "FAIL"))
  cat(sprintf("  G-001: Placebo Age Mean: %.2f (expected %.2f) - %s\n",
      placebo_age, GROUND_TRUTH$age_placebo_mean, ifelse(age_match, "PASS", "FAIL")))

  print(demo_check)
}

cat("\n")

# ==============================================================================
# SUMMARY
# ==============================================================================

cat(paste(rep("=", 70), collapse=""), "\n")
cat("  VALIDATION SUMMARY\n")
cat(paste(rep("=", 70), collapse=""), "\n\n")

# Count by status
for (status in unique(validation_results$Status)) {
  count <- sum(validation_results$Status == status)
  cat(sprintf("  %s: %d\n", status, count))
}

cat("\nResults by Category:\n")
for (cat_name in unique(validation_results$Category)) {
  cat_data <- validation_results[validation_results$Category == cat_name, ]
  pass_count <- sum(cat_data$Status == "PASS")
  total_count <- nrow(cat_data)
  cat(sprintf("  %s: %d/%d PASS (%.0f%%)\n", cat_name, pass_count, total_count, 100*pass_count/total_count))
}

overall_pass <- sum(validation_results$Status == "PASS")
overall_total <- nrow(validation_results)
overall_pct <- 100 * overall_pass / overall_total

cat(sprintf("\nOVERALL: %d/%d checks passed (%.0f%%)\n", overall_pass, overall_total, overall_pct))

if (overall_pct >= 90) {
  cat("\n  [RESULT] VALIDATION PASSED\n")
  final_status <- "PASSED"
} else if (overall_pct >= 70) {
  cat("\n  [RESULT] VALIDATION PASSED WITH NOTES\n")
  final_status <- "PASSED_WITH_NOTES"
} else {
  cat("\n  [RESULT] VALIDATION NEEDS ATTENTION\n")
  final_status <- "NEEDS_ATTENTION"
}

# Save results
output_file <- file.path(base_path, "esub-benchmark/08_validation/validation_results_v2.csv")
write.csv(validation_results, output_file, row.names = FALSE)
cat(sprintf("\n  Results saved to: validation_results_v2.csv\n"))

# Save summary
summary_file <- file.path(base_path, "esub-benchmark/08_validation/validation_summary.txt")
sink(summary_file)
cat("eSubmission Benchmark Validation Summary\n")
cat("========================================\n")
cat(sprintf("Date: %s\n", format(Sys.time(), "%Y-%m-%d %H:%M:%S")))
cat(sprintf("Status: %s\n", final_status))
cat(sprintf("Pass Rate: %d/%d (%.0f%%)\n\n", overall_pass, overall_total, overall_pct))
cat("Results by Category:\n")
for (cat_name in unique(validation_results$Category)) {
  cat_data <- validation_results[validation_results$Category == cat_name, ]
  pass_count <- sum(cat_data$Status == "PASS")
  total_count <- nrow(cat_data)
  cat(sprintf("  %s: %d/%d\n", cat_name, pass_count, total_count))
}
cat("\nDetailed Results:\n")
print(validation_results)
sink()

cat(sprintf("  Summary saved to: validation_summary.txt\n"))
cat(paste(rep("=", 70), collapse=""), "\n")
