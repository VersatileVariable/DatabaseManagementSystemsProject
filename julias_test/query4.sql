SELECT member_id, email 
	FROM stg_member 
	WHERE member_id NOT IN (SELECT member_id FROM stg_checkout)
	ORDER BY member_id;