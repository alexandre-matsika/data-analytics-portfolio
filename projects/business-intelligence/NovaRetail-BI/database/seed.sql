--------------------------------------------------------------
-- -            Création de la table calendrier
--------------------------------------------------------------
WITH Calendrier AS (
	SELECT generate_series(
		DATE '2023-01-01', 
		DATE '2025-12-31', 
		INTERVAL '1 day'
	)::DATE AS date
),
jours_feries AS (
	SELECT *
	FROM(
		VALUES
			(DATE '2023-01-01', 'Jour de l''An'),
			(DATE '2023-04-10', 'Lundi de Pâques'),
			(DATE '2023-05-01', 'Fête du Travail'),
			(DATE '2023-05-08', 'Victoire 1945'),
			(DATE '2023-05-18', 'Ascension'),
			(DATE '2023-05-29', 'Lundi de Pentecôte'),
			(DATE '2023-07-14', 'Fête nationale'),
			(DATE '2023-08-15', 'Assomption'),
			(DATE '2023-11-01', 'Toussaint'),
			(DATE '2023-11-11', 'Armistice 1918'),
			(DATE '2023-12-25', 'Noël'),
			(DATE '2024-01-01', 'Jour de l''An'),
			(DATE '2024-04-01', 'Lundi de Pâques'),
			(DATE '2024-05-01', 'Fête du Travail'),
			(DATE '2024-05-08', 'Victoire 1945'),
			(DATE '2024-05-09', 'Ascension'),
			(DATE '2024-05-20', 'Lundi de Pentecôte'),
			(DATE '2024-07-14', 'Fête nationale'),
			(DATE '2024-08-15', 'Assomption'),
			(DATE '2024-11-01', 'Toussaint'),
			(DATE '2024-11-11', 'Armistice 1918'),
			(DATE '2024-12-25', 'Noël'),
			(DATE '2025-01-01', 'Jour de l''An'),
			(DATE '2025-04-21', 'Lundi de Pâques'),
			(DATE '2025-05-01', 'Fête du Travail'),
			(DATE '2025-05-08', 'Victoire 1945'),
			(DATE '2025-05-29', 'Ascension'),
			(DATE '2025-06-09', 'Lundi de Pentecôte'),
			(DATE '2025-07-14', 'Fête nationale'),
			(DATE '2025-08-15', 'Assomption'),
			(DATE '2025-11-01', 'Toussaint'),
			(DATE '2025-11-11', 'Armistice 1918'),
			(DATE '2025-12-25', 'Noël')
	 )  AS jf(date, nom_jour_ferie)
)

SELECT
    c.date,
	EXTRACT(YEAR FROM c.date) AS annee,
	EXTRACT(QUARTER FROM c.date) AS trimestre,
	EXTRACT(MONTH FROM c.date) AS mois,
	CASE 
		WHEN EXTRACT(MONTH FROM c.date)=1 THEN 'Janvier'
		WHEN EXTRACT(MONTH FROM c.date)=2 THEN 'Février'
		WHEN EXTRACT(MONTH FROM c.date)=3 THEN 'Mars'
		WHEN EXTRACT(MONTH FROM c.date)=4 THEN 'Avril'
		WHEN EXTRACT(MONTH FROM c.date)=5 THEN 'Mai'
		WHEN EXTRACT(MONTH FROM c.date)=6 THEN 'Juin'
		WHEN EXTRACT(MONTH FROM c.date)=7 THEN 'Juillet'
		WHEN EXTRACT(MONTH FROM c.date)=8 THEN 'Août'
		WHEN EXTRACT(MONTH FROM c.date)=9 THEN 'Septembre'
		WHEN EXTRACT(MONTH FROM c.date)=10 THEN 'Octobre'
		WHEN EXTRACT(MONTH FROM c.date)=11 THEN 'Novembre'
		WHEN EXTRACT(MONTH FROM c.date)=12 THEN 'Décembre'
	END AS nom_mois,
	EXTRACT(WEEK FROM c.date) AS semaine,
	EXTRACT(DAY FROM c.date) AS jour,
	EXTRACT(ISODOW FROM c.date) AS jour_semaine,
	CASE 
		WHEN EXTRACT(ISODOW FROM c.date)=1 THEN 'Lundi'
		WHEN EXTRACT(ISODOW FROM c.date)=2 THEN 'Mardi'
		WHEN EXTRACT(ISODOW FROM c.date)=3 THEN 'Mercredi'
		WHEN EXTRACT(ISODOW FROM c.date)=4 THEN 'Jeudi'
		WHEN EXTRACT(ISODOW FROM c.date)=5 THEN 'Vendredi'
		WHEN EXTRACT(ISODOW FROM c.date)=6 THEN 'Samedi'
		WHEN EXTRACT(ISODOW FROM c.date)=7 THEN 'Dimanche'
	END AS nom_jour,
	EXTRACT(ISODOW FROM c.date) IN (6,7) AS est_weekend,
	jf.date IS NOT NULL AS est_jour_ferie,
	jf.nom_jour_ferie AS nom_jour_ferie
FROM Calendrier c
LEFT JOIN jours_feries jf
	ON c.date = jf.date
ORDER BY c.date;

------------------------------------------------------------------------------
--- Script pour générer des données de produits avec leurs variantes
------------------------------------------------------------------------------

