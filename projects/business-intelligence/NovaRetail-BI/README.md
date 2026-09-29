# NovaRetail BI

## Présentation

NovaRetail BI est un projet de Business Intelligence reproduisant un cas d'étude professionnel.

L'objectif est de concevoir une solution décisionnelle complète permettant à une direction commerciale de piloter son activité grâce à des indicateurs clés et à un tableau de bord Power BI.

Ce projet est développé dans le cadre de mon portfolio Data Analytics afin de mettre en pratique les différentes étapes d'un projet décisionnel, depuis l'analyse du besoin métier jusqu'à la réalisation du tableau de bord final.

---

## Contexte métier

**NovaRetail** est une entreprise fictive spécialisée dans la distribution de produits.

La direction commerciale souhaite disposer d'une solution décisionnelle permettant de suivre les performances de l'entreprise, d'analyser les ventes et de faciliter la prise de décision.

Le projet vise notamment à répondre à des questions telles que :

- Comment évoluent le chiffre d'affaires et la marge dans le temps ?
- Quels magasins génèrent le plus de chiffre d'affaires ?
- Quels produits et types de produits contribuent le plus aux ventes et à la marge ?
- Comment les performances diffèrent-elles entre les magasins ?
- Quels commerciaux et quelles équipes commerciales génèrent le plus d'activité ?
- Les performances diffèrent-elles entre la semaine et le week-end ?
- Comment évolue le chiffre d'affaires d'une année à l'autre ?

---

## Objectif du projet

L'objectif de ce projet est de reproduire les différentes étapes d'un projet BI complet, depuis l'analyse du besoin métier jusqu'à la réalisation d'un tableau de bord décisionnel.

Le projet couvre notamment :

- l'analyse du besoin métier ;
- la définition des indicateurs clés de performance (KPI) ;
- la conception d'un modèle dimensionnel en étoile ;
- l'implémentation du modèle dans PostgreSQL ;
- la génération d'un jeu de données cohérent pour l'analyse ;
- la mise en place de contrôles de qualité des données ;
- l'analyse métier avec SQL ;
- la préparation et la modélisation des données dans Power BI ;
- la création de mesures DAX ;
- la conception d'un tableau de bord interactif.

---

## Architecture des données

Le modèle repose sur une architecture dimensionnelle en étoile composée d'une table de faits centrale et de cinq dimensions.

### Table de faits

- `fact_vente`

### Dimensions

- `dim_date`
- `dim_produit`
- `dim_client`
- `dim_magasin`
- `dim_commercial`

La granularité de `fact_vente` correspond à **un produit vendu dans une transaction**.

Une transaction identifiée par `code_vente` peut donc comporter plusieurs lignes de vente.

Les principaux faits stockés sont :

- la quantité vendue ;
- le prix unitaire ;
- le coût unitaire ;
- le taux de remise.

Les indicateurs analytiques tels que le chiffre d'affaires et la marge sont calculés à partir de ces données atomiques.

---

## Implémentation PostgreSQL

La base PostgreSQL contient :

- 72 produits ;
- 200 clients ;
- 10 magasins ;
- 15 commerciaux ;
- 10 000 transactions ;
- 16 500 lignes de vente ;
- une dimension Date couvrant la période 2023 à 2025.

Des contraintes d'intégrité et des contrôles qualité permettent de vérifier la cohérence du jeu de données avant son exploitation analytique.

La documentation détaillée de cette phase est disponible dans :

`docs/04_PostgreSQL_Implementation.md`

---

## Analyses SQL

Les analyses métier sont regroupées dans `database/queries.sql`.

Elles couvrent :

1. la performance commerciale globale ;
2. la performance annuelle ;
3. l'évolution mensuelle des ventes ;
4. la performance des magasins ;
5. la performance des produits ;
6. la performance par type de produit ;
7. la performance des commerciaux ;
8. la performance des équipes commerciales ;
9. la performance par magasin et type de produit ;
10. la comparaison entre semaine et week-end ;
11. la croissance annuelle du chiffre d'affaires.

Les contrôles de qualité sont regroupés dans `database/quality_checks.sql`.

---

## Structure du projet

```text
NovaRetail-BI/
│
├── README.md
│
├── docs/
│   ├── 01_Kickoff.md
│   ├── 02_Business_Requirements.md
│   ├── 03_Design_Review.md
│   ├── 04_PostgreSQL_Implementation.md
│   └── images/
│       ├── data_model_v1.png
│       ├── data_model_v2.png
│       └── data_model_v3.png
│
├── database/
│   ├── schema.sql
│   ├── seed.sql
│   ├── quality_checks.sql
│   ├── queries.sql
│   └── README.md
│
└── powerbi/
```

Les prochaines phases du projet ajouteront notamment la documentation du modèle Power BI et de la conception du tableau de bord.

---

## Technologies utilisées

- PostgreSQL
- SQL
- Power BI
- Power Query
- DAX
- Git

---

## État d'avancement

| Étape                            | Statut |
| --------------------------------- | ------ |
| Kick-off                          | ✅     |
| Analyse du besoin métier         | ✅     |
| Définition des KPI               | ✅     |
| Conception du modèle de données | ✅     |
| Revue de conception               | ✅     |
| Implémentation PostgreSQL        | ✅     |
| Génération des données         | ✅     |
| Contrôles qualité des données  | ✅     |
| Analyse SQL                       | ✅     |
| Modélisation Power BI            | ⏳     |
| Mesures DAX                       | ⏳     |
| Tableau de bord Power BI          | ⏳     |

---

## Documentation

La documentation du projet suit les différentes étapes de sa réalisation :

- `docs/01_Kickoff.md` — cadrage initial du projet ;
- `docs/02_Business_Requirements.md` — besoins métier et KPI ;
- `docs/03_Design_Review.md` — évolution et validation du modèle de données ;
- `docs/04_PostgreSQL_Implementation.md` — implémentation PostgreSQL, génération des données, contrôles qualité et analyses SQL.

Les prochaines étapes seront documentées dans :

- `docs/05_PowerBI_Model.md`
- `docs/06_Dashboard_Design.md`

---

## À propos de ce projet

**NovaRetail BI** est un cas d'étude conçu pour reproduire le cycle de vie complet d'un projet Business Intelligence, depuis la compréhension du besoin métier jusqu'à la réalisation d'un tableau de bord décisionnel.

L'ensemble des étapes du projet est documenté afin de présenter non seulement le résultat final, mais également la démarche de conception, de modélisation, de contrôle des données et d'analyse mise en œuvre tout au long du projet.
