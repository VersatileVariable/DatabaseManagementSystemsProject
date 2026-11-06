#Checkouts still out and past due as of today	
#So this is not supposed to include checkouts that have been submitted past their due date
#It is just supposed to include checkouts that have not been returned, and their due date is past
#not supposed to include return date when we submit for real

#REVIEW THIS

SELECT * FROM (
	SELECT
		checkout_id, 
		(SELECT name FROM stg_tools WHERE stg_checkout.tool_id = stg_tools.tool_id) AS tool_name, 
		(SELECT email FROM stg_member WHERE stg_checkout.member_id = stg_member.member_id) AS member_email,
		due_date, 
		return_date,
		CASE
			WHEN return_date IS NULL THEN return_date - '2026-06-30'
			ELSE return_date - due_date
		END AS days_overdue
	FROM stg_checkout) AS derivedCheckouts
WHERE return_date IS NULL or return_date > due_date
ORDER BY days_overdue DESC, checkout_id;