WITH types_produits AS (
    SELECT *
    FROM (
        VALUES
            ('Smartphone', 'Électronique', 'Téléphonie mobile'),
            ('Ordinateur portable', 'Électronique', 'Informatique'),
            ('Casque Bluetooth', 'Électronique', 'Audio'),
            ('Téléviseur 4K', 'Électronique', 'TV & vidéo'),

            ('Baskets', 'Mode & habillement', 'Chaussures'),
            ('Jean', 'Mode & habillement', 'Vêtements'),
            ('Sac à main', 'Mode & habillement', 'Accessoires'),
            ('Veste', 'Mode & habillement', 'Vêtements'),

            ('Shampoing', 'Beauté & hygiène', 'Soins capillaires'),
            ('Crème hydratante', 'Beauté & hygiène', 'Soins du visage'),
            ('Parfum', 'Beauté & hygiène', 'Parfumerie'),
            ('Rouge à lèvres', 'Beauté & hygiène', 'Maquillage'),

            ('Canapé', 'Maison & décoration', 'Mobilier'),
            ('Lampe de bureau', 'Maison & décoration', 'Éclairage'),
            ('Draps de lit', 'Maison & décoration', 'Linge de maison'),

            ('Tablette de chocolat', 'Alimentation', 'Confiserie'),
            ('Jus d''orange', 'Alimentation', 'Boissons'),
            ('Paquet de pâtes', 'Alimentation', 'Épicerie'),
            ('Café moulu', 'Alimentation', 'Épicerie'),
            ('Biscuits', 'Alimentation', 'Biscuits & snacks'),

            ('Console de jeux', 'Jeux & loisirs', 'Jeux vidéo'),
            ('Peluche', 'Jeux & loisirs', 'Jouets'),
            ('Jeu de société', 'Jeux & loisirs', 'Jeux de société'),
            ('Ballon de football', 'Jeux & loisirs', 'Sport & plein air')
    ) AS t(type_produit, categorie, sous_categorie)
),
modeles_produits AS (
    SELECT *
    FROM (
		VALUES
			('Smartphone', 'Samsung', 'Galaxy S25'),
			('Smartphone', 'Apple', 'iPhone 16'),
			('Smartphone', 'Google', 'Pixel 9'),
			('Smartphone', 'Xiaomi', 'Xiaomi 15'),

			('Ordinateur portable', 'Lenovo', 'ThinkPad E14'),
			('Ordinateur portable', 'Dell', 'XPS 13'),
			('Ordinateur portable', 'HP', 'Pavilion 15'),
			('Ordinateur portable', 'Asus', 'Zenbook 14'),

			('Casque Bluetooth', 'Sony', 'WH-1000XM5'),
			('Casque Bluetooth', 'Bose', 'QuietComfort Ultra'),
			('Casque Bluetooth', 'Apple', 'AirPods Max'),
			('Casque Bluetooth', 'JBL', 'Tour One M2'),

			('Téléviseur 4K', 'LG', 'OLED evo C4'),
			('Téléviseur 4K', 'Samsung', 'Neo QLED QN90D'),
			('Téléviseur 4K', 'Sony', 'BRAVIA 8'),
			('Téléviseur 4K', 'TCL', 'C855')
	) AS m(type_produit, marque, modele)
),
variantes_produits AS (
    SELECT *
    FROM (
        VALUES
            -- =====================================================
            -- SMARTPHONES
            -- =====================================================

            -- Samsung Galaxy S25
            ('Smartphone', 'Samsung', 'Galaxy S25',
             'Noir', NULL, 0.162, 128),

            ('Smartphone', 'Samsung', 'Galaxy S25',
             'Bleu', NULL, 0.162, 256),

            -- Apple iPhone 16
            ('Smartphone', 'Apple', 'iPhone 16',
             'Noir', NULL, 0.170, 128),

            ('Smartphone', 'Apple', 'iPhone 16',
             'Blanc', NULL, 0.170, 256),

            -- Google Pixel 9
            ('Smartphone', 'Google', 'Pixel 9',
             'Noir', NULL, 0.198, 128),

            ('Smartphone', 'Google', 'Pixel 9',
             'Vert', NULL, 0.198, 256),

            -- Xiaomi 15
            ('Smartphone', 'Xiaomi', 'Xiaomi 15',
             'Noir', NULL, 0.191, 256),

            ('Smartphone', 'Xiaomi', 'Xiaomi 15',
             'Vert', NULL, 0.191, 512),


            -- =====================================================
            -- ORDINATEURS PORTABLES
            -- =====================================================

            -- Lenovo ThinkPad E14
            ('Ordinateur portable', 'Lenovo', 'ThinkPad E14',
             'Noir', '14 pouces', 1.59, 512),

            ('Ordinateur portable', 'Lenovo', 'ThinkPad E14',
             'Noir', '14 pouces', 1.59, 1024),

            -- Dell XPS 13
            ('Ordinateur portable', 'Dell', 'XPS 13',
             'Argent', '13 pouces', 1.17, 512),

            ('Ordinateur portable', 'Dell', 'XPS 13',
             'Noir', '13 pouces', 1.17, 1024),

            -- HP Pavilion 15
            ('Ordinateur portable', 'HP', 'Pavilion 15',
             'Argent', '15.6 pouces', 1.75, 512),

            ('Ordinateur portable', 'HP', 'Pavilion 15',
             'Bleu', '15.6 pouces', 1.75, 1024),

            -- Asus Zenbook 14
            ('Ordinateur portable', 'Asus', 'Zenbook 14',
             'Bleu', '14 pouces', 1.28, 512),

            ('Ordinateur portable', 'Asus', 'Zenbook 14',
             'Gris', '14 pouces', 1.28, 1024),


            -- =====================================================
            -- CASQUES BLUETOOTH
            -- =====================================================

            -- Sony WH-1000XM5
            ('Casque Bluetooth', 'Sony', 'WH-1000XM5',
             'Noir', NULL, 0.250, NULL),

            ('Casque Bluetooth', 'Sony', 'WH-1000XM5',
             'Argent', NULL, 0.250, NULL),

            -- Bose QuietComfort Ultra
            ('Casque Bluetooth', 'Bose', 'QuietComfort Ultra',
             'Noir', NULL, 0.240, NULL),

            ('Casque Bluetooth', 'Bose', 'QuietComfort Ultra',
             'Blanc', NULL, 0.240, NULL),

            -- Apple AirPods Max
            ('Casque Bluetooth', 'Apple', 'AirPods Max',
             'Gris sidéral', NULL, 0.386, NULL),

            ('Casque Bluetooth', 'Apple', 'AirPods Max',
             'Bleu', NULL, 0.386, NULL),

            -- JBL Tour One M2
            ('Casque Bluetooth', 'JBL', 'Tour One M2',
             'Noir', NULL, 0.278, NULL),

            ('Casque Bluetooth', 'JBL', 'Tour One M2',
             'Champagne', NULL, 0.278, NULL),


            -- =====================================================
            -- TÉLÉVISEURS 4K
            -- =====================================================

            -- LG OLED evo C4
            ('Téléviseur 4K', 'LG', 'OLED evo C4',
             'Noir', '55 pouces', 16.8, NULL),

            ('Téléviseur 4K', 'LG', 'OLED evo C4',
             'Noir', '65 pouces', 22.6, NULL),

            -- Samsung Neo QLED QN90D
            ('Téléviseur 4K', 'Samsung', 'Neo QLED QN90D',
             'Noir', '55 pouces', 20.1, NULL),

            ('Téléviseur 4K', 'Samsung', 'Neo QLED QN90D',
             'Noir', '65 pouces', 28.4, NULL),

            -- Sony BRAVIA 8
            ('Téléviseur 4K', 'Sony', 'BRAVIA 8',
             'Noir', '55 pouces', 18.5, NULL),

            ('Téléviseur 4K', 'Sony', 'BRAVIA 8',
             'Noir', '65 pouces', 26.3, NULL),

            -- TCL C855
            ('Téléviseur 4K', 'TCL', 'C855',
             'Noir', '55 pouces', 15.7, NULL),

            ('Téléviseur 4K', 'TCL', 'C855',
             'Noir', '65 pouces', 24.8, NULL)

    ) AS v(
        type_produit,
        marque,
        modele,
        couleur,
        taille,
        poids_kg,
        capacite_stockage_go
    )
),
fournisseurs_produits AS (
    SELECT *
    FROM (
        VALUES
            ('Samsung', 'Ingram Micro'),
            ('Apple',   'TD SYNNEX'),
            ('Google',  'Ingram Micro'),
            ('Xiaomi',  'Esprinet'),
            ('Lenovo',  'TD SYNNEX'),
            ('Dell',    'Arrow Electronics'),
            ('HP',      'Ingram Micro'),
            ('Asus',    'Esprinet'),
            ('Sony',    'Exertis'),
            ('Bose',    'Ingram Micro'),
            ('JBL',     'Exertis'),
            ('LG',      'TD SYNNEX'),
            ('TCL',     'Exertis')
    ) AS f(marque, fournisseur)
),
gammes_produits AS (
    SELECT *
    FROM (
        VALUES
            -- SMARTPHONES
            ('Smartphone', 'Samsung', 'Galaxy S25', 'Haut de gamme'),
            ('Smartphone', 'Apple', 'iPhone 16', 'Haut de gamme'),
            ('Smartphone', 'Google', 'Pixel 9', 'Haut de gamme'),
            ('Smartphone', 'Xiaomi', 'Xiaomi 15', 'Haut de gamme'),

            -- ORDINATEURS PORTABLES
            ('Ordinateur portable', 'Lenovo', 'ThinkPad E14', 'Milieu de gamme'),
            ('Ordinateur portable', 'Dell', 'XPS 13', 'Premium'),
            ('Ordinateur portable', 'HP', 'Pavilion 15', 'Milieu de gamme'),
            ('Ordinateur portable', 'Asus', 'Zenbook 14', 'Haut de gamme'),

            -- CASQUES BLUETOOTH
            ('Casque Bluetooth', 'Sony', 'WH-1000XM5', 'Haut de gamme'),
            ('Casque Bluetooth', 'Bose', 'QuietComfort Ultra', 'Premium'),
            ('Casque Bluetooth', 'Apple', 'AirPods Max', 'Premium'),
            ('Casque Bluetooth', 'JBL', 'Tour One M2', 'Haut de gamme'),

            -- TÉLÉVISEURS 4K
            ('Téléviseur 4K', 'LG', 'OLED evo C4', 'Haut de gamme'),
            ('Téléviseur 4K', 'Samsung', 'Neo QLED QN90D', 'Premium'),
            ('Téléviseur 4K', 'Sony', 'BRAVIA 8', 'Haut de gamme'),
            ('Téléviseur 4K', 'TCL', 'C855', 'Milieu de gamme')

    ) AS gp(type_produit, marque, modele, gamme)
),
prix_produits AS (
    SELECT *
    FROM (
        VALUES
            -- =====================================================
            -- SMARTPHONES
            -- =====================================================
            ('Smartphone', 'Samsung', 'Galaxy S25', 128, NULL, 899.00),
            ('Smartphone', 'Samsung', 'Galaxy S25', 256, NULL, 959.00),

            ('Smartphone', 'Apple', 'iPhone 16', 128, NULL, 969.00),
            ('Smartphone', 'Apple', 'iPhone 16', 256, NULL, 1099.00),

            ('Smartphone', 'Google', 'Pixel 9', 128, NULL, 899.00),
            ('Smartphone', 'Google', 'Pixel 9', 256, NULL, 999.00),

            ('Smartphone', 'Xiaomi', 'Xiaomi 15', 256, NULL, 999.00),
            ('Smartphone', 'Xiaomi', 'Xiaomi 15', 512, NULL, 1099.00),

            -- =====================================================
            -- ORDINATEURS PORTABLES
            -- =====================================================
            -- ORDINATEURS PORTABLES
			('Ordinateur portable', 'Lenovo', 'ThinkPad E14', 512, '14 pouces', 849.00),
			('Ordinateur portable', 'Lenovo', 'ThinkPad E14', 1024, '14 pouces', 999.00),
			('Ordinateur portable', 'Dell', 'XPS 13', 512, '13 pouces', 1399.00),
			('Ordinateur portable', 'Dell', 'XPS 13', 1024, '13 pouces', 1599.00),
			('Ordinateur portable', 'HP', 'Pavilion 15', 512, '15.6 pouces', 749.00),
			('Ordinateur portable', 'HP', 'Pavilion 15', 1024, '15.6 pouces', 899.00),
			('Ordinateur portable', 'Asus', 'Zenbook 14', 512, '14 pouces', 1099.00),
			('Ordinateur portable', 'Asus', 'Zenbook 14', 1024, '14 pouces', 1299.00),
            -- =====================================================
            -- CASQUES BLUETOOTH
            -- =====================================================
            ('Casque Bluetooth', 'Sony', 'WH-1000XM5', NULL, NULL, 399.00),
            ('Casque Bluetooth', 'Bose', 'QuietComfort Ultra', NULL, NULL, 449.00),
            ('Casque Bluetooth', 'Apple', 'AirPods Max', NULL, NULL, 579.00),
            ('Casque Bluetooth', 'JBL', 'Tour One M2', NULL, NULL, 299.00),

            -- =====================================================
            -- TÉLÉVISEURS 4K
            -- =====================================================
            ('Téléviseur 4K', 'LG', 'OLED evo C4', NULL, '55 pouces', 1499.00),
            ('Téléviseur 4K', 'LG', 'OLED evo C4', NULL, '65 pouces', 1999.00),

            ('Téléviseur 4K', 'Samsung', 'Neo QLED QN90D', NULL, '55 pouces', 1599.00),
            ('Téléviseur 4K', 'Samsung', 'Neo QLED QN90D', NULL, '65 pouces', 2199.00),

            ('Téléviseur 4K', 'Sony', 'BRAVIA 8', NULL, '55 pouces', 1699.00),
            ('Téléviseur 4K', 'Sony', 'BRAVIA 8', NULL, '65 pouces', 2299.00),

            ('Téléviseur 4K', 'TCL', 'C855', NULL, '55 pouces', 999.00),
            ('Téléviseur 4K', 'TCL', 'C855', NULL, '65 pouces', 1399.00)

    ) AS p(
        type_produit,
        marque,
        modele,
        capacite_stockage_go,
        taille,
        prix_catalogue
    )
)

