#VALUES(2218, 'julia', 'holzbach', 'jholzba',
#	12345, '2026-01-01', 'active');

#UPDATE updated_member SET zip = 123 WHERE member_id = 2218;

#Date conversion
#UPDATE updated_member SET join_date = CAST((SELECT joined FROM members WHERE member_id = 2218) AS DATETIME) WHERE member_id = 2218;

#Emails
#UPDATE updated_member 
#	SET email = LOWER(TRIM( " JULIA "))
#	WHERE member_id = 2218;

#Zip code
#UPDATE updated_member SET zip = CAST((SELECT zip FROM members WHERE member_id = 2218) AS VARCHAR(5)) 
#	WHERE member_id = 2218;
	
#SELECT zip FROM updated_member WHERE member_id = 2218;
#	WHILE (CHAR_LENGTH(zip) < 5)
#		BEGIN
#				zip = CONCAT('0', zip)
#		END
		

#SELECT CHAR_LENGTH(zip) FROM updated_member WHERE member_id = 2218;
#SELECT * FROM updated_member WHERE CHAR_LENGTH(zip) > 5;

#UPDATE updated_member SET zip = CONCAT('0', zip) WHERE CHAR_LENGTH(zip) < 5;
#Could of course do
	#concat "00" where char _legnth = 3, but that doesn't feel the most effective

#IF (SELECT CHAR_LENGTH(zip) FROM updated_member) < 5
#	PRINT 'Update';

#UPDATE updated_member SET zip = 123 WHERE member_id = 2218;


#SELECT og_certifications.category, og_categories.category_id
#	FROM og_certifications
#		JOIN og_categories ON og_certifications.category = og_categories.name;


#INSERT INTO stg_category (category_id, name, daily_late_fee, max_loan_days)
#	SELECT category_id, name, daily_late_fee, max_loan_days 
#	FROM og_categories;

#INSERT INTO stg_category (requires_certification)
#	IF (SELECT requires_certification FROM og_categories) == 'Y'
#;

#SELECT requires_cert FROM og_categories WHERE requires_cert = 'Y';

#CREATE FUNCTION toBinary(s varchar(50)) RETURNS BOOLEAN DETERMINISTIC
#	BEGIN
#		IF s = 'Y' THEN
#			RETURN TRUE
#	END;

 #UPDATE stg_category 
 #	SET requires_certification =
#		(SELECT requires_cert,
#			CASE
#				WHEN requires_cert = 'Y' THEN 1
#				ELSE 0
#			END AS bool_type
#		FROM og_categories);
 
 #UPDATE stg_category 
# 	SET requires_certification = CASE
# 	WHEN requires_cert = 'Y' 
#	THEN 1 
#	WHEN requires_cert = 'N'
#	THEN 0
# 		FROM og_categories 
# 		WHERE category_id = 10 
# 	WHERE category_id = 10;
 
 


#TENTATIVE BEST INSERT TO BOOLEAN
INSERT INTO stg_category (requires_certification)
 	SELECT requires_cert,
 		CASE 
 			WHEN requires_cert = 'Y' THEN TRUE
 			WHEN requires_cert = 'N' THEN FALSE
 			ELSE 2
 		END
 	FROM og_categories;


DROP TABLE stg_category;
#Storing tool condition as lowercase, replace spaces with _