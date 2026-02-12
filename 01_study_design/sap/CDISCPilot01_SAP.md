# STATISTICAL ANALYSIS PLAN

## Protocol Number: CDISCPilot01

---

# SAFETY AND EFFICACY OF THE XANOMELINE TRANSDERMAL THERAPEUTIC SYSTEM (TTS) IN PATIENTS WITH MILD TO MODERATE ALZHEIMER'S DISEASE

---

| **Document Information** | |
|--------------------------|--------------------------|
| Protocol Number | CDISCPilot01 |
| SAP Version | 1.0 |
| Date | [Document Date] |
| Based on Protocol Version | 1.0 |

---

## TABLE OF CONTENTS

1. Introduction
2. Study Objectives and Endpoints
3. Analysis Populations
4. Statistical Methods
5. Analysis Datasets
6. Tables, Listings, and Figures Specifications
7. Interim Analysis
8. Changes from Protocol
9. References

---

## 1. INTRODUCTION

### 1.1 Purpose

This Statistical Analysis Plan (SAP) describes the statistical methods and procedures that will be used to analyze the efficacy and safety data collected in Protocol CDISCPilot01. This SAP is consistent with the protocol and provides more detailed specifications for the statistical analyses.

### 1.2 Study Overview

This is a Phase 2/3, prospective, randomized, multi-center, double-blind, placebo-controlled, parallel-group study to evaluate the safety and efficacy of the Xanomeline Transdermal Therapeutic System (TTS) in patients with mild to moderate Alzheimer's disease.

Approximately 300 subjects will be randomized in a 1:1:1 ratio to one of three treatment groups:
- Placebo
- Xanomeline Low Dose (50 cm² TTS)
- Xanomeline High Dose (75 cm² TTS)

The treatment period is 24 weeks with a 2-week follow-up period.

### 1.3 Study Design

| Design Element | Description |
|----------------|-------------|
| Study Type | Phase 2/3 |
| Design | Randomized, double-blind, placebo-controlled, parallel-group |
| Number of Arms | 3 |
| Randomization | 1:1:1 |
| Treatment Duration | 24 weeks |
| Total Study Duration | 26 weeks (including follow-up) |
| Planned Enrollment | 300 subjects |

---

## 2. STUDY OBJECTIVES AND ENDPOINTS

### 2.1 Primary Objective and Endpoint

| Objective | Endpoint | Type |
|-----------|----------|------|
| To evaluate the efficacy of xanomeline TTS compared to placebo on cognitive function | Change from baseline to Week 24 in ADAS-Cog (11) score | Primary Efficacy |

### 2.2 Secondary Objectives and Endpoints

| Objective | Endpoint | Type |
|-----------|----------|------|
| To evaluate global clinical improvement | CIBIC+ score at Week 24 | Secondary Efficacy |
| To evaluate behavioral symptoms | Change from baseline to Week 24 in NPI-X score | Secondary Efficacy |
| To evaluate safety | Adverse events, laboratory values, vital signs | Safety |

### 2.3 Endpoint Definitions

#### 2.3.1 ADAS-Cog (Alzheimer's Disease Assessment Scale - Cognitive Subscale)

The ADAS-Cog is an 11-item scale measuring cognitive function:
- Word Recall
- Naming Objects and Fingers
- Commands
- Constructional Praxis
- Ideational Praxis
- Orientation
- Word Recognition
- Remembering Test Instructions
- Spoken Language Ability
- Comprehension of Spoken Language
- Word-Finding Difficulty

Total score range: 0-70; higher scores indicate greater impairment.

**Primary Analysis Variable**: Change from baseline to Week 24 in total ADAS-Cog score (ACTOT)

#### 2.3.2 CIBIC+ (Clinician's Interview-Based Impression of Change with Caregiver Input)

A 7-point global assessment scale:
| Score | Description |
|-------|-------------|
| 1 | Very much improved |
| 2 | Much improved |
| 3 | Minimally improved |
| 4 | No change |
| 5 | Minimally worse |
| 6 | Much worse |
| 7 | Very much worse |

#### 2.3.3 NPI-X (Neuropsychiatric Inventory - Extended)

