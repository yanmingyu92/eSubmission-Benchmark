# Create SDTM Excel Specification from define.xml
# This script parses the SDTM define.xml and generates a P21-format Excel specification

# Load required packages
if (!requireNamespace("xml2", quietly = TRUE)) install.packages("xml2")
if (!requireNamespace("openxlsx", quietly = TRUE)) install.packages("openxlsx")
if (!requireNamespace("dplyr", quietly = TRUE)) install.packages("dplyr")

library(xml2)
library(openxlsx)
library(dplyr)

# Define paths
base_path <- "C:/Users/yanmi/Downloads/clinagent_new/esub-benchmark/04_sdtm"
define_path <- file.path(base_path, "define.xml")
output_path <- file.path(base_path, "SDTM_Specifications.xlsx")

# Parse define.xml
cat("Parsing define.xml...\n")
doc <- read_xml(define_path)

# Define namespaces
ns <- c(
  odm = "http://www.cdisc.org/ns/odm/v1.2",
  def = "http://www.cdisc.org/ns/def/v1.0",
  xlink = "http://www.w3.org/1999/xlink"
)

# Extract study metadata
study_name <- xml_text(xml_find_first(doc, "//odm:StudyName", ns))
study_desc <- xml_text(xml_find_first(doc, "//odm:StudyDescription", ns))
protocol_name <- xml_text(xml_find_first(doc, "//odm:ProtocolName", ns))
define_version <- xml_attr(xml_find_first(doc, "//def:MetaDataVersion", ns), "DefineVersion")
standard_name <- xml_attr(xml_find_first(doc, "//def:MetaDataVersion", ns), "StandardName")
standard_version <- xml_attr(xml_find_first(doc, "//def:MetaDataVersion", ns), "StandardVersion")

# 1. Extract Datasets (ItemGroupDef)
cat("Extracting datasets...\n")
itemgroupdefs <- xml_find_all(doc, "//odm:ItemGroupDef", ns)

datasets <- data.frame(
  stringsAsFactors = FALSE,
  Dataset = character(),
  Label = character(),
  Class = character(),
  Structure = character(),
  `Key Variables` = character(),
  Repeating = character(),
  `Reference Data` = character(),
  Comment = character(),
  check.names = FALSE
)

for (ig in itemgroupdefs) {
  oid <- xml_attr(ig, "OID")
  name <- xml_attr(ig, "Name")
  label <- xml_attr(ig, "SASDatasetName")
  if (is.na(label) || label == "") label <- name
  domain_label <- xml_attr(ig, "Domain")
  class <- xml_attr(ig, "def:Class")
  if (is.na(class)) class <- ""

  # Get structure from comment
  structure <- ""
  repeating <- "No"
  reference_data <- "No"

  # Get key variables
  key_vars <- xml_attr(ig, "def:HasNoData")
  key_vars <- if(is.na(key_vars) || key_vars == "Yes") "" else ""

  # Get repeating flag
  repeating_attr <- xml_attr(ig, "Repeating")
  if (!is.na(repeating_attr)) repeating <- ifelse(repeating_attr == "Yes", "Yes", "No")

  # Get purpose/IsReferenceData
  purpose <- xml_attr(ig, "Purpose")
  if (!is.na(purpose) && purpose == "Tabulation") reference_data <- "No"

  # Get comment
  comment_oid <- xml_attr(ig, "def:Comment")
  comment_text <- ""
  if (!is.na(comment_oid)) {
    comment_node <- xml_find_first(doc, paste0("//odm:CommentDef[@OID='", comment_oid, "']"), ns)
    if (!is.na(comment_node)) {
      comment_text <- xml_text(comment_node)
    }
  }

  datasets <- rbind(datasets, data.frame(
    Dataset = name,
    Label = domain_label,
    Class = class,
    Structure = structure,
    `Key Variables` = key_vars,
    Repeating = repeating,
    `Reference Data` = reference_data,
    Comment = comment_text,
    check.names = FALSE
  ))
}

cat("Found", nrow(datasets), "datasets\n")

# 2. Extract Variables (ItemDef)
cat("Extracting variables...\n")
itemdefs <- xml_find_all(doc, "//odm:ItemDef", ns)

variables <- data.frame(
  stringsAsFactors = FALSE,
  Order = integer(),
  Dataset = character(),
  Variable = character(),
  Label = character(),
  `Data Type` = character(),
  Length = integer(),
  Format = character(),
  Mandatory = character(),
  Origin = character(),
  Method = character(),
  Codelist = character(),
  Comment = character(),
  check.names = FALSE
)

# Track order per dataset
dataset_order <- list()

