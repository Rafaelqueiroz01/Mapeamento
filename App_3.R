#### Carregando Pacotes ####
library(fullPage)
library(shiny)
library(shinyjs)
library(shinyWidgets)
library(shinyalert)

#### Cores das Seções ####
accordion_item <- function(titulo, conteudo) {
  tags$div(class = "acordeao",
           tags$button(class = "acordeao-header", titulo),
           tags$div(class = "acordeao-content",
                    p(style = "font-size: 1em; text-align: justify;", HTML(conteudo))
           )
  )
}

options <- list(
  sectionsColor = c(
    "#C3F3EC", "#FE9199", "#f5f4ef", "#01131a",
    "#C3F3EC", "#FFFFFF", "#FE9199", "#FFADB2"
  )
)

#### Exemplo login ####
usuarios <- data.frame(
  login = c("RJ - 00001", "SP - 00002"),
  senha = c("1234", "abcd"),
  stringsAsFactors = FALSE
)

#### Início UI ####
ui <- fullPage(
  center = TRUE,
  opts = options,
  menu = c(
    "Capa" = "capa",
    "Mapa de Navegação" = "navegacao",
    "Objeto da Pesquisa" = "objeto_pesquisa",
    "Nível da Análise" = "n_analise",
    "Brasil" = "slide_brasil",
    "Departamento Regional" = "slide_dr",
    "Unidade" = "slide_unidade"
    
  ),
  
  tags$head(
    #### CSS personalizado ####
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"),
    #### JS personalizado ####
    tags$script(src = "scriot.js")
  ),
  
  #### Necessário para rodar JS no Shiny ####
  useShinyjs(),
  useShinyalert(),
  
  #### 01 - Capa ####
  fullSectionImage(menu = "capa", img = "capa_2.jpg", h1(" ")),
  
  #### 02 - Navegação ####
  fullSectionImage(menu = "navegacao", img = "navegacao.jpg", h1(" ")),
  
  #### 03 - Objeto da Pesquisa ####
  fullSection(
    menu = "objeto_pesquisa",
    fullSlide(
      h1("Contextualização", style = "color: #800020; font-size: 36px;font-weight: bold;"),
      h2("Blocos da Coleta"),
      
      div(class = "acordeao-container-two-columns",
          div(class = "acordeao-column",
              accordion_item("Características Básicas da Unidade Educacional", "Explicação 1"),
              accordion_item("Reforma", "Explicação 2"),
              accordion_item("Dependências Físicas", "Explicação 3"),
              accordion_item("Infraestrutura Auxiliar", "Explicação 4"),
              accordion_item("Sustentabilidade", "Explicação 5")
          ),
          div(class = "acordeao-column",
              accordion_item("Conectividade", "Explicação 6"),
              accordion_item("Acessibilidade", "Explicação 7"),
              accordion_item("Salas de aula", "Explicação 8"),
              accordion_item("Biblioteca", "Explicação 9"),
              accordion_item("Laboratório", "Explicação 10")
          )
      )
    )
  ),
  
  #### 04 - Nível de Análise ####
  fullSection(
    menu = "n_analise",
    fullContainer(
      tags$h1("Nível da Análise:", style = "color:#FFFFFF"),
      hr(),
      div(style = "background-color: white; padding: 10px; border-radius: 8px;",
          fullButtonTo("Brasil", section = 5)
      ),
      hr(),
      div(style = "background-color: white; padding: 10px; border-radius: 8px;",
          fullButtonTo("Departamento Regional", section = 6)
      ),
      hr(),
      div(style = "background-color: white; padding: 10px; border-radius: 8px;",
          fullButtonTo("Unidade", section = 7)
      )
    )
  ),
  
  #### 05 - Brasil ####
  fullSection(
    menu = "slide_brasil",
    fullSlide(h1("Visão Brasil 1")),
    fullSlide(h1("Visão Brasil 2"))
  ),
  
  #### 06 - DR ####
  fullSection(
    menu = "slide_dr",
    fullSlide(h1("Visão DR 1")),
    fullSlide(h1("Visão DR 2"))
  ),
  #### 07 - Unidade ####
  fullSection(
    menu = "slide_unidade",
    
    #### Slide de login ####
    fullSlide(
      div(class = "login-container",
          div(class = "login-box",
              h1("Área restrita", style = "color: #800020;"),
              
              textInput("login_input", "Login:", placeholder = "ex: RJ - 00001"),
              passwordInput("senha_input", "Senha:", placeholder = "Digite sua senha"),
              actionButton("btn_login", "Entrar"),
              
              br(), br()
             
          )
      )
    ),
    
    #### Slides restritos ####
    fullSlide(id = "slide_unidade_2", h1("Slide 2 - Conteúdo restrito")),
    fullSlide(id = "slide_unidade_3", h1("Slide 3 - Conteúdo restrito"))
  )
)
#### Server ####
server <- function(input, output, session){
  library(dplyr)
  flag <- reactiveVal(FALSE)
  
  #### Exemplo de base de usuários ####
  usuarios <- data.frame(
    login = c("RJ - 00001", "SP - 00002"),
    senha = c("1234", "abcd"),
    stringsAsFactors = FALSE
  )
  
  #### Esconde os slides restritos inicialmente ####
  shinyjs::hide("slide_unidade_2")
  shinyjs::hide("slide_unidade_3")
  
  observe({
    if (!flag()) {
      shinyjs::runjs('configurarAcordeons();')
      flag(TRUE)
    }
  })
  
  #### Validação de login ####
  observeEvent(input$btn_login, {
    req(input$login_input, input$senha_input)
    
    usuario_encontrado <- usuarios %>%
      filter(login == input$login_input, senha == input$senha_input)
    
    if (nrow(usuario_encontrado) == 1) {
      shinyjs::hide("msg_login_erro")
      shinyjs::show("slide_unidade_2")
      shinyjs::show("slide_unidade_3")
      
      shinyalert(
        title = "Login realizado com sucesso!",
        text = "Os conteúdos restritos foram desbloqueados.",
        type = "success",
        timer = 3000
      )
      
    } else {
      shinyalert(
        title = "Login inválido!",
        text = "Usuário ou senha incorretos. Tente novamente.",
        type = "error",
        timer = 4000
      )
    }
  })
}


shinyApp(ui, server)