# SDTM DATA REVIEWER'S GUIDE

## Protocol Number: CDISCPilot01

---

# SAFETY AND EFFICACY OF THE XANOMELINE TRANSDERMAL THERAPEUTIC SYSTEM (TTS) IN PATIENTS WITH MILD TO MODERATE ALZHEIMER'S DISEASE

---

| **Document Information** | |
|--------------------------|--------------------------|
| Protocol Number | CDISCPilot01 |
| SDRG Version | 1.0 |
| Date | [Document Date] |
| SDTM Version | 1.2 |
| SDTM IG Version | 3.1.2 |

---

## TABLE OF CONTENTS

1. Introduction
2. Study Overview
3. SDTM Implementation Notes
4. Domain Descriptions
5. Data Quality Notes
6. Reviewer Guidance
7. Contact Information

---

## 1. INTRODUCTION

### 1.1 Purpose

This SDTM Data Reviewer's Guide (SDRG) provides context for the Study Data Tabulation Model (SDTM) datasets submitted for Protocol CDISCPilot01. This document supplements the define.xml file by providing additional information about the study design, data collection, and SDTM implementation that may be useful for FDA reviewers.

### 1.2 Scope

This document covers:
- Study design and data collection overview
- SDTM implementation approach
- Domain-specific notes and clarifications
- Data quality considerations
- Guidance for using the submitted datasets

### 1.3 Standards Conformance

| Standard | Version |
|----------|---------|
| SDTM | 1.2 |
| SDTM Implementation Guide | 3.1.2 |
| SDTM Controlled Terminology | CDISC SDTM CT 2022-12-16 |
| Define-XML | 1.0 |
| MedDRA | 8.0 |
| WHO Drug | [Version] |

---

## 2. STUDY OVERVIEW

### 2.1 Protocol Summary

| Element | Description |
|---------|-------------|
| **Protocol Number** | CDISCPilot01 |
| **Protocol Title** | Safety and Efficacy of the Xanomeline Transdermal Therapeutic System (TTS) in Patients with Mild to Moderate Alzheimer's Disease |
| **Study Phase** | 2/3 |
| **Indication** | Alzheimer's Disease (Mild to Moderate) |
| **Study Design** | Prospective, randomized, multi-center, double-blind, placebo-controlled, parallel-group |
| **Number of Sites** | [Number] |
| **Planned Enrollment** | 300 subjects |
| **Treatment Duration** | 24 weeks |

### 2.2 Treatment Arms

| Arm Code | Arm Name | Description |
|----------|----------|-------------|
| 0 | Placebo | Placebo transdermal patch |
| 54 | Xanomeline Low Dose | Xanomeline 50 cm² TTS |
| 81 | Xanomeline High Dose | Xanomeline 75 cm² TTS |

### 2.3 Study Schema

```
                    SCREENING (up to 28 days)
                              |
                              v
                    BASELINE (Day 1)
                              |
                              v
              +---------------+---------------+
              |               |               |
              v               v               v
         PLACEBO      LOW DOSE         HIGH Dose
         (ARMCD=0)    (ARMCD=54)       (ARMCD=81)
              |               |               |
              +---------------+---------------+
                              |
                              v
                    TREATMENT PERIOD
                    (24 weeks)
                              |
                              v
                    FOLLOW-UP
                    (2 weeks)
```

### 2.4 Visit Schedule

| Visit | Study Day | Window | Description |
|-------|-----------|--------|-------------|
| Screening | -28 to -1 | - | Eligibility assessment |
| Baseline | 1 | - | Randomization, first dose |
| Week 2 | 14 | 1-20 | Safety assessment |
| Week 4 | 28 | 21-41 | Safety, efficacy |
| Week 8 | 56 | 42-69 | Safety, efficacy |
| Week 12 | 84 | 70-97 | Safety, efficacy |
| Week 16 | 112 | 98-125 | Safety, efficacy |
| Week 20 | 140 | 126-153 | Safety, efficacy |
| Week 24 | 168 | 154-196 | End of treatment |
| Follow-up | 182 | 175-210 | Safety follow-up |

---

## 3. SDTM IMPLEMENTATION NOTES

### 3.1 General Implementation Approach

#### 3.1.1 Subject Identifiers

| Variable | Description | Example |
|----------|-------------|---------|
| STUDYID | Study Identifier | CDISCPILOT01 |
| SITEID | Site Identifier | 701, 702, etc. |
| SUBJID | Subject Identifier within site | 001, 002, etc. |
| USUBJID | Unique Subject Identifier | CDISCPILOT01-701-001 |

