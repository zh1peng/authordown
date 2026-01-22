library(shiny)
library(authordown)

server <- function(input, output, session) {
  sample_data <- function() {
    sample_path <- system.file("extdata", "authordown_template.csv", package = "authordown")
    authordown_read_local(sample_path)
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
      data_rv(authordown_read_local(input$author_file$datapath))
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

  output$titlepage <- renderPrint({
    req(outputs_rv())
    outputs_rv()$title_page
  })

  output$acknowledgements <- renderPrint({
    req(outputs_rv())
    outputs_rv()$acknowledgements
  })

  output$conflict <- renderPrint({
    req(outputs_rv())
    outputs_rv()$conflict
  })

  output$contributions <- renderPrint({
    req(outputs_rv())
    outputs_rv()$contributions
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
