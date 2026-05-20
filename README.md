# IMPORTANT: PROJET FICTIF - DONNÉES SIMULÉES - USAGE PORTFOLIO
# Audit Qualité par Client Mystère - BCA
## Réseau Antilles-Guyane
### Vague 1 (T2 2025)

> **Classification :** Confidentiel. Usage interne BCA uniquement

La BCA a mandaté cet audit pour mesurer la qualité de service dans ses 24 agences des Antilles-Guyane à partir de données observationnelles collectées par des enquêteurs formés, à l'insu du personnel. Cent vingt visites ont été planifiées sur cinq scénarios distincts (ouverture de compte, crédit personnel, réclamation, dépôt d'espèces, services numériques). Les données produites servent de baseline pour un programme d'amélioration continue sur trois vagues.

---

## Chaîne de données

```
02_donnees/brutes/
  bca_audit_brut.csv          ← 00_simulation.R
  metadata_agences.csv        ← manuel
  metadata_enqueteurs.csv     ← manuel

        |
        |_  01_nettoyage.R
             (typage, BARS, NA structurels M5,
              GPS parsing, flags qualité)

02_donnees/nettoyees/
  bca_audit_clean.csv         ← 01_nettoyage.R

        |
        |_  02_detection_fraude.R
             (FD-01/02/03/04/06)

05_qualite_donnees/
  flags_fraude.csv
  journal_nettoyage.md
  rapport_qualite_donnees.txt

        |
        |_  03_derivation_variables.R
             (exclusion frauduleux, scores agrégés)

02_donnees/nettoyees/
  bca_audit_clean.csv         ← enrichi (overwrite)
  scores_agences.csv
  scores_territoires.csv

        |
        |_  04_rapport_qualite_donnees.R
        |_  05_analyse.R

04_rapport/
  tableaux_analyse.csv
  analyse_resume.txt

        |
        |_  rapport_audit_bca.Rmd
        |_  generer_scorecards.R
        |_  dashboard.Rmd

04_rapport/
  rapport_audit_bca.pdf
  scorecards/  (24 PDF)
  tableau_de_bord/dashboard.html
```

---

## Reproduire le pipeline

Lancer depuis la racine du projet (`projet_04_client_mystere/`).

```bash
# 1. Générer les données simulées
Rscript 03_scripts/00_simulation.R

# 2. Nettoyer et valider
Rscript 03_scripts/01_nettoyage.R

# 3. Détecter les visites frauduleuses
Rscript 03_scripts/02_detection_fraude.R

# 4. Dériver les variables analytiques
Rscript 03_scripts/03_derivation_variables.R

# 5. Rapport qualité données
Rscript 03_scripts/04_rapport_qualite_donnees.R

# 6. Analyse principale
Rscript 03_scripts/05_analyse.R

# 7. Rapport PDF
Rscript -e "rmarkdown::render('04_rapport/rapport_audit_bca.Rmd')"

# 8. Scorecards (24 PDF)
Rscript 04_rapport/scorecards/generer_scorecards.R

# 9. Dashboard
Rscript -e "rmarkdown::render('04_rapport/tableau_de_bord/dashboard.Rmd')"
```

Les scripts s'exécutent dans l'ordre 00 à 05. Chaque script écrit ses sorties avant que le suivant les lise. Aucune exécution parallèle.

---

## Livrables principaux

| Livrable | Chemin | Format |
|---|---|---|
| Note méthodologique | `00_methodologie/note_methodologique.md` | Markdown |
| Blueprint questionnaire | `00_methodologie/blueprint_questionnaire.md` | Markdown |
| Cadre d'échantillonnage | `00_methodologie/cadre_echantillonnage.md` | Markdown |
| XLSForm ODK | `01_instrument/BCA_audit_qualite_v1.xlsx` | XLSForm |
| Guide enquêteur | `01_instrument/guide_enqueteur.md` | Markdown |
| Données brutes simulées | `02_donnees/brutes/bca_audit_brut.csv` | CSV |
| Données nettoyées finales | `02_donnees/nettoyees/bca_audit_clean.csv` | CSV |
| Scores par agence | `02_donnees/nettoyees/scores_agences.csv` | CSV |
| Scores par territoire | `02_donnees/nettoyees/scores_territoires.csv` | CSV |
| Flags fraude | `05_qualite_donnees/flags_fraude.csv` | CSV |
| Rapport audit PDF | `04_rapport/rapport_audit_bca.pdf` | PDF |
| Scorecards agences | `04_rapport/scorecards/scorecard_BCA-XX-XX.pdf` | PDF × 24 |
| Dashboard interactif | `04_rapport/tableau_de_bord/dashboard.html` | HTML |
| Journal des décisions | `DECISIONS.md` | Markdown |
| Dictionnaire des variables | `02_donnees/dictionnaire_variables.md` | Markdown |