**USUBID Format**: {STUDYID}-{SITEID}-{SUBJID}

#### 3.1.2 Date Handling

- All dates are provided in ISO 8601 format (YYYY-MM-DD or YYYY-MM-DDThh:mm:ss)
- Partial dates are represented with missing components omitted
- Study day variables (--DY) are derived per SDTM IG guidelines

#### 3.1.3 Treatment Variables

| SDTM Variable | Description |
|---------------|-------------|
| ARM | Description of Planned Arm |
| ARMCD | Planned Arm Code |
| ACTARM | Description of Actual Arm |
| ACTARMCD | Actual Arm Code |

All subjects received the treatment to which they were randomized; therefore, ARM = ACTARM and ARMCD = ACTARMCD for all subjects.

### 3.2 Supplemental Qualifiers (SUPP-- Domains)

The following supplemental qualifier domains are included:

| SUPP Domain | Parent Domain | Purpose |
|-------------|---------------|---------|
| SUPPDM | DM | Additional demographic variables |
| SUPPAE | AE | Additional adverse event information |
| SUPPDS | DS | Additional disposition information |
| SUPPLB | LB | Additional laboratory information |

### 3.3 Custom Domain Notes

No custom domains were created for this study. All domains follow CDISC SDTM standards.

---

## 4. DOMAIN DESCRIPTIONS

### 4.1 Special Purpose Domains

#### 4.1.1 DM - Demographics

| Key Variables | Description |
|---------------|-------------|
| USUBJID | Unique Subject Identifier |
| BRTHDTC | Date/Time of Birth |
| AGE | Age |
| AGEU | Age Units (YEARS) |
| SEX | Sex |
| RACE | Race |
| ETHNIC | Ethnicity |
| ARMCD | Planned Arm Code |
| ARM | Description of Planned Arm |
| ACTARMCD | Actual Arm Code |
| ACTARM | Description of Actual Arm |
| COUNTRY | Country |
| DMDTC | Date/Time of Collection |

**Notes**:
- Age is calculated as integer years at time of informed consent
- Race collected per protocol-defined categories

#### 4.1.2 DS - Disposition

| Key Variables | Description |
|---------------|-------------|
| USUBJID | Unique Subject Identifier |
| DSCAT | Category for Disposition |
| DSDECOD | Standardized Disposition Term |
| DSTERM | Reported Term for Disposition |
| DSSTDTC | Start Date/Time of Disposition Event |

**Disposition Categories**:
| DSCAT | Description |
|-------|-------------|
| DISPOSITION EVENT | Study completion/discontinuation |
| PROTOCOL MILESTONE | Protocol-defined milestones |

**Key Disposition Terms**:
| DSDECOD | Description |
|---------|-------------|
| COMPLETED | Subject completed the study |
| ADVERSE EVENT | Discontinued due to adverse event |
| WITHDRAWAL BY SUBJECT | Subject withdrew consent |
| STUDY TERMINATED BY SPONSOR | Sponsor terminated study |

### 4.2 Interventions Domains

#### 4.2.1 EX - Exposure

| Key Variables | Description |
|---------------|-------------|
| USUBJID | Unique Subject Identifier |
| EXTRT | Name of Actual Treatment |
| EXDOSE | Dose per Administration |
| EXDOSU | Dose Units |
| EXDOSFRM | Dose Form |
| EXROUTE | Route of Administration |
| EXSTDTC | Start Date/Time of Treatment |
| EXENDTC | End Date/Time of Treatment |
| EXSEQ | Sequence Number |

**Notes**:
- Transdermal route of administration
- Two patches applied daily
- Exposure collected per protocol schedule

#### 4.2.2 CM - Concomitant Medications

| Key Variables | Description |
|---------------|-------------|
| USUBJID | Unique Subject Identifier |
| CMDECOD | Standardized Medication Name |
| CMINDC | Indication |
| CMSTDTC | Start Date/Time |
| CMENDTC | End Date/Time |
| CMSEQ | Sequence Number |

**Notes**:
- Prior and concomitant medications collected
- Medications coded using WHO Drug Dictionary

#### 4.2.3 AE - Adverse Events

