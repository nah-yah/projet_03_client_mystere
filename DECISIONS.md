# Journal des décisions de conception
## Projet 04 - Audit Qualité par Client Mystère - BCA
### Réseau Antilles-Guyane
#### Vague 1 - T2 2025

> **Classification :** Confidentiel - Usage interne BCA
> **Rôle :** Trace toutes les décisions structurelles du projet. Un futur mainteneur doit pouvoir comprendre pourquoi une décision a été prise sans interroger l'équipe.

---

## Format de chaque entrée

**Contexte:** Situation qui a rendu la décision nécessaire.
**Décision:** Ce qui a été retenu.
**Motif:** Pourquoi cette option plutôt qu'une autre.
**Conséquences:** Ce que ça change dans les fichiers, scripts et livrables.
**Fichiers impactés:** Liste des fichiers directement affectés.

---

## Décisions méthodologiques (J1)

---

### DEC-01 - Méthode de collecte : client mystère

**Statut :** Actif

**Contexte.** La BCA dispose déjà d'enquêtes de satisfaction post-visite par territoire. Ces données divergent sans qu'on puisse établir si l'écart traduit une différence réelle de qualité ou un biais de perception.

**Décision.** L'audit utilise la méthode du client mystère : un enquêteur formé exécute un scénario prédéfini dans chaque agence, à l'insu du personnel, et score les comportements observés sur une grille standardisée.

**Motif.** Le client mystère capte du comportement observé, pas de l'auto-déclaré. Il produit des données comparables entre agences sur un protocole identique. Les enquêtes de satisfaction existantes restent complémentaires mais ne répondent pas à la question posée.

**Conséquences.** L'instrument est un XLSForm déployé sur ODK Collect. Les scores reposent sur des ancres comportementales (BARS) pour limiter la variabilité inter-enquêteurs. La formation et la certification des enquêteurs sont obligatoires avant toute collecte.

**Fichiers impactés :**
`00_methodologie/note_methodologique.md`
`01_instrument/BCA_audit_qualite_v1.xlsx`
`01_instrument/guide_enqueteur.md`

---

### DEC-02 - Volume de visites : 5 par agence, 1 par scénario

**Statut :** Actif

**Contexte.** Avec 24 agences et 5 scénarios, le volume total de visites est 120. Il fallait décider du nombre de visites par agence et de la règle d'assignation des scénarios.

**Décision.** Chaque agence reçoit exactement 5 visites sur 5 jours ouvrés distincts. Chaque visite est associée à un scénario différent. Deux visites à la même agence ne tombent pas le même jour calendaire.

**Motif.** Un scénario par agence garantit la couverture complète de toutes les situations testées. Cinq jours distincts limitent le risque de reconnaissance de l'enquêteur par le personnel.

**Conséquences.** La matrice de rotation assigne enquêteurs et scénarios en avance. Les règles R1 (5 scénarios distincts par agence) et R4 (pas deux visites le même jour) sont vérifiées automatiquement dans `01_nettoyage.R`.

**Fichiers impactés :**
`00_methodologie/cadre_echantillonnage.md`
`03_scripts/00_simulation.R`
`03_scripts/01_nettoyage.R`

---

### DEC-03 - Architecture de scoring composite sur 100

**Statut :** Actif

**Contexte.** L'instrument couvre six dimensions de service. Il fallait décider de la pondération de chacune dans le score final.

**Décision.** Score composite sur 100 avec six dimensions pondérées.

| Dimension | Module | Poids |
|---|---|---|
| Environnement extérieur | M2 | 10 % |
| Accueil et attente | M3 | 15 % |
| Professionnalisme | M4 | 20 % |
| Exécution du service | M5 | 30 % |
| Environnement intérieur | M6 | 10 % |
| Services numériques | M7 | 15 % |

**Motif.** M5 pèse 30 % parce qu'il capte la transaction principale pour laquelle le client s'est déplacé. M4 (20 %) couvre les comportements les plus visibles et les plus documentés dans la littérature client mystère bancaire. Les quatre autres dimensions se partagent les 50 % restants de façon équilibrée.

