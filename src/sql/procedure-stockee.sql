
-- Création de la procédure stockée "Lister tous les objets situés dans une pièce passée en paramètre" 

CREATE OR REPLACE FUNCTION lister_objet(salle VARCHAR)
 RETURNS TABLE(nom_objet VARCHAR)
 LANGUAGE sql
 AS $$
    SELECT nom_objet
    FROM objet
    INNER JOIN salle ON salle.id_salle = objet.id_salle
    WHERE salle = nom_salle;
 $$;

-- Pour l'appeler
CALL lister_objet();


-- Création de la procédure stockée "Ajout d'un objet passé en paramètre et association avec la pièce concernée en ID"

CREATE OR REPLACE PROCEDURE ajout_objet_id_salle(nom_objets VARCHAR, id_salles INTEGER)
 LANGUAGE plpgsql
 AS $$
 BEGIN
     INSERT INTO objets (nom_objets, id_salles) VALUES 
        (nom_objets, id_salles);
 END;
 $$;

-- Création de la procédure stockée "Ajout d'un objet passé en paramètre et association avec la pièce concernée avec le nom"

 CREATE OR REPLACE PROCEDURE ajout_objet(var_nom_objets VARCHAR, var_nom_salles VARCHAR)
 LANGUAGE plpgsql
 AS $$
 BEGIN
     INSERT INTO objets (nom_objets, id_salles)
     SELECT var_nom_objets, salles.id_salles
     FROM salles
     WHERE salles.nom_salles = var_nom_salles;
 
     IF NOT FOUND THEN
         RAISE EXCEPTION 'La salle "%" n''existe pas.', var_nom_salles;
     END IF;
 END;
 $$;