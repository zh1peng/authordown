library(shiny)
library(authordown)

server <- function(input, output){
  
  author_data <- reactive({
    req(input$author_file)
    read.csv(input$author_file$datapath)
  })

  output$titlepage <- renderPrint({
    req(input$generate)
    generate_title_page(author_data(), style = input$style)
  })
}