**Conséquences.** La formule est fixée dans `00_simulation.R` (génération) et dans `03_derivation_variables.R` (calcul post-nettoyage). Toute modification de pondération casse la comparabilité avec la Vague 2.

**Fichiers impactés :**
`00_methodologie/note_methodologique.md`
`00_methodologie/blueprint_questionnaire.md`
`03_scripts/00_simulation.R`
`03_scripts/03_derivation_variables.R`
`04_rapport/rapport_audit_bca.Rmd`

---

### DEC-04 - Grille d'évaluation : échelle BARS à 3 ou 4 niveaux

**Statut :** Actif

**Contexte.** Les échelles Likert subjectives (Mauvais / Passable / Bon / Excellent) produisent des résultats non comparables entre enquêteurs. Il fallait un format d'item plus objectif.

**Décision.** Tous les items scorés utilisent une échelle BARS (Behaviorally Anchored Rating Scale). Chaque niveau (0, 1, 2 ou 3) est associé à une description d'un comportement observable, pas à un jugement de valeur.

**Motif.** Deux enquêteurs formés sur les mêmes ancres attribuent le même score face au même comportement. L'interprétation de "Bon" varie d'un enquêteur à l'autre ; l'interprétation de "L'agent a reformulé la demande avant de répondre" ne varie pas.

**Conséquences.** Chaque item du blueprint contient quatre ancres comportementales rédigées au présent de l'indicatif. Les niveaux 2 et 3 du BARS4 correspondent à la conformité REC v3.0.

**Fichiers impactés :**
`00_methodologie/blueprint_questionnaire.md`
`01_instrument/BCA_audit_qualite_v1.xlsx`
`01_instrument/guide_enqueteur.md`

---

### DEC-05 - M5 conditionnel et normalisé à /25

**Statut :** Actif

**Contexte.** Les cinq scénarios (S1 à S5) couvrent des transactions bancaires différentes avec des items spécifiques à chacun. Les scores bruts maximum varient entre scénarios. Il fallait maintenir la comparabilité des visites inter-scénarios dans le composite.

**Décision.** ODK n'active que le sous-module M5 correspondant au scénario assigné. Chaque sous-module produit un score brut normalisé à /25 avant d'entrer dans le composite.

| Scénario | Items scorés | Max brut |
|---|---|---|
| S1 - Ouverture de compte | 7 | 18 |
| S2 - Crédit personnel | 7 | 18 |
| S3 - Réclamation formelle | 7 | 18 |
| S4 - Dépôt d'espèces | 7 | 17 |
| S5 - Services numériques | 6 | 16 |

Normalisation : `m5_score_norm = round((m5_score_brut / m5_score_max) * 25, 2)`

**Motif.** Sans normalisation, une visite S1 (max 18) est structurellement avantagée face à une visite S5 (max 16) dans le composite. La normalisation à /25 préserve la comparabilité tout en gardant un poids de 30 % identique pour M5 quel que soit le scénario.

**Conséquences.** Les colonnes M5 ont des NA structurels : les items S1 sont NA pour toutes les visites S2 à S5. Cette structure est vérifiée dans `01_nettoyage.R`. Voir DEC-14 et DEC-15 pour les dénominateurs exacts.

**Fichiers impactés :**
`00_methodologie/blueprint_questionnaire.md`
`01_instrument/BCA_audit_qualite_v1.xlsx`
`03_scripts/00_simulation.R`
`03_scripts/01_nettoyage.R`
`03_scripts/03_derivation_variables.R`

---

### DEC-06 - Règles de détection des visites frauduleuses

**Statut :** Actif - FD-05 reportée en Vague 2

**Contexte.** Sans mécanisme de contrôle qualité, un enquêteur peut soumettre un formulaire sans s'être rendu en agence. Cinq règles de détection automatique ont été définies.

**Décision.** Cinq flags automatiques. Toute visite déclenchant 2 flags ou plus est exclue de l'analyse avant la dérivation des variables.

