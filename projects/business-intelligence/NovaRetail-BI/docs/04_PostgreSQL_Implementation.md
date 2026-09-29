
# PostgreSQL Implementation

## 1. Objectif

Cette étape du projet NovaRetail BI consiste à transformer le modèle de données validé lors de la revue de conception en une base PostgreSQL exploitable pour l'analyse.

L'implémentation couvre :

- la création du modèle dimensionnel ;
- la définition des clés et contraintes d'intégrité ;
- la génération des données de référence et des données de vente ;
- la mise en place de contrôles de qualité ;
- la réalisation des premières analyses métier en SQL.

Les scripts associés sont regroupés dans le dossier `database/`.

---

## 2. Modèle implémenté

La base repose sur un modèle dimensionnel en étoile composé d'une table de faits centrale et de cinq dimensions.

### Table de faits

`fact_vente`

Une ligne de `fact_vente` représente une ligne produit au sein d'une transaction commerciale.

Une même transaction, identifiée par `code_vente`, peut donc contenir plusieurs lignes lorsqu'elle comporte plusieurs produits.

Exemple :

```text
Transaction V1001
├── 2 × Smartphone
└── 3 × Coque de protection
```

Cette transaction correspond à deux lignes dans `fact_vente`, et non à cinq transactions.

### Dimensions

La table de faits est reliée aux dimensions suivantes :

- `dim_date`
- `dim_produit`
- `dim_client`
- `dim_magasin`
- `dim_commercial`

Chaque dimension possède une clé technique utilisée pour les relations avec la table de faits.

Les dimensions métier disposent également de codes fonctionnels tels que :

- `code_produit`
- `code_client`
- `code_magasin`
- `code_commercial`

Ces codes permettent de conserver des identifiants métier lisibles indépendamment des clés techniques de la base.

---

## 3. Granularité de la table de faits

La granularité retenue est :

> Une ligne de `fact_vente` correspond à un produit vendu dans une transaction.

Cette granularité permet d'analyser les ventes selon plusieurs axes :

- produit ;
- type de produit ;
- client ;
- magasin ;
- commercial ;
- équipe commerciale ;
- date.

La clé primaire `id_ligne_vente` identifie techniquement chaque ligne de vente.

`code_vente` représente quant à lui l'identifiant métier de la transaction et peut apparaître sur plusieurs lignes.

Le nombre de transactions est donc calculé avec :

```sql
COUNT(DISTINCT code_vente)
```

---

## 4. Faits stockés

La table `fact_vente` conserve principalement des données atomiques :

- `quantite`
- `prix_unitaire`
- `cout_unitaire`
- `taux_remise`

Les indicateurs analytiques sont calculés à partir de ces valeurs plutôt que stockés directement dans la table.

### Chiffre d'affaires

```text
Chiffre d'affaires = quantité × prix unitaire
```

### Coût

```text
Coût = quantité × coût unitaire
```

### Marge brute

```text
Marge brute = chiffre d'affaires - coût
```

### Taux de marge brute utilisé dans le projet

```text
Taux de marge brute = marge brute / chiffre d'affaires × 100
```

Cette approche conserve la table de faits à un niveau atomique et permet de recalculer les indicateurs selon le contexte d'analyse.

---

## 5. Contraintes d'intégrité

Plusieurs contraintes ont été définies directement dans PostgreSQL afin de sécuriser les données dès leur insertion.

Elles permettent notamment de garantir :

- des quantités strictement positives ;
- des prix unitaires strictement positifs ;
- des coûts unitaires strictement positifs ;
- un taux de remise compris entre `0` et `1` ;
- un `code_vente` obligatoire et non vide ;
- l'intégrité référentielle entre la table de faits et les dimensions ;
- l'unicité des principaux codes métier.

Cette stratégie permet de traiter une partie de la qualité des données directement au niveau de la base.

---

## 6. Génération des données

Le jeu de données a été généré spécifiquement pour NovaRetail afin de disposer d'un environnement suffisamment riche pour les analyses SQL et le futur tableau de bord Power BI.

### Dimension Date

La dimension `dim_date` couvre la période :

