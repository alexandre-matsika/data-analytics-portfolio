
# NovaRetail BI — Data Dictionary

## 1. Objective

This document describes the data structure used in the NovaRetail BI project.

It provides a reference for:

- tables and their analytical roles,
- columns and data types,
- primary and foreign keys,
- nullable and mandatory attributes,
- integrity constraints,
- business rules,
- the grain of the sales fact table.

The PostgreSQL data warehouse follows a star schema composed of five dimensions and one fact table.

---

## 2. Data Model Overview

The model contains the following tables:

| Table              | Type      | Description                                     |
| ------------------ | --------- | ----------------------------------------------- |
| `dim_produit`    | Dimension | Product master data                             |
| `dim_client`     | Dimension | Customer demographic and geographic attributes  |
| `dim_magasin`    | Dimension | Store characteristics and geographic attributes |
| `dim_commercial` | Dimension | Sales representative and team information       |
| `dim_date`       | Dimension | Calendar and time-analysis attributes           |
| `fact_vente`     | Fact      | Sales transaction lines                         |

### Fact Table Grain

The grain of `fact_vente` is:

> **One row represents one product line within a sales transaction.**

A transaction identified by `code_vente` can therefore appear on several rows when multiple products are purchased in the same transaction.

As a consequence, transaction counts must be based on the distinct number of `code_vente` values rather than the number of rows in `fact_vente`.

---

## 3. `dim_produit`

### Purpose

Stores product master data used to analyse sales by product, category, sub-category, brand, supplier and other product characteristics.

| Column                   | Data Type     | Nullable | Description / Business Rule                                        |
| ------------------------ | ------------- | -------: | ------------------------------------------------------------------ |
| `id_produit`           | INTEGER       |       No | Surrogate primary key generated automatically                      |
| `code_produit`         | VARCHAR(50)   |       No | Unique business identifier for the product; cannot be empty        |
| `nom_produit`          | VARCHAR(100)  |       No | Product name; cannot be empty                                      |
| `categorie`            | VARCHAR(100)  |       No | Product category; cannot be empty                                  |
| `sous_categorie`       | VARCHAR(100)  |       No | Product sub-category; cannot be empty                              |
| `marque`               | VARCHAR(100)  |       No | Product brand; cannot be empty                                     |
| `fournisseur`          | VARCHAR(100)  |       No | Product supplier; cannot be empty                                  |
| `couleur`              | VARCHAR(100)  |      Yes | Product colour when applicable                                     |
| `taille`               | VARCHAR(20)   |      Yes | Product size when applicable                                       |
| `poids_kg`             | NUMERIC(10,3) |      Yes | Product weight in kilograms; must be greater than 0 when populated |
| `capacite_stockage_go` | INTEGER       |      Yes | Storage capacity in GB; must be greater than 0 when populated      |
| `gamme`                | VARCHAR(50)   |      Yes | Product range or market positioning                                |
| `saison`               | VARCHAR(100)  |      Yes | Associated season when applicable                                  |
| `prix_catalogue`       | NUMERIC(10,2) |       No | Catalogue price; must be greater than 0                            |
| `modele`               | VARCHAR(100)  |      Yes | Product model when applicable                                      |
| `type_produit`         | VARCHAR(100)  |       No | Product type; cannot be empty                                      |

### Key Constraints

- Primary key: `id_produit`
- Unique business key: `code_produit`
- `prix_catalogue > 0`
- `poids_kg > 0` when populated
- `capacite_stockage_go > 0` when populated

---

## 4. `dim_client`

### Purpose

Stores customer attributes used for demographic and geographic sales analysis.

| Column               | Data Type    | Nullable | Description / Business Rule                                  |
| -------------------- | ------------ | -------: | ------------------------------------------------------------ |
| `id_client`        | INTEGER      |       No | Surrogate primary key generated automatically                |
| `code_client`      | VARCHAR(50)  |       No | Unique business identifier for the customer; cannot be empty |
| `nom_client`       | VARCHAR(100) |       No | Customer last name; cannot be empty                          |
| `prenom_client`    | VARCHAR(100) |       No | Customer first name; cannot be empty                         |
| `sexe`             | CHAR(1)      |       No | Customer sex; accepted values are`F` or `M`              |
| `date_inscription` | DATE         |       No | Customer registration date                                   |
| `date_naissance`   | DATE         |       No | Customer date of birth; must precede registration date       |
| `profession`       | VARCHAR(100) |      Yes | Customer profession                                          |
| `ville`            | VARCHAR(100) |      Yes | Customer city                                                |
| `departement`      | VARCHAR(100) |      Yes | Customer department                                          |
| `region`           | VARCHAR(100) |      Yes | Customer region                                              |

