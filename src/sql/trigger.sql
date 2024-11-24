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