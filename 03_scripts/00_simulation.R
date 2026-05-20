library(tidyverse)
set.seed(2025)

agences    <- read_csv("02_donnees/brutes/metadata_agences.csv",    show_col_types = FALSE)
enqueteurs <- read_csv("02_donnees/brutes/metadata_enqueteurs.csv", show_col_types = FALSE)

sim_bars <- function(n, max_score, mu, sigma = 12) {
  mu_n <- pmin(pmax((mu - 30) / 65, 0), 1)
  pmin(pmax(round(rnorm(n, mu_n * max_score, sigma * max_score / 100)), 0), max_score)
}

sim_bin <- function(n, mu) {
  rbinom(n, 1, pmin(pmax((mu - 30) / 65, 0), 1) * 0.85 + 0.10)
}

pivot_rotation <- function(mat) {
  creneau_map <- c("1"="Matin","2"="Midi","3"="Apres-midi","4"="Matin","5"="Apres-midi")
  mat |>
    pivot_longer(-id_agence, names_to = c("visite", ".value"),
                 names_pattern = "v(\\d+)_(s|eq)") |>
    rename(scenario = s, id_enqueteur = eq) |>
    mutate(num_visite = as.integer(visite), creneau = creneau_map[visite]) |>
    select(-visite)
}

rot_mq <- tribble(
  ~id_agence,   ~v1_s,~v1_eq, ~v2_s,~v2_eq, ~v3_s,~v3_eq, ~v4_s,~v4_eq, ~v5_s,~v5_eq,
  "BCA-MQ-01",  "S1","EQ-04", "S3","EQ-11", "S5","EQ-02", "S2","EQ-08", "S4","EQ-15",
  "BCA-MQ-02",  "S2","EQ-07", "S4","EQ-03", "S1","EQ-12", "S5","EQ-09", "S3","EQ-01",
  "BCA-MQ-03",  "S3","EQ-10", "S5","EQ-06", "S2","EQ-14", "S4","EQ-05", "S1","EQ-13",
  "BCA-MQ-04",  "S4","EQ-02", "S1","EQ-08", "S3","EQ-11", "S5","EQ-04", "S2","EQ-07",
  "BCA-MQ-05",  "S5","EQ-09", "S2","EQ-15", "S4","EQ-06", "S1","EQ-03", "S3","EQ-10",
  "BCA-MQ-06",  "S1","EQ-13", "S3","EQ-04", "S2","EQ-09", "S4","EQ-14", "S5","EQ-11",
  "BCA-MQ-07",  "S2","EQ-06", "S5","EQ-10", "S3","EQ-15", "S1","EQ-07", "S4","EQ-02",
  "BCA-MQ-08",  "S3","EQ-01", "S4","EQ-12", "S1","EQ-08", "S2","EQ-05", "S5","EQ-13",
  "BCA-MQ-09",  "S4","EQ-11", "S1","EQ-09", "S5","EQ-03", "S3","EQ-15", "S2","EQ-06",
  "BCA-MQ-10",  "S5","EQ-14", "S2","EQ-01", "S4","EQ-07", "S1","EQ-10", "S3","EQ-04",
  "BCA-MQ-11",  "S1","EQ-05", "S3","EQ-13", "S2","EQ-11", "S4","EQ-01", "S5","EQ-08"
)

rot_gp <- tribble(
  ~id_agence,   ~v1_s,~v1_eq, ~v2_s,~v2_eq, ~v3_s,~v3_eq, ~v4_s,~v4_eq, ~v5_s,~v5_eq,
  "BCA-GP-01",  "S4","EQ-16", "S1","EQ-20", "S3","EQ-17", "S5","EQ-19", "S2","EQ-18",
  "BCA-GP-02",  "S5","EQ-19", "S2","EQ-17", "S4","EQ-20", "S3","EQ-16", "S1","EQ-18",
  "BCA-GP-03",  "S2","EQ-18", "S3","EQ-19", "S1","EQ-16", "S4","EQ-17", "S5","EQ-20",
  "BCA-GP-04",  "S3","EQ-20", "S4","EQ-16", "S5","EQ-18", "S1","EQ-19", "S2","EQ-17",
  "BCA-GP-05",  "S1","EQ-17", "S5","EQ-18", "S2","EQ-19", "S3","EQ-20", "S4","EQ-16",
  "BCA-GP-06",  "S5","EQ-16", "S1","EQ-17", "S4","EQ-19", "S2","EQ-18", "S3","EQ-20",
  "BCA-GP-07",  "S2","EQ-20", "S4","EQ-18", "S3","EQ-16", "S5","EQ-17", "S1","EQ-19",
  "BCA-GP-08",  "S3","EQ-18", "S5","EQ-19", "S1","EQ-17", "S4","EQ-20", "S2","EQ-16"
)