A 12-item caregiver-rated assessment of neuropsychiatric symptoms:
- Delusions
- Hallucinations
- Agitation/Aggression
- Depression/Dysphoria
- Anxiety
- Elation/Euphoria
- Apathy/Indifference
- Disinhibition
- Irritability/Lability
- Aberrant Motor Behavior
- Nighttime Behavior Disturbances
- Appetite/Eating Changes

---

## 3. ANALYSIS POPULATIONS

### 3.1 Definitions

| Population | Definition | Primary Use |
|------------|------------|-------------|
| **Intent-to-Treat (ITT)** | All randomized subjects, regardless of actual treatment received | Primary efficacy |
| **Efficacy** | ITT subjects with baseline and at least one post-baseline efficacy assessment | Primary efficacy analysis |
| **Safety** | All subjects who received at least one dose of study medication | Safety analyses |
| **Per-Protocol** | ITT subjects without major protocol violations | Supportive efficacy |

### 3.2 Population Flags

The following flags will be used in ADSL to define populations:

| Variable | Description |
|----------|-------------|
| ITTFL | Intent-to-Treat Population Flag (Y/N) |
| SAFFL | Safety Population Flag (Y/N) |
| EFFFL | Efficacy Population Flag (Y/N) |
| COMP24FL | Completers of Week 24 Flag (Y/N) |
| PPROTFL | Per-Protocol Population Flag (Y/N) |

### 3.3 Subject Disposition

Subject disposition will be summarized by treatment group:
- Number screened
- Number randomized
- Number discontinued (by reason)
- Number completed

---

## 4. STATISTICAL METHODS

### 4.1 Sample Size Justification

Based on previous studies with cholinergic agents in Alzheimer's disease:
- Expected treatment difference: 3 points on ADAS-Cog
- Standard deviation: 7 points
- Power: 80%
- Alpha: 0.05 (two-sided)

A sample size of 100 subjects per treatment group (300 total) provides adequate power to detect the expected treatment difference.

### 4.2 General Principles

#### 4.2.1 Analysis Sets
- Primary efficacy analyses will be performed on the Efficacy population
- All randomized subjects will be analyzed according to their assigned treatment group (ITT principle)
- Safety analyses will be performed on the Safety population

#### 4.2.2 Treatment Comparisons
- Each xanomeline dose group will be compared to placebo
- Xanomeline High Dose vs. Placebo
- Xanomeline Low Dose vs. Placebo
- Xanomeline High Dose vs. Xanomeline Low Dose

#### 4.2.3 Significance Level
- Two-sided alpha = 0.05 for primary endpoint
- No multiplicity adjustment for secondary endpoints (exploratory)

#### 4.2.4 Missing Data
- Primary analysis: Last Observation Carried Forward (LOCF)
- Sensitivity analyses: Mixed Model Repeated Measures (MMRM), Complete Case

### 4.3 Primary Efficacy Analysis

#### 4.3.1 Primary Endpoint

**Change from baseline to Week 24 in ADAS-Cog (11) total score**

#### 4.3.2 Analysis Method

**Analysis of Covariance (ANCOVA)**

Model specification:
```
CHG = TRTP + SITEGR1 + BASE
```

Where:
- CHG = Change from baseline in ADAS-Cog score
- TRTP = Planned treatment (categorical)
- SITEGR1 = Pooled site group
- BASE = Baseline ADAS-Cog score

**Statistical Tests:**
1. **Dose Response Test**: Test for non-zero coefficient for treatment as continuous variable
2. **Pairwise Comparisons**: Treatment as categorical factor
   - Least Squares (LS) Means
   - Difference of LS Means with Standard Error
   - 95% Confidence Intervals
   - P-values (unadjusted for multiple comparisons)

**Implementation Notes:**
- Use Type III Sum of Squares
- LS Means weighted proportionately (equivalent to SAS OM option)
- Contrasts set using sum-to-zero coding

#### 4.3.3 Data Requirements

| Variable | Dataset | Selection Criteria |
|----------|---------|-------------------|
| USUBJID | ADADAS | Unique subject identifier |
| PARAMCD | ADADAS | = 'ACTOT' (Total ADAS-Cog) |
| EFFFL | ADADAS | = 'Y' |
| ITTFL | ADADAS | = 'Y' |
| ANL01FL | ADADAS | = 'Y' (Analysis flag) |
| AVISITN | ADADAS | = 0 (Baseline) or 24 (Week 24) |

