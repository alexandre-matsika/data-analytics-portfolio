-- ============================================================
-- NovaRetail BI - Data Quality Checks
-- PostgreSQL
--
-- Purpose:
-- Validate completeness, integrity and business consistency
-- of the data warehouse after data loading.
-- ============================================================


-- ============================================================
-- 1. TABLE VOLUMES
-- ============================================================

SELECT
    (SELECT COUNT(*) FROM dim_date) AS nb_dates,
    (SELECT COUNT(*) FROM dim_client) AS nb_clients,
    (SELECT COUNT(*) FROM dim_produit) AS nb_produits,
    (SELECT COUNT(*) FROM dim_magasin) AS nb_magasins,
    (SELECT COUNT(*) FROM dim_commercial) AS nb_commerciaux,
    (SELECT COUNT(*) FROM fact_vente) AS nb_lignes_vente;


-- ============================================================
-- 2. BUSINESS KEY UNIQUENESS
-- ============================================================

SELECT
    (SELECT COUNT(*) - COUNT(DISTINCT code_client)
     FROM dim_client) AS doublons_code_client,

    (SELECT COUNT(*) - COUNT(DISTINCT code_produit)
     FROM dim_produit) AS doublons_code_produit,

    (SELECT COUNT(*) - COUNT(DISTINCT code_magasin)
     FROM dim_magasin) AS doublons_code_magasin,

    (SELECT COUNT(*) - COUNT(DISTINCT code_commercial)
     FROM dim_commercial) AS doublons_code_commercial,

    (SELECT COUNT(*) - COUNT(DISTINCT date)
     FROM dim_date) AS doublons_date;

-- ============================================================
-- 3. REQUIRED VALUES - FACT_VENTE
-- ============================================================

SELECT
    COUNT(*) FILTER (WHERE code_vente IS NULL) AS null_code_vente,
    COUNT(*) FILTER (WHERE id_produit IS NULL) AS null_id_produit,
    COUNT(*) FILTER (WHERE id_client IS NULL) AS null_id_client,
    COUNT(*) FILTER (WHERE id_magasin IS NULL) AS null_id_magasin,
    COUNT(*) FILTER (WHERE id_commercial IS NULL) AS null_id_commercial,
    COUNT(*) FILTER (WHERE id_date IS NULL) AS null_id_date,
    COUNT(*) FILTER (WHERE quantite IS NULL) AS null_quantite,
    COUNT(*) FILTER (WHERE prix_unitaire IS NULL) AS null_prix_unitaire,
    COUNT(*) FILTER (WHERE cout_unitaire IS NULL) AS null_cout_unitaire,
    COUNT(*) FILTER (WHERE taux_remise IS NULL) AS null_taux_remise
FROM fact_vente;

-- ============================================================
-- 4. REQUIRED VALUES - DIMENSIONS
-- ============================================================

SELECT
    (SELECT COUNT(*) FROM dim_client
     WHERE code_client IS NULL
        OR nom_client IS NULL
        OR prenom_client IS NULL
        OR sexe IS NULL
        OR date_inscription IS NULL
        OR date_naissance IS NULL
    ) AS clients_incomplets,

    (SELECT COUNT(*) FROM dim_produit
     WHERE code_produit IS NULL
        OR nom_produit IS NULL
        OR categorie IS NULL
        OR sous_categorie IS NULL
        OR marque IS NULL
        OR fournisseur IS NULL
        OR prix_catalogue IS NULL
        OR type_produit IS NULL
    ) AS produits_incomplets,

    (SELECT COUNT(*) FROM dim_magasin
     WHERE code_magasin IS NULL
        OR nom_magasin IS NULL
        OR type_magasin IS NULL
        OR date_ouverture IS NULL
    ) AS magasins_incomplets,

    (SELECT COUNT(*) FROM dim_commercial
     WHERE code_commercial IS NULL
        OR nom_commercial IS NULL
        OR prenom_commercial IS NULL
        OR equipe IS NULL
        OR date_recrutement IS NULL
        OR manager IS NULL
    ) AS commerciaux_incomplets,

    (SELECT COUNT(*) FROM dim_date
     WHERE date IS NULL
        OR annee IS NULL
        OR trimestre IS NULL
        OR mois IS NULL
        OR nom_mois IS NULL
        OR semaine IS NULL
        OR jour IS NULL
        OR jour_semaine IS NULL
        OR nom_jour IS NULL
        OR est_weekend IS NULL
        OR est_jour_ferie IS NULL
    ) AS dates_incompletes;

