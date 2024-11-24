
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