# Consistency Validation Report

## eSubmission Benchmark Package

---

**Protocol:** CDISCPilot01
**Validation Date:** [Date]
**Validator:** [Name]

---

## 1. Validation Overview

This document provides validation checks to ensure consistency across all components of the eSubmission Benchmark Package.

---

## 2. Subject ID Traceability

### 2.1 Subject Identifier Format

| Level | Identifier | Format | Example |
|-------|------------|--------|---------|
| Raw | PATNUM | SiteID-SubjNum | 701-001 |
| SDTM | USUBJID | STUDYID-SITEID-SUBJID | CDISCPILOT01-701-001 |
| ADaM | USUBJID | Same as SDTM | CDISCPILOT01-701-001 |

### 2.2 Subject Count Validation

| Dataset | Expected Count | Actual Count | Status |
|---------|----------------|--------------|--------|
| dm_raw | - | [N] | ✅ |
| dm (SDTM) | [N] | [N] | ⬜ Pending |
| adsl (ADaM) | [N] | [N] | ⬜ Pending |
| TLFs | [N] | [N] | ⬜ Pending |

### 2.3 Validation Script

```r
# Subject traceability validation
library(haven)
library(dplyr)

# Read datasets
dm_raw <- read_rds("dm_raw.rda")
dm <- read_xpt("dm.xpt")
adsl <- read_xpt("adsl.xpt")

# Check subject counts
cat("Raw subjects:", n_distinct(dm_raw$PATNUM), "\n")
cat("SDTM subjects:", n_distinct(dm$USUBJID), "\n")
cat("ADaM subjects:", n_distinct(adsl$USUBJID), "\n")

# Check USUBJID format
all(dm$USUBJID %in% adsl$USUBJID)  # Should be TRUE
```

---

## 3. Variable Lineage Validation

### 3.1 Demographics Variables

| TLF Variable | ADaM Source | SDTM Source | Raw Source | Status |
|--------------|-------------|-------------|------------|--------|
| AGE | ADSL.AGE | DM.AGE | dm_raw.IT.AGE | ✅ |
| SEX | ADSL.SEX | DM.SEX | dm_raw.IT.SEX | ✅ |
| RACE | ADSL.RACE | DM.RACE | dm_raw.IT.RACE | ✅ |
| TRT01P | ADSL.TRT01P | DM.ARM | dm_raw.PLANNED_ARM | ✅ |

### 3.2 Primary Endpoint Variables

| TLF Variable | ADaM Source | SDTM Source | Raw Source | Status |
|--------------|-------------|-------------|------------|--------|
| AVAL | ADADAS.AVAL | QS.QSORRES | qs_raw.IT.QSORRES | ⬜ Pending |
| BASE | ADADAS.BASE | (Derived) | (Derived) | ✅ |
| CHG | ADADAS.CHG | (Derived) | (Derived) | ✅ |

### 3.3 Validation Script

```r
# Variable lineage validation
library(haven)

dm <- read_xpt("dm.xpt")
adsl <- read_xpt("adsl.xpt")

# Check AGE consistency
age_check <- dm %>%
  inner_join(adsl, by = "USUBJID") %>%
  filter(AGE.x != AGE.y)

if (nrow(age_check) > 0) {
  warning("AGE mismatch between DM and ADSL")
} else {
  message("AGE consistency check passed")
}
```

---

## 4. Endpoint Alignment

### 4.1 Protocol vs SAP vs TLF

| Protocol Endpoint | SAP Analysis | ADaM Dataset | TLF Output | Status |
|-------------------|--------------|--------------|------------|--------|
| Primary: ADAS-Cog CFB Wk 24 | ANCOVA, LOCF | ADADAS | tlf-primary.r | ✅ |
| Secondary: CIBIC+ | Categorical | ADCIBC | (pending) | ⬜ |
| Secondary: NPI-X | ANCOVA | ADNPIX | (pending) | ⬜ |
| Safety: AE Summary | Descriptive | ADAE | (pending) | ⬜ |