INSERT INTO dim_produit (
    code_produit,
    nom_produit,
    type_produit,
    categorie,
    sous_categorie,
    marque,
    modele,
    fournisseur,
    couleur,
    taille,
    poids_kg,
    capacite_stockage_go,
    gamme,
    saison,
    prix_catalogue
)
SELECT
    'PROD-' || LPAD(
        ROW_NUMBER() OVER (
            ORDER BY
                tp.categorie,
                mp.type_produit,
                mp.marque,
                mp.modele,
                vp.capacite_stockage_go,
                vp.taille,
                vp.couleur
        )::TEXT,
        3,
        '0'
    ) AS code_produit,

    TRIM(
        COALESCE(TRIM(mp.marque), '') || ' ' ||
        COALESCE(TRIM(mp.modele), '') || ' ' ||
        COALESCE(vp.capacite_stockage_go::TEXT || ' Go ', '') ||
        COALESCE(vp.taille::TEXT || ' ', '') ||
        COALESCE(TRIM(vp.couleur), '')
    ) AS nom_produit,

    tp.type_produit,
    tp.categorie,
    tp.sous_categorie,
    mp.marque,
    mp.modele,
    fp.fournisseur,
    vp.couleur,
    vp.taille,
    vp.poids_kg,
    vp.capacite_stockage_go,
    gp.gamme,
    NULL::VARCHAR(100) AS saison,
    pp.prix_catalogue

FROM types_produits tp

INNER JOIN modeles_produits mp
    ON tp.type_produit = mp.type_produit

LEFT JOIN variantes_produits vp
    ON mp.type_produit = vp.type_produit
    AND mp.marque = vp.marque
    AND mp.modele = vp.modele

LEFT JOIN fournisseurs_produits fp
    ON mp.marque = fp.marque

LEFT JOIN gammes_produits gp
    ON mp.type_produit = gp.type_produit
    AND mp.marque = gp.marque
    AND mp.modele = gp.modele

LEFT JOIN prix_produits pp
    ON mp.type_produit = pp.type_produit
    AND mp.marque = pp.marque
    AND mp.modele = pp.modele
    AND vp.capacite_stockage_go
        IS NOT DISTINCT FROM pp.capacite_stockage_go
    AND vp.taille
        IS NOT DISTINCT FROM pp.taille;



------------------------------------------------------------------------------
--- Script pour générer des données de la table dim_magasin
------------------------------------------------------------------------------
WITH magasins AS (
    SELECT *
    FROM (
        VALUES
            ('MAG-001', 'NovaRetail Paris République',
             'Boutique', DATE '2018-03-15', 850.00,
             'Paris', 'Paris', 'Île-de-France'),

            ('MAG-002', 'NovaRetail Paris La Défense',
             'Centre commercial', DATE '2019-09-10', 1450.00,
             'Puteaux', 'Hauts-de-Seine', 'Île-de-France'),

            ('MAG-003', 'NovaRetail Lyon Part-Dieu',
             'Centre commercial', DATE '2017-06-20', 1300.00,
             'Lyon', 'Rhône', 'Auvergne-Rhône-Alpes'),

            ('MAG-004', 'NovaRetail Marseille Prado',
             'Centre commercial', DATE '2020-02-12', 1150.00,
             'Marseille', 'Bouches-du-Rhône', 'Provence-Alpes-Côte d''Azur'),

            ('MAG-005', 'NovaRetail Lille Centre',
             'Boutique', DATE '2016-11-05', 780.00,
             'Lille', 'Nord', 'Hauts-de-France'),

            ('MAG-006', 'NovaRetail Bordeaux Lac',
             'Centre commercial', DATE '2021-04-17', 1250.00,
             'Bordeaux', 'Gironde', 'Nouvelle-Aquitaine'),

            ('MAG-007', 'NovaRetail Toulouse Centre',
             'Boutique', DATE '2019-01-25', 920.00,
             'Toulouse', 'Haute-Garonne', 'Occitanie'),

            ('MAG-008', 'NovaRetail Nantes Atlantis',
             'Centre commercial', DATE '2018-08-30', 1100.00,
             'Saint-Herblain', 'Loire-Atlantique', 'Pays de la Loire'),

            ('MAG-009', 'NovaRetail Strasbourg Centre',
             'Boutique', DATE '2022-05-14', 760.00,
             'Strasbourg', 'Bas-Rhin', 'Grand Est'),

            ('MAG-010', 'NovaRetail Entrepôt Logistique',
             'Entrepôt', DATE '2015-10-01', 4500.00,
             'Orléans', 'Loiret', 'Centre-Val de Loire')
    ) AS m(
        code_magasin,
        nom_magasin,
        type_magasin,
        date_ouverture,
        surface_m2,
        ville,
        departement,
        region
    )
)

INSERT INTO dim_magasin (
    code_magasin,
    nom_magasin,
    type_magasin,
    date_ouverture,
    surface_m2,
    ville,
    departement,
    region
)
SELECT
    code_magasin,
    nom_magasin,
    type_magasin,
    date_ouverture,
    surface_m2,
    ville,
    departement,
    region
FROM magasins;


------------------------------------------------------------------------------
-- script pour générer des données de la table dim_commercial
------------------------------------------------------------------------------


WITH commerciaux AS (
    SELECT *
    FROM (
        VALUES
            ('COM-001', 'Lefèvre', 'Julien',   'Équipe Nord',  DATE '2017-03-15', 'Sophie Martin'),
            ('COM-002', 'Moreau', 'Camille',   'Équipe Nord',  DATE '2019-06-10', 'Sophie Martin'),
            ('COM-003', 'Dubois', 'Nicolas',   'Équipe Nord',  DATE '2020-09-21', 'Sophie Martin'),
            ('COM-004', 'Fontaine', 'Élodie',  'Équipe Nord',  DATE '2022-02-07', 'Sophie Martin'),
            ('COM-005', 'Lambert', 'Thomas',   'Équipe Nord',  DATE '2023-05-15', 'Sophie Martin'),

            ('COM-006', 'Garcia', 'Laura',      'Équipe Sud',   DATE '2016-11-03', 'Thomas Bernard'),
            ('COM-007', 'Roux', 'Alexandre',   'Équipe Sud',   DATE '2018-07-18', 'Thomas Bernard'),
            ('COM-008', 'Fournier', 'Manon',   'Équipe Sud',   DATE '2020-01-13', 'Thomas Bernard'),
            ('COM-009', 'Girard', 'Hugo',       'Équipe Sud',   DATE '2021-10-04', 'Thomas Bernard'),
            ('COM-010', 'Bonnet', 'Chloé',      'Équipe Sud',   DATE '2024-01-08', 'Thomas Bernard'),

            ('COM-011', 'Mercier', 'Antoine',   'Équipe Ouest', DATE '2017-08-28', 'Claire Robert'),
            ('COM-012', 'Blanc', 'Sarah',       'Équipe Ouest', DATE '2019-04-01', 'Claire Robert'),
            ('COM-013', 'Guerin', 'Maxime',     'Équipe Ouest', DATE '2020-11-16', 'Claire Robert'),
            ('COM-014', 'Chevalier', 'Julie',   'Équipe Ouest', DATE '2022-06-20', 'Claire Robert'),
            ('COM-015', 'Robin', 'Lucas',       'Équipe Ouest', DATE '2023-09-11', 'Claire Robert')
    ) AS c(
        code_commercial,
        nom_commercial,
        prenom_commercial,
        equipe,
        date_recrutement,
        manager
    )
)

INSERT INTO dim_commercial (
    code_commercial,
    nom_commercial,
    prenom_commercial,
    equipe,
    date_recrutement,
    manager
)
SELECT
    code_commercial,
    nom_commercial,
    prenom_commercial,
    equipe,
    date_recrutement,
    manager
FROM commerciaux;


/* =============================================================================
   DIM_CLIENT - Génération et insertion des données clients
   -----------------------------------------------------------------------------
   Objectif :
   - Générer un jeu de 200 clients fictifs pour le projet NovaRetail BI.
   - Construire des données cohérentes pour les analyses démographiques,
     géographiques et commerciales.
   - Alimenter la dimension dim_client.
   ============================================================================= */

WITH

/* -----------------------------------------------------------------------------
   1. Génération de la population client
   -----------------------------------------------------------------------------
   Création de 200 identifiants techniques temporaires.
   numero_client est utilisé uniquement pour générer de manière déterministe
   les différents attributs des clients.
   ----------------------------------------------------------------------------- */
clients_base AS (
    SELECT
        generate_series(1, 200) AS numero_client
),

/* -----------------------------------------------------------------------------
   2. Référentiel des noms
   -----------------------------------------------------------------------------
   Liste de noms utilisée pour construire les identités fictives.
   L'identifiant permet d'associer les noms aux clients par calcul modulo.
   ----------------------------------------------------------------------------- */
noms AS (
    SELECT *
    FROM (
        VALUES
            (1, 'Martin'),
            (2, 'Bernard'),
            (3, 'Thomas'),
            (4, 'Robert'),
            (5, 'Richard'),
            (6, 'Petit'),
            (7, 'Durand'),
            (8, 'Leroy'),
            (9, 'Moreau'),
            (10, 'Simon')
    ) AS n(id_nom, nom)
),

/* -----------------------------------------------------------------------------
   3. Référentiel des prénoms féminins
   ----------------------------------------------------------------------------- */
prenoms_femmes AS (
    SELECT *
    FROM (
        VALUES
            (1, 'Emma'),
            (2, 'Louise'),
            (3, 'Chloé'),
            (4, 'Camille'),
            (5, 'Manon'),
            (6, 'Sarah'),
            (7, 'Julie'),
            (8, 'Laura'),
            (9, 'Élodie'),
            (10, 'Clara')
    ) AS pf(id_prenom, prenom)
),

/* -----------------------------------------------------------------------------
   4. Référentiel des prénoms masculins
   ----------------------------------------------------------------------------- */
