#What about the tools with zero checkouts? <-- HAVE TO LOOK AT THIS
SELECT tool_id, tool_name, times_checked_out FROM (
	SELECT
		tool_id, 
		(SELECT name FROM stg_tools WHERE stg_checkout.tool_id = stg_tools.tool_id) AS tool_name, 
		COUNT(tool_id) AS times_checked_out 
	FROM stg_checkout
	GROUP BY tool_id) AS derivedCheckouts
WHERE times_checked_out > 
	(SELECT AVG(count) FROM (SELECT COUNT(tool_id) AS count FROM stg_checkout GROUP BY tool_id) AS derivedCheckouts)
ORDER BY times_checked_out DESC, tool_id;