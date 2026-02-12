# SDTM Mapping Programs

## Overview

This directory contains R programs for creating SDTM datasets from raw data using the admiral package ecosystem.

---

## Program Inventory

| Program | Creates | Source | Status |
|---------|---------|--------|--------|
| create_dm.R | dm.xpt | dm_raw | Template |
| create_ae.R | ae.xpt | ae_raw | Template |
| create_vs.R | vs.xpt | vs_raw | Template |
| create_ex.R | ex.xpt | ec_raw | Template |
| create_ds.R | ds.xpt | ds_raw | Template |
| create_lb.R | lb.xpt | lb_raw | Template |
| create_mh.R | mh.xpt | mh_raw | Template |
| create_cm.R | cm.xpt | cm_raw | Template |
| create_qs.R | qs.xpt | qs_raw | Template |

---

## Dependencies

```r
# Core packages
library(admiral)      # SDTM/ADaM derivations
library(admiraldev)   # Development utilities
library(haven)        # XPT read/write
library(xportr)       # XPT export with CDISC compliance
library(dplyr)        # Data manipulation
library(tidyr)        # Data reshaping
library(lubridate)    # Date handling
library(stringr)      # String operations
```

---

## Execution Order

1. Trial Design domains (TA, TE, TI, TS, TV)
2. Subject-level domain (DM)
3. Subject visits (SV), Elements (SE)
4. Findings domains (VS, LB, QS)
5. Interventions domains (EX, CM, AE)
6. Events domains (MH, DS)
7. Supplemental domains (SUPPDM, SUPPAE, etc.)

---

## Notes

- These programs follow admiral package conventions
- Raw data should be in pharmaverseraw format
- Output follows SDTM IG v3.1.2

---

*SDTM Programs for eSubmission Benchmark Package*
