# Power BI Data Model

## 1. Objective

The objective of this stage was to transform the PostgreSQL analytical model into a Power BI semantic model suitable for business analysis and dashboard development.

The main goals were to:

- connect Power BI to the PostgreSQL database;
- preserve the star schema designed during the database implementation;
- prepare the imported tables for reporting;
- configure relationships and the date dimension correctly;
- centralize business calculations in reusable DAX measures;
- support dynamic filtering and time intelligence across the report.

The PostgreSQL database had already been structured, populated, and validated before the Power BI integration. Therefore, Power BI was primarily used as the semantic modeling, calculation, and visualization layer.

## 2. PostgreSQL Connection

Power BI Desktop was connected to the NovaRetail PostgreSQL database using **Import mode**.

The following analytical tables were imported:

- `fact_vente`
- `dim_produit`
- `dim_client`
- `dim_magasin`
- `dim_commercial`
- `dim_date`

The relational model and data quality controls had already been implemented in PostgreSQL. The objective was therefore not to rebuild the data preparation logic in Power BI, but to reuse the validated analytical model as the foundation of the report.

## 3. Power Query Preparation

Power Query was used as a lightweight preparation layer before loading the data into the Power BI semantic model.

The main preparation steps were:

- renaming the imported `public.*` queries to clear analytical table names;
- verifying data types for identifiers, dates, text fields, quantities, prices, costs, and discount rates;
- removing automatically generated navigation columns;
- preserving the existing fact and dimension structure from PostgreSQL.

No unnecessary business transformations were duplicated in Power Query because the source database had already been designed and validated for analytical use.

This separation of responsibilities keeps the architecture clear:

**PostgreSQL → data structure, generation, integrity, and quality controls**
**Power BI → semantic model, DAX calculations, filtering, and visualization**

## 4. Star Schema

The Power BI semantic model follows the same star schema implemented in PostgreSQL.

The central fact table is `fact_vente`, surrounded by five dimensions:

- `dim_produit`
- `dim_client`
- `dim_magasin`
- `dim_commercial`
- `dim_date`

### Fact Table Grain

The grain of `fact_vente` is:

> **One row represents one product line within a sales transaction.**

A single transaction can therefore contain several rows when multiple products are purchased.

For example, a transaction containing two smartphones and three accessories is represented by two fact rows:

- one smartphone line with a quantity of 2;
- one accessory line with a quantity of 3.

The transaction identifier `code_vente` can therefore appear on multiple rows, while `id_ligne_vente` uniquely identifies each sales line.

This distinction is important for the analytical model:

- sales quantities are aggregated from `quantite`;
- revenue and cost are calculated at sales-line level;
- transactions are counted using the distinct `code_vente` values.

### Relationships

Five active many-to-one relationships connect the fact table to the dimensions:

| Fact table key                | Dimension key                     | Cardinality           |
| ----------------------------- | --------------------------------- | --------------------- |
| `fact_vente[id_produit]`    | `dim_produit[id_produit]`       | Many-to-one (`*:1`) |
| `fact_vente[id_client]`     | `dim_client[id_client]`         | Many-to-one (`*:1`) |
| `fact_vente[id_magasin]`    | `dim_magasin[id_magasin]`       | Many-to-one (`*:1`) |
| `fact_vente[id_commercial]` | `dim_commercial[id_commercial]` | Many-to-one (`*:1`) |
| `fact_vente[id_date]`       | `dim_date[id_date]`             | Many-to-one (`*:1`) |

All relationships are active and use **single-direction filtering from the dimension tables to the fact table**.

This allows report filters and slicers to propagate naturally from dimensions such as date, store, product, or salesperson to the sales data while keeping the model simple and predictable.

No direct relationships were created between dimension tables.

### Modeling Principle

The model separates descriptive business attributes from measurable sales events:

- dimensions provide the analytical context;
- `fact_vente` stores the atomic sales facts;
- DAX measures perform aggregations according to the current filter context.

This structure supports reusable measures and consistent analysis across products, stores, customers, salespeople, and time.

## 5. Date Dimension

A dedicated `dim_date` table is used to support consistent time-based analysis across the report.

The dimension covers the complete period from **January 1, 2023 to December 31, 2025**, with one row per calendar date.

It contains attributes such as:

