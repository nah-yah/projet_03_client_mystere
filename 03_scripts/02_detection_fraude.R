library(tidyverse)

df <- read_csv("02_donnees/nettoyees/bca_audit_clean.csv", show_col_types = FALSE)

t1 <- as.POSIXct(df$m1_t1_arrivee, format = "%H:%M:%S", tz = "UTC")
t4 <- as.POSIXct(df$m1_t4_depart,  format = "%H:%M:%S", tz = "UTC")

df <- df |>
  mutate(
    fd_01 = !is.na(m1_duree_totale) & m1_duree_totale < 3,
    fd_02 = !is.na(m1_gps_valide) & m1_gps_valide == 0,
    fd_03 = !is.na(m8_score_antifraude) & m8_score_antifraude < 6,
    fd_04 = !is.na(t1) & !is.na(t4) & t4 < t1,
    fd_06 = !is.na(m8_delai_soumission) & m8_delai_soumission < 8,
    n_flags = fd_01 + fd_02 + fd_03 + fd_04 + fd_06,
    exclure = n_flags >= 2
  )

cat(sprintf(
  "FD-01:%d  FD-02:%d  FD-03:%d  FD-04:%d  FD-06:%d | 2+flags:%d | retenues:%d/%d\n",
  sum(df$fd_01, na.rm = TRUE),
  sum(df$fd_02, na.rm = TRUE),
  sum(df$fd_03, na.rm = TRUE),
  sum(df$fd_04, na.rm = TRUE),
  sum(df$fd_06, na.rm = TRUE),
  sum(df$exclure, na.rm = TRUE),
  sum(!df$exclure, na.rm = TRUE),
  nrow(df)
))

dir.create("05_qualite_donnees", showWarnings = FALSE, recursive = TRUE)
write_csv(df, "05_qualite_donnees/flags_fraude.csv", na = "")
cat("-> 05_qualite_donnees/flags_fraude.csv\n")