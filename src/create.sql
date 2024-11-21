-- CREATE USER admin_simpluedo WITH CREATEDB;

DROP DATABASE IF EXISTS SIMPLUEDO
CREATE DATABASE SIMPLUEDO;

-- Après s'être connecté à la base de données
-- GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO admin_simpluedo;

DROP TABLE IF EXISTS utilisateur;
DROP TABLE IF EXISTS role;
DROP TABLE IF EXISTS visiter;
DROP TABLE IF EXISTS personnage;
DROP TABLE IF EXISTS objet;
DROP TABLE IF EXISTS salle;

CREATE TABLE personnage(
   id_perso INTEGER PRIMARY KEY,
   nom_perso VARCHAR(20) ,
);

CREATE TABLE salle(
   id_salle INTEGER PRIMARY KEY,
   nom_salle VARCHAR(20) ,
);

CREATE TABLE objet(
   id_objet INTEGER PRIMARY KEY,
   nom_objet VARCHAR(20) ,
   id_salle INTEGER NOT NULL REFERENCES salle(id_salle)
);

CREATE TABLE role(
   id_role INTEGER PRIMARY KEY,
   nom_role VARCHAR(20) ,
);

CREATE TABLE utilisateur(
   uuid_utilisateur UUID PRIMARY KEY DEFAULT gen_random_uuid(),
   pseudo_utilisateur VARCHAR(20) ,
   id_role INTEGER NOT NULL,
   id_perso INTEGER,
   UNIQUE(id_perso),
   FOREIGN KEY(id_role) REFERENCES role(id_role),
   FOREIGN KEY(id_perso) REFERENCES personnage(id_perso)
);

CREATE TABLE visiter(
   id_perso INTEGER,
   id_salle INTEGER,
   heure_arrive TIME,
   heure_sortie TIME,
   PRIMARY KEY(id_perso, id_salle),
   FOREIGN KEY(id_perso) REFERENCES personnage(id_perso),
   FOREIGN KEY(id_salle) REFERENCES salle(id_salle)
);