### Key Constraints

- Primary key: `id_client`
- Unique business key: `code_client`
- `sexe` must be `F` or `M`
- `date_naissance < date_inscription`

---

## 5. `dim_magasin`

### Purpose

Stores store attributes used to analyse performance by store, store type, geographic location and sales area.

| Column             | Data Type     | Nullable | Description / Business Rule                                                |
| ------------------ | ------------- | -------: | -------------------------------------------------------------------------- |
| `id_magasin`     | INTEGER       |       No | Surrogate primary key generated automatically                              |
| `code_magasin`   | VARCHAR(50)   |       No | Unique business identifier for the store; cannot be empty                  |
| `nom_magasin`    | VARCHAR(100)  |       No | Store name; cannot be empty                                                |
| `type_magasin`   | VARCHAR(50)   |       No | Store type                                                                 |
| `date_ouverture` | DATE          |       No | Store opening date                                                         |
| `surface_m2`     | NUMERIC(10,2) |      Yes | Store surface area in square metres; must be greater than 0 when populated |
| `ville`          | VARCHAR(100)  |      Yes | Store city; cannot be empty when populated                                 |
| `departement`    | VARCHAR(100)  |      Yes | Store department; cannot be empty when populated                           |
| `region`         | VARCHAR(100)  |      Yes | Store region; cannot be empty when populated                               |

### Accepted Store Types

`type_magasin` accepts:

- `Boutique`
- `Centre commercial`
- `Entrepôt`

### Key Constraints

- Primary key: `id_magasin`
- Unique business key: `code_magasin`
- `surface_m2 > 0` when populated

---

## 6. `dim_commercial`

### Purpose

Stores sales representative attributes used to analyse commercial performance by salesperson, team and manager.

| Column                | Data Type    | Nullable | Description / Business Rule                                     |
| --------------------- | ------------ | -------: | --------------------------------------------------------------- |
| `id_commercial`     | INTEGER      |       No | Surrogate primary key generated automatically                   |
| `code_commercial`   | VARCHAR(50)  |       No | Unique business identifier for the salesperson; cannot be empty |
| `nom_commercial`    | VARCHAR(100) |       No | Salesperson last name; cannot be empty                          |
| `prenom_commercial` | VARCHAR(100) |       No | Salesperson first name; cannot be empty                         |
| `equipe`            | VARCHAR(100) |       No | Sales team; cannot be empty                                     |
| `date_recrutement`  | DATE         |       No | Recruitment date                                                |
| `manager`           | VARCHAR(100) |       No | Manager name; cannot be empty                                   |

### Key Constraints

- Primary key: `id_commercial`
- Unique business key: `code_commercial`
- Mandatory textual attributes cannot contain empty strings

---

## 7. `dim_date`

### Purpose

Provides the calendar structure used for time-based analysis.

Calendar attributes are derived from the date during data loading, while public holiday attributes are enriched from a reference dataset.

| Column             | Data Type    | Nullable | Description / Business Rule                    |
| ------------------ | ------------ | -------: | ---------------------------------------------- |
| `id_date`        | INTEGER      |       No | Surrogate primary key generated automatically  |
| `date`           | DATE         |       No | Unique calendar date                           |
| `annee`          | INTEGER      |       No | Calendar year; must be greater than 0          |
| `trimestre`      | INTEGER      |       No | Calendar quarter from 1 to 4                   |
| `mois`           | INTEGER      |       No | Month number from 1 to 12                      |
| `nom_mois`       | VARCHAR(20)  |       No | French month name                              |
| `semaine`        | INTEGER      |       No | Week number from 1 to 53                       |
| `jour`           | INTEGER      |       No | Day of month from 1 to 31                      |
| `jour_semaine`   | INTEGER      |       No | Day-of-week number from 1 to 7                 |
| `nom_jour`       | VARCHAR(10)  |       No | French weekday name                            |
| `est_weekend`    | BOOLEAN      |       No | Indicates whether the date falls on a weekend  |
| `est_jour_ferie` | BOOLEAN      |       No | Indicates whether the date is a public holiday |
| `nom_jour_ferie` | VARCHAR(100) |      Yes | Public holiday name when applicable            |

### Key Constraints

- Primary key: `id_date`
- Unique business key: `date`
- `trimestre` between 1 and 4
- `mois` between 1 and 12
- `semaine` between 1 and 53
- `jour` between 1 and 31
- `jour_semaine` between 1 and 7
- Month and weekday names are restricted to their accepted French values

---

## 8. `fact_vente`

