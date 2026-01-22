test_that("validation requires name columns", {
  data <- data.frame(FirstName = "Alice", stringsAsFactors = FALSE)
  expect_error(authordown_validate(data), "Missing required column")
})

test_that("order must be unique and positive", {
  data <- data.frame(
    FirstName = c("A", "B"),
    LastName = c("C", "D"),
    Order = c(1, 1),
    stringsAsFactors = FALSE
  )
  expect_error(authordown_validate(data), "Order")
})

test_that("corresponding authors require valid email", {
  data <- data.frame(
    FirstName = "Alice",
    LastName = "Smith",
    Corresponding = TRUE,
    Email = NA_character_,
    stringsAsFactors = FALSE
  )
  expect_error(authordown_validate(data), "Corresponding authors")
})

test_that("orcid format is checked", {
  data <- data.frame(
    FirstName = "Alice",
    LastName = "Smith",
    Orcid = "bad-orcid",
    stringsAsFactors = FALSE
  )
  expect_error(authordown_validate(data), "ORCID")
})
