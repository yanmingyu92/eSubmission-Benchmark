# Master Consistency Validation Plan

## eSubmission Benchmark Package - CDISCPilot01

---

## 1. Overview

This plan defines a systematic approach to validate consistency across all components of the eSubmission benchmark package, ensuring it represents a high-quality, realistic clinical trial submission.

---

## 2. Validation Framework

### 2.1 Validation Layers

```
┌─────────────────────────────────────────────────────────────────┐
│                     DOCUMENT ALIGNMENT                          │
│    Protocol ↔ SAP ↔ Mock Shells ↔ TLF Specifications            │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     DATA LINEAGE                                │
│    Raw Data → SDTM → ADaM → TLFs                               │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     ANALYSIS CONSISTENCY                        │
│    Statistical Methods, Populations, Endpoints                  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     REGULATORY COMPLIANCE                       │
│    CDISC Standards, define.xml, Reviewer Guides                 │
└─────────────────────────────────────────────────────────────────┘
```

### 2.2 Validation Categories

| Category | Description | Priority |
|----------|-------------|----------|
| **Critical** | Must pass for package to be valid | High |
| **Major** | Significant consistency issues | Medium |
| **Minor** | Documentation/formatting issues | Low |

---

## 3. Data Consistency Validation

### 3.1 Subject Traceability Matrix

**Objective:** Verify same subjects exist across all data levels

| Check ID | Description | Source | Target | Expected |
|----------|-------------|--------|--------|----------|
| D-001 | Subject count raw vs SDTM | dm_raw | dm.xpt | Equal |
| D-002 | Subject count SDTM vs ADaM | dm.xpt | adsl.xpt | Equal |
| D-003 | USUBJID format consistency | dm.xpt | All ADaM | Match pattern |
| D-004 | All ADaM subjects in SDTM | adsl.xpt | dm.xpt | Subset |
| D-005 | All TLF subjects in ADaM | TLF outputs | adsl.xpt | Subset |

**Validation Script:**
```r
# V001_subject_traceability.R

library(haven)
library(dplyr)

# --- Configuration ---
paths <- list(
  raw = "../esub-benchmark-repos/pharmaverseraw/data",
  sdtm = "../esub-benchmark-repos/sdtm-adam-pilot-project/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm",
  adam = "../esub-benchmark-repos/submissions-pilot3-adam/submission/adam",
  tlf = "../esub-benchmark-repos/submissions-pilot1/adam"
)

# --- Load Data ---
dm_raw <- read_rds(file.path(paths$raw, "dm_raw.rda"))
dm <- read_xpt(file.path(paths$sdtm, "dm.xpt"))
adsl <- read_xpt(file.path(paths$adam, "adsl.xpt"))

# --- D-001: Raw vs SDTM ---
cat("=== D-001: Subject Count Raw vs SDTM ===\n")

# Map raw to SDTM format
dm_raw_mapped <- dm_raw %>%
  mutate(
    SITEID = substr(as.character(PATNUM), 1, 3),
    SUBJID = as.character(PATNUM),
    USUBJID = paste0("CDISCPILOT01-", SITEID, "-", SUBJID)
  )

raw_n <- n_distinct(dm_raw_mapped$USUBJID)
sdtm_n <- n_distinct(dm$USUBJID)

cat(sprintf("Raw subjects: %d\n", raw_n))
cat(sprintf("SDTM subjects: %d\n", sdtm_n))
cat(sprintf("Status: %s\n\n", ifelse(raw_n == sdtm_n, "PASS ✓", "FAIL ✗")))

# --- D-002: SDTM vs ADaM ---
cat("=== D-002: Subject Count SDTM vs ADaM ===\n")

adam_n <- n_distinct(adsl$USUBJID)

cat(sprintf("SDTM subjects: %d\n", sdtm_n))
cat(sprintf("ADaM subjects: %d\n", adam_n))
cat(sprintf("Status: %s\n\n", ifelse(sdtm_n == adam_n, "PASS ✓", "FAIL ✗")))

# --- D-003: USUBJID Format ---
cat("=== D-003: USUBJID Format Consistency ===\n")

usubjid_pattern <- "^CDISCPILOT01-[0-9]{3}-[0-9]{3}$"
dm_format_ok <- all(grepl(usubjid_pattern, dm$USUBJID))
adam_format_ok <- all(grepl(usubjid_pattern, adsl$USUBJID))

cat(sprintf("SDTM USUBJID format: %s\n", ifelse(dm_format_ok, "Valid ✓", "Invalid ✗")))
cat(sprintf("ADaM USUBJID format: %s\n\n", ifelse(adam_format_ok, "Valid ✓", "Invalid ✗")))

# --- D-004: All ADaM subjects in SDTM ---
cat("=== D-004: ADaM Subjects in SDTM ===\n")

adam_only <- setdiff(adsl$USUBJID, dm$USUBJID)
cat(sprintf("ADaM subjects not in SDTM: %d\n", length(adam_only)))
cat(sprintf("Status: %s\n\n", ifelse(length(adam_only) == 0, "PASS ✓", "FAIL ✗")))

# --- Summary Report ---
results <- tibble(
  Check_ID = c("D-001", "D-002", "D-003", "D-004"),
  Description = c(
    "Raw vs SDTM subject count",
    "SDTM vs ADaM subject count",
    "USUBJID format consistency",
    "ADaM subjects in SDTM"
  ),
  Result = c(
    ifelse(raw_n == sdtm_n, "PASS", "FAIL"),
    ifelse(sdtm_n == adam_n, "PASS", "FAIL"),
    ifelse(dm_format_ok & adam_format_ok, "PASS", "FAIL"),
    ifelse(length(adam_only) == 0, "PASS", "FAIL")
  )
)

cat("=== SUMMARY ===\n")
print(results)

# Save results
write.csv(results, "validation_results_subject_traceability.csv", row.names = FALSE)
```

