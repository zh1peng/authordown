#' Generate a sample CSV template for authordown
#'
#' @description Creates a sample CSV (or Excel) with columns for authors,
#' affiliations, acknowledgments, conflicts, etc.
#' @param file A file path where the template should be written.
#'   Defaults to \"authordown_template.csv\" in the current directory.
#' @param excel Logical. If TRUE, writes an Excel file (.xlsx) instead of CSV.
#' @return Invisibly returns the data frame used for the template.
#' @export
#' @examples
#' \dontrun{
#' generate_template() # writes authordown_template.csv
#' }
generate_template <- function(file = "authordown_template.csv", excel = FALSE) {
  format <- if (isTRUE(excel)) "xlsx" else "csv"
  if (!grepl(paste0("\\.", format, "$"), file, ignore.case = TRUE)) {
    file <- paste0(file, ".", format)
  }

  authordown_template(path = file, format = format)
  message("Template written to: ", file)

  invisible(authordown_read_local(file, validate = FALSE))
}
