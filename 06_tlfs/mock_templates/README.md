# TLF Mock Shell Templates

## Overview

This directory contains mock shell templates for Tables, Listings, and Figures (TLFs) based on the CDISCPilot01 clinical trial. These mock shells define the expected structure, formatting, and content of each output before actual data is populated.

---

## Mock Shell Inventory

### Tables

| TLF ID | File | Title | Population |
|--------|------|-------|------------|
| 14-1.03 | t_mock_14-1-03_demographic.md | Summary of Demographic and Baseline Characteristics | ITT |
| 14-3.01 | t_mock_14-3-01_primary_endpoint.md | Primary Endpoint Analysis: ADAS-Cog Change from Baseline to Week 24 - LOCF | Efficacy |
| 14-3.05 | t_mock_14-3-05_efficacy_ancova.md | ANCOVA of Change from Baseline at Week 20 | ITT |
| 14-4.01 | t_mock_14-4-01_ae_overview.md | Overview of Adverse Events | Safety |
| 14-4.02 | t_mock_14-4-02_ae_by_soc_pt.md | Adverse Events by System Organ Class and Preferred Term | Safety |

### Figures

| TLF ID | File | Title | Population |
|--------|------|-------|------------|
| 14-5.01 | f_mock_14-5-01_km_plot.md | Kaplan-Meier Plot for Time to First Dermatologic Event | Safety |

---

## Naming Convention

- `t_mock_XX-X-XX_*.md` - Table mock shells
- `l_mock_XX-X-XX_*.md` - Listing mock shells
- `f_mock_XX-X-XX_*.md` - Figure mock shells

Where XX-X-XX corresponds to the TLF identifier.

---

## Data Sources

| TLF ID | Source Datasets | Notes |
|--------|-----------------|-------|
| 14-1.03 | ADSL | Demographics and baseline characteristics |
| 14-3.01 | ADADAS, ADSL | Primary efficacy endpoint |
| 14-3.05 | ADLBC, ADSL | Secondary efficacy (lab data) |
| 14-4.01 | ADAE, ADSL | Safety overview |
| 14-4.02 | ADAE, ADSL | Safety detail |
| 14-5.01 | ADTTE, ADSL | Time-to-event analysis |

---

## Program References

| TLF ID | Program | Language |
|--------|---------|----------|
| 14-1.03 | tlf-demographic.R | R |
| 14-3.01 | tlf-primary.R | R |
| 14-3.05 | tlf-efficacy.R | R |
| 14-4.01 | tlf-ae-overview.R | R (to be created) |
| 14-4.02 | tlf-ae-soc-pt.R | R (to be created) |
| 14-5.01 | tlf-kmplot.R | R |

---

## Formatting Standards

### Numeric Display

| Statistic | Format | Example |
|-----------|--------|---------|
| N, n | Integer | 86 |
| Percentage | xx.x | 14.3 |
| Mean | xxx.xx | 75.21 |
| SD | xxx.xx | 8.59 |
| Mean (SD) | xxx.xx (xxx.xx) | 75.21 (8.59) |
| Median | xxx.xx | 76.00 |
| Min - Max | xxx.xx - xxx.xx | 52.00 - 89.00 |
| p-value | x.xxx or <0.001 | 0.045 |
| 95% CI | (xx.xx; xx.xx) | (1.23; 4.56) |

### Statistical Methods

| Analysis | Method |
|----------|--------|
| Continuous variables | Mean, SD, Median, Min, Max |
| Categorical variables | Frequency, Percentage |
| Primary endpoint | ANCOVA with baseline as covariate |
| Time-to-event | Kaplan-Meier, Log-rank test |

---

## Usage

1. Use these mock shells as templates for TLF development
2. Replace placeholder values (nn, xxx.xx, etc.) with actual data
3. Ensure all footnotes and annotations are included
4. Verify data sources match specification

---

*Generated for eSubmission Benchmark Package*