- date;
- year;
- quarter;
- month number and month name;
- week number;
- day of the month;
- day of the week and weekday name;
- weekend indicator;
- public holiday indicator and holiday name.

### Power BI Configuration

In Power BI, `dim_date` was explicitly marked as the model's **Date table**, using the `date` column as the reference date field.

This configuration provides a reliable calendar dimension for filtering, chronological analysis, and DAX time-intelligence calculations.

To ensure correct chronological ordering in report visuals:

- `nom_mois` is sorted by the numeric `mois` column;
- `nom_jour` is sorted by the numeric `jour_semaine` column.

A calculated column was also created for monthly analysis:

```DAX
Annee_Mois =
FORMAT(
    dim_date[date];
    "yyyy-MM"
)
```

### Role in the Semantic Model

`dim_date` is connected to `fact_vente` through the active relationship:

`dim_date[id_date]` → `fact_vente[id_date]`

This dimension provides the common time context used by the report for:

- annual performance analysis;
- monthly revenue trends;
- year-over-year comparisons;
- weekday versus weekend analysis;
- day-of-week analysis;
- date-based filtering and slicers.

Using a dedicated date dimension rather than deriving time attributes directly from the fact table keeps temporal logic centralized and reusable throughout the model.

## 6. DAX Measures

Business calculations were centralized in a dedicated `_Mesures` table.

This approach separates analytical calculations from the physical data tables and makes the semantic model easier to maintain and navigate.

### Core Sales Measures

The main sales KPIs are calculated from the atomic facts stored in `fact_vente`.

#### Revenue

```DAX
Chiffre d'affaires =
SUMX(
    fact_vente;
    fact_vente[quantite] * fact_vente[prix_unitaire]
)
```

Revenue is calculated at sales-line level by multiplying the quantity sold by the historical unit selling price.

#### Total Cost

```DAX
Coût total =
SUMX(
    fact_vente;
    fact_vente[quantite] * fact_vente[cout_unitaire]
)
```

The total cost follows the same line-level calculation principle using the historical unit cost.

#### Gross Margin

```DAX
Marge brute =
[Chiffre d'affaires] - [Coût total]
```

#### Gross Margin Rate

```DAX
Taux de marge brute =
DIVIDE(
    [Marge brute];
    [Chiffre d'affaires];
    0
)
```

In this project, the gross margin rate is defined as gross margin divided by revenue and is used consistently throughout the report.

### Sales Volume Measures

```DAX
Quantité vendue =
SUM(fact_vente[quantite])
```

The number of transactions requires a distinct count because one transaction may contain several product lines:

```DAX
Nombre de transactions =
DISTINCTCOUNT(fact_vente[code_vente])
```

Using `COUNTROWS(fact_vente)` would count sales lines rather than business transactions.

### Additional Analytical Measures

Additional measures were created to support specific dashboard analyses, including:

- `Montant des remises`;
- `Taux de remise effectif`;
- `CA moyen par jour`;
- `CA moyen par commercial`.

For example, the average revenue per salesperson is calculated using an iterator:

```DAX
CA moyen par commercial =
AVERAGEX(
    VALUES(dim_commercial[id_commercial]);
    [Chiffre d'affaires]
)
```

`VALUES` returns the distinct salespeople available in the current filter context. `AVERAGEX` then evaluates revenue for each salesperson and calculates the average of those results.

As a result, the measure remains dynamic when filters such as year, team, or salesperson are applied.

### Measure Design Principle

Measures were preferred over calculated columns whenever the result depends on the report's filter context.

This allows the same business logic to be reused across KPI cards, tables, charts, slicers, and analytical views while automatically responding to the active report context.

## 7. Time Intelligence

The dedicated `dim_date` table enables time-intelligence calculations based on a continuous and properly configured calendar.

Two measures were created to analyze year-over-year revenue performance.

### Previous-Year Revenue

```DAX
CA année précédente =
CALCULATE(
    [Chiffre d'affaires];
    SAMEPERIODLASTYEAR(dim_date[date])
)
```

`SAMEPERIODLASTYEAR` shifts the current date context back by one year, while `CALCULATE` evaluates the revenue measure within that modified context.

For example:

- when the report is filtered on 2024, the measure returns 2023 revenue;
- when the report is filtered on 2025, the measure returns 2024 revenue;
- for 2023, the measure returns no previous-year value because the model contains no 2022 sales data.

### Year-over-Year Revenue Growth

