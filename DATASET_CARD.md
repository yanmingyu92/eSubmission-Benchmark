# Dataset Card: eSubmission Benchmark

## Dataset Details

- **Name:** eSubmission Benchmark - CDISCPilot01
- **Version:** 1.0.0
- **Release Date:** 2026-02-12
- **License:** CC-BY-4.0
- **Citation:** See CITATION.cff

---

## Dataset Description

This benchmark contains clinical trial data for a simulated Alzheimer's Disease study, following CDISC SDTM v1.2 / ADaM v2.1 standards. The data is derived from the CDISC SDTM/ADaM Pilot Project and RConsortium FDA Submission Pilots.

### Study Overview

| Attribute | Value |
|------------|-------|
| Study ID | CDISCPilot01 |
| Phase | 2/3 |
| Indication | Alzheimer's Disease (Mild to Moderate) |
| Treatment | Xanomeline TTS (Transdermal Therapeutic System) |
| Design | Randomized, double-blind, placebo-controlled, parallel-group |
| Duration | 24 weeks treatment + 2 weeks follow-up |

### Subject Populations

| Population | N | Description |
|------------|---|-------------|
| Screened | 306 | All consented subjects |
| ITT | 254 | All randomized subjects |
| Safety | 254 | Received ≥1 dose |
| Efficacy | 234 | ITT + post-baseline efficacy data |

### Treatment Groups

| Group | N (ITT) | Treatment |
|-------|---------|-----------|
| Placebo | 86 | Placebo transdermal patch |
| Xanomeline Low | 84 | Xanomeline 50 cm² TTS |
| Xanomeline High | 84 | Xanomeline 75 cm² TTS |

---

## Dataset Structure

### SDTM Datasets (22 files)

| Domain | File | Records | Description |
|--------|------|---------|-------------|
| Demographics | dm.xpt | 306 | Subject demographics |
| Adverse Events | ae.xpt | 1,191 | Adverse event records |
| Concomitant Meds | cm.xpt | 2,982 | Concomitant medications |
| Disposition | ds.xpt | 562 | Subject disposition |
| Exposure | ex.xpt | 2,772 | Treatment exposure |
| Laboratory | lb.xpt | 54,828 | Laboratory test results |
| Medical History | mh.xpt | 1,116 | Medical history |
| Questionnaires | qs.xpt | 30,096 | Questionnaire responses |
| Vital Signs | vs.xpt | 7,024 | Vital signs measurements |
| Subject Visits | sv.xpt | 3,640 | Visit scheduling |
| Trial Design | ta.xpt, te.xpt, ti.xpt, ts.xpt, tv.xpt | 3-20 | Trial design metadata |
| Supplemental | suppae.xpt, suppdm.xpt, suppds.xpt, supplb.xpt | varies | Supplemental qualifiers |
| Related Records | relrec.xpt | 30 | Record relationships |
| Subject Characteristics | sc.xpt | 508 | Subject characteristics |
| Subject Elements | se.xpt | 5,056 | Subject element data |

### ADaM Datasets (5 files)

| Dataset | File | Records | Description |
|---------|------|---------|-------------|
| Subject-Level | adsl.xpt | 254 | One record per subject |
| Adverse Events | adae.xpt | 1,191 | AE analysis dataset |
| ADAS-Cog | adadas.xpt | 2,718 | Primary efficacy data |
| Lab Chemistry | adlbc.xpt | 7,778 | Chemistry lab analysis |
| Time-to-Event | adtte.xpt | 254 | Survival analysis data |

---

## Variable Specifications

### Subject Identifier

All datasets use a common subject identifier:

| Variable | Format | Example |
|----------|--------|---------|
| USUBJID | XX-XXX-XXXX | 01-701-1015 |

Pattern breakdown:
- First 2 digits: Study identifier (01)
- Middle 3 digits: Site identifier (701)
- Last 4 digits: Subject number (1015)

### Treatment Variables

| SDTM Variable | ADaM Variable | Values |
|---------------|---------------|--------|
| ARM | TRT01P | Placebo, Xanomeline Low Dose, Xanomeline High Dose |
| ARMCD | TRT01PN | Pbo/Xan_Lo/Xan_Hi → 0/54/81 |

