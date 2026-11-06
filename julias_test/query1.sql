SELECT tool_id, name, (SELECT name FROM stg_category WHERE stg_tools.category_id = stg_category.category_id) AS category_name
FROM stg_tools 
WHERE tool_condition = 'needs_repair'
ORDER BY tool_id;