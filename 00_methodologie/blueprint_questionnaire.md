# Blueprint du Questionnaire
## Audit Qualité par Client Mystère - Banque Continentale des Antilles
### Réseau Antilles-Guyane
#### Vague 1 (T2 2025)

> **Classification :** Confidentiel. Usage interne BCA (Version 1.0)  
> **Instrument déployé sur :** ODK Collect / ONA  
> **XLSForm :** `01_instrument/BCA_audit_qualite_v1.xlsx`

---

## Table des matières

1. [Architecture générale](#1-architecture-générale)
2. [Module 1 : Identification de la visite](#2-module-1-identification-de-la-visite)
3. [Module 2 : Environnement extérieur](#3-module-2-environnement-extérieur)
4. [Module 3 : Accueil et expérience d'attente](#4-module-3-accueil-et-expérience-dattente)
5. [Module 4 : Professionnalisme du personnel](#5-module-4-professionnalisme-du-personnel)
6. [Module 5 : Exécution du service](#6-module-5-exécution-du-service)
7. [Module 6 : Environnement physique intérieur](#7-module-6-environnement-physique-intérieur)
8. [Module 7 : Services numériques](#8-module-7-services-numériques)
9. [Module 8 : Clôture et vérification anti-fraude](#9-module-8-clôture-et-vérification-anti-fraude)
10. [Récapitulatif des variables et formule composite](#10-récapitulatif-des-variables-et-formule-composite)

---

## 1. Architecture générale

### Logique de l'instrument

Huit modules. Les modules 1 et 8 sont administratifs (identification et clôture). Les modules 2 à 7 produisent les scores. Le module 5 est conditionnel : ODK n'active que le sous-module correspondant au scénario assigné.

| Module | Score brut | Poids | Contribution max |
|---|---|---|---|
| M1 Identification | non scoré | - | métadonnées de la visite |
| M2 Environnement extérieur | /11 | 10 % | 10 |
| M3 Accueil + attente | /14 | 15 % | 15 |
| M4 Professionnalisme | /16 | 20 % | 20 |
| M5 Exécution du service | /16–18 | 30 % | 30 [conditionnel S1–S5] |
| M6 Environnement intérieur | /11 | 10 % | 10 |
| M7 Services numériques | /13 | 15 % | 15 |
| M8 Clôture + anti-fraude | non scoré | - | contrôle qualité |

### Conventions de nommage des variables

```
m{module}_{numéro séquentiel}_{nom_court}

Exemples :
  m2_01_facade         → Module 2, item 1, façade
  m3_02_temps_attente  → Module 3, item 2, temps d'attente
  m5s1_03_docs_requis  → Module 5 scénario S1, item 3, documents requis
```

### Types de réponse

| Code | Type | Description | Valeurs |
|---|---|---|---|
| BARS4 | Échelle comportementale ancrée | 4 niveaux | 0, 1, 2, 3 |
| BARS3 | Échelle comportementale ancrée | 3 niveaux | 0, 1, 2 |
| BIN | Binaire | Oui / Non | 1, 0 |
| INT | Entier | Valeur numérique | Ex. durée en minutes |
| CHR | Texte libre | Observation narrative | Texte |
| SEL | Sélection dans liste | Choix unique | Valeur codée |

---

## 2. Module 1 : Identification de la visite

**Non scoré.** Collecte les métadonnées administratives, les horodatages et les durées déclarées.

### Variables administratives

| Variable | Label | Type | Valeurs et contraintes |
|---|---|---|---|
| `m1_id_visite` | Identifiant unique de la visite | CHR | Auto : `{id_agence}-V{1-5}-{date}` |
| `m1_id_enqueteur` | Code enquêteur | SEL | EQ-01 à EQ-25 |
| `m1_id_agence` | Code agence | SEL | BCA-MQ-01 à BCA-GF-05 |
| `m1_scenario` | Scénario assigné | SEL | S1, S2, S3, S4, S5 |
| `m1_date_visite` | Date de la visite | DATE | ISO 8601 : YYYY-MM-DD |
| `m1_creneau` | Créneau horaire | SEL | Matin, Midi, Après-midi |
| `m1_vague` | Numéro de vague | INT | 1 (constant) |

### Horodatages

Deux horodatages sont saisis dans ODK, tous deux à l'extérieur de l'agence. L'enquêteur ne sort pas son téléphone pendant l'interaction avec l'agent.

| Variable | Label | Type | Moment de saisie |
|---|---|---|---|
| `m1_t1_arrivee` | Heure d'arrivée | TIME | Juste avant de franchir la porte d'entrée |
| `m1_t4_depart` | Heure de départ | TIME | Juste après être sorti de l'agence |

### Durées déclarées

Les durées d'attente et de service ne sont pas calculées depuis des horodatages intermédiaires. Elles sont renseignées par l'enquêteur après la visite, en minutes, sur la base de son observation directe.

| Variable | Label | Type | Contraintes |
|---|---|---|---|
| `m1_duree_attente` | Temps d'attente avant prise en charge | INT | En minutes, ≥ 0 |
| `m1_duree_service` | Durée de l'échange avec l'agent | INT | En minutes, ≥ 1 |
| `m1_duree_totale` | Durée totale déclarée | INT | Calculé : `m1_duree_attente + m1_duree_service` |

### Captures GPS

| Variable | Label | Type | Déclenchement |
|---|---|---|---|
| `m1_gps_arr_lat` / `m1_gps_arr_lon` | GPS à l'arrivée | GPS | Automatique à T1 |
| `m1_gps_dep_lat` / `m1_gps_dep_lon` | GPS au départ | GPS | Automatique à T4 |
| `m1_gps_valide` | Les deux lectures dans géofence 100 m | BIN | Calculé automatiquement |

Le rayon de géofence est fixé à 100 m autour du centroïde de chaque agence. Si T1 ou T4 tombe hors de ce périmètre, la visite déclenche le flag FD-02.

---

## 3. Module 2 : Environnement extérieur

**Score brut /11. Poids 10 %. Contribution max 10 points**

Observé avant d'entrer dans l'agence.

| Variable | Item | Type | Ancres comportementales | Max |
|---|---|---|---|---|
| `m2_01_facade` | État de la façade et peinture | BARS4 | 0 = Dégradée, traces visibles / 1 = Usée, sans dommage / 2 = Correcte, propre / 3 = Soignée, récente | 3 |
| `m2_02_signaletique` | Visibilité et état de la signalétique | BARS4 | 0 = Absente ou illisible / 1 = Présente mais décolorée ou abîmée / 2 = Lisible et complète / 3 = Lisible, éclairée, conforme charte | 3 |
| `m2_03_acces` | Accessibilité PMR (rampe, espace) | BARS3 | 0 = Aucun dispositif / 1 = Dispositif présent mais inadéquat / 2 = Accès conforme et dégagé | 2 |
| `m2_04_proprete_abords` | Propreté des abords immédiats | BARS4 | 0 = Déchets, désordre marqué / 1 = Quelques déchets / 2 = Propre / 3 = Propre et entretenu | 3 |
| `m2_05_photo_facade` | Photo façade | PHOTO | Obligatoire | - |
| `m2_06_photo_signa` | Photo signalétique | PHOTO | Obligatoire | - |
| `m2_note_ext` | Observation libre extérieur | CHR | Optionnel | - |

**Score M2** = `m2_01 + m2_02 + m2_03 + m2_04` (**max 11**)

---

## 4. Module 3 : Accueil et expérience d'attente

**Score brut /14. Poids 15 %. Contribution max 15 points**

| Variable | Item | Type | Ancres comportementales | Max |
|---|---|---|---|---|
| `m3_01_accueil_verbal` | Qualité de l'accueil verbal | BARS4 | 0 = Aucune reconnaissance / 1 = Reconnaissance après initiative client / 2 = Reconnaissance verbale en moins de 30 s / 3 = Contact visuel + accueil verbal + orientation en moins de 30 s | 3 |
| `m3_02_temps_attente` | Temps d'attente avant prise en charge | BARS4 | 0 = Plus de 15 min / 1 = 10 à 15 min / 2 = 5 à 10 min / 3 = Moins de 5 min | 3 |
| `m3_03_gestion_file` | Gestion visible de la file d'attente | BARS3 | 0 = Aucune gestion / 1 = Signalétique présente, pas de prise en charge active / 2 = Agent dédié ou système de ticket fonctionnel | 2 |
| `m3_04_confort_attente` | Confort de la zone d'attente | BARS4 | 0 = Pas de sièges disponibles / 1 = Sièges disponibles, état dégradé / 2 = Sièges disponibles, état correct / 3 = Sièges + eau ou documentation + climatisation fonctionnelle | 3 |
| `m3_05_info_attente` | Information proactive sur le délai | BARS3 | 0 = Aucune information / 1 = Information donnée uniquement si demandée / 2 = Information spontanée avec excuse si délai long | 2 |
| `m3_06_photo_attente` | Photo zone d'attente | PHOTO | Obligatoire | - |
| `m3_note_accueil` | Observation libre accueil | CHR | Optionnel | - |

**Score M3** = `m3_01 + m3_02 + m3_03 + m3_04 + m3_05` (**max 14**)

---

## 5. Module 4 : Professionnalisme du personnel

**Score brut /16. Poids 20 %. Contribution max 20 points**

| Variable | Item | Type | Ancres comportementales | Max |
|---|---|---|---|---|
| `m4_01_tenue` | Tenue vestimentaire et badge | BARS4 | 0 = Tenue non conforme, sans badge / 1 = Badge absent ou tenue incomplète / 2 = Tenue conforme + badge visible / 3 = Tenue conforme + badge + présentation soignée | 3 |
| `m4_02_courtoisie` | Courtoisie et respect du client | BARS4 | 0 = Impoli ou indifférent / 1 = Neutre, sans formule de politesse / 2 = Poli, formules standards / 3 = Chaleureux, personnalisé, contact nominatif | 3 |
| `m4_03_ecoute` | Qualité d'écoute active | BARS4 | 0 = Coupe la parole, distrait / 1 = Écoute passive, sans reformulation / 2 = Écoute et reformule / 3 = Écoute, reformule et vérifie la compréhension | 3 |
| `m4_04_clarte` | Clarté des explications | BARS4 | 0 = Explications absentes ou incompréhensibles / 1 = Explications incomplètes / 2 = Explications claires et complètes / 3 = Explications claires + support visuel ou document remis | 3 |
| `m4_05_confidentialite` | Respect de la confidentialité | BARS3 | 0 = Informations partagées à voix haute sans précaution / 1 = Précautions partielles / 2 = Espace privatif utilisé ou voix basse systématique | 2 |
| `m4_06_conge` | Formule de congé et clôture | BARS3 | 0 = Aucune formule de congé / 1 = Formule minimale / 2 = Remerciement + invitation à revenir | 2 |
| `m4_07_role_agent` | Rôle de l'agent principal | SEL | Guichetier, Conseiller, Directeur, Autre | - |
| `m4_note_pro` | Observation libre professionnalisme | CHR | Optionnel | - |

**Score M4** = `m4_01 + m4_02 + m4_03 + m4_04 + m4_05 + m4_06` (**max 16**)

---

## 6. Module 5 : Exécution du service

**Score brut /16 à /18 selon scénario. Poids 30 %. Contribution max 30 points**

ODK active un seul sous-module selon `m1_scenario`. Chaque sous-module normalise son score brut à /25 avant d'entrer dans le composite.

```
m1_scenario = S1  →  M5-S1  (Ouverture de compte)     score brut max /18
m1_scenario = S2  →  M5-S2  (Crédit personnel)         score brut max /18
m1_scenario = S3  →  M5-S3  (Réclamation formelle)     score brut max /18
m1_scenario = S4  →  M5-S4  (Dépôt d'espèces)          score brut max /17
m1_scenario = S5  →  M5-S5  (Services numériques)      score brut max /16
```

---

### M5-S1 : Ouverture de compte

**Activé si** `m1_scenario = S1`

| Variable | Item | Type | Ancres comportementales | Max |
|---|---|---|---|---|
| `m5s1_01_besoins` | Analyse des besoins avant proposition | BARS4 | 0 = Aucune question / 1 = Une question générique / 2 = Deux questions ou plus ciblées / 3 = Analyse structurée avec reformulation | 3 |
| `m5s1_02_produit` | Adéquation du produit proposé | BARS4 | 0 = Produit non adapté ou non proposé / 1 = Produit standard sans justification / 2 = Produit adapté avec justification / 3 = Produit adapté + comparaison d'options | 3 |
| `m5s1_03_docs_requis` | Information sur les documents requis | BARS3 | 0 = Pas d'information / 1 = Information partielle / 2 = Liste complète remise ou expliquée | 2 |
| `m5s1_04_kyc` | Vérification KYC (identité, domicile) | BARS4 | 0 = Aucune vérification / 1 = Vérification partielle / 2 = Vérification standard complète / 3 = Vérification complète + explication de la raison | 3 |
| `m5s1_05_delai` | Information sur le délai d'ouverture | BARS3 | 0 = Aucune information / 1 = Délai approximatif / 2 = Délai précis + étapes expliquées | 2 |
| `m5s1_06_suite` | Clarté des prochaines étapes | BARS4 | 0 = Aucune information / 1 = Étapes vagues / 2 = Étapes claires / 3 = Étapes claires + document récapitulatif | 3 |
| `m5s1_07_conformite` | Conformité générale de la procédure | BARS3 | 0 = Procédure incomplète ou erronée / 1 = Procédure partielle / 2 = Procédure complète et conforme REC v3.0 | 2 |
| `m5s1_note` | Observation libre S1 | CHR | Optionnel | - |

**Score S1 brut** = somme des items (**max 18**)  
**Score S1 normalisé** = `(score_brut / 18) × 25`

---

### M5-S2 : Crédit personnel

**Activé si** `m1_scenario = S2`

| Variable | Item | Type | Ancres comportementales | Max |
|---|---|---|---|---|
| `m5s2_01_besoins` | Analyse du besoin avant chiffrage | BARS4 | 0 = Chiffrage immédiat sans questions / 1 = Une question sur le montant / 2 = Questions sur montant + projet / 3 = Analyse complète : montant, projet, situation, capacité | 3 |
| `m5s2_02_credit_responsable` | Application du principe crédit responsable | BARS4 | 0 = Taux présenté sans analyse de capacité / 1 = Capacité mentionnée sans vérification / 2 = Capacité vérifiée sommairement / 3 = Analyse de capacité + mise en garde si nécessaire | 3 |
| `m5s2_03_taux_frais` | Transparence sur taux et frais | BARS4 | 0 = Taux ou frais non mentionnés / 1 = Taux mentionné, frais omis / 2 = Taux + frais mentionnés / 3 = TAEG + frais + coût total expliqués | 3 |
| `m5s2_04_alternatives` | Présentation d'alternatives | BARS3 | 0 = Une seule option / 1 = Deux options sans comparaison / 2 = Comparaison structurée de deux options ou plus | 2 |
| `m5s2_05_delai_reponse` | Information sur le délai de réponse | BARS3 | 0 = Aucune information / 1 = Délai vague / 2 = Délai précis + conditions | 2 |
| `m5s2_06_docs` | Documents ou simulation remis | BARS4 | 0 = Rien remis / 1 = Référence verbale seulement / 2 = Document ou lien remis / 3 = Simulation écrite personnalisée | 3 |
| `m5s2_07_conformite` | Conformité procédure crédit responsable | BARS3 | 0 = Non conforme / 1 = Partiellement conforme / 2 = Conforme REC v3.0 | 2 |
| `m5s2_note` | Observation libre S2 | CHR | Optionnel | - |

**Score S2 brut** = somme des items (**max 18**)  
**Score S2 normalisé** = `(score_brut / 18) × 25`

---

### M5-S3 : Réclamation formelle

**Activé si** `m1_scenario = S3`

| Variable | Item | Type | Ancres comportementales | Max |
|---|---|---|---|---|
| `m5s3_01_reception` | Accueil de la réclamation | BARS4 | 0 = Réclamation minimisée ou refusée / 1 = Acceptée sans empathie / 2 = Acceptée avec empathie / 3 = Acceptée + reformulation + validation du ressenti | 3 |
| `m5s3_02_empathie` | Expression d'empathie | BARS3 | 0 = Aucune / 1 = Formule générique / 2 = Empathie personnalisée et sincère | 2 |
| `m5s3_03_procedure` | Explication de la procédure de réclamation | BARS4 | 0 = Aucune explication / 1 = Renvoi vague vers un formulaire / 2 = Procédure expliquée / 3 = Procédure + délai légal + référence du médiateur | 3 |
| `m5s3_04_escalade` | Escalade appropriée si nécessaire | BARS3 | 0 = Pas d'escalade alors que nécessaire / 1 = Escalade proposée sans suivi / 2 = Escalade effectuée ou non nécessaire | 2 |
| `m5s3_05_trace` | Enregistrement de la réclamation | BARS4 | 0 = Aucune trace / 1 = Note interne sans accusé / 2 = Accusé de réception verbal / 3 = Accusé de réception écrit avec numéro de dossier | 3 |
| `m5s3_06_delai` | Information sur le délai de traitement | BARS3 | 0 = Aucun délai mentionné / 1 = Délai vague / 2 = Délai légal précis (10 jours ouvrés ACPR) | 2 |
| `m5s3_07_conformite` | Conformité procédure réclamation | BARS4 | 0 = Non conforme / 1 = Partiellement conforme / 2 = Conforme / 3 = Conforme + remise du document info médiateur | 3 |
| `m5s3_note` | Observation libre S3 | CHR | Optionnel | - |

**Score S3 brut** = somme des items (**max 18**)  
**Score S3 normalisé** = `(score_brut / 18) × 25`

---

### M5-S4 : Dépôt d'espèces

**Activé si** `m1_scenario = S4`

| Variable | Item | Type | Ancres comportementales | Max |
|---|---|---|---|---|
| `m5s4_01_verification` | Vérification de l'identité avant dépôt | BARS4 | 0 = Aucune vérification / 1 = Numéro de compte seulement / 2 = Pièce d'identité demandée / 3 = Pièce d'identité + vérification visuelle active | 3 |
| `m5s4_02_comptage` | Comptage des espèces | BARS4 | 0 = Pas de comptage visible / 1 = Comptage une fois / 2 = Comptage deux fois / 3 = Comptage deux fois + annonce du montant à voix haute | 3 |
| `m5s4_03_lcbft` | Application procédure LCB-FT | BARS4 | 0 = Aucune question pour montant au-dessus du seuil / 1 = Question posée mais non documentée / 2 = Question + enregistrement / 3 = Procédure complète conforme LAB | 3 |
| `m5s4_04_recu` | Remise d'un reçu | BARS3 | 0 = Pas de reçu / 1 = Reçu proposé après demande / 2 = Reçu remis spontanément | 2 |
| `m5s4_05_rapidite` | Rapidité d'exécution | BARS4 | 0 = Plus de 10 min / 1 = 7 à 10 min / 2 = 4 à 7 min / 3 = Moins de 4 min | 3 |
| `m5s4_06_exactitude` | Exactitude du montant enregistré | BIN | 0 = Erreur constatée / 1 = Montant correct | 1 |
| `m5s4_07_conformite` | Conformité générale procédure guichet | BARS3 | 0 = Non conforme / 1 = Partiellement conforme / 2 = Conforme REC v3.0 | 2 |
| `m5s4_note` | Observation libre S4 | CHR | Optionnel | - |

**Score S4 brut** = somme des items (**max 17**)  
**Score S4 normalisé** = `(score_brut / 17) × 25`

---

### M5-S5 : Services numériques

**Activé si** `m1_scenario = S5`

| Variable | Item | Type | Ancres comportementales | Max |
|---|---|---|---|---|
| `m5s5_01_connaissance` | Connaissance des services numériques | BARS4 | 0 = Incapable de décrire les services / 1 = Description vague / 2 = Description correcte des fonctions principales / 3 = Description complète + démonstration ou support visuel | 3 |
| `m5s5_02_adequation` | Adéquation de la recommandation au profil | BARS4 | 0 = Recommandation générique / 1 = Légèrement adaptée / 2 = Adaptée au profil déclaré / 3 = Adaptée + justification personnalisée | 3 |
| `m5s5_03_accompagnement` | Accompagnement à la prise en main | BARS4 | 0 = Aucun accompagnement / 1 = Renvoi vers site web ou FAQ / 2 = Explication pas à pas / 3 = Explication + offre d'aide à l'activation | 3 |
| `m5s5_04_promotion_canal` | Promotion active du canal numérique | BARS3 | 0 = Canal numérique non mentionné / 1 = Mentionné mais non promu / 2 = Promu avec avantages explicités | 2 |
| `m5s5_05_securite` | Information sur la sécurité numérique | BARS3 | 0 = Aucune mention / 1 = Mention générique / 2 = Conseils spécifiques : mot de passe, phishing, double authentification | 2 |
| `m5s5_06_conformite` | Conformité procédure services numériques | BARS4 | 0 = Non conforme / 1 = Partiellement conforme / 2 = Conforme / 3 = Conforme + remise d'un support écrit ou QR code | 3 |
| `m5s5_note` | Observation libre S5 | CHR | Optionnel | - |

**Score S5 brut** = somme des items (**max 16**)  
**Score S5 normalisé** = `(score_brut / 16) × 25`

---

## 7. Module 6 : Environnement physique intérieur

**Score brut /11. Poids 10 %. Contribution max 10 points**

Observé pendant la visite.

| Variable | Item | Type | Ancres comportementales | Max |
|---|---|---|---|---|
| `m6_01_proprete` | Propreté générale de l'espace intérieur | BARS4 | 0 = Sale, désordonné / 1 = Quelques salissures / 2 = Propre / 3 = Propre et ordonné, aucune trace | 3 |
| `m6_02_affichage` | Affichage réglementaire visible | BARS4 | 0 = Absent / 1 = Partiel / 2 = Complet / 3 = Complet, lisible, à jour (date visible) | 3 |
| `m6_03_materiel_info` | Disponibilité de documentation client | BARS3 | 0 = Aucune documentation / 1 = Documentation présente mais ancienne ou désordonnée / 2 = Documentation à jour et accessible | 2 |
| `m6_04_ambiance` | Ambiance générale (bruit, température, lumière) | BARS4 | 0 = Conditions difficiles sur 2 critères ou plus / 1 = Un critère défaillant / 2 = Conditions acceptables / 3 = Conditions agréables sur les 3 critères | 3 |
| `m6_05_photo_interieur` | Photo environnement intérieur | PHOTO | Obligatoire | - |
| `m6_note_int` | Observation libre intérieur | CHR | Optionnel | - |

**Score M6** = `m6_01 + m6_02 + m6_03 + m6_04` (**max 11**)

---

## 8. Module 7 : Services numériques

**Score brut /13. Poids 15 %. Contribution max 15 points**

Observé indépendamment du scénario. Évalue la présence et la qualité des outils numériques dans l'agence.

| Variable | Item | Type | Ancres comportementales | Max |
|---|---|---|---|---|
| `m7_01_borne` | Présence et état d'une borne en libre-service | BARS4 | 0 = Absente / 1 = Présente mais hors service / 2 = Fonctionnelle / 3 = Fonctionnelle + signalétique d'utilisation | 3 |
| `m7_02_affichage_digital` | Affichage digital (écrans, bornes info) | BARS3 | 0 = Absent / 1 = Présent mais inactif / 2 = Actif et informatif | 2 |
| `m7_03_wifi` | Disponibilité Wi-Fi client | BIN | 0 = Absent / 1 = Réseau détectable | 1 |
| `m7_04_promo_appli` | Promotion visible de l'application mobile | BARS3 | 0 = Aucune / 1 = Affiche présente / 2 = Affiche + QR code fonctionnel testé | 2 |
| `m7_05_support_digital` | Support digital disponible au guichet | BARS3 | 0 = Absent / 1 = Tablette ou écran présent mais non utilisé / 2 = Utilisé activement pour accompagner le client | 2 |
| `m7_06_score_global_digital` | Impression globale maturité digitale agence | BARS4 | 0 = Aucun équipement digital / 1 = Équipements présents non fonctionnels / 2 = Équipements fonctionnels, usage passif / 3 = Équipements fonctionnels, usage actif et proactif | 3 |
| `m7_note_digital` | Observation libre digital | CHR | Optionnel | - |

**Score M7** = `m7_01 + m7_02 + m7_03 + m7_04 + m7_05 + m7_06` (**max 13**)

---

## 9. Module 8 : Clôture et vérification anti-fraude

**Non scoré.** Contrôle qualité de la visite.

### Questions de vérification comportementale

Ces cinq questions alimentent le score anti-fraude (règle FD-03 : score inférieur à 6 sur 10 déclenche une mise en examen automatique).

| Variable | Question | Type | Condition |
|---|---|---|---|
| `m8_01_agent_desc` | Décrivez la tenue de l'agent principal | CHR | Toujours |
| `m8_02_file_attente` | Combien de clients attendaient à votre arrivée ? | INT | Toujours |
| `m8_03_element_distinct` | Décrivez un élément distinctif de l'agence | CHR | Toujours |
| `m8_04_incident` | Un incident ou imprévu s'est-il produit ? | BIN | Toujours |
| `m8_05_incident_desc` | Si oui, décrivez l'incident | CHR | Si `m8_04 = 1` |
| `m8_06_abandon` | La visite a-t-elle été abandonnée ? | BIN | Toujours |
| `m8_07_abandon_code` | Code d'abandon | SEL | Si `m8_06 = 1`, A1 = Risque, A2 = Scénario impossible, A3 = Agence fermée, A4 = Autre |

### Score anti-fraude

| Variable | Composante vérifiée | Max |
|---|---|---|
| `m8_af_01` | Cohérence description agent vs rôle déclaré en M4 | 2 |
| `m8_af_02` | Cohérence file d'attente vs temps d'attente déclaré | 2 |
| `m8_af_03` | Élément distinctif vérifiable contre base photo | 2 |
| `m8_af_04` | Cohérence durée totale déclarée vs scénario | 2 |
| `m8_af_05` | Cohérence GPS T1/T4 vs horodatages | 2 |
| `m8_score_antifraude` | **Score total** | **/10** |

Seuil FD-03 : `m8_score_antifraude < 6` déclenche une mise en examen automatique.

### Soumission

| Variable | Label | Type |
|---|---|---|
| `m8_heure_soumission` | Horodatage de soumission du formulaire | DATETIME |
| `m8_delai_soumission` | Délai entre T4 et soumission (contrôle FD-06) | Minutes |
| `m8_gps_soumission` | GPS au moment de la soumission | GPS |

`m8_delai_soumission` = `m8_heure_soumission − m1_t4_depart`. Seuil FD-06 : inférieur à 8 minutes déclenche une mise en examen.

---

## 10. Récapitulatif des variables et formule composite

### Comptage par module

| Module | Variables scorées | Variables admin, photo, texte | Total |
|---|---|---|---|
| M1 Identification | 0 | 11 | 11 |
| M2 Environnement ext. | 4 | 3 | 7 |
| M3 Accueil + attente | 5 | 2 | 7 |
| M4 Professionnalisme | 6 | 2 | 8 |
| M5 Exécution (actif) | 7 | 1 | 8 |
| M6 Environnement int. | 4 | 2 | 6 |
| M7 Digital agence | 6 | 1 | 7 |
| M8 Clôture anti-fraude | 5 | 7 | 12 |
| **Total** | **37** | **29** | **66** |

### Scores bruts et normalisés

| Dimension | Variables scorées | Score brut réel | Normalisé | Poids | Contribution max |
|---|---|---|---|---|---|
| Environnement ext. | `m2_01–04` | /11 | /11 | 10 % | 10 |
| Accueil + attente | `m3_01–05` | /14 | /14 | 15 % | 15 |
| Professionnalisme | `m4_01–06` | /16 | /16 | 20 % | 20 |
| Exécution S1 | `m5s1_01–07` | /18 | /25 | 30 % | 30 |
| Exécution S2 | `m5s2_01–07` | /18 | /25 | 30 % | 30 |
| Exécution S3 | `m5s3_01–07` | /18 | /25 | 30 % | 30 |
| Exécution S4 | `m5s4_01–07` | /17 | /25 | 30 % | 30 |
| Exécution S5 | `m5s5_01–06` | /16 | /25 | 30 % | 30 |
| Environnement int. | `m6_01–04` | /11 | /11 | 10 % | 10 |
| Digital agence | `m7_01–06` | /13 | /13 | 15 % | 15 |

### Formule composite

```
Score composite (0 à 100) =
    (score_m2 / 11) × 10
  + (score_m3 / 14) × 15
  + (score_m4 / 16) × 20
  + (score_m5_norm / 25) × 30
  + (score_m6 / 11) × 10
  + (score_m7 / 13) × 15

où score_m5_norm = (score_m5_brut / score_m5_max) × 25
et  score_m5_max ∈ {18, 18, 18, 17, 16} selon scénario {S1, S2, S3, S4, S5}
```

### Décisions de conception associées

**DEC-14**: Les scores bruts réels sont /11, /14, /16, /11 pour M2, M3, M4, M6. La formule composite utilise ces dénominateurs réels. Les contributions pondérées finales (10, 15, 20, 10 points) restent identiques.

**DEC-15**: M5 scoring, blueprint v2. Dénominateurs par scénario : S1 = 18, S2 = 18, S3 = 18, S4 = 17, S5 = 16. Tous normalisés à /25 avant entrée dans le composite.

**DEC-16**: Protocole d'horodatage simplifié. T2 et T3 supprimés. Seuls T1 (avant entrée) et T4 (après sortie) sont saisis dans ODK. Les durées d'attente et de service sont déclarées par l'enquêteur après la visite en minutes. Motif : usage du téléphone pendant l'interaction en agence bancaire atypique et risque de détection.

**FD-05**: L'item de détection basé sur l'écart GPS photo vs GPS formulaire est défini dans la grille mais non calculable en Vague 1. Modification prévue pour la Vague 2.

---

*Unité Audit et Qualité de Service*  
*Version 1.0*  
*Confidentiel. Usage interne uniquement*