prenoms_hommes AS (
    SELECT *
    FROM (
        VALUES
            (1, 'Lucas'),
            (2, 'Hugo'),
            (3, 'Arthur'),
            (4, 'Nicolas'),
            (5, 'Julien'),
            (6, 'Antoine'),
            (7, 'Maxime'),
            (8, 'Alexandre'),
            (9, 'Louis'),
            (10, 'Gabriel')
    ) AS ph(id_prenom, prenom)
),

/* -----------------------------------------------------------------------------
   5. Référentiel des professions
   -----------------------------------------------------------------------------
   Création de profils professionnels variés permettant notamment de réaliser
   des segmentations clients dans les futures analyses Power BI.
   ----------------------------------------------------------------------------- */
professions AS (
    SELECT *
    FROM (
        VALUES
            (1, 'Cadre'),
            (2, 'Employé'),
            (3, 'Technicien'),
            (4, 'Enseignant'),
            (5, 'Commerçant'),
            (6, 'Ingénieur'),
            (7, 'Profession libérale'),
            (8, 'Etudiant'),
            (9, 'Retraité'),
            (10, 'Sans activité')
    ) AS p(id_profession, profession)
),

/* -----------------------------------------------------------------------------
   6. Référentiel géographique
   -----------------------------------------------------------------------------
   Association ville / département / région.
   Ce référentiel garantit la cohérence géographique des données clients et
   permettra des analyses commerciales par zone géographique.
   ----------------------------------------------------------------------------- */
localisations AS (
    SELECT *
    FROM (
        VALUES
            (1, 'Paris', 'Paris', 'Île-de-France'),
            (2, 'Boulogne-Billancourt', 'Hauts-de-Seine', 'Île-de-France'),
            (3, 'Lyon', 'Rhône', 'Auvergne-Rhône-Alpes'),
            (4, 'Marseille', 'Bouches-du-Rhône', 'Provence-Alpes-Côte d''Azur'),
            (5, 'Lille', 'Nord', 'Hauts-de-France'),
            (6, 'Bordeaux', 'Gironde', 'Nouvelle-Aquitaine'),
            (7, 'Toulouse', 'Haute-Garonne', 'Occitanie'),
            (8, 'Nantes', 'Loire-Atlantique', 'Pays de la Loire'),
            (9, 'Strasbourg', 'Bas-Rhin', 'Grand Est'),
            (10, 'Orléans', 'Loiret', 'Centre-Val de Loire')
    ) AS l(id_localisation, ville, departement, region)
)

/* =============================================================================
   7. Alimentation de la dimension client
   -----------------------------------------------------------------------------
   Les données générées à partir des différents référentiels sont insérées
   dans dim_client.

   id_client n'est pas renseigné : il est généré automatiquement par PostgreSQL
   grâce à la colonne IDENTITY définie dans schema.sql.
   ============================================================================= */

INSERT INTO dim_client (
    code_client,
    nom_client,
    prenom_client,
    sexe,
    date_inscription,
    date_naissance,
    profession,
    ville,
    departement,
    region
)

SELECT

    /* -------------------------------------------------------------------------
       Génération d'un code client unique au format CLI-001 à CLI-200
       ------------------------------------------------------------------------- */
    'CLI-' || LPAD(numero_client::TEXT, 3, '0') AS code_client,

    /* Nom du client issu du référentiel des noms */
    n.nom AS nom_client,

    /* -------------------------------------------------------------------------
       Attribution du prénom selon le sexe :
       - numéro pair   -> prénom féminin
       - numéro impair -> prénom masculin
       ------------------------------------------------------------------------- */
    CASE
        WHEN cb.numero_client % 2 = 0 THEN pf.prenom
        ELSE ph.prenom
    END AS prenom_client,

    /* Attribution du sexe selon la même règle de parité */
    CASE
        WHEN cb.numero_client % 2 = 0 THEN 'F'
        ELSE 'M'
    END AS sexe,

    /* -------------------------------------------------------------------------
       Génération de la date d'inscription
       Répartition des inscriptions entre 2018 et 2025.
       MAKE_DATE permet de construire directement une date valide.
       ------------------------------------------------------------------------- */
    MAKE_DATE(
        2018 + ((cb.numero_client * 5) % 8),
        1 + ((cb.numero_client * 7) % 12),
        1 + ((cb.numero_client * 11) % 28)
    ) AS date_inscription,

    /* -------------------------------------------------------------------------
       Génération de la date de naissance
       Répartition des dates entre 1955 et 2004.
       Le jour est limité à 28 afin de garantir une date valide quel que soit
       le mois généré.
       ------------------------------------------------------------------------- */
    MAKE_DATE(
        1955 + ((cb.numero_client * 17) % 50),
        1 + ((cb.numero_client * 7) % 12),
        1 + ((cb.numero_client * 11) % 28)
    ) AS date_naissance,

    /* Attributs complémentaires */
    p.profession,
    l.ville,
    l.departement,
    l.region

FROM clients_base cb

/* -----------------------------------------------------------------------------
   8. Association d'un nom au client
   -----------------------------------------------------------------------------
   Le modulo permet de réutiliser les 10 noms pour les 200 clients.
   ----------------------------------------------------------------------------- */
LEFT JOIN noms n
    ON n.id_nom = ((cb.numero_client - 1) % 10) + 1

/* -----------------------------------------------------------------------------
   9. Association des prénoms masculins
   -----------------------------------------------------------------------------
   La formule fait varier l'identifiant du prénom au fil des blocs de clients
   afin d'éviter une correspondance totalement fixe nom/prénom.
   ----------------------------------------------------------------------------- */
LEFT JOIN prenoms_hommes ph
    ON ph.id_prenom =
       (((cb.numero_client - 1) / 10 + cb.numero_client - 1) % 10) + 1

/* Même principe pour les prénoms féminins */
LEFT JOIN prenoms_femmes pf
    ON pf.id_prenom =
       (((cb.numero_client - 1) / 10 + cb.numero_client - 1) % 10) + 1

/* -----------------------------------------------------------------------------
   10. Attribution de la profession
   ----------------------------------------------------------------------------- */
LEFT JOIN professions p
    ON p.id_profession = ((cb.numero_client - 1) % 10) + 1

/* -----------------------------------------------------------------------------
   11. Attribution de la localisation
   -----------------------------------------------------------------------------
   Utilisation d'une formule différente de celle de la profession afin de
   limiter une correspondance systématique entre profession et localisation.
   ----------------------------------------------------------------------------- */
LEFT JOIN localisations l
    ON l.id_localisation =
       (((cb.numero_client - 1) / 10 + cb.numero_client - 1) % 10) + 1;


