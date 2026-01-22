#' Validate author metadata
#'
#' @description Checks required columns and key formats such as order, email,
#' ORCID, and corresponding author rules.
#'
#' @param data A data frame of author metadata.
#' @param require_affiliations Logical. If TRUE, require at least one
#'   affiliation column.
#' @return The validated, standardized data frame.
#' @export
#' @examples
#' authors <- data.frame(FirstName = "Alice", LastName = "Smith")
#' authordown_validate(authors)
authordown_validate <- function(data, require_affiliations = FALSE) {
  data <- authordown_canonicalize(data)
  problems <- attr(data, "authordown_problems")
  if (is.null(problems)) {
    problems <- list()
  }

  errors <- character()

  required_cols <- c("FirstName", "LastName")
  missing_cols <- setdiff(required_cols, names(data))
  if (length(missing_cols) > 0) {
    errors <- c(
      errors,
      paste0("Missing required column(s): ", paste(missing_cols, collapse = ", "))
    )
  }

  if (length(problems$Order) > 0) {
    errors <- c(errors, "Column 'Order' must be numeric integers.")
  }
  if ("Order" %in% names(data)) {
    if (any(!is.na(data$Order) & data$Order <= 0)) {
      errors <- c(errors, "Column 'Order' must be positive integers.")
    }
    order_vals <- data$Order[!is.na(data$Order)]
    if (any(duplicated(order_vals))) {
      errors <- c(errors, "Column 'Order' must be unique when provided.")
    }
  }

  if (length(problems$Corresponding) > 0) {
    errors <- c(errors, "Column 'Corresponding' must be TRUE/FALSE or yes/no.")
  }

  if ("Corresponding" %in% names(data) && "Email" %in% names(data)) {
    needs_email <- !is.na(data$Corresponding) & data$Corresponding
    missing_email <- needs_email & (is.na(data$Email) | data$Email == "")
    if (any(missing_email)) {
      errors <- c(errors, "Corresponding authors must have an Email.")
    }
  }

  if ("Email" %in% names(data)) {
    email_vals <- trimws(as.character(data$Email))
    data$Email <- email_vals
    bad_idx <- which(!is.na(email_vals) &
      !grepl("^[^@[:space:]]+@[^@[:space:]]+$", email_vals))
    if (length(bad_idx) > 0) {
      shown <- paste0(
        "row ", bad_idx, ": ", shQuote(email_vals[bad_idx])
      )
      shown <- paste(utils::head(shown, 5), collapse = ", ")
      if (length(bad_idx) > 5) {
        shown <- paste0(shown, ", ...")
      }
      errors <- c(
        errors,
        paste0("Email values must look like valid addresses (", shown, ").")
      )
    }
  }

  if ("Orcid" %in% names(data)) {
    orcid_vals <- data$Orcid[!is.na(data$Orcid)]
    bad_orcid <- orcid_vals[
      !grepl("^[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{3}[0-9X]$", orcid_vals)
    ]
    if (length(bad_orcid) > 0) {
      errors <- c(errors, "ORCID values must use the 0000-0000-0000-0000 format.")
    }
  }

  if ("EqualContribution" %in% names(data)) {
    allowed <- c("co-first", "co-senior", "equal", "none")
    eq_vals <- data$EqualContribution[!is.na(data$EqualContribution)]
    bad_eq <- eq_vals[!tolower(eq_vals) %in% allowed]
    if (length(bad_eq) > 0) {
      errors <- c(
        errors,
        "EqualContribution must be one of: co-first, co-senior, equal, none."
      )
    }
  }

  aff_cols <- grep("^Affiliation\\d+$", names(data), value = TRUE)
  if (isTRUE(require_affiliations) && length(aff_cols) == 0) {
    errors <- c(errors, "At least one Affiliation column is required.")
  }

  if (length(errors) > 0) {
    rlang::abort(paste(c("Invalid author data:", errors), collapse = "\n"))
  }

  data
}

