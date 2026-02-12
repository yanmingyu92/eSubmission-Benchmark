# Raw Data Documentation

## Overview

This document describes the raw data available and the approach for completing missing raw datasets for the eSubmission Benchmark Package.

---

## Available Raw Data (from pharmaverseraw)

| Dataset | File | Variables | Status |
|---------|------|-----------|--------|
| dm_raw | dm_raw.rda | 13 | ✅ Available |
| ae_raw | ae_raw.rda | 32 | ✅ Available |
| ds_raw | ds_raw.rda | 13 | ✅ Available |
| ec_raw | ec_raw.rda | 14 | ✅ Available |
| vs_raw | vs_raw.rda | 15 | ✅ Available |

---

## Missing Raw Data

| Dataset | SDTM Source | Variables Needed | Status |
|---------|-------------|------------------|--------|
| lb_raw | LB | ~20-30 | ❌ Not available |
| mh_raw | MH | ~15-20 | ❌ Not available |
| cm_raw | CM | ~20-25 | ❌ Not available |
| qs_raw | QS | ~25-35 | ❌ Not available |

---

## Approach for Completing Raw Data

### Option 1: Reverse Engineering from SDTM

Raw data can be reverse-engineered from SDTM datasets by:
1. Removing SDTM-specific derived variables
2. Renaming variables to raw format (e.g., LBTESTCD → IT.LBTEST)
3. Adding EDC-style metadata (FOLDER, INSTANCE, etc.)
4. Introducing realistic data collection artifacts

### Option 2: Simulation

Generate synthetic raw data based on:
1. SDTM data structure and constraints
2. Typical EDC data collection patterns
3. Realistic data quality issues

---

## Raw Data Variable Mapping

### lb_raw (Laboratory)

| Raw Variable | SDTM Variable | Description |
|--------------|---------------|-------------|
| STUDY | STUDYID | Study Identifier |
| PATNUM | SUBJID | Subject Number |
| VISITNAME | VISIT | Visit Name |
| FOLDER | - | EDC Folder |
| IT.LBTEST | LBTEST | Lab Test Name |
| IT.LBORRES | LBORRES | Original Result |
| IT.LBORRESU | LBORRESU | Original Units |
| IT.LBLLO | - | Lower Limit of Normal |
| IT.LBULO | - | Upper Limit of Normal |
| DTCOL | LBDTC | Collection Date/Time |

### mh_raw (Medical History)

| Raw Variable | SDTM Variable | Description |
|--------------|---------------|-------------|
| STUDY | STUDYID | Study Identifier |
| PATNUM | SUBJID | Subject Number |
| IT.MHTERM | MHTERM | Medical History Term |
| IT.MHBODSYS | MHBODSYS | Body System |
| IT.MHSTDAT | MHSTDTC | Start Date |
| IT.MHENDAT | MHENDTC | End Date |
| DTCOL | - | Data Collection Date |

### cm_raw (Concomitant Medications)

| Raw Variable | SDTM Variable | Description |
|--------------|---------------|-------------|
| STUDY | STUDYID | Study Identifier |
| PATNUM | SUBJID | Subject Number |
| IT.CMTRT | CMTRT | Medication Name |
| IT.CMINDC | CMINDC | Indication |
| IT.CMDOSE | CMDOSE | Dose |
| IT.CMDOSU | CMDOSU | Dose Unit |
| IT.CMFRQ | CMFRQ | Frequency |
| IT.CMROUTE | CMROUTE | Route |
| IT.CMSTDAT | CMSTDTC | Start Date |
| IT.CMENDAT | CMENDTC | End Date |

### qs_raw (Questionnaires)

| Raw Variable | SDTM Variable | Description |
|--------------|---------------|-------------|
| STUDY | STUDYID | Study Identifier |
| PATNUM | SUBJID | Subject Number |
| VISITNAME | VISIT | Visit Name |
| IT.QSTEST | QSTEST | Question/Test Name |
| IT.QSORRES | QSORRES | Original Response |
| IT.QSSTRESN | QSSTRESN | Numeric Result |
| DTCOL | QSDTC | Assessment Date |

---

## Notes

1. Raw data format is intentionally "messy" to represent real EDC exports
2. Variable names follow EDC conventions (IT.* for item variables)
3. Dates may be partial or in various formats
4. Some values may be missing or require mapping

---

## Files

| File | Description |
|------|-------------|
| raw_data_specification.xlsx | Detailed variable specifications |
| create_lb_raw.R | Script to create lb_raw from SDTM |
| create_mh_raw.R | Script to create mh_raw from SDTM |
| create_cm_raw.R | Script to create cm_raw from SDTM |
| create_qs_raw.R | Script to create qs_raw from SDTM |

---

*Documentation for eSubmission Benchmark Package*
