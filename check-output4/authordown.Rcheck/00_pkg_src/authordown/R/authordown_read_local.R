#' Read a local author metadata file
#'
#' @description Reads a CSV/TSV/XLSX file and returns a standardized data frame.
#' By default, the data are validated for required columns and basic formats.
#'
#' @param path Path to a local CSV, TSV, or XLSX file.
#' @param sheet Optional sheet name or index for XLSX files.
#' @param validate Logical. If TRUE, validate the data.
#' @return A data frame with standardized columns.
#' @export
#' @examples
#' \dontrun{
#' authors <- authordown_read_local("authors.csv")
#' }
authordown_read_local <- function(path, sheet = NULL, validate = TRUE) {
  if (!file.exists(path)) {
    rlang::abort(paste0("File not found: ", path))
  }

  ext <- tolower(tools::file_ext(path))
  if (ext %in% c("csv", "txt")) {
    data <- utils::read.csv(path, stringsAsFactors = FALSE, check.names = FALSE)
  } else if (ext == "tsv") {
    data <- utils::read.delim(path, stringsAsFactors = FALSE, check.names = FALSE)
  } else if (ext == "xlsx") {
    if (!requireNamespace("openxlsx", quietly = TRUE)) {
      rlang::abort("Package 'openxlsx' is required to read XLSX files.")
    }
    data <- openxlsx::read.xlsx(path, sheet = sheet)
  } else {
    rlang::abort("Unsupported file type. Use CSV, TSV, or XLSX.")
  }

  if (isTRUE(validate)) {
    return(authordown_validate(data))
  }

  authordown_canonicalize(data)
}