### Population Flags (ADaM)

| Flag | Description | N |
|------|-------------|---|
| ITTFL | Intent-to-Treat | 254 |
| SAFFL | Safety | 254 |
| EFFFL | Efficacy | 234 |
| COMP24FL | Completed Week 24 | 223 |

---

## Data Standards

| Standard | Version |
|----------|---------|
| SDTM IG | 3.1.2 |
| SDTM Model | 1.2 |
| ADaM IG | 1.1 |
| ADaM Model | 2.1 |
| Define-XML | 2.0 |
| MedDRA | 8.0 |
| CT (SDTM) | 2022-12-16 |
| CT (ADaM) | 2022-06-24 |

---

## Data Lineage

```
Source Data                    Derived Data
────────────────────────────────────────────────
dm_raw.rda        ─────────→  dm.xpt (SDTM)
ae_raw.rda        ─────────→  ae.xpt (SDTM)
vs_raw.rda        ─────────→  vs.xpt (SDTM)
ec_raw.rda        ─────────→  ex.xpt (SDTM)
ds_raw.rda        ─────────→  ds.xpt (SDTM)
(pharmaverseraw)              (CDISC pilot)

dm.xpt            ─────────→  adsl.xpt (ADaM)
ae.xpt            ─────────→  adae.xpt (ADaM)
qs.xpt            ─────────→  adadas.xpt (ADaM)
lb.xpt            ─────────→  adlbc.xpt (ADaM)
adae.xpt          ─────────→  adtte.xpt (ADaM)
```

---

## Ground Truth Values

### Demographic Statistics (ITT Population)

| Metric | Placebo (N=86) | Low Dose (N=84) | High Dose (N=84) |
|--------|----------------|-----------------|------------------|
| Age Mean (SD) | 75.21 (8.59) | 75.67 (8.29) | 74.38 (7.89) |
| Age Median | 76 | 77.5 | 76 |
| Age Range | 52-89 | 51-88 | 56-88 |
| Female % | 58% | 58% | 57% |
| White % | 91% | 93% | 88% |
| BMI Mean (SD) | 23.64 (3.67) | 25.06 (4.27) | 25.35 (4.16) |

### Primary Endpoint (ADAS-Cog)

- **Population:** Efficacy (N=234)
- **Analysis:** ANCOVA with treatment, site, baseline
- **Missing Data:** LOCF imputation
- **LOCF Records:** 163 (at Week 24)

---

## Usage Examples

### Loading Data in R

```r
library(haven)

# Load SDTM
dm <- read_xpt("04_sdtm/datasets/dm.xpt")
ae <- read_xpt("04_sdtm/datasets/ae.xpt")

# Load ADaM
adsl <- read_xpt("05_adam/datasets/adsl.xpt")

# Filter ITT population
adsl_itt <- adsl[adsl$ITTFL == "Y", ]
```

### Loading Data in Python

```python
import pandas as pd
import pyreadstat

# Load SDTM
dm, meta = pyreadstat.read_xpt("04_sdtm/datasets/dm.xpt")
```

### Loading Data in SAS

```sas
libname sdtm xport "04_sdtm/datasets/dm.xpt";
proc contents data=sdtm.dm;
run;
```

---

## Validation

All datasets have been validated against:

1. **Subject counts** match across levels
2. **Treatment coding** consistent
3. **Population flags** logically consistent
4. **Statistics** match TLF ground truth

Run validation:
```r
source("08_validation/run_validation_v2.R")
```

---

## Limitations

1. **Synthetic Data:** Data is simulated for educational/testing purposes
2. **No Real Patient Information:** All subject identifiers are synthetic
3. **Partial Raw Data:** Some raw data files need to be reverse-engineered from SDTM
4. **Limited Domains:** Not all SDTM domains are included

---

## Ethical Considerations

- No real patient data is included
- All subject identifiers are synthetic
- Data is for development and testing only
- Not for clinical decision-making

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-02-12 | Initial release |

---

## Contact

For questions about the dataset:
- Open an issue on GitHub
- See main README for contact information

---

*Dataset Card v1.0*
