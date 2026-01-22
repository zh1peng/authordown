#' Generate a Title Page (Journal-Style)
#'
#' @description Produces a journal-style title page text with:
#'   \enumerate{
#'     \item An optional paper title
#'     \item Author line (with superscript affiliation indices)
#'     \item Affiliation list (labeled by superscript numbers)
#'     \item Co-first author footnote (\\code{\\u2020} or \"†\") if multiple authors share the same minimal rank
#'     \item Corresponding author footnote (*) and contact line
#'   }
#'
#' The function expects columns:
#'   \\itemize{
#'     \\item \\strong{FirstName}, \\strong{MiddleName}, \\strong{LastName} (strings)
#'     \\item \\strong{Rank} (numeric), used to detect co-first authors (lowest rank)
#'     \\item \\strong{Correspondence} (logical or \"TRUE\"/\"FALSE\" string)
#'     \\item \\strong{Email} (for corresponding authors)
#'     \\item \\strong{Affiliation1}, \\strong{Affiliation2}, etc. (any number of these)
#'   }
#'
#' @param data A data frame with the columns listed above.
#' @param style Title page style. Supported values: "default", "APA", "Nature".
#' @param title Optional character string for the paper title.
#' @param show_degree Logical. If TRUE, include Degree after author names.
#' @param co_first_footnote Logical. If \\code{TRUE}, adds a footnote for co-first authors if multiple authors share the same \\strong{lowest} rank.
#' @return A single character string suitable for copy-pasting into Word.
#' @export
#' @examples
#' authors <- data.frame(
#'   FirstName      = c("Alice", "Bob", "Charlie"),
#'   MiddleName     = c("M.", "", "Q."),
#'   LastName       = c("Smith", "Johnson", "Lee"),
#'   Degree         = c("PhD", "MD", "PhD"),
#'   Email          = c("alice@example.com", "bob@example.com", "charlie@example.org"),
#'   Rank           = c(1, 1, 2),  # Alice and Bob are co-first authors
#'   Correspondence = c(TRUE, FALSE, FALSE),
#'   Affiliation1   = c("University of X, Dept. of Y", "University of X, Dept. of Y", "Institute of Z"),
#'   Affiliation2   = c(NA, "Company W", NA),
#'   stringsAsFactors = FALSE
#' )
#' cat(generate_title_page(authors, title = "A Great Paper", show_degree = TRUE))
generate_title_page <- function(data,
                                style = c("default", "APA", "Nature"),
                                title = NULL,
                                show_degree = FALSE,
                                co_first_footnote = TRUE) {
  style <- match.arg(style)
  # 1) Sort authors by Rank if present
  if ("Rank" %in% colnames(data)) {
    data <- data[order(data$Rank, na.last = TRUE), ]
  }
  
  # 2) Identify co-first authors if multiple authors share the same minimal rank
  co_first_flag <- FALSE
  co_first_rank <- NULL
  if (co_first_footnote && "Rank" %in% colnames(data)) {
    if (!all(is.na(data$Rank))) {
      min_rank <- min(data$Rank, na.rm = TRUE)
      # Count how many authors have this rank
      if (sum(data$Rank == min_rank, na.rm = TRUE) > 1) {
        co_first_flag <- TRUE
        co_first_rank <- min_rank
      }
    }
  }
  
  # 3) Identify corresponding authors
  #    Accept "TRUE"/"FALSE" strings or logical
  if ("Correspondence" %in% colnames(data)) {
    is_corr <- function(x) {
      if (is.logical(x)) return(x)
      # If it's a string, check if it's "true", "TRUE", "yes", "1"
      tolower(trimws(x)) %in% c("true", "yes", "1")
    }
    data$IsCorresponding <- sapply(data$Correspondence, is_corr)
  } else {
    data$IsCorresponding <- FALSE
  }
  
  # 4) Gather all affiliation columns
  aff_cols <- grep("^Affiliation", names(data), value = TRUE)
  # Extract unique non-NA affiliations in the order they appear
  all_affils <- character()
  for (col in aff_cols) {
    vals <- as.character(data[[col]])
    vals <- vals[!is.na(vals) & vals != ""]
    for (v in vals) {
      if (!(v %in% all_affils)) {
        all_affils <- c(all_affils, v)
      }
    }
  }
  # Indices for the unique affiliations
  aff_indices <- seq_along(all_affils)
  
  # 5) Build the author line
  #    e.g., "Alice M. Smith^1†*, Bob Johnson^1,2†, Charlie Q. Lee^3"
  author_strs <- apply(data, 1, function(row) {
    # Name
    nm_parts <- c(row["FirstName"], row["MiddleName"], row["LastName"])
    if (isTRUE(show_degree) && "Degree" %in% names(row)) {
      nm_parts <- c(nm_parts, row["Degree"])
    }
    nm_parts <- nm_parts[!is.na(nm_parts) & nm_parts != "" & nm_parts != "NA"]
    full_name <- paste(nm_parts, collapse = " ")
    
    # Affiliations for this author
    aff_for_author <- c()
    for (col in aff_cols) {
      val <- row[col]
      if (!is.na(val) && val != "") {
        # find index in all_affils
        idx <- which(all_affils == val)
        aff_for_author <- c(aff_for_author, idx)
      }
    }
    aff_superscript <- ""
    if (length(aff_for_author) > 0) {
      aff_superscript <- paste0("^", paste(aff_for_author, collapse = ","), "^")
    }
    
    # Co-first footnote marker (†)
    # if rank == co_first_rank
    co_first_marker  <- ""
    if (co_first_flag && !is.na(row["Rank"]) && row["Rank"] == co_first_rank) {
      co_first_marker <- "\u2020"  # †
      # Add to the superscript if it exists
    }
    
    
    # Corresponding author marker (*)
    corr_marker <- ""
    if (as.logical(row["IsCorresponding"])) {
      corr_marker <- "*"
    }
    
    # e.g., "Alice M. Smith^1†*"
    paste0(full_name, aff_superscript, co_first_marker, corr_marker)
  })
  
  author_line <- paste(author_strs, collapse = ", ")
  
  # 6) Build the affiliation lines
  #    e.g.,
  #    "^1^ University of X, Dept. of Y
  #     ^2^ Company Z, Research Division"
  aff_lines <- mapply(function(i, aff) {
    paste0(i, ". ", aff)
  }, aff_indices, all_affils)
  aff_text <- paste(aff_lines, collapse = "\n\n")
  
  # 7) Build footnotes if needed
  footnotes <- c()
  
  # co-first note
  if (co_first_flag) {
    footnotes <- c(footnotes, "\u2020Co-first authors who contributed equally. \n\n")
  }
  
  # corresponding authors
  corr_idx <- which(data$IsCorresponding == TRUE)
  if (length(corr_idx) > 0 && "Email" %in% colnames(data)) {
    corr_emails <- unique(as.character(data$Email[corr_idx]))
    corr_emails <- corr_emails[!is.na(corr_emails) & corr_emails != ""]
    if (length(corr_emails) > 0) {
      corr_line <- paste("Corresponding author(s):", paste(corr_emails, collapse = ", "))
      # Mark with '*'
      footnotes <- c(footnotes, paste0("*", corr_line))
    }
  }
  
  footnote_text <- ""
  if (length(footnotes) > 0) {
    footnote_text <- paste(footnotes, collapse = "\n")
  }
  
  # 8) Assemble final output
  # Something like:
  # Title: ...
  #
  # Alice M. Smith^1†*, Bob Johnson^1,2†
  #
  # ^1^ University of X, Dept. of Y
  # ^2^ Company Z, Research Division
  #
  # † indicates co-first authors...
  # * Corresponding author(s): ...
  
  lines <- c()
  
  if (!is.null(title) && title != "") {
    lines <- c(lines, paste0('## ',title, "\n"))
  }
  
  lines <- c(lines, author_line, "")
  if (length(all_affils) > 0) {
    lines <- c(lines, aff_text, "")
  }
  
  if (footnote_text != "") {
    lines <- c(lines, footnote_text)
  }
  
  final_output <- paste(lines, collapse = "\n")
  return(final_output)
}
