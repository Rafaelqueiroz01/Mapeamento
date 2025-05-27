#' @export
orange_palette <- list(
  primary = "#FF6B35",
  secondary = "#FFB563",
  accent = "#FF9F1C",
  grid = "#FFE1CC",
  text = "#FFFFFF"
)

#' @export
uf <- tibble::tribble(
  ~cod.uf,	~nom_uf,
  12,	"Acre",
  27,	"Alagoas",
  13,	"Amazonas",
  16,	"Amapá",
  29,	"Bahia",
  23,	"Ceará",
  53,	"Distrito Federal",
  32,	"Espírito Santo",
  52,	"Goiás",
  21,	"Maranhão",
  31,	"Minas Gerais",
  50,	"Mato Grosso do Sul",
  51,	"Mato Grosso",
  15,	"Pará",
  25,	"Paraíba",
  26,	"Pernambuco",
  22,	"Piauí",
  41,	"Paraná",
  33,	"Rio de Janeiro",
  24,	"Rio Grande do Norte",
  11,	"Rondônia",
  14,	"Roraima",
  43,	"Rio Grande do Sul",
  42,	"Santa Catarina",
  28,	"Sergipe",
  35,	"São Paulo",
  17,	"Tocantins")


#' @export
dados <- readRDS("app/data/Dados para aplicativo web.Rds")

#' @export
mapdata <- readRDS("app/data/br-all.Rds")

#' @export
geo <- readRDS("app/data/geo.Rds")

#' @export
serie <- readr::read_csv("app/data/tbl_resultado_demanda.csv")

#' @export
con <- DBI::dbConnect(RSQLite::SQLite(), "app/data/ind_ocupacao")

#' @export
cursos <- readRDS("app/data/cursos_cnct.rds") |> 
  dplyr::distinct(`Denominação do Curso`, .keep_all = T)

#' @export
fechar_con <- shiny::onStop(function() {
  DBI::dbDisconnect(con)
})