```text
01/01/2023 → 31/12/2025
```

Elle contient **1 096 dates**.

Elle comprend notamment :

- l'année ;
- le mois ;
- le nom du mois ;
- le jour ;
- des informations permettant d'identifier les week-ends ;
- les jours fériés français utilisés dans le jeu de données.

### Dimensions métier

Le jeu de données contient :

```text
Produits       : 72
Clients        : 200
Magasins       : 10
Commerciaux    : 15
```

Les 15 commerciaux sont répartis entre plusieurs équipes commerciales.

### Données de vente

Le jeu de données contient :

```text
Transactions   : 10 000
Lignes de vente: 16 500
```

Une transaction peut contenir plusieurs produits, conformément à la granularité définie pour `fact_vente`.

La génération introduit également des variations contrôlées concernant notamment :

- le volume de transactions ;
- le nombre de lignes par transaction ;
- les quantités vendues ;
- les remises ;
- les prix ;
- les coûts ;
- la répartition temporelle des ventes ;
- la contribution des magasins et des commerciaux.

L'objectif n'est pas de reproduire parfaitement le comportement d'une entreprise réelle, mais de disposer d'un jeu de données cohérent permettant d'exercer des analyses BI réalistes.

---

## 7. Contrôles qualité

Les contrôles sont regroupés dans :

```text
database/quality_checks.sql
```

Ils permettent de vérifier notamment :

- les volumes de données ;
- l'unicité des identifiants ;
- les valeurs obligatoires ;
- l'intégrité référentielle ;
- la cohérence des codes métier ;
- les distributions des quantités ;
- les distributions des remises ;
- la répartition des transactions dans le temps ;
- la cohérence des prix et des remises ;
- la cohérence des coûts ;
- la cohérence de la dimension Date ;
- la cohérence des attributs calendaires ;
- la présence éventuelle de marges négatives ou nulles.

Les contrôles réalisés sur le jeu de données final n'ont pas identifié d'anomalie bloquante pour la poursuite du projet.

---

## 8. Analyse métier SQL

Une fois le modèle et la qualité des données validés, plusieurs requêtes ont été développées afin d'explorer les principaux indicateurs métier avant la construction du tableau de bord Power BI.

Elles sont regroupées dans :

```text
database/queries.sql
```

Les analyses couvrent :

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

La dernière analyse utilise notamment `LAG()` afin de comparer le chiffre d'affaires d'une année à celui de l'année précédente et de calculer la croissance Year-over-Year.

---

## 9. Organisation des scripts

Les scripts PostgreSQL sont organisés de la manière suivante :

```text
database/
├── schema.sql
├── seed.sql
├── quality_checks.sql
├── queries.sql
└── README.md
```

### `schema.sql`

Création des dimensions, de la table de faits, des clés et des contraintes.

### `seed.sql`

Génération et insertion des données utilisées pour le projet.

### `quality_checks.sql`

Contrôles permettant de vérifier la qualité et la cohérence du jeu de données.

### `queries.sql`

Requêtes d'analyse métier utilisées pour explorer les performances de NovaRetail.

---

## 10. Résultat de cette phase

À l'issue de cette étape, NovaRetail dispose :

- d'un modèle dimensionnel implémenté dans PostgreSQL ;
- d'une granularité clairement définie ;
- d'un jeu de données couvrant trois années ;
- de contraintes assurant l'intégrité des données ;
- de contrôles qualité reproductibles ;
- d'un ensemble de requêtes SQL permettant d'analyser les principaux KPI métier.

La base PostgreSQL constitue désormais la source de données pour la prochaine étape du projet : la modélisation et l'analyse dans Power BI.

---

## 11. Étape suivante

La prochaine phase consiste à connecter Power BI à PostgreSQL afin de :

- préparer les données avec Power Query ;
- reproduire et vérifier les relations du modèle en étoile ;
- créer les mesures analytiques avec DAX ;
- construire les différentes vues du tableau de bord ;
- restituer les principaux enseignements métier.

Cette étape sera documentée dans :

```text
docs/05_PowerBI_Model.md
```
