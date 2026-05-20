library(tidyverse)
Sys.setlocale("LC_ALL", "fr_FR.UTF-8")
options(encoding = "UTF-8")

visites     <- read_csv("02_donnees/nettoyees/bca_audit_clean.csv",    show_col_types = FALSE)
agences     <- read_csv("02_donnees/nettoyees/scores_agences.csv",     show_col_types = FALSE)
territoires <- read_csv("02_donnees/nettoyees/scores_territoires.csv", show_col_types = FALSE)

dir.create("04_rapport", showWarnings = FALSE, recursive = TRUE)

visites <- visites |>
  mutate(
    territoire_label = case_when(
      code_territoire == "MQ" ~ "Martinique",
      code_territoire == "GP" ~ "Guadeloupe",
      code_territoire == "GF" ~ "Guyane française",
      TRUE ~ as.character(code_territoire)
    ),
    zone_type_label = if_else(zone_type == "Peri-urbaine", "Péri-urbaine", zone_type),
    groupe_anciennete_label = case_when(
      groupe_anciennete == "G1" ~ "Historique (≥25 ans)",
      groupe_anciennete == "G2" ~ "Établie (15-24 ans)",
      groupe_anciennete == "G3" ~ "Récente (6-14 ans)",
      groupe_anciennete == "G4" ~ "Très récente (≤5 ans)",
      TRUE ~ as.character(groupe_anciennete)
    ),
    creneau_label = case_when(
      m1_creneau == "Matin"      ~ "Matin (8h-12h)",
      m1_creneau == "Midi"       ~ "Midi (12h-14h)",
      m1_creneau == "Apres-midi" ~ "Après-midi (14h-17h)",
      TRUE ~ as.character(m1_creneau)
    ),
    bande_label = case_when(
      bande_performance == "A" ~ "A — Exemplaire",
      bande_performance == "B" ~ "B — Compétent",
      bande_performance == "C" ~ "C — En développement",
      bande_performance == "D" ~ "D — Insuffisant",
      bande_performance == "F" ~ "F — Préoccupant",
      TRUE ~ as.character(bande_performance)
    ),
    tier        = factor(tier, levels = 1:3, ordered = TRUE),
    m1_scenario = factor(m1_scenario, c("S1", "S2", "S3", "S4", "S5"))
  )

summarise_score <- function(df, ...) {
  df |>
    group_by(...) |>
    summarise(
      n        = n(),
      score_moy = round(mean(score_composite, na.rm = TRUE), 1),
      score_sd  = round(sd(score_composite,   na.rm = TRUE), 1),
      .groups  = "drop"
    )
}

comp_territoire <- summarise_score(visites, territoire_label, code_territoire) |>
  arrange(desc(score_moy))

comp_tier <- summarise_score(visites, tier) |>
  arrange(desc(score_moy))

comp_scenario <- summarise_score(visites, m1_scenario) |>
  arrange(desc(score_moy))

comp_creneau <- summarise_score(visites, creneau_label) |>
  arrange(desc(score_moy))

comp_anciennete <- summarise_score(visites, groupe_anciennete_label, groupe_anciennete) |>
  arrange(groupe_anciennete)

# --- Durées par scénario ---
comp_durees <- visites |>
  group_by(m1_scenario) |>
  summarise(
    moy_attente = round(mean(m1_duree_attente, na.rm = TRUE), 1),
    moy_service = round(mean(m1_duree_service, na.rm = TRUE), 1),
    moy_totale  = round(mean(m1_duree_totale,  na.rm = TRUE), 1),
    .groups     = "drop"
  )

p_val <- function(formula) {
  summary(aov(formula, data = visites))[[1]][["Pr(>F)"]][1]
}

p_territoire <- p_val(score_composite ~ code_territoire)
p_tier       <- p_val(score_composite ~ tier)
p_scenario   <- p_val(score_composite ~ m1_scenario)
p_creneau    <- p_val(score_composite ~ m1_creneau)

cor_agents     <- cor(visites$nb_agents_estime, visites$score_composite, use = "complete.obs")
cor_anciennete <- cor(visites$anciennete_ans,   visites$score_composite, use = "complete.obs")

log <- capture.output({
  cat(sprintf("BCA Audit Qualité - Analyse %s\n%s\n",
              format(Sys.time(), "(%Y-%m-%d %H:%M)"), strrep("-", 45)))
  
  cat("\nScore global\n"); sep()
  s <- visites$score_composite
  cat(sprintf("moy=%.1f sd=%.1f min=%.1f max=%.1f\n",
              mean(s, na.rm = TRUE), sd(s, na.rm = TRUE),
              min(s, na.rm = TRUE), max(s, na.rm = TRUE)))
  print(table(visites$bande_performance))
  
  cat(sprintf("\nPar territoire (ANOVA p=%s)\n", round(p_territoire, 4))); sep()
  print(comp_territoire)
  
  cat(sprintf("\nPar tier (ANOVA p=%s)\n", round(p_tier, 4))); sep()
  print(comp_tier)
  
  cat(sprintf("\nPar scénario (ANOVA p=%s)\n", round(p_scenario, 4))); sep()
  print(comp_scenario)
  
  cat(sprintf("\nPar créneau (ANOVA p=%s)\n", round(p_creneau, 4))); sep()
  print(comp_creneau)
  
  cat("\nPar ancienneté\n"); sep()
  print(comp_anciennete)
  
  cat("\nDurées déclarées par scénario (minutes)\n"); sep()
  print(comp_durees)
  
  cat(sprintf("\nCorrélations\nnb_agents vs score : %.3f\nanciennete vs score : %.3f\n",
              cor_agents, cor_anciennete)); sep()
  
  cat("\nTop 5 / Bottom 5 agences\n"); sep()
  print(slice_head(agences, n = 5) |> select(id_agence, score_moy, bande_agence, rang_global))
  print(slice_tail(agences, n = 5) |> select(id_agence, score_moy, bande_agence, rang_global))
})

bind_rows(
  mutate(comp_territoire, type = "territoire", groupe = territoire_label),
  mutate(comp_tier,       type = "tier",       groupe = as.character(tier)),
  mutate(comp_scenario,   type = "scenario",   groupe = as.character(m1_scenario)),
  mutate(comp_creneau,    type = "creneau",     groupe = creneau_label),
  mutate(comp_anciennete, type = "anciennete",  groupe = groupe_anciennete_label)
) |>
  select(type, groupe, n, score_moy, score_sd) |>
  write_csv("04_rapport/tableaux_analyse.csv", na = "")

cat(paste(log, collapse = "\n"))
writeLines(log, "04_rapport/analyse_resume.txt")
cat("\n-> 04_rapport/tableaux_analyse.csv | analyse_resume.txt\n")