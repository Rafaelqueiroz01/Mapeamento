box::use(
  dplyr[...],
  highcharter[...],
  tidyr[pivot_longer],
  shiny[NS, div, p, tags, HTML]
)
box::use(
  app/logic/global[uf,
                   serie]
)

hcoptslang <- getOption("highcharter.lang")
hcoptslang$decimalPoint <- ","
hcoptslang$thousandsSep <- "."

options(highcharter.lang = hcoptslang)

#' @export
extrair_familia_cbo <- function(dados, desc = F) {
  
  coluna <- ifelse(desc, "desc.familia.cbo", "familia.cbo")
  
  saida <- dados() %>%
    pull(coluna)
  
  return(saida)
}


#' @export
extrair_valores <- function(dados, 
                            valor = c("vinculos", "renda")) {
  
  valor <- match.arg(valor)
  
  coluna <- switch (valor,
                    renda = "rem2.2022",
                    vinculos = "q.2022"
  )
  
  saida <- dados() %>%  
    pull(coluna)
  
  return(saida)
}

#' @export
pegar_vetor_do_tamanho <- function(x) {
  
  linhas <- nrow(x)
  
  saida <- seq_len(linhas)
  
  return(saida)
}

#' @export
pegar_valor <- function(dados,
                        indice,
                        coluna) {
  saida <- dados %>% 
    slice(indice) %>% 
    pull(coluna)
  
  
  return(saida)
}

#' @export

aplicar_condicação <- function(x, coluna) {
  
  saida <- x[,coluna, 1]
  
  return(saida)
}

#' @export

transformar_condicao_numerico <- function(x) {
  
  valor <- x()
  
  saida <-  case_when(
    valor == "Baixa" ~ 25,
    valor == "Média" ~ 50,
    valor == "Alta" ~ 75,
    .default = 0
  )
  
  return(saida)
  
}

#' @export

transformar_condicao_cores <- function(x) {
  
  valor <- x()
  
  saida <-  case_when(
    valor == "Baixa" ~ "#C62828",
    valor == "Média" ~ "#F9A825",
    valor == "Alta" ~ "#2E7D32",
    .default = "#000"
  )
  
  return(saida)
  
}

#' @export
aplicar_filtro_uf <- function(x) {
  
  codigo <- x %>% pull(cod.uf.trab)
  
  if(length(codigo) == 0) {
    return(0)
  }
  saida <- uf %>% 
    filter(cod.uf == codigo) %>%
    pull(nom_uf)
  
  return(saida)
}

#' @export

aplicar_filtro_nome <- function(x) {
  
  saida <- x %>% 
    pull(desc.familia.cbo)
  
  return(saida)
}

#' @export

formatar_moeda <- function(x){
  
  saida <- x %>%
    format(digits = 2L,
           nsmall = 2L,
           big.mark = ".",
           decimal.mark = ",")
  
  return(saida)
  
}

#' @export
formar_grafico_linha_renda <- function(x) {
  
  x <- x %>% 
    select(rem2.2022,
           rem2.2021, 
           rem2.2020,
           rem2.2019,
           rem2.2018, 
           rem2.2017,
           rem2.2016)
  
  saida <- x %>%
    pivot_longer(cols = everything(), 
                 names_to = "Ano",
                 values_to = "categoria") %>% 
    mutate(Ano = gsub("rem2.", "", Ano),
           Ano = as.numeric(Ano)) %>% 
    arrange(Ano)
  
  
  hc <- highchart() %>%  
    hc_chart(type = "line",
             style = list(fontFamily = "Roboto, sans-serif"),
             backgroundColor = "#F8F9FA") %>% 
    hc_xAxis(categories = saida$Ano,
             title = list(text = "Ano",
                         style = list(color = "#2C3E50",
                                    fontSize = "14px",
                                    fontWeight = "bold")),
             gridLineColor = "#E9ECEF",
             lineColor = "#E9ECEF",
             tickColor = "#E9ECEF",
             labels = list(style = list(color = "#495057",
                                      fontSize = "12px"))) %>%  
    hc_title(text = "Evolução da Remuneração por hora (Mediana)",
             style = list(color = "#2C3E50",
                         fontSize = "18px",
                         fontWeight = "bold")) %>%
    hc_add_series(
      name = "Remuneração mediana por hora",
      data = saida$categoria,
      color = "#FF6B6B",
      lineWidth = 3,
      marker = list(
        enabled = TRUE,
        radius = 6,
        symbol = "circle",
        fillColor = "#FF6B6B",
        lineWidth = 2,
        lineColor = "#FFFFFF"
      )
    ) %>%
    hc_yAxis(
      title = list(text = "Vendas",
                  style = list(color = "#2C3E50",
                             fontSize = "14px",
                             fontWeight = "bold")),
      labels = list(format = "R$ {value:,.2f}",
                   style = list(color = "#495057",
                              fontSize = "12px")),
      gridLineColor = "#E9ECEF",
      lineColor = "#E9ECEF",
      tickColor = "#E9ECEF"
    ) %>% 
    hc_tooltip(
      backgroundColor = "#FFFFFF",
      borderWidth = 0,
      borderRadius = 8,
      shadow = TRUE,
      style = list(fontSize = "14px"),
      pointFormat = "<b>Valor:</b> R$ {point.y:,.2f}"
    ) %>% 
    hc_plotOptions(
      line = list(
        lineWidth = 3,
        states = list(
          hover = list(
            lineWidth = 4
          )
        )
      )
    )
}

