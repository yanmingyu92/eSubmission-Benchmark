# ADaM Specifications Document

## CDISCPilot01 - ADaM Dataset Specifications

**Version:** 1.0
**Date:** 2026-02-12
**Standard:** ADaM IG v1.1

---

## 1. Document Purpose

This document provides specifications for all ADaM datasets included in the eSubmission Benchmark package. Specifications are derived from define.xml and aligned with the Statistical Analysis Plan.

---

## 2. Dataset Inventory

| Dataset | Label | Class | Records | File |
|---------|-------|-------|---------|------|
| ADSL | Subject-Level Analysis Dataset | SUBJECT LEVEL | 254 | adsl.xpt |
| ADAE | Adverse Events Analysis Dataset | OCCURRENCE | 1,191 | adae.xpt |
| ADADAS | ADAS-Cog Analysis Dataset | BDS | 2,718 | adadas.xpt |
| ADLBC | Lab Chemistry Analysis Dataset | BDS | 7,778 | adlbc.xpt |
| ADTTE | Time-to-Event Analysis Dataset | TTE | 254 | adtte.xpt |

---

## 3. Dataset Specifications

### 3.1 ADSL - Subject-Level Analysis Dataset

**Label:** Subject-Level Analysis Dataset
**Class:** SUBJECT LEVEL
**Structure:** One record per subject
**Key Variables:** STUDYID, USUBJID

| Variable | Label | Type | Length | Origin | Notes |
|----------|-------|------|--------|--------|-------|
| STUDYID | Study Identifier | Char | 12 | SDTM.DM | CDISCPILOT01 |
| USUBJID | Unique Subject Identifier | Char | 11 | SDTM.DM | XX-XXX-XXXX |
| SUBJID | Subject Identifier for the Study | Char | 4 | SDTM.DM | Subject number |
| SITEID | Study Site Identifier | Char | 3 | SDTM.DM | Site number |
| SITEGR1 | Pooled Site Group 1 | Char | 3 | Derived | Small sites pooled |
| TRT01PN | Planned Treatment for Period 01 (N) | Num | 8 | SDTM.DM | 0, 54, 81 |
| TRT01P | Planned Treatment for Period 01 | Char | 22 | SDTM.DM | Treatment description |
| TRT01AN | Actual Treatment for Period 01 (N) | Num | 8 | SDTM.DM | 0, 54, 81 |
| TRT01A | Actual Treatment for Period 01 | Char | 22 | SDTM.DM | Treatment description |
| TRTSDT | Date of First Exposure to Treatment | Num | 8 | SDTM.EX | SAS date |
| TRTEDT | Date of Last Exposure to Treatment | Num | 8 | SDTM.EX | SAS date |
| AGE | Age | Num | 8 | SDTM.DM | Age in years |
| AGEGR1 | Pooled Age Group 1 | Char | 5 | Derived | <65, 65-80, >80 |
| AGEGR1N | Pooled Age Group 1 (N) | Num | 8 | Derived | 1, 2, 3 |
| RACE | Race | Char | 40 | SDTM.DM | Race category |
| RACEN | Race (N) | Num | 8 | Derived | Numeric code |
| SEX | Sex | Char | 1 | SDTM.DM | M, F |
| HEIGHTBL | Height at Baseline (cm) | Num | 8 | SDTM.VS | Baseline height |
| WEIGHTBL | Weight at Baseline (kg) | Num | 8 | SDTM.VS | Baseline weight |
| BMIBL | BMI at Baseline (kg/m²) | Num | 8 | Derived | Baseline BMI |
| MMSETOT | MMSE Total | Num | 8 | SDTM.QS | MMSE score |
| ITTFL | Intent-to-Treat Population Flag | Char | 1 | Derived | Y, N |
| SAFFL | Safety Population Flag | Char | 1 | Derived | Y, N |
| EFFFL | Efficacy Population Flag | Char | 1 | Derived | Y, N |
| COMP24FL | Completers of Week 24 Population Flag | Char | 1 | Derived | Y, N |
| DISCONFL | Did Subject Discontinue? | Char | 1 | Derived | Y, N |
| DSRAEFL | Discontinued due to AE? | Char | 1 | Derived | Y, N |
| DCSREAS | Reason for Discontinuation | Char | 40 | SDTM.DS | Disposition reason |
| EOSDT | End of Study Date | Num | 8 | SDTM.DS | SAS date |
| EOSSTT | End of Study Status | Char | 14 | Derived | COMPLETED, DISCONTINUED |