| Key Variables | Description |
|---------------|-------------|
| USUBJID | Unique Subject Identifier |
| AETERM | Reported Term for the Adverse Event |
| AEDECOD | Dictionary-Derived Term (MedDRA PT) |
| AEHLT | High Level Term |
| AEHLGT | High Level Group Term |
| AEBODSYS | Body System or Organ Class (MedDRA SOC) |
| AESEV | Severity/Intensity |
| AESER | Serious Event |
| AEREL | Causality |
| AEACN | Action Taken with Study Treatment |
| AEOUT | Outcome of Adverse Event |
| AESTDTC | Start Date/Time |
| AEENDTC | End Date/Time |
| AESEQ | Sequence Number |

**Notes**:
- Adverse events coded using MedDRA Version 8.0
- Severity graded as MILD, MODERATE, or SEVERE
- Seriousness criteria per ICH E2A guidelines

### 4.3 Events Domains

#### 4.3.1 MH - Medical History

| Key Variables | Description |
|---------------|-------------|
| USUBJID | Unique Subject Identifier |
| MHTERM | Reported Term for Medical History |
| MHDECOD | Dictionary-Derived Term |
| MHSTDTC | Start Date/Time |
| MHSEQ | Sequence Number |

**Notes**:
- Relevant medical history collected at screening
- Historical conditions coded using MedDRA

### 4.4 Findings Domains

#### 4.4.1 VS - Vital Signs

| Key Variables | Description |
|---------------|-------------|
| USUBJID | Unique Subject Identifier |
| VSTESTCD | Vital Signs Test Short Name |
| VSTEST | Vital Signs Test Name |
| VSORRES | Result or Finding in Original Units |
| VSORRESU | Original Units |
| VSSTRESC | Character Result/Finding in Standard Format |
| VSSTRESN | Numeric Result/Finding in Standard Units |
| VSSTRESU | Standard Units |
| VSLOC | Location Used for Measurement |
| VISIT | Visit Name |
| VISITNUM | Visit Number |
| VSDTC | Date/Time of Measurement |
| VSSEQ | Sequence Number |

**Vital Signs Tests**:
| VSTESTCD | VSTEST | VSSTRESU |
|----------|--------|----------|
| HEIGHT | Height | cm |
| WEIGHT | Weight | kg |
| TEMP | Temperature | C |
| pulse | Pulse Rate | beats/min |
| SYSBP | Systolic Blood Pressure | mmHg |
| DIABP | Diastolic Blood Pressure | mmHg |

#### 4.4.2 LB - Laboratory Tests

| Key Variables | Description |
|---------------|-------------|
| USUBJID | Unique Subject Identifier |
| LBCAT | Category for Lab Test |
| LBTESTCD | Lab Test Short Name |
| LBTEST | Lab Test Name |
| LBORRES | Result or Finding in Original Units |
| LBORRESU | Original Units |
| LBSTRESC | Character Result/Finding in Standard Format |
| LBSTRESN | Numeric Result/Finding in Standard Units |
| LBSTRESU | Standard Units |
| LBORNRLO | Reference Range Lower Limit in Orig Unit |
| LBORNRHI | Reference Range Upper Limit in Orig Unit |
| LBSTNRLO | Reference Range Lower Limit-Std Units |
| LBSTNRHI | Reference Range Upper Limit-Std Units |
| LBNRIND | Reference Range Indicator |
| VISIT | Visit Name |
| VISITNUM | Visit Number |
| LBDTC | Date/Time of Measurement |
| LBSEQ | Sequence Number |

**Laboratory Categories**:
| LBCAT | Description |
|-------|-------------|
| CHEMISTRY | Blood chemistry tests |
| HEMATOLOGY | Hematology tests |
| URINALYSIS | Urine analysis tests |
| OTHER | Other laboratory tests |

**Key Chemistry Tests**:
| LBTESTCD | LBTEST | LBSTRESU |
|----------|--------|----------|
| ALB | Albumin | g/L |
| ALP | Alkaline Phosphatase | U/L |
| ALT | Alanine Aminotransferase | U/L |
| AST | Aspartate Aminotransferase | U/L |
| BILI | Bilirubin | umol/L |
| BUN | Blood Urea Nitrogen | mmol/L |
| CREAT | Creatinine | umol/L |
| GLUC | Glucose | mmol/L |
| K | Potassium | mmol/L |
| SODIUM | Sodium | mmol/L |

#### 4.4.3 QS - Questionnaires

| Key Variables | Description |
|---------------|-------------|
| USUBJID | Unique Subject Identifier |
| QSCAT | Category of Questionnaire |
| QSSCAT | Subcategory of Questionnaire |
| QSTESTCD | Questionnaire Test Short Name |
| QSTEST | Questionnaire Test Name |
| QSORRES | Result or Finding in Original Format |
| QSSTRESC | Character Result/Finding in Standard Format |
| QSSTRESN | Numeric Result/Finding in Standard Units |
| VISIT | Visit Name |
| VISITNUM | Visit Number |
| QSDTC | Date/Time of Assessment |
| QSSEQ | Sequence Number |