#' @export

formar_grafico_linha_contratacao <- function(x) {
  
  x <- x %>% 
    select(q.2022,
           q.2021, 
           q.2020, 
           q.2019, 
           q.2018, 
           q.2017,
           q.2016)
  
  saida <- x %>%
    pivot_longer(cols = everything(), 
                 names_to = "Ano",
                 values_to = "categoria") %>% 
    mutate(Ano = gsub("q.", "", Ano),
           Ano = as.numeric(Ano)) %>% 
    arrange(Ano)
  
  
  hc <- highchart() %>%  
    hc_chart(type = "line",
             style = list(fontFamily = "Roboto, sans-serif"),
             backgroundColor = "#F8F9FA") %>% 
    hc_xAxis(categories = saida$Ano,
             title = list(text = "Ano",
                         style = list(color = "#2C3E50",
                                    fontSize = "14px",
                                    fontWeight = "bold")),
             gridLineColor = "#E9ECEF",
             lineColor = "#E9ECEF",
             tickColor = "#E9ECEF",
             labels = list(style = list(color = "#495057",
                                      fontSize = "12px"))) %>%  
    hc_title(text = "Evolução das contratações da família ocupacional na UF",
             style = list(color = "#2C3E50",
                         fontSize = "18px",
                         fontWeight = "bold")) %>%
    hc_add_series(
      name = "Contratações",
      data = saida$categoria,
      color = "#4ECDC4",
      lineWidth = 3,
      marker = list(
        enabled = TRUE,
        radius = 6,
        symbol = "circle",
        fillColor = "#4ECDC4",
        lineWidth = 2,
        lineColor = "#FFFFFF"
      )
    ) %>%
    hc_yAxis(
      title = list(text = "Contratações",
                  style = list(color = "#2C3E50",
                             fontSize = "14px",
                             fontWeight = "bold")),
      labels = list(format = "{value:,.0f}",
                   style = list(color = "#495057",
                              fontSize = "12px")),
      gridLineColor = "#E9ECEF",
      lineColor = "#E9ECEF",
      tickColor = "#E9ECEF"
    ) %>% 
    hc_tooltip(
      backgroundColor = "#FFFFFF",
      borderWidth = 0,
      borderRadius = 8,
      shadow = TRUE,
      style = list(fontSize = "14px"),
      pointFormat = "<b>Valor:</b> {point.y:,.0f}"
    ) %>% 
    hc_plotOptions(
      line = list(
        lineWidth = 3,
        states = list(
          hover = list(
            lineWidth = 4
          )
        )
      )
    )
}


#' @export

accordion_item <- function(titulo, conteudo) {
  
  tags$div(class = "acordeao",
           tags$button(class = "acordeao-header", 
                       titulo),
           tags$div(class = "acordeao-content",
                    p(style = "font-size: 1em;
                               text-align: justify;",
                      HTML(conteudo))
           )
  )
}


#' @export

formar_frase_da_mediana <- function(uf) {
  if(uf == 0){
    return("UF não informada!")
  }
  preposicoes <- c(
    "Acre" = "no Acre",
    "Alagoas" = "em Alagoas",
    "Amapá" = "no Amapá",
    "Amazonas" = "no Amazonas",
    "Bahia" = "na Bahia",
    "Ceará" = "no Ceará",
    "Distrito Federal" = "no Distrito Federal",
    "Espírito Santo" = "no Espírito Santo",
    "Goiás" = "em Goiás",
    "Maranhão" = "no Maranhão",
    "Mato Grosso" = "em Mato Grosso",
    "Mato Grosso do Sul" = "em Mato Grosso do Sul",
    "Minas Gerais" = "em Minas Gerais",
    "Pará" = "no Pará",
    "Paraíba" = "na Paraíba",
    "Paraná" = "no Paraná",
    "Pernambuco" = "em Pernambuco",
    "Piauí" = "no Piauí",
    "Rio de Janeiro" = "no Rio de Janeiro",
    "Rio Grande do Norte" = "no Rio Grande do Norte",
    "Rio Grande do Sul" = "no Rio Grande do Sul",
    "Rondônia" = "em Rondônia",
    "Roraima" = "em Roraima",
    "Santa Catarina" = "em Santa Catarina",
    "São Paulo" = "em São Paulo",
    "Sergipe" = "em Sergipe",
    "Tocantins" = "no Tocantins"
  )
  
  
  if (!uf %in% names(preposicoes)) {
    stop("UF inválida! Informe um nome de estado brasileiro válido.")
  }
  
  resultado <- preposicoes[uf]
  frase <- sprintf("Mediana da remuneração por hora %s em 2022.", resultado)
  
  return(frase)
}

