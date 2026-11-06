SELECT 
	category.name AS category_name,
	COUNT(checkout.tool_id) AS checkout_count
FROM checkout JOIN tool ON checkout.tool_id = tool.tool_id 
RIGHT JOIN category ON tool.category_id = category.category_id
GROUP BY category.category_id
ORDER BY checkout_count DESC, category_name; 