### 4.4 Secondary Efficacy Analyses

#### 4.4.1 CIBIC+ Analysis

- **Method**: Categorical analysis
- **Presentation**: Frequency and percentage by category
- **Comparison**: Shift analysis (Wilcoxon rank-sum or CMH test)

#### 4.4.2 NPI-X Analysis

- **Method**: ANCOVA (similar to primary endpoint)
- **Model**: CHG = TRTP + SITEGR1 + BASE
- **Output**: LS Means, differences, 95% CI, p-values

### 4.5 Safety Analyses

#### 4.5.1 Adverse Events

**Summary Tables:**
- Overview of adverse events
- Adverse events by System Organ Class and Preferred Term
- Serious adverse events
- Adverse events leading to discontinuation
- Adverse events by severity and relationship

**Analysis Variables (ADAE):**
| Variable | Description |
|----------|-------------|
| AEDECOD | Dictionary-derived term (MedDRA PT) |
| AEBODSYS | Body system (MedDRA SOC) |
| AESER | Serious event flag |
| AESEV | Severity |
| AEREL | Relationship to study drug |
| TRTEMFL | Treatment-emergent flag |

#### 4.5.2 Laboratory Data

- Summary statistics by visit and treatment
- Shift tables (low/normal/high)
- Out-of-range listings

#### 4.5.3 Vital Signs

- Summary statistics by visit and treatment
- Change from baseline
- Clinically significant changes

### 4.6 Demographic and Baseline Characteristics

Summary statistics by treatment group for:
- Age (continuous and categorical: <65, 65-80, >80)
- Sex
- Race
- Height, Weight, BMI at baseline
- MMSE total score

| Variable | Continuous Summary | Categorical Summary |
|----------|-------------------|---------------------|
| AGE | n, Mean (SD), Median, Min-Max | Category frequencies |
| AGEGR1 | - | <65, 65-80, >80 |
| SEX | - | Male, Female |
| RACE | - | By category |
| HEIGHTBL | n, Mean (SD), Median, Min-Max | - |
| WEIGHTBL | n, Mean (SD), Median, Min-Max | - |
| BMIBL | n, Mean (SD), Median, Min-Max | - |
| MMSETOT | n, Mean (SD), Median, Min-Max | - |

---

## 5. ANALYSIS DATASETS

### 5.1 ADaM Datasets

| Dataset | Label | Class | Purpose |
|---------|-------|-------|---------|
| ADSL | Subject-Level Analysis Dataset | SUBJECT LEVEL | Demographics, baseline, disposition |
| ADADAS | ADAS-Cog Analysis Dataset | BDS | Primary efficacy (cognitive) |
| ADCIBC | CIBIC+ Analysis Dataset | BDS | Secondary efficacy (global) |
| ADNPIX | NPI-X Analysis Dataset | BDS | Secondary efficacy (behavioral) |
| ADAE | Adverse Events Analysis Dataset | OCCURRENCE | Safety (adverse events) |
| ADLBC | Lab Chemistry Analysis Dataset | BDS | Safety (chemistry labs) |
| ADLBH | Lab Hematology Analysis Dataset | BDS | Safety (hematology labs) |
| ADVS | Vital Signs Analysis Dataset | BDS | Safety (vital signs) |
| ADTTE | Time-to-Event Analysis Dataset | TTE | Time to first dermatologic event |

### 5.2 Key Variables

#### 5.2.1 ADSL (Subject-Level)

| Variable | Label | Type |
|----------|-------|------|
| USUBJID | Unique Subject Identifier | Char |
| SITEID | Study Site Identifier | Char |
| SITEGR1 | Pooled Site Group 1 | Char |
| TRT01P | Planned Treatment for Period 01 | Char |
| TRT01PN | Planned Treatment for Period 01 (N) | Num |
| TRTSDT | Date of First Exposure to Treatment | Date |
| TRTEDT | Date of Last Exposure to Treatment | Date |
| AGE | Age | Num |
| AGEGR1 | Pooled Age Group 1 | Char |
| SEX | Sex | Char |
| RACE | Race | Char |
| HEIGHTBL | Height at Baseline (cm) | Num |
| WEIGHTBL | Weight at Baseline (kg) | Num |
| BMIBL | BMI at Baseline (kg/m²) | Num |
| MMSETOT | MMSE Total | Num |
| ITTFL | Intent-to-Treat Population Flag | Char |
| SAFFL | Safety Population Flag | Char |
| EFFFL | Efficacy Population Flag | Char |
| COMP24FL | Completers of Week 24 Population Flag | Char |

