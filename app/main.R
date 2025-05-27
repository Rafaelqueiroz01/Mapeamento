box::use(
  shiny[moduleServer,
        NS,
        observe,
        reactiveVal,
        tagList,
        tags],
  fullPage[fullPage],
  shinyjs[useShinyjs]
)


box::use(
  home = app/view/Slide_home,
  intro = app/view/Slide_intro,
  rank = app/view/Slide_rank,
  ocupacao = app/view/Slide_ocupacao_main,
  cursos = app/view/Slide_cursos_main,
  app/logic/global[fechar_con]
)


#' @export
ui <- function(id) {
  ns <- NS(id)
  tagList(
    tags$div(tags$img(src = "static/Logo-Senac.svg", 
                      class = "logo-class"),
             style = "height: 13vh;
                 position: fixed;
                 top: 0;
                 left: 0;
                 width: 10vw;
                 z-index: 100;
                 display: flex;
                 justify-content: space-between;"),
    fullPage(
      opts = list(
        navigation = FALSE,
        #navigationPosition = "right",
        showActiveTooltip = TRUE,
        slidesNavigation = TRUE,
        controlArrows = TRUE,
        sectionsColor = c("#AFC9D6", 
                          "#C9AFD6", 
                          "#D6AFC9", 
                          "#D6AFAF",
                          "#D6C0AF")
        # sectionsColor = c("#005F73", 
        #                   "#0A9396", 
        #                   "#94D2BD", 
        #                   "#EE9B00",
        #                   "#CA6702")
      ),
      useShinyjs(),
      home$ui(ns("home")),
      intro$ui(ns("intro")),
      rank$ui(ns("rank")),
      ocupacao$ui(ns("selecao")),
      cursos$ui(ns("cursos"))
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    
    fechar_con()
    
    flag <- reactiveVal(FALSE)
    
    observe({
      if(!flag()){
        shinyjs::runjs('configurarAcordeons()')
        
        flag(TRUE)
      }
    })
    
    home$server("home")
    
    dados_selecionado <- intro$server("intro")
    
    familia_selecionada <- rank$server("rank", dados_selecionado)
    
    ocupacao$server("selecao", familia_selecionada)
    cursos$server("cursos", familia_selecionada)
    
    
  })
}