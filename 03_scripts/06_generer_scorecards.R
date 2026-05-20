library(tidyverse)
library(rmarkdown)

agences <- read_csv("02_donnees/nettoyees/scores_agences.csv", show_col_types = FALSE)

walk(agences$id_agence, \(ag) {
  cat(sprintf("[%d/%d] %s\n", which(agences$id_agence == ag), nrow(agences), ag))
  render(
    input       = "04_rapport/scorecards/scorecard_template.Rmd",
    output_file = paste0("scorecard_", ag, ".pdf"),
    output_dir  = "04_rapport/scorecards",
    params      = list(agence_id = ag),
    envir       = new.env(),
    quiet       = TRUE
  )
})

cat(sprintf("\n%d scorecards -> 04_rapport/scorecards/\n", nrow(agences)))