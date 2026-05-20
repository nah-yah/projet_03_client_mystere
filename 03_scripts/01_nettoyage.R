library(tidyverse)

path_in  <- "02_donnees/brutes/bca_audit_brut.csv"
path_out <- "02_donnees/nettoyees/bca_audit_clean.csv"
path_log <- "05_qualite_donnees/journal_nettoyage.md"

# Distance plane en mètres (précision suffisante <100 km, erreur <0.1 % aux Antilles/Guyane)
dist_m <- \(lat1, lon1, lat2, lon2)
sqrt((lat1 - lat2)^2 + ((lon1 - lon2) * cos(lat1 * pi / 180))^2) * 111000

log <- capture.output({
  
  brut <- read_csv(path_in, show_col_types = FALSE)
  cat(sprintf("Chargé : %d x %d\n", nrow(brut), ncol(brut)))
  
  # --- Parse geopoints ODK si format string "lat lon alt acc" ---
  # Données réelles ODK → colonnes m1_gps_arrivee / m1_gps_depart (string)
  # Données simulées   → colonnes m1_gps_arr_lat/lon déjà séparées → bloc ignoré
  if ("m1_gps_arrivee" %in% names(brut) && is.character(brut$m1_gps_arrivee)) {
    gps_split <- \(x) {
      m <- str_match(trimws(x), "^([\\d.-]+)\\s+([\\d.-]+)")
      list(lat = as.numeric(m[, 2]), lon = as.numeric(m[, 3]))
    }
    arr <- gps_split(brut$m1_gps_arrivee)
    dep <- gps_split(brut$m1_gps_depart)
    brut <- brut |>
      mutate(
        m1_gps_arr_lat = arr$lat, m1_gps_arr_lon = arr$lon,
        m1_gps_dep_lat = dep$lat, m1_gps_dep_lon = dep$lon
      )
    cat("GPS geopoints parsés (données ODK)\n")
  }
  
  # --- Types ---
  brut <- brut |>
    mutate(
      m1_scenario       = factor(m1_scenario,       c("S1","S2","S3","S4","S5")),
      m1_creneau        = factor(m1_creneau,         c("Matin","Midi","Apres-midi")),
      code_territoire   = factor(code_territoire,    c("MQ","GP","GF")),
      zone_type         = factor(zone_type,          c("Urbaine dense","Urbaine","Peri-urbaine","Rurale")),
      groupe_anciennete = factor(groupe_anciennete,  c("G1","G2","G3","G4")),
      tier              = factor(tier,               1:3, ordered = TRUE),
      bande_performance = factor(bande_performance,  c("F","D","C","B","A"), ordered = TRUE),
      m4_07_role_agent  = factor(m4_07_role_agent,   c("Guichetier","Conseiller","Directeur","Autre")),
      m8_abandon_code   = factor(m8_abandon_code,    c("A1","A2","A3","A4")),
      m1_date_visite    = as.Date(m1_date_visite)
    )
  
  # --- Plages BARS ---
  plages <- tribble(
    ~var,                         ~max,
    "m2_01_facade",                3,
    "m2_02_signaletique",          3,
    "m2_03_acces",                 2,
    "m2_04_proprete_abords",       3,
    "m3_01_accueil_verbal",        3,
    "m3_02_temps_attente",         3,
    "m3_03_gestion_file",          2,
    "m3_04_confort_attente",       3,
    "m3_05_info_attente",          3,
    "m4_01_tenue",                 3,
    "m4_02_courtoisie",            3,
    "m4_03_ecoute",                3,
    "m4_04_clarte",                3,
    "m4_05_confidentialite",       2,
    "m4_06_conge",                 2,
    "m5s1_01_besoins",             3,
    "m5s1_02_produit",             3,
    "m5s1_03_docs_requis",         2,
    "m5s1_04_kyc",                 3,
    "m5s1_05_delai",               2,
    "m5s1_06_suite",               3,
    "m5s1_07_conformite",          2,
    "m5s2_01_besoins",             3,
    "m5s2_02_credit_responsable",  3,
    "m5s2_03_taux_frais",          3,
    "m5s2_04_alternatives",        2,
    "m5s2_05_delai_reponse",       2,
    "m5s2_06_docs",                3,
    "m5s2_07_conformite",          2,
    "m5s3_01_reception",           3,
    "m5s3_02_empathie",            2,
    "m5s3_03_procedure",           3,
    "m5s3_04_escalade",            2,
    "m5s3_05_trace",               3,
    "m5s3_06_delai",               2,
    "m5s3_07_conformite",          3,
    "m5s4_01_verification",        3,
    "m5s4_02_comptage",            3,
    "m5s4_03_lcbft",               3,
    "m5s4_04_recu",                2,
    "m5s4_05_rapidite",            3,
    "m5s4_06_exactitude",          1,
    "m5s4_07_conformite",          2,
    "m5s5_01_connaissance",        3,
    "m5s5_02_adequation",          3,
    "m5s5_03_accompagnement",      3,
    "m5s5_04_promotion_canal",     2,
    "m5s5_05_securite",            2,
    "m5s5_06_conformite",          3,
    "m6_01_proprete",              3,
    "m6_02_affichage",             3,
    "m6_03_materiel_info",         2,
    "m6_04_ambiance",              3,
    "m7_01_borne",                 3,
    "m7_02_affichage_digital",     2,
    "m7_03_wifi",                  1,
    "m7_04_promo_appli",           2,
    "m7_05_support_digital",       2,
    "m7_06_score_global_digital",  3
  )
  
  n_plage <- 0L
  walk2(plages$var, plages$max, \(v, m) {
    if (!v %in% names(brut)) return()
    n <- sum(!is.na(brut[[v]]) & (brut[[v]] < 0 | brut[[v]] > m))
    if (!n) return()
    n_plage <<- n_plage + n
    cat(sprintf("ALERTE plage : %s [0-%d] — %d cas\n", v, m, n))
  })
  cat(if (n_plage == 0) "Plages BARS : OK\n"
      else sprintf("Plages BARS : %d cas\n", n_plage))
  
  # --- Scores bruts ---
  scores <- c(m2_score_brut=11, m3_score_brut=14, m4_score_brut=16,
              m6_score_brut=11, m7_score_brut=13)
  n_score <- 0L
  walk2(names(scores), unname(scores), \(v, m) {
    n <- sum(!is.na(brut[[v]]) & brut[[v]] > m)
    if (!n) return()
    n_score <<- n_score + n
    cat(sprintf("ALERTE score brut : %s > %d — %d cas\n", v, m, n))
  })
  n_m5 <- sum(!is.na(brut$m5_score_brut) & !is.na(brut$m5_score_max) &
                brut$m5_score_brut > brut$m5_score_max)
  if (n_m5 > 0)
    cat(sprintf("ALERTE score brut : m5_score_brut > m5_score_max — %d cas\n", n_m5))
  cat(if (n_score + n_m5 == 0) "Scores bruts : OK\n"
      else sprintf("Scores bruts : %d cas\n", n_score + n_m5))
  
  # --- NA structurels M5 ---
  prefixes <- c(S1="m5s1_", S2="m5s2_", S3="m5s3_", S4="m5s4_", S5="m5s5_")
  n_na <- 0L
  for (sc in names(prefixes)) {
    cols <- names(brut)[str_starts(names(brut), prefixes[[sc]])]
    if (!length(cols)) next
    n <- sum(!is.na(as.matrix(brut[brut$m1_scenario != sc, cols])))
    if (!n) next
    n_na <- n_na + n
    cat(sprintf("ALERTE NA structurel M5-%s : %d cas\n", sc, n))
  }
  cat(if (n_na == 0) "NA structurels M5 : OK\n"
      else sprintf("NA structurels M5 : %d cas\n", n_na))
  
  # --- GPS : recompute m1_gps_valide depuis distances (DEC-16 — géofence 100 m) ---
  # DEC-16 : 2 lectures (arr + dep) remplacent les 3 lectures antérieures
  # Valide si arrivée ET départ dans les 100 m du centroïde de l'agence
  brut <- brut |>
    mutate(
      dist_arr      = dist_m(m1_gps_arr_lat, m1_gps_arr_lon, latitude, longitude),
      dist_dep      = dist_m(m1_gps_dep_lat, m1_gps_dep_lon, latitude, longitude),
      m1_gps_valide = as.integer(dist_arr <= 100 & dist_dep <= 100)
    ) |>
    select(-dist_arr, -dist_dep)
  
  cat(sprintf("GPS hors géofence 100 m : %d visite(s)\n",
              sum(brut$m1_gps_valide == 0, na.rm = TRUE)))
  
  # --- Horodatages (DEC-16 : T1 et T4 uniquement) ---
  # Comparaison string HH:MM:SS — locale-indépendant, même journée
  brut <- brut |>
    mutate(
      flag_horaire_incoherent = m1_t1_arrivee >= m1_t4_depart
    )
  cat(sprintf("Horodatages incohérents (T4 <= T1) : %d\n",
              sum(brut$flag_horaire_incoherent, na.rm = TRUE)))
  
  # --- Durées déclaratives (DEC-16) ---
  brut <- brut |>
    mutate(
      flag_duree_incoherente =
        is.na(m1_duree_attente) | is.na(m1_duree_service) | is.na(m1_duree_totale) |
        m1_duree_attente < 0   | m1_duree_service < 0     |
        m1_duree_totale != m1_duree_attente + m1_duree_service
    )
  cat(sprintf("Durées incohérentes : %d\n",
              sum(brut$flag_duree_incoherente, na.rm = TRUE)))
  
  # --- Cross-validation T1/T4 vs durée déclarée (tolérance 5 min) ---
  # Détecte les déclarations de durée incompatibles avec l'écart T4-T1 observé
  t1 <- as.POSIXct(brut$m1_t1_arrivee, format = "%H:%M:%S", tz = "UTC")
  t4 <- as.POSIXct(brut$m1_t4_depart,  format = "%H:%M:%S", tz = "UTC")
  
  brut <- brut |>
    mutate(
      flag_temps_incoherent =
        is.na(t1) | is.na(t4) |
        abs(as.integer(difftime(t4, t1, units = "mins")) - m1_duree_totale) > 5
    )
  cat(sprintf("Durée déclarée vs écart T1/T4 incohérents (>5 min) : %d\n",
              sum(brut$flag_temps_incoherent, na.rm = TRUE)))
  
  # --- m8_heure_soumission + m8_delai_soumission (données ODK réelles) ---
  # Données simulées : m8_delai_soumission déjà présent en integer → bloc ignoré
  if ("m8_heure_soumission" %in% names(brut) &&
      is.character(brut$m8_heure_soumission)) {
    
    brut <- brut |>
      mutate(
        m8_heure_soumission = as.POSIXct(
          m8_heure_soumission, format = "%Y-%m-%dT%H:%M:%S", tz = "UTC"
        ),
        t4_full = as.POSIXct(
          paste(format(m1_date_visite, "%Y-%m-%d"), m1_t4_depart),
          format = "%Y-%m-%d %H:%M:%S", tz = "UTC"
        ),
        m8_delai_soumission = as.integer(
          difftime(m8_heure_soumission, t4_full, units = "mins")
        )
      ) |>
      select(-t4_full)
    
    n_tard <- sum(brut$m8_delai_soumission > 30, na.rm = TRUE)
    cat(sprintf("Soumissions hors délai 30 min : %d\n", n_tard))
  }
  
  # --- Règles métier ---
  r1 <- brut |>
    group_by(id_agence) |>
    summarise(n = n_distinct(m1_scenario), .groups = "drop") |>
    filter(n != 5)
  r2 <- brut |> count(id_agence, id_enqueteur) |> filter(n > 1)
  r4 <- brut |> count(id_agence, m1_date_visite)  |> filter(n > 1)
  cat(sprintf("R1:%s R2:%s R4:%s\n",
              if (nrow(r1) == 0) "OK" else paste("FAIL", nrow(r1)),
              if (nrow(r2) == 0) "OK" else paste("FAIL", nrow(r2)),
              if (nrow(r4) == 0) "OK" else paste("FAIL", nrow(r4))))
  
  # --- Flags qualité ---
  brut <- brut |>
    mutate(
      flag_qualite_ok =
        !flag_horaire_incoherent &
        !flag_duree_incoherente  &
        !flag_temps_incoherent   &
        m1_gps_valide == 1,
      m5_complet = case_when(
        m1_scenario == "S1" ~ !is.na(m5s1_01_besoins),
        m1_scenario == "S2" ~ !is.na(m5s2_01_besoins),
        m1_scenario == "S3" ~ !is.na(m5s3_01_reception),
        m1_scenario == "S4" ~ !is.na(m5s4_01_verification),
        m1_scenario == "S5" ~ !is.na(m5s5_01_connaissance),
        TRUE                ~ FALSE
      )
    )
  
  cat(sprintf("flag_qualite_ok : %d/%d | Sortie : %d x %d\n",
              sum(brut$flag_qualite_ok, na.rm = TRUE), nrow(brut),
              nrow(brut), ncol(brut)))
  print(table(brut$bande_performance))
  print(table(brut$code_territoire))
})

write_csv(brut, path_out, na = "")
writeLines(log, path_log)
cat(sprintf("-> %s\n-> %s\n", path_out, path_log))