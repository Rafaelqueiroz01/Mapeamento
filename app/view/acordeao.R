box::use(
  shiny[NS, div, moduleServer, tagList, tags, HTML]
)

box::use(
  app/logic/funcoes_auxiliares[accordion_item]
)

ui <- function(id) {
  ns <- NS(id)
  tagList(
    div(class = "acordeao-container",
        accordion_item("O que é o índice de Demanda Futura?", 
                       "É um indicador calculado a partir de técnicas de análise fatorial, que buscam identificar as 
            correlações observadas em um conjunto de variáveis e, com isso, sintetizar as informações 
            observadas por essas variáveis através de um único valor. Neste caso, utilizamos as variações 
            do número de vínculos e as remunerações observadas no mercado de trabalho brasileiro, 
            variáveis basilares para as análises típicas de demanda."),
        
        accordion_item("Quais são as regras de tendência de demanda?", 
                       "<ul style = 'margin-left: 0;text-align: justify;'>
                <li><strong>Regra A:</strong> Tendência de demanda restrita: o número de contratações e salários 
                para aquela família ocupacional cresceram juntos em ao menos 3 anos entre 2016 e 2021.</li>
                <li><strong>Regra B:</strong> Tendência de contratação: o número de contratações para aquela 
                família ocupacional cresceu em ao menos 3 anos entre 2016 e 2021.</li>
                <li><strong>Regra C:</strong> Crescimento de contratações absoluto: houve crescimento de 
                contratações em todos os anos entre 2016 e 2021.</li>
                <li><strong>Regra D:</strong> Aumento de salários: houve aumento dos salários para aquela 
                família ocupacional em ao menos três anos entre 2016 e 2021.</li>
            </ul>"),
        
        accordion_item("Como incluir características específicas do meu estado para análise de demanda?", 
                       "Além das regras pré-definidas acima, você pode escolher as famílias ocupacionais de interesse 
            a partir de características específicas, como maior proporção de jovens, ou para cursos que são 
            oferecidos pelo Senac (possuem PCN)."),
        
        accordion_item("Como utilizar o painel para tomada de decisão?", 
                       "O painel está estruturado para te auxiliar a ajustar a oferta educacional à luz das famílias 
            ocupacionais que estão em alta de demanda no mercado. Você pode navegar pelas diferentes tendências 
            e escolher as famílias ocupacionais e cursos em destaque que dialogam com a sua oferta e realidade local."),
        
        accordion_item("Qual tipo de trabalho é considerado?", 
                       "Nesta pesquisa, utilizamos os dados da RAIS, que acompanha toda contratação formal no país. 
            Embora esta seja uma limitação, considerando que boa parte das pessoas ocupadas nos setores 
            de comércio e serviços ainda estão na informalidade, o uso destes dados nos permite ter uma 
            fonte censitária e confiável."),
        
        accordion_item("Qual o período de tempo considerado na análise?", 
                       "Os dados utilizados nesta versão da pesquisa são referentes ao período 2016-2021. A escolha 
            deste período se deu em virtude da disponibilidade das bases de dados, além de permitir observar 
            as movimentações de curto e médio prazo para pensar a dinâmica do mercado de trabalho."),
        
        accordion_item("Como os indicadores foram calculados?", 
                       "As variáveis utilizadas são calculadas a partir da variação do número de vínculos e remuneração 
            em relação a 2016. O cálculo do indicador fatorial considera também pesos maiores para os anos 
            mais recentes (2019-2021), e menores para os anos anteriores (2017 e 2018).")
    )
  )
}


server <- function(id) {
  moduleServer(id, function(input, output, session) {})
}
