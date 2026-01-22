#' Render a Manuscript Section to HTML
#'
#' @description This function takes a section title, a content-generating function, and a data frame,
#' then produces an HTML file that displays the section header and its content. This generic function
#' works for any section (e.g. Conflict of Interest, Author Contributions, Acknowledgements).
#'
#' @param section_title A character string for the section header (e.g., "Conflict of Interest").
#' @param content_function A function that accepts a data frame and returns a formatted character string.
#' @param data A data frame containing the necessary columns.
#' @param output_file The path to the output HTML file. Defaults to a temporary file.
#' @param ... Additional arguments passed to \code{content_function}.
#' @return A character string with the path to the rendered HTML file.
#' @export
#' @examples
#' \dontrun{
#'   # To render the Conflict of Interest section:
#'   html_path <- render_section_html("Conflict of Interest", generate_conflict, authors)
#'   browseURL(html_path)
#' }
render_section_html <- function(section_title, content_function, data,
                                output_file = tempfile(fileext = ".html"),...) {
  if (!requireNamespace("rmarkdown", quietly = TRUE)) {
    rlang::abort("Package 'rmarkdown' is required to render HTML output.")
  }
  # Get the section content
  content <- content_function(data, ...)
  
  # Build an R Markdown document with a section header and content
  rmd_content <- paste0(
    "---\n",
    "title: \"", "HTML output", "\"\n",
    "output: html_document\n",
    "---\n\n",
    "### ", section_title, "\n\n",
    content, "\n"
  )
  
  # Write the Rmd content to a temporary file and render it to HTML
  rmd_file <- tempfile(fileext = ".Rmd")
  writeLines(rmd_content, con = rmd_file)
  rmarkdown::render(input = rmd_file, output_file = output_file, quiet = TRUE)
  
  message("HTML file generated at: ", output_file)
  return(output_file)
}