### 3.2 Treatment Arm Consistency

**Objective:** Verify treatment coding is consistent across all levels

| Check ID | Description | Expected |
|----------|-------------|----------|
| D-010 | ARM/ARMCD values match | Placebo=0, Low=54, High=81 |
| D-011 | TRT01P values match ARM | Exact match |
| D-012 | Treatment N values match | Same across datasets |
| D-013 | Treatment order consistent | Same order in all outputs |

**Validation Script:**
```r
# V002_treatment_consistency.R

library(haven)
library(dplyr)

# --- Load Data ---
dm <- read_xpt(file.path(paths$sdtm, "dm.xpt"))
adsl <- read_xpt(file.path(paths$adam, "adsl.xpt"))
adadas <- read_xpt(file.path(paths$adam, "adadas.xpt"))
adae <- read_xpt(file.path(paths$adam, "adae.xpt"))

# --- D-010: Treatment Coding ---
cat("=== D-010: Treatment Coding ===\n")

# Expected coding
expected_trt <- tibble(
  ARMCD = c("0", "54", "81"),
  ARM = c("Placebo", "Xanomeline Low Dose", "Xanomeline High Dose"),
  TRT01PN = c(0, 54, 81)
)

# Check DM
dm_trt <- dm %>%
  filter(ARMCD %in% expected_trt$ARMCD) %>%
  count(ARMCD, ARM) %>%
  arrange(ARMCD)

cat("DM Treatment Distribution:\n")
print(dm_trt)

# Check ADSL
adsl_trt <- adsl %>%
  filter(TRT01PN %in% expected_trt$TRT01PN) %>%
  count(TRT01PN, TRT01P) %>%
  arrange(TRT01PN)

cat("\nADSL Treatment Distribution:\n")
print(adsl_trt)

# --- D-011: ARM vs TRT01P Mapping ---
cat("\n=== D-011: ARM vs TRT01P Mapping ===\n")

# Cross-check mapping
mapping_check <- dm %>%
  select(USUBJID, ARMCD, ARM) %>%
  inner_join(adsl %>% select(USUBJID, TRT01PN, TRT01P), by = "USUBJID") %>%
  mutate(
    code_match = case_when(
      ARMCD == "0" & TRT01PN == 0 ~ TRUE,
      ARMCD == "54" & TRT01PN == 54 ~ TRUE,
      ARMCD == "81" & TRT01PN == 81 ~ TRUE,
      TRUE ~ FALSE
    ),
    name_match = case_when(
      ARM == "Placebo" & TRT01P == "Placebo" ~ TRUE,
      ARM == "Xanomeline Low Dose" & TRT01P == "Xanomeline Low Dose" ~ TRUE,
      ARM == "Xanomeline High Dose" & TRT01P == "Xanomeline High Dose" ~ TRUE,
      TRUE ~ FALSE
    )
  )

mismatches <- mapping_check %>%
  filter(!code_match | !name_match)

cat(sprintf("Total records: %d\n", nrow(mapping_check)))
cat(sprintf("Mismatches: %d\n", nrow(mismatches)))
cat(sprintf("Status: %s\n", ifelse(nrow(mismatches) == 0, "PASS ✓", "FAIL ✗")))

# --- D-012: Treatment N Values ---
cat("\n=== D-012: Treatment N Values ===\n")

dm_n <- dm %>% filter(ARMCD != "Screen Failure") %>% count(ARMCD) %>% arrange(ARMCD)
adsl_n <- adsl %>% count(TRT01PN) %>% arrange(TRT01PN)
adadas_n <- adadas %>% filter(ITTFL == "Y") %>% count(TRTPN) %>% arrange(TRTPN)

cat("DM N by ARM:\n")
print(dm_n)
cat("\nADSL N by TRT:\n")
print(adsl_n)
cat("\nADADAS N by TRT (ITT):\n")
print(adadas_n)

# Check consistency
n_check <- tibble(
  Source = c("DM", "ADSL", "ADADAS"),
  Placebo = c(
    dm_n %>% filter(ARMCD == "0") %>% pull(n),
    adsl_n %>% filter(TRT01PN == 0) %>% pull(n),
    adadas_n %>% filter(TRTPN == 0) %>% pull(n)
  ),
  Low_Dose = c(
    dm_n %>% filter(ARMCD == "54") %>% pull(n),
    adsl_n %>% filter(TRT01PN == 54) %>% pull(n),
    adadas_n %>% filter(TRTPN == 54) %>% pull(n)
  ),
  High_Dose = c(
    dm_n %>% filter(ARMCD == "81") %>% pull(n),
    adsl_n %>% filter(TRT01PN == 81) %>% pull(n),
    adadas_n %>% filter(TRTPN == 81) %>% pull(n)
  )
)

cat("\nN Comparison:\n")
print(n_check)
```

