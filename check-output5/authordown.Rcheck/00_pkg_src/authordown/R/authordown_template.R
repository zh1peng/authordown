#' Write an authordown input template
#'
#' @description Copies a standard author metadata template from the package
#' into the requested path. Use this to start a new project with the expected
#' columns and example values.
#'
#' @param path Output file path. Extension determines format if \code{format}
#'   is not supplied.
#' @param format Optional format override: \code{"csv"} or \code{"xlsx"}.
#' @return Invisibly returns the output path.
#' @export
#' @examples
#' \dontrun{
#' authordown_template("authors.csv")
#' authordown_template("authors.xlsx")
#' }
authordown_template <- function(path = "authordown_template.csv", format = NULL) {
  if (is.null(format)) {
    format <- tolower(tools::file_ext(path))
    if (format == "") {
      format <- "csv"
    }
  }
  format <- match.arg(format, c("csv", "xlsx"))

  source_path <- system.file(
    "extdata",
    paste0("authordown_template.", format),
    package = "authordown"
  )
  if (source_path == "") {
    rlang::abort("Template file is missing from inst/extdata.")
  }

  ok <- file.copy(source_path, path, overwrite = TRUE)
  if (!ok) {
    rlang::abort(paste0("Failed to write template to: ", path))
  }

  invisible(path)
}