| Code | Condition | Seuil |
|---|---|---|
| FD-01 | Durée totale inférieure à 3 minutes | Toujours |
| FD-02 | GPS arrivée ET départ hors géofence 100 m | Toujours |
| FD-03 | Score anti-fraude inférieur à 6 / 10 | Toujours |
| FD-04 | Heure de départ antérieure à heure d'arrivée | Toujours (simplifié en DEC-16) |
| FD-05 | Écart GPS photo vs GPS formulaire > 200 m | Reportée Vague 2 |
| FD-06 | Formulaire soumis moins de 8 min après T4 | Toujours |

FD-05 est définie dans le protocole mais non calculable en Vague 1 : le XLSForm ne sépare pas les coordonnées GPS photo des coordonnées GPS formulaire dans des colonnes distinctes. Modification prévue pour la Vague 2.

**Motif.** Le seuil de 2 flags (et non 1) réduit les faux positifs dus aux imprécisions GPS en agence urbaine dense.

**Conséquences.** Les exclusions sont loguées dans `05_qualite_donnees/flags_fraude.csv`. La règle d'exclusion est appliquée dans `02_detection_fraude.R` avant `03_derivation_variables.R`.

**Fichiers impactés :**
`03_scripts/02_detection_fraude.R`
`03_scripts/03_derivation_variables.R`
`00_methodologie/note_methodologique.md`
`00_methodologie/blueprint_questionnaire.md`

---

### DEC-07 - Labels d'affichage déplacés hors du script de nettoyage

**Statut :** Actif

**Contexte.** Une version préliminaire de `01_nettoyage.R` créait les colonnes `territoire_label`, `zone_type_label`, `groupe_anciennete_label`, `creneau_label` et `bande_label` dans le CSV nettoyé.

**Décision.** Ces colonnes sont supprimées du script de nettoyage et calculées à la volée dans `05_analyse.R`, `04_rapport/rapport_audit_bca.Rmd`, `04_rapport/scorecards/scorecard_template.Rmd` et `04_rapport/tableau_de_bord/dashboard.Rmd`.

**Motif.** Un script de nettoyage nettoie des données. Il ne les reformate pas pour la présentation. Mélanger les deux responsabilités complique la maintenance : si un label change, il faut retrouver où il est défini et dans quel contexte il s'applique.

**Conséquences.** Le CSV `bca_audit_clean.csv` contient des valeurs ASCII sans accent (ex. `Peri-urbaine`, `Guyane francaise`). Chaque script de rapport applique sa propre fonction de recodage en tête de fichier.

**Fichiers impactés :**
`03_scripts/01_nettoyage.R`
`03_scripts/05_analyse.R`
`04_rapport/rapport_audit_bca.Rmd`
`04_rapport/scorecards/scorecard_template.Rmd`
`04_rapport/tableau_de_bord/dashboard.Rmd`

---

### DEC-08 - Pipeline mono-dossier : pas de dossier intermediaires/

**Statut :** Actif

**Contexte.** Une version préliminaire du pipeline utilisait `02_donnees/intermediaires/` entre le nettoyage et la dérivation des variables.

**Décision.** Tout passe par `02_donnees/nettoyees/`. Le script `03_derivation_variables.R` lit depuis `05_qualite_donnees/flags_fraude.csv` (enrichi par la détection fraude) et réécrit `02_donnees/nettoyees/bca_audit_clean.csv` avec les variables analytiques ajoutées.

**Motif.** Un dossier intermédiaire crée une ambiguïté sur l'état des données : lequel est "le bon" fichier à analyser ? Avec un seul dossier cible, le dernier fichier écrit est toujours l'état courant.

**Conséquences.** La structure du repo est simplifiée. Les chemins dans tous les scripts `read_csv` pointent vers `02_donnees/brutes/` ou `02_donnees/nettoyees/`, jamais vers un troisième dossier.

**Fichiers impactés :**
`03_scripts/01_nettoyage.R`
`03_scripts/02_detection_fraude.R`
`03_scripts/03_derivation_variables.R`
`setup.R`

