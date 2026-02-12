# SDTM Specifications Document

## CDISCPilot01 - SDTM Dataset Specifications

**Version:** 1.0
**Date:** 2026-02-12
**Standard:** SDTM IG v3.1.2

---

## 1. Document Purpose

This document provides specifications for all SDTM datasets included in the eSubmission Benchmark package. Specifications are derived from define.xml and CDISC standards.

---

## 2. Dataset Inventory

| Domain | Label | Class | Records | File |
|--------|-------|-------|---------|------|
| DM | Demographics | Special Purpose | 306 | dm.xpt |
| AE | Adverse Events | Events | 1,191 | ae.xpt |
| CM | Concomitant Medications | Interventions | 2,982 | cm.xpt |
| DS | Disposition | Special Purpose | 562 | ds.xpt |
| EX | Exposure | Interventions | 2,772 | ex.xpt |
| LB | Laboratory Tests | Findings | 54,828 | lb.xpt |
| MH | Medical History | Events | 1,116 | mh.xpt |
| QS | Questionnaires | Findings | 30,096 | qs.xpt |
| VS | Vital Signs | Findings | 7,024 | vs.xpt |
| SC | Subject Characteristics | Findings | 508 | sc.xpt |
| SV | Subject Visits | Trial Design | 3,640 | sv.xpt |
| SE | Subject Elements | Trial Design | 5,056 | se.xpt |
| TA | Trial Arms | Trial Design | 3 | ta.xpt |
| TE | Trial Elements | Trial Design | 3 | te.xpt |
| TI | Trial Inclusion/Exclusion | Trial Design | 6 | ti.xpt |
| TS | Trial Summary | Trial Design | 20 | ts.xpt |
| TV | Trial Visits | Trial Design | 17 | tv.xpt |
| RELREC | Related Records | Relationship | 30 | relrec.xpt |
| SUPPAE | Supplemental AE | Relationship | varies | suppae.xpt |
| SUPPDM | Supplemental DM | Relationship | varies | suppdm.xpt |
| SUPPDS | Supplemental DS | Relationship | varies | suppds.xpt |
| SUPPLB | Supplemental LB | Relationship | varies | supplb.xpt |

---

## 3. Domain Specifications

### 3.1 DM - Demographics

**Domain Label:** Demographics
**Class:** Special Purpose
**Structure:** One record per subject
**Key Variables:** STUDYID, USUBJID

| Variable | Label | Type | Length | Origin | Notes |
|----------|-------|------|--------|--------|-------|
| STUDYID | Study Identifier | Char | 12 | Assigned | Unique study identifier |
| DOMAIN | Domain Abbreviation | Char | 2 | Assigned | Fixed value: DM |
| USUBJID | Unique Subject Identifier | Char | 11 | Derived | Format: XX-XXX-XXXX |
| SUBJID | Subject Identifier | Char | 4 | Collected | Subject number within site |
| RFSTDTC | Subject Reference Start Date/Time | Char | 10 | Derived | First treatment date |
| RFENDTC | Subject Reference End Date/Time | Char | 10 | Derived | Last treatment date |
| RFXSTDTC | Date/Time of First Study Treatment | Char | 10 | Derived | First dose date |
| RFXENDTC | Date/Time of Last Study Treatment | Char | 10 | Derived | Last dose date |
| RFCICDTC | Date/Time of Last Informed Consent | Char | 10 | Collected | Consent date |
| SITEID | Study Site Identifier | Char | 3 | Collected | Site number |
| BRTHDTC | Date/Time of Birth | Char | 10 | Collected | Birth date (year only) |
| AGE | Age | Num | 8 | Derived | Age in years at consent |
| AGEU | Age Units | Char | 5 | Assigned | Fixed: YEARS |
| SEX | Sex | Char | 1 | Collected | M, F, U |
| RACE | Race | Char | 40 | Collected | Per protocol categories |
| ETHNIC | Ethnicity | Char | 25 | Collected | HISPANIC OR LATINO, NOT HISPANIC OR LATINO |
| ARMCD | Planned Arm Code | Char | 8 | Assigned | Pbo, Xan_Lo, Xan_Hi, Scrnfail |
| ARM | Description of Planned Arm | Char | 22 | Assigned | Placebo, Xanomeline Low Dose, etc. |
| ACTARMCD | Actual Arm Code | Char | 8 | Derived | Same as ARMCD |
| ACTARM | Description of Actual Arm | Char | 22 | Derived | Same as ARM |
| COUNTRY | Country | Char | 3 | Collected | USA |
| DMDTC | Date/Time of Collection | Char | 10 | Collected | Demographics collection date |
| DMDY | Study Day of Collection | Num | 8 | Derived | Relative to RFSTDTC |