```DAX
Croissance YoY =
DIVIDE(
    [Chiffre d'affaires] - [CA année précédente];
    [CA année précédente]
)
```

The measure compares current-period revenue with the equivalent period from the previous year.

The annual results are:

| Year |        Revenue | Previous-Year Revenue | YoY Growth |
| ---- | -------------: | --------------------: | ---------: |
| 2023 | €1,152,026.37 |                    — |         — |
| 2024 | €1,467,733.13 |        €1,152,026.37 |     27.40% |
| 2025 | €1,630,072.05 |        €1,467,733.13 |     11.06% |

These results were consistent with the year-over-year analysis previously performed directly in PostgreSQL.

### Filter Context

The time-intelligence measures respond dynamically to the active date context.

When a specific year is selected, the YoY measure compares that year with the corresponding previous year. The same calculation logic can also operate within more detailed date contexts because it relies on the calendar dimension rather than on hard-coded year values.

The YoY KPI is therefore most meaningful when the report provides a clearly defined time context.

This illustrates an important semantic-modeling principle: time comparisons are implemented as reusable measures driven by the date dimension and filter context, rather than as static calculations tied to individual visuals.

## 8. Modeling Choices

Several modeling decisions were made to keep the Power BI semantic model simple, consistent, and maintainable.

### Import Mode

The PostgreSQL tables were loaded into Power BI using **Import mode**.

For the scope and volume of the NovaRetail dataset, this approach provides fast interactive analysis while keeping PostgreSQL as the structured source of analytical data.

### Star Schema Preservation

The star schema designed in PostgreSQL was preserved in Power BI rather than being flattened into a single reporting table.

This maintains a clear separation between:

- sales events stored in `fact_vente`;
- descriptive attributes stored in dimension tables;
- analytical calculations implemented as DAX measures.

The same modeling structure is therefore maintained from the database layer to the semantic layer.

### Single-Direction Relationships

Relationships use single-direction filtering from dimensions to the fact table.

This keeps filter propagation predictable and avoids unnecessary ambiguity that could be introduced by bidirectional relationships.

### Database and Power BI Responsibilities

Data structure, referential integrity, business consistency, and data quality controls were handled upstream in PostgreSQL.

Power Query therefore remained intentionally lightweight, while Power BI focused on:

- semantic modeling;
- reusable business measures;
- filter context;
- time intelligence;
- interactive analysis and visualization.

This avoids duplicating transformation and validation logic across multiple layers.

### Measures Over Calculated Columns

DAX measures were preferred when calculations needed to respond dynamically to report filters.

Measures such as revenue, gross margin, transaction count, and year-over-year growth are therefore evaluated according to the current filter context rather than stored as static values.

Calculated columns were used only when a row-level attribute was required for reporting purposes, such as the `Annee_Mois` label in the date dimension.

### Dedicated Measures Table

Business measures were centralized in a dedicated `_Mesures` table.

This does not change the underlying calculation logic, but improves model organization by providing a single location for the main analytical measures used throughout the report.

### Reusable Semantic Layer

The model was designed so that business logic is defined once and reused across multiple report pages and visual types.

For example, `[Chiffre d'affaires]` is the same measure whether it is analyzed by:

- year;
- month;
- store;
- product;
- product category;
- salesperson;
- sales team.

The active dimension filters determine the analytical context without requiring separate versions of the revenue calculation.

This approach improves consistency between visuals and makes the model easier to maintain and extend.

## 9. Result

The Power BI implementation resulted in a structured semantic model built directly on top of the validated PostgreSQL analytical database.

The final model provides:

- a clear star schema with one fact table and five dimensions;
- active many-to-one relationships with controlled filter propagation;
- a dedicated and properly configured date dimension;
- centralized and reusable DAX measures;
- dynamic calculations driven by filter context;
- year-over-year time intelligence;
- consistent analytical results between PostgreSQL and Power BI.

The model supports analysis across the main NovaRetail business dimensions, including time, products, stores, customers, salespeople, and sales teams.

By separating data preparation and quality controls in PostgreSQL from semantic calculations and interactive analysis in Power BI, the project maintains a clear division of responsibilities between the database and reporting layers.

This semantic model provides the foundation for the final NovaRetail dashboard, whose report structure, visual design, navigation, interactions, and analytical choices are documented in `06_Dashboard_Design.md`.
