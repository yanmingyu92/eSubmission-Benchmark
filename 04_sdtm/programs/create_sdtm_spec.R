# ==============================================================================
# Create SDTM Excel Specification from define.xml
# ==============================================================================

library(dplyr)
library(openxlsx)

# Paths
base_path <- "C:/Users/yanmi/Downloads/clinagent_new/esub-benchmark"
sdtm_path <- file.path(base_path, "04_sdtm")
output_file <- file.path(sdtm_path, "SDTM_Specifications.xlsx")

# ==============================================================================
# 1. Define Study Metadata
# ==============================================================================

define_info <- data.frame(
  Attribute = c(
    "Study Name",
    "Study Description",
    "Protocol Name",
    "Standard Name",
    "Standard Version",
    "Define XML Version"
  ),
  Value = c(
    "CDISCPILOT01",
    "Safety and Efficacy of Xanomeline TTS in Alzheimer's Disease",
    "CDISCPilot01",
    "CDISC SDTM",
    "3.1.2",
    "1.0"
  )
)

# ==============================================================================
# 2. Dataset Specifications
# ==============================================================================

datasets <- data.frame(
  Dataset = c("DM", "AE", "CM", "DS", "EX", "LB", "MH", "QS", "VS",
              "SC", "SV", "SE", "TA", "TE", "TI", "TS", "TV", "RELREC",
              "SUPPAE", "SUPPDM", "SUPPDS", "SUPPLB"),
  Label = c(
    "Demographics", "Adverse Events", "Concomitant Medications",
    "Disposition", "Exposure", "Laboratory Tests", "Medical History",
    "Questionnaires", "Vital Signs", "Subject Characteristics",
    "Subject Visits", "Subject Elements", "Trial Arms", "Trial Elements",
    "Trial Inclusion/Exclusion Criteria", "Trial Summary", "Trial Visits",
    "Related Records", "Supplemental Qualifiers AE", "Supplemental Qualifiers DM",
    "Supplemental Qualifiers DS", "Supplemental Qualifiers LB"
  ),
  Class = c(
    "Special Purpose", "Events", "Interventions", "Special Purpose",
    "Interventions", "Findings", "Events", "Findings", "Findings",
    "Findings", "Trial Design", "Trial Design", "Trial Design",
    "Trial Design", "Trial Design", "Trial Design", "Trial Design",
    "Relationship", "Relationship", "Relationship", "Relationship", "Relationship"
  ),
  Structure = c(
    "One record per subject", "One record per event per subject",
    "One record per medication per subject", "One record per disposition event per subject",
    "One record per dosing period per subject", "One record per lab test per visit per subject",
    "One record per medical history event per subject", "One record per question per visit per subject",
    "One record per vital sign per visit per subject", "One record per characteristic per subject",
    "One record per planned visit per subject", "One record per element per subject",
    "One record per arm", "One record per element",
    "One record per criterion", "One record per trial summary parameter",
    "One record per planned visit", "One record per relationship",
    "One record per supplemental qualifier", "One record per supplemental qualifier",
    "One record per supplemental qualifier", "One record per supplemental qualifier"
  ),
  Key_Variables = c(
    "STUDYID, USUBJID", "STUDYID, USUBJID, AESEQ",
    "STUDYID, USUBJID, CMSEQ", "STUDYID, USUBJID, DSSEQ",
    "STUDYID, USUBJID, EXSEQ", "STUDYID, USUBJID, LBSEQ",
    "STUDYID, USUBJID, MHSEQ", "STUDYID, USUBJID, QSSEQ",
    "STUDYID, USUBJID, VSSEQ", "STUDYID, USUBJID, SCSEQ",
    "STUDYID, USUBJID, VISITNUM", "STUDYID, USUBJID, ETCD",
    "STUDYID, ARMCD", "STUDYID, ETCD", "STUDYID, IETESTCD",
    "STUDYID, TSPARMCD", "STUDYID, VISITNUM", "STUDYID, RELID",
    "STUDYID, USUBJID, IDVAR, IDVARVAL, QNAM", "STUDYID, USUBJID, IDVAR, IDVARVAL, QNAM",
    "STUDYID, USUBJID, IDVAR, IDVARVAL, QNAM", "STUDYID, USUBJID, IDVAR, IDVARVAL, QNAM"
  ),
  Repeating = rep("No", 22),
  Reference_Data = rep("No", 22),
  Comment = rep("", 22)
)

