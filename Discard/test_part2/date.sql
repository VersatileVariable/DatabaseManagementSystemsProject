##These don't seem to work? Seems to be that the updates work better instead
CREATE TRIGGER insertDate BEFORE INSERT ON updated_member
	FOR EACH ROW 
		SET NEW.join_date = CAST(NEW.join_date AS DATETIME);

DROP TRIGGER insertDate;



delimiter $$
CREATE TRIGGER updateEmails BEFORE INSERT ON updated_member
	FOR EACH ROW
		BEGIN
			SET NEW.email = LOWER(NEW.email);
			SET NEW.email = TRIM( NEW.email);
		END;
$$
delimiter ;