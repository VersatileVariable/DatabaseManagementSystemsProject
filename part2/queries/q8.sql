Members who have checked out at least one tool from every category that requires certification	
member_id, email	
member_id

#DO I NEED TO CHECK TO CONFIRM THAT EACH CERTIFICATION IS DIFFERENT AND THAT THERE AReN"T ANY NULL
SELECT member_id, email FROM 
	(SELECT 
		member_id, 
		(SELECT email FROM stg_member WHERE stg_certification.member_id = stg_member.member_id) AS email, 
		COUNT(member_id) AS quantity FROM stg_certification GROUP BY member_id) 
		AS divTable
	WHERE quantity = (SELECT COUNT(category_id) FROM stg_category WHERE requires_certification = TRUE)
	ORDER BY member_id;