#' @export
tratar_serie <- function(fam) {
  
  
  codigo <- fam %>% pull(cod.uf.trab)
  
  fam <- fam %>% pull(familia.cbo)
  
  saida <- serie %>% 
    filter(cod_uf_trab %in%codigo) %>% 
    filter(familia == fam)
  
  
  return(saida)
}

#' @export
fazer_grafico_de_tempo_esc <- function(dados) {

  hchart(dados(),
         "line",
         hcaes_(x = "ano", 
                y = "esc" ),
         backgroundColor = "#e9e9e9",
         style = list(fontFamily = "Arial, sans-serif")) %>%
    hc_colors("#2E5077") %>% 
    hc_tooltip(formatter = JS("function() { return Highcharts.numberFormat(this.y * 100, 2) + '%'; }"),
               backgroundColor = "rgba(247, 247, 247, 0.9)",
               borderWidth = 0,
               shadow = FALSE) %>%
    hc_yAxis(title = list(text = "Proporção (%)",
                          style = list(
                            color = "#666666",
                            fontSize = "14px")),
             labels = list(
               formatter = JS("function() { return Highcharts.numberFormat(this.value * 100, 2) + '%'; }"),
               style = list(color = "#666666")),
             gridLineColor = "rgba(230, 230, 230, 0.5)",
             lineColor = "rgba(230, 230, 230, 0.5)"
    ) %>%
    hc_xAxis(title = list(text = "Ano",
                          style = list(
                            color = "#666666",
                            fontSize = "14px")),
             labels = list(style = list(color = "#666666")),
             gridLineColor = "rgba(230, 230, 230, 0.5)",
             lineColor = "rgba(230, 230, 230, 0.5)"
    ) %>%
    hc_plotOptions(line = list(lineWidth = 2,
                               marker = list(
                                 enabled = TRUE,
                                 radius = 4,
                                 symbol = "circle")
                               )
    )
}

#' @export
fazer_grafico_de_tempo_jovens <- function(dados) {
  
  hchart(dados(),
         "line",
         hcaes_(x = "ano", 
                y = "idade_ate29" ),
         backgroundColor = "#e9e9e9",
         style = list(fontFamily = "Arial, sans-serif")) %>%
    hc_colors("#2E5077") %>% 
    hc_tooltip(formatter = JS("function() { return Highcharts.numberFormat(this.y*100, 2) + '%'; }"),
               backgroundColor = "rgba(247, 247, 247, 0.9)",
               borderWidth = 0,
               shadow = FALSE) %>%
    hc_yAxis(title = list(text = "Proporção (%)",
                          style = list(
                            color = "#666666",
                            fontSize = "14px")),
             labels = list(
               formatter = JS("function() { return Highcharts.numberFormat(this.value * 100, 2) + '%'; }"),
               style = list(color = "#666666")),
             gridLineColor = "rgba(230, 230, 230, 0.5)",
             lineColor = "rgba(230, 230, 230, 0.5)"
    ) %>%
    hc_xAxis(title = list(text = "Ano",
                          style = list(
                            color = "#666666",
                            fontSize = "14px")),
             labels = list(style = list(color = "#666666")),
             gridLineColor = "rgba(230, 230, 230, 0.5)",
             lineColor = "rgba(230, 230, 230, 0.5)"
    ) %>%
    hc_plotOptions(line = list(lineWidth = 2,
                               marker = list(
                                 enabled = TRUE,
                                 radius = 4,
                                 symbol = "circle")
    )
    )
}

#' @export
fazer_grafico_de_tempo_idade <- function(dados) {
  
  hchart(dados(),
         "line",
         hcaes_(x = "ano", 
                y = "idade" ),
         backgroundColor = "#e9e9e9",
         style = list(fontFamily = "Arial, sans-serif")) %>%
    hc_colors("#2E5077") %>% 
    hc_tooltip(formatter = JS("function() { return Highcharts.numberFormat(this.y, 2); }"),
               backgroundColor = "rgba(247, 247, 247, 0.9)",
               borderWidth = 0,
               shadow = FALSE) %>%
    hc_yAxis(title = list(text = "Idade mediana",
                          style = list(
                            color = "#666666",
                            fontSize = "14px")),
             labels = list(
               formatter = JS("function() { return Highcharts.numberFormat(this.value, 0) ; }"),
               style = list(color = "#666666")),
             gridLineColor = "rgba(230, 230, 230, 0.5)",
             lineColor = "rgba(230, 230, 230, 0.5)"
    ) %>%
    hc_xAxis(title = list(text = "Ano",
                          style = list(
                            color = "#666666",
                            fontSize = "14px")),
             labels = list(style = list(color = "#666666")),
             gridLineColor = "rgba(230, 230, 230, 0.5)",
             lineColor = "rgba(230, 230, 230, 0.5)"
    ) %>%
    hc_plotOptions(line = list(lineWidth = 2,
                               marker = list(
                                 enabled = TRUE,
                                 radius = 4,
                                 symbol = "circle")
    )
    )
}