---

### 3.2 AE - Adverse Events

**Domain Label:** Adverse Events
**Class:** Events
**Structure:** One record per adverse event per subject
**Key Variables:** STUDYID, USUBJID, AESEQ

| Variable | Label | Type | Length | Origin | Notes |
|----------|-------|------|--------|--------|-------|
| STUDYID | Study Identifier | Char | 12 | Assigned | CDISCPILOT01 |
| DOMAIN | Domain Abbreviation | Char | 2 | Assigned | Fixed: AE |
| USUBJID | Unique Subject Identifier | Char | 11 | Derived | Format: XX-XXX-XXXX |
| AESEQ | Sequence Number | Num | 8 | Derived | Sequential per USUBJID |
| AESPID | Sponsor-Defined Identifier | Char | 10 | Assigned | Internal reference |
| AETERM | Reported Term for the Adverse Event | Char | 200 | Collected | Verbatim term |
| AELLT | Lowest Level Term | Char | 100 | Assigned | MedDRA LLT |
| AELLTCD | Lowest Level Term Code | Num | 8 | Assigned | MedDRA LLT code |
| AEDECOD | Dictionary-Derived Term | Char | 100 | Assigned | MedDRA PT |
| AEPTCD | Preferred Term Code | Num | 8 | Assigned | MedDRA PT code |
| AEHLT | High Level Term | Char | 100 | Assigned | MedDRA HLT |
| AEHLTCD | High Level Term Code | Num | 8 | Assigned | MedDRA HLT code |
| AEHLGT | High Level Group Term | Char | 100 | Assigned | MedDRA HLGT |
| AEHLGTCD | High Level Group Term Code | Num | 8 | Assigned | MedDRA HLGT code |
| AEBODSYS | Body System or Organ Class | Char | 67 | Assigned | MedDRA SOC |
| AEBDSYCD | Body System or Organ Class Code | Num | 8 | Assigned | MedDRA SOC code |
| AESOC | Standardized MedDRA Query | Char | 67 | Assigned | MedDRA SOC name |
| AESOCCD | Standardized MedDRA Query Code | Num | 8 | Assigned | MedDRA SOC code |
| AESEV | Severity/Intensity | Char | 9 | Collected | MILD, MODERATE, SEVERE |
| AESER | Serious Event | Char | 1 | Derived | Y, N |
| AEACN | Action Taken with Study Treatment | Char | 20 | Collected | DOSE NOT CHANGED, etc. |
| AEREL | Causality | Char | 20 | Collected | NONE, POSSIBLE, PROBABLE |
| AEOUT | Outcome of Adverse Event | Char | 20 | Collected | RECOVERED/RESOLVED, etc. |
| AESTDTC | Start Date/Time of Adverse Event | Char | 10 | Collected | ISO 8601 format |
| AEENDTC | End Date/Time of Adverse Event | Char | 10 | Collected | ISO 8601 format |
| AESTDY | Study Day of Start of Adverse Event | Num | 8 | Derived | Relative to RFSTDTC |
| AEENDY | Study Day of End of Adverse Event | Num | 8 | Derived | Relative to RFSTDTC |
| AESCAN | Involves Cancer | Char | 1 | Derived | Y, N |
| AESCNO | Congenital Anomaly or Birth Defect | Char | 1 | Derived | Y, N |
| AESDTH | Results in Death | Char | 1 | Derived | Y, N |
| AESHOSP | Requires or Prolongs Hospitalization | Char | 1 | Derived | Y, N |
| AESLIFE | Is Life Threatening | Char | 1 | Derived | Y, N |
| AESODIS | Important Medical Event | Char | 1 | Derived | Y, N |

