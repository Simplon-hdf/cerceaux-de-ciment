# Base de Données Simpluedo

Ce projet contient toutes les requêtes SQL nécessaires pour créer et manipuler la base de données Simpluedo. Ce fichier est structuré en plusieurs sections pour faciliter la compréhension.

---
### Sommaire

1. [Structure de la Base de Données](#structure-de-la-base-de-données)
    - [1. Création des Tables](#création-des-tables)
    - [2. Insertion des Données](#insertion-des-données)
2. [Triggers](#triggers)
    - [Mise à jour de la position des personnages](#trigger--mise-à-jour-de-la-position-des-personnages)
3. [Procédures Stockées](#procédures-stockées)
4. [Requêtes Demandées](#requêtes-demandées)
    - [1. Lister tous les personnages du jeu](#1-lister-tous-les-personnages-du-jeu)
    - [2. Lister chaque joueur et son personnage associé](#2-lister-chaque-joueur-et-son-personnage-associé)
    - [3. Afficher les personnages dans une salle à une heure donnée](#3-afficher-la-liste-des-personnages-présents-dans-la-cuisine-entre-0800-et-0900)
    - [4. Afficher les pièces non visitées](#4-afficher-les-pièces-où-aucun-personnage-nest-allé)
    - [5. Compter les objets par pièce](#5compter-le-nombre-dobjets-par-pièce)
    - [6. Ajouter une pièce](#6-ajouter-une-pièce)
    - [7. Modifier un objet](#7-modifier-un-objet)
    - [8. Supprimer une pièce](#8-supprimer-une-pièce)
5. [Sauvegarder la base de données](#sauvegarder-la-base-de-données)

---


## Structure de la Base de Données

### Création des Tables

```sql

-- Connexion à une autre base de données pour permettre la suppression
\c postgres

-- Supprime la base de données si elle existe
DROP DATABASE IF EXISTS simpluedo;

CREATE USER admin_simpluedo WITH CREATEDB;

-- Crée une nouvelle base de données
CREATE DATABASE simpluedo;

-- Se reconnecte à la nouvelle base de données
\c simpluedo

CREATE TABLE personnage(
   id_perso INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
   nom_perso VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE salle(
   id_salle INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
   nom_salle VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE objet(
   id_objet INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
   nom_objet VARCHAR(20) UNIQUE NOT NULL,
   id_salle INTEGER NOT NULL REFERENCES salle(id_salle)
);

CREATE TABLE roles(
   id_role INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
   nom_role VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE utilisateur(
   uuid_utilisateur UUID PRIMARY KEY DEFAULT gen_random_uuid(),
   pseudo_utilisateur VARCHAR(20) NOT NULL UNIQUE,
   id_role INTEGER NOT NULL REFERENCES roles(id_role),
   id_perso INTEGER UNIQUE REFERENCES personnage(id_perso)
);

CREATE TABLE visiter(
   id_perso INTEGER REFERENCES personnage(id_perso),
   id_salle INTEGER REFERENCES salle(id_salle),
   heure_arrivee TIME,
   heure_sortie TIME,
   PRIMARY KEY(id_perso, id_salle, heure_arrivee)
);

-- Après s'être connecté à la base de données
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO admin_simpluedo;

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO admin_simpluedo;

ALTER SCHEMA public OWNER TO admin_simpluedo;

```

---

### Insertion des Données

```sql
-- Insertion des personnages dans le jeu
INSERT INTO personnage(nom_perso) VALUES
    ('Colonel MOUTARDE'),
    ('Docteur OLIVE'),
    ('Professeur VIOLET'),
    ('Madame PERVENCHE'),
    ('Mademoiselle ROSE'),
    ('Madame LEBLANC');

-- Insertion des salles disponibles dans le jeu
INSERT INTO salle(nom_salle) VALUES
    ('Bibliothèque'),
    ('Bureau'),
    ('Cuisine'),
    ('Hall'),
    ('Salle à manger'),
    ('Salle de bal'),
    ('Salle de billard'),
    ('Salon'),
    ('Véranda');

-- Insertion des objets placés dans les différentes salles
INSERT INTO objet(nom_objet, id_salle) VALUES
    ('Revolver', 3),
    ('Poignard', 3),
    ('Chandelier', 5),
    ('Corde', 1),
    ('Clé anglaise', 5),
    ('Barre de fer', 3);

-- Insertion des différents rôles dans le jeu
INSERT INTO roles(nom_role) VALUES
    ('Maitre du jeu'),
    ('Observateur'),
    ('Détective');

-- Insertion des utilisateurs avec leurs rôles et personnages associés
INSERT INTO utilisateur(pseudo_utilisateur, id_role, id_perso) VALUES
    ('igoshawk0', 3, 2),
    ('mdiche1', 3, 4),
    ('ggopsill2', 3, 3),
    ('hewenson3', 3, 5),
    ('agirardez4', 3, 6),
    ('thaynesford5', 2, NULL),
    ('clarvin1', 2, NULL),
    ('nhulmes2', 2, NULL),
    ('bplumbe4', 2, NULL);

```

---

### Triggers

#### Trigger : Mise à jour de la position des personnages

```sql
\c simpluedo
-- Création de la table position
CREATE TABLE position (
    id_perso INTEGER NOT NULL REFERENCES personnage(id_perso),
    id_salle INTEGER NOT NULL REFERENCES salle(id_salle),
    heure_arrivee TIME NOT NULL,
    PRIMARY KEY (id_perso) -- Un personnage peut être dans une seule salle à la fois
);

-- Création de la fonction
CREATE OR REPLACE FUNCTION maj_position_trigger()
RETURNS TRIGGER AS $$
BEGIN
    -- Complète l'heure de sortie dans visiter
    UPDATE visiter
    SET heure_sortie = NEW.heure_arrivee
    WHERE id_perso= NEW.id_perso
      AND heure_sortie IS NULL;

    -- Met à jour ou insère dans position
    INSERT INTO position (id_perso, id_salle, heure_arrivee)
    VALUES (NEW.id_perso, NEW.id_salle, NEW.heure_arrivee)
    ON CONFLICT (id_perso)
    DO UPDATE SET id_salle = EXCLUDED.id_salle, heure_arrivee = EXCLUDED.heure_arrivee;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Lancement du trigger
CREATE TRIGGER trigger_maj_position
AFTER INSERT OR UPDATE ON visiter
FOR EACH ROW
EXECUTE FUNCTION maj_position_trigger();
```

---

### Procédures Stockées

```sql
-- Création de la procédure stockée "Lister tous les objets situés dans une pièce passée en paramètre" 

CREATE OR REPLACE PROCEDURE lister_objet(n_salle VARCHAR)
LANGUAGE plpgsql
AS $$
DECLARE
    obj_name VARCHAR; -- Variable pour stocker temporairement le nom des objets
BEGIN
    RAISE NOTICE 'Objets dans la salle % :', n_salle;
    
    FOR obj_name IN
        SELECT objet.nom_objet
        FROM objet
        INNER JOIN salle ON salle.id_salle = objet.id_salle
        WHERE salle.nom_salle = n_salle
    LOOP
        RAISE NOTICE 'Objet: %', obj_name; -- Afficher chaque objet trouvé
    END LOOP;
END;
$$;

-- Pour l'appeler
call lister_objet('Cuisine');


-- Création de la procédure stockée "Ajout d'un objet passé en paramètre et association avec la pièce concernée avec le nom"

 CREATE OR REPLACE PROCEDURE ajout_objet(var_nom_objet VARCHAR, var_nom_salle VARCHAR)
 LANGUAGE plpgsql
 AS $$
 BEGIN
     INSERT INTO objet (nom_objet, id_salle)
     SELECT var_nom_objet, salle.id_salle
     FROM salle
     WHERE salle.nom_salle = var_nom_salle;
 
     IF NOT FOUND THEN
         RAISE EXCEPTION 'La salle "%" n''existe pas.', var_nom_salle;
     END IF;
 END;
 $$;

 -- Pour l'appeler
 call ajout_objet('Pam','Cuisine')
```

---

### Requêtes Demandées

#### 1. Lister tous les personnages du jeu

```sql
SELECT * FROM personnage;
```

---

#### 2. Lister chaque joueur et son personnage associé

```sql
SELECT pseudo_utilisateur, nom_perso 
FROM utilisateur
INNER JOIN personnage ON utilisateur.id_perso = personnage.id_perso;
```

---

#### 3. Afficher la liste des personnages présents dans la cuisine entre 08:00 et 09:00

```sql
SELECT * FROM personnage
INNER JOIN visiter ON visiter.id_perso = personnage.id_perso
WHERE date_part('hour', heure_arrivee) = '08';
```

---

#### 4. Afficher les pièces où aucun personnage n'est allé

```sql
SELECT * FROM visiter
INNER JOIN salle ON salle.id_salle = visiter.id_salle
WHERE heure_arrivee IS NULL;
```

---

#### 5. Compter le nombre d'objets par pièce

```sql
SELECT COUNT(*) AS nombre_objets
FROM objet
INNER JOIN salle ON salle.id_salle = objet.id_salle
WHERE nom_salle = 'Cuisine'; -- Changez le nom de la pièce si nécessaire
```

---

#### 6. Ajouter une pièce

```sql
INSERT INTO salle(nom_salle) VALUES
    ('Nom de la pièce');
```

---

#### 7. Modifier un objet

```sql
UPDATE objet
SET nom_objet = 'Piou Piou' -- Changez ici le nom de l'objet
WHERE id_objet = 1; -- L'identifiant de l'objet à modifier
```

---

#### 8. Supprimer une pièce

```sql
DELETE FROM salle
WHERE id_salle = ''; -- Remplacez par l'identifiant de la salle à supprimer
```

---

## Sauvegarder la base de données

Pour sauvegarder la base de données **simpluedo**, exécutez la commande suivante :

```bash
pg_dump -h localhost -p 5432 -U "postgres" simpluedo > simpluedo_backup.sql
```

- **`-h localhost`** : Adresse de l’hôte (utilisez `localhost` si la base est locale).
- **`-p 5432`** : Port par défaut de PostgreSQL.
- **`-U postgres`** : Le supper User PostgreSQL.
- **`simpluedo`** : Nom de la base de données à sauvegarder.
- **`simpluedo_backup.sql`** : Fichier dans lequel la sauvegarde sera exportée.

---
