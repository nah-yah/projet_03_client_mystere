root <- "projet_03_client_mystere"

dirs <- file.path(root, c(
  "00_methodologie",
  "01_instrument",
  "02_donnees/brutes",
  "02_donnees/nettoyees",
  "03_scripts",
  "04_rapport/scorecards",
  "04_rapport/tableau_de_bord",
  "05_qualite_donnees"
))

invisible(lapply(dirs, dir.create, recursive = TRUE, showWarnings = FALSE))
cat(length(dirs), "dossiers créés dans", root, "\n")