---

### 3.2 ADADAS - ADAS-Cog Analysis Dataset

**Label:** ADAS-Cog (11) Analysis Dataset
**Class:** BASIC DATA STRUCTURE (BDS)
**Structure:** One or more records per subject per analysis parameter per analysis timepoint
**Key Variables:** STUDYID, USUBJID, PARAMCD, AVISITN

| Variable | Label | Type | Length | Origin | Notes |
|----------|-------|------|--------|--------|-------|
| STUDYID | Study Identifier | Char | 12 | ADSL | CDISCPILOT01 |
| USUBJID | Unique Subject Identifier | Char | 11 | ADSL | XX-XXX-XXXX |
| PARAMCD | Parameter Code | Char | 6 | Assigned | ACTOT |
| PARAM | Parameter | Char | 40 | Assigned | ADAS-COG (11) Total Score |
| AVAL | Analysis Value | Num | 8 | SDTM.QS | Analysis result |
| AVALC | Analysis Value (C) | Char | 20 | Derived | Character result |
| BASE | Baseline Value | Num | 8 | Derived | Baseline AVAL |
| CHG | Change from Baseline | Num | 8 | Derived | AVAL - BASE |
| PCHG | Percent Change from Baseline | Num | 8 | Derived | 100 * CHG / BASE |
| AVISIT | Analysis Visit | Char | 20 | SDTM.QS | Visit description |
| AVISITN | Analysis Visit (N) | Num | 8 | Derived | Numeric visit code |
| ADT | Analysis Date | Num | 8 | SDTM.QS | SAS date |
| ADY | Analysis Relative Day | Num | 8 | SDTM.QS | Relative to TRTSDT |
| AWTARGET | Analysis Window Target Days | Num | 8 | Derived | Target day |
| AWLO | Analysis Window Lower Days | Num | 8 | Derived | Lower bound |
| AWHI | Analysis Window Upper Days | Num | 8 | Derived | Upper bound |
| AWTDIFF | Analysis Window Target Diff | Num | 8 | Derived | Difference from target |
| DTYPE | Derivation Type | Char | 4 | Derived | LOCF if imputed |
| ANL01FL | Analysis Flag 01 | Char | 1 | Derived | Y for analysis |
| ITTFL | Intent-to-Treat Population Flag | Char | 1 | ADSL | Y, N |
| EFFFL | Efficacy Population Flag | Char | 1 | ADSL | Y, N |
| TRTP | Planned Treatment | Char | 22 | ADSL | Treatment description |
| TRTPN | Planned Treatment (N) | Num | 8 | ADSL | 0, 54, 81 |
| TRTA | Actual Treatment | Char | 22 | ADSL | Treatment description |
| TRTAN | Actual Treatment (N) | Num | 8 | ADSL | 0, 54, 81 |

#### Parameter Definitions

| PARAMCD | PARAM | Description |
|---------|-------|-------------|
| ACTOT | ADAS-COG (11) Total Score | Total score across 11 items |
| ACITM01 | Word Recall | Item 1 score |
| ACITM02 | Naming Objects and Fingers | Item 2 score |
| ... | ... | ... |

#### Visit Windowing

| AVISIT | AVISITN | AWTARGET | AWLO | AWHI |
|--------|---------|----------|------|------|
| Baseline | 0 | 0 | 0 | 0 |
| Week 8 | 8 | 56 | 42 | 69 |
| Week 16 | 16 | 112 | 98 | 125 |
| Week 24 | 24 | 168 | 154 | 196 |

---

### 3.3 ADAE - Adverse Events Analysis Dataset

**Label:** Adverse Events Analysis Dataset
**Class:** OCCURRENCE
**Structure:** One record per adverse event per subject
**Key Variables:** STUDYID, USUBJID, AESEQ

