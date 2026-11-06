Top three tools in each category by checkout count, 
	using RANK(), among tools with at least one checkout; ties may produce more than three rows	
category_name, tool_id, tool_name, checkout_count, category_rank	
category_name, category_rank, tool_id

SELECT category_name, tool_id, tool_name, checkout_count, 
	RANK() OVER (PARTITION BY
		checkout_count

FROM (
	SELECT
		(SELECT name FROM stg_category WHERE stg_category.category_id = 
			(SELECT category_id FROM stg_tools WHERE stg_tools.tool_id = stg_checkout.tool_id)) AS category_name, 
		tool_id, 
		(SELECT name FROM stg_tools WHERE stg_tools.tool_id = stg_checkout.tool_id) AS tool_name, 
		COUNT(tool_id) AS checkout_count 
		#category_rank 
	FROM stg_checkout 
	GROUP BY tool_id) AS derivedCheckout
ORDER BY category_name, tool_id;


SELECT tool_id, RANK() OVER (PARTITION BY 
								COUNT(tool_id) 
							ORDER BY
								tool_id DESC
								) count_rank
FROM stg_checkout GROUP BY tool_id ORDER BY count_rank;