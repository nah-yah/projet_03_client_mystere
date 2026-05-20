library(tidyverse)

clean       <- read_csv("02_donnees/nettoyees/bca_audit_clean.csv",    show_col_types = FALSE)
agences     <- read_csv("02_donnees/nettoyees/scores_agences.csv",     show_col_types = FALSE)
territoires <- read_csv("02_donnees/nettoyees/scores_territoires.csv", show_col_types = FALSE)

dir.create("05_qualite_donnees", showWarnings = FALSE, recursive = TRUE)

dim_scores <- c(
  M2 = mean(clean$m2_score_brut / 11 * 10, na.rm = TRUE),
  M3 = mean(clean$m3_score_brut / 14 * 15, na.rm = TRUE),
  M4 = mean(clean$m4_score_brut / 16 * 20, na.rm = TRUE),
  M5 = mean(clean$m5_score_norm / 25 * 30, na.rm = TRUE),
  M6 = mean(clean$m6_score_brut / 11 * 10, na.rm = TRUE),
  M7 = mean(clean$m7_score_brut / 13 * 15, na.rm = TRUE)
)
dim_max <- c(M2 = 10, M3 = 15, M4 = 20, M5 = 30, M6 = 10, M7 = 15)

sep <- \(n = 40) cat(strrep("-", n), "\n")

