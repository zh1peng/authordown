# authordown

authordown is an R package for managing author metadata and generating manuscript front matter, especially for large author lists.

## Features

- Title page generation with affiliation numbering and correspondence notes
- Author metadata validation and normalization
- Acknowledgements, conflict of interest, and contribution sections
- Templates to standardize author data entry
- Shiny app for quick preview and export

## Installation

From CRAN (once available):

```r
install.packages("authordown")
```

From GitHub:

```r
# install.packages("devtools")
devtools::install_github("zh1peng/authordown")
```

## End-to-end workflow (offline safe)

### 1) Start from the bundled template

```r
library(authordown)

# Use the bundled CSV template
template_path <- system.file("extdata", "authordown_template.csv", package = "authordown")
authors <- authordown_read_local(template_path)
```

You can also write a fresh template to your working directory:

```r
authordown_template("authors.csv")
```

### 2) Generate a title page (with degree shown)

```r
title_page <- generate_title_page(
  data = authors,
  title = "Example Paper",
  style = "default",
  show_degree = TRUE
)
cat(title_page)
```

### 3) Generate other sections

```r
ack <- generate_acknowledgement(authors, style = "paragraph")
coi <- generate_conflict(authors, style = "paragraph")
contrib <- generate_contribution(authors, style = "bullets")

cat(ack)
cat("\n\n")
cat(coi)
cat("\n\n")
cat(contrib)
```

### 4) XLSX input

```r
xlsx_path <- system.file("extdata", "authordown_template.xlsx", package = "authordown")
authors_xlsx <- authordown_read_local(xlsx_path)
```

## URL workflows (export to local file first)

These helpers currently require a local export for offline checks. Export your table to CSV/XLSX and then use `authordown_read_local()`.

```r
\dontrun{
# Google Sheets
sheet_url <- "https://docs.google.com/spreadsheets/d/..."
authors <- authordown_read_google_sheet(sheet_url)

# Tencent table
qq_url <- "https://docs.qq.com/sheet/..."
authors <- authordown_read_tencent(qq_url)
}
```

## Shiny app

```r
library(shiny)
shiny::runApp(system.file("shiny-app", package = "authordown"))
```

Upload your template CSV, select a style, and click Generate to preview the title page.

## Troubleshooting

- "Missing required column" means your file does not include required fields such as `FirstName` and `LastName`.
- "Corresponding authors must have an Email" means a row has `Corresponding = TRUE` but `Email` is blank.
- "ORCID values must use the 0000-0000-0000-0000 format" indicates a formatting error.

## License

AGPL-3
