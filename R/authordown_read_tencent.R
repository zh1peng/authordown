#' Read author metadata from Tencent table (placeholder)
#'
#' @description This function currently does not fetch data from Tencent tables.
#' Export the table as CSV or XLSX and read it locally with
#' \code{\link{authordown_read_local}}.
#'
#' @param url A Tencent table share URL.
#' @param validate Logical. If TRUE, validate the data.
#' @return A data frame.
#' @export
#' @examples
#' \dontrun{
#' authordown_read_tencent("https://docs.qq.com/sheet/...")
#' }
authordown_read_tencent <- function(url, validate = TRUE) {
  rlang::abort(
    paste(
      "Tencent table import is not available in offline checks.",
      "Please export the table to CSV or XLSX, then use authordown_read_local()."
    )
  )
}