### Purpose

Stores sales transaction lines and provides the atomic measures used to calculate revenue, cost, gross margin, quantities and discounts.

### Grain

> **One row = one product line within a sales transaction.**

`code_vente` identifies the business transaction. It can therefore appear on multiple rows when a transaction contains several products.

| Column             | Data Type     | Nullable | Description / Business Rule                                                          |
| ------------------ | ------------- | -------: | ------------------------------------------------------------------------------------ |
| `id_ligne_vente` | INTEGER       |       No | Surrogate primary key identifying the sales line                                     |
| `code_vente`     | VARCHAR(50)   |       No | Business transaction identifier; cannot be empty and may repeat across product lines |
| `id_produit`     | INTEGER       |       No | Foreign key referencing`dim_produit`                                               |
| `id_client`      | INTEGER       |       No | Foreign key referencing`dim_client`                                                |
| `id_magasin`     | INTEGER       |       No | Foreign key referencing`dim_magasin`                                               |
| `id_commercial`  | INTEGER       |       No | Foreign key referencing`dim_commercial`                                            |
| `id_date`        | INTEGER       |       No | Foreign key referencing`dim_date`                                                  |
| `quantite`       | INTEGER       |       No | Quantity sold on the transaction line; must be greater than 0                        |
| `prix_unitaire`  | NUMERIC(10,2) |       No | Unit selling price recorded for the transaction line; must be greater than 0         |
| `cout_unitaire`  | NUMERIC(10,2) |       No | Unit cost recorded for the transaction line; must be greater than 0                  |
| `taux_remise`    | NUMERIC(5,2)  |       No | Discount rate applied to the catalogue price; value between 0 and 1                  |

### Foreign Keys

| Fact Column       | Referenced Table   | Referenced Column |
| ----------------- | ------------------ | ----------------- |
| `id_produit`    | `dim_produit`    | `id_produit`    |
| `id_client`     | `dim_client`     | `id_client`     |
| `id_magasin`    | `dim_magasin`    | `id_magasin`    |
| `id_commercial` | `dim_commercial` | `id_commercial` |
| `id_date`       | `dim_date`       | `id_date`       |

### Atomic Measures

The fact table stores the following atomic measures:

- `quantite`
- `prix_unitaire`
- `cout_unitaire`
- `taux_remise`

Revenue, cost and gross margin are derived from these transaction-level values.

For example:

```text
Revenue = Quantity × Unit Price

Cost = Quantity × Unit Cost

Gross Margin = Revenue − Cost
```

The transaction count must use the distinct number of `code_vente` values because a single transaction may contain several product lines.

---

## 9. Relationships

The star schema uses one-to-many relationships from each dimension to the fact table:

```text
dim_produit     1 ──── * fact_vente
dim_client      1 ──── * fact_vente
dim_magasin     1 ──── * fact_vente
dim_commercial  1 ──── * fact_vente
dim_date        1 ──── * fact_vente
```

Each sales line is therefore associated with exactly one product, customer, store, salesperson and date.

---

## 10. Data Integrity Rules

The PostgreSQL schema implements several categories of integrity controls.

### Entity Integrity

Each table uses an automatically generated surrogate primary key.

Business identifiers such as product, customer, store and salesperson codes are also constrained to be unique.

### Referential Integrity

Foreign keys in `fact_vente` ensure that every sales line references existing dimension records.

### Domain Integrity

`CHECK` constraints enforce valid values for attributes such as:

- positive quantities,
- positive prices and costs,
- discount rates between 0 and 1,
- valid calendar ranges,
- accepted store types,
- accepted month and weekday names,
- valid customer sex values.

### Text Quality

Mandatory business identifiers and several mandatory descriptive attributes cannot contain empty strings.

---

## 11. Analytical Considerations

Several modeling choices are important when interpreting the data:

- `fact_vente` is stored at **sales-line grain**, not transaction grain.
- `code_vente` is therefore not unique in the fact table.
- Transaction counts require a distinct count of `code_vente`.
- `prix_unitaire` and `cout_unitaire` are stored in the fact table because they represent values associated with the historical sales transaction.
- `prix_catalogue` belongs to the product dimension and represents the product reference price.
- `taux_remise` represents the discount applied at sales-line level.
- Calendar attributes are centralized in `dim_date` to support consistent time analysis.

---

## 12. Summary

The NovaRetail data warehouse uses a star schema designed to support retail sales analysis while maintaining a clear analytical grain and explicit integrity rules.

The data dictionary complements the physical PostgreSQL schema by documenting not only the technical structure of the database, but also the analytical meaning of the fields used throughout the BI solution.