#### 5.2.2 ADADAS (ADAS-Cog)

| Variable | Label | Type |
|----------|-------|------|
| USUBJID | Unique Subject Identifier | Char |
| PARAMCD | Parameter Code | Char |
| PARAM | Parameter | Char |
| AVAL | Analysis Value | Num |
| BASE | Baseline Value | Num |
| CHG | Change from Baseline | Num |
| AVISIT | Analysis Visit | Char |
| AVISITN | Analysis Visit (N) | Num |
| DTYPE | Derivation Type | Char |
| ANL01FL | Analysis Flag 01 | Char |

---

## 6. TABLES, LISTINGS, AND FIGURES SPECIFICATIONS

### 6.1 TLF Overview

| TLF ID | Title | Population | Type |
|--------|-------|------------|------|
| 14-1.01 | Subject Disposition | ITT | Table |
| 14-1.02 | Protocol Deviations | ITT | Listing |
| 14-1.03 | Demographic and Baseline Characteristics | ITT | Table |
| 14-1.04 | Extent of Exposure | Safety | Table |
| 14-3.01 | Primary Endpoint Analysis: ADAS-Cog - Change from Baseline to Week 24 - LOCF | Efficacy | Table |
| 14-3.02 | CIBIC+ Results at Week 24 | Efficacy | Table |
| 14-3.03 | NPI-X Change from Baseline to Week 24 | Efficacy | Table |
| 14-3.04 | ADAS-Cog by Visit | Efficacy | Figure |
| 14-4.01 | Overview of Adverse Events | Safety | Table |
| 14-4.02 | Adverse Events by SOC and PT | Safety | Table |
| 14-4.03 | Serious Adverse Events | Safety | Table |
| 14-4.04 | Adverse Events Leading to Discontinuation | Safety | Table |
| 14-4.05 | Laboratory Results Over Time | Safety | Table |
| 14-4.06 | Vital Signs Over Time | Safety | Table |
| 14-5.01 | Kaplan-Meier Plot: Time to First Dermatologic Event | Safety | Figure |

### 6.2 Primary Efficacy Table Specification (14-3.01)

**Title**: Primary Endpoint Analysis: ADAS Cog (11) - Change from Baseline to Week 24 - LOCF

**Population**: Efficacy

**Layout**:

| Row Label | Placebo | Xanomeline Low Dose | Xanomeline High Dose |
|-----------|---------|---------------------|----------------------|
| **Baseline** | | | |
| n | xx | xx | xx |
| Mean (SD) | xx.x (xx.xx) | xx.x (xx.xx) | xx.x (xx.xx) |
| Median (Range) | xx.x (xxx;xx) | xx.x (xxx;xx) | xx.x (xxx;xx) |
| **Week 24** | | | |
| n | xx | xx | xx |
| Mean (SD) | xx.x (xx.xx) | xx.x (xx.xx) | xx.x (xx.xx) |
| Median (Range) | xx.x (xxx;xx) | xx.x (xxx;xx) | xx.x (xxx;xx) |
| **Change from Baseline** | | | |
| n | xx | xx | xx |
| Mean (SD) | xx.x (xx.xx) | xx.x (xx.xx) | xx.x (xx.xx) |
| Median (Range) | xx.x (xxx;xx) | xx.x (xxx;xx) | xx.x (xxx;xx) |
| **Statistical Analysis** | | | |
| p-value(Dose Response) [1][2] | | x.xxx | x.xxx |
| p-value(Xan - Placebo) [1][3] | | x.xxx | x.xxx |
| Diff of LS Means (SE) | | x.x (x.xx) | x.x (x.xx) |
| 95% CI | | (xx.x; x.x) | (xx.x; x.x) |
| p-value(Xan High - Xan Low) [1][3] | | | x.xxx |
| Diff of LS Means (SE) | | | x.x (x.xx) |
| 95% CI | | | (xx.x; x.x) |

