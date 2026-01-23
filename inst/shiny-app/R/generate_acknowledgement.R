#' Generate an Acknowledgement Section (Updated)
#'
#' @description Combines acknowledgements provided by the authors into a single,
#' coherent sentence. The function ignores author names (as they are assumed to be
#' included in the acknowledgement text itself) and simply concatenates each non-empty
#' acknowledgement entry using a semicolon.
#'
#' @param data A data frame containing at least the column Acknowledgement.
#' @param style Output style: "paragraph", "bullets", or "numbered".
#' @return A character string with the combined acknowledgements.
#' @export
#' @examples
#' authors <- data.frame(
#'   Acknowledgement = c("This work received support from resource X", 
#'                       "Resource Y was instrumental", 
#'                       "Alice Smith received support from resource ZZ"),
#'   stringsAsFactors = FALSE
#' )
#' generate_acknowledgement(authors, style = "paragraph")
generate_acknowledgement <- function(data,
                                     style = c("paragraph", "bullets", "numbered")) {
  style <- match.arg(style)
  if (!("Acknowledgement" %in% names(data))) {
    return("No acknowledgement information provided.")
  }
  
  valid <- data$Acknowledgement[!is.na(data$Acknowledgement) & data$Acknowledgement != ""]
  if (length(valid) == 0) {
    return("No acknowledgements provided.")
  }
  
  prefix <- "Acknowledgements:"
  if (style == "paragraph") {
    result <- paste(valid, collapse = "; ")
    return(paste(prefix, result))
  }
  if (style == "bullets") {
    bullets <- paste0("- ", valid, collapse = "\n")
    return(paste(prefix, bullets, sep = "\n"))
  }

  numbered <- paste0(seq_along(valid), ". ", valid, collapse = "\n")
  paste(prefix, numbered, sep = "\n")
}