-- ============================================================
-- DIM_PRODUIT - PRODUITS COMPLÉMENTAIRES
-- ============================================================
-- Objectif :
-- Compléter le catalogue initial avec des produits appartenant
-- aux catégories Mode, Beauté, Maison, Alimentation et Loisirs.
--
-- Étapes :
-- 1. Définition des références complémentaires
-- 2. Enrichissement avec catégorie / sous-catégorie
-- 3. Attribution des fournisseurs
-- 4. Génération des codes et noms produits
-- 5. Insertion dans dim_produit
-- ============================================================
WITH types_produits AS (
    SELECT *
    FROM (
        VALUES
            ('Smartphone', 'Électronique', 'Téléphonie mobile'),
            ('Ordinateur portable', 'Électronique', 'Informatique'),
            ('Casque Bluetooth', 'Électronique', 'Audio'),
            ('Téléviseur 4K', 'Électronique', 'TV & vidéo'),

            ('Baskets', 'Mode & habillement', 'Chaussures'),
            ('Jean', 'Mode & habillement', 'Vêtements'),
            ('Sac à main', 'Mode & habillement', 'Accessoires'),
            ('Veste', 'Mode & habillement', 'Vêtements'),

            ('Shampoing', 'Beauté & hygiène', 'Soins capillaires'),
            ('Crème hydratante', 'Beauté & hygiène', 'Soins du visage'),
            ('Parfum', 'Beauté & hygiène', 'Parfumerie'),
            ('Rouge à lèvres', 'Beauté & hygiène', 'Maquillage'),

            ('Canapé', 'Maison & décoration', 'Mobilier'),
            ('Lampe de bureau', 'Maison & décoration', 'Éclairage'),
            ('Draps de lit', 'Maison & décoration', 'Linge de maison'),

            ('Tablette de chocolat', 'Alimentation', 'Confiserie'),
            ('Jus d''orange', 'Alimentation', 'Boissons'),
            ('Paquet de pâtes', 'Alimentation', 'Épicerie'),
            ('Café moulu', 'Alimentation', 'Épicerie'),
            ('Biscuits', 'Alimentation', 'Biscuits & snacks'),

            ('Console de jeux', 'Jeux & loisirs', 'Jeux vidéo'),
            ('Peluche', 'Jeux & loisirs', 'Jouets'),
            ('Jeu de société', 'Jeux & loisirs', 'Jeux de société'),
            ('Ballon de football', 'Jeux & loisirs', 'Sport & plein air')
    ) AS t(type_produit, categorie, sous_categorie)
),
modeles_produits AS (
    SELECT *
    FROM (
		VALUES
			('Smartphone', 'Samsung', 'Galaxy S25'),
			('Smartphone', 'Apple', 'iPhone 16'),
			('Smartphone', 'Google', 'Pixel 9'),
			('Smartphone', 'Xiaomi', 'Xiaomi 15'),

			('Ordinateur portable', 'Lenovo', 'ThinkPad E14'),
			('Ordinateur portable', 'Dell', 'XPS 13'),
			('Ordinateur portable', 'HP', 'Pavilion 15'),
			('Ordinateur portable', 'Asus', 'Zenbook 14'),

			('Casque Bluetooth', 'Sony', 'WH-1000XM5'),
			('Casque Bluetooth', 'Bose', 'QuietComfort Ultra'),
			('Casque Bluetooth', 'Apple', 'AirPods Max'),
			('Casque Bluetooth', 'JBL', 'Tour One M2'),

			('Téléviseur 4K', 'LG', 'OLED evo C4'),
			('Téléviseur 4K', 'Samsung', 'Neo QLED QN90D'),
			('Téléviseur 4K', 'Sony', 'BRAVIA 8'),
			('Téléviseur 4K', 'TCL', 'C855')
	) AS m(type_produit, marque, modele)
),
variantes_produits AS (
    SELECT *
    FROM (
        VALUES
            -- =====================================================
            -- SMARTPHONES
            -- =====================================================

            -- Samsung Galaxy S25
            ('Smartphone', 'Samsung', 'Galaxy S25',
             'Noir', NULL, 0.162, 128),

            ('Smartphone', 'Samsung', 'Galaxy S25',
             'Bleu', NULL, 0.162, 256),

            -- Apple iPhone 16
            ('Smartphone', 'Apple', 'iPhone 16',
             'Noir', NULL, 0.170, 128),

            ('Smartphone', 'Apple', 'iPhone 16',
             'Blanc', NULL, 0.170, 256),

            -- Google Pixel 9
            ('Smartphone', 'Google', 'Pixel 9',
             'Noir', NULL, 0.198, 128),

            ('Smartphone', 'Google', 'Pixel 9',
             'Vert', NULL, 0.198, 256),

            -- Xiaomi 15
            ('Smartphone', 'Xiaomi', 'Xiaomi 15',
             'Noir', NULL, 0.191, 256),

            ('Smartphone', 'Xiaomi', 'Xiaomi 15',
             'Vert', NULL, 0.191, 512),


            -- =====================================================
            -- ORDINATEURS PORTABLES
            -- =====================================================

            -- Lenovo ThinkPad E14
            ('Ordinateur portable', 'Lenovo', 'ThinkPad E14',
             'Noir', '14 pouces', 1.59, 512),

            ('Ordinateur portable', 'Lenovo', 'ThinkPad E14',
             'Noir', '14 pouces', 1.59, 1024),

            -- Dell XPS 13
            ('Ordinateur portable', 'Dell', 'XPS 13',
             'Argent', '13 pouces', 1.17, 512),

            ('Ordinateur portable', 'Dell', 'XPS 13',
             'Noir', '13 pouces', 1.17, 1024),

            -- HP Pavilion 15
            ('Ordinateur portable', 'HP', 'Pavilion 15',
             'Argent', '15.6 pouces', 1.75, 512),

            ('Ordinateur portable', 'HP', 'Pavilion 15',
             'Bleu', '15.6 pouces', 1.75, 1024),

            -- Asus Zenbook 14
            ('Ordinateur portable', 'Asus', 'Zenbook 14',
             'Bleu', '14 pouces', 1.28, 512),

            ('Ordinateur portable', 'Asus', 'Zenbook 14',
             'Gris', '14 pouces', 1.28, 1024),


            -- =====================================================
            -- CASQUES BLUETOOTH
            -- =====================================================

            -- Sony WH-1000XM5
            ('Casque Bluetooth', 'Sony', 'WH-1000XM5',
             'Noir', NULL, 0.250, NULL),

            ('Casque Bluetooth', 'Sony', 'WH-1000XM5',
             'Argent', NULL, 0.250, NULL),

            -- Bose QuietComfort Ultra
            ('Casque Bluetooth', 'Bose', 'QuietComfort Ultra',
             'Noir', NULL, 0.240, NULL),

            ('Casque Bluetooth', 'Bose', 'QuietComfort Ultra',
             'Blanc', NULL, 0.240, NULL),

            -- Apple AirPods Max
            ('Casque Bluetooth', 'Apple', 'AirPods Max',
             'Gris sidéral', NULL, 0.386, NULL),

            ('Casque Bluetooth', 'Apple', 'AirPods Max',
             'Bleu', NULL, 0.386, NULL),

            -- JBL Tour One M2
            ('Casque Bluetooth', 'JBL', 'Tour One M2',
             'Noir', NULL, 0.278, NULL),

            ('Casque Bluetooth', 'JBL', 'Tour One M2',
             'Champagne', NULL, 0.278, NULL),


            -- =====================================================
            -- TÉLÉVISEURS 4K
            -- =====================================================

            -- LG OLED evo C4
            ('Téléviseur 4K', 'LG', 'OLED evo C4',
             'Noir', '55 pouces', 16.8, NULL),

            ('Téléviseur 4K', 'LG', 'OLED evo C4',
             'Noir', '65 pouces', 22.6, NULL),

            -- Samsung Neo QLED QN90D
            ('Téléviseur 4K', 'Samsung', 'Neo QLED QN90D',
             'Noir', '55 pouces', 20.1, NULL),

            ('Téléviseur 4K', 'Samsung', 'Neo QLED QN90D',
             'Noir', '65 pouces', 28.4, NULL),

            -- Sony BRAVIA 8
            ('Téléviseur 4K', 'Sony', 'BRAVIA 8',
             'Noir', '55 pouces', 18.5, NULL),

            ('Téléviseur 4K', 'Sony', 'BRAVIA 8',
             'Noir', '65 pouces', 26.3, NULL),

            -- TCL C855
            ('Téléviseur 4K', 'TCL', 'C855',
             'Noir', '55 pouces', 15.7, NULL),

            ('Téléviseur 4K', 'TCL', 'C855',
             'Noir', '65 pouces', 24.8, NULL)

    ) AS v(
        type_produit,
        marque,
        modele,
        couleur,
        taille,
        poids_kg,
        capacite_stockage_go
    )
),
fournisseurs_produits AS (
    SELECT *
    FROM (
        VALUES
            ('Samsung', 'Ingram Micro'),
            ('Apple',   'TD SYNNEX'),
            ('Google',  'Ingram Micro'),
            ('Xiaomi',  'Esprinet'),
            ('Lenovo',  'TD SYNNEX'),
            ('Dell',    'Arrow Electronics'),
            ('HP',      'Ingram Micro'),
            ('Asus',    'Esprinet'),
            ('Sony',    'Exertis'),
            ('Bose',    'Ingram Micro'),
            ('JBL',     'Exertis'),
            ('LG',      'TD SYNNEX'),
            ('TCL',     'Exertis')
    ) AS f(marque, fournisseur)
),
gammes_produits AS (
    SELECT *
    FROM (
        VALUES
            -- SMARTPHONES
            ('Smartphone', 'Samsung', 'Galaxy S25', 'Haut de gamme'),
            ('Smartphone', 'Apple', 'iPhone 16', 'Haut de gamme'),
            ('Smartphone', 'Google', 'Pixel 9', 'Haut de gamme'),
            ('Smartphone', 'Xiaomi', 'Xiaomi 15', 'Haut de gamme'),

            -- ORDINATEURS PORTABLES
            ('Ordinateur portable', 'Lenovo', 'ThinkPad E14', 'Milieu de gamme'),
            ('Ordinateur portable', 'Dell', 'XPS 13', 'Premium'),
            ('Ordinateur portable', 'HP', 'Pavilion 15', 'Milieu de gamme'),
            ('Ordinateur portable', 'Asus', 'Zenbook 14', 'Haut de gamme'),

            -- CASQUES BLUETOOTH
            ('Casque Bluetooth', 'Sony', 'WH-1000XM5', 'Haut de gamme'),
            ('Casque Bluetooth', 'Bose', 'QuietComfort Ultra', 'Premium'),
            ('Casque Bluetooth', 'Apple', 'AirPods Max', 'Premium'),
            ('Casque Bluetooth', 'JBL', 'Tour One M2', 'Haut de gamme'),

            -- TÉLÉVISEURS 4K
            ('Téléviseur 4K', 'LG', 'OLED evo C4', 'Haut de gamme'),
            ('Téléviseur 4K', 'Samsung', 'Neo QLED QN90D', 'Premium'),
            ('Téléviseur 4K', 'Sony', 'BRAVIA 8', 'Haut de gamme'),
            ('Téléviseur 4K', 'TCL', 'C855', 'Milieu de gamme')

    ) AS gp(type_produit, marque, modele, gamme)
),
prix_produits AS (
    SELECT *
    FROM (
        VALUES
            -- =====================================================
            -- SMARTPHONES
            -- =====================================================
            ('Smartphone', 'Samsung', 'Galaxy S25', 128, NULL, 899.00),
            ('Smartphone', 'Samsung', 'Galaxy S25', 256, NULL, 959.00),

            ('Smartphone', 'Apple', 'iPhone 16', 128, NULL, 969.00),
            ('Smartphone', 'Apple', 'iPhone 16', 256, NULL, 1099.00),

            ('Smartphone', 'Google', 'Pixel 9', 128, NULL, 899.00),
            ('Smartphone', 'Google', 'Pixel 9', 256, NULL, 999.00),

            ('Smartphone', 'Xiaomi', 'Xiaomi 15', 256, NULL, 999.00),
            ('Smartphone', 'Xiaomi', 'Xiaomi 15', 512, NULL, 1099.00),

            -- =====================================================
            -- ORDINATEURS PORTABLES
            -- =====================================================
            -- ORDINATEURS PORTABLES
			('Ordinateur portable', 'Lenovo', 'ThinkPad E14', 512, '14 pouces', 849.00),
			('Ordinateur portable', 'Lenovo', 'ThinkPad E14', 1024, '14 pouces', 999.00),
			('Ordinateur portable', 'Dell', 'XPS 13', 512, '13 pouces', 1399.00),
			('Ordinateur portable', 'Dell', 'XPS 13', 1024, '13 pouces', 1599.00),
			('Ordinateur portable', 'HP', 'Pavilion 15', 512, '15.6 pouces', 749.00),
			('Ordinateur portable', 'HP', 'Pavilion 15', 1024, '15.6 pouces', 899.00),
			('Ordinateur portable', 'Asus', 'Zenbook 14', 512, '14 pouces', 1099.00),
			('Ordinateur portable', 'Asus', 'Zenbook 14', 1024, '14 pouces', 1299.00),
            -- =====================================================
            -- CASQUES BLUETOOTH
            -- =====================================================
            ('Casque Bluetooth', 'Sony', 'WH-1000XM5', NULL, NULL, 399.00),
            ('Casque Bluetooth', 'Bose', 'QuietComfort Ultra', NULL, NULL, 449.00),
            ('Casque Bluetooth', 'Apple', 'AirPods Max', NULL, NULL, 579.00),
            ('Casque Bluetooth', 'JBL', 'Tour One M2', NULL, NULL, 299.00),

            -- =====================================================
            -- TÉLÉVISEURS 4K
            -- =====================================================
            ('Téléviseur 4K', 'LG', 'OLED evo C4', NULL, '55 pouces', 1499.00),
            ('Téléviseur 4K', 'LG', 'OLED evo C4', NULL, '65 pouces', 1999.00),

            ('Téléviseur 4K', 'Samsung', 'Neo QLED QN90D', NULL, '55 pouces', 1599.00),
            ('Téléviseur 4K', 'Samsung', 'Neo QLED QN90D', NULL, '65 pouces', 2199.00),

            ('Téléviseur 4K', 'Sony', 'BRAVIA 8', NULL, '55 pouces', 1699.00),
            ('Téléviseur 4K', 'Sony', 'BRAVIA 8', NULL, '65 pouces', 2299.00),

            ('Téléviseur 4K', 'TCL', 'C855', NULL, '55 pouces', 999.00),
            ('Téléviseur 4K', 'TCL', 'C855', NULL, '65 pouces', 1399.00)

    ) AS p(
        type_produit,
        marque,
        modele,
        capacite_stockage_go,
        taille,
        prix_catalogue
    )
),
produits_complementaires AS (
    SELECT *
    FROM (
        VALUES
            -- MODE & HABILLEMENT
            ('Baskets', 'Nike', 'Air Max', 'Noir', '42', 'Premium', 'Toutes saisons', 149.00),
            ('Baskets', 'Adidas', 'Stan Smith', 'Blanc', '42', 'Milieu de gamme', 'Toutes saisons', 109.00),

            ('Jean', 'Levi''s', '501', 'Bleu', 'M', 'Premium', 'Toutes saisons', 119.00),
            ('Jean', 'Lee', 'Regular Fit', 'Noir', 'M', 'Milieu de gamme', 'Toutes saisons', 79.00),

            ('Sac à main', 'Lancaster', 'City', 'Noir', NULL, 'Premium', 'Toutes saisons', 189.00),
            ('Sac à main', 'Fossil', 'Rachel', 'Marron', NULL, 'Milieu de gamme', 'Toutes saisons', 149.00),

            ('Veste', 'The North Face', 'Quest', 'Noir', 'M', 'Premium', 'Automne-Hiver', 139.00),
            ('Veste', 'Jack & Jones', 'Essentials', 'Bleu', 'M', 'Milieu de gamme', 'Automne-Hiver', 89.00),

            -- BEAUTÉ & HYGIÈNE
            ('Shampoing', 'L''Oréal', 'Elseve', NULL, NULL, 'Milieu de gamme', NULL, 6.90),
            ('Shampoing', 'Dove', 'Nutrition', NULL, NULL, 'Entrée de gamme', NULL, 4.90),

            ('Crème hydratante', 'Nivea', 'Soft', NULL, NULL, 'Entrée de gamme', NULL, 5.90),
            ('Crème hydratante', 'La Roche-Posay', 'Hydraphase', NULL, NULL, 'Premium', NULL, 24.90),

            ('Parfum', 'Dior', 'Sauvage', NULL, NULL, 'Premium', NULL, 109.00),
            ('Parfum', 'Lancôme', 'La Vie Est Belle', NULL, NULL, 'Premium', NULL, 99.00),

            ('Rouge à lèvres', 'Maybelline', 'SuperStay', 'Rouge', NULL, 'Milieu de gamme', NULL, 14.90),
            ('Rouge à lèvres', 'L''Oréal', 'Color Riche', 'Rose', NULL, 'Milieu de gamme', NULL, 15.90),

            -- MAISON & DÉCORATION
            ('Canapé', 'IKEA', 'KIVIK', 'Gris', NULL, 'Milieu de gamme', NULL, 599.00),
            ('Canapé', 'Maisons du Monde', 'Brooke', 'Beige', NULL, 'Premium', NULL, 899.00),

            ('Lampe de bureau', 'IKEA', 'TERTIAL', 'Noir', NULL, 'Entrée de gamme', NULL, 19.90),
            ('Lampe de bureau', 'Philips', 'LED Desk', 'Blanc', NULL, 'Milieu de gamme', NULL, 49.90),

            ('Draps de lit', 'IKEA', 'DVALA', 'Blanc', '240x220', 'Entrée de gamme', 'Toutes saisons', 29.90),
            ('Draps de lit', 'Essix', 'Percale', 'Bleu', '240x220', 'Premium', 'Toutes saisons', 89.00),

            -- ALIMENTATION
            ('Tablette de chocolat', 'Lindt', 'Excellence', NULL, NULL, 'Premium', NULL, 3.50),
            ('Tablette de chocolat', 'Milka', 'Lait', NULL, NULL, 'Entrée de gamme', NULL, 2.20),

            ('Jus d''orange', 'Tropicana', 'Pur Premium', NULL, NULL, 'Premium', NULL, 3.20),
            ('Jus d''orange', 'Joker', 'Pur Jus', NULL, NULL, 'Milieu de gamme', NULL, 2.60),

            ('Paquet de pâtes', 'Barilla', 'Spaghetti', NULL, NULL, 'Milieu de gamme', NULL, 2.30),
            ('Paquet de pâtes', 'Panzani', 'Penne', NULL, NULL, 'Milieu de gamme', NULL, 2.10),

            ('Café moulu', 'Lavazza', 'Qualità Rossa', NULL, NULL, 'Premium', NULL, 6.90),
            ('Café moulu', 'Carte Noire', 'Classique', NULL, NULL, 'Milieu de gamme', NULL, 5.90),

            ('Biscuits', 'LU', 'Petit Beurre', NULL, NULL, 'Milieu de gamme', NULL, 2.50),
            ('Biscuits', 'Oreo', 'Original', NULL, NULL, 'Milieu de gamme', NULL, 2.90),

            -- JEUX & LOISIRS
            ('Console de jeux', 'Sony', 'PlayStation 5', 'Blanc', NULL, 'Premium', NULL, 549.00),
            ('Console de jeux', 'Nintendo', 'Switch OLED', 'Blanc', NULL, 'Premium', NULL, 349.00),

            ('Peluche', 'Jemini', 'Ours', 'Marron', NULL, 'Entrée de gamme', NULL, 19.90),
            ('Peluche', 'Disney', 'Mickey', 'Noir', NULL, 'Milieu de gamme', NULL, 29.90),

            ('Jeu de société', 'Asmodee', 'Dobble', NULL, NULL, 'Milieu de gamme', NULL, 19.90),
            ('Jeu de société', 'Hasbro', 'Monopoly', NULL, NULL, 'Milieu de gamme', NULL, 29.90),

            ('Ballon de football', 'Adidas', 'Tiro', 'Blanc', NULL, 'Milieu de gamme', NULL, 24.90),
            ('Ballon de football', 'Nike', 'Academy', 'Blanc', NULL, 'Milieu de gamme', NULL, 29.90)

    ) AS p(
        type_produit,
        marque,
        modele,
        couleur,
        taille,
        gamme,
        saison,
        prix_catalogue
    )
),
produits_complementaires_enrichis AS (
    SELECT
        pc.type_produit,
        tp.categorie,
        tp.sous_categorie,
        pc.marque,
        pc.modele,
        pc.couleur,
        pc.taille,
        pc.gamme,
        pc.saison,
        pc.prix_catalogue

    FROM produits_complementaires pc

    INNER JOIN types_produits tp
        ON pc.type_produit = tp.type_produit
),
fournisseurs_categories AS (
    SELECT *
    FROM (
        VALUES
            ('Mode & habillement',    'Fashion Distribution'),
            ('Beauté & hygiène',      'Beauty Distribution'),
            ('Maison & décoration',   'Home Distribution'),
            ('Alimentation',          'Food Distribution'),
            ('Jeux & loisirs',        'Leisure Distribution')
    ) AS f(categorie, fournisseur)
),
produits_complets AS (
    SELECT
        pce.type_produit,
        pce.categorie,
        pce.sous_categorie,
        pce.marque,
        pce.modele,
        fc.fournisseur,
        pce.couleur,
        pce.taille,
        pce.gamme,
        pce.saison,
        pce.prix_catalogue

    FROM produits_complementaires_enrichis pce

    INNER JOIN fournisseurs_categories fc
        ON pce.categorie = fc.categorie
),

