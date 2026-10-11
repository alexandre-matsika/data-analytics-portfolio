# Power BI Dashboard Design

## 1. Objective

The objective of the NovaRetail Power BI dashboard is to transform the semantic model into an interactive decision-support report covering the main areas of sales performance.

The dashboard was designed to allow users to:

- monitor the main sales KPIs;
- analyze revenue and profitability over time;
- compare product and store performance;
- evaluate salesperson and sales team performance;
- identify temporal sales patterns;
- filter the analysis dynamically according to the business context.

Rather than concentrating all information on a single page, the report was divided into several analytical views, each addressing a specific business perspective.

The design aims to balance three principles:

- **clarity** — the most important information should be immediately identifiable;
- **consistency** — KPIs, colors, filters, and navigation should behave consistently across pages;
- **interactivity** — users should be able to move from a global view to more specific analyses through filters and visual interactions.

## 2. Report Structure

The final report contains four analytical pages:

| Page                             | Purpose                                                      |
| -------------------------------- | ------------------------------------------------------------ |
| `01 - Vue exécutive`          | Global overview of NovaRetail sales performance              |
| `02 - Produits & Magasins`     | Analysis of product, product category, and store performance |
| `03 - Performance commerciale` | Analysis of salespeople and sales teams                      |
| `04 - Analyse temporelle`      | Analysis of revenue trends and calendar-based sales patterns |

Each page follows a common structure:

- navigation at the top of the report;
- KPI cards providing immediate performance indicators;
- analytical visuals focused on the page's business objective;
- contextual slicers for interactive filtering;
- consistent visual formatting across the report.

A page navigator provides direct access to the four analytical views and highlights the currently active page.

This structure allows the report to progress from a high-level executive overview toward more focused product, store, sales, and time-based analyses without overloading a single dashboard page.

## 3. Executive Overview

The `01 - Vue exécutive` page provides a high-level overview of NovaRetail's sales performance.

It is designed as the main entry point of the report, allowing users to assess overall business performance before moving to more detailed analytical pages.

### Key Performance Indicators

The page displays six main KPIs:

- **Revenue** — total sales revenue generated during the selected period;
- **Gross Margin** — difference between revenue and total cost;
- **Gross Margin Rate** — gross margin expressed as a percentage of revenue;
- **YoY Growth** — revenue growth compared with the equivalent period of the previous year;
- **Transactions** — number of distinct sales transactions;
- **Quantity Sold** — total number of units sold.

These indicators provide a compact view of sales activity, profitability, growth, and transaction volume.

### Main Visuals

Three analytical visuals complement the KPI cards.

#### Monthly Revenue Trend

A line chart displays revenue by month across the reporting period.

This visual makes it possible to identify:

- the overall revenue trajectory;
- monthly fluctuations;
- seasonal patterns;
- changes in performance across years.

#### Top 5 Stores by Revenue

A ranking highlights the five stores generating the highest revenue in the current filter context.

This provides an immediate view of the locations contributing most strongly to sales performance.

#### Top 5 Product Categories by Revenue

A second ranking displays the five product categories generating the highest revenue.

This helps identify the categories contributing most strongly to overall sales.

### Filters

The page includes three interactive slicers:

- **Year**;
- **Store**;
- **Product Category**.

These filters allow users to move from the global company view to a more specific analytical context.

All KPI cards and analytical visuals respond dynamically to the selected filters.

The YoY indicator depends on the active time context and is therefore most meaningful when a specific year provides a valid basis for comparison.

## 4. Products & Stores Analysis

The `02 - Produits & Magasins` page provides a more detailed analysis of product and store performance.

While the executive overview focuses on overall business performance, this page allows users to compare revenue and profitability across product categories, individual products, and stores.

### Key Performance Indicators

The page displays five KPIs:

- **Revenue** — total sales revenue generated in the current filter context;
- **Gross Margin** — gross profit generated after accounting for product costs;
- **Gross Margin Rate** — gross margin expressed as a percentage of revenue;
- **Discount Amount** — total monetary impact of discounts applied to sales;
- **Effective Discount Rate** — overall discount level relative to the corresponding sales value.

These indicators provide a combined view of sales performance, profitability, and discount activity.

### Product Category Analysis

A combined chart displays the **Top 10 product categories by revenue**, together with their gross margin rate.

Revenue is represented by bars, while the gross margin rate is represented by a line.

This makes it possible to compare two complementary dimensions of performance:

- the commercial contribution of each product category;
- the profitability generated by that category.

A category generating high revenue is therefore not automatically interpreted as having the strongest profitability.

### Store Analysis

A second combined chart displays the **Top 5 stores by revenue**, together with their gross margin rate.

As with the product category analysis, revenue and profitability are displayed together to provide a more complete view of store performance.

This helps distinguish stores with strong revenue performance from stores that also maintain stronger margin performance.

### Product Rankings

Two additional rankings provide a more granular product-level view:

- **Top 10 Products by Revenue**;
- **Top 10 Products by Gross Margin**.

Using separate rankings makes it possible to compare products according to both sales contribution and absolute profitability.

A product can therefore rank highly in revenue without necessarily occupying the same position when products are ranked by gross margin.

### Filters

The page includes three interactive slicers:

- **Year**;
- **Store**;
- **Product Category**.

These filters update the KPI cards and analytical visuals dynamically.

They allow users to analyze product and store performance globally or within a more specific business context.

## 5. Sales Performance Analysis

The `03 - Performance commerciale` page focuses on the performance of individual salespeople and sales teams.

The objective is to evaluate commercial performance from several perspectives, combining revenue, profitability, transaction activity, and sales volume.

### Key Performance Indicators

The page displays five KPIs:

- **Revenue** — total revenue generated in the current filter context;
- **Gross Margin** — gross profit generated by sales;
- **Gross Margin Rate** — gross margin expressed as a percentage of revenue;
- **Transactions** — number of distinct sales transactions;
- **Quantity Sold** — total number of units sold.

These indicators provide an overall view of commercial activity before analyzing individual salespeople and teams.

### Salesperson Performance Table

A detailed table provides a consolidated view of salesperson performance.

The table includes:

- salesperson;
- sales team;
- revenue;
- gross margin;
- gross margin rate;
- number of transactions;
- quantity sold.

The table is sorted by revenue in descending order, making it possible to identify the strongest revenue contributors while retaining additional information about profitability and sales activity.

### Revenue by Salesperson

A horizontal bar chart compares revenue across individual salespeople.

This ranking provides a direct view of differences in revenue contribution and complements the detailed performance table with a more visual comparison.

Additional measures such as gross margin, gross margin rate, transaction count, and quantity sold are available through tooltips to provide further context without overloading the visual.

### Revenue and Profitability Analysis

A scatter plot compares individual salespeople according to two dimensions:

- **X-axis:** Revenue;
- **Y-axis:** Gross Margin Rate.

Each point represents one salesperson.

The chart includes two average reference lines:

- average revenue per salesperson;
- average gross margin rate.

These reference lines divide the visual into four analytical areas:

- **high revenue / high margin rate** — salespeople combining strong revenue contribution with above-average profitability;
- **high revenue / low margin rate** — strong revenue contribution with profitability below the average;
- **low revenue / high margin rate** — stronger profitability but lower revenue contribution;
- **low revenue / low margin rate** — performance below the average on both dimensions.

This approach provides a more balanced assessment than ranking salespeople by revenue alone.

It also helps identify different performance profiles without assuming that the highest-revenue salesperson is automatically the most profitable.

Detailed values such as gross margin, transaction count, and quantity sold are available through tooltips for additional analysis.

### Revenue by Sales Team

A column chart compares total revenue across the sales teams.

This provides a higher-level view of commercial performance and complements the salesperson-level analysis by showing how revenue is distributed across teams.

### Filters

The page includes three interactive slicers:

- **Year**;
- **Sales Team**;
- **Salesperson**.

These filters update the KPI cards, table, and analytical visuals dynamically.

They allow users to move from an overall commercial view to the analysis of a specific team or individual salesperson.

## 6. Time Analysis

The `04 - Analyse temporelle` page focuses on the evolution of sales performance over time and on recurring calendar-based patterns.

The objective is to complement the other analytical pages with a dedicated temporal perspective, allowing users to examine revenue trends, year-over-year growth, and differences in daily sales performance.

### Key Performance Indicators

The page displays five KPIs:

- **Revenue** — total revenue generated in the current filter context;
- **YoY Growth** — revenue growth compared with the equivalent period of the previous year;
- **Transactions** — number of distinct sales transactions;
- **Quantity Sold** — total number of units sold;
- **Average Daily Revenue** — average revenue generated per day in the current analytical context.

These indicators provide a summary of sales performance while adding a normalized daily measure for temporal comparisons.

### Monthly Revenue Trend