for (item in itemdefs) {
  oid <- xml_attr(item, "OID")
  name <- xml_attr(item, "Name")
  label <- xml_attr(item, "Label") %||% ""
  datatype <- xml_attr(item, "DataType") %||% ""
  length <- xml_attr(item, "Length") %||% ""
  format <- xml_attr(item, "Format") %||% ""

  # Get origin
  origin <- xml_attr(item, "def:Origin") %||% ""

  # Get comment
  comment_oid <- xml_attr(item, "def:Comment")
  comment_text <- ""
  if (!is.na(comment_oid)) {
    comment_node <- xml_find_first(doc, paste0("//odm:CommentDef[@OID='", comment_oid, "']"), ns)
    if (!is.na(comment_node)) {
      comment_text <- xml_text(comment_node)
    }
  }

  # Get method
  method_oid <- xml_attr(item, "def:Method")
  method_text <- ""
  if (!is.na(method_oid)) {
    method_node <- xml_find_first(doc, paste0("//odm:ComputationMethod[@OID='", method_oid, "']"), ns)
    if (!is.na(method_node)) {
      method_text <- xml_text(method_node)
    }
  }

  # Get codelist reference
  codelist_ref <- xml_find_first(item, ".//odm:CodeListRef", ns)
  codelist_oid <- ""
  if (!is.na(codelist_ref)) {
    codelist_oid <- xml_attr(codelist_ref, "CodeListOID")
  }

  # Extract dataset from OID (format: DOMAIN.VARIABLENAME or just VARIABLENAME)
  dataset <- ""
  if (grepl("\\.", oid)) {
    parts <- strsplit(oid, "\\.")[[1]]
    if (length(parts) >= 2) {
      dataset <- parts[1]
    }
  }

  # Determine order
  if (dataset != "") {
    if (is.null(dataset_order[[dataset]])) {
      dataset_order[[dataset]] <- 0
    }
    dataset_order[[dataset]] <- dataset_order[[dataset]] + 1
    order_num <- dataset_order[[dataset]]
  } else {
    order_num <- 1
  }

  # Check if mandatory
  mandatory <- "No"
  itemref <- xml_find_first(doc, paste0("//odm:ItemRef[@ItemOID='", oid, "']"), ns)
  if (!is.na(itemref)) {
    mand_attr <- xml_attr(itemref, "Mandatory")
    if (!is.na(mand_attr) && mand_attr == "Yes") {
      mandatory <- "Yes"
    }
  }

  variables <- rbind(variables, data.frame(
    Order = order_num,
    Dataset = dataset,
    Variable = name,
    Label = label,
    `Data Type` = datatype,
    Length = as.integer(length),
    Format = format,
    Mandatory = mandatory,
    Origin = origin,
    Method = method_text,
    Codelist = codelist_oid,
    Comment = comment_text,
    check.names = FALSE
  ))
}

cat("Found", nrow(variables), "variables\n")

# 3. Extract Codelists
cat("Extracting codelists...\n")
codelists_raw <- xml_find_all(doc, "//odm:CodeList", ns)

codelists <- data.frame(
  stringsAsFactors = FALSE,
  ID = character(),
  Name = character(),
  `Data Type` = character(),
  Order = integer(),
  Term = character(),
  `NCI Term Code` = character(),
  `Decoded Value` = character(),
  check.names = FALSE
)

for (cl in codelists_raw) {
  oid <- xml_attr(cl, "OID")
  name <- xml_attr(cl, "Name")
  datatype <- xml_attr(cl, "DataType") %||% ""

  # Get enumerated items
  enum_items <- xml_find_all(cl, ".//odm:EnumeratedItem", ns)
  order_num <- 0
  for (item in enum_items) {
    order_num <- order_num + 1
    term <- xml_attr(item, "CodedValue")
    nci_code <- xml_attr(item, "def:Code") %||% ""
    decoded <- term  # For enumerated items, decoded = coded

    codelists <- rbind(codelists, data.frame(
      ID = oid,
      Name = name,
      `Data Type` = datatype,
      Order = order_num,
      Term = term,
      `NCI Term Code` = nci_code,
      `Decoded Value` = decoded,
      check.names = FALSE
    ))
  }

  # Get code list items (with decode)
  cl_items <- xml_find_all(cl, ".//odm:CodeListItem", ns)
  for (item in cl_items) {
    order_num <- order_num + 1
    term <- xml_attr(item, "CodedValue")
    nci_code <- xml_attr(item, "def:Code") %||% ""
    decoded_node <- xml_find_first(item, ".//odm:Decode/odm:TranslatedText", ns)
    decoded <- if (!is.na(decoded_node)) xml_text(decoded_node) else term

    codelists <- rbind(codelists, data.frame(
      ID = oid,
      Name = name,
      `Data Type` = datatype,
      Order = order_num,
      Term = term,
      `NCI Term Code` = nci_code,
      `Decoded Value` = decoded,
      check.names = FALSE
    ))
  }
}

cat("Found", nrow(codelists), "codelist entries\n")

# 4. Extract Methods
cat("Extracting methods...\n")
methods_raw <- xml_find_all(doc, "//def:ComputationMethod", ns)