-- ============================================================
-- PRÉPARATION DES PRODUITS COMPLÉMENTAIRES POUR L'INSERTION
-- ============================================================
-- Les 32 premières références (PROD-001 à PROD-032)
-- sont insérées précédemment.
-- Les produits complémentaires commencent donc à PROD-033.

produits_prets_insertion AS (
    SELECT
        'PROD-' ||
        LPAD(
            (ROW_NUMBER() OVER (
                ORDER BY categorie, type_produit, marque, modele
            ) + 32)::TEXT,
            3,
            '0'
        ) AS code_produit,

        TRIM(
            marque || ' ' ||
            modele ||
            COALESCE(' ' || taille, '') ||
            COALESCE(' ' || couleur, '')
        ) AS nom_produit,

        type_produit,
        categorie,
        sous_categorie,
        marque,
        modele,
        fournisseur,
        couleur,
        taille,
        NULL::NUMERIC(10,3) AS poids_kg,
        NULL::INTEGER AS capacite_stockage_go,
        gamme,
        saison,
        prix_catalogue

    FROM produits_complets
)

INSERT INTO dim_produit (
    code_produit,
    nom_produit,
    type_produit,
    categorie,
    sous_categorie,
    marque,
    modele,
    fournisseur,
    couleur,
    taille,
    poids_kg,
    capacite_stockage_go,
    gamme,
    saison,
    prix_catalogue
)
SELECT
    code_produit,
    nom_produit,
    type_produit,
    categorie,
    sous_categorie,
    marque,
    modele,
    fournisseur,
    couleur,
    taille,
    poids_kg,
    capacite_stockage_go,
    gamme,
    saison,
    prix_catalogue
