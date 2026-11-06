SELECT member_id, email 
	FROM member 
	WHERE member_id NOT IN (SELECT member_id FROM checkout)
	ORDER BY member_id;