---

## Stack technique

| Composant | Outil | Version |
|---|---|---|
| Langage principal | R | 4.3+ |
| Manipulation données | tidyverse | 2.0+ |
| Collecte terrain | ODK Collect | 2024+ |
| Serveur collecte | ONA | cloud |
| Instrument | XLSForm (pyxform) | v1 |
| Rapport | R Markdown + xelatex | - |
| Dashboard | flexdashboard + plotly + crosstalk | - |
| Scorecards | R Markdown paramétré | - |
| Contrôle de version | git | - |

---

## Structure du repo

```
projet_04_client_mystere/
├── README.md
├── setup.R                       (crée les dossiers du repo)
├── .gitignore
├── 00_methodologie/
│   ├── note_methodologique.md
│   ├── blueprint_questionnaire.md
│   └── cadre_echantillonnage.md
├── 01_instrument/
│   ├── BCA_audit_qualite_v1.xlsx
│   └── guide_enqueteur.md
├── 02_donnees/
│   ├── brutes/
│   ├── nettoyees/
│   └── dictionnaire_variables.md
├── 03_scripts/
│   ├── 00_simulation.R
│   ├── 01_nettoyage.R
│   ├── 02_detection_fraude.R
│   ├── 03_derivation_variables.R
│   ├── 04_rapport_qualite_donnees.R
│   └── 05_analyse.R
├── 04_rapport/
│   ├── rapport_audit_bca.Rmd
│   ├── scorecards/
│   │   ├── scorecard_template.Rmd
│   │   └── generer_scorecards.R
│   └── tableau_de_bord/
│       └── dashboard.Rmd
└── 05_qualite_donnees/
```

---

## Décisions clés

Toutes les décisions structurelles du projet sont tracées dans [`DECISIONS.md`](DECISIONS.md).

Décisions à connaître pour maintenir ou étendre le projet :

| DEC | Résumé |
|---|---|
| DEC-03 | Pondération du score composite (M5 = 30 %, M4 = 20 %, M3/M7 = 15 %, M2/M6 = 10 %) |
| DEC-05 | M5 conditionnel par scénario, normalisé à /25 pour comparabilité |
| DEC-06 | 5 règles fraude, exclusion à 2 flags ou plus - FD-05 reportée Vague 2 |
| DEC-07 | Labels d'affichage calculés dans les scripts de rapport, pas dans le nettoyage |
| DEC-08 | Pipeline mono-dossier : tout transite par `02_donnees/nettoyees/` |
| DEC-14 | Dénominateurs réels M2=/11, M3=/14, M4=/16, M6=/11, M7=/13 |
| DEC-16 | T1 et T4 uniquement dans ODK - durées déclarées en minutes post-visite |

---

## Protocole d'horodatage (DEC-16)

L'enquêteur saisit deux horodatages dans ODK, tous deux depuis l'extérieur de l'agence : T1 juste avant d'entrer, T4 juste après être sorti. Les durées d'attente et de service sont déclarées en minutes après la visite. Le GPS est capturé automatiquement à T1 et T4. Le script `01_nettoyage.R` cross-valide les durées déclarées contre l'écart T4–T1 avec une tolérance de 5 minutes.

---

## Statut Vague 1 et suite

La Vague 1 couvre T2 2025 (collecte avril–juin 2025). Elle produit la baseline réseau pour les 24 agences.

La Vague 2 est prévue pour T4 2025. Les comparaisons longitudinales (Vague 1 vs Vague 2) seront le principal apport analytique. Deux points techniques sont à préparer avant la Vague 2 :

1. Modifier le XLSForm pour séparer les colonnes GPS photo du GPS formulaire (activation de FD-05).
2. Mettre à jour la matrice de rotation pour les enquêteurs ayant quitté le pool.

---

*Unité Audit et Qualité de Service - BCA* 
*Confidentiel. Usage interne uniquement*
