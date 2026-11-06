SELECT tool_id, name AS tool_name, (SELECT name FROM category WHERE tool.category_id = category.category_id) AS category_name
FROM tool 
WHERE tool_condition = 'needs_repair'
ORDER BY tool_id;