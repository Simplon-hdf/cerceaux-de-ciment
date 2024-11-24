-- Lister tous les personnages du jeu
SELECT * FROM personnage;

-- Lister chaque joueur et son personnage associé
SELECT pseudo_utilisateur, nom_perso FROM utilisateur
INNER JOIN personnage ON utilisateur.id_perso = personnage.id_perso;

-- Afficher la liste des personnages présents dans la cuisine entre 08:00 et 09:00
SELECT * FROM personnage
INNER JOIN visiter ON visiter.id_perso = personnage.id_perso
WHERE date_part('hour',heure_arrivee) = '08';

-- Afficher les pièces où aucun personnage n'est allé
SELECT * FROM visiter
INNER JOIN salle ON salle.id_salle = visiter.id_salle
WHERE heure_arrivee = NULL

-- Compter le nombre d'objets par pièce
SELECT COUNT(*) FROM objet
INNER JOIN salle ON salle.id_salle = objet.id_salle
WHERE nom_salle = 'Cuisine' -- On change le nom de la pièce

-- Ajouter une pièce
INSERT INTO salle(nom_salle) VALUES
    ('Nom de la pièce');


-- Modifier un objet
UPDATE objet
SET nom_objet = 'Piou Piou' -- Le nom que l'on veut changer
WHERE id_objet = 1 -- Le numéro de l'objet en question


-- Supprimer une pièce
DELETE FROM salle
WHERE id_salle = '' -- L'id de la salle a supprimer
