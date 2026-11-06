INSERT INTO category(category_id, name, daily_late_fee, max_loan_days, requires_certification)
	SELECT 
		category_id,
		name,
		daily_late_fee, #THIS NEEDS TO BE TURNED INTO DOLLAR FORMAT?
		max_loan_days,
		CASE 
			WHEN requires_certification = 'Y' THEN TRUE
 			ELSE FALSE
 		END
	FROM stg_category;

INSERT INTO member(member_id, first_name, last_name, email, zip, join_date, status) 
	SELECT
		member_id, 
		first_name, 
		last_name, 
		LOWER(TRIM(email)),
		LPAD(zip, 5, 0),
		CASE
			WHEN LOCATE('-', join_date) != 0 THEN STR_TO_DATE(join_date,'%Y-%m-%d')  
			ELSE STR_TO_DATE(join_date,'%m/%d/%Y')
		END, 
		REPLACE(LOWER(status), ' ', '_')
	FROM stg_member
	WHERE member_id IN (SELECT MIN(member_id) FROM stg_member GROUP BY LOWER(TRIM(email)));

INSERT INTO staff(staff_id, first_name, last_name, email)
	SELECT
		staff_id,
		first_name,
		last_name,
		LOWER(TRIM(email))
	FROM stg_staff;

#Check about the comma part, but otherwise seems good to me
INSERT INTO tool(tool_id, name, brand, category_id, purchase_date, purchase_price, tool_condition)
	SELECT 
		tool_id,
		name,
		brand,
		(SELECT category_id FROM stg_category WHERE LOWER(stg_category.name) = LOWER(TRIM(stg_tool.category_name))),
		CASE
			WHEN LOCATE('/', purchase_date) != 0 THEN STR_TO_DATE(purchase_date,'%m/%d/%Y') 
			ELSE STR_TO_DATE(purchase_date,'%Y-%m-%d')
		END,
		REPLACE(REPLACE(purchase_price, ',', ''), '$', ''),
		LOWER(REPLACE(tool_condition, ' ', '_'))
	FROM stg_tool;

INSERT INTO certification(member_id, category_id, certified_on)
	SELECT
		(SELECT member_id FROM member WHERE member.email = LOWER(TRIM(stg_certification.member_email))),
		(SELECT category_id FROM category WHERE category.name = LOWER(TRIM(stg_certification.category_name))),
		CASE
			WHEN LOCATE('/', certified_on) != 0 THEN STR_TO_DATE(certified_on,'%m/%d/%Y') 
			ELSE STR_TO_DATE(certified_on,'%Y-%m-%d')
		END
	FROM stg_certification;

INSERT INTO checkout(checkout_id, tool_id, member_id, staff_id, checkout_date, due_date, return_date, late_fee)
	SELECT * FROM ( 
		SELECT DISTINCT 
			loan_id,
			tool_id,
			(SELECT member_id FROM `member` WHERE `member`.email = LOWER(TRIM(stg_checkout.member_email))),
			(SELECT staff_id FROM staff WHERE staff.email = LOWER(TRIM(stg_checkout.staff_email))),
			CASE 
				WHEN LOCATE('/', out_date) != 0 THEN STR_TO_DATE(out_date,'%m/%d/%Y') 
				ELSE STR_TO_DATE(out_date,'%Y-%m-%d') 
			END AS outValue,
			CASE
				WHEN LOCATE('/', due_date) != 0 THEN STR_TO_DATE(due_date,'%m/%d/%Y') 
				ELSE STR_TO_DATE(due_date,'%Y-%m-%d') 
			END,
			CASE
				WHEN LOCATE('/', back_date) != 0 THEN STR_TO_DATE(back_date,'%m/%d/%Y') 
				WHEN LOCATE('-', back_date) != 0 THEN STR_TO_DATE(back_date,'%Y-%m-%d') 
				ELSE NULL
			END AS returnValue,
			fee_charged
			#CHECK ABOUT PRICING HERE
		FROM stg_checkout) AS derivedLoanInfo
	WHERE (tool_id IN (SELECT tool_id FROM tool)) AND (returnValue IS NULL OR returnValue >= outValue);









