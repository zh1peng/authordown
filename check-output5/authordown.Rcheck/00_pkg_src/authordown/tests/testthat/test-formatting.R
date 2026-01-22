test_that("title page respects show_degree", {
  data <- data.frame(
    FirstName = "Alice",
    LastName = "Smith",
    Degree = "PhD",
    Affiliation1 = "University X",
    stringsAsFactors = FALSE
  )

  no_degree <- generate_title_page(data, show_degree = FALSE)
  with_degree <- generate_title_page(data, show_degree = TRUE)

  expect_false(grepl("PhD", no_degree, fixed = TRUE))
  expect_true(grepl("PhD", with_degree, fixed = TRUE))
})

test_that("section styles are accepted and validated", {
  data <- data.frame(
    FirstName = c("Alice", "Bob"),
    LastName = c("Smith", "Johnson"),
    Acknowledgement = c("Grant A", "Grant B"),
    Conflict = c("No conflict", "Consultant"),
    Contribution = c("Conceptualization", "Writing"),
    stringsAsFactors = FALSE
  )

  expect_silent(generate_acknowledgement(data, style = "bullets"))
  expect_silent(generate_conflict(data, style = "numbered"))
  expect_silent(generate_contribution(data, style = "paragraph"))
  expect_error(generate_acknowledgement(data, style = "bad"))
  expect_error(generate_contribution(data, style = "bad"))
})

test_that("title page style validation is explicit", {
  data <- data.frame(
    FirstName = "Alice",
    LastName = "Smith",
    Affiliation1 = "University X",
    stringsAsFactors = FALSE
  )

  expect_silent(generate_title_page(data, style = "default"))
  expect_error(generate_title_page(data, style = "unknown"))
})

test_that("list_style maps to contribution styles", {
  data <- data.frame(
    FirstName = "Alice",
    LastName = "Smith",
    Contribution = "Conceptualization",
    stringsAsFactors = FALSE
  )

  bullets <- generate_contribution(data, list_style = TRUE)
  paragraph <- generate_contribution(data, list_style = FALSE)

  expect_true(grepl("^- ", bullets))
  expect_true(grepl("contributed as follows", paragraph))
})