### 3.3 Population Consistency

**Objective:** Verify population definitions and flags

| Check ID | Description | Expected |
|----------|-------------|----------|
| D-020 | ITTFL definition | All randomized |
| D-021 | SAFFL definition | Received ≥1 dose |
| D-022 | EFFFL definition | ITT + post-baseline |
| D-023 | Population counts reasonable | SAF ≤ ITT, EFF ≤ ITT |

```r
# V003_population_consistency.R

library(haven)
library(dplyr)

adsl <- read_xpt(file.path(paths$adam, "adsl.xpt"))

# --- D-020 to D-023: Population Flags ---
cat("=== Population Flag Summary ===\n")

pop_summary <- adsl %>%
  summarise(
    Total = n(),
    ITT = sum(ITTFL == "Y"),
    SAF = sum(SAFFL == "Y"),
    EFF = sum(EFFFL == "Y"),
    COMP24 = sum(COMP24FL == "Y", na.rm = TRUE)
  )

cat(sprintf("Total subjects: %d\n", pop_summary$Total))
cat(sprintf("ITT (ITTFL=Y): %d (%.1f%%)\n", pop_summary$ITT, 100*pop_summary$ITT/pop_summary$Total))
cat(sprintf("Safety (SAFFL=Y): %d (%.1f%%)\n", pop_summary$SAF, 100*pop_summary$SAF/pop_summary$Total))
cat(sprintf("Efficacy (EFFFL=Y): %d (%.1f%%)\n", pop_summary$EFF, 100*pop_summary$EFF/pop_summary$Total))
cat(sprintf("Completers Wk24: %d (%.1f%%)\n", pop_summary$COMP24, 100*pop_summary$COMP24/pop_summary$Total))

# Logical checks
checks <- tibble(
  Check = c(
    "SAF should be ≤ ITT",
    "EFF should be ≤ ITT",
    "COMP24 should be ≤ EFF"
  ),
  Result = c(
    pop_summary$SAF <= pop_summary$ITT,
    pop_summary$EFF <= pop_summary$ITT,
    pop_summary$COMP24 <= pop_summary$EFF
  ),
  Status = c(
    ifelse(pop_summary$SAF <= pop_summary$ITT, "PASS ✓", "FAIL ✗"),
    ifelse(pop_summary$EFF <= pop_summary$ITT, "PASS ✓", "FAIL ✗"),
    ifelse(pop_summary$COMP24 <= pop_summary$EFF, "PASS ✓", "FAIL ✗")
  )
)

cat("\n=== Population Logic Checks ===\n")
print(checks)

# Population by treatment
cat("\n=== Population by Treatment ===\n")
pop_by_trt <- adsl %>%
  group_by(TRT01P) %>%
  summarise(
    N = n(),
    ITT = sum(ITTFL == "Y"),
    SAF = sum(SAFFL == "Y"),
    EFF = sum(EFFFL == "Y"),
    .groups = "drop"
  )
print(pop_by_trt)
```

