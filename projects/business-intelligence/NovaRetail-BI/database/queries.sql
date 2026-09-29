-- ============================================================
-- NovaRetail BI - Business Analysis Queries
-- PostgreSQL
--
-- Purpose:
-- Analyse retail sales performance and identify business
-- insights that will support the Power BI dashboard.
-- ============================================================



-- ============================================================
-- 1. Overall Sales Performance
-- ============================================================
-- Purpose:
-- Calculate the main business KPIs across all sales records:
--   - Revenue
--   - Total cost
--   - Gross margin
--   - Gross margin rate
-- ============================================================
SELECT
    ROUND(SUM(quantite * prix_unitaire), 2) AS chiffre_affaires,
    ROUND(SUM(quantite * cout_unitaire), 2) AS cout_total,
    ROUND(SUM(quantite * (prix_unitaire - cout_unitaire)), 2) AS marge_brute,
    ROUND(
		(SUM(quantite * (prix_unitaire - cout_unitaire))
		/ SUM(quantite * prix_unitaire)) * 100,
		2
	) AS taux_marge_brute_pct
FROM fact_vente;

-- ============================================================
-- 2. Annual Sales Performance
-- ============================================================
-- Purpose:
-- Analyse the main business KPIs by year:
--   - Revenue
--   - Total cost
--   - Gross margin
--   - Gross margin rate
-- ============================================================
SELECT
	dd.annee,
    ROUND(SUM(quantite * prix_unitaire), 2) AS chiffre_affaires,
    ROUND(SUM(quantite * cout_unitaire), 2) AS cout_total,
    ROUND(SUM(quantite * (prix_unitaire - cout_unitaire)), 2) AS marge_brute,
    ROUND(
		(SUM(quantite * (prix_unitaire - cout_unitaire))
		/ SUM(quantite * prix_unitaire)) * 100,
		2
	) AS taux_marge_brute_pct
FROM fact_vente fv
JOIN dim_date dd
    ON dd.id_date = fv.id_date
GROUP BY dd.annee
ORDER BY dd.annee;

-- ============================================================
-- 3. Monthly Sales Trend
-- ============================================================
-- Purpose:
-- Analyse monthly sales performance and identify seasonality
-- through transaction volume, revenue, average basket value
-- and profitability.
-- ============================================================

SELECT
    dd.annee,
    dd.mois,
    dd.nom_mois,
    COUNT(DISTINCT fv.code_vente) AS nombre_transactions,
    ROUND(SUM(fv.quantite * fv.prix_unitaire), 2) AS chiffre_affaires,
    ROUND(SUM(fv.quantite * fv.cout_unitaire), 2) AS cout_total,
    ROUND(
        SUM(fv.quantite * fv.prix_unitaire)
        / COUNT(DISTINCT fv.code_vente),
        2
    ) AS panier_moyen,
    ROUND(
        SUM(fv.quantite * (fv.prix_unitaire - fv.cout_unitaire)),
        2
    ) AS marge_brute,
    ROUND(
        SUM(fv.quantite * (fv.prix_unitaire - fv.cout_unitaire))
        / SUM(fv.quantite * fv.prix_unitaire) * 100,
        2
    ) AS taux_marge_brute_pct
FROM fact_vente fv
JOIN dim_date dd
    ON fv.id_date = dd.id_date
GROUP BY
    dd.annee,
    dd.mois,
    dd.nom_mois
ORDER BY
    dd.annee,
    dd.mois;


-- ============================================================
-- 4. Store Performance
-- ============================================================
-- Purpose:
-- Compare store performance based on transaction volume,
-- revenue, average basket value and profitability.
-- ============================================================
SELECT
	m.code_magasin AS code_magasin,
	m.nom_magasin AS nom_magasin,
	m.ville AS ville_magasin,
	COUNT(DISTINCT fv.code_vente) AS transactions,
	ROUND(SUM(fv.quantite * fv.prix_unitaire), 2) AS chiffre_affaires,
	ROUND(SUM(fv.quantite * fv.prix_unitaire)
	/ COUNT(DISTINCT fv.code_vente), 2) AS panier_moyen,
	ROUND(SUM(fv.quantite * (fv.prix_unitaire - fv.cout_unitaire)), 2) AS marge_brute,
	ROUND(SUM(fv.quantite * (fv.prix_unitaire - fv.cout_unitaire))
	/ SUM(fv.quantite * fv.prix_unitaire) * 100, 2) AS taux_marge_brute_pct