---

### DEC-09 - Logs de nettoyage exportés en Markdown

**Statut :** Actif

**Contexte.** Les scripts de nettoyage et de QC génèrent des messages de diagnostic. Il fallait décider où et comment les conserver.

**Décision.** Les logs de `01_nettoyage.R` et `04_rapport_qualite_donnees.R` sont capturés via `capture.output()` et écrits dans `05_qualite_donnees/journal_nettoyage.md` et `05_qualite_donnees/rapport_qualite_donnees.txt`.

**Motif.** Les fichiers texte et Markdown sont versionnables dans git sans diff binaire. Un data engineer peut comparer deux runs de nettoyage avec `git diff` sans outil externe.

**Conséquences.** `capture.output()` est utilisé dans `01_nettoyage.R` pour capturer tous les `cat()` sans `<<-` (pas de mutation globale).

**Fichiers impactés :**
`03_scripts/01_nettoyage.R`
`03_scripts/04_rapport_qualite_donnees.R`
`05_qualite_donnees/journal_nettoyage.md`

---

## Décisions d'implémentation (J1–J3)

---

### DEC-10 - Encodage ASCII dans les CSV de métadonnées

**Statut :** Actif

**Contexte.** Les valeurs de `zone_type`, `label_anciennete` et `territoire` dans les CSV de métadonnées contiennent des caractères accentués.

**Décision.** Les valeurs des CSV bruts (`metadata_agences.csv`, `metadata_enqueteurs.csv`, `bca_audit_brut.csv`) utilisent l'encodage ASCII sans accents : `Peri-urbaine`, `Etablie`, `Recente`, `Guyane francaise`.

**Motif.** Compatibilité maximale entre systèmes (Windows / Mac / Linux / ODK) sans déclaration d'encodage explicite dans chaque script. `read_csv()` lit les CSV ASCII correctement sur tous les systèmes sans paramètre `locale`.

**Conséquences.** Les labels avec accents sont appliqués uniquement dans les scripts d'affichage via recodage explicite. Voir DEC-07.

**Fichiers impactés :**
`02_donnees/brutes/metadata_agences.csv`
`02_donnees/brutes/metadata_enqueteurs.csv`

---

### DEC-11 - BCA-MQ-11 : singleton G4, exclu des comparaisons inter-groupes

**Statut :** Actif

**Contexte.** Le groupe G4 (ancienneté 5 ans ou moins) ne compte qu'une seule agence dans le réseau : BCA-MQ-11 (Le Vauclin, Martinique, 5 ans).

