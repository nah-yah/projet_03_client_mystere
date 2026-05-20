library(tidyverse)

df    <- read_csv("05_qualite_donnees/flags_fraude.csv", show_col_types = FALSE)
clean <- filter(df, !exclure)

cat(sprintf("Chargé : %d | exclus : %d | retenus : %d\n", 
            nrow(df), nrow(df) - nrow(clean), nrow(clean)))

clean <- clean |>
  mutate(
    score_ecart_global = score_composite - mean(score_composite, na.rm = TRUE),
    conforme_m3        = m3_score_brut >= 14 * 0.75,
    conforme_m4        = m4_score_brut >= 16 * 0.75,
    conforme_m5        = m5_score_norm >= 25 * 0.75,
    creneau_num        = match(m1_creneau, c("Matin", "Midi", "Apres-midi"))
  )

scores_agences <- clean |>
  group_by(id_agence, code_territoire, territoire, tier,
           groupe_anciennete, anciennete_ans, zone_type, nb_agents_estime) |>
  summarise(
    n_visites        = n(),
    score_moy        = round(mean(score_composite, na.rm = TRUE), 1),
    score_sd         = round(sd(score_composite, na.rm = TRUE), 1),
    score_min        = round(min(score_composite, na.rm = TRUE), 1),
    score_max        = round(max(score_composite, na.rm = TRUE), 1),
    moy_m2           = round(mean(m2_score_brut / 11 * 10, na.rm = TRUE), 1),
    moy_m3           = round(mean(m3_score_brut / 14 * 15, na.rm = TRUE), 1),
    moy_m4           = round(mean(m4_score_brut / 16 * 20, na.rm = TRUE), 1),
    moy_m5           = round(mean(m5_score_norm / 25 * 30, na.rm = TRUE), 1),
    moy_m6           = round(mean(m6_score_brut / 11 * 10, na.rm = TRUE), 1),
    moy_m7           = round(mean(m7_score_brut / 13 * 15, na.rm = TRUE), 1),
    taux_conforme_m3 = round(mean(conforme_m3, na.rm = TRUE) * 100, 1),
    taux_conforme_m4 = round(mean(conforme_m4, na.rm = TRUE) * 100, 1),
    taux_conforme_m5 = round(mean(conforme_m5, na.rm = TRUE) * 100, 1),
    .groups          = "drop"
  ) |>
  mutate(
    rang_global  = rank(-score_moy, ties.method = "min"),
    bande_agence = factor(
      case_when(score_moy >= 90 ~ "A", score_moy >= 75 ~ "B",
                score_moy >= 60 ~ "C", score_moy >= 45 ~ "D", TRUE ~ "F"),
      levels = c("F","D","C","B","A"), ordered = TRUE),
    ecart_reseau = round(score_moy - mean(score_moy, na.rm = TRUE), 1)
  ) |>
  group_by(code_territoire) |>
  mutate(rang_territoire = rank(-score_moy, ties.method = "min")) |>
  ungroup() |>
  arrange(rang_global)

scores_territoires <- clean |>
  group_by(code_territoire, territoire) |>
  summarise(
    n_agences = n_distinct(id_agence),
    n_visites = n(),
    score_moy = round(mean(score_composite, na.rm = TRUE), 1),
    score_sd  = round(sd(score_composite, na.rm = TRUE), 1),
    score_min = round(min(score_composite, na.rm = TRUE), 1),
    score_max = round(max(score_composite, na.rm = TRUE), 1),
    moy_m2    = round(mean(m2_score_brut / 11 * 10, na.rm = TRUE), 1),
    moy_m3    = round(mean(m3_score_brut / 14 * 15, na.rm = TRUE), 1),
    moy_m4    = round(mean(m4_score_brut / 16 * 20, na.rm = TRUE), 1),
    moy_m5    = round(mean(m5_score_norm / 25 * 30, na.rm = TRUE), 1),
    moy_m6    = round(mean(m6_score_brut / 11 * 10, na.rm = TRUE), 1),
    moy_m7    = round(mean(m7_score_brut / 13 * 15, na.rm = TRUE), 1),
    .groups   = "drop"
  ) |>
  mutate(
    rang         = rank(-score_moy, ties.method = "min"),
    ecart_reseau = round(score_moy - mean(score_moy, na.rm = TRUE), 1)
  ) |>
  arrange(rang)

print(scores_territoires |> select(code_territoire, n_visites, score_moy, rang))
print(scores_agences |>
        select(id_agence, code_territoire, score_moy, bande_agence, rang_global) |>
        slice(c(1:5, (n() - 4):n())))

write_csv(clean,              "02_donnees/nettoyees/bca_audit_clean.csv",      na = "")
write_csv(scores_agences,     "02_donnees/nettoyees/scores_agences.csv",       na = "")
write_csv(scores_territoires, "02_donnees/nettoyees/scores_territoires.csv",   na = "")

cat("-> Exportés dans 02_donnees/nettoyees/\n")