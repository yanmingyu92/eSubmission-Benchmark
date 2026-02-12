# TLF Outputs Inventory

## Real TLF Outputs from CDISC Pilot / RConsortium Pilots

This directory contains actual TLF outputs generated from the CDISC pilot data using R programs.

---

## Directory Structure

```
outputs/
├── pdf/
│   ├── report-tlf.pdf           # Consolidated TLF report (Pilot 1)
│   ├── report-tlf-pilot3.pdf    # Consolidated TLF report (Pilot 3)
│   ├── tlf-efficacy.pdf         # Efficacy ANCOVA table
│   ├── tlf-primary.pdf          # Primary endpoint table
│   └── tlf-kmplot.pdf           # Kaplan-Meier plot
├── rtf/
│   ├── tlf-efficacy.rtf         # Efficacy ANCOVA (RTF format)
│   └── tlf-primary.rtf          # Primary endpoint (RTF format)
└── tlf-demographic.out          # Demographics table (text format)
```

---

## TLF Specifications

### Table 14-1.03: Demographics (tlf-demographic.out)

**Population:** Intent-to-Treat (ITT) - N=254

| Metric | Placebo (N=86) | Xanomeline Low (N=84) | Xanomeline High (N=84) |
|--------|----------------|----------------------|------------------------|
| Age Mean (SD) | 75.21 (8.59) | 75.67 (8.29) | 74.38 (7.89) |
| Age Median | 76 | 77.5 | 76 |
| Age Min-Max | 52-89 | 51-88 | 56-88 |
| Age <65 | 14 | 8 | 11 |
| Age 65-80 | 42 | 47 | 55 |
| Age >80 | 30 | 29 | 18 |
| White | 78 | 78 | 74 |
| Black/AA | 8 | 6 | 9 |
| Am Indian/AN | 0 | 0 | 1 |
| Height Mean (SD) | 162.57 (11.52) | 163.43 (10.42) | 165.82 (10.13) |
| Weight Mean (SD) | 62.76 (12.77) | 67.28 (14.12) | 70.00 (14.65) |
| BMI Mean (SD) | 23.64 (3.67) | 25.06 (4.27) | 25.35 (4.16) |
| MMSE Mean (SD) | 18.05 (4.27) | 17.87 (4.22) | 18.51 (4.16) |

### Table 14-3.01: Primary Endpoint (tlf-primary.rtf/pdf)

**Population:** Efficacy (N=234)

**Endpoint:** ADAS-Cog (11) Change from Baseline to Week 24 - LOCF

**Analysis Method:** ANCOVA with treatment, site group, and baseline as covariates

**Key Results:**
- Dose response p-value
- Pairwise comparisons (Xan vs Placebo, High vs Low)
- LS Means differences with 95% CI

### Table 14-3.05: Efficacy ANCOVA (tlf-efficacy.rtf/pdf)

**Population:** ITT

**Endpoint:** Glucose Change from Baseline at Week 20

**Analysis Method:** ANCOVA with treatment and baseline as covariates

### Figure 14-5.01: Kaplan-Meier Plot (tlf-kmplot.pdf)

**Population:** Safety (N=254)

**Endpoint:** Time to First Dermatologic Event (TTDE)

**Features:**
- KM curves by treatment group
- Risk table below plot
- Censoring marks
- 95% confidence bands

---

## Source Programs

| TLF | Source Program | Location |
|-----|---------------|----------|
| Demographics | tlf-demographic.Rmd | submissions-pilot1/vignettes/ |
| Primary | tlf-primary.Rmd | submissions-pilot1/vignettes/ |
| Efficacy | tlf-efficacy.Rmd | submissions-pilot1/vignettes/ |
| KM Plot | tlf-kmplot.Rmd | submissions-pilot1/vignettes/ |

---

## Ground Truth Values

These values can be used to validate any regenerated TLFs:

### Subject Counts
- ITT Total: 254
- ITT Placebo: 86
- ITT Xanomeline Low: 84
- ITT Xanomeline High: 84
- Efficacy: 234
- Safety: 254

### Treatment Coding
| Treatment | ARMCD | TRT01PN |
|-----------|-------|---------|
| Placebo | Pbo | 0 |
| Xanomeline Low Dose | Xan_Lo | 54 |
| Xanomeline High Dose | Xan_Hi | 81 |

### USUBJID Format
Pattern: `^[0-9]{2}-[0-9]{3}-[0-9]{4}$`
Example: `01-701-1015`

---

## Usage

1. **View PDF outputs:** Open files in `pdf/` directory
2. **Edit RTF outputs:** Open files in `rtf/` directory with Word
3. **Compare with mocks:** Use `tlf-demographic.out` to compare with mock shells
4. **Regenerate:** Run source programs in submissions-pilot1 repo

---

## Validation Status

All TLF outputs have been validated against source data:
- [x] Subject counts match ADSL
- [x] Treatment distribution matches
- [x] Statistics match calculated values
- [x] Format matches mock specifications

---

*TLF Inventory v1.0*
