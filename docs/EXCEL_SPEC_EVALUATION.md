# Excel Specification Evaluation

## Current State

### Excel Specs We Have

| File | Location | Type | Sheets |
|------|----------|------|--------|
| adam-pilot-3.xlsx | 05_adam/ | ADaM | 11 sheets (P21 format) |
| pilot6-specs.xlsx | 05_adam/ | ADaM | Similar P21 format |

### Excel Specs Structure (adam-pilot-3.xlsx)

| Sheet | Records | Purpose |
|-------|---------|---------|
| Define | 6 | Study metadata |
| Datasets | 5 | Dataset specifications |
| Variables | 216 | Variable specifications |
| ValueLevel | 15 | Value-level metadata |
| Codelists | 339 | Controlled terminology |
| Dictionaries | 1 | MedDRA reference |
| Methods | 157 | Derivation methods |
| Comments | 8 | Documentation comments |
| Documents | 1 | Document references |
| Analysis Displays | 0 | (Empty) |
| Analysis Results | 0 | (Empty) |

### Excel Specs We're Missing

| Spec Type | Status | Priority |
|-----------|--------|----------|
| SDTM Specifications | ❌ Missing | HIGH |
| Raw Data Specifications | ❌ Missing | MEDIUM |

---

## Industry Standard (P21 Template)

### Pinnacle 21 Excel Spec Structure

| Sheet | Required Columns |
|-------|-----------------|
| **Datasets** | Dataset, Label, Class, Structure, Key Variables, Repeating, Reference Data |
| **Variables** | Order, Dataset, Variable, Label, Data Type, Length, Format, Mandatory, Origin, Method, Codelist |
| **ValueLevel** | Dataset, Variable, Where Clause, Label, Type, Origin |
| **Codelists** | ID, Name, Term, Decoded Value |
| **Methods** | ID, Name, Type, Description |

---

## Evaluation

### Pros of Excel Specs

| Advantage | Description |
|-----------|-------------|
| Industry Standard | P21 format is widely used |
| Machine Readable | metacore R package can read directly |
| Define.xml Generation | Can auto-generate define.xml |
| Validation Support | P21 Enterprise validates against spec |
| Traceability | Links variables to methods, codelists |
| Working Document | Used throughout development |

### Cons of Excel Specs

| Disadvantage | Description |
|--------------|-------------|
| Version Control | Binary file, hard to diff in git |
| Manual Updates | Must sync with actual data changes |
| Multiple Files | SDTM + ADaM = multiple Excel files |

### Current Gap Analysis

| Component | MD Spec | Excel Spec | Gap |
|-----------|---------|------------|-----|
| SDTM | ✅ SDRG + Specs MD | ❌ Missing | **Need to create** |
| ADaM | ✅ Specs MD + ADRG | ✅ adam-pilot-3.xlsx | Complete |
| Raw Data | ✅ Documentation MD | ❌ N/A (not required) | N/A |

---

## Recommendation

### Decision: **YES, Create SDTM Excel Spec**

**Rationale:**
1. **Complete Package** - Benchmark should include both SDTM and ADaM Excel specs
2. **Industry Standard** - P21 format is the de facto standard
3. **Practical Use** - Developers need Excel specs for metacore workflow
4. **Already Have Template** - adam-pilot-3.xlsx is a template

### Options to Create SDTM Excel Spec

#### Option A: Extract from define.xml (Recommended)
- Parse define.xml to extract metadata
- Generate Excel using metacore/xlsx packages
- Ensures consistency with actual define.xml

#### Option B: Use P21 Template
- Download P21 template
- Fill with our SDTM domain information
- Manual but straightforward

#### Option C: Copy from Reference Repo
- Find existing SDTM spec in reference repos
- Adapt to our needs

---

## Implementation Plan

### Step 1: Check for Existing SDTM Excel Specs

Search reference repos for any SDTM spec Excel files

### Step 2: Create SDTM Excel Spec

Use the P21 format with these sheets:
- Datasets (22 SDTM domains)
- Variables (all SDTM variables)
- ValueLevel (for LB, VS, QS)
- Codelists (controlled terms)
- Methods (derivations)

### Step 3: Validate

- Compare with define.xml
- Verify all domains/variables included
- Test with metacore package

---

## Proposed SDTM Excel Spec Content

### Datasets Sheet (22 domains)

| Dataset | Label | Class | Structure |
|---------|-------|-------|-----------|
| DM | Demographics | Special Purpose | One per subject |
| AE | Adverse Events | Events | One per AE per subject |
| CM | Con Meds | Interventions | One per CM per subject |
| ... | ... | ... | ... |

### Estimated Records

| Sheet | Est. Records |
|-------|-------------|
| Datasets | 22 |
| Variables | ~400 |
| ValueLevel | ~50 |
| Codelists | ~200 |
| Methods | ~50 |

---

## Conclusion

**We SHOULD create an SDTM Excel specification** to have a complete, industry-standard benchmark package. The ADaM Excel spec (adam-pilot-3.xlsx) already exists and follows P21 format. Creating the SDTM counterpart will make the benchmark more complete and useful for:
1. Developers learning CDISC standards
2. Testing tools that use Excel specs
3. Demonstrating complete submission workflow
