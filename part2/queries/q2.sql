/*ADD NULL ERROR CHECKING*/

SELECT catID AS category_name, COUNT(catID) AS checkout_count FROM (
	SELECT checkout.tool_id, 
	category_id AS CatID FROM checkout JOIN tool ON checkout.tool_id = tool.tool_id)
	AS derivedC
	GROUP BY catID;


SELECT category_id FROM category WHERE (SELECT COUNT(tool_id) = 0 GROUP BY category_id


Number of checkouts in each category, including categories with none	
category_name, checkout_count	
checkout_count desc, category_name