rot_gf <- tribble(
  ~id_agence,   ~v1_s,~v1_eq, ~v2_s,~v2_eq, ~v3_s,~v3_eq, ~v4_s,~v4_eq, ~v5_s,~v5_eq,
  "BCA-GF-01",  "S1","EQ-21", "S2","EQ-22", "S3","EQ-23", "S4","EQ-24", "S5","EQ-25",
  "BCA-GF-02",  "S2","EQ-22", "S3","EQ-23", "S4","EQ-24", "S5","EQ-25", "S1","EQ-21",
  "BCA-GF-03",  "S3","EQ-23", "S4","EQ-24", "S5","EQ-25", "S1","EQ-21", "S2","EQ-22",
  "BCA-GF-04",  "S4","EQ-24", "S5","EQ-25", "S1","EQ-21", "S2","EQ-22", "S3","EQ-23",
  "BCA-GF-05",  "S5","EQ-25", "S1","EQ-21", "S2","EQ-22", "S3","EQ-23", "S4","EQ-24"
)

rotation <- bind_rows(pivot_rotation(rot_mq),
                      pivot_rotation(rot_gp),
                      pivot_rotation(rot_gf))
stopifnot(nrow(rotation) == 120)

jours_ouvres <- seq(as.Date("2025-04-07"), as.Date("2025-06-27"), by = "day")
jours_ouvres <- jours_ouvres[!format(jours_ouvres, "%u") %in% c("6", "7")]

rotation <- agences |>
  select(id_agence) |>
  mutate(date_visite = map(id_agence, ~ sort(sample(jours_ouvres, 5)))) |>
  unnest(date_visite) |>
  group_by(id_agence) |>
  mutate(num_visite = row_number()) |>
  ungroup() |>
  right_join(rotation, by = c("id_agence", "num_visite"))

agences <- agences |>
  mutate(
    mu_agence = pmin(pmax(68 +
                            case_when(tier == 1 ~ 10, tier == 2 ~ 0, tier == 3 ~ -8) +
                            case_when(groupe_anciennete == "G1" ~  5, groupe_anciennete == "G2" ~  2,
                                      groupe_anciennete == "G3" ~ -2, groupe_anciennete == "G4" ~ -5) +
                            case_when(zone_type == "Urbaine dense" ~  3, zone_type == "Urbaine" ~  1,
                                      zone_type == "Peri-urbaine"  ~ -1, zone_type == "Rurale"  ~ -4) +
                            case_when(code_territoire == "MQ" ~ 2, code_territoire == "GP" ~ 0,
                                      code_territoire == "GF" ~ -3) +
                            rnorm(n(), 0, 4), 30), 95)
  )

visites <- rotation |>
  left_join(agences |> select(id_agence, tier, groupe_anciennete, anciennete_ans,
                              zone_type, code_territoire, territoire,
                              mu_agence, latitude, longitude, nb_agents_estime),
            by = "id_agence") |>
  left_join(enqueteurs |> select(id_enqueteur, genre, tranche_age,
                                 statut_professionnel, score_certification),
            by = "id_enqueteur") |>
  mutate(
    m1_id_visite   = paste0(id_agence, "-V", num_visite, "-", format(date_visite, "%Y%m%d")),
    m1_vague       = 1L,
    m1_scenario    = scenario,
    m1_creneau     = creneau,
    m1_date_visite = date_visite
  )
stopifnot(nrow(visites) == 120)

durees_service <- c(S1 = 27, S2 = 20, S3 = 15, S4 = 10, S5 = 15)
plages <- list(Matin = c(8, 11.5), Midi = c(12, 13.5), `Apres-midi` = c(14, 16.5))

visites <- visites |>
  mutate(
    h_debut          = map_dbl(creneau, ~ runif(1, plages[[.x]][1], plages[[.x]][2])),
    m1_duree_attente = pmax(0L, as.integer(round(rnorm(n(), 5 * (1 - (mu_agence - 30) / 130), 2)))),
    m1_duree_service = as.integer(round(runif(n(), durees_service[scenario] - 5,
                                              durees_service[scenario] + 5))),
    m1_duree_totale  = m1_duree_attente + m1_duree_service,
    t1               = as.POSIXct(
      sprintf("2025-01-01 %02d:%02d:00",
              floor(h_debut), round((h_debut %% 1) * 60)),
      tz = "UTC"),
    m1_t1_arrivee = format(t1, "%H:%M:%S"),
    m1_t4_depart  = format(t1 + m1_duree_totale * 60, "%H:%M:%S")
  ) |>
  select(-h_debut, -t1)

m_par_deg <- 111000