FROM fact_vente fv
INNER JOIN dim_magasin m
	ON fv.id_magasin = m.id_magasin
GROUP BY m.code_magasin, 
         m.nom_magasin,
		 m.ville
ORDER BY chiffre_affaires DESC;

-- ============================================================
-- 5. Product Performance
-- ============================================================
-- Purpose:
-- Compare individual product performance based on units sold,
-- revenue and profitability.
-- ============================================================
SELECT
    p.code_produit AS code_produit,
    p.nom_produit AS nom_produit,
	p.type_produit AS type_produit,
	SUM(fv.quantite) AS quantite_vendue,
    ROUND(SUM(fv.quantite * fv.prix_unitaire), 2) AS chiffre_affaires,
    ROUND(SUM(fv.quantite * (fv.prix_unitaire - fv.cout_unitaire)), 2) AS marge_brute,
	ROUND(
	   SUM(fv.quantite * (fv.prix_unitaire - fv.cout_unitaire))
	   / SUM(fv.quantite * fv.prix_unitaire) * 100
	   , 2) AS taux_marge_brute_pct

FROM fact_vente fv
JOIN dim_produit p
    ON fv.id_produit = p.id_produit

GROUP BY
    p.code_produit,
	p.nom_produit,
	p.type_produit
ORDER BY chiffre_affaires DESC;

-- ============================================================
-- 6. Product Type Performance
-- ============================================================
-- Purpose:
-- Compare product types based on sales volume, revenue
-- and profitability.
-- ============================================================
SELECT
    p.type_produit AS type_produit,
	SUM(fv.quantite) AS quantite_vendue,
    ROUND(SUM(fv.quantite * fv.prix_unitaire), 2) AS chiffre_affaires,
    ROUND(SUM(fv.quantite * (fv.prix_unitaire - fv.cout_unitaire)), 2) AS marge_brute,
	ROUND(
	   SUM(fv.quantite * (fv.prix_unitaire - fv.cout_unitaire))
	   / SUM(fv.quantite * fv.prix_unitaire) * 100
	   , 2) AS taux_marge_brute_pct

FROM fact_vente fv
JOIN dim_produit p
    ON fv.id_produit = p.id_produit

GROUP BY
  p.type_produit
ORDER BY chiffre_affaires DESC;

-- ============================================================
-- 7. Salesperson Performance
-- ============================================================
-- Purpose:
-- Compare salesperson performance based on transaction volume,
-- revenue, average basket value and profitability.
-- ============================================================
SELECT
	co.code_commercial AS code,
	co.nom_commercial AS nom,
	co.prenom_commercial AS prenom,
	co.equipe AS equipe,
	co.manager AS manager,
	COUNT(DISTINCT fv.code_vente) AS transactions,
	ROUND(SUM(fv.quantite * fv.prix_unitaire), 2) AS chiffre_affaires,
	ROUND(
		SUM(fv.quantite * fv.prix_unitaire)
		/ COUNT(DISTINCT fv.code_vente)
	,2) AS panier_moyen,
	ROUND(
		SUM(fv.quantite * (fv.prix_unitaire - fv.cout_unitaire))
	,2) AS marge_brute,
	ROUND(
		SUM(fv.quantite * (fv.prix_unitaire - fv.cout_unitaire))
		/ SUM(fv.quantite * fv.prix_unitaire) * 100
	,2) AS taux_marge_brute_pct
FROM fact_vente fv
JOIN dim_commercial co
	ON fv.id_commercial = co.id_commercial
GROUP BY co.code_commercial,
         co.nom_commercial,
		 co.prenom_commercial,
		 co.equipe,
		 co.manager
ORDER BY chiffre_affaires DESC;