A line chart displays revenue by month across the reporting period.

This visual provides a continuous view of sales performance and makes it possible to identify:

- changes in the revenue trajectory;
- monthly fluctuations;
- recurring seasonal patterns;
- differences in performance across years.

The monthly view complements the YoY KPI by showing the underlying evolution behind annual performance changes.

### Weekday vs Weekend Analysis

A comparison chart displays **average daily revenue for weekdays and weekends**.

Average daily revenue is used instead of total revenue because the number of weekdays and weekend days in the calendar is different.

This provides a more comparable measure of sales performance between the two types of days and helps identify whether daily commercial activity differs between weekdays and weekends.

### Revenue by Day of Week

A second chart displays **average daily revenue by day of the week**, from Monday to Sunday.

The weekday names are sorted using their numerical day-of-week order from the date dimension, ensuring that the visual follows the natural calendar sequence rather than alphabetical order.

Using average daily revenue allows each weekday to be compared on a normalized basis rather than simply comparing accumulated revenue.

This analysis helps identify recurring differences in daily sales performance across the week.

### Filters

The page includes two interactive slicers:

- **Year**;
- **Store**.

These filters update the KPI cards and temporal visuals dynamically.

They allow users to analyze time patterns globally or within a specific year or store context.

## 7. Navigation and Interactions

The dashboard was designed as an interactive report rather than a collection of independent static pages.

Navigation, slicers, and visual interactions allow users to move between analytical perspectives and progressively refine the business context.

### Page Navigation

A page navigator is positioned at the top of the report and provides direct access to the four analytical pages:

- `01 - Vue exécutive`;
- `02 - Produits & Magasins`;
- `03 - Performance commerciale`;
- `04 - Analyse temporelle`.

The active page is visually highlighted, allowing users to immediately identify their current position within the report.

Using a consistent navigation structure across the report creates a dashboard experience similar to a small analytical application rather than a sequence of disconnected report pages.

### Interactive Filtering

Each page contains slicers adapted to its analytical purpose.

Depending on the page, users can filter the report by dimensions such as:

- year;
- store;
- product category;
- sales team;
- salesperson.

The available filters were intentionally adapted to the business context of each page rather than displaying every possible dimension everywhere.

When a slicer selection changes, the relevant KPI cards and analytical visuals are recalculated according to the new filter context.

### Visual Interactions

Charts and tables also participate in the interactive analysis.

Selecting a data point or category in a visual can filter or highlight related information in other visuals on the same page, allowing users to explore the data without creating separate reports for every analytical combination.

Tooltips provide additional measures where useful, giving users access to supporting information without permanently increasing the visual density of the page.

### Interaction Design Principle

The interaction design follows a progressive analysis approach:

**overview → filtering → comparison → detailed analysis**

Users can begin with a global view, narrow the analytical context using slicers or visual selections, and then move to a specialized report page when deeper analysis is required.

This approach keeps the report readable while preserving the ability to explore the underlying business data dynamically.

## 8. Visual Design and Color System

The dashboard uses a consistent visual system to improve readability and help users interpret information across the different report pages.

The objective was to create a professional analytical interface while avoiding unnecessary visual complexity.

### Visual Consistency

The same general layout principles are reused throughout the report:

- navigation is positioned consistently at the top of each page;
- KPI cards are placed in the upper section for immediate visibility;
- analytical visuals occupy the main reporting area;
- slicers are grouped consistently to support filtering;
- titles and labels follow a common formatting approach.

This consistency reduces the effort required to understand each new page and allows users to focus on the analysis rather than on changes in interface structure.

### Color System

A limited color palette is used throughout the report, with colors assigned according to analytical meaning rather than decorative variety.

The main semantic colors are:

| Color                          | Main Usage                                                          |
| ------------------------------ | ------------------------------------------------------------------- |
| **Blue**                 | Revenue, monetary values, volumes, rankings, and entity comparisons |
| **Cyan** (`#22D3EE`)   | Profitability indicators, particularly gross margin rate            |
| **Orange** (`#F59E0B`) | Time-based trends and temporal evolution                            |

### Blue — Business Performance

Blue is the primary analytical color of the dashboard.

It is used for measures such as revenue, gross margin amounts, quantities, and rankings where the main objective is to compare the magnitude of business performance across entities.

Examples include comparisons between products, stores, salespeople, and sales teams.

### Cyan — Profitability

Cyan is used primarily when profitability needs to be visually distinguished from revenue or other monetary measures.