# ==============================================================================
# 3. Variable Specifications
# ==============================================================================

# DM Variables
dm_vars <- data.frame(
  Order = 1:22,
  Dataset = "DM",
  Variable = c("STUDYID", "DOMAIN", "USUBJID", "SUBJID", "RFSTDTC", "RFENDTC",
               "RFXSTDTC", "RFXENDTC", "RFCICDTC", "SITEID", "BRTHDTC", "AGE",
               "AGEU", "SEX", "RACE", "ETHNIC", "ARMCD", "ARM", "ACTARMCD",
               "ACTARM", "COUNTRY", "DMDTC"),
  Label = c("Study Identifier", "Domain Abbreviation", "Unique Subject Identifier",
            "Subject Identifier for the Study", "Subject Reference Start Date/Time",
            "Subject Reference End Date/Time", "Date/Time of First Study Treatment",
            "Date/Time of Last Study Treatment", "Date/Time of Last Informed Consent",
            "Study Site Identifier", "Date/Time of Birth", "Age",
            "Age Units", "Sex", "Race", "Ethnicity", "Planned Arm Code",
            "Description of Planned Arm", "Actual Arm Code", "Description of Actual Arm",
            "Country", "Date/Time of Collection"),
  Data_Type = c("text", "text", "text", "text", "datetime", "datetime",
                "datetime", "datetime", "datetime", "text", "datetime", "integer",
                "text", "text", "text", "text", "text", "text", "text",
                "text", "text", "datetime"),
  Length = c(12, 2, 11, 4, 10, 10, 10, 10, 10, 3, 10, 8, 5, 1, 40, 25, 8, 22, 8, 22, 3, 10),
  Mandatory = c("Yes", "Yes", "Yes", "Yes", rep("No", 18)),
  Origin = c("Assigned", "Assigned", "Derived", "Collected", "Derived", "Derived",
             "Derived", "Derived", "Collected", "Collected", "Collected", "Derived",
             "Assigned", "Collected", "Collected", "Collected", "Assigned", "Assigned",
             "Derived", "Derived", "Collected", "Collected"),
  Codelist = c("", "", "", "", "", "", "", "", "", "", "", "", "", "SEX", "RACE", "ETHNIC", "ARMCD", "ARM", "", "", "COUNTRY", "")
)

# AE Variables
ae_vars <- data.frame(
  Order = 1:27,
  Dataset = "AE",
  Variable = c("STUDYID", "DOMAIN", "USUBJID", "AESEQ", "AESPID", "AETERM", "AELLT",
               "AELLTCD", "AEDECOD", "AEPTCD", "AEHLT", "AEHLTCD", "AEHLGT", "AEHLGTCD",
               "AEBODSYS", "AEBDSYCD", "AESEV", "AESER", "AEACN", "AEREL", "AEOUT",
               "AESTDTC", "AEENDTC", "AESTDY", "AEENDY", "AESCAN", "AESDTH"),
  Label = c("Study Identifier", "Domain Abbreviation", "Unique Subject Identifier",
            "Sequence Number", "Sponsor-Defined Identifier", "Reported Term",
            "Lowest Level Term", "Lowest Level Term Code", "Dictionary-Derived Term",
            "Preferred Term Code", "High Level Term", "High Level Term Code",
            "High Level Group Term", "High Level Group Term Code", "Body System",
            "Body System Code", "Severity/Intensity", "Serious Event",
            "Action Taken with Study Treatment", "Causality", "Outcome",
            "Start Date/Time", "End Date/Time", "Study Day of Start", "Study Day of End",
            "Involves Cancer", "Results in Death"),
  Data_Type = c("text", "text", "text", "integer", "text", "text", "text",
                "integer", "text", "integer", "text", "integer", "text", "integer",
                "text", "integer", "text", "text", "text", "text", "text",
                "datetime", "datetime", "integer", "integer", "text", "text"),
  Length = c(12, 2, 11, 8, 10, 200, 100, 8, 100, 8, 100, 8, 100, 8, 67, 8, 9, 1, 20, 20, 20, 10, 10, 8, 8, 1, 1),
  Mandatory = c("Yes", "Yes", "Yes", "Yes", rep("No", 23)),
  Origin = c("Assigned", "Assigned", "Derived", "Derived", "Assigned", "Collected",
             "Assigned", "Assigned", "Assigned", "Assigned", "Assigned", "Assigned",
             "Assigned", "Assigned", "Assigned", "Assigned", "Collected", "Derived",
             "Collected", "Collected", "Collected", "Collected", "Collected",
             "Derived", "Derived", "Derived", "Derived"),
  Codelist = c(rep("", 16), "AESEV", "NY", "", "", "", "", "", "", "", "", "")
)