**Décision.** BCA-MQ-11 apparaît dans tous les classements et scorecards individuels. Les analyses comparatives (ANOVA, boxplot par groupe d'ancienneté) excluent G4.

**Motif.** Une seule observation ne produit pas d'estimateur valide pour un groupe. Inclure G4 dans une régression ancienneté/score sans caveat serait trompeur.

**Conséquences.** Le rapport mentionne explicitement G4 dans la section Limites. Le script `05_analyse.R` filtre G4 dans les blocs ANOVA par ancienneté.

**Fichiers impactés :**
`03_scripts/05_analyse.R`
`04_rapport/rapport_audit_bca.Rmd`
`00_methodologie/cadre_echantillonnage.md`

---

### DEC-12 - BCA-GP-06 reclassifiée G2 vers G3

**Statut :** Actif

**Contexte.** BCA-GP-06 (Saint-François, Guadeloupe) a été ouverte en 2011, soit 14 ans d'ancienneté en 2025. Le CSV initial l'avait classée G2 (Établie, 15–24 ans).

**Décision.** BCA-GP-06 est reclassifiée G3 (Récente, 6–14 ans). Le seuil inférieur de G2 est 15 ans ; 14 ans ne l'atteint pas.

**Motif.** Bug de classification. Une agence à 14 ans n'appartient pas au groupe "Établie (15–24 ans)". La correction s'applique à tous les fichiers qui utilisent `groupe_anciennete`.

**Conséquences.**

| Groupe | Avant | Après |
|---|---|---|
| G2 - Établie | 10 agences (41,7 %) | 9 agences (37,5 %) |
| G3 - Récente | 7 agences (29,2 %) | 8 agences (33,3 %) |

**Fichiers impactés :**
`02_donnees/brutes/metadata_agences.csv`
`00_methodologie/cadre_echantillonnage.md`

---

### DEC-13 - FD-05 non calculable en Vague 1

**Statut :** Reportée Vague 2

**Contexte.** La règle FD-05 détecte un écart supérieur à 200 m entre le GPS des métadonnées photo et le GPS du formulaire. Dans la version actuelle du XLSForm, les deux sources de coordonnées ne sont pas stockées dans des colonnes distinctes.

**Décision.** FD-05 est documentée dans le protocole et dans le blueprint mais non implémentée dans `02_detection_fraude.R` pour la Vague 1.

**Motif.** Une règle non calculable ne doit pas figurer dans le code de détection : elle créerait une erreur silencieuse ou un flag toujours à `NA`. Mieux vaut l'exclure proprement et noter la correction à apporter.

**Conséquences.** Le XLSForm de la Vague 2 séparera les colonnes `gps_photo_lat/lon` du champ geopoint standard. `02_detection_fraude.R` sera mis à jour pour activer FD-05 dès que les colonnes existent.

**Fichiers impactés :**
`03_scripts/02_detection_fraude.R`
`00_methodologie/blueprint_questionnaire.md`
`00_methodologie/note_methodologique.md`

---

## Corrections techniques (J3)

---

### DEC-14 - Scores bruts réels : dénominateurs corrigés

**Statut :** Actif - corrige une erreur de la note méthodologique initiale

**Contexte.** La note méthodologique initiale indiquait des maxima arrondis : M2=/12, M3=/15, M4=/20, M6=/12. Ces valeurs ne correspondaient pas aux items réels du blueprint.

**Décision.** Les dénominateurs de la formule composite utilisent les maxima bruts réels.

| Module | Dénominateur réel | Contribution pondérée |
|---|---|---|
| M2 | 11 | /11 × 10 |
| M3 | 14 | /14 × 15 |
| M4 | 16 | /16 × 20 |
| M6 | 11 | /11 × 10 |
| M7 | 13 | /13 × 15 |

**Motif.** Les contributions pondérées finales (10, 15, 20, 10, 15 points) sont identiques avant et après correction. Seuls les dénominateurs changent. L'utilisation des dénominateurs incorrects produisait des scores systématiquement sous-évalués pour M2 et M6.

**Conséquences.** La note méthodologique, le blueprint et la formule dans `00_simulation.R` et `03_derivation_variables.R` ont été mis à jour avec les dénominateurs corrects.

**Fichiers impactés :**
`00_methodologie/note_methodologique.md`
`00_methodologie/blueprint_questionnaire.md`
`03_scripts/00_simulation.R`
`03_scripts/03_derivation_variables.R`

---

### DEC-15 - M5 : dénominateurs exacts par scénario

**Statut :** Actif - précise DEC-05

**Contexte.** DEC-05 définit la normalisation M5 à /25 mais ne précise pas les maxima bruts par scénario. Ces maxima sont nécessaires pour calculer `m5_score_norm` correctement.

**Décision.** Les maxima bruts par scénario sont les suivants.

| Scénario | Items | Max brut | Normalisation |
|---|---|---|---|
| S1 | 7 items BARS | 18 | ÷18 × 25 |
| S2 | 7 items BARS | 18 | ÷18 × 25 |
| S3 | 7 items BARS | 18 | ÷18 × 25 |
| S4 | 7 items (6 BARS + 1 binaire) | 17 | ÷17 × 25 |
| S5 | 6 items BARS | 16 | ÷16 × 25 |

**Motif.** S4 a un item binaire (`m5s4_06_exactitude`, max=1) qui abaisse le plafond de 18 à 17. S5 a un item de moins que les autres scénarios.

**Conséquences.** La colonne `m5_score_max` dans le CSV brut prend les valeurs {18, 18, 18, 17, 16} selon le scénario actif. Cette colonne est utilisée dans la normalisation dans `03_derivation_variables.R`.

**Fichiers impactés :**
`00_methodologie/blueprint_questionnaire.md`
`03_scripts/00_simulation.R`
`03_scripts/03_derivation_variables.R`

---

## Modification post-briefing

---

### DEC-16 - Protocole d'horodatage simplifié : T1 et T4 uniquement

**Statut :** Actif - remplace le protocole initial à 4 horodatages

**Contexte.** Le protocole initial requérait quatre horodatages saisis dans ODK pendant la visite (T1 entrée, T2 premier contact agent, T3 fin de service, T4 sortie). Les briefings terrain ont signalé qu'utiliser un smartphone en agence bancaire est atypique et augmente significativement le risque de détection de l'enquêteur.

**Décision.** Le protocole est simplifié.

- T1 (entrée) et T4 (sortie) sont saisis dans ODK depuis l'extérieur de l'agence, avant d'entrer et après être sorti.
- T2 et T3 sont supprimés de l'instrument.
- Les durées `m1_duree_attente` et `m1_duree_service` sont déclarées par l'enquêteur en minutes, après la visite (déclaratif post-visite).
- `m1_duree_totale` est calculé automatiquement : `m1_duree_attente + m1_duree_service`.
- Le GPS est capturé automatiquement à T1 (geopoint `m1_gps_arrivee`) et à T4 (geopoint `m1_gps_depart`). Le GPS mi-visite est supprimé.
- La règle FD-02 porte désormais sur 2 lectures (arr + dep) et non plus 3. La géofence reste à 100 m.
- La règle FD-04 est simplifiée : `m1_t4_depart < m1_t1_arrivee` uniquement.

**Motif.** Un enquêteur qui sort son téléphone pendant l'interaction avec un agent bancaire se signale immédiatement. Le risque de détection précoce annule le bénéfice des horodatages T2/T3. Les durées déclarées restent cross-validées contre l'écart T4-T1 (`flag_temps_incoherent`, tolérance 5 min) dans `01_nettoyage.R`.

**Conséquences.**

| Élément | Avant DEC-16 | Après DEC-16 |
|---|---|---|
| Horodatages ODK | T1, T2, T3, T4 | T1, T4 |
| Durées | Calculées depuis T2/T3 | Déclarées en minutes post-visite |
| GPS | Arr + Mi-visite + Dep | Arr + Dep |
| FD-02 | 2+ / 3 lectures hors géofence | Les 2 lectures hors géofence |
| FD-04 | T4 < T1 | T4 < T1 (inchangé) |
| Nouveau flag | - | `flag_temps_incoherent` : écart déclaré vs T4–T1 > 5 min |

**Fichiers modifiés :**

| Fichier | Modification |
|---|---|
| `01_instrument/BCA_audit_qualite_v1.xlsx` | Suppression T2/T3/GPS mi-visite, ajout déclaratifs durées |
| `01_instrument/guide_enqueteur.md` | Suppression instructions T2/T3, ajout consignes durées déclaratives |
| `03_scripts/00_simulation.R` | Suppression `m1_t2_premier_contact`, `m1_t3_fin_service`, `m1_gps_mid_*`, ajout `m1_duree_attente`/`m1_duree_service` déclaratifs |
| `03_scripts/01_nettoyage.R` | Suppression vérif T2/T3, ajout `flag_temps_incoherent`, recalcul `m1_gps_valide` sur 2 lectures |
| `03_scripts/02_detection_fraude.R` | FD-02 adapté à 2 lectures, FD-04 inchangé |
| `00_methodologie/note_methodologique.md` | Section 6 (instrument) et section 7 (horodatages) mises à jour |
| `00_methodologie/blueprint_questionnaire.md` | M1 redessiné : T2/T3 supprimés, GPS mi-visite supprimé, durées déclaratives ajoutées |

---

*Unité Audit et Qualité de Service - BCA*
*Document mis à jour à chaque décision structurelle*