---

## 4. Document Alignment Validation

### 4.1 Protocol ↔ SAP Alignment

| Check ID | Protocol Element | SAP Element | Validation |
|----------|------------------|-------------|------------|
| P-001 | Primary objective | Primary endpoint | Match |
| P-002 | Secondary objectives | Secondary endpoints | Match |
| P-003 | Study design | Analysis populations | Consistent |
| P-004 | Sample size | Power calculation | Consistent |
| P-005 | Treatment arms | Treatment groups | Match |
| P-006 | Inclusion/exclusion | Population definitions | Consistent |

**Checklist:**

```markdown
## Protocol ↔ SAP Alignment Checklist

### Primary Endpoint
- [ ] Protocol states: "Change from baseline to Week 24 in ADAS-Cog"
- [ ] SAP states: "Change from baseline to Week 24 in ADAS-Cog (11) score"
- [ ] Analysis method in SAP: ANCOVA with baseline covariate
- [ ] Missing data in SAP: LOCF

### Secondary Endpoints
- [ ] Protocol: CIBIC+ at Week 24
- [ ] SAP: CIBIC+ categorical analysis
- [ ] Protocol: NPI-X change from baseline
- [ ] SAP: NPI-X ANCOVA

### Study Design
- [ ] Protocol: 300 subjects, 1:1:1 randomization
- [ ] SAP: Sample size justification consistent
- [ ] Protocol: 24-week treatment
- [ ] SAP: Analysis visit windows defined

### Treatment Groups
- [ ] Protocol: Placebo, Xanomeline Low (50cm²), Xanomeline High (75cm²)
- [ ] SAP: TRT01P values match
- [ ] Coding: 0, 54, 81 consistent
```

### 4.2 SAP ↔ Mock Shell Alignment

| Check ID | SAP Element | Mock Shell Element | Validation |
|----------|-------------|-------------------|------------|
| S-001 | Table 14-3.01 spec | Mock 14-3.01 | Layout match |
| S-002 | Primary analysis | Primary table mock | Statistics match |
| S-003 | Population definitions | Mock population | Same filter |
| S-004 | Footnotes | Mock footnotes | Match |