**Questionnaire Categories**:
| QSCAT | Description |
|-------|-------------|
| ALZHEIMER'S DISEASE ASSESSMENT SCALE | ADAS-Cog assessment |
| CLINICAL GLOBAL IMPRESSION | CGI/CIBIC+ assessment |
| NEUROPSYCHIATRIC INVENTORY - REVISED (NPI-X) | NPI-X assessment |
| MINI MENTAL STATE EXAMINATION | MMSE assessment |

### 4.5 Trial Design Domains

#### 4.5.1 TA - Trial Arms

| Key Variables | Description |
|---------------|-------------|
| ARMCD | Planned Arm Code |
| ARM | Description of Planned Arm |
| TAETORD | Order of Element within Arm |
| ETCD | Element Code |
| ELEMENT | Description of Element |

**Trial Arms**:
| ARMCD | ARM |
|-------|-----|
| 0 | Placebo |
| 54 | Xanomeline Low Dose |
| 81 | Xanomeline High Dose |

#### 4.5.2 TE - Trial Elements

| Key Variables | Description |
|---------------|-------------|
| ETCD | Element Code |
| ELEMENT | Description of Element |
| TESTRL | Rule for Start of Element |
| TEENRL | Rule for End of Element |

#### 4.5.3 TV - Trial Visits

| Key Variables | Description |
|---------------|-------------|
| VISITNUM | Visit Number |
| VISIT | Visit Name |
| VISIONM | Visit Initialization Mapping |
| VISITDY | Planned Study Day of Visit |

#### 4.5.4 TS - Trial Summary

| Key Variables | Description |
|---------------|-------------|
| TSPARMCD | Trial Summary Parameter Short Name |
| TSPARM | Trial Summary Parameter |
| TSVAL | Parameter Value |

**Key Trial Summary Parameters**:
| TSPARMCD | TSPARM | TSVAL |
|----------|--------|-------|
| TITLE | Trial Title | Safety and Efficacy of Xanomeline... |
| TRTINDC | Treatment Indication | Alzheimer's Disease |
| TBLIND | Trial Blinding | DOUBLE BLIND |
| RANDOMIZ | Trial Randomization | RANDOMIZED |
| FCNTRL | Study Type | INTERVENTIONAL |

### 4.6 Relationship Domains

#### 4.6.1 RELREC - Related Records

Used to describe relationships between records in different domains.

#### 4.6.2 SUPPDM, SUPPAE, SUPPDS, SUPPLB - Supplemental Qualifiers

Provide additional variables not supported in parent domains.

---

## 5. DATA QUALITY NOTES

### 5.1 Data Validation

All SDTM datasets were validated against:
- CDISC SDTM IG 3.1.2 conformance rules
- Sponsor-defined validation checks
- Cross-domain consistency checks

### 5.2 Known Data Issues

| Issue | Domain | Description | Resolution |
|-------|--------|-------------|------------|
| None | - | No known data quality issues | - |

### 5.3 Data Derivations

#### 5.3.1 Study Day Derivation

Study day (--DY) variables are derived as:
- If date >= RFSTDTC: (date - RFSTDTC) + 1
- If date < RFSTDTC: (date - RFSTDTC)

#### 5.3.2 Age Derivation

Age is calculated as the integer number of years between birth date and informed consent date.

### 5.4 Missing Data Handling

- Missing dates are represented as null values in ISO 8601 format
- Partial dates retain available components
- Missing numeric values are represented as null

---

## 6. REVIEWER GUIDANCE

### 6.1 Getting Started

1. Review the define.xml for complete variable metadata
2. Start with DM domain to understand subject population
3. Review DS domain for subject disposition
4. Cross-reference with trial design domains (TA, TE, TV, TS)

### 6.2 Key Cross-Domain Relationships

| Relationship | Description |
|--------------|-------------|
| DM.USUBJID ↔ All domains | Subject identifier links all data |
| DM.ARM ↔ EX.EXTRT | Treatment assignment |
| EX.EXSTDTC ↔ AE.AESTDTC | Treatment-emergent AE determination |
| LB.LBDTC ↔ VS.VSDTC | Co-collected at same visit |

### 6.3 Subject Counts

| Population | Count |
|------------|-------|
| Screened | [Number] |
| Randomized | [Number] |
| Safety | [Number] |
| Completed | [Number] |

