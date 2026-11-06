SELECT tool_id, tool_name, times_checked_out FROM (
	SELECT
		tool.tool_id, 
		tool.name AS tool_name, 
		COUNT(checkout.tool_id) AS times_checked_out
	FROM checkout RIGHT JOIN tool ON checkout.tool_id = tool.tool_id
	GROUP BY tool_id) AS derivedCheckouts
WHERE times_checked_out > (SELECT AVG(count) FROM (
	SELECT
		tool.tool_id, 
		COUNT(checkout.tool_id) AS count
		FROM checkout RIGHT JOIN tool ON checkout.tool_id = tool.tool_id GROUP BY tool_id)
AS derivTable)
ORDER BY times_checked_out DESC, tool_id;