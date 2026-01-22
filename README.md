# authordown <img src="man/figures/logo.png" align="right" height="150" alt="authordown logo" />

[![R-CMD-check](https://github.com/zh1peng/authordown/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/zh1peng/authordown/actions/workflows/R-CMD-check.yaml)

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

## Recommended workflow for online tables

If you manage authors in an online table, export it locally and then use
`authordown_read_local()`:

1) Export to CSV or XLSX (or TSV).
2) Read locally with `authordown_read_local()`.

Supported formats: CSV, TSV, XLSX.

## Affiliations

Use `Affiliation1`, `Affiliation2`, ... `AffiliationN` columns to list all
affiliations for each author. There is no hard limit; add as many columns as
needed. The title page numbers affiliations in the order they first appear.

## Shiny app

```r
library(shiny)
shiny::runApp(system.file("shiny-app", package = "authordown"))
```

Workflow: download the template, fill it, upload it, preview the parsed data, then generate outputs for copy/paste.

## Render sections for copy/paste

If you want rendered HTML for easy copy/paste into a manuscript system, use:

```r
\dontrun{
html_path <- render_section_html(
  section_title = "Conflict of Interest",
  content_function = generate_conflict,
  data = authors,
  style = "paragraph"
)
}
```

## Troubleshooting

- "Missing required column" means your file does not include required fields such as `FirstName` and `LastName`.
- "Corresponding authors must have an Email" means a row has `Corresponding = TRUE` but `Email` is blank.
- "ORCID values must use the 0000-0000-0000-0000 format" indicates a formatting error.

## License

AGPL-3