### 6.4 Using the Data

#### 6.4.1 Identifying Treatment Groups

```sql
-- Example: Select subjects by treatment arm
SELECT USUBJID, ARM, ARMCD
FROM DM
WHERE ARMCD IN ('0', '54', '81')
```

#### 6.4.2 Finding Treatment-Emergent Adverse Events

```sql
-- Example: Select treatment-emergent AEs
SELECT ae.USUBJID, ae.AETERM, ae.AESTDTC
FROM AE ae
INNER JOIN DM dm ON ae.USUBJID = dm.USUBJID
INNER JOIN EX ex ON ae.USUBJID = ex.USUBJID
WHERE ae.AESTDTC >= ex.EXSTDTC
```

#### 6.4.3 Laboratory Reference Ranges

Reference ranges are provided in LB domain:
- LBORNRLO/LBORNRHI: Original units
- LBSTNRLO/LBSTNRHI: Standard units
- LBNRIND: Reference range indicator (LOW, NORMAL, HIGH)

---

## 7. CONTACT INFORMATION

| Role | Name | Contact |
|------|------|---------|
| Sponsor | [Name] | [Email] |
| Medical Monitor | [Name] | [Email] |
| Biostatistician | [Name] | [Email] |
| Data Manager | [Name] | [Email] |

---

## APPENDIX A: DOMAIN INVENTORY

| Domain | Label | Class | Records |
|--------|-------|-------|---------|
| DM | Demographics | Special Purpose | [Count] |
| DS | Disposition | Special Purpose | [Count] |
| EX | Exposure | Interventions | [Count] |
| AE | Adverse Events | Interventions | [Count] |
| CM | Concomitant Medications | Interventions | [Count] |
| MH | Medical History | Events | [Count] |
| VS | Vital Signs | Findings | [Count] |
| LB | Laboratory Tests | Findings | [Count] |
| QS | Questionnaires | Findings | [Count] |
| SC | Subject Characteristics | Findings | [Count] |
| SV | Subject Visits | Trial Design | [Count] |
| TA | Trial Arms | Trial Design | [Count] |
| TE | Trial Elements | Trial Design | [Count] |
| TI | Trial Inclusion/Exclusion | Trial Design | [Count] |
| TS | Trial Summary | Trial Design | [Count] |
| TV | Trial Visits | Trial Design | [Count] |
| SE | Subject Elements | Trial Design | [Count] |
| RELREC | Related Records | Relationship | [Count] |
| SUPPDM | Supplemental DM | Relationship | [Count] |
| SUPPAE | Supplemental AE | Relationship | [Count] |
| SUPPDS | Supplemental DS | Relationship | [Count] |
| SUPPLB | Supplemental LB | Relationship | [Count] |

---

## APPENDIX B: FILE INVENTORY

| File Name | Description | Size |
|-----------|-------------|------|
| dm.xpt | Demographics | [Size] |
| ds.xpt | Disposition | [Size] |
| ex.xpt | Exposure | [Size] |
| ae.xpt | Adverse Events | [Size] |
| cm.xpt | Concomitant Medications | [Size] |
| mh.xpt | Medical History | [Size] |
| vs.xpt | Vital Signs | [Size] |
| lb.xpt | Laboratory Tests | [Size] |
| qs.xpt | Questionnaires | [Size] |
| sc.xpt | Subject Characteristics | [Size] |
| sv.xpt | Subject Visits | [Size] |
| ta.xpt | Trial Arms | [Size] |
| te.xpt | Trial Elements | [Size] |
| ti.xpt | Trial Inclusion/Exclusion | [Size] |
| ts.xpt | Trial Summary | [Size] |
| tv.xpt | Trial Visits | [Size] |
| se.xpt | Subject Elements | [Size] |
| relrec.xpt | Related Records | [Size] |
| suppae.xpt | Supplemental AE | [Size] |
| suppdm.xpt | Supplemental DM | [Size] |
| suppds.xpt | Supplemental DS | [Size] |
| supplb.xpt | Supplemental LB | [Size] |
| define.xml | Data Definitions | [Size] |
| define.pdf | Data Definitions (PDF) | [Size] |
| blankcrf.pdf | Annotated CRF | [Size] |

---

## DOCUMENT HISTORY

| Version | Date | Description |
|---------|------|-------------|
| 1.0 | [Date] | Initial version |

---

*This SDTM Data Reviewer's Guide is intended for use as part of the eSubmission Benchmark Package for educational and testing purposes only.*
