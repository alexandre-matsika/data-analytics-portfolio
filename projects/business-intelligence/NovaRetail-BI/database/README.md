# Database

Ce dossier contient les scripts SQL utilisés pour créer, alimenter, contrôler et analyser la base de données PostgreSQL du projet **NovaRetail BI**.

## Contenu

- **schema.sql** : création du modèle dimensionnel en étoile, des tables, des clés primaires et étrangères ainsi que des contraintes d'intégrité.
- **seed.sql** : génération et insertion du jeu de données fictif utilisé pour les analyses SQL et le tableau de bord Power BI.
- **quality_checks.sql** : contrôles de qualité permettant de vérifier les volumes, l'unicité des identifiants, les valeurs obligatoires, l'intégrité référentielle et la cohérence des données.
- **queries.sql** : requêtes d'analyse métier permettant d'étudier les principaux indicateurs de performance de NovaRetail.

## Modèle de données

La base repose sur un modèle dimensionnel en étoile composé de :

- `fact_vente`
- `dim_date`
- `dim_produit`
- `dim_client`
- `dim_magasin`
- `dim_commercial`

La granularité de la table `fact_vente` correspond à **un produit vendu dans une transaction**.

Une même transaction, identifiée par `code_vente`, peut donc être représentée par plusieurs lignes de vente.

## Jeu de données

Le jeu de données couvre la période **2023 à 2025** et contient notamment :

- 72 produits ;
- 200 clients ;
- 10 magasins ;
- 15 commerciaux ;
- 10 000 transactions ;
- 16 500 lignes de vente.

Les données ont été générées spécifiquement pour NovaRetail afin de disposer d'un environnement cohérent pour l'analyse SQL et la construction du tableau de bord Power BI.

## Analyses SQL

Le fichier `queries.sql` regroupe les analyses métier réalisées avant la construction du tableau de bord Power BI.

Elles couvrent notamment :

- les KPI commerciaux globaux ;
- l'évolution annuelle et mensuelle des ventes ;
- la performance des magasins ;
- la performance des produits et types de produits ;
- la performance des commerciaux et des équipes ;
- l'analyse croisée magasin / type de produit ;
- la comparaison entre semaine et week-end ;
- la croissance annuelle du chiffre d'affaires.

## Objectif

Cette base PostgreSQL constitue la source de données principale du projet **NovaRetail BI**.

Elle permet de centraliser un jeu de données structuré et contrôlé avant son exploitation dans Power BI.

La documentation détaillée de l'implémentation PostgreSQL est disponible dans :

[`docs/04_PostgreSQL_Implementation.md`](../docs/04_PostgreSQL_Implementation.md)