visites <- visites |>
  mutate(
    m1_gps_arr_lat = latitude  + rnorm(n(), 0, 20) / m_par_deg,
    m1_gps_arr_lon = longitude + rnorm(n(), 0, 20) / m_par_deg,
    m1_gps_dep_lat = latitude  + rnorm(n(), 0, 20) / m_par_deg,
    m1_gps_dep_lon = longitude + rnorm(n(), 0, 20) / m_par_deg,
    m1_gps_valide  = 1L
  )

mu <- visites$mu_agence

visites <- visites |>
  mutate(
    m2_01_facade          = sim_bars(n(), 3, mu),
    m2_02_signaletique    = sim_bars(n(), 3, mu),
    m2_03_acces           = sim_bars(n(), 2, mu),
    m2_04_proprete_abords = sim_bars(n(), 3, mu),
    m2_score_brut = m2_01_facade + m2_02_signaletique + m2_03_acces + m2_04_proprete_abords,
    
    m3_01_accueil_verbal  = sim_bars(n(), 3, mu),
    m3_02_temps_attente   = sim_bars(n(), 3, mu),
    m3_03_gestion_file    = sim_bars(n(), 2, mu),
    m3_04_confort_attente = sim_bars(n(), 3, mu),
    m3_05_info_attente    = sim_bars(n(), 3, mu),
    m3_score_brut = m3_01_accueil_verbal + m3_02_temps_attente + m3_03_gestion_file +
      m3_04_confort_attente + m3_05_info_attente,
    
    m4_01_tenue           = sim_bars(n(), 3, mu),
    m4_02_courtoisie      = sim_bars(n(), 3, mu),
    m4_03_ecoute          = sim_bars(n(), 3, mu),
    m4_04_clarte          = sim_bars(n(), 3, mu),
    m4_05_confidentialite = sim_bars(n(), 2, mu),
    m4_06_conge           = sim_bars(n(), 2, mu),
    m4_07_role_agent      = sample(c("Guichetier","Conseiller","Directeur","Autre"),
                                   n(), replace = TRUE, prob = c(0.45, 0.40, 0.10, 0.05)),
    m4_score_brut = m4_01_tenue + m4_02_courtoisie + m4_03_ecoute +
      m4_04_clarte + m4_05_confidentialite + m4_06_conge,
    
    m6_01_proprete      = sim_bars(n(), 3, mu),
    m6_02_affichage     = sim_bars(n(), 3, mu),
    m6_03_materiel_info = sim_bars(n(), 2, mu),
    m6_04_ambiance      = sim_bars(n(), 3, mu),
    m6_score_brut = m6_01_proprete + m6_02_affichage + m6_03_materiel_info + m6_04_ambiance,
    
    m7_01_borne                = sim_bars(n(), 3, mu),
    m7_02_affichage_digital    = sim_bars(n(), 2, mu),
    m7_03_wifi                 = sim_bin(n(), mu),
    m7_04_promo_appli          = sim_bars(n(), 2, mu),
    m7_05_support_digital      = sim_bars(n(), 2, mu),
    m7_06_score_global_digital = sim_bars(n(), 3, mu),
    m7_score_brut = m7_01_borne + m7_02_affichage_digital + m7_03_wifi +
      m7_04_promo_appli + m7_05_support_digital + m7_06_score_global_digital
  )

m5_items <- list(
  S1 = list(noms = c("besoins","produit","docs_requis","kyc","delai","suite","conformite"),
            max  = c(3,3,2,3,2,3,2), type = rep("bars",7)),
  S2 = list(noms = c("besoins","credit_responsable","taux_frais","alternatives",
                     "delai_reponse","docs","conformite"),
            max  = c(3,3,3,2,2,3,2), type = rep("bars",7)),
  S3 = list(noms = c("reception","empathie","procedure","escalade","trace","delai","conformite"),
            max  = c(3,2,3,2,3,2,3), type = rep("bars",7)),
  S4 = list(noms = c("verification","comptage","lcbft","recu","rapidite","exactitude","conformite"),
            max  = c(3,3,3,2,3,1,2), type = c(rep("bars",5),"bin","bars")),
  S5 = list(noms = c("connaissance","adequation","accompagnement","promotion_canal","securite","conformite"),
            max  = c(3,3,3,2,2,3), type = rep("bars",6))
)

for (sc in names(m5_items))
  for (j in seq_along(m5_items[[sc]]$noms))
    visites[[paste0("m5", tolower(sc), "_", sprintf("%02d",j), "_", m5_items[[sc]]$noms[j])]] <- NA_real_

visites[c("m5_score_brut","m5_score_norm")] <- NA_real_
visites$m5_score_max <- NA_integer_

