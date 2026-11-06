SELECT * FROM (
	SELECT
		member_id, 
		(SELECT first_name FROM member WHERE checkout.member_id = member.member_id) AS first_name,
		(SELECT last_name FROM member WHERE checkout.member_id = member.member_id) AS last_name,
		SUM(late_fee) AS total_fees
	FROM checkout
	GROUP BY member_id) AS derivedLateFees
WHERE total_fees > 75.00
ORDER BY total_fees DESC, member_id;