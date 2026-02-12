# Document Alignment Checklist

## Manual Validation of Document Consistency

---

## 1. Protocol ↔ SAP Alignment

### 1.1 Study Objectives

| Protocol Statement | SAP Statement | Aligned? | Notes |
|-------------------|---------------|----------|-------|
| Primary: Evaluate efficacy of xanomeline on cognitive function | Primary: ADAS-Cog Change from Baseline to Week 24 | ⬜ Yes ⬜ No | |
| Secondary: Global clinical improvement | Secondary: CIBIC+ | ⬜ Yes ⬜ No | |
| Secondary: Behavioral symptoms | Secondary: NPI-X | ⬜ Yes ⬜ No | |

### 1.2 Study Design

| Protocol Statement | SAP Statement | Aligned? | Notes |
|-------------------|---------------|----------|-------|
| Prospective, randomized | ITT population for primary analysis | ⬜ Yes ⬜ No | |
| Multi-center | SITEGR1 in ANCOVA model | ⬜ Yes ⬜ No | |
| Double-blind, placebo-controlled | Treatment groups: Placebo, Low, High | ⬜ Yes ⬜ No | |
| Parallel-group | No cross-over analyses | ⬜ Yes ⬜ No | |
| 300 subjects planned | Sample size justification: 80% power | ⬜ Yes ⬜ No | |

### 1.3 Treatment Groups

| Protocol | SAP Coding | Aligned? |
|----------|------------|----------|
| Placebo | TRT01PN = 0, ARMCD = "0" | ⬜ Yes ⬜ No |
| Xanomeline Low Dose (50 cm²) | TRT01PN = 54, ARMCD = "54" | ⬜ Yes ⬜ No |
| Xanomeline High Dose (75 cm²) | TRT01PN = 81, ARMCD = "81" | ⬜ Yes ⬜ No |

### 1.4 Populations

| Protocol Definition | SAP Definition | Aligned? |
|---------------------|----------------|----------|
| ITT: All randomized subjects | ITTFL = "Y" in ADSL | ⬜ Yes ⬜ No |
| Safety: Received ≥1 dose | SAFFL = "Y" in ADSL | ⬜ Yes ⬜ No |
| Efficacy: ITT + post-baseline | EFFFL = "Y" in ADSL | ⬜ Yes ⬜ No |

### 1.5 Endpoints

| Protocol Endpoint | SAP Analysis | Aligned? |
|-------------------|--------------|----------|
| ADAS-Cog CFB Week 24 | ANCOVA with baseline covariate | ⬜ Yes ⬜ No |
| | LOCF for missing data | ⬜ Yes ⬜ No |
| | Treatment, site group, baseline in model | ⬜ Yes ⬜ No |
| CIBIC+ | Categorical analysis | ⬜ Yes ⬜ No |
| NPI-X | ANCOVA | ⬜ Yes ⬜ No |

---

## 2. SAP ↔ Mock Shell Alignment

### 2.1 Table 14-1.03: Demographics

| SAP Specification | Mock Shell | Aligned? |
|-------------------|------------|----------|
| Population: ITT | "Population: Intent-to-Treat" | ⬜ Yes ⬜ No |
| Variables: AGE, SEX, RACE, HEIGHTBL, WEIGHTBL, BMIBL, MMSETOT | Same variables listed | ⬜ Yes ⬜ No |
| Statistics: n, Mean (SD), Median, Min-Max | Same statistics shown | ⬜ Yes ⬜ No |
| Columns: Placebo, Low Dose, High Dose | Same columns | ⬜ Yes ⬜ No |

### 2.2 Table 14-3.01: Primary Endpoint

| SAP Specification | Mock Shell | Aligned? |
|-------------------|------------|----------|
| Title: ADAS-Cog CFB Week 24 | Same title | ⬜ Yes ⬜ No |
| Population: Efficacy | "Population: Efficacy" | ⬜ Yes ⬜ No |
| Baseline statistics: n, Mean (SD), Median (Range) | Same format | ⬜ Yes ⬜ No |
| Week 24 statistics: Same | Same format | ⬜ Yes ⬜ No |
| Change statistics: Same | Same format | ⬜ Yes ⬜ No |
| Dose response p-value | Included | ⬜ Yes ⬜ No |
| Pairwise comparisons | Included | ⬜ Yes ⬜ No |
| LS Means with SE | Included | ⬜ Yes ⬜ No |
| 95% CI | Included | ⬜ Yes ⬜ No |
| Footnote [1]: ANCOVA model | Present | ⬜ Yes ⬜ No |
| Footnote [2]: Dose response | Present | ⬜ Yes ⬜ No |
| Footnote [3]: No multiplicity adjustment | Present | ⬜ Yes ⬜ No |

### 2.3 Table 14-4.01: AE Overview

| SAP Specification | Mock Shell | Aligned? |
|-------------------|------------|----------|
| Population: Safety | "Population: Safety" | ⬜ Yes ⬜ No |
| Any AE count | Included | ⬜ Yes ⬜ No |
| TEAE count | Included | ⬜ Yes ⬜ No |
| SAE count | Included | ⬜ Yes ⬜ No |
| AE leading to discontinuation | Included | ⬜ Yes ⬜ No |
| Total AE count | Included | ⬜ Yes ⬜ No |

---

## 3. Mock Shell ↔ TLF Output Alignment

### 3.1 Table 14-1.03: Demographics