for (sc in names(m5_items)) {
  items  <- m5_items[[sc]]
  idx    <- which(visites$m1_scenario == sc)
  mu_sc  <- visites$mu_agence[idx]
  prefix <- paste0("m5", tolower(sc), "_")
  sc_max <- sum(items$max)
  brut   <- rep(0L, length(idx))
  
  for (j in seq_along(items$noms)) {
    vals <- if (items$type[j] == "bin") sim_bin(length(idx), mu_sc)
    else sim_bars(length(idx), items$max[j], mu_sc)
    visites[[paste0(prefix, sprintf("%02d",j), "_", items$noms[j])]][idx] <- vals
    brut <- brut + vals
  }
  visites$m5_score_brut[idx] <- brut
  visites$m5_score_max[idx]  <- sc_max
  visites$m5_score_norm[idx] <- round((brut / sc_max) * 25, 2)
}

visites <- visites |>
  mutate(
    m8_af_01 = sample(0:2, n(), TRUE, c(0.05,0.15,0.80)),
    m8_af_02 = sample(0:2, n(), TRUE, c(0.05,0.15,0.80)),
    m8_af_03 = sample(0:2, n(), TRUE, c(0.08,0.17,0.75)),
    m8_af_04 = sample(0:2, n(), TRUE, c(0.05,0.15,0.80)),
    m8_af_05 = sample(0:2, n(), TRUE, c(0.05,0.10,0.85)),
    m8_score_antifraude = m8_af_01 + m8_af_02 + m8_af_03 + m8_af_04 + m8_af_05,
    m8_delai_soumission = as.integer(round(runif(n(), 8, 28))),
    m8_abandon          = rbinom(n(), 1, 0.02),
    m8_abandon_code     = if_else(m8_abandon == 1,
                                  sample(c("A1","A2","A3","A4"), n(), replace = TRUE),
                                  NA_character_),
    m8_incident = rbinom(n(), 1, 0.08)
  )

visites <- visites |>
  mutate(
    score_composite = round(
      (m2_score_brut / 11) * 10 + (m3_score_brut / 14) * 15 +
        (m4_score_brut / 16) * 20 + (m5_score_norm / 25) * 30 +
        (m6_score_brut / 11) * 10 + (m7_score_brut / 13) * 15, 2),
    bande_performance = case_when(
      score_composite >= 90 ~ "A", score_composite >= 75 ~ "B",
      score_composite >= 60 ~ "C", score_composite >= 45 ~ "D",
      TRUE ~ "F")
  )

# FD-01 : durée totale implausible (< 3 min)
idx_f <- sample(nrow(visites), 7)
visites$m1_duree_totale[idx_f[1:2]] <- sample(1:2, 2, replace = TRUE)

# FD-02 : GPS arr + dep hors géofence (> 100 m)
for (i in idx_f[3:4]) {
  off_lat <- runif(1, 244, 389) / m_par_deg * sample(c(-1,1), 1)
  off_lon <- runif(1, 244, 389) / m_par_deg * sample(c(-1,1), 1)
  visites$m1_gps_arr_lat[i] <- visites$latitude[i] + off_lat
  visites$m1_gps_arr_lon[i] <- visites$longitude[i] + off_lon
  visites$m1_gps_dep_lat[i] <- visites$latitude[i] + off_lat + rnorm(1, 0, 5) / m_par_deg
  visites$m1_gps_dep_lon[i] <- visites$longitude[i] + off_lon + rnorm(1, 0, 5) / m_par_deg
  visites$m1_gps_valide[i]  <- 0L
}

# FD-03 : score anti-fraude < 6
visites$m8_score_antifraude[idx_f[5:6]] <- sample(0:5, 2, replace = TRUE)

# FD-06 : délai soumission < 8 min
visites$m8_delai_soumission[idx_f[7]] <- sample(1:7, 1)

r1 <- visites |> group_by(id_agence) |> summarise(n = n_distinct(m1_scenario)) |> filter(n != 5)
r2 <- visites |> count(id_agence, id_enqueteur) |> filter(n > 1)
r4 <- visites |> count(id_agence, m1_date_visite) |> filter(n > 1)

cat(sprintf("\n%d lignes | %d cols | score %.1f/%.1f/%.1f | R1:%s R2:%s R4:%s\n",
            nrow(visites), ncol(visites),
            min(visites$score_composite), mean(visites$score_composite), max(visites$score_composite),
            if (nrow(r1) == 0) "OK" else "FAIL",
            if (nrow(r2) == 0) "OK" else "FAIL",
            if (nrow(r4) == 0) "OK" else "FAIL"))
print(table(visites$bande_performance))
print(table(visites$m1_scenario))

write_csv(visites, "02_donnees/brutes/bca_audit_brut.csv", na = "")
cat(sprintf("-> bca_audit_brut.csv (%d x %d)\n", nrow(visites), ncol(visites)))