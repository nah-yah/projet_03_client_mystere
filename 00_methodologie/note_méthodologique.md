# Note Méthodologique
## Audit Qualité par Client Mystère - Banque Continentale des Antilles
### Réseau Antilles-Guyane 
#### Vague 1 - T2 2025

> **Classification :** Confidentiel. Usage interne BCA (Version 1.0)

---

## Table des matières

1. [Le problème que cet audit résout](#1-le-problème-que-cet-audit-résout)
2. [Pourquoi le client mystère](#2-pourquoi-le-client-mystère)
3. [Les cinq scénarios de visite](#3-les-cinq-scénarios-de-visite)
4. [Le pool d'enquêteurs](#4-le-pool-denquêteurs)
5. [Plan d'échantillonnage](#5-plan-déchantillonnage)
6. [L'instrument de collecte](#6-linstrument-de-collecte)
7. [Architecture de scoring](#7-architecture-de-scoring)
8. [Éthique et limites](#8-éthique-et-limites)
9. [Calendrier des livrables](#9-calendrier-des-livrables)
10. [Références](#10-références)

---

## 1. Le problème que cet audit résout

La BCA exploite 24 agences sur trois territoires français d'outre-mer. Toutes opèrent sous le même cadre réglementaire ACPR/Banque de France/BCE, appliquent la même charte qualité (Référentiel Excellence Client v3.0, 2024) et suivent les mêmes procédures internes. Depuis 2024, les remontées du service client et les taux de satisfaction post-visite divergent pourtant d'un territoire à l'autre, et parfois entre agences d'un même territoire.

La Direction Générale ne sait pas si ces écarts traduisent une différence réelle de qualité de service ou un biais de perception dans les données collectées. Les enquêtes de satisfaction actuelles ne répondent pas à cette question : elles capturent ce que le client croit avoir vécu, pas ce qui s'est passé. Cet audit tranche. Il produit des données observationnelles comparables sur les 24 agences, collectées selon un protocole identique, notées sur une grille comportementale commune.

### Objectifs

L'étude poursuit cinq objectifs distincts. Elle mesure la conformité de chaque agence aux standards du REC v3.0 sur six dimensions de service. Elle produit un classement par agence et par territoire fondé sur des scores composites pondérés. Elle distingue les écarts systémiques, présents dans plusieurs agences ou un territoire entier, des écarts localisés, propres à une agence. Elle teste l'association entre variables structurelles et scores qualité. Elle fournit enfin une baseline pour un programme d'amélioration continue sur trois vagues.

---

## 2. Pourquoi le client mystère

Trois méthodes de mesure de la qualité de service coexistent dans la littérature et la pratique bancaire. L'enquête de satisfaction client et l'entretien sortie de caisse captent tous deux de l'auto-déclaré : le client relate ce dont il se souvient, filtré par ses attentes préalables et sa politesse. L'observation structurée par un tiers formé capte du comportement réel, mais elle exige des observateurs identifiés, ce qui modifie l'attitude du personnel observé. Le client mystère combine les avantages des deux approches sans leurs défauts principaux : l'enquêteur exécute un scénario prédéfini, l'agent BCA ne sait pas qu'il est évalué, le score final renvoie à un comportement observable décrit dans la grille, pas à une impression.

| Méthode | Type de données | Biais principal | Valeur ajoutée |
|---|---|---|---|
| Enquête satisfaction | Auto-déclaré | Biais de mémoire | Perception globale |
| Entretien sortie de caisse | Auto-déclaré | Biais de politesse | Expérience immédiate |
| Observation structurée | Observé | Effet Hawthorne | Comportement réel |
| Client mystère (cette étude) | Scénario scoré | Rappel limité | Mesure standardisée |

L'enquêteur note les comportements dans les 30 minutes qui suivent la visite, avant que la mémoire ne filtre. La conception de l'instrument suit les standards de la Mystery Shopping Professionals Association (MSPA Europe, 2023), adaptés au contexte bancaire français d'outre-mer.

---

## 3. Les cinq scénarios de visite

Chaque agence reçoit cinq visites distinctes, une par scénario. L'équipe pré-randomise l'assignation avant le début de la collecte et la communique à chaque enquêteur dans son dossier de briefing individuel. Aucun enquêteur ne répète le même scénario dans la même agence sur la même vague.

| Code | Scénario | Ce qui est testé | Durée estimée |
|---|---|---|---|
| S1 | Demande d'ouverture de compte | Processus commercial, documentation, conformité KYC | 20 à 35 min |
| S2 | Renseignement sur un crédit personnel | Connaissance produit, analyse des besoins, crédit responsable | 15 à 25 min |
| S3 | Dépôt d'une réclamation formelle | Gestion des réclamations, escalade, empathie | 10 à 20 min |
| S4 | Dépôt d'espèces | Efficacité guichet, exactitude, conformité LCB-FT | 5 à 15 min |
| S5 | Renseignement sur les services numériques | Compétence digitale, accompagnement, promotion canal | 10 à 20 min |

Les scénarios couvrent les cinq transactions les plus fréquentes dans les agences BCA du réseau Antilles-Guyane. S3 et S4 couvrent des situations à fort enjeu réglementaire et leur poids dans le score final en tient compte indirectement via la dimension Exécution du service, qui pèse 30 % du score composite.

---

## 4. Le pool d'enquêteurs

### Profil requis

Le pool cible des personnes âgées de 21 à 65 ans, sans relation d'emploi antérieure avec BCA ou ses filiales, capables d'incarner un profil client plausible pour le scénario assigné. La maîtrise de l'instrument mobile est vérifiée lors de la certification : tout enquêteur qui n'atteint pas 80 % au quiz de fin de formation ne participe pas à la collecte. Le pool comprend 25 enquêteurs pour couvrir les trois territoires :

- 15 en Martinique,
- 5 en Guadeloupe,
- 5 en Guyane française,

avec une marge pour les abandons et remplacements.

La composition cible vise 50 % de femmes, 45 % d'hommes et 5 % d'autres profils ou sans préférence déclarée, répartis sur quatre tranches d'âge : 25 % entre 21 et 30 ans, 35 % entre 31 et 45 ans, 30 % entre 46 et 60 ans, 10 % au-delà. Le statut professionnel varie selon la plausibilité du scénario assigné.

### Règles anti-collusion

Les enquêteurs ne partagent pas leurs assignments, localisations ou scores pendant la collecte. Toute communication transite par le coordinateur de terrain central. L'instrument ODK enregistre les métadonnées, coordonnées GPS et horodatages, qui permettent de détecter les visites fictives indépendamment des déclarations des enquêteurs. Un enquêteur dont deux visites déclenchent des flags de fraude dans la même vague est retiré du pool et ses données sont exclues avant l'analyse.

### Formation

La formation se déroule en demi-journée hybride : trois heures en synchrone et une heure en autonomie. Elle couvre les principes et l'éthique du client mystère avec la base légale RGPD, l'exécution d'un scénario sans mémoriser un script avec la gestion de l'imprévu et le protocole d'abandon, la prise en main d'ODK Collect avec les horodatages et la validation GPS, puis les questions anti-fraude. La certification finale combine un quiz de vingt questions et un parcours guidé complet de l'instrument. Le module sur l'abandon de visite mérite une attention particulière : il couvre deux cas absents de la plupart des formations standard. Gérer un agent qui sort du script attendu et reconnaître les conditions qui justifient l'arrêt propre de la visite.

---

## 5. Plan d'échantillonnage

### Les 24 agences

La base de sondage est la liste des agences au T1 2025, stratifiée par territoire, tier et créneau horaire. Le fichier complet avec coordonnées GPS, ancienneté et caractéristiques opérationnelles se trouve dans `02_donnees/brutes/metadata_agences.csv`, documenté dans `00_methodologie/cadre_echantillonnage.md`.

| Territoire | Agences | Tier 1 | Tier 2 | Tier 3 |
|---|---|---|---|---|
| Martinique | 11 | 2 | 4 | 5 |
| Guadeloupe | 8 | 2 | 3 | 3 |
| Guyane française | 5 | 1 | 2 | 2 |
| **Total** | **24** | **5** | **9** | **10** |

L'agence BCA-GP-06 en Guadeloupe relève du groupe d'ancienneté G3 (14 ans, seuil G2 fixé à 15 ans). Cette classification affecte les comparaisons par groupe d'ancienneté mais n'a pas d'incidence sur le score composite. Le groupe G4 ne compte qu'une seule agence (BCA-MQ-11) : les comparaisons inter-groupes l'excluent pour éviter les conclusions non généralisables.

### Volume de visites et règles de rotation

Chaque agence reçoit exactement cinq visites, une par scénario, réparties sur cinq jours ouvrés distincts. Le plan de rotation garantit qu'aucun enquêteur ne visite la même agence deux fois dans la même vague, que les visites se distribuent sur les trois créneaux :

- matin 8h à 12h,
- midi 12h à 14h,
- après-midi 14h à 17h,

et que deux visites à la même agence ne tombent pas le même jour calendaire. Les enquêteurs opèrent dans leur territoire de résidence.

Cinq visites par agence ne permettent pas de produire des estimations statistiquement robustes au niveau du conseiller individuel. Les scores s'interprètent au niveau agence, et les comparaisons entre agences ou entre territoires sont les unités d'analyse pertinentes. La Vague 2 permettra des comparaisons longitudinales plus informatives.

---

## 6. L'instrument de collecte

### Structure du questionnaire

L'instrument comporte onze modules numérotés M1 à M8, dont M5 est conditionnel au scénario actif. M1 capture les métadonnées de la visite (identifiants, scénario, créneau, horodatages, GPS). M2 à M4 couvrent l'environnement extérieur, l'accueil et l'attente, le professionnalisme du personnel. M5 capture l'exécution du service sur des items propres à chaque scénario. M6 et M7 couvrent l'environnement intérieur et les services numériques. M8 regroupe les questions de vérification anti-fraude, le délai de soumission du formulaire et les codes d'abandon ou d'incident.

L'instrument est déployé sur ODK Collect. Les données transitent par un serveur ONA sécurisé, chiffré en transit et au repos, hébergé dans l'Union européenne. Seul le coordinateur central dispose des droits d'export.

### La grille BARS

Les items de score utilisent une échelle comportementale ancrée (BARS) à quatre niveaux, de 0 à 3. Chaque ancre décrit un comportement observable, pas une appréciation subjective. L'ancre pour l'item « accueil verbal » en est un exemple :

| Score | Comportement observable |
|---|---|
| 0 | Aucune reconnaissance de la présence du client |
| 1 | Reconnaissance uniquement après que le client a pris l'initiative |
| 2 | Reconnaissance verbale dans les 30 secondes, sans sollicitation |
| 3 | Contact visuel, accueil verbal et orientation dans les 30 secondes |

Cette formulation élimine les jugements de valeur et permet d'aligner les notations entre enquêteurs formés sur le même corpus d'exemples. Les items binaires (0 ou 1) couvrent les comportements sans graduation observable comme la présence ou l'absence d'un reçu, l'activation ou non d'une vérification LCB-FT.

### Le protocole d'horodatage

L'enquêteur saisit deux horodatages dans ODK Collect, tous deux à l'extérieur de l'agence :

- **T1** juste avant de franchir la porte d'entrée ;
- **T4** juste après être sorti de l'agence.

ODK capture automatiquement les coordonnées GPS à ces deux moments. L'enquêteur ne sort pas son téléphone pendant l'interaction avec l'agent : l'usage visible du téléphone en agence bancaire est atypique et augmente le risque de détection.

Le temps d'attente et la durée de l'échange sont renseignés après la visite sous forme de durées déclarées en minutes. Ces deux valeurs, additionnées, constituent la durée de service totale. Le délai de soumission du formulaire (calculé entre T4 et l'horodatage de soumission ODK) alimente la règle de détection FD-06.

Le système compare les positions GPS capturées en T1 et T4 au polygone pré-enregistré de chaque agence, avec un rayon de géofence de 100 mètres. Si les deux lectures tombent hors géofence, la visite part en révision qualité.

---

## 7. Architecture de scoring

### Six dimensions, six poids

Le score composite repose sur six dimensions qui mesurent des aspects distincts de l'expérience client en agence. L'exécution du service (M5) pèse 30 % parce qu'elle capte la raison principale pour laquelle le client s'est déplacé. Les cinq sous-modules S1 à S5 ont des maxima bruts différents (18 points pour S1, S2 et S3 ; 17 pour S4 ; 16 pour S5), tous normalisés sur 25 pour maintenir la comparabilité inter-scénarios.

| Dimension | Module | Max brut réel | Poids | Points max |
|---|---|---|---|---|
| Environnement extérieur | M2 | 11 | 10 % | 10 |
| Accueil et expérience d'attente | M3 | 14 | 15 % | 15 |
| Professionnalisme du personnel | M4 | 16 | 20 % | 20 |
| Exécution du service | M5 (normalisé /25) | 16 à 18 selon scénario | 30 % | 30 |
| Environnement physique intérieur | M6 | 11 | 10 % | 10 |
| Services numériques | M7 | 13 | 15 % | 15 |
| **Total** | | | **100 %** | **100** |

La dimension Services numériques repose sur M7 uniquement, six items pour un maximum brut de 13 points. M8 ne contribue pas au score composite : il alimente exclusivement la détection de fraude et la qualification des abandons.

### Formule du score composite

```
Score composite (0 à 100) =
    (m2_score_brut / 11) × 10
  + (m3_score_brut / 14) × 15
  + (m4_score_brut / 16) × 20
  + (m5_score_norm / 25) × 30
  + (m6_score_brut / 11) × 10
  + (m7_score_brut / 13) × 15
```


`m5_score_norm` est le score brut de l'item M5 actif ramené sur 25 par la formule `(score_brut / score_max_scenario) × 25`, avant d'entrer dans le composite. Cette normalisation préserve la comparabilité entre visites de scénarios différents.

### Grille de performance

| Score | Bande | Libellé | Action |
|---|---|---|---|
| 90 à 100 | A | Exemplaire | Reconnaissance et partage des pratiques |
| 75 à 89 | B | Compétent | Maintien et améliorations ciblées |
| 60 à 74 | C | En développement | Plan d'amélioration structuré |
| 45 à 59 | D | Insuffisant | Intervention prioritaire et revisite sous 60 jours |
| Moins de 45 | F | Préoccupant | Escalade Direction Générale et audit immédiat |

### Détection des visites frauduleuses

Cinq conditions déclenchent un flag automatique. Toute visite portant deux flags ou plus est exclue de l'analyse avant le nettoyage. L'exclusion se fait par règle de cumul, pas par jugement au cas par cas, ce qui garantit la reproductibilité de la décision.

| Code | Condition | Raison |
|---|---|---|
| FD-01 | Durée totale déclarée inférieure à 3 minutes | Implausible pour tout scénario, y compris S4 |
| FD-02 | GPS T1 ou T4 à plus de 100 m du centroïde de l'agence | L'enquêteur n'était probablement pas sur place |
| FD-03 | Score de vérification anti-fraude inférieur à 6 sur 10 | L'enquêteur ne peut pas décrire ce qu'il a observé |
| FD-04 | T4 antérieur à T1 | Erreur de saisie ou manipulation délibérée |
| FD-06 | Formulaire soumis moins de 8 minutes après T4 | Impossible de répondre honnêtement en ce délai |

FD-05 (écart entre le GPS des métadonnées photo et le GPS du formulaire supérieur à 200 m) sera activée à la Vague 2 après modification de l'instrument XLSForm.

---

## 8. Éthique et limites

### Observer sans prévenir

Le client mystère observe des personnes à leur insu. Quatre conditions rendent cette pratique acceptable dans le périmètre de cette étude. Les agents BCA savent, via communication interne, que des audits client mystère ont lieu périodiquement dans le réseau. L'instrument ne collecte aucune donnée personnelle identifiable : il enregistre le rôle de l'agent, jamais son nom. Les photos excluent les visages du personnel. Les scores alimentent un programme d'amélioration collective et ne servent pas seuls de base à des mesures disciplinaires individuelles.

L'étude respecte le RGPD et les dispositions applicables dans les départements et régions d'outre-mer français. Les enquêteurs ne sont pas tenus d'effectuer une visite qu'ils jugent risquée : l'instrument intègre un code d'abandon de visite, sans pénalité et sans justification exigée.

### Limites connues

| Limite | Mesure d'atténuation |
|---|---|
| Biais de rappel post-visite | Formulaire complété dans les 30 minutes suivant T4 |
| Variabilité inter-enquêteurs | Formation standardisée, BARS, certification à 80 % minimum |
| Petit échantillon par agence (n = 5) | Interprétation au niveau réseau, pas au niveau individuel |
| Scénarios artificiels | Scripts fondés sur les transactions les plus fréquentes de BCA |
| FD-05 non calculable en Vague 1 | Modification XLSForm prévue pour la Vague 2 |

Cinq visites par agence fournissent un signal utile pour comparer les agences entre elles et identifier les écarts systémiques. Elles ne suffisent pas à produire des intervalles de confiance étroits au niveau agence. Les décisions d'intervention prioritaire s'appuient sur le score composite ET sur le contexte terrain connu des responsables régionaux.

---

## 9. Calendrier des livrables

| Réf. | Fichier | Description | Semaine de livraison |
|---|---|---|---|
| A1 | `00_methodologie/note_methodologique.md` | Note méthodologique complète | S1 Avril 2025 |
| A2 | `00_methodologie/blueprint_questionnaire.md` | Plan détaillé du questionnaire | S1 Avril 2025 |
| A3 | `00_methodologie/cadre_echantillonnage.md` | Agences et rotation des scénarios | S1 Avril 2025 |
| B1 | `01_instrument/BCA_audit_qualite_v1.xlsx` | XLSForm complet | S2 Avril 2025 |
| B2 | `01_instrument/guide_enqueteur.md` | Manuel terrain | S2 Avril 2025 |
| C1 | `02_donnees/brutes/bca_audit_brut.csv` | Données brutes issues des visites | S4 Mai 2025 |
| C2 | `02_donnees/brutes/metadata_agences.csv` | Métadonnées agences | S4 Mai 2025 |
| C3 | `02_donnees/brutes/metadata_enqueteurs.csv` | Métadonnées enquêteurs | S4 Mai 2025 |
| C4 | `03_scripts/00_simulation.R` | Script de génération des données | S4 Mai 2025 |
| D1 | `03_scripts/01_nettoyage.R` | Nettoyage principal | S4 Mai 2025 |
| D2 | `03_scripts/02_detection_fraude.R` | Règles de détection fraude | S4 Mai 2025 |
| D3 | `03_scripts/03_derivation_variables.R` | Calculs et scores composites | S4 Mai 2025 |
| D4 | `03_scripts/04_rapport_qualite_donnees.R` | Rapport QC données | S4 Mai 2025 |
| D5 | `02_donnees/nettoyees/bca_audit_clean.csv` | Données nettoyées finales | S4 Mai 2025 |
| E1 | `03_scripts/05_analyse.R` | Analyse principale | S1 Juin 2025 |
| E2 | `04_rapport/rapport_audit_bca.Rmd` | Document R Markdown | S1 Juin 2025 |
| E3 | `04_rapport/rapport_audit_bca.pdf` | Rapport final compilé | S1 Juin 2025 |
| E4 | `04_rapport/scorecards/` | Fiches agences (24 PDF) | S1 Juin 2025 |
| E5 | `04_rapport/tableau_de_bord/` | Dashboard interactif | S1 Juin 2025 |
| F1 | `README.md` | Vue d'ensemble du projet | S1 Juin 2025 |
| F2 | `02_donnees/dictionnaire_variables.md` | Dictionnaire de données | S1 Juin 2025 |
| F3 | `DECISIONS.md` | Journal des décisions de conception | S1 Juin 2025 |

---

## 10. Références

Mystery Shopping Professionals Association (MSPA). (2023). *MSPA Global Standards for Mystery Shopping Research.* Brussels : MSPA Europe.

Banque de France / ACPR. (2024). *Recommandations sur la relation client en agence bancaire.* Paris : Autorité de Contrôle Prudentiel et de Résolution.

Wilson, A. M. (2001). Mystery shopping : Using deception to measure service performance. *Psychology & Marketing, 18*(7), 721--734.

Heskett, J. L., Jones, T. O., Loveman, G. W., Sasser, W. E. & Schlesinger, L. A. (1994). Putting the service-profit chain to work. *Harvard Business Review, 72*(2), 164--174.

Règlement (UE) 2016/679 du Parlement européen et du Conseil du 27 avril 2016 (RGPD).

---

*Unité Audit et Qualité de Service - BCA*  
*Version 1.0*  
*Confidentiel. Usage interne uniquement*