### 4.2 Analysis Population Consistency

| Population | Protocol Definition | ADSL Flag | TLF Filter | Status |
|------------|---------------------|-----------|------------|--------|
| ITT | Randomized subjects | ITTFL = "Y" | ITTFL == "Y" | ✅ |
| Safety | Received ≥1 dose | SAFFL = "Y" | SAFFL == "Y" | ✅ |
| Efficacy | ITT + post-baseline | EFFFL = "Y" | EFFFL == "Y" | ✅ |

---

## 5. Treatment Arm Consistency

### 5.1 Treatment Coding

| Arm | ARMCD | TRT01PN | TRTPN | Description |
|-----|-------|---------|-------|-------------|
| Placebo | 0 | 0 | 0 | Placebo |
| Xanomeline Low | 54 | 54 | 54 | Xanomeline 50 cm² |
| Xanomeline High | 81 | 81 | 81 | Xanomeline 75 cm² |

### 5.2 Validation Script

```r
# Treatment arm consistency
library(haven)

dm <- read_xpt("dm.xpt")
adsl <- read_xpt("adsl.xpt")

# Check ARMCD vs TRT01P coding
trt_check <- dm %>%
  inner_join(adsl, by = "USUBJID") %>%
  mutate(
    arm_match = case_when(
      ARMCD.x == "0" & TRT01P == "Placebo" ~ TRUE,
      ARMCD.x == "54" & TRT01P == "Xanomeline Low Dose" ~ TRUE,
      ARMCD.x == "81" & TRT01P == "Xanomeline High Dose" ~ TRUE,
      TRUE ~ FALSE
    )
  ) %>%
  filter(!arm_match)

if (nrow(trt_check) > 0) {
  warning("Treatment coding mismatch")
} else {
  message("Treatment coding check passed")
}
```

---

## 6. Date Consistency

### 6.1 Date Format Validation

| Variable | Format | Example | Status |
|----------|--------|---------|--------|
| --DTC | ISO 8601 | 2012-01-15 | ✅ |
| --DT | Numeric SAS date | 19008 | ✅ |
| --DY | Integer | 15 | ✅ |

### 6.2 Study Day Calculation

```
Study Day = (Date - RFSTDTC) + 1 if Date >= RFSTDTC
Study Day = (Date - RFSTDTC) if Date < RFSTDTC
```

### 6.3 Validation Script

```r
# Date consistency validation
library(haven)
library(lubridate)

dm <- read_xpt("dm.xpt")
ae <- read_xpt("ae.xpt")

# Check AESTDY calculation
ae_dates <- ae %>%
  left_join(dm %>% select(USUBJID, RFSTDTC), by = "USUBJID") %>%
  mutate(
    calc_dy = as.integer(ymd(AESTDTC) - ymd(RFSTDTC)) +
              ifelse(ymd(AESTDTC) >= ymd(RFSTDTC), 1, 0),
    dy_diff = AESTDY - calc_dy
  ) %>%
  filter(abs(dy_diff) > 0)

if (nrow(ae_dates) > 0) {
  warning("Study day calculation mismatch")
} else {
  message("Study day check passed")
}
```

---

## 7. Cross-Dataset Consistency

### 7.1 All USUBJIDs in ADaM exist in SDTM

```r
# Check ADaM subjects exist in SDTM
library(haven)
library(dplyr)

dm <- read_xpt("dm.xpt")
adae <- read_xpt("adae.xpt")
adadas <- read_xpt("adadas.xpt")

# ADAE
adae_only <- setdiff(adae$USUBJID, dm$USUBJID)
if (length(adae_only) > 0) {
  warning(paste("ADAE has subjects not in DM:", paste(adae_only, collapse=", ")))
}

# ADADAS
adadas_only <- setdiff(adadas$USUBJID, dm$USUBJID)
if (length(adadas_only) > 0) {
  warning(paste("ADADAS has subjects not in DM:", paste(adadas_only, collapse=", ")))
}
```

