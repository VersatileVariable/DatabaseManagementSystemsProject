SELECT 
	(SELECT name FROM category WHERE category.category_id = cat_ID) AS category_name, 
	tool_id,
	tool_name,
	checkout_count,
	category_rank FROM (
		SELECT
			tool_id, 
			COUNT(tool_id) AS checkout_count,
			(SELECT name FROM tool WHERE checkout.tool_id = tool.tool_id) AS tool_name,
			RANK() OVER (PARTITION BY (SELECT category_id FROM tool WHERE tool.tool_id = checkout.tool_id) 
						ORDER BY COUNT(tool_id) DESC
						) category_rank,
			(SELECT category_id FROM tool WHERE tool.tool_id = checkout.tool_id) AS cat_id
	FROM checkout GROUP BY tool_id) AS derivTable
WHERE category_rank <= 3
ORDER BY category_name, category_rank, tool_id;