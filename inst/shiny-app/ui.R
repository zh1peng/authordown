library(shiny)

fluidPage(
  titlePanel("authordown Manuscript Front Matter"),
  tags$p("Workflow: download template \u2192 upload completed file \u2192 preview data \u2192 generate outputs."),
  tags$hr(),

  tags$h3("1) Download template"),
  tags$p("Start by downloading the standard template and fill it in."),
  fluidRow(
    column(6, downloadButton("download_template_csv", "Download CSV template")),
    column(6, downloadButton("download_template_xlsx", "Download XLSX template"))
  ),

  tags$hr(),
  tags$h3("2) Upload completed template"),
  fileInput("author_file", "Upload CSV or XLSX", accept = c(".csv", ".xlsx", ".tsv")),
  tags$p("Supported formats: CSV, TSV, XLSX."),
  tags$p("Affiliations: use columns named Affiliation1, Affiliation2, ... AffiliationN."),
  verbatimTextOutput("validation_msg"),

  tags$hr(),
  tags$h3("3) Preview parsed data"),
  tags$div(
    style = "max-height: 320px; overflow-y: auto; border: 1px solid #ddd; padding: 6px;",
    tableOutput("data_preview")
  ),

  tags$hr(),
  tags$h3("4) Generate outputs"),
  fluidRow(
    column(4, selectInput("style", "Title page style", choices = c("default", "APA", "Nature"))),
    column(4, checkboxInput("show_degree", "Show degrees", value = FALSE)),
    column(4, textInput("paper_title", "Paper title", value = "A great paper"))
  ),
  fluidRow(
    column(4, selectInput("ack_style", "Acknowledgements style", choices = c("paragraph", "bullets", "numbered"))),
    column(4, selectInput("coi_style", "Conflict style", choices = c("paragraph", "bullets", "numbered"))),
    column(4, selectInput("contrib_style", "Contributions style", choices = c("paragraph", "bullets", "numbered")))
  ),
  actionButton("generate", "Generate outputs"),

  tags$hr(),
  tags$h3("5) Preview and copy"),
  tags$p("These previews are formatted for clean copy/paste."),
  uiOutput("combined_preview_rendered"),
  checkboxInput("show_plain", "Show plain text output", value = FALSE),
  conditionalPanel(
    condition = "input.show_plain",
    textAreaInput("combined_preview", "Combined output (plain text)", value = "", rows = 12)
  ),
  tabsetPanel(
    tabPanel("Title page", uiOutput("titlepage")),
    tabPanel("Acknowledgements", uiOutput("acknowledgements")),
    tabPanel("Conflict of interest", uiOutput("conflict")),
    tabPanel("Contributions", uiOutput("contributions"))
  )
)