| Variable | Label | Type | Length | Origin | Notes |
|----------|-------|------|--------|--------|-------|
| STUDYID | Study Identifier | Char | 12 | ADSL | CDISCPILOT01 |
| USUBJID | Unique Subject Identifier | Char | 11 | ADSL | XX-XXX-XXXX |
| AESEQ | Sequence Number | Num | 8 | SDTM.AE | From SDTM |
| AETERM | Reported Term for the Adverse Event | Char | 200 | SDTM.AE | Verbatim term |
| AEDECOD | Dictionary-Derived Term | Char | 100 | SDTM.AE | MedDRA PT |
| AEBODSYS | Body System or Organ Class | Char | 67 | SDTM.AE | MedDRA SOC |
| AESER | Serious Event | Char | 1 | SDTM.AE | Y, N |
| AESEV | Severity/Intensity | Char | 9 | SDTM.AE | MILD, MODERATE, SEVERE |
| AEREL | Causality | Char | 20 | SDTM.AE | Relationship |
| AEOUT | Outcome of Adverse Event | Char | 20 | SDTM.AE | Outcome |
| TRTEMFL | Treatment Emergent Analysis Flag | Char | 1 | Derived | Y, N |
| ASTDT | Analysis Start Date | Num | 8 | Derived | SAS date |
| AENDT | Analysis End Date | Num | 8 | Derived | SAS date |
| ASTDY | Analysis Start Relative Day | Num | 8 | Derived | Relative to TRTSDT |
| AENDY | Analysis End Relative Day | Num | 8 | Derived | Relative to TRTSDT |
| AOCC01FL | 1st Occurrence of Any AE Flag | Char | 1 | Derived | Y, N |
| AOCC02FL | 1st Occurrence of Serious AE Flag | Char | 1 | Derived | Y, N |
| AOCCSFL | 1st Occurrence of SOC AE Flag | Char | 1 | Derived | Y, N |
| CQ01NAM | Customized Query 01 Name | Char | 40 | Derived | DERMATOLOGIC EVENTS |
| ITTFL | Intent-to-Treat Population Flag | Char | 1 | ADSL | Y, N |
| SAFFL | Safety Population Flag | Char | 1 | ADSL | Y, N |
| TRTP | Planned Treatment | Char | 22 | ADSL | Treatment description |
| TRTPN | Planned Treatment (N) | Num | 8 | ADSL | 0, 54, 81 |
| TRTA | Actual Treatment | Char | 22 | ADSL | Treatment description |
| TRTAN | Actual Treatment (N) | Num | 8 | ADSL | 0, 54, 81 |

---

### 3.4 ADLBC - Lab Chemistry Analysis Dataset

**Label:** Analysis Dataset Lab Blood Chemistry
**Class:** BASIC DATA STRUCTURE (BDS)
**Structure:** One or more records per subject per analysis parameter per analysis timepoint
**Key Variables:** STUDYID, USUBJID, PARAMCD, AVISITN

| Variable | Label | Type | Length | Origin | Notes |
|----------|-------|------|--------|--------|-------|
| STUDYID | Study Identifier | Char | 12 | ADSL | CDISCPILOT01 |
| USUBJID | Unique Subject Identifier | Char | 11 | ADSL | XX-XXX-XXXX |
| PARAMCD | Parameter Code | Char | 8 | SDTM.LB | Test code |
| PARAM | Parameter | Char | 40 | SDTM.LB | Test name |
| AVAL | Analysis Value | Num | 8 | SDTM.LB | Analysis result |
| AVALC | Analysis Value (C) | Char | 20 | Derived | Character result |
| BASE | Baseline Value | Num | 8 | Derived | Baseline AVAL |
| CHG | Change from Baseline | Num | 8 | Derived | AVAL - BASE |
| PCHG | Percent Change from Baseline | Num | 8 | Derived | 100 * CHG / BASE |
| ANRLO | Analysis Range Lower Limit | Num | 8 | SDTM.LB | Lower limit |
| ANRHI | Analysis Range Upper Limit | Num | 8 | SDTM.LB | Upper limit |
| ANRIND | Analysis Range Indicator | Char | 10 | Derived | LOW, NORMAL, HIGH |
| R2A1LO | Ratio to ULN | Num | 8 | Derived | AVAL / ANRHI |
| ADT | Analysis Date | Num | 8 | SDTM.LB | SAS date |
| AVISIT | Analysis Visit | Char | 20 | SDTM.LB | Visit description |
| AVISITN | Analysis Visit (N) | Num | 8 | Derived | Numeric visit code |
| AVALCAT1 | Analysis Value Category 1 | Char | 20 | Derived | Categorical |
| ANL01FL | Analysis Flag 01 | Char | 1 | Derived | Y for analysis |
| ITTFL | Intent-to-Treat Population Flag | Char | 1 | ADSL | Y, N |
| SAFFL | Safety Population Flag | Char | 1 | ADSL | Y, N |
| TRTP | Planned Treatment | Char | 22 | ADSL | Treatment description |
| TRTPN | Planned Treatment (N) | Num | 8 | ADSL | 0, 54, 81 |

