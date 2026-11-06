SELECT * FROM (
	SELECT
		member_id, 
		(SELECT first_name FROM stg_member WHERE stg_checkout.member_id = stg_member.member_id) AS first_name,
		(SELECT last_name FROM stg_member WHERE stg_checkout.member_id = stg_member.member_id) AS last_name,
		SUM(late_fee) AS fee
	FROM stg_checkout
	GROUP BY member_id) AS derivedLateFees
WHERE fee > 75.00
ORDER BY fee DESC, member_id;
