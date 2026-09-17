-- ============================================================
-- NovaRetail BI - PostgreSQL Data Warehouse
-- Star schema for retail sales analysis
--
-- Grain of fact_vente:
-- One row represents one product line within a sales transaction.
--
-- Dimensions:
--   dim_produit
--   dim_client
--   dim_magasin
--   dim_commercial
--   dim_date
--
-- Fact table:
--   fact_vente
-- ============================================================



-- ============================================================
-- DIMENSION: PRODUIT
-- Product master data used to analyse sales by category,
-- sub-category, brand and supplier.
-- ============================================================
CREATE TABLE IF NOT EXISTS dim_produit (
    id_produit INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    code_produit VARCHAR(50) UNIQUE NOT NULL,
    nom_produit VARCHAR(100) NOT NULL,
    categorie VARCHAR(100) NOT NULL,
    sous_categorie VARCHAR(100) NOT NULL,
    marque VARCHAR(100) NOT NULL,
    fournisseur VARCHAR(100) NOT NULL,
    couleur VARCHAR(100),
    taille VARCHAR(5),
    poids_kg NUMERIC(10,3) CHECK (poids_kg > 0),
    capacite_stockage_go INTEGER CHECK (capacite_stockage_go > 0),
    gamme VARCHAR(50),
    saison VARCHAR(100),
    prix_catalogue NUMERIC(10,2) NOT NULL CHECK (prix_catalogue > 0),

    CONSTRAINT chk_code_produit_non_vide
        CHECK (LENGTH(TRIM(code_produit)) > 0),

    CONSTRAINT chk_nom_produit_non_vide
        CHECK (LENGTH(TRIM(nom_produit)) > 0),

    CONSTRAINT chk_categorie_non_vide
        CHECK (LENGTH(TRIM(categorie)) > 0),

    CONSTRAINT chk_sous_categorie_non_vide
        CHECK (LENGTH(TRIM(sous_categorie)) > 0),

    CONSTRAINT chk_marque_non_vide
        CHECK (LENGTH(TRIM(marque)) > 0),

    CONSTRAINT chk_fournisseur_non_vide
        CHECK (LENGTH(TRIM(fournisseur)) > 0)
);

-- ============================================================
-- DIMENSION: CLIENT
-- Customer attributes used for demographic and geographic
-- sales analysis.
-- ============================================================
CREATE TABLE IF NOT EXISTS dim_client (
    id_client INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    code_client VARCHAR(50) UNIQUE NOT NULL,
    nom_client VARCHAR(100) NOT NULL,
    prenom_client VARCHAR(100) NOT NULL,
    sexe CHAR(1) NOT NULL CHECK (sexe IN ('F', 'M')),
    date_inscription DATE NOT NULL,
    date_naissance DATE NOT NULL,
    profession VARCHAR(100),
    ville VARCHAR(100),
    departement VARCHAR(100),
    region VARCHAR(100),
 
    CONSTRAINT chk_code_client_non_vide
        CHECK (LENGTH(TRIM(code_client)) > 0),

    CONSTRAINT chk_nom_client_non_vide
        CHECK (LENGTH(TRIM(nom_client)) > 0),

    CONSTRAINT chk_prenom_client_non_vide
        CHECK (LENGTH(TRIM(prenom_client)) > 0),

    CONSTRAINT chk_date_naissance_avant_inscription
        CHECK (date_naissance < date_inscription)
);

-- ============================================================
-- DIMENSION: MAGASIN
-- Store attributes used to analyse sales by store type,
-- location and sales area.
-- ============================================================
CREATE TABLE IF NOT EXISTS dim_magasin (
    id_magasin INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    code_magasin VARCHAR(50) UNIQUE NOT NULL,
    nom_magasin VARCHAR(100) NOT NULL,
    type_magasin VARCHAR(50) NOT NULL 
        CHECK (
            type_magasin IN (
                'Boutique', 
                'Centre commercial', 
                'Entrepôt'
            )
        ),
    date_ouverture DATE NOT NULL,
    surface_m2 NUMERIC(10,2) CHECK (surface_m2 > 0),
    ville VARCHAR(100),
    departement VARCHAR(100),
    region VARCHAR(100),

    CONSTRAINT chk_code_magasin_non_vide
        CHECK (LENGTH(TRIM(code_magasin)) > 0),

    CONSTRAINT chk_nom_magasin_non_vide
        CHECK (LENGTH(TRIM(nom_magasin)) > 0),

    CONSTRAINT chk_type_magasin_non_vide
        CHECK (LENGTH(TRIM(type_magasin)) > 0),

    CONSTRAINT chk_ville_non_vide
        CHECK (LENGTH(TRIM(ville)) > 0),

    CONSTRAINT chk_departement_non_vide
        CHECK (LENGTH(TRIM(departement)) > 0),

    CONSTRAINT chk_region_non_vide
        CHECK (LENGTH(TRIM(region)) > 0)
);

