library(shiny)

load_authordown <- function() {
  if (requireNamespace("authordown", quietly = TRUE)) {
    library(authordown)
    return(invisible(TRUE))
  }

  r_dir <- file.path(getwd(), "R")
  if (!dir.exists(r_dir)) {
    stop("authordown package not installed and R/ directory not found.")
  }
  r_files <- list.files(r_dir, pattern = "\\.R$", full.names = TRUE)
  if (length(r_files) == 0) {
    stop("authordown package not installed and no R/*.R files found.")
  }
  for (r_file in r_files) {
    source(r_file, local = TRUE)
  }
  invisible(TRUE)
}

load_authordown()

server <- function(input, output, session) {
  read_input_data <- function(path, sheet = NULL) {
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
      if (is.null(sheet)) {
        data <- openxlsx::read.xlsx(path)
      } else {
        data <- openxlsx::read.xlsx(path, sheet = sheet)
      }
    } else {
      rlang::abort("Unsupported file type. Use CSV, TSV, or XLSX.")
    }
    authordown_validate(data)
  }

  sample_data <- function() {
    sample_path <- system.file("extdata", "authordown_template.csv", package = "authordown")
    read_input_data(sample_path)
  }

  data_rv <- reactiveVal(sample_data())
  error_rv <- reactiveVal(NULL)

  observeEvent(input$author_file, {
    if (is.null(input$author_file)) {
      data_rv(sample_data())
      error_rv(NULL)
      return()
    }
    tryCatch({
      data_rv(read_input_data(input$author_file$datapath))
      error_rv(NULL)
    }, error = function(e) {
      error_rv(conditionMessage(e))
    })
  }, ignoreInit = TRUE)

  output$validation_msg <- renderText({
    msg <- error_rv()
    if (is.null(msg)) {
      "Validation: OK"
    } else {
      paste("Validation error:", msg)
    }
  })

  output$data_preview <- renderTable({
    data <- data_rv()
    validate(need(is.null(error_rv()), "Fix validation errors to preview data."))
    head(data, 10)
  }, rownames = TRUE)

  outputs_rv <- eventReactive(input$generate, {
    validate(need(is.null(error_rv()), "Fix validation errors before generating outputs."))
    data <- data_rv()

    title_page <- generate_title_page(
      data = data,
      title = input$paper_title,
      style = input$style,
      show_degree = input$show_degree
    )
    acknowledgements <- generate_acknowledgement(data, style = input$ack_style)
    conflict <- generate_conflict(data, style = input$coi_style)
    contributions <- generate_contribution(data, style = input$contrib_style)
    combined <- paste(title_page, acknowledgements, conflict, contributions, sep = "\n\n")

    list(
      title_page = title_page,
      acknowledgements = acknowledgements,
      conflict = conflict,
      contributions = contributions,
      combined = combined
    )
  })

  observeEvent(outputs_rv(), {
    updateTextAreaInput(session, "combined_preview", value = outputs_rv()$combined)
  })

  render_preview_html <- function(text) {
    if (is.null(text) || length(text) == 0) {
      return("")
    }
    lines <- strsplit(text, "\n", fixed = TRUE)[[1]]
    html_lines <- vapply(lines, function(line) {
      is_title <- grepl("^##\\s+", line)
      line_text <- sub("^##\\s+", "", line)
      line_text <- htmltools::htmlEscape(line_text)
      line_text <- gsub("\\^([^\\^]+)\\^([†*]?)", "<sup>\\1\\2</sup>", line_text, perl = TRUE)
      if (!grepl("^[†*]", line_text)) {
        line_text <- gsub("([A-Za-z0-9\\)])([†*])", "\\1<sup>\\2</sup>", line_text, perl = TRUE)
      }
      if (is_title) {
        line_text <- paste0("<strong>", line_text, "</strong>")
      }
      line_text
    }, character(1))

    html <- paste(html_lines, collapse = "<br>")
    htmltools::HTML(
      paste0(
        "<div style=\"white-space: normal; font-family: inherit; font-size: 14px;\">",
        html,
        "</div>"
      )
    )
  }

  output$combined_preview_rendered <- renderUI({
    req(outputs_rv())
    render_preview_html(outputs_rv()$combined)
  })

  output$titlepage <- renderUI({
    req(outputs_rv())
    render_preview_html(outputs_rv()$title_page)
  })

  output$acknowledgements <- renderUI({
    req(outputs_rv())
    render_preview_html(outputs_rv()$acknowledgements)
  })

  output$conflict <- renderUI({
    req(outputs_rv())
    render_preview_html(outputs_rv()$conflict)
  })

  output$contributions <- renderUI({
    req(outputs_rv())
    render_preview_html(outputs_rv()$contributions)
  })

  output$download_template_csv <- downloadHandler(
    filename = function() {
      "authordown_template.csv"
    },
    content = function(file) {
      authordown_template(path = file, format = "csv")
    }
  )

  output$download_template_xlsx <- downloadHandler(
    filename = function() {
      "authordown_template.xlsx"
    },
    content = function(file) {
      if (!requireNamespace("openxlsx", quietly = TRUE)) {
        stop("Package 'openxlsx' is required to generate XLSX templates.")
      }
      authordown_template(path = file, format = "xlsx")
    }
  )
}