**Validation Script:**
```r
# V004_sap_mock_alignment.R

# This script checks alignment between SAP and Mock specifications

# Define expected structure from SAP
sap_primary_table <- list(
  id = "14-3.01",
  title = "Primary Endpoint Analysis: ADAS Cog (11) - Change from Baseline to Week 24 - LOCF",
  population = "Efficacy",
  columns = c("Placebo", "Xanomeline Low Dose", "Xanomeline High Dose"),
  rows = c(
    "Baseline: n, Mean (SD), Median (Range)",
    "Week 24: n, Mean (SD), Median (Range)",
    "Change from Baseline: n, Mean (SD), Median (Range)",
    "Statistical Analysis:",
    "  p-value(Dose Response)",
    "  p-value(Xan - Placebo)",
    "  Diff of LS Means (SE)",
    "  95% CI"
  ),
  footnotes = c(
    "[1] ANCOVA with treatment, site group, baseline",
    "[2] Dose response test",
    "[3] Pairwise comparison, no multiplicity adjustment"
  )
)

# Read mock shell
mock_content <- readLines("../esub-benchmark/06_tlfs/mock_templates/t_mock_14-3-01_primary_endpoint.md")

cat("=== SAP ↔ Mock Alignment Check ===\n")

# Check title
title_found <- any(grepl(sap_primary_table$title, mock_content, fixed = TRUE))
cat(sprintf("Title match: %s\n", ifelse(title_found, "PASS ✓", "FAIL ✗")))

# Check population
pop_found <- any(grepl(sap_primary_table$population, mock_content, fixed = TRUE))
cat(sprintf("Population match: %s\n", ifelse(pop_found, "PASS ✓", "FAIL ✗")))

# Check columns
for (col in sap_primary_table$columns) {
  col_found <- any(grepl(col, mock_content, fixed = TRUE))
  cat(sprintf("Column '%s': %s\n", col, ifelse(col_found, "PASS ✓", "FAIL ✗")))
}

# Check key statistics
stats <- c("Mean (SD)", "Median", "p-value", "LS Means", "95% CI")
for (stat in stats) {
  stat_found <- any(grepl(stat, mock_content, fixed = TRUE))
  cat(sprintf("Statistic '%s': %s\n", stat, ifelse(stat_found, "PASS ✓", "FAIL ✗")))
}
```

### 4.3 Mock Shell ↔ TLF Output Alignment

| Check ID | Mock Element | TLF Output | Validation |
|----------|--------------|------------|------------|
| M-001 | Table structure | Actual columns | Match |
| M-002 | Row labels | Actual row labels | Match |
| M-003 | Statistics | Calculated values | Reasonable |
| M-004 | Footnotes | Actual footnotes | Match |

---

## 5. Analysis Logic Consistency

### 5.1 Primary Endpoint Analysis

| Check ID | Component | Expected | Actual | Status |
|----------|-----------|----------|--------|--------|
| A-001 | Analysis method | ANCOVA | | |
| A-002 | Model specification | CHG ~ TRTP + SITEGR1 + BASE | | |
| A-003 | LS Means method | Proportional weighting | | |
| A-004 | Multiple comparison | No adjustment | | |
| A-005 | Missing data | LOCF | | |

