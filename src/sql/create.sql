-- 1 : psql -U ayoublaroussi -f /Users/ayoublaroussi/Documents/Repo/Simplon/simpluedo-cerceaux-de-ciment/src/trigger.sql simpluedo

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

ALTER SCHEMA public OWNER TO admin_simpluedo;
