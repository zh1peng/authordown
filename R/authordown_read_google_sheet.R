#' Read author metadata from Google Sheets (placeholder)
#'
#' @description This function currently does not fetch data from Google Sheets.
#' Export the sheet as CSV or XLSX and read it locally with
#' \code{\link{authordown_read_local}}.
#'
#' @param url A Google Sheets share URL.
#' @param validate Logical. If TRUE, validate the data.
#' @return A data frame.
#' @export
#' @examples
#' \dontrun{
#' authordown_read_google_sheet("https://docs.google.com/spreadsheets/d/...")
#' }
authordown_read_google_sheet <- function(url, validate = TRUE) {
  rlang::abort(
    paste(
      "Google Sheets import is not available in offline checks.",
      "Please export the sheet to CSV or XLSX, then use authordown_read_local()."
    )
  )
}