**Validation Script:**
```r
# V005_analysis_logic.R

library(haven)
library(dplyr)
library(emmeans)

adadas <- read_xpt(file.path(paths$adam, "adadas.xpt"))

# Filter for primary analysis
anl <- adadas %>%
  filter(
    PARAMCD == "ACTOT",
    ANL01FL == "Y",
    AVISITN == 24,
    EFFFL == "Y",
    ITTFL == "Y"
  )

cat("=== A-001: Analysis Dataset Summary ===\n")
cat(sprintf("Records for analysis: %d\n", nrow(anl)))
cat(sprintf("Unique subjects: %d\n", n_distinct(anl$USUBJID)))

cat("\n=== A-002: Model Specification ===\n")

# Set contrasts for Type III SS (like SAS)
options(contrasts = c("contr.sum", "contr.poly"))

# Fit ANCOVA model per SAP
model <- lm(CHG ~ TRTPN + SITEGR1 + BASE, data = anl)

cat("Model: CHG ~ TRTPN + SITEGR1 + BASE\n")
cat(sprintf("Observations used: %d\n", nobs(model)))

# Dose response test
ancova <- drop1(model, .~., test = "F")
dose_response_p <- ancova["TRTPN", "Pr(>F)"]
cat(sprintf("\nDose response p-value: %.4f\n", dose_response_p))

cat("\n=== A-003: LS Means Calculation ===\n")

# Categorical treatment for pairwise
anl <- anl %>%
  mutate(TRTPCD_F = factor(TRTPN, levels = c(81, 54, 0)))

model_cat <- lm(CHG ~ TRTPCD_F + SITEGR1 + BASE, data = anl)

# LS Means with proportional weighting (matching SAS OM option)
lsm <- emmeans(model_cat, ~TRTPCD_F, weights = "proportional")

cat("LS Means by Treatment:\n")
print(as.data.frame(lsm))

# Pairwise comparisons
pairs_lsm <- pairs(lsm, adjust = NULL)
cat("\nPairwise Comparisons:\n")
print(as.data.frame(pairs_lsm))

# Compare with TLF output values
cat("\n=== A-005: LOCF Verification ===\n")
locf_records <- anl %>% filter(DTYPE == "LOCF")
cat(sprintf("LOCF records at Week 24: %d (%.1f%%)\n",
    nrow(locf_records), 100*nrow(locf_records)/nrow(anl)))
```

### 5.2 Demographic Summary Consistency

| Check ID | Component | Expected |
|----------|-----------|----------|
| A-010 | Population | ITT (ITTFL = "Y") |
| A-011 | Variables | AGE, SEX, RACE, HEIGHTBL, WEIGHTBL, BMIBL, MMSETOT |
| A-012 | Statistics | n, Mean (SD), Median, Min-Max |

```r
# V006_demographic_consistency.R

library(haven)
library(dplyr)

adsl <- read_xpt(file.path(paths$adam, "adsl.xpt"))

# Filter per SAP
anl <- adsl %>% filter(ITTFL == "Y")

cat("=== A-010: Population Check ===\n")
cat(sprintf("ITT subjects: %d\n", nrow(anl)))

cat("\n=== A-011: Variable Summary ===\n")

demo_vars <- c("AGE", "SEX", "RACE", "HEIGHTBL", "WEIGHTBL", "BMIBL", "MMSETOT")

for (var in demo_vars) {
  if (var %in% names(anl)) {
    cat(sprintf("%s: present ✓\n", var))
  } else {
    cat(sprintf("%s: MISSING ✗\n", var))
  }
}

cat("\n=== A-012: Statistics by Treatment ===\n")

demo_summary <- anl %>%
  group_by(TRT01P) %>%
  summarise(
    N = n(),
    Age_Mean = mean(AGE, na.rm = TRUE),
    Age_SD = sd(AGE, na.rm = TRUE),
    BMI_Mean = mean(BMIBL, na.rm = TRUE),
    BMI_SD = sd(BMIBL, na.rm = TRUE),
    .groups = "drop"
  )

print(demo_summary)

# Compare with expected TLF values
expected_demo <- tibble(
  TRT01P = c("Placebo", "Xanomeline Low Dose", "Xanomeline High Dose"),
  Expected_N = c(86, 84, 84),
  Expected_Age_Mean = c(75.21, 75.67, 74.38)
)

comparison <- demo_summary %>%
  left_join(expected_demo, by = "TRT01P") %>%
  mutate(
    N_Match = N == Expected_N,
    Age_Match = abs(Age_Mean - Expected_Age_Mean) < 0.01
  )

cat("\n=== Comparison with TLF ===\n")
print(comparison %>% select(TRT01P, N, Expected_N, N_Match, Age_Match))
```

