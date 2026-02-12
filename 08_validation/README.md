# Validation Directory

## eSubmission Benchmark Package - Consistency Validation

---

## Overview

This directory contains all materials for validating the consistency of the eSubmission benchmark package across data, documents, and analysis.

---

## Files

| File | Purpose |
|------|---------|
| `master_validation_plan.md` | Complete validation plan with all checks defined |
| `run_full_validation.R` | Automated R script for data validation |
| `run_validation.bat` | Windows batch file to run validation |
| `document_alignment_checklist.md` | Manual checklist for document consistency |
| `consistency_validation.md` | Original validation report template |

---

## How to Run Validation

### Automated Validation (Data Consistency)

1. Ensure R is installed with required packages:
   ```r
   install.packages(c("haven", "dplyr", "tidyr", "stringr", "lubridate", "emmeans"))
   ```

2. Run the validation:
   ```
   run_validation.bat
   ```

   Or from R:
   ```r
   setwd("08_validation")
   source("run_full_validation.R")
   ```

3. Results saved to `validation_results.csv`

### Manual Validation (Document Consistency)

1. Open `document_alignment_checklist.md`
2. Review each section comparing documents
3. Check boxes for aligned items
4. Document any issues found
5. Sign off when complete

---

## Validation Categories

### 1. Data Consistency (Automated)

| Category | Checks | Description |
|----------|--------|-------------|
| Subject Traceability | D-001 to D-004 | Subject counts and IDs across datasets |
| Treatment Consistency | D-010 to D-012 | Treatment coding and N values |
| Population Consistency | D-020 to D-023 | Population flags and logic |
| Variable Lineage | L-001 to L-003 | Variable consistency across levels |

### 2. Document Alignment (Manual)

| Category | Checks | Description |
|----------|--------|-------------|
| Protocol ↔ SAP | P-001 to P-006 | Study design, objectives, endpoints |
| SAP ↔ Mock | S-001 to S-004 | Table specs, analysis methods |
| Mock ↔ TLF | M-001 to M-004 | Output structure, values |

### 3. Analysis Consistency (Automated + Manual)

| Category | Checks | Description |
|----------|--------|-------------|
| Model Specification | A-001 to A-004 | ANCOVA model matches SAP |
| Data Selection | Filters | Population, parameter, visit |
| Results Reproducibility | Compare | TLF values match program output |

---

## Expected Results

### Critical Checks (Must Pass)

| Check ID | Description | Expected Result |
|----------|-------------|-----------------|
| D-001 | Raw vs SDTM subject count | Equal |
| D-002 | SDTM vs ADaM subject count | Equal |
| D-003 | USUBJID format | Valid pattern |
| D-004 | ADaM subjects in SDTM | All present |
| D-010 | Treatment values | Match |
| A-001 | Primary endpoint data | Present |

### Major Checks (Should Pass)

| Check ID | Description | Expected Result |
|----------|-------------|-----------------|
| D-011 | Treatment N values | Match |
| D-020 | SAF ≤ ITT | TRUE |
| D-021 | EFF ≤ ITT | TRUE |
| A-002 | Baseline and Week 24 data | Present |
| L-001 | AGE consistency | No mismatches |

---

## Validation Status Summary

Run the validation to populate this section:

```
[Paste validation_results.csv summary here after running]
```

---

## Issue Resolution

If validation fails:

1. **Data Issues**: Check source datasets, verify XPT files are not corrupted
2. **Document Issues**: Update Protocol/SAP/Mocks to align
3. **Analysis Issues**: Verify TLF programs match SAP specifications
4. **Re-run validation** after fixes

---

## Sign-off

| Role | Name | Date | Status |
|------|------|------|--------|
| Validation Lead | | | ⬜ Pending |
| Quality Assurance | | | ⬜ Pending |
| Project Lead | | | ⬜ Pending |

---

*Validation Directory v1.0*
