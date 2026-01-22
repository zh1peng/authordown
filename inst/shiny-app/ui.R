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
  tableOutput("data_preview"),

  tags$hr(),
  tags$h3("4) Generate outputs"),
  fluidRow(
    column(4, selectInput("style", "Title page style", choices = c("default", "APA", "Nature"))),
    column(4, checkboxInput("show_degree", "Show degrees", value = FALSE)),
    column(4, textInput("paper_title", "Paper title", value = "Example Paper"))
  ),
  fluidRow(
    column(4, selectInput("ack_style", "Acknowledgements style", choices = c("paragraph", "bullets", "numbered"))),
    column(4, selectInput("coi_style", "Conflict style", choices = c("paragraph", "bullets", "numbered"))),
    column(4, selectInput("contrib_style", "Contributions style", choices = c("paragraph", "bullets", "numbered")))
  ),
  actionButton("generate", "Generate outputs"),

  tags$hr(),
  tags$h3("5) Preview and copy"),
  tags$p("These previews are plain text, ready for copy/paste."),
  textAreaInput("combined_preview", "Combined output", value = "", rows = 12),
  tabsetPanel(
    tabPanel("Title page", verbatimTextOutput("titlepage")),
    tabPanel("Acknowledgements", verbatimTextOutput("acknowledgements")),
    tabPanel("Conflict of interest", verbatimTextOutput("conflict")),
    tabPanel("Contributions", verbatimTextOutput("contributions"))
  )
)
