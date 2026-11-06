SELECT catID, COUNT(catID) FROM (
	SELECT stg_checkout.tool_id, 
	category_id AS CatID FROM stg_checkout JOIN stg_tools ON stg_checkout.tool_id = stg_tools.tool_id)
	AS derivedC
	GROUP BY catID;
	
#ADD NULL ERROR CHECKING