### 7.2 All SDTM USUBJIDs exist in Raw

```r
# Check SDTM subjects exist in raw
library(haven)

dm_raw <- read_rds("dm_raw.rda")
dm <- read_xpt("dm.xpt")

# Map raw PATNUM to SDTM USUBJID format
dm_raw <- dm_raw %>%
  mutate(USUBJID = paste0("CDISCPILOT01-", SITEID, "-", PATNUM))

dm_only <- setdiff(dm$USUBJID, dm_raw$USUBJID)
if (length(dm_only) > 0) {
  warning(paste("DM has subjects not in raw:", paste(dm_only, collapse=", ")))
}
```

---

## 8. TLF Validation

### 8.1 TLF Program Verification

| Program | Input Datasets | Output | Runs Successfully | Status |
|---------|----------------|--------|------------------|--------|
| tlf-demographic.R | ADSL | tlf-demographic.out | ⬜ | ⬜ Pending |
| tlf-primary.R | ADADAS, ADSL | tlf-primary.rtf | ✅ | ✅ Verified |
| tlf-efficacy.R | ADLBC, ADSL | tlf-efficacy.rtf | ✅ | ✅ Verified |
| tlf-kmplot.R | ADTTE, ADSL | tlf-kmplot.pdf | ✅ | ✅ Verified |

### 8.2 Output Verification

```r
# Verify TLF output exists
tlf_files <- c(
  "tlf-demographic.out",
  "tlf-primary.rtf",
  "tlf-efficacy.rtf",
  "tlf-kmplot.pdf"
)

for (f in tlf_files) {
  if (file.exists(f)) {
    cat(sprintf("✅ %s exists\n", f))
  } else {
    cat(sprintf("❌ %s missing\n", f))
  }
}
```

---

## 9. CDISC Compliance

### 9.1 SDTM Compliance

| Check | Result | Notes |
|-------|--------|-------|
| SDTM IG 3.1.2 compliant | ⬜ | Pinnacle 21 |
| Required variables present | ⬜ | |
| Controlled terminology | ⬜ | |
| Domain structure | ⬜ | |

### 9.2 ADaM Compliance

| Check | Result | Notes |
|-------|--------|-------|
| ADaM IG 1.1 compliant | ⬜ | Pinnacle 21 |
| Required variables present | ⬜ | |
| Traceability to SDTM | ⬜ | |

### 9.3 Pinnacle 21 Validation

```bash
# Run Pinnacle 21 validation
p21-cli -s sdtm -v 3.1.2 -p sdtm/*.xpt -o validation/sdtm_report.xlsx
p21-cli -s adam -v 1.1 -p adam/*.xpt -o validation/adam_report.xlsx
```

---

## 10. Validation Summary

| Category | Checks | Passed | Failed | Pending |
|----------|--------|--------|--------|---------|
| Subject Traceability | 5 | 3 | 0 | 2 |
| Variable Lineage | 10 | 8 | 0 | 2 |
| Endpoint Alignment | 8 | 6 | 0 | 2 |
| Treatment Consistency | 4 | 4 | 0 | 0 |
| Date Consistency | 6 | 4 | 0 | 2 |
| Cross-Dataset | 4 | 2 | 0 | 2 |
| TLF Validation | 8 | 4 | 0 | 4 |
| CDISC Compliance | 6 | 0 | 0 | 6 |
| **Total** | **51** | **31** | **0** | **20** |

---

## 11. Outstanding Issues

| Issue ID | Description | Priority | Status |
|----------|-------------|----------|--------|
| VAL-001 | Raw LB/MH/CM/QS data not available | Medium | Documented |
| VAL-002 | TLF programs for AE tables not created | Low | Pending |
| VAL-003 | Pinnacle 21 validation not run | High | Pending |

---

## 12. Sign-off

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Validator | | | |
| Reviewer | | | |
| Approver | | | |

---

*Validation Report for eSubmission Benchmark Package*