---

### 3.3 EX - Exposure

**Domain Label:** Exposure
**Class:** Interventions
**Structure:** One record per dosing record per subject
**Key Variables:** STUDYID, USUBJID, EXSEQ

| Variable | Label | Type | Length | Origin | Notes |
|----------|-------|------|--------|--------|-------|
| STUDYID | Study Identifier | Char | 12 | Assigned | CDISCPILOT01 |
| DOMAIN | Domain Abbreviation | Char | 2 | Assigned | Fixed: EX |
| USUBJID | Unique Subject Identifier | Char | 11 | Derived | Format: XX-XXX-XXXX |
| EXSEQ | Sequence Number | Num | 8 | Derived | Sequential per USUBJID |
| EXTRT | Name of Actual Treatment | Char | 22 | Assigned | Treatment name |
| EXDOSE | Dose per Administration | Num | 8 | Collected | Dose amount |
| EXDOSU | Dose Units | Char | 5 | Assigned | mg |
| EXDOSFRM | Dose Form | Char | 20 | Assigned | PATCH |
| EXROUTE | Route of Administration | Char | 16 | Assigned | TRANSDERMAL |
| EXSTDTC | Start Date/Time of Treatment | Char | 10 | Collected | ISO 8601 |
| EXENDTC | End Date/Time of Treatment | Char | 10 | Collected | ISO 8601 |
| EXSTDY | Study Day of Start of Treatment | Num | 8 | Derived | Relative to RFSTDTC |
| EXENDY | Study Day of End of Treatment | Num | 8 | Derived | Relative to RFSTDTC |
| EXADJ | Reason for Dose Adjustment | Char | 60 | Collected | Adjustment reason |

---

### 3.4 LB - Laboratory Tests

**Domain Label:** Laboratory Test Results
**Class:** Findings
**Structure:** One record per lab test per visit per subject
**Key Variables:** STUDYID, USUBJID, LBSEQ

| Variable | Label | Type | Length | Origin | Notes |
|----------|-------|------|--------|--------|-------|
| STUDYID | Study Identifier | Char | 12 | Assigned | CDISCPILOT01 |
| DOMAIN | Domain Abbreviation | Char | 2 | Assigned | Fixed: LB |
| USUBJID | Unique Subject Identifier | Char | 11 | Derived | Format: XX-XXX-XXXX |
| LBSEQ | Sequence Number | Num | 8 | Derived | Sequential per USUBJID |
| LBCAT | Category for Lab Test | Char | 11 | Assigned | CHEMISTRY, HEMATOLOGY, URINALYSIS |
| LBSCAT | Subcategory for Lab Test | Char | 20 | Assigned | Subcategory |
| LBTESTCD | Lab Test Short Name | Char | 8 | Assigned | Test code |
| LBTEST | Lab Test Name | Char | 40 | Assigned | Full test name |
| LBORRES | Result in Original Units | Char | 20 | Collected | Original result |
| LBORRESU | Original Units | Char | 10 | Collected | Original unit |
| LBORNRLO | Reference Range Lower Limit in Orig Unit | Num | 8 | Assigned | Lower limit |
| LBORNRHI | Reference Range Upper Limit in Orig Unit | Num | 8 | Assigned | Upper limit |
| LBSTRESC | Character Result/Finding in Std Format | Char | 20 | Derived | Standardized result (char) |
| LBSTRESN | Numeric Result/Finding in Standard Units | Num | 8 | Derived | Standardized result (numeric) |
| LBSTRESU | Standard Units | Char | 10 | Assigned | Standard unit |
| LBSTNRLO | Reference Range Lower Limit-Std Units | Num | 8 | Derived | Standard lower limit |
| LBSTNRHI | Reference Range Upper Limit-Std Units | Num | 8 | Derived | Standard upper limit |
| LBNRIND | Reference Range Indicator | Char | 10 | Derived | LOW, NORMAL, HIGH |
| LBFAST | Fasting Status | Char | 1 | Collected | Y, N |
| VISITNUM | Visit Number | Num | 8 | Assigned | Numeric visit code |
| VISIT | Visit Name | Char | 20 | Assigned | Visit description |
| VISITDY | Planned Study Day of Visit | Num | 8 | Assigned | Planned day |
| LBDTC | Date/Time of Specimen Collection | Char | 10 | Collected | ISO 8601 |
| LBDY | Study Day of Specimen Collection | Num | 8 | Derived | Relative to RFSTDTC |