log <- capture.output({
  
  cat(sprintf("BCA Audit Qualité · Rapport QC · %s\n", format(Sys.time(), "%Y-%m-%d %H:%M")))
  sep(50)
  
  # 1. Volumétrie
  cat("\n1. VOLUMÉTRIE\n"); sep()
  cat(sprintf("Retenues : %d/120 (%.1f%%) | Agences : %d | Enquêteurs : %d\n",
              nrow(clean), nrow(clean) / 120 * 100,
              n_distinct(clean$id_agence), n_distinct(clean$id_enqueteur)))
  print(table(clean$code_territoire))
  print(table(clean$m1_scenario))
  
  # 2. Complétude
  cat("\n2. COMPLÉTUDE\n"); sep()
  module_cols <- list(
    M2 = c("m2_01_facade", "m2_02_signaletique", "m2_03_acces", "m2_04_proprete_abords"),
    M3 = c("m3_01_accueil_verbal", "m3_02_temps_attente", "m3_03_gestion_file",
           "m3_04_confort_attente", "m3_05_info_attente"),
    M4 = c("m4_01_tenue", "m4_02_courtoisie", "m4_03_ecoute", "m4_04_clarte",
           "m4_05_confidentialite", "m4_06_conge"),
    M6 = c("m6_01_proprete", "m6_02_affichage", "m6_03_materiel_info", "m6_04_ambiance"),
    M7 = c("m7_01_borne", "m7_02_affichage_digital", "m7_03_wifi",
           "m7_04_promo_appli", "m7_05_support_digital", "m7_06_score_global_digital")
  )
  
  for (mod in names(module_cols)) {
    cols <- intersect(module_cols[[mod]], names(clean))
    taux <- mean(colMeans(!is.na(clean[, cols])))
    cat(sprintf("  %s : %.1f%%\n", mod, taux * 100))
  }
  
  m5_ref <- c(S1 = "m5s1_01_besoins", S2 = "m5s2_01_besoins", S3 = "m5s3_01_reception",
              S4 = "m5s4_01_verification", S5 = "m5s5_01_connaissance")
  for (sc in names(m5_ref)) {
    n_sc <- sum(clean$m1_scenario == sc, na.rm = TRUE)
    n_ok <- sum(clean$m1_scenario == sc & !is.na(clean[[m5_ref[sc]]]), na.rm = TRUE)
    cat(sprintf("  M5-%s : %d/%d\n", sc, n_ok, n_sc))
  }
  
  # 3. Durées déclarées
  cat("\n3. DURÉES DÉCLARÉES\n"); sep()
  cat(sprintf("  Attente  — min:%d  moy:%.1f  max:%d (min)\n",
              min(clean$m1_duree_attente, na.rm = TRUE),
              mean(clean$m1_duree_attente, na.rm = TRUE),
              max(clean$m1_duree_attente, na.rm = TRUE)))
  cat(sprintf("  Service  — min:%d  moy:%.1f  max:%d (min)\n",
              min(clean$m1_duree_service, na.rm = TRUE),
              mean(clean$m1_duree_service, na.rm = TRUE),
              max(clean$m1_duree_service, na.rm = TRUE)))
  cat(sprintf("  Totale   — min:%d  moy:%.1f  max:%d (min)\n",
              min(clean$m1_duree_totale, na.rm = TRUE),
              mean(clean$m1_duree_totale, na.rm = TRUE),
              max(clean$m1_duree_totale, na.rm = TRUE)))
  n_incoherent <- sum(clean$m1_duree_totale != clean$m1_duree_attente + clean$m1_duree_service,
                      na.rm = TRUE)
  cat(sprintf("  Durées incohérentes (totale ≠ attente + service) : %d\n", n_incoherent))
  
  # 4. Scores
  cat("\n4. SCORES\n"); sep()
  s <- clean$score_composite
  cat(sprintf("min=%.1f Q1=%.1f med=%.1f moy=%.1f Q3=%.1f max=%.1f sd=%.1f\n",
              min(s, na.rm = TRUE), quantile(s, .25, na.rm = TRUE),
              median(s, na.rm = TRUE), mean(s, na.rm = TRUE),
              quantile(s, .75, na.rm = TRUE), max(s, na.rm = TRUE), sd(s, na.rm = TRUE)))
  print(table(clean$bande_performance))
  cat("\nDimensions :\n")
  for (d in names(dim_scores))
    cat(sprintf("  %s : %.1f/%d (%.0f%%)\n",
                d, dim_scores[d], dim_max[d], dim_scores[d] / dim_max[d] * 100))
  
  # 5. Par territoire
  cat("\n5. PAR TERRITOIRE\n"); sep()
  print(select(territoires, code_territoire, territoire,
               n_visites, score_moy, score_sd, rang, ecart_reseau))
  
  # 6. Alertes
  cat("\n6. ALERTES\n"); sep()
  crit <- filter(agences, bande_agence %in% c("D", "F"))
  if (nrow(crit) > 0) {
    cat("Agences D/F :\n")
    print(select(crit, id_agence, score_moy, bande_agence))
  } else {
    cat("Aucune agence D/F\n")
  }
  cat(sprintf("Dimension la plus faible : %s (%.0f%%)\n",
              names(which.min(dim_scores / dim_max)),
              min(dim_scores / dim_max) * 100))
  
  # 7. Contrôles méthodologiques
  cat("\n7. CONTRÔLES\n"); sep()
  r1 <- clean |> group_by(id_agence) |> summarise(n = n_distinct(m1_scenario), .groups = "drop") |> filter(n != 5)
  r2 <- clean |> count(id_agence, id_enqueteur) |> filter(n > 1)
  r3 <- clean |> group_by(id_agence) |> summarise(n = n_distinct(m1_creneau), .groups = "drop") |> filter(n < 3)
  r4 <- clean |> count(id_agence, m1_date_visite) |> filter(n > 1)
  cat(sprintf("R1:%s R2:%s R3:%s R4:%s\n",
              if (nrow(r1) == 0) "OK" else paste("FAIL", nrow(r1)),
              if (nrow(r2) == 0) "OK" else paste("FAIL", nrow(r2)),
              if (nrow(r3) == 0) "OK" else paste("FAIL", nrow(r3)),
              if (nrow(r4) == 0) "OK" else paste("FAIL", nrow(r4))))
})

writeLines(log, "05_qualite_donnees/rapport_qualite_donnees.txt")
cat(paste(log, collapse = "\n"))
cat("\n-> 05_qualite_donnees/rapport_qualite_donnees.txt\n")