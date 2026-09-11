# Business Requirements – NovaRetail BI

**Date :** 09 septembre 2026

**Version :** V1

**Statut :** Validé

---

## 1. Objectif

L'objectif de ce document est de formaliser les besoins fonctionnels exprimés par le directeur commercial afin de guider la conception du modèle de données et du futur tableau de bord Power BI.

---

## 2. Principaux besoins métier

Le directeur commercial souhaite pouvoir :

- suivre l'évolution du chiffre d'affaires ;
- comparer les performances des magasins ;
- identifier les régions les plus performantes ;
- suivre les performances des commerciaux ;
- analyser les ventes par catégorie de produits ;
- identifier les produits les plus et les moins vendus ;
- suivre les performances des principaux clients.

---

## 3. Indicateurs clés de performance (KPI)

Les principaux KPI retenus sont :

- Chiffre d'affaires
- Quantité vendue
- Coût des ventes
- Marge
- Nombre de ventes
- Panier moyen
- Performance par magasin
- Performance par commercial
- Performance par catégorie
- Top clients

---

## 4. Questions auxquelles le tableau de bord devra répondre

Le tableau de bord devra notamment permettre de répondre aux questions suivantes :

- Quel est le chiffre d'affaires par région ?
- Quels sont les magasins les plus performants ?
- Quels sont les magasins en difficulté ?
- Quels sont les commerciaux les plus performants ?
- Quels produits génèrent le plus de chiffre d'affaires ?
- Quels produits sont les moins vendus ?
- Quels sont les meilleurs clients ?
- Comment évoluent les ventes dans le temps ?

---

## 5. Décisions prises

Afin de répondre efficacement aux besoins métier, il a été décidé de :

- construire un modèle décisionnel dédié à l'analyse ;
- utiliser PostgreSQL comme base de données ;
- utiliser Power BI pour la restitution ;
- privilégier un schéma en étoile pour faciliter les analyses.

---

## 6. Conclusion

Les besoins métier identifiés dans ce document serviront de référence tout au long du projet.

Ils guideront la conception du modèle de données, le développement des requêtes SQL ainsi que la réalisation du tableau de bord Power BI.