-- ============================================================
-- 8. Sales Team Performance
-- ============================================================
-- Purpose:
-- Compare sales team performance based on transaction volume,
-- revenue, average basket value and profitability.
-- ============================================================
SELECT
    co.equipe AS equipe,
    co.manager AS manager,
    COUNT(DISTINCT fv.code_vente) AS transactions,
    ROUND(SUM(fv.quantite * fv.prix_unitaire), 2) AS chiffre_affaires,
    ROUND(
        SUM(fv.quantite * fv.prix_unitaire)
        / COUNT(DISTINCT fv.code_vente),
        2
    ) AS panier_moyen,
    ROUND(
        SUM(fv.quantite * (fv.prix_unitaire - fv.cout_unitaire)),
        2
    ) AS marge_brute,
    ROUND(
        SUM(fv.quantite * (fv.prix_unitaire - fv.cout_unitaire))
        / SUM(fv.quantite * fv.prix_unitaire) * 100,
        2
    ) AS taux_marge_brute_pct
FROM fact_vente fv
JOIN dim_commercial co
    ON fv.id_commercial = co.id_commercial
GROUP BY
    co.equipe,
    co.manager
ORDER BY chiffre_affaires DESC;

-- ============================================================================
-- 9. Store and Product Type Performance
-- ============================================================================
-- Purpose:
-- Analyse revenue and profitability by store and product type
-- to understand how product types contribute to each store's performance.
-- ============================================================================
SELECT
    m.code_magasin AS code_magasin,
    m.nom_magasin AS nom_magasin,
    p.type_produit AS type_produit,
    SUM(fv.quantite) AS quantite_vendue,
    ROUND(SUM(fv.quantite * fv.prix_unitaire), 2) AS chiffre_affaires,
    ROUND(SUM(fv.quantite * (fv.prix_unitaire - fv.cout_unitaire)), 2) AS marge_brute,
    ROUND(
        SUM(fv.quantite * (fv.prix_unitaire - fv.cout_unitaire))
		/ SUM(fv.quantite * fv.prix_unitaire) * 100
    , 2) AS taux_marge_brute_pct
FROM fact_vente fv
JOIN dim_magasin m
    ON fv.id_magasin = m.id_magasin
JOIN dim_produit p
    ON fv.id_produit = p.id_produit
GROUP BY m.code_magasin,
         m.nom_magasin,
         p.type_produit
ORDER BY chiffre_affaires DESC;


-- ============================================================
-- 10. Weekday vs Weekend Sales Performance
-- ============================================================
-- Purpose:
-- Compare sales performance between weekdays and weekends
-- based on transaction volume, revenue, average basket value
-- and profitability.
-- ============================================================
SELECT 
	CASE 
		WHEN dd.est_weekend THEN 'Weekend'
		ELSE 'Weekday'
	END  AS type_jour,
	COUNT(DISTINCT fv.code_vente) AS transactions,
	ROUND(SUM(fv.quantite * fv.prix_unitaire), 2) AS chiffre_affaires,
	ROUND(
		SUM(fv.quantite * (fv.prix_unitaire - fv.cout_unitaire))
	, 2) AS marge_brute,
	ROUND(
		SUM(fv.quantite * fv.prix_unitaire)
		/ COUNT(DISTINCT fv.code_vente)
	, 2) AS panier_moyen,
	ROUND(SUM(fv.quantite * (fv.prix_unitaire - fv.cout_unitaire)) 
	/ SUM(fv.quantite * fv.prix_unitaire) * 100
	, 2) AS taux_marge_brute_pct
	
FROM fact_vente fv
JOIN dim_date dd
	ON fv.id_date = dd.id_date
GROUP BY dd.est_weekend
ORDER BY chiffre_affaires DESC;

-- ============================================================
-- 11. Year-over-Year Revenue Growth
-- ============================================================
-- Purpose:
-- Measure annual revenue growth by comparing each year's
-- revenue with the previous year.
-- ============================================================

WITH ca_annuel AS (
	SELECT
	    dd.annee AS annee,
	    ROUND(SUM(fv.quantite * fv.prix_unitaire), 2) AS chiffre_affaires
	FROM fact_vente fv
	JOIN dim_date dd
	    ON fv.id_date = dd.id_date
	GROUP BY dd.annee
),
comparaison AS (
	SELECT
		annee,
		chiffre_affaires,
		LAG(chiffre_affaires) OVER(
			ORDER BY annee
		) AS ca_annee_precedente
	FROM ca_annuel
)

SELECT
	annee,
	chiffre_affaires,
	ca_annee_precedente,
	ROUND((chiffre_affaires - ca_annee_precedente)
	/ NULLIF(ca_annee_precedente, 0) * 100
	, 2) AS taux_croissance_yoy_pct
FROM comparaison;
