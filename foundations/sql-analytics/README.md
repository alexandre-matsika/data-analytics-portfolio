# SQL Analytics

Ce dossier présente mes fondamentaux en SQL appliqué à l’analyse de données.

L’objectif est de démontrer :

- ma maîtrise des requêtes SQL essentielles pour un poste de Data Analyst
- ma capacité à structurer des analyses de données de manière lisible et maintenable
- mon aptitude à transformer des données brutes en informations exploitables pour répondre à des questions métier

---

## Structure du dossier

## Structure du dossier

```text
sql-analytics/
├── README.md
├── datasets/
│   ├── README.md
│   ├── schema.sql
│   └── seed.sql
├── cookbook/
│   ├── README.md
│   ├── basics/
│   │   ├── 01_basic_select_filter.sql
│   │   ├── 02_joins.sql
│   │   ├── 03_group_by_aggregations.sql
│   │   └── 04_case_when.sql
│   ├── intermediate/
│   │   ├── 05_ctes.sql
│   │   ├── 07_subqueries.sql
│   │   ├── 08_time_series_analysis.sql
│   │   └── 09_kpi_calculations.sql
│   └── advanced/
│       └── 06_window_functions.sql
└── business-cases/
```

# Description des sections

- `datasets/` : contient le schéma SQL et les données de démonstration utilisées dans cette section
- `cookbook/` : regroupe les requêtes SQL classées par niveau de difficulté
- `business-cases/` : contiendra des mini cas pratiques orientés métier
- `README.md` : présente l’objectif, la structure et le positionnement de cette section

---

## Compétences SQL démontrées

Cette section couvre actuellement les compétences suivantes :

- sélection, filtrage et tri de données
- jointures entre plusieurs tables
- agrégations et groupements
- logique conditionnelle avec `CASE WHEN`
- CTE (`Common Table Expressions`)
- sous-requêtes
- fonctions de fenêtre
- analyse temporelle
- calcul de KPI métier

## Dataset utilisé

Le dataset de démonstration simule un environnement e-commerce simple avec des tables de :

- clients
- commandes
- produits
- catégories
- paiements

Ce choix a une vocation pédagogique : il permet d’illustrer de manière claire et progressive les fondamentaux SQL utilisés en analyse de données.

---

## Positionnement de cette section

Cette section est dédiée aux fondations techniques SQL.

Le dataset e-commerce est utilisé ici comme support d’apprentissage et de démonstration des concepts analytiques.
Les projets métier plus avancés, spécialisés et orientés secteur seront développés dans les autres sections du portfolio.

---

## État actuel

À ce stade, cette section contient :

- un dataset e-commerce de démonstration
- un cookbook structuré par niveaux
- des exercices couvrant les fondamentaux SQL, les CTE, les sous-requêtes et les fonctions de fenêtre
- des analyses temporelles et des calculs de KPI métier
- une progression vers des contrôles qualité et des cas métier plus avancés

## Exemples de questions traitées

Voici quelques exemples de questions auxquelles les requêtes de cette section permettent de répondre :

- Quels sont les clients les plus actifs ?
- Quel chiffre d’affaires est généré par mois ou par catégorie ?
- Comment évolue le chiffre d’affaires dans le temps ?
- Quel est le panier moyen des commandes finalisées ?
- Quelle proportion des clients effectue plusieurs commandes ?
- Quels produits génèrent les marges brutes les plus élevées ?
- Quelle est la contribution de chaque catégorie au chiffre d’affaires ?
- Comment utiliser des CTE, sous-requêtes et fonctions de fenêtre pour structurer des analyses plus complexes ?

## Outils

- PostgreSQL
- SQL standard
- Git / GitHub

---

## Objectif analytique

Au-delà de la syntaxe SQL, cette section montre comment :

- transformer des données brutes en indicateurs de performance
- structurer une analyse de manière lisible et réutilisable
- préparer des bases solides pour des projets analytiques plus complets

Elle constitue une étape fondatrice avant le développement de projets plus avancés dans les sections `projects/analytics/`, `projects/bi/`, `projects/ml/` et `projects/end-to-end/`.

## Suite prévue

Les prochaines étapes de cette section incluent notamment :

- `10_data_quality_checks.sql`
- `11_advanced_analytics.sql`
- la création de mini cas métier dans `business-cases/`
- l’ajout d’un dictionnaire de données dans `datasets/`