---

### 3.5 QS - Questionnaires

**Domain Label:** Questionnaires
**Class:** Findings
**Structure:** One record per questionnaire item per visit per subject
**Key Variables:** STUDYID, USUBJID, QSSEQ

| Variable | Label | Type | Length | Origin | Notes |
|----------|-------|------|--------|--------|-------|
| STUDYID | Study Identifier | Char | 12 | Assigned | CDISCPILOT01 |
| DOMAIN | Domain Abbreviation | Char | 2 | Assigned | Fixed: QS |
| USUBJID | Unique Subject Identifier | Char | 11 | Derived | Format: XX-XXX-XXXX |
| QSSEQ | Sequence Number | Num | 8 | Derived | Sequential per USUBJID |
| QSCAT | Category of Questionnaire | Char | 40 | Assigned | ADAS-COG, CIBIC+, NPI-X, MMSE |
| QSSCAT | Subcategory of Questionnaire | Char | 40 | Assigned | Subcategory |
| QSTESTCD | Questionnaire Test Short Name | Char | 8 | Assigned | Test code |
| QSTEST | Questionnaire Test Name | Char | 200 | Assigned | Full test name |
| QSORRES | Result in Original Format | Char | 20 | Collected | Original response |
| QSSTRESC | Character Result in Standard Format | Char | 20 | Derived | Standardized result (char) |
| QSSTRESN | Numeric Result in Standard Units | Num | 8 | Derived | Standardized result (numeric) |
| QSDRVFL | Derived Flag | Char | 1 | Derived | Y if derived |
| VISITNUM | Visit Number | Num | 8 | Assigned | Numeric visit code |
| VISIT | Visit Name | Char | 20 | Assigned | Visit description |
| QSDTC | Date/Time of Assessment | Char | 10 | Collected | ISO 8601 |
| QSDY | Study Day of Assessment | Num | 8 | Derived | Relative to RFSTDTC |

---

## 4. Controlled Terminology

### Treatment Coding

| ARMCD | ARM | TRT01PN |
|-------|-----|---------|
| Pbo | Placebo | 0 |
| Xan_Lo | Xanomeline Low Dose | 54 |
| Xan_Hi | Xanomeline High Dose | 81 |
| Scrnfail | Screen Failure | N/A |

### Visit Coding

| VISITNUM | VISIT | Planned Day |
|----------|-------|--------------|
| 1 | SCREENING | -28 to -1 |
| 2 | BASELINE | 1 |
| 3 | WEEK 2 | 14 |
| 4 | WEEK 4 | 28 |
| 5 | WEEK 8 | 56 |
| 6 | WEEK 12 | 84 |
| 7 | WEEK 16 | 112 |
| 8 | WEEK 20 | 140 |
| 9 | WEEK 24 | 168 |
| 10 | FOLLOW-UP | 182 |

### Population Flags

| Flag | Description | Value |
|------|-------------|-------|
| ITTFL | Intent-to-Treat | Y/N |
| SAFFL | Safety | Y/N |
| EFFFL | Efficacy | Y/N |

---

## 5. Data Quality Rules

| Rule ID | Description | Severity |
|---------|-------------|----------|
| SDTM-001 | USUBJID format must be XX-XXX-XXXX | Critical |
| SDTM-002 | All required variables must be present | Critical |
| SDTM-003 | Date variables must be ISO 8601 format | High |
| SDTM-004 | Study day derivations must match protocol | High |
| SDTM-005 | Treatment codes must match TA domain | Critical |

---

## 6. Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-02-12 | eSubmission Benchmark | Initial version |

---

*SDTM Specifications v1.0*