FROM produits_prets_insertion;



-- ============================================================
-- GÉNÉRATION DES TRANSACTIONS ET DES LIGNES DE VENTE
-- ============================================================
TRUNCATE TABLE fact_vente RESTART IDENTITY;

WITH transactions_base AS (
    SELECT
        generate_series(1, 10000) AS numero_vente
),
transactions_annees AS (
    SELECT
        numero_vente,
        'VTE-' || LPAD(numero_vente::TEXT, 5, '0') AS code_vente,

        CASE
            WHEN numero_vente < 2801 THEN 2023
            WHEN numero_vente <= 6100 THEN 2024
            ELSE 2025
        END AS annee_vente,

        ((numero_vente * 37 - 1) % 100) + 1 AS position_saison

    FROM transactions_base
),

-- Poids(%) des ventes mensuelles
saisonnalite_mensuelle AS (
	SELECT *
	    FROM (
	        VALUES
	            (1,  7),   -- Janvier
	            (2,  7),   -- Février
	            (3,  7),   -- Mars
	            (4,  7),   -- Avril
	            (5,  7),   -- Mai
	            (6,  7),   -- Juin
	            (7,  8),   -- Juillet
	            (8,  7),   -- Août
	            (9,  8),   -- Septembre
	            (10, 9),   -- Octobre
	            (11, 11),  -- Novembre
	            (12, 15)   -- Décembre
	    ) AS s(mois, poids)
),
saisonnalite_cumulee AS (
    SELECT
        mois,
        poids,
        SUM(poids) OVER (
            ORDER BY mois
        ) AS poids_cumule
    FROM saisonnalite_mensuelle
),
bornes_saisonnalite AS (
    SELECT
        mois,
        poids,
        poids_cumule - poids + 1 AS borne_min,
        poids_cumule AS borne_max
    FROM saisonnalite_cumulee
),

transactions_mois AS (
    SELECT
        ta.numero_vente,
        ta.code_vente,
        ta.annee_vente,
        ta.position_saison,
        bs.mois AS mois_vente
    FROM transactions_annees ta

    INNER JOIN bornes_saisonnalite bs
        ON ta.position_saison
           BETWEEN bs.borne_min AND bs.borne_max
),

transactions_dates AS (
    SELECT
        numero_vente,
        code_vente,
        annee_vente,
        mois_vente,
        ((numero_vente * 11 - 1) % 28) + 1 AS jour_vente,

        MAKE_DATE(
            annee_vente,
            mois_vente,
            ((numero_vente * 11 - 1) % 28) + 1
        ) AS date_vente

    FROM transactions_mois
),
transactions_avec_date AS (
    SELECT
        td.numero_vente,
        td.code_vente,
        td.date_vente,
        dd.id_date

    FROM transactions_dates td

    INNER JOIN dim_date dd
        ON td.date_vente = dd.date
),

transactions_clients AS (
    SELECT
        tad.numero_vente,
        tad.code_vente,
        tad.date_vente,
        tad.id_date,

        CASE
            -- 40 % des transactions vers les clients 1 à 20
            WHEN ((tad.numero_vente * 37 - 1) % 100) + 1 <= 40
            THEN ((tad.numero_vente * 17 - 1) % 20) + 1

            -- 35 % vers les clients 21 à 80
            WHEN ((tad.numero_vente * 37 - 1) % 100) + 1 <= 75
            THEN 21 + ((tad.numero_vente * 17 - 1) % 60)

            -- 25 % vers les clients 81 à 200
            ELSE 81 + ((tad.numero_vente * 17 - 1) % 120)

        END AS numero_client

    FROM transactions_avec_date tad
),
transactions_avec_client AS (
    SELECT
        tc.numero_vente,
        tc.code_vente,
        tc.date_vente,
        tc.id_date,
        dc.id_client

    FROM transactions_clients tc

    INNER JOIN dim_client dc
        ON dc.code_client =
           'CLI-' || LPAD(tc.numero_client::TEXT, 3, '0')
),
-- Répartition des transactions entre les magasins
poids_magasins AS (
    SELECT *
    FROM (
        VALUES
            ('MAG-001', 15),
            ('MAG-002', 13),
            ('MAG-003', 12),
            ('MAG-004', 11),
            ('MAG-005', 10),
            ('MAG-006',  9),
            ('MAG-007',  9),
            ('MAG-008',  8),
            ('MAG-009',  7),
            ('MAG-010',  6)
    ) AS m(code_magasin, poids)
),

-- Construction des bornes correspondant au poids de chaque magasin
bornes_magasins AS (
    SELECT
        code_magasin,
        poids,

        SUM(poids) OVER (
            ORDER BY code_magasin
        ) - poids + 1 AS borne_min,

        SUM(poids) OVER (
            ORDER BY code_magasin
        ) AS borne_max

    FROM poids_magasins
),
-- Attribution d'une position de 1 à 100 à chaque transaction
transactions_magasins AS (
    SELECT
        tac.numero_vente,
        tac.code_vente,
        tac.date_vente,
        tac.id_date,
        tac.id_client,

        ((tac.numero_vente * 43 - 1) % 100) + 1
            AS position_magasin

    FROM transactions_avec_client tac
),
-- Récupération de la clé technique du magasin
transactions_avec_magasin AS (
    SELECT
        tm.numero_vente,
        tm.code_vente,
        tm.date_vente,
        tm.id_date,
        tm.id_client,
        dm.id_magasin,
        dm.code_magasin

    FROM transactions_magasins tm

    INNER JOIN bornes_magasins bm
        ON tm.position_magasin
           BETWEEN bm.borne_min AND bm.borne_max

    INNER JOIN dim_magasin dm
        ON dm.code_magasin = bm.code_magasin
),
-- Répartition des transactions entre les commerciaux
poids_commerciaux AS (
    SELECT *
    FROM (
        VALUES
            ('COM-001', 10),
            ('COM-002',  9),
            ('COM-003',  9),
            ('COM-004',  8),
            ('COM-005',  8),
            ('COM-006',  7),
            ('COM-007',  7),
            ('COM-008',  7),
            ('COM-009',  6),
            ('COM-010',  6),
            ('COM-011',  5),
            ('COM-012',  5),
            ('COM-013',  5),
            ('COM-014',  4),
            ('COM-015',  4)
    ) AS c(code_commercial, poids)
),
-- Construction des intervalles correspondant aux poids
bornes_commerciaux AS (
    SELECT
        code_commercial,
        poids,

        SUM(poids) OVER (
            ORDER BY code_commercial
        ) - poids + 1 AS borne_min,

        SUM(poids) OVER (
            ORDER BY code_commercial
        ) AS borne_max

    FROM poids_commerciaux
),
-- Attribution d'une position commerciale à chaque transaction
transactions_commerciaux AS (
    SELECT
        tam.*,

        ((tam.numero_vente * 47 - 1) % 100) + 1
            AS position_commercial

    FROM transactions_avec_magasin tam
),
-- Récupération de la clé technique du commercial
transactions_avec_commercial AS (
    SELECT
        tc.numero_vente,
        tc.code_vente,
        tc.date_vente,
        tc.id_date,
        tc.id_client,
        tc.id_magasin,
        dc.id_commercial,
        dc.code_commercial

    FROM transactions_commerciaux tc

    INNER JOIN bornes_commerciaux bc
        ON tc.position_commercial
           BETWEEN bc.borne_min AND bc.borne_max

    INNER JOIN dim_commercial dc
        ON dc.code_commercial = bc.code_commercial
),
transactions_nb_lignes AS (
    SELECT
        tac.*,

        CASE
            WHEN ((tac.numero_vente * 53 - 1) % 100) + 1 <= 55 THEN 1
            WHEN ((tac.numero_vente * 53 - 1) % 100) + 1 <= 85 THEN 2
            WHEN ((tac.numero_vente * 53 - 1) % 100) + 1 <= 95 THEN 3
            ELSE 4
        END AS nb_lignes

    FROM transactions_avec_commercial tac
),
lignes_ventes AS (
    SELECT
        tnl.numero_vente,
        tnl.code_vente,
        tnl.date_vente,
        tnl.id_date,
        tnl.id_client,
        tnl.id_magasin,
        tnl.id_commercial,
        tnl.nb_lignes,
        gs.numero_ligne

    FROM transactions_nb_lignes tnl

    CROSS JOIN LATERAL generate_series(
        1,
        tnl.nb_lignes
    ) AS gs(numero_ligne)
),

