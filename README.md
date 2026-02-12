# eSubmission Benchmark

## A Comprehensive Clinical Trial Regulatory Submission Package for Research and Development

[![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)
[![Validation Status](https://img.shields.io/badge/Validation-PASSED-brightgreen.svg)](./08_validation/)
[![CDISC](https://img.shields.io/badge/CDISM-SDTM%2FADaM-blue.svg)](https://www.cdisc.org/)

---

## Abstract

The eSubmission Benchmark is a comprehensive, validated benchmark package for clinical trial regulatory submission development and testing. It provides a complete end-to-end submission package including study design documents, raw and derived data (SDTM/ADaM), TLF generation programs, and validation frameworks. This benchmark enables researchers, developers, and regulatory scientists to develop, test, and validate clinical trial analysis and submission tools using realistic, standards-compliant data.

**Keywords:** Clinical trial, Regulatory submission, CDISC, SDTM, ADaM, FDA, Benchmark, Reproducibility

---

## Citation

If you use this benchmark in your research, please cite:

```bibtex
@dataset{esub_benchmark_2026,
  title={eSubmission Benchmark: A Comprehensive Clinical Trial Regulatory Submission Package},
  author={Jaime Yan},
  year={2026},
  publisher={GitHub},
  version={1.0.0},
  doi={10.5281/zenodo.XXXXXX},
  url={https://github.com/yanmingyu92/esub-benchmark}
}
```

### Source Data Citations

This benchmark incorporates data and methodologies from the following sources:

```bibtex
@misc{cdisc_pilot,
  title={CDISC SDTM/ADaM Pilot Project},
  author={{Clinical Data Interchange Standards Consortium}},
  year={2013},
  howpublished={\url{https://github.com/cdisc-org/sdtm-adam-pilot-project}}
}

@misc{rconsortium_pilots,
  title={R Consortium FDA Submission Pilots},
  author={{R Consortium Submissions Working Group}},
  year={2024},
  howpublished={\url{https://github.com/RConsortium/submissions-wg}}
}

@misc{pharmaverseraw,
  title={pharmaverseraw: Raw Clinical Trial Data},
  author={{Pharmaverse}},
  year={2024},
  howpublished={\url{https://github.com/pharmaverse/pharmaverseraw}}
}

@misc{pharmaversesdtm,
  title={pharmaversesdtm: SDTM Test Data},
  author={{Pharmaverse}},
  year={2024},
  howpublished={\url{https://github.com/pharmaverse/pharmaversesdtm}}
}
```

---

## Table of Contents

1. [Introduction](#introduction)
2. [Benchmark Contents](#benchmark-contents)
3. [Installation](#installation)
4. [Usage](#usage)
5. [Validation Methodology](#validation-methodology)
6. [Quality Metrics](#quality-metrics)
7. [Data Description](#data-description)
8. [Reproducibility](#reproducibility)
9. [License](#license)
10. [Acknowledgments](#acknowledgments)

---

## Introduction

### Background

Regulatory submissions for clinical trials require strict adherence to data standards (CDISC SDTM/ADaM), analysis conventions, and documentation requirements. The development and testing of tools for clinical trial analysis and submission has been hampered by the lack of comprehensive, publicly available benchmark datasets.

### Purpose

This benchmark provides:
- **Complete submission package** with all required components
- **Validated data lineage** from raw data to final TLFs
- **Reproducible analysis** using R programs
- **Quality metrics** for tool evaluation
- **Documentation standards** following regulatory guidance

### Study Context

The benchmark is based on a simulated Alzheimer's Disease clinical trial:

| Attribute | Value |
|-----------|-------|
| Study ID | CDISCPilot01 |
| Indication | Alzheimer's Disease (Mild to Moderate) |
| Treatment | Xanomeline TTS (Transdermal) |
| Arms | Placebo, Low Dose, High Dose |
| Subjects (ITT) | 254 |
| Duration | 24 weeks |

---

## Benchmark Contents

### Directory Structure

```
esub-benchmark/
├── CITATION.cff                    # Citation information
├── LICENSE                         # CC-BY-4.0 license
├── README.md                       # This file
├── DATASET_CARD.md                 # Dataset documentation
├── BENCHMARK_METHODS.md            # Methodology details
│
├── 01_study_design/               # Study documentation
│   ├── protocol/                  # Protocol document
│   └── sap/                       # Statistical Analysis Plan
│
├── 02_data_collection/            # Data collection materials
│   └── acrf/                      # Annotated CRFs (5 PDFs)
│
├── 03_raw_data/                   # Raw data specifications
│   ├── raw_data_documentation.md  # Variable specifications
│   └── create_missing_raw_data.R  # Data creation scripts
│
├── 04_sdtm/                       # SDTM datasets and docs
│   ├── datasets/                  # 22 SDTM XPT files
│   ├── define.xml                 # SDTM metadata
│   ├── blankcrf.pdf               # Blank CRF
│   ├── CDISCPilot01_SDRG.md       # SDTM Reviewer's Guide
│   └── programs/                  # SDTM creation programs
│
├── 05_adam/                       # ADaM datasets and docs
│   ├── datasets/                  # 5 ADaM XPT files
│   ├── define.xml                 # ADaM metadata
│   └── adrg.pdf                   # ADaM Reviewer's Guide
│
├── 06_tlfs/                       # Tables, Listings, Figures
│   ├── mock_templates/            # 6 mock shell templates
│   └── outputs/                   # Real TLF outputs
│       ├── pdf/                   # PDF outputs
│       ├── rtf/                   # RTF outputs
│       └── tlf-demographic.out    # Text output
│
├── 07_regulatory/                 # Regulatory documents
│   ├── cover-letter.pdf           # Submission cover letter
│   └── sap-cdiscpilot01.pdf       # SAP in PDF format
│
└── 08_validation/                 # Validation framework
    ├── run_validation_v2.R        # Validation script
    ├── quality_report.md          # Quality report
    ├── master_validation_plan.md  # Validation plan
    └── document_alignment_checklist.md
```

### Component Inventory

| Category | Component | Count | Format |
|----------|-----------|-------|--------|
| **Data** | SDTM datasets | 22 | XPT |
| | ADaM datasets | 5 | XPT |
| | Raw data specs | 5 | RDA |
| **Documentation** | Protocol | 1 | MD |
| | SAP | 1 | MD + PDF |
| | SDRG | 1 | MD |
| | ADRG | 1 | PDF |
| | aCRFs | 5 | PDF |
| **Metadata** | define.xml | 2 | XML |
| **TLFs** | Mock templates | 6 | MD |
| | Real outputs | 8 | PDF/RTF/OUT |
| **Programs** | SDTM creation | 3 | R |
| | Validation | 3 | R |

---

## Installation

### Prerequisites

- R (>= 4.1.0)
- RStudio (recommended)

### Quick Start

```r
# Clone the repository
# git clone https://github.com/your-org/esub-benchmark.git

# Install required packages
install.packages(c(
  "haven",      # XPT file handling
  "dplyr",      # Data manipulation
  "tidyr",      # Data reshaping
  "stringr",    # String operations
  "lubridate",  # Date handling
  "xportr",     # CDISC XPT export
  "admiral",    # ADaM derivations
  "Tplyr",      # Clinical summaries
  "rtables",    # Table generation
  "ggplot2",    # Graphics
  "emmeans"     # LS means
))

# Run validation
setwd("esub-benchmark/08_validation")
source("run_validation_v2.R")
```

---

## Usage

### Loading Data

```r
library(haven)

# Load SDTM data
dm <- read_xpt("04_sdtm/datasets/dm.xpt")
ae <- read_xpt("04_sdtm/datasets/ae.xpt")

# Load ADaM data
adsl <- read_xpt("05_adam/datasets/adsl.xpt")
adadas <- read_xpt("05_adam/datasets/adadas.xpt")
```

### Generating TLFs

```r
# Source TLF programs from reference repo
# See submissions-pilot1/vignettes/ for complete programs

# Example: Demographics table
library(dplyr)
library(rtables)

adsl_itt <- adsl %>% filter(ITTFL == "Y")

# Build demographics table following mock specification
# See 06_tlfs/mock_templates/ for specifications
```

### Running Validation

```r
# Full validation suite
setwd("08_validation")
source("run_validation_v2.R")

# Results saved to:
# - validation_results_v2.csv
# - validation_summary.txt
```

---

## Validation Methodology

### Validation Framework

The benchmark includes a comprehensive validation framework with the following components:

1. **Data Consistency Validation**
   - Subject traceability across data levels
   - Treatment coding consistency
   - Population flag logic

2. **Document Alignment Validation**
   - Protocol ↔ SAP alignment
   - SAP ↔ Mock shell alignment
   - Mock ↔ TLF output comparison

3. **Analysis Logic Validation**
   - Model specification verification
   - Statistical method verification
   - Ground truth comparison

### Validation Categories

| Category | Description | Checks |
|----------|-------------|--------|
| Subject Traceability | Verify subject IDs across datasets | 5 |
| Treatment Consistency | Verify treatment coding | 5 |
| Population Consistency | Verify population definitions | 3 |
| Ground Truth Comparison | Compare with TLF outputs | 1 |

---

## Quality Metrics

### Primary Metrics

| Metric | Definition | Target | Result |
|--------|------------|--------|--------|
| **Subject Completeness** | % subjects traceable from raw to TLF | 100% | 100% ✓ |
| **Treatment Coding Accuracy** | % correct treatment assignments | 100% | 100% ✓ |
| **Population Consistency** | % population flags correctly derived | 100% | 100% ✓ |
| **Value Accuracy** | % statistics matching ground truth | 100% | 100% ✓ |

### Validation Results

```
Category                    Pass Rate    Status
─────────────────────────────────────────────────
Subject Traceability        100% (5/5)   ✓ PASS
Treatment Consistency       100% (5/5)   ✓ PASS
Population Consistency      100% (3/3)   ✓ PASS
Ground Truth Comparison     100% (1/1)   ✓ PASS
─────────────────────────────────────────────────
OVERALL                     100% (14/14) ✓ VALIDATED
```

### Test Cases

| Test ID | Description | Expected | Actual | Status |
|---------|-------------|----------|--------|--------|
| D-001 | SDTM total subject count | 306 | 306 | PASS |
| D-002 | SDTM ITT subject count | 254 | 254 | PASS |
| D-003 | ADaM ITT subject count | 254 | 254 | PASS |
| D-004 | ADaM subjects in SDTM | 0 missing | 0 | PASS |
| D-005 | USUBJID format | Valid pattern | Valid | PASS |
| D-010 | ARMCD values | Match expected | Match | PASS |
| D-011 | TRT01PN values | 0, 54, 81 | Match | PASS |
| D-012 | Treatment N values | 86, 84, 84 | Match | PASS |
| D-020 | SAF ≤ ITT | TRUE | TRUE | PASS |
| D-021 | EFF ≤ ITT | TRUE | TRUE | PASS |
| D-022 | ITT matches TLF | 254 | 254 | PASS |
| G-001 | Placebo Age Mean | 75.21 | 75.21 | PASS |

---

## Data Description

### Study Populations

| Population | Definition | N |
|------------|------------|---|
| Screened | All consented subjects | 306 |
| ITT (Intent-to-Treat) | All randomized | 254 |
| Safety | Received ≥1 dose | 254 |
| Efficacy | ITT + post-baseline data | 234 |

### Treatment Groups

| Treatment | ARMCD | TRT01PN | N (ITT) |
|-----------|-------|---------|---------|
| Placebo | Pbo | 0 | 86 |
| Xanomeline Low Dose | Xan_Lo | 54 | 84 |
| Xanomeline High Dose | Xan_Hi | 81 | 84 |

### Endpoints

| Type | Endpoint | Analysis Method |
|------|----------|-----------------|
| Primary | ADAS-Cog CFB Week 24 | ANCOVA, LOCF |
| Secondary | CIBIC+ | Categorical |
| Secondary | NPI-X | ANCOVA |
| Safety | Adverse Events | Descriptive |
| Safety | Time to Dermatologic AE | Kaplan-Meier |

### Subject Identifier Format

```
Pattern: XX-XXX-XXXX
Example: 01-701-1015
         │   │    │
         │   │    └─ Subject number
         │   └────── Site ID
         └────────── Study ID
```

---

## Reproducibility

### Environment Specification

```r
# R version
R.version.string
# "R version 4.4.1 (2024-06-14)"

# Key package versions
packageVersion("haven")      # "2.5.4"
packageVersion("dplyr")      # "1.1.4"
packageVersion("admiral")    # "1.1.0"
packageVersion("Tplyr")      # "1.0.2"
```

### Reproducibility Steps

1. Install R 4.4.x
2. Install required packages (see Installation)
3. Clone benchmark repository
4. Run `08_validation/run_validation_v2.R`
5. Compare results with `validation_results_v2.csv`

---

## License

This work is licensed under the [Creative Commons Attribution 4.0 International License](LICENSE).

### Source Data Licenses

| Source | License |
|--------|---------|
| CDISC Pilot Data | CDISC Terms of Use |
| RConsortium Pilots | MIT / Apache 2.0 |
| Pharmaverse Packages | Apache 2.0 |

---

## Acknowledgments

This benchmark incorporates data and methodologies from:

- **CDISC** for the SDTM/ADaM Pilot Project
- **R Consortium Submissions Working Group** for FDA submission pilots
- **Pharmaverse** for clinical trial data packages
- **FDA** for submission guidance and feedback

### References

1. CDISC. (2013). *CDISC SDTM/ADaM Pilot Project*. https://github.com/cdisc-org/sdtm-adam-pilot-project

2. R Consortium. (2024). *R Submission Pilots to FDA*. https://rconsortium.github.io/submissions-wg/

3. Pharmaverse. (2024). *pharmaverseraw: Raw Clinical Trial Data*. https://github.com/pharmaverse/pharmaverseraw

4. FDA. (2024). *Technical Conformance Guide*. https://www.fda.gov/drugs/drug-submissions

5. CDISC. (2024). *SDTM Implementation Guide v3.1.2*. https://www.cdisc.org/standards/foundational/sdtm

6. CDISC. (2024). *ADaM Implementation Guide v1.1*. https://www.cdisc.org/standards/foundational/adam

---

## Contact

For questions, issues, or contributions:
- Open an issue on GitHub
- Email: your-email@example.com

---

*Version 1.0.0 | Last Updated: 2026-02-12*