For example, in combined charts, revenue can be represented using blue bars while the gross margin rate is represented using a cyan line.

The salesperson scatter plot also uses cyan markers and reference lines to support the revenue-versus-profitability analysis.

This makes profitability visually identifiable without introducing a large number of unrelated colors.

### Orange — Time-Based Trends

Orange is reserved primarily for temporal evolution.

It is used for the monthly revenue trend, where the objective is to emphasize changes in performance over time rather than comparisons between business entities.

Keeping orange associated with temporal analysis creates a visual distinction between:

- **comparison** — primarily represented in blue;
- **profitability** — highlighted in cyan;
- **evolution over time** — highlighted in orange.

### Visual Design Principle

The dashboard intentionally avoids assigning a different color to every category, product, store, or salesperson unless the distinction provides analytical value.

Instead, visual hierarchy is created through position, size, labels, and a limited semantic color palette.

This approach keeps the report visually consistent and helps ensure that color supports interpretation rather than becoming a source of distraction.

## 9. Analytical Design Choices

Several analytical design choices were made to ensure that the dashboard supports interpretation rather than simply displaying metrics.

### Revenue and Profitability

Revenue is an important indicator of commercial performance, but it does not provide a complete view of business performance on its own.

For this reason, several visuals combine or compare revenue with profitability measures such as gross margin and gross margin rate.

This approach is used particularly in the product category, store, and salesperson analyses.

It allows users to distinguish between:

- entities generating strong revenue;
- entities generating strong profitability;
- entities combining both dimensions.

### Average Daily Revenue

Time-based comparisons use average daily revenue when comparing weekdays, weekends, and individual days of the week.

Using total revenue in these situations could produce misleading comparisons because the number of occurrences of each type of day is not identical.

Average daily revenue provides a normalized measure and therefore supports a more meaningful comparison of recurring calendar patterns.

### Average Reference Lines

The salesperson scatter plot includes average reference lines for:

- revenue per salesperson;
- gross margin rate.

These lines divide the visual into four analytical areas and provide an immediate benchmark for interpreting salesperson performance.

Rather than evaluating each salesperson only through an absolute ranking, users can identify whether revenue and profitability are above or below the corresponding averages.

### Top-N Rankings

Several visuals use Top-N rankings to focus attention on the entities contributing most strongly to performance.

Examples include:

- Top 5 stores;
- Top 5 product categories on the executive overview;
- Top 10 product categories in the product and store analysis;
- Top 10 individual products.

Limiting these visuals to the most relevant entities improves readability while more detailed views remain available on the specialized report pages.

### Tooltips and Detail on Demand

Additional information is provided through tooltips where displaying every measure directly on the visual would reduce readability.

For example, the salesperson analysis provides supporting measures such as gross margin, gross margin rate, transaction count, and quantity sold through tooltips.

This follows a detail-on-demand approach: the main visual remains focused on its primary analytical question while additional context remains accessible when required.

### Analytical Design Principle

The dashboard was designed around a simple principle:

> **Each visual should answer a specific analytical question.**

Visuals were therefore selected according to the type of analysis required:

- KPI cards for immediate performance monitoring;
- line charts for temporal evolution;
- bar and column charts for rankings and comparisons;
- combined charts for revenue and profitability analysis;
- scatter plots for multidimensional salesperson performance;
- tables for detailed comparison.

This approach avoids adding visuals purely for variety and keeps the report focused on business interpretation.

## 10. Result

The final NovaRetail Power BI dashboard provides an interactive analytical interface built on top of the PostgreSQL database and Power BI semantic model developed during the previous stages of the project.

The report combines four complementary analytical perspectives:

- an executive overview of overall sales performance;
- product and store performance analysis;
- salesperson and sales team performance analysis;
- time-based analysis of revenue and recurring sales patterns.

Across these pages, users can monitor the main business KPIs, compare revenue and profitability, explore performance across different business dimensions, and refine the analysis through interactive filters and visual selections.

The dashboard also applies consistent navigation, visual hierarchy, semantic color usage, and analytical design principles to maintain readability across the report.

Rather than presenting metrics in isolation, the report was designed to support progressive analysis:

**overview → filtering → comparison → detailed analysis**

The resulting dashboard provides the interactive decision-support layer of the NovaRetail BI project and creates the foundation for the final business analysis.

The key findings identified through the dashboard, their business interpretation, and the resulting recommendations are documented separately in `07_Business_Insights.md`.
