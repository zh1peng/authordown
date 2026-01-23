library(shiny)

app_dir <- file.path("inst", "shiny-app")
ui <- source(file.path(app_dir, "ui.R"), local = TRUE)$value
server <- source(file.path(app_dir, "server.R"), local = TRUE)$value

shinyApp(ui = ui, server = server)