**Footnotes**:
- [1] Based on Analysis of covariance (ANCOVA) model with treatment and site group as factors and baseline value as a covariate.
- [2] Test for a non-zero coefficient for treatment (dose) as a continuous variable
- [3] Pairwise comparison with treatment as a categorical variable: p-values without adjustment for multiple comparisons.

### 6.3 Demographic Table Specification (14-1.03)

**Title**: Summary of Demographic and Baseline Characteristics

**Population**: Intent-to-Treat

**Variables**:

| Variable | Statistics |
|----------|------------|
| Age (years) | n, Mean (SD), Median, Min - Max |
| Age Group, n (%) | <65, 65-80, >80 |
| Sex, n (%) | Male, Female |
| Race, n (%) | White, Black or African American, American Indian or Alaska Native |
| Height (cm) | n, Mean (SD), Median, Min - Max |
| Weight (kg) | n, Mean (SD), Median, Min - Max |
| BMI (kg/m²) | n, Mean (SD), Median, Min - Max |
| MMSE Total | n, Mean (SD), Median, Min - Max |

### 6.4 Kaplan-Meier Plot Specification (14-5.01)

**Title**: Time to First Dermatologic Adverse Event

**Population**: Safety

**Parameters**:
- Parameter: TTDE (Time to First Dermatologic Event)
- Event: First occurrence of dermatologic AE (CQ01NAM = "DERMATOLOGIC EVENTS")
- Censoring: Study completion or last observation

**Plot Elements**:
- Kaplan-Meier curves by treatment group
- Number at risk table
- Median time to event with 95% CI
- Log-rank test p-value

---

## 7. INTERIM ANALYSIS

No formal interim analysis is planned for this study.

A Data Safety Monitoring Board (DSMB) will review unblinded safety data at regular intervals, but no formal statistical stopping rules are defined.

---

## 8. CHANGES FROM PROTOCOL

This SAP is consistent with the protocol. Any deviations or additions will be documented here:

| Section | Description |
|---------|-------------|
| None | No changes from protocol |

---

## 9. REFERENCES

1. Protocol CDISCPilot01: Safety and Efficacy of the Xanomeline Transdermal Therapeutic System (TTS) in Patients with Mild to Moderate Alzheimer's Disease

2. CDISC ADaM Implementation Guide v1.1

3. CDISC SDTM Implementation Guide v3.1.2

4. FDA Guidance for Industry: E9 Statistical Principles for Clinical Trials

5. FDA Guidance for Industry: Enrichment Strategies for Clinical Trials

---

## APPENDIX A: ANALYSIS VISIT WINDOWS

| Visit | Target Day | Window | Analysis Visit |
|-------|-----------|--------|----------------|
| Baseline | 0 | - | Week 0 |
| Week 2 | 14 | 1-20 | Week 2 |
| Week 4 | 28 | 21-41 | Week 4 |
| Week 8 | 56 | 42-69 | Week 8 |
| Week 12 | 84 | 70-97 | Week 12 |
| Week 16 | 112 | 98-125 | Week 16 |
| Week 20 | 140 | 126-153 | Week 20 |
| Week 24 | 168 | 154-196 | Week 24 |

---

## APPENDIX B: SOFTWARE AND VERSIONS

| Software | Version | Purpose |
|----------|---------|---------|
| R | 4.1.3 | Primary analysis |
| admiral | 0.10.1 | ADaM dataset creation |
| Tplyr | 0.4.1 | Descriptive statistics |
| rtables | 0.3.8 | Table generation |
| pharmaRTF | 0.1.3 | RTF output |
| emmeans | 1.6.3 | LS means calculations |
| haven | 2.4.3 | XPT file handling |
| ggplot2 | 3.3.5 | Graphics |
| visR | 0.2.0 | Clinical visualizations |

---

## DOCUMENT HISTORY

| Version | Date | Description |
|---------|------|-------------|
| 1.0 | [Date] | Initial version |

---

## SIGNATURES

**Biostatistician:**

Name: _________________________
Date: _________________________
Signature: _________________________

**Medical Director:**

Name: _________________________
Date: _________________________
Signature: _________________________

---

*This Statistical Analysis Plan is intended for use as part of the eSubmission Benchmark Package for educational and testing purposes only.*
