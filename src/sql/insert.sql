INSERT INTO personnage(nom_perso) VALUES
    ('Colonel MOUTARDE'),
    ('Docteur OLIVE'),
    ('Professeur VIOLET'),
    ('Madame PERVENCHE'),
    ('Mademoiselle ROSE'),
    ('Madame LEBLANC');

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

INSERT INTO objet(nom_objet, id_salle) VALUES
    ('Revolver', 3),
    ('Poignard', 3),
    ('Chandelier', 5),
    ('Corde', 1),
    ('Clé anglaise', 5),
    ('Barre de fer', 3);

INSERT INTO roles(nom_role) VALUES
    ('Maitre du jeu'),
    ('Observateur'),
    ('Détective');

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