#' Standardize raw author metadata
#'
#' @param data A data frame of author metadata.
#' @return A standardized data frame.
#' @keywords internal
authordown_canonicalize <- function(data) {
  if (!is.data.frame(data)) {
    rlang::abort("Input must be a data frame.")
  }

  data <- as.data.frame(data, stringsAsFactors = FALSE, check.names = FALSE)
  names(data) <- trimws(names(data))

  normalized <- function(x) {
    gsub("[^a-z0-9]+", "", tolower(x))
  }

  target_map <- list(
    FirstName = c("firstname", "givenname"),
    MiddleName = c("middlename"),
    LastName = c("lastname", "surname", "familyname"),
    Suffix = c("suffix"),
    Degree = c("degree"),
    Email = c("email", "emailaddress"),
    Orcid = c("orcid"),
    Order = c("order", "authororder"),
    Rank = c("rank"),
    Corresponding = c("corresponding", "correspondence", "correspondingauthor"),
    EqualContribution = c("equalcontribution", "equalcontrib", "cofirst", "cosenior"),
    Contribution = c("contribution", "credit"),
    Acknowledgement = c("acknowledgement", "acknowledgment", "acknowledgments"),
    Conflict = c("conflict", "coi", "conflictofinterest")
  )

  new_names <- names(data)
  for (i in seq_along(new_names)) {
    raw_name <- new_names[i]
    norm <- normalized(raw_name)
    if (grepl("^affiliation\\d+$", tolower(raw_name))) {
      new_names[i] <- paste0(
        "Affiliation",
        gsub("^affiliation", "", tolower(raw_name))
      )
      next
    }
    if (norm == "affiliation") {
      new_names[i] <- "Affiliation1"
      next
    }
    matched <- FALSE
    for (target in names(target_map)) {
      if (norm %in% target_map[[target]]) {
        new_names[i] <- target
        matched <- TRUE
        break
      }
    }
    if (!matched) {
      new_names[i] <- raw_name
    }
  }
  names(data) <- new_names

  if (any(duplicated(names(data)))) {
    rlang::abort("Duplicate column names after standardization.")
  }

  for (col in names(data)) {
    if (is.factor(data[[col]])) {
      data[[col]] <- as.character(data[[col]])
    }
    if (is.character(data[[col]])) {
      data[[col]] <- trimws(data[[col]])
      data[[col]][data[[col]] == ""] <- NA
    }
  }

  problems <- list()

  if ("Corresponding" %in% names(data)) {
    raw_vals <- data$Corresponding
    parsed <- vapply(raw_vals, parse_logical_value, logical(1))
    invalid <- which(!is.na(raw_vals) & is.na(parsed))
    if (length(invalid) > 0) {
      problems$Corresponding <- invalid
    }
    data$Corresponding <- parsed
  }

  if ("Order" %in% names(data)) {
    raw_vals <- data$Order
    parsed <- suppressWarnings(as.integer(as.character(raw_vals)))
    invalid <- which(!is.na(raw_vals) & is.na(parsed))
    if (length(invalid) > 0) {
      problems$Order <- invalid
    }
    data$Order <- parsed
  }

  if ("EqualContribution" %in% names(data)) {
    data$EqualContribution <- tolower(data$EqualContribution)
  }

  if ("Orcid" %in% names(data)) {
    data$Orcid <- toupper(data$Orcid)
  }

  attr(data, "authordown_problems") <- problems
  data
}

parse_logical_value <- function(x) {
  if (is.logical(x)) {
    return(x)
  }
  if (is.na(x)) {
    return(NA)
  }
  x <- tolower(trimws(as.character(x)))
  if (x %in% c("true", "t", "yes", "y", "1")) {
    return(TRUE)
  }
  if (x %in% c("false", "f", "no", "n", "0")) {
    return(FALSE)
  }
  NA
}
