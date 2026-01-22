test_that("template round-trip works for CSV", {
  tmp <- tempfile(fileext = ".csv")
  authordown_template(tmp)
  expect_true(file.exists(tmp))
  data <- authordown_read_local(tmp)
  expect_true(is.data.frame(data))
  expect_true(all(c("FirstName", "LastName") %in% names(data)))
})

test_that("generate_title_page includes markers and footnotes", {
  authors <- data.frame(
    FirstName = c("Alice", "Bob", "Charlie"),
    MiddleName = c("M.", "", "Q."),
    LastName = c("Smith", "Johnson", "Lee"),
    Degree = c("PhD", "MD", "PhD"),
    Email = c("alice@example.com", "bob@example.com", "charlie@example.org"),
    Rank = c(1, 1, 2),
    Correspondence = c(TRUE, FALSE, TRUE),
    Affiliation1 = c("University X", "University X", "Institute Z"),
    Affiliation2 = c(NA, "Company W", NA),
    stringsAsFactors = FALSE
  )
  title_page <- generate_title_page(authors, title = "A Great Paper", show_degree = TRUE)
  expect_match(title_page, "## A Great Paper")
  expect_match(title_page, "Co-first authors")
  expect_match(title_page, "Corresponding author\\(s\\):")
  expect_match(title_page, "alice@example.com")
  expect_match(title_page, "1\\. University X")
})

test_that("acknowledgements respect style", {
  authors <- data.frame(
    Acknowledgement = c("Support from Grant A", "Thanks to Team B"),
    stringsAsFactors = FALSE
  )
  para <- generate_acknowledgement(authors, style = "paragraph")
  bullets <- generate_acknowledgement(authors, style = "bullets")
  expect_match(para, "^Acknowledgements:")
  expect_match(bullets, "\n- ")
})

test_that("conflict output includes mixed conflicts", {
  authors <- data.frame(
    FirstName = c("Alice", "Bob"),
    LastName = c("Smith", "Johnson"),
    Conflict = c("No conflict", "Consultant at Company Z"),
    stringsAsFactors = FALSE
  )
  out <- generate_conflict(authors, style = "paragraph")
  expect_match(out, "report conflicts of interest")
  expect_match(out, "Bob Johnson")
  expect_match(out, "All other authors")
})

test_that("contribution supports styles and list_style", {
  authors <- data.frame(
    FirstName = c("Alice", "Bob"),
    LastName = c("Smith", "Johnson"),
    Contribution = c("Conceptualization; Data curation", "Supervision"),
    stringsAsFactors = FALSE
  )
  para <- generate_contribution(authors, style = "paragraph")
  bullets <- generate_contribution(authors, list_style = TRUE)
  expect_match(para, "Alice Smith contributed as follows")
  expect_match(bullets, "^- ", perl = TRUE)
})

test_that("authordown combines sections", {
  authors <- data.frame(
    FirstName = c("Alice", "Bob"),
    LastName = c("Smith", "Johnson"),
    Email = c("alice@example.com", "bob@example.com"),
    Correspondence = c(TRUE, FALSE),
    Affiliation1 = c("University X", "University X"),
    Acknowledgement = c("Support from Grant A", NA),
    Conflict = c("No conflict", "Consultant at Company Z"),
    Contribution = c("Conceptualization", "Data curation"),
    stringsAsFactors = FALSE
  )
  out <- authordown(authors, title = "Example Paper")
  expect_match(out, "## Example Paper")
  expect_match(out, "Acknowledgements:")
  expect_match(out, "conflicts? of interest")
  expect_match(out, "contributed as follows")
})

test_that("render_section_html writes an html file", {
  skip_if_not_installed("rmarkdown")
  authors <- data.frame(
    FirstName = "Alice",
    LastName = "Smith",
    Conflict = "No conflict",
    stringsAsFactors = FALSE
  )
  out <- render_section_html("Conflict of Interest", generate_conflict, authors)
  expect_true(file.exists(out))
})