-- ============================================================
-- 5. REFERENTIAL INTEGRITY
-- ============================================================

SELECT
    COUNT(*) FILTER (WHERE dp.id_produit IS NULL)
        AS produits_orphelins,

    COUNT(*) FILTER (WHERE dc.id_client IS NULL)
        AS clients_orphelins,

    COUNT(*) FILTER (WHERE dm.id_magasin IS NULL)
        AS magasins_orphelins,

    COUNT(*) FILTER (WHERE dco.id_commercial IS NULL)
        AS commerciaux_orphelins,

    COUNT(*) FILTER (WHERE dd.id_date IS NULL)
        AS dates_orphelines

FROM fact_vente fv

LEFT JOIN dim_produit dp
    ON fv.id_produit = dp.id_produit

LEFT JOIN dim_client dc
    ON fv.id_client = dc.id_client

LEFT JOIN dim_magasin dm
    ON fv.id_magasin = dm.id_magasin

LEFT JOIN dim_commercial dco
    ON fv.id_commercial = dco.id_commercial

LEFT JOIN dim_date dd
    ON fv.id_date = dd.id_date;

-- ============================================================
-- 6. BUSINESS VALUE CONSISTENCY - FACT_VENTE
-- ============================================================

SELECT
    COUNT(*) FILTER (
        WHERE quantite <= 0
    ) AS quantites_invalides,

    COUNT(*) FILTER (
        WHERE prix_unitaire <= 0
    ) AS prix_invalides,

    COUNT(*) FILTER (
        WHERE cout_unitaire <= 0
    ) AS couts_invalides,

    COUNT(*) FILTER (
        WHERE taux_remise < 0
           OR taux_remise > 1
    ) AS remises_invalides,

    COUNT(*) FILTER (
        WHERE LENGTH(TRIM(code_vente)) = 0
    ) AS codes_vente_vides

FROM fact_vente;

-- ============================================================
-- 7. QUANTITY DISTRIBUTION
-- ============================================================

SELECT
    quantite,
    COUNT(*) AS nb_lignes,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS pourcentage
FROM fact_vente
GROUP BY quantite
ORDER BY quantite;

-- ============================================================
-- 8. DISCOUNT DISTRIBUTION
-- ============================================================

SELECT
    taux_remise,
    COUNT(*) AS nb_lignes,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS pourcentage
FROM fact_vente
GROUP BY taux_remise
ORDER BY taux_remise;

-- ============================================================
-- 9. TRANSACTION DISTRIBUTION BY YEAR
-- ============================================================

SELECT
    dd.annee,
    COUNT(DISTINCT fv.code_vente) AS nb_transactions
FROM fact_vente fv
INNER JOIN dim_date dd
    ON fv.id_date = dd.id_date
GROUP BY dd.annee
ORDER BY dd.annee;

-- ============================================================
-- 10. TRANSACTION DISTRIBUTION BY MONTH
-- ============================================================

SELECT
    dd.mois,
    dd.nom_mois,
    COUNT(DISTINCT fv.code_vente) AS nb_transactions,
    ROUND(
        COUNT(DISTINCT fv.code_vente) * 100.0
        / SUM(COUNT(DISTINCT fv.code_vente)) OVER (),
        2
    ) AS pourcentage
FROM fact_vente fv
INNER JOIN dim_date dd
    ON fv.id_date = dd.id_date
GROUP BY
    dd.mois,
    dd.nom_mois
ORDER BY dd.mois;

-- ============================================================
-- 11. PRICE, COST AND MARGIN CONSISTENCY
-- ============================================================

SELECT
    COUNT(*) FILTER (
        WHERE prix_unitaire < cout_unitaire
    ) AS ventes_marge_negative,

    COUNT(*) FILTER (
        WHERE prix_unitaire = cout_unitaire
    ) AS ventes_marge_nulle,

    COUNT(*) FILTER (
        WHERE prix_unitaire > cout_unitaire
    ) AS ventes_marge_positive,

    ROUND(MIN(prix_unitaire - cout_unitaire), 2)
        AS marge_unitaire_min,

    ROUND(MAX(prix_unitaire - cout_unitaire), 2)
        AS marge_unitaire_max

