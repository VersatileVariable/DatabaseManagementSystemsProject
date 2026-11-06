/*Members who have checked out at least one tool from every category that requires certification	
member_id, email	
member_id

#NULL*/
SELECT mem_id AS member_id, (SELECT email FROM member WHERE member_id = mem_id) AS email FROM (
	SELECT 
		member_id AS mem_id, 
		tool_id,
		(SELECT category_id FROM tool WHERE checkout.tool_id = tool.tool_id) AS cat_id,
		(SELECT requires_certification FROM category WHERE category.category_id = cat_id) AS req_cert
	FROM checkout
	ORDER BY mem_id) AS derivTable
	WHERE req_cert = TRUE
	GROUP BY mem_id
	HAVING (COUNT(DISTINCT cat_id)) = (SELECT COUNT(DISTINCT category_id) FROM category WHERE requires_certification = TRUE);


/*SELECT * FROM (
	SELECT
		member_id,
		tool_id, 
		(SELECT category_id FROM tool WHERE checkout.tool_id = tool.tool_id) AS cat_id,
		(SELECT requires_certification FROM category WHERE category.category_id = 
			(SELECT category_id FROM tool WHERE checkout.tool_id = tool.tool_id)) AS req_cert
	FROM checkout) AS derivTable 
	WHERE member_id = 2044 AND req_cert = TRUE
	ORDER BY cat_id;*/