methods <- data.frame(
  stringsAsFactors = FALSE,
  ID = character(),
  Name = character(),
  Type = character(),
  Description = character(),
  check.names = FALSE
)

for (m in methods_raw) {
  oid <- xml_attr(m, "OID")
  # Extract method name from OID
  name <- gsub("COMPMETHOD\\.", "", oid)
  description <- xml_text(m)

  methods <- rbind(methods, data.frame(
    ID = oid,
    Name = name,
    Type = "Computation",
    Description = description,
    check.names = FALSE
  ))
}

cat("Found", nrow(methods), "methods\n")

# 5. Extract ValueLevel (ValueListDef)
cat("Extracting value level metadata...\n")
valuelists_raw <- xml_find_all(doc, "//def:ValueListDef", ns)

valuelevel <- data.frame(
  stringsAsFactors = FALSE,
  Dataset = character(),
  Variable = character(),
  `Where Clause` = character(),
  Label = character(),
  `Data Type` = character(),
  Length = character(),
  Origin = character(),
  check.names = FALSE
)

for (vl in valuelists_raw) {
  oid <- xml_attr(vl, "OID")
  # Parse OID to get dataset and variable (format: ValueList.DOMAIN.VARIABLE)
  parts <- strsplit(gsub("ValueList\\.", "", oid), "\\.")[[1]]
  dataset <- if (length(parts) >= 1) parts[1] else ""
  variable <- if (length(parts) >= 2) paste(parts[-1], collapse=".") else ""

  # Get item refs
  itemrefs <- xml_find_all(vl, ".//odm:ItemRef", ns)
  for (ref in itemrefs) {
    item_oid <- xml_attr(ref, "ItemOID")
    # Get item details
    item <- xml_find_first(doc, paste0("//odm:ItemDef[@OID='", item_oid, "']"), ns)
    if (!is.na(item)) {
      label <- xml_attr(item, "Label") %||% ""
      datatype <- xml_attr(item, "DataType") %||% ""
      length <- xml_attr(item, "Length") %||% ""
      origin <- xml_attr(item, "def:Origin") %||% ""

      valuelevel <- rbind(valuelevel, data.frame(
        Dataset = dataset,
        Variable = variable,
        `Where Clause` = item_oid,
        Label = label,
        `Data Type` = datatype,
        Length = length,
        Origin = origin,
        check.names = FALSE
      ))
    }
  }
}

cat("Found", nrow(valuelevel), "value level entries\n")

# 6. Extract Comments
cat("Extracting comments...\n")
comments_raw <- xml_find_all(doc, "//odm:CommentDef", ns)

comments <- data.frame(
  stringsAsFactors = FALSE,
  ID = character(),
  Value = character(),
  check.names = FALSE
)

for (c in comments_raw) {
  oid <- xml_attr(c, "OID")
  value <- xml_text(c)

  comments <- rbind(comments, data.frame(
    ID = oid,
    Value = value,
    check.names = FALSE
  ))
}

cat("Found", nrow(comments), "comments\n")

# 7. Create Define sheet (study metadata)
define <- data.frame(
  `Study Name` = study_name,
  `Study Description` = study_desc,
  `Protocol Name` = protocol_name,
  `Define Version` = define_version,
  `Standard Name` = standard_name,
  `Standard Version` = standard_version,
  check.names = FALSE
)

# Create workbook
cat("\nCreating Excel workbook...\n")
wb <- createWorkbook()

# Add sheets
addWorksheet(wb, "Define")
writeData(wb, "Define", define)

addWorksheet(wb, "Datasets")
writeData(wb, "Datasets", datasets)

addWorksheet(wb, "Variables")
writeData(wb, "Variables", variables)

addWorksheet(wb, "ValueLevel")
writeData(wb, "ValueLevel", valuelevel)

addWorksheet(wb, "Codelists")
writeData(wb, "Codelists", codelists)

addWorksheet(wb, "Methods")
writeData(wb, "Methods", methods)

addWorksheet(wb, "Comments")
writeData(wb, "Comments", comments)

# Style headers
headerStyle <- createStyle(
  textDecoration = "bold",
  halign = "center",
  fgFill = "#D3D3D3"
)

for (sheet in sheets(wb)) {
  addStyle(wb, sheet, headerStyle, rows = 1, cols = 1:50, gridExpand = TRUE)
  setColWidths(wb, sheet, cols = 1:50, widths = "auto")
}

# Save workbook
cat("Saving to", output_path, "...\n")
saveWorkbook(wb, output_path, overwrite = TRUE)

cat("\n=== Summary ===\n")
cat("Datasets:", nrow(datasets), "\n")
cat("Variables:", nrow(variables), "\n")
cat("ValueLevel:", nrow(valuelevel), "\n")
cat("Codelists:", nrow(codelists), "\n")
cat("Methods:", nrow(methods), "\n")
cat("Comments:", nrow(comments), "\n")
cat("\nDone! Excel spec saved to:", output_path, "\n")