FROM fact_vente;

-- ============================================================
-- 12. DISCOUNT / SELLING PRICE CONSISTENCY
-- ============================================================

SELECT
    COUNT(*) FILTER (
        WHERE fv.prix_unitaire <>
              ROUND(
                  dp.prix_catalogue * (1 - fv.taux_remise),
                  2
              )
    ) AS prix_incoherents,

    COUNT(*) AS nb_lignes_controlees

FROM fact_vente fv

INNER JOIN dim_produit dp
    ON fv.id_produit = dp.id_produit;

-- ============================================================
-- 13. COST CONSISTENCY
-- ============================================================

WITH couts_attendus AS (
    SELECT
        fv.id_ligne_vente,
        fv.cout_unitaire,
        dp.prix_catalogue,

        CASE
            WHEN dp.type_produit = 'Smartphone' THEN 0.85
            WHEN dp.type_produit = 'Ordinateur portable' THEN 0.82
            WHEN dp.type_produit = 'Téléviseur 4K' THEN 0.80
            WHEN dp.type_produit = 'Console de jeux' THEN 0.84
            WHEN dp.type_produit = 'Casque Bluetooth' THEN 0.65

            WHEN dp.type_produit IN (
                'Tablette de chocolat',
                'Jus d''orange',
                'Paquet de pâtes',
                'Café moulu',
                'Biscuits'
            ) THEN 0.70

            WHEN dp.type_produit IN (
                'Baskets',
                'Jean',
                'Sac à main',
                'Veste'
            ) THEN 0.55

            WHEN dp.type_produit IN (
                'Shampoing',
                'Crème hydratante',
                'Parfum',
                'Rouge à lèvres'
            ) THEN 0.50

            WHEN dp.type_produit IN (
                'Canapé',
                'Lampe de bureau',
                'Draps de lit'
            ) THEN 0.60

            WHEN dp.type_produit IN (
                'Peluche',
                'Jeu de société',
                'Ballon de football'
            ) THEN 0.60

            ELSE NULL
        END AS taux_cout_attendu

    FROM fact_vente fv
    INNER JOIN dim_produit dp
        ON fv.id_produit = dp.id_produit
)

SELECT
    COUNT(*) FILTER (
        WHERE taux_cout_attendu IS NULL
    ) AS types_non_couverts,

    COUNT(*) FILTER (
        WHERE cout_unitaire <>
              ROUND(prix_catalogue * taux_cout_attendu, 2)
    ) AS couts_incoherents,

    COUNT(*) AS nb_lignes_controlees

FROM couts_attendus;

-- ============================================================
-- 14. DATE DIMENSION CONSISTENCY
-- ============================================================

SELECT
    annee,
    COUNT(*) AS nb_dates,
    COUNT(*) FILTER (WHERE est_weekend) AS nb_weekends,
    COUNT(*) FILTER (WHERE est_jour_ferie) AS nb_jours_feries,
    MIN(date) AS date_min,
    MAX(date) AS date_max
FROM dim_date
GROUP BY annee
ORDER BY annee;

-- ============================================================
-- 15. DATE ATTRIBUTE CONSISTENCY
-- ============================================================

SELECT
    COUNT(*) FILTER (
        WHERE annee <> EXTRACT(YEAR FROM date)
    ) AS annees_incoherentes,

    COUNT(*) FILTER (
        WHERE mois <> EXTRACT(MONTH FROM date)
    ) AS mois_incoherents,

    COUNT(*) FILTER (
        WHERE jour <> EXTRACT(DAY FROM date)
    ) AS jours_incoherents,

    COUNT(*) FILTER (
        WHERE trimestre <> EXTRACT(QUARTER FROM date)
    ) AS trimestres_incoherents,

    COUNT(*) FILTER (
        WHERE jour_semaine <> EXTRACT(ISODOW FROM date)
    ) AS jours_semaine_incoherents,

    COUNT(*) FILTER (
        WHERE est_weekend <>
              (EXTRACT(ISODOW FROM date) IN (6, 7))
    ) AS weekends_incoherents

FROM dim_date;