# Combine all variables
variables <- bind_rows(dm_vars, ae_vars) %>%
  mutate(
    Format = "",
    `Assigned Value` = "",
    Common = "",
    Method = "",
    Role = "Qualifier",
    Comment = ""
  )

# ==============================================================================
# 4. Codelists
# ==============================================================================

codelists <- data.frame(
  ID = c(rep("ARMCD", 4), rep("SEX", 3), rep("NY", 2), rep("AESEV", 3), "COUNTRY"),
  Name = c(rep("Treatment Arm", 4), rep("Sex", 3), rep("Yes/No", 2), rep("Severity", 3), "Country"),
  Data_Type = c(rep("text", 13)),
  Order = c(1:4, 1:3, 1:2, 1:3, 1),
  Term = c("Pbo", "Xan_Lo", "Xan_Hi", "Scrnfail",
           "M", "F", "U", "Y", "N",
           "MILD", "MODERATE", "SEVERE", "USA"),
  Decoded_Value = c("Placebo", "Xanomeline Low Dose", "Xanomeline High Dose", "Screen Failure",
                    "Male", "Female", "Unknown", "Yes", "No",
                    "Mild", "Moderate", "Severe", "UNITED STATES")
)

# ==============================================================================
# 5. Methods
# ==============================================================================

methods <- data.frame(
  ID = c("M001", "M002", "M003"),
  Name = c("USUBJID Derivation", "Study Day Calculation", "Treatment Emergent Flag"),
  Type = c("Derivation", "Derivation", "Derivation"),
  Description = c(
    "Concatenate STUDYID, SITEID, SUBJID with hyphens",
    "If date >= RFSTDTC then (date - RFSTDTC) + 1 else (date - RFSTDTC)",
    "Flag if event start date >= first treatment date"
  )
)

# ==============================================================================
# 6. Create Excel Workbook
# ==============================================================================

cat("Creating SDTM Specifications Excel file...\n")

wb <- createWorkbook()

# Add sheets
addWorksheet(wb, "Define")
addWorksheet(wb, "Datasets")
addWorksheet(wb, "Variables")
addWorksheet(wb, "ValueLevel")
addWorksheet(wb, "Codelists")
addWorksheet(wb, "Methods")
addWorksheet(wb, "Comments")

# Write data
writeData(wb, "Define", define_info)
writeData(wb, "Datasets", datasets)
writeData(wb, "Variables", variables)
writeData(wb, "Codelists", codelists)
writeData(wb, "Methods", methods)
writeData(wb, "ValueLevel", data.frame(Comment = "Value level metadata not required for most SDTM domains"))
writeData(wb, "Comments", data.frame(Comment = "Additional comments"))

# Add header styling
headerStyle <- createStyle(
  textDecoration = "bold",
  halign = "center",
  valign = "center",
  fgFill = "#4F81BD",
  fontColour = "#FFFFFF"
)

for (sheet in c("Datasets", "Variables", "Codelists", "Methods")) {
  addStyle(wb, sheet, headerStyle, rows = 1, cols = 1:100, gridExpand = TRUE, stack = TRUE)
}

# Set column widths
setColWidths(wb, "Datasets", cols = 1:9, widths = "auto")
setColWidths(wb, "Variables", cols = 1:15, widths = "auto")
setColWidths(wb, "Codelists", cols = 1:6, widths = "auto")
setColWidths(wb, "Methods", cols = 1:4, widths = "auto")

# Save workbook
saveWorkbook(wb, output_file, overwrite = TRUE)

cat(sprintf("\nSDTM Specifications created: %s\n", output_file))
cat(sprintf("Sheets: %s\n", paste(getSheetNames(output_file), collapse = ", ")))