-- ============================================================
-- DIMENSION: COMMERCIAL
-- Sales representative attributes used to analyse performance
-- by salesperson, team and manager.
-- ============================================================
CREATE TABLE IF NOT EXISTS dim_commercial (
    id_commercial INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    code_commercial VARCHAR(50) UNIQUE NOT NULL,
    nom_commercial VARCHAR(100) NOT NULL,
    prenom_commercial VARCHAR(100) NOT NULL,
    equipe VARCHAR(100),
    date_recrutement DATE NOT NULL,
    manager VARCHAR(100),

    CONSTRAINT chk_code_commercial_non_vide
        CHECK (LENGTH(TRIM(code_commercial)) > 0),

    CONSTRAINT chk_nom_commercial_non_vide
        CHECK (LENGTH(TRIM(nom_commercial)) > 0),

    CONSTRAINT chk_prenom_commercial_non_vide
        CHECK (LENGTH(TRIM(prenom_commercial)) > 0),

    CONSTRAINT chk_equipe_non_vide
        CHECK (LENGTH(TRIM(equipe)) > 0),

    CONSTRAINT chk_manager_non_vide
        CHECK (LENGTH(TRIM(manager)) > 0)

);

-- ============================================================
-- DIMENSION: DATE
-- Calendar attributes used for time-based sales analysis.
-- Calendar attributes are derived from the date during data loading.
-- Public holiday attributes are enriched from a reference dataset.
-- ============================================================
CREATE TABLE IF NOT EXISTS dim_date (
    id_date INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    date DATE UNIQUE NOT NULL,
    annee INTEGER NOT NULL CHECK (annee > 0),
    trimestre INTEGER NOT NULL CHECK (trimestre BETWEEN 1 AND 4),
    mois INTEGER NOT NULL CHECK (mois BETWEEN 1 AND 12),
    nom_mois VARCHAR(20) NOT NULL 
        CHECK (
            nom_mois IN (
                'Janvier', 
                'Février', 
                'Mars', 
                'Avril', 
                'Mai', 
                'Juin', 
                'Juillet', 
                'Août', 
                'Septembre', 
                'Octobre', 
                'Novembre', 
                'Décembre'
            )
        ),
    semaine INTEGER NOT NULL CHECK (semaine BETWEEN 1 AND 53),
    jour INTEGER NOT NULL CHECK (jour BETWEEN 1 AND 31),
    jour_semaine INTEGER NOT NULL CHECK (jour_semaine BETWEEN 1 AND 7),
    nom_jour VARCHAR(10) NOT NULL 
        CHECK (
            nom_jour IN (
                'Lundi', 
                'Mardi', 
                'Mercredi', 
                'Jeudi', 
                'Vendredi', 
                'Samedi', 
                'Dimanche'
            )
        ),
    est_weekend BOOLEAN NOT NULL,
    est_jour_ferie BOOLEAN NOT NULL,
    nom_jour_ferie VARCHAR(100)
);


-- ============================================================
-- FACT TABLE: VENTE
--
-- Grain:
-- One row = one product line within a sales transaction.
--
-- code_vente identifies the business transaction and can
-- therefore appear on several rows when a transaction contains
-- several products.
--
-- Revenue, cost and gross margin are derived from:
--   quantite
--   prix_unitaire
--   cout_unitaire
-- ============================================================
CREATE TABLE IF NOT EXISTS fact_vente (
    id_ligne_vente INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    -- Business transaction identifier.
    -- Not unique because one transaction may contain multiple product lines.
    code_vente VARCHAR(50) NOT NULL,
    id_produit INTEGER NOT NULL,
    id_client INTEGER NOT NULL,
    id_magasin INTEGER NOT NULL,
    id_commercial INTEGER NOT NULL,
    id_date INTEGER NOT NULL,
    quantite INTEGER NOT NULL CHECK (quantite > 0),
    prix_unitaire NUMERIC(10,2) NOT NULL CHECK (prix_unitaire > 0),
    cout_unitaire NUMERIC(10,2) NOT NULL CHECK (cout_unitaire > 0),

    FOREIGN KEY (id_produit) REFERENCES dim_produit(id_produit),
    FOREIGN KEY (id_client) REFERENCES dim_client(id_client),
    FOREIGN KEY (id_magasin) REFERENCES dim_magasin(id_magasin),
    FOREIGN KEY (id_commercial) REFERENCES dim_commercial(id_commercial),
    FOREIGN KEY (id_date) REFERENCES dim_date(id_date),

    CONSTRAINT chk_code_vente_non_vide
        CHECK (LENGTH(TRIM(code_vente)) > 0)
);