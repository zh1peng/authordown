library(shiny)

ui <- source("ui.R", local = TRUE)$value
server <- source("server.R", local = TRUE)$value

shinyApp(ui = ui, server = server)