-- Poids de vente par type de produit
poids_types_produits AS (
    SELECT *
    FROM (
        VALUES
            -- Électronique
            ('Smartphone',             6),
            ('Ordinateur portable',    4),
            ('Casque Bluetooth',       6),
            ('Téléviseur 4K',          3),

            -- Mode & habillement
            ('Baskets',                6),
            ('Jean',                   5),
            ('Sac à main',             4),
            ('Veste',                  4),

            -- Beauté & hygiène
            ('Shampoing',              5),
            ('Crème hydratante',       5),
            ('Parfum',                 4),
            ('Rouge à lèvres',         4),

            -- Maison & décoration
            ('Canapé',                 1),
            ('Lampe de bureau',        3),
            ('Draps de lit',           3),

            -- Alimentation
            ('Tablette de chocolat',   6),
            ('Jus d''orange',          6),
            ('Paquet de pâtes',        6),
            ('Café moulu',             5),
            ('Biscuits',               6),

            -- Jeux & loisirs
            ('Console de jeux',        2),
            ('Peluche',                2),
            ('Jeu de société',         2),
            ('Ballon de football',     2)
    ) AS p(type_produit, poids)
),
-- Construction des bornes de répartition des types de produits
-- à partir de leur poids dans les ventes
bornes_types_produits AS (
    SELECT
        type_produit,
        poids,

        -- Première position attribuée au type de produit
        SUM(poids) OVER (
            ORDER BY type_produit
        ) - poids + 1 AS borne_min,

        -- Dernière position attribuée au type de produit
        SUM(poids) OVER (
            ORDER BY type_produit
        ) AS borne_max

    FROM poids_types_produits
),
-- Attribution d'une position entre 1 et 100 à chaque ligne de vente
-- afin d'appliquer la répartition définie par type de produit
lignes_ventes_positions AS (
    SELECT
        lv.*,

        ROW_NUMBER() OVER (
            ORDER BY lv.numero_vente, lv.numero_ligne
        ) AS numero_ligne_global

    FROM lignes_ventes lv
),
lignes_ventes_positions_produits AS (
    SELECT
        lvp.*,

        ((lvp.numero_ligne_global * 37 - 1) % 100) + 1
            AS position_produit

    FROM lignes_ventes_positions lvp
),
-- Attribution du type de produit en fonction
-- des bornes de répartition définies précédemment
lignes_ventes_types_produits AS (
    SELECT
        lvpp.*,
        btp.type_produit

    FROM lignes_ventes_positions_produits lvpp

    INNER JOIN bornes_types_produits btp
        ON lvpp.position_produit
           BETWEEN btp.borne_min AND btp.borne_max
),
-- Numérotation des références disponibles à l'intérieur de chaque type de produit
produits_numerotes AS (
    SELECT
        id_produit,
        type_produit,
        ROW_NUMBER() OVER (
            PARTITION BY type_produit
            ORDER BY id_produit
        ) AS numero_produit
    FROM dim_produit
),

-- Numérotation séquentielle des lignes de vente à l'intérieur de chaque type.
-- Cette étape évite la corrélation entre l'attribution du type de produit
-- et le choix de la référence produit.
lignes_ventes_rang_type AS (
    SELECT
        lvtp.*,
        ROW_NUMBER() OVER (
            PARTITION BY lvtp.type_produit
            ORDER BY lvtp.numero_ligne_global
        ) AS rang_dans_type
    FROM lignes_ventes_types_produits lvtp
),

-- Nombre de références disponibles pour chaque type de produit
nb_produits_par_type AS (
    SELECT
        type_produit,
        COUNT(*) AS nb_produits_type
    FROM dim_produit
    GROUP BY type_produit
),

-- Attribution cyclique d'une référence à chaque ligne de vente
lignes_ventes_numero_produit AS (
    SELECT
        lvrt.*,
        npt.nb_produits_type,
        ((lvrt.rang_dans_type - 1) % npt.nb_produits_type) + 1
            AS numero_produit
    FROM lignes_ventes_rang_type lvrt
    INNER JOIN nb_produits_par_type npt
        ON lvrt.type_produit = npt.type_produit
),

-- Récupération de la clé technique id_produit
lignes_ventes_avec_produit AS (
    SELECT
        lvnp.*,
        pn.id_produit
    FROM lignes_ventes_numero_produit lvnp
    INNER JOIN produits_numerotes pn
        ON lvnp.type_produit = pn.type_produit
       AND lvnp.numero_produit = pn.numero_produit
),

-- Numérotation des lignes à l'intérieur de chaque type de produit
-- afin d'éviter une corrélation avec l'attribution du type
lignes_ventes_rang_quantite AS (
    SELECT
        lvap.*,
        ROW_NUMBER() OVER (
            PARTITION BY lvap.type_produit
            ORDER BY lvap.numero_ligne_global
        ) AS rang_quantite
    FROM lignes_ventes_avec_produit lvap
),
-- ============================================================
-- ATTRIBUTION DES QUANTITÉS VENDUES
-- ============================================================

lignes_ventes_avec_quantite AS (
    SELECT
        lvrq.*,

        CASE

            -- Produits généralement achetés à l'unité
            WHEN lvrq.type_produit IN (
                'Canapé',
                'Téléviseur 4K',
                'Ordinateur portable',
                'Smartphone',
                'Console de jeux'
            )
            THEN
                CASE
                    WHEN ((lvrq.rang_quantite - 1) % 100) + 1 <= 90
                        THEN 1
                    ELSE 2
                END

            -- Produits alimentaires :
            -- achats de plusieurs unités plus fréquents
            WHEN lvrq.type_produit IN (
                'Tablette de chocolat',
                'Jus d''orange',
                'Paquet de pâtes',
                'Café moulu',
                'Biscuits'
            )
            THEN
                CASE
                    WHEN ((lvrq.rang_quantite - 1) % 100) + 1 <= 50 THEN 1
                    WHEN ((lvrq.rang_quantite - 1) % 100) + 1 <= 80 THEN 2
                    WHEN ((lvrq.rang_quantite - 1) % 100) + 1 <= 95 THEN 3
                    ELSE 4
                END

            -- Autres produits
            ELSE
                CASE
                    WHEN ((lvrq.rang_quantite - 1) % 100) + 1 <= 75 THEN 1
                    WHEN ((lvrq.rang_quantite - 1) % 100) + 1 <= 95 THEN 2
                    ELSE 3
                END

        END AS quantite

    FROM lignes_ventes_rang_quantite lvrq
),
-- ============================================================
-- 1. Récupération du prix catalogue du produit
-- ============================================================
lignes_ventes_avec_prix_catalogue AS (
    SELECT
        lvaq.*,
        dp.prix_catalogue
    FROM lignes_ventes_avec_quantite lvaq
    INNER JOIN dim_produit dp
        ON lvaq.id_produit = dp.id_produit
),

-- ============================================================
-- 2. Attribution d'un taux de remise
--
-- Répartition cible :
-- 60 % : aucune remise
-- 20 % : remise de 5 %
-- 15 % : remise de 10 %
--  5 % : remise de 15 %
-- ============================================================
lignes_ventes_avec_remise AS (
    SELECT
        lvpc.*,

        CASE
            WHEN (
                ((lvpc.rang_quantite + lvpc.id_produit * 17 - 1) % 100) + 1
            ) <= 60
                THEN 0.00

            WHEN (
                ((lvpc.rang_quantite + lvpc.id_produit * 17 - 1) % 100) + 1
            ) <= 80
                THEN 0.05

            WHEN (
                ((lvpc.rang_quantite + lvpc.id_produit * 17 - 1) % 100) + 1
            ) <= 95
                THEN 0.10

            ELSE 0.15
        END AS taux_remise

    FROM lignes_ventes_avec_prix_catalogue lvpc
),

-- ============================================================
-- 3. Calcul du prix unitaire réellement facturé
--
-- prix_unitaire = prix_catalogue × (1 - taux_remise)
-- ============================================================
lignes_ventes_avec_prix AS (
    SELECT
        lvar.*,

        ROUND(
            lvar.prix_catalogue * (1 - lvar.taux_remise),
            2
        ) AS prix_unitaire

    FROM lignes_ventes_avec_remise lvar
),

-- ============================================================
-- 4. Attribution du taux de coût selon le type de produit
-- ============================================================
lignes_ventes_avec_taux_cout AS (
    SELECT
        lvap.*,

        CASE
            -- Électronique
            WHEN lvap.type_produit = 'Smartphone'
                THEN 0.85

            WHEN lvap.type_produit = 'Ordinateur portable'
                THEN 0.82

            WHEN lvap.type_produit = 'Téléviseur 4K'
                THEN 0.80

            WHEN lvap.type_produit = 'Console de jeux'
                THEN 0.84

            WHEN lvap.type_produit = 'Casque Bluetooth'
                THEN 0.65

            -- Alimentation
            WHEN lvap.type_produit IN (
                'Tablette de chocolat',
                'Jus d''orange',
                'Paquet de pâtes',
                'Café moulu',
                'Biscuits'
            )
                THEN 0.70

            -- Mode
            WHEN lvap.type_produit IN (
                'Baskets',
                'Jean',
                'Sac à main',
                'Veste'
            )
                THEN 0.55

            -- Beauté
            WHEN lvap.type_produit IN (
                'Shampoing',
                'Crème hydratante',
                'Parfum',
                'Rouge à lèvres'
            )
                THEN 0.50

            -- Maison
            WHEN lvap.type_produit IN (
                'Canapé',
                'Lampe de bureau',
                'Draps de lit'
            )
                THEN 0.60

            -- Jeux & loisirs
            WHEN lvap.type_produit IN (
                'Peluche',
                'Jeu de société',
                'Ballon de football'
            )
                THEN 0.60
			ELSE NULL

        END AS taux_cout

    FROM lignes_ventes_avec_prix lvap
),

-- ============================================================
-- 5. Calcul du coût unitaire
--
-- Le coût est calculé à partir du prix catalogue et non
-- du prix remisé.
-- ============================================================
lignes_ventes_avec_cout AS (
    SELECT
        lvatc.*,

        ROUND(
            lvatc.prix_catalogue * lvatc.taux_cout,
            2
        ) AS cout_unitaire

    FROM lignes_ventes_avec_taux_cout lvatc
)

INSERT INTO fact_vente (
    code_vente,
    id_produit,
    id_client,
    id_magasin,
    id_commercial,
    id_date,
    quantite,
    prix_unitaire,
    cout_unitaire,
    taux_remise
)
SELECT
    code_vente,
    id_produit,
    id_client,
    id_magasin,
    id_commercial,
    id_date,
    quantite,
    prix_unitaire,
    cout_unitaire,
    taux_remise
FROM lignes_ventes_avec_cout;