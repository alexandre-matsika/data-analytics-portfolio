# SQL Cookbook

Ce dossier regroupe des exemples pratiques de requêtes SQL, organisés par niveau de complexité.

L’objectif est de démontrer les compétences SQL essentielles pour l’analyse de données, avec une progression logique allant des requêtes de base jusqu’aux techniques plus avancées.

---

## Structure du dossier

    cookbook/
    ├── README.md
    ├── basics/
    │   ├── 01_basic_select_filter.sql
    │   ├── 02_joins.sql
    │   ├── 03_group_by_aggregations.sql
    │   └── 04_case_when.sql
    ├── intermediate/
    │   ├── 05_ctes.sql
    │   ├── 07_subqueries.sql
    │   └── 08_time_series_analysis.sql
    │
    └── advanced/
        └── 06_window_functions.sql

## Organisation par niveau

### `basics/`

Cette section couvre les fondamentaux SQL nécessaires pour :

- sélectionner des données
- filtrer et trier des résultats
- relier plusieurs tables
- agréger des données
- appliquer une logique métier simple

Contenu actuel :

- `01_basic_select_filter.sql` : sélection, filtrage, tri et limitation
- `02_joins.sql` : jointures entre plusieurs tables
- `03_group_by_aggregations.sql` : agrégations avec `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`, `GROUP BY` et `HAVING`
- `04_case_when.sql` : logique conditionnelle avec `CASE WHEN` pour créer des catégories et segments métier

### `intermediate/`

Cette section introduit des requêtes plus structurées pour :

- améliorer la lisibilité
- organiser les calculs intermédiaires
- préparer des analyses plus complexes

Contenu actuel :

- `05_ctes.sql` : utilisation des CTE (`Common Table Expressions`) pour rendre les requêtes plus lisibles et maintenables
- `07_subqueries.sql` : utilisation de sous-requêtes scalaires, corrélées et imbriquées avec `EXISTS` et `NOT EXISTS` pour effectuer des comparaisons, filtrages et analyses dynamiques
- `08_time_series_analysis.sql`: analyse temporelle : `DATE_TRUNC`, `EXTRACT`, agrégations mensuelles, chiffre d'affaires cumulé, croissance Month-over-Month et moyenne mobile

### `advanced/`

Cette section accueille des techniques plus avancées pour :

- approfondir l’analyse
- effectuer des classements sans réduire la granularité des résultats
- réaliser des calculs cumulatifs et des comparaisons entre lignes
- améliorer la robustesse des requêtes

Contenu actuel :

- `06_window_functions.sql` : classement, comparaison entre lignes, calculs cumulatifs et analyses séquentielles avec les fonctions de fenêtre

Contenu prévu :

- contrôles qualité des données

---

## Objectifs du cookbook

Ce cookbook montre comment utiliser SQL pour :

- extraire des données
- filtrer et trier des informations
- relier plusieurs tables
- agréger des données
- introduire une logique métier dans les requêtes
- structurer les analyses SQL
- préparer des jeux de données exploitables

---

## Approche

Chaque fichier contient des requêtes commentées avec un objectif précis.

L’idée n’est pas seulement de montrer la syntaxe SQL, mais aussi la manière de transformer des données brutes en informations utiles pour répondre à des questions métier simples.

---

## Notions déjà couvertes

- `SELECT`
- `WHERE`
- `ORDER BY`
- `LIMIT`
- `JOIN`
- `GROUP BY`
- fonctions d’agrégation
- `HAVING`
- `CASE WHEN`
- `CTE`
- fonctions de fenêtre : `OVER`, `PARTITION BY`, `ROW_NUMBER`, `RANK`, `DENSE_RANK`, `LAG` et `LEAD`
- sous-requêtes : sous-requêtes scalaires, sous-requêtes dans `FROM`, sous-requêtes corrélées, `EXISTS` et `NOT EXISTS`

---

## Suite prévue

Les prochains fichiers qui viendront enrichir ce dossier sont notamment

- `09_kpi_calculations.sql`
- `10_data_quality_checks.sql`