---

## 6. Cross-Component Validation

### 6.1 Endpoint-to-Dataset Mapping

| Protocol Endpoint | SAP Analysis | ADaM Dataset | TLF Program | Status |
|-------------------|--------------|--------------|-------------|--------|
| ADAS-Cog CFB Wk 24 | ANCOVA, LOCF | ADADAS | tlf-primary.R | ⬜ |
| CIBIC+ | Categorical | ADCIBC | - | ⬜ |
| NPI-X | ANCOVA | ADNPIX | - | ⬜ |
| Safety AE | Descriptive | ADAE | - | ⬜ |
| Dermatologic AE | KM | ADTTE | tlf-kmplot.R | ⬜ |

### 6.2 Complete Validation Checklist

```markdown
## Complete Validation Checklist

### Data Level
- [ ] D-001: Raw to SDTM subject count match
- [ ] D-002: SDTM to ADaM subject count match
- [ ] D-003: USUBJID format consistent
- [ ] D-004: All ADaM subjects exist in SDTM
- [ ] D-010: Treatment coding consistent
- [ ] D-011: ARM maps to TRT01P correctly
- [ ] D-012: Treatment N values match
- [ ] D-020: ITT population defined correctly
- [ ] D-021: Safety population defined correctly
- [ ] D-022: Efficacy population defined correctly

### Document Level
- [ ] P-001: Protocol primary endpoint = SAP primary endpoint
- [ ] P-002: Protocol secondary endpoints = SAP secondary endpoints
- [ ] P-003: Study design consistent across documents
- [ ] P-004: Sample size consistent
- [ ] P-005: Treatment groups consistent
- [ ] S-001: SAP table spec = Mock structure
- [ ] S-002: SAP analysis method = Mock statistics
- [ ] S-003: SAP population = Mock population
- [ ] M-001: Mock structure = TLF output structure
- [ ] M-002: Mock statistics = TLF calculated values

### Analysis Level
- [ ] A-001: Primary analysis method = ANCOVA
- [ ] A-002: Model specification matches SAP
- [ ] A-003: LS Means method documented
- [ ] A-004: Multiple comparison approach documented
- [ ] A-005: Missing data handling = LOCF
- [ ] A-010: Demographics population = ITT
- [ ] A-011: Demographics variables match SAP
- [ ] A-012: Demographics statistics match SAP

### Compliance Level
- [ ] C-001: SDTM IG 3.1.2 compliant
- [ ] C-002: ADaM IG 1.1 compliant
- [ ] C-003: Define-XML valid
- [ ] C-004: ADRG complete
- [ ] C-005: SDRG complete
```

---

## 7. Validation Execution Plan

### Phase 1: Data Validation (Day 1)
1. Run V001_subject_traceability.R
2. Run V002_treatment_consistency.R
3. Run V003_population_consistency.R
4. Document results

### Phase 2: Document Validation (Day 2)
1. Complete Protocol ↔ SAP checklist
2. Run V004_sap_mock_alignment.R
3. Manual review of mock shells vs TLFs
4. Document findings

### Phase 3: Analysis Validation (Day 3)
1. Run V005_analysis_logic.R
2. Run V006_demographic_consistency.R
3. Verify TLF outputs match specifications
4. Document results

### Phase 4: Final Report (Day 4)
1. Compile all validation results
2. Document any issues found
3. Create remediation plan if needed
4. Sign-off on validation

---

## 8. Issue Tracking

| Issue ID | Category | Description | Severity | Status | Resolution |
|----------|----------|-------------|----------|--------|------------|
| | | | | | |

---

## 9. Sign-off

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Validation Lead | | | |
| Quality Assurance | | | |
| Project Lead | | | |

---

*Master Validation Plan v1.0*
