#' Generate Author Contributions
#'
#' @description Combines each author's contribution statement into a clear paragraph.
#' Each line indicates the author and their specific contribution.
#'
#' @param data A data frame containing at least the columns: FirstName, LastName, and Contribution.
#' @param style Output style: "paragraph", "bullets", or "numbered".
#' @param list_style Deprecated. Use \code{style}. When provided, TRUE maps to
#'   "bullets" and FALSE maps to "paragraph".
#' @return A character string summarizing the author contributions.
#' @export
#' @examples
#' authors <- data.frame(
#'   FirstName = c("Alice", "Bob"),
#'   LastName = c("Smith", "Johnson"),
#'   Contribution = c("Conceptualization; Data curation", "Supervision; Writing - review"),
#'   stringsAsFactors = FALSE
#' )
#' generate_contribution(authors, style = "paragraph")
generate_contribution <- function(data,
                                  style = c("paragraph", "bullets", "numbered"),
                                  list_style = NULL) {
  if (!is.null(list_style)) {
    if (!is.logical(list_style) || length(list_style) != 1) {
      rlang::abort("list_style must be TRUE or FALSE when provided.")
    }
    style <- if (isTRUE(list_style)) "bullets" else "paragraph"
  }
  style <- match.arg(style)
  if (!("Contribution" %in% names(data))) {
    return("No author contributions provided.")
  }
  
  valid <- data[!is.na(data$Contribution) & data$Contribution != "", ]
  if (nrow(valid) == 0) {
    return("No author contributions provided.")
  }
  
  lines <- apply(valid, 1, function(row) {
    paste0(
      row["FirstName"], " ", row["LastName"],
      " contributed as follows: ",
      row["Contribution"]
    )
  })

  if (style == "paragraph") {
    return(paste(lines, collapse = "; "))
  }
  if (style == "bullets") {
    return(paste0("- ", lines, collapse = "\n"))
  }

  paste0(seq_along(lines), ". ", lines, collapse = "\n")
}