---

### 3.5 ADTTE - Time-to-Event Analysis Dataset

**Label:** AE Time To 1st Derm. Event Analysis
**Class:** TIME-TO-EVENT
**Structure:** One record per subject per parameter
**Key Variables:** STUDYID, USUBJID, PARAMCD

| Variable | Label | Type | Length | Origin | Notes |
|----------|-------|------|--------|--------|-------|
| STUDYID | Study Identifier | Char | 12 | ADSL | CDISCPILOT01 |
| USUBJID | Unique Subject Identifier | Char | 11 | ADSL | XX-XXX-XXXX |
| PARAMCD | Parameter Code | Char | 4 | Assigned | TTDE |
| PARAM | Parameter | Char | 40 | Assigned | Time to First Dermatologic Event |
| AVAL | Analysis Value | Num | 8 | Derived | Time in days |
| CNSR | Censor | Num | 8 | Derived | 0=event, 1=censored |
| STARTDT | Start Date | Num | 8 | ADSL | TRTSDT |
| ADT | Analysis Date | Num | 8 | Derived | Event/censor date |
| EVDESC1 | Event Description 1 | Char | 40 | Derived | Event description |
| ITTFL | Intent-to-Treat Population Flag | Char | 1 | ADSL | Y, N |
| SAFFL | Safety Population Flag | Char | 1 | ADSL | Y, N |
| TRTP | Planned Treatment | Char | 22 | ADSL | Treatment description |
| TRTPN | Planned Treatment (N) | Num | 8 | ADSL | 0, 54, 81 |
| TRTA | Actual Treatment | Char | 22 | ADSL | Treatment description |
| TRTAN | Actual Treatment (N) | Num | 8 | ADSL | 0, 54, 81 |

#### Censoring Rules

| CNSR | Description |
|------|-------------|
| 0 | Event occurred (first dermatologic AE) |
| 1 | Censored (no event by end of study) |

#### Event Definition

- Event = First occurrence of AE with CQ01NAM = "DERMATOLOGIC EVENTS"
- Censor = Study completion date if no event

---

## 4. Derivation Rules

### 4.1 Population Flags

| Flag | Derivation Rule |
|------|----------------|
| ITTFL | Y if ARMCD not equal to "Scrnfail" |
| SAFFL | Y if subject has at least one EX record |
| EFFFL | Y if ITTFL=Y and has post-baseline efficacy data |
| COMP24FL | Y if completed Week 24 visit |

### 4.2 Baseline Definition

- **ADADAS:** AVAL where AVISITN = 0
- **ADLBC:** AVAL where AVISITN = 0 and visit = Baseline

### 4.3 Change from Baseline

```
CHG = AVAL - BASE
PCHG = (CHG / BASE) * 100
```

### 4.4 Analysis Visit Derivation

| Raw Visit | Analysis Visit (AVISITN) |
|-----------|-------------------------|
| Screening | 0 (Baseline) |
| Week 2 | 2 |
| Week 4 | 4 |
| Week 8 | 8 |
| Week 12 | 12 |
| Week 16 | 16 |
| Week 20 | 20 |
| Week 24 | 24 |

### 4.5 LOCF Imputation

For ADADAS at Week 24:
- If Week 24 data missing, use last non-missing post-baseline value
- Set DTYPE = "LOCF" for imputed records

---

## 5. Analysis Method Reference

| Analysis | Dataset | Method | Reference |
|----------|---------|--------|-----------|
| Primary Efficacy | ADADAS | ANCOVA | SAP Section 8.1 |
| Safety: AE Summary | ADAE | Descriptive | SAP Section 8.3 |
| Safety: Lab Shift | ADLBC | Shift table | SAP Section 8.3 |
| Time to Event | ADTTE | Kaplan-Meier | SAP Section 8.4 |

---

## 6. Quality Rules

| Rule ID | Description | Severity |
|---------|-------------|----------|
| ADAM-001 | All ADSL subjects must exist in DM | Critical |
| ADAM-002 | TRT01PN must match ARMCD mapping | Critical |
| ADAM-003 | BASE must equal AVAL at baseline | High |
| ADAM-004 | CHG must equal AVAL - BASE | High |
| ADAM-005 | AVISITN must be derived correctly | High |
| ADAM-006 | Population flags must be logically consistent | Critical |

---

## 7. Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-02-12 | eSubmission Benchmark | Initial version |

---

*ADaM Specifications v1.0*
