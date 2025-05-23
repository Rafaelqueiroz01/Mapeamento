
#### Carregando Pacotes ####
library(shiny)
library(fullPage)
#### Cores das Seções ####
options <- list(
  sectionsColor = c(
    "#C3F3EC",
    "#FE9199",
    "#01131a",
    "#FFCAB1",
    "#C3F3EC",
    "#FFFFFF",
    "#FE9199",
    "#FFADB2"
  )
)
#### Início UI ####
ui <- fullPage(
  center = TRUE,
  opts = options,
  #### Lista de Opções ####
  menu = c(
    "Capa" = "capa",
    "Mapa de Navegação" = "navegacao",
    "Nível da Análise" = "n_analise",
    "Brasil"="slide_brasil",
    "Departamento Regional"="slide_DR",
    "Unidade"="slide_unidade"
  ),
  tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")),
  #### 01 - slide - Capa ####
  fullSectionImage( # will not show in viewer, open in browser
    menu = "capa",
    img = "capa_2.jpg",
    h1(" ")
  ),
  
  #### 02 - slide - Mapa de Navegação ####
  fullSectionImage( # will not show in viewer, open in browser
    menu = "navegacao",
    img = "navegacao.jpg",
    h1(" ")
  ),
  #### 03 - slide - Nível de Análise #### 
  fullSection(
    menu = "n_analise",
    #img = "fundo.jpg",
    fullContainer(
      tags$h1("Nível da Análise:", style = "color:#FFFFFF"),
      #### Grupo 1 ####
      hr(),
      div( style = "background-color: white; padding: 10px; border-radius: 8px;",
      fullButtonTo("Brasil", section = 4)
      ),
      #### Grupo 2 ####
      hr(),
      div( style = "background-color: white; padding: 10px; border-radius: 8px;",
      fullButtonTo("Departamento Regional", section = 5)
      ),
      #### Grupo 3 ####
      hr(),
      div( style = "background-color: white; padding: 10px; border-radius: 8px;",
      fullButtonTo("Unidade", section = 6)
      )
    )
  ),
  #### 04 - slide - Brasil ####
  fullSection(
    menu = "slide_brasil",
    fullSlide(
      h1("Slide 1")
    ),
    fullSlide(
      h1("Slide 2")
    )
  ),
  #### 05 - slide - DR ####
  fullSection(
    menu = "slide_DR",
    fullSlide(
      h1("Slide 1")
    ),
    fullSlide(
      h1("Slide 2")
    )
  ),
  #### 06 - slide - Brasil ####
  fullSection(
    menu = "slide_unidade",
    fullSlide(
      h1("Slide 1")
    ),
    fullSlide(
      h1("Slide 2")
    )
  )
)

#### Início Server ####
server <- function(input, output){
  
  output$plot1 <- renderPlot({
    par(bg = "#FFADB2")
    plot(mtcars$wt, mtcars$mpg)
  })
  
  output$plot2 <- renderPlot({
    par(bg = "#F3F3F3")
    hist(rnorm(input$input1, mean = 25, sd = 5))
  })
  
  output$plot3 <- renderPlot({
    par(bg = "#FFADB2")
    plot(1:nrow(mtcars), mtcars$drat, type = "l")
  })
  
  output$sistersDemo <- renderText({
    '# See those
     demo("pagePiling", package = "fullPage")
     demo("multiPage", package = "fullPage")'
  })
}

shinyApp(ui, server)