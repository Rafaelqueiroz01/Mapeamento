library(shiny)
library(fullPage)

ui <- fullPage(
  fullSectionImage(
    img = "capa_2.jpg",
    style = "background-size: contain; background-repeat: no-repeat; background-position: center;",
    h1("Minha seção com imagem")
  )
)

server <- function(input, output, session) {}

shinyApp(ui, server)