| Mock Element | TLF Output | Match? | Notes |
|--------------|------------|--------|-------|
| Column headers: Placebo, Low, High | Same | ⬜ Yes ⬜ No | |
| N values row | Present | ⬜ Yes ⬜ No | |
| Age: Mean (SD) | Present | ⬜ Yes ⬜ No | |
| Age: Median | Present | ⬜ Yes ⬜ No | |
| Age: Min-Max | Present | ⬜ Yes ⬜ No | |
| Age Group categories | Present | ⬜ Yes ⬜ No | |
| Sex categories | Present | ⬜ Yes ⬜ No | |
| Race categories | Present | ⬜ Yes ⬜ No | |
| Height statistics | Present | ⬜ Yes ⬜ No | |
| Weight statistics | Present | ⬜ Yes ⬜ No | |
| BMI statistics | Present | ⬜ Yes ⬜ No | |
| MMSE statistics | Present | ⬜ Yes ⬜ No | |

**Actual Values Check:**
| Metric | Placebo (Mock) | Placebo (TLF) | Match? |
|--------|----------------|---------------|--------|
| N | N=86 | 86 | ⬜ Yes ⬜ No |
| Age Mean (SD) | xx.xx (xx.xx) | 75.21 (8.59) | ⬜ Yes ⬜ No |

### 3.2 Table 14-3.01: Primary Endpoint

| Mock Element | TLF Output | Match? | Notes |
|--------------|------------|--------|-------|
| Title | "Primary Endpoint Analysis: ADAS Cog (11)..." | ⬜ Yes ⬜ No | |
| Protocol reference | "Protocol: CDISCPILOT01" | ⬜ Yes ⬜ No | |
| Population | "Population: Efficacy" | ⬜ Yes ⬜ No | |
| Baseline section | Present with statistics | ⬜ Yes ⬜ No | |
| Week 24 section | Present with statistics | ⬜ Yes ⬜ No | |
| Change section | Present with statistics | ⬜ Yes ⬜ No | |
| Dose response p-value | Present | ⬜ Yes ⬜ No | |
| Pairwise p-values | Present | ⬜ Yes ⬜ No | |
| LS Means differences | Present | ⬜ Yes ⬜ No | |
| 95% CI | Present | ⬜ Yes ⬜ No | |
| All 3 footnotes | Present | ⬜ Yes ⬜ No | |

### 3.3 Figure 14-5.01: KM Plot

| Mock Element | TLF Output | Match? | Notes |
|--------------|------------|--------|-------|
| Title | "KM plot for Time to First Dermatologic Event" | ⬜ Yes ⬜ No | |
| Population | "Safety population" | ⬜ Yes ⬜ No | |
| X-axis label | "Time to First Dermatologic Event (Days)" | ⬜ Yes ⬜ No | |
| Y-axis label | "Probability of event" | ⬜ Yes ⬜ No | |
| Three treatment curves | Present | ⬜ Yes ⬜ No | |
| Legend with treatment names | Present | ⬜ Yes ⬜ No | |
| Risk table | Present below plot | ⬜ Yes ⬜ No | |
| Censoring marks | Present | ⬜ Yes ⬜ No | |
| Reference line at 0.5 | Present | ⬜ Yes ⬜ No | |

---

## 4. Analysis Logic Verification

### 4.1 Primary Endpoint Model

| Component | SAP | TLF Program | Match? |
|-----------|-----|-------------|--------|
| Dependent variable | CHG (Change from baseline) | CHG used | ⬜ Yes ⬜ No |
| Independent: Treatment | TRTPN (continuous) for dose response | TRTPN used | ⬜ Yes ⬜ No |
| Independent: Site | SITEGR1 | SITEGR1 used | ⬜ Yes ⬜ No |
| Independent: Baseline | BASE | BASE used | ⬜ Yes ⬜ No |
| Model type | ANCOVA (lm in R) | lm() function | ⬜ Yes ⬜ No |
| Sum of Squares | Type III | contr.sum set | ⬜ Yes ⬜ No |
| LS Means weighting | Proportional | weights='proportional' | ⬜ Yes ⬜ No |
| Multiple comparison | No adjustment | adjust=NULL | ⬜ Yes ⬜ No |

### 4.2 Data Selection

| Filter | SAP | TLF Program | Match? |
|--------|-----|-------------|--------|
| Population | EFFFL = "Y" | filter(EFFFL == "Y") | ⬜ Yes ⬜ No |
| ITT flag | ITTFL = "Y" | filter(ITTFL == "Y") | ⬜ Yes ⬜ No |
| Parameter | PARAMCD = "ACTOT" | filter(PARAMCD == "ACTOT") | ⬜ Yes ⬜ No |
| Analysis flag | ANL01FL = "Y" | filter(ANL01FL == "Y") | ⬜ Yes ⬜ No |
| Visit | Week 24 | filter(AVISITN == 24) | ⬜ Yes ⬜ No |

### 4.3 Missing Data

| Method | SAP | TLF Implementation | Match? |
|--------|-----|-------------------|--------|
| Primary | LOCF | DTYPE = "LOCF" records | ⬜ Yes ⬜ No |
| Sensitivity | Not specified | - | ⬜ N/A |

---

## 5. Sign-off

### Reviewer Checklist

- [ ] All Protocol ↔ SAP alignments verified
- [ ] All SAP ↔ Mock alignments verified
- [ ] All Mock ↔ TLF alignments verified
- [ ] Analysis logic matches SAP
- [ ] Data selection matches SAP
- [ ] Results are reproducible

### Signatures

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Document Reviewer | | | |
| Statistical Reviewer | | | |
| Quality Assurance | | | |

---

## Notes and Issues

| Issue # | Description | Severity | Resolution |
|---------|-------------|----------|------------|
| | | | |

---

*Document Alignment Checklist v1.0*
