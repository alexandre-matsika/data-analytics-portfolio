# Design Review – NovaRetail BI

**Date :** 11 septembre 2026

**Version :** V2

**Statut :** Validé

---

## Validation

Le modèle a fait l'objet d'une revue de conception afin de valider son adéquation avec les besoins décisionnels du projet.

---

## 1. Contexte

Dans le cadre du projet NovaRetail BI, une première version du modèle de données (V1) a été réalisée afin de représenter les ventes de l'entreprise et de préparer le développement du tableau de bord Power BI.

Une revue de conception a ensuite été organisée afin de valider l'architecture du modèle et de vérifier son adéquation avec les objectifs décisionnels du projet.

---

## 2. Objectif de la revue

L'objectif de cette revue était de s'assurer que le modèle de données était optimisé pour un usage analytique dans Power BI.

Les principaux points étudiés ont été :

* la structure générale du modèle ;
* l'identification de la table de faits ;
* les dimensions nécessaires à l'analyse ;
* les relations entre les tables ;
* l'adéquation du modèle avec un schéma en étoile.

---

## 3. Modèle V1

La première version du modèle était construite selon une logique proche d'un système transactionnel (OLTP).

Elle comportait notamment :

* une table Vente ;
* une table Detail_Vente ;
* plusieurs tables normalisées (Client, Produit, Commercial, Magasin, Catégorie, Localisation, Statut).

Cette conception était adaptée à l'enregistrement des ventes mais nécessitait plusieurs jointures pour réaliser les analyses décisionnelles.

---

## 4. Limites identifiées

Pendant la revue, plusieurs points d'amélioration ont été identifiés :

* navigation complexe entre les tables ;
* modèle davantage orienté transaction que décision ;
* absence de schéma en étoile ;
* dimensions non directement reliées à la table de faits.

---

## 5. Décisions prises

Les décisions suivantes ont été retenues :

* adoption d'un schéma en étoile ;
* création d'une table de faits **Fact_Vente** ;
* rattachement direct des dimensions à la table de faits ;
* intégration des informations géographiques dans les dimensions concernées ;
* suppression des tables intermédiaires devenues inutiles dans un modèle décisionnel.

---

## 6. Modèle V2 retenu

Le modèle final est constitué :

### Table de faits

* Fact_Vente

### Dimensions

* Dim_Client
* Dim_Produit
* Dim_Commercial
* Dim_Magasin
* Dim_Date

La table de faits contient les mesures métier :

* quantité ;
* montant ;
* coût ;
* remise ;
* statut.

<p align="center">
  <img src="images/data_model_v2.png" alt="Modèle décisionnel NovaRetail V2" width="1200">
</p>

---

## 7. Justification des choix

Le modèle V2 présente plusieurs avantages :

* structure conforme aux bonnes pratiques du schéma en étoile ;
* simplification des relations dans Power BI ;
* modèle plus lisible ;
* meilleures performances analytiques ;
* évolution facilitée du tableau de bord.

---

## 8. Prochaines étapes

La revue de conception a permis de faire évoluer le modèle initial vers une architecture décisionnelle adaptée à Power BI.

Ce modèle servira de référence pour les prochaines étapes du projet, notamment la création de la base PostgreSQL, l'implémentation des requêtes SQL et le développement du tableau de bord.

---

## 9. Enseignements tirés de la revue

Cette revue de conception a permis de mettre en évidence les différences entre un modèle transactionnel (OLTP) et un modèle décisionnel (OLAP). Le modèle a été repensé selon une architecture en étoile afin de répondre aux besoins analytiques du projet. Cette étape a renforcé l'importance d'aligner la modélisation des données avec les objectifs métier avant de démarrer le développement.

---

## 10. Décision

La version V2 du modèle de données est validée.

Elle constitue désormais la référence du projet NovaRetail BI.

Les prochaines étapes porteront sur :

- l'implémentation PostgreSQL ;
- l'alimentation de la base ;
- les requêtes analytiques ;
- la construction du modèle Power BI.
