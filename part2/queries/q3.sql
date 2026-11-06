SELECT checkout_id, tool_name, member_email, due_date, days_overdue FROM (
	SELECT
		checkout_id, 
		(SELECT name FROM tool WHERE checkout.tool_id = tool.tool_id) AS tool_name, 
		(SELECT email FROM member WHERE checkout.member_id = member.member_id) AS member_email,
		due_date, 
		return_date,
		(DATEDIFF('2026-06-30', due_date)) AS days_overdue
	FROM checkout) AS derivedCheckouts
WHERE return_date IS NULL AND '2026-06-30' > due_date
ORDER BY days_overdue DESC, checkout_id;