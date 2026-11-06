#Seems to be good
INSERT INTO stg_member(member_id, first_name, last_name, email, zip, join_date, status) 
	SELECT
		member_id, 
		first_name, 
		last_name, 
		LOWER(TRIM(email)),
		LPAD(zip, 5, 0),
		CASE
			WHEN LOCATE('/', joined) != 0 THEN STR_TO_DATE(joined,'%m/%d/%Y') 
			ELSE STR_TO_DATE(joined,'%Y-%m-%d') 
		END, 
		REPLACE(LOWER(status), ' ', '_')
	FROM members
	WHERE member_id IN (SELECT MIN(member_id) FROM members GROUP BY LOWER(TRIM(email)));

#Check about the comma part, but otherwise seems good to me
INSERT INTO stg_tools(tool_id, name, brand, category_id, purchase_date, purchase_price, tool_condition)
	SELECT 
		tool_id,
		name,
		brand,
		(SELECT category_id FROM stg_category WHERE LOWER(stg_category.name) = LOWER(TRIM(inventory.category))),
		CASE
			WHEN LOCATE('/', purchased) != 0 THEN STR_TO_DATE(purchased,'%m/%d/%Y') 
			ELSE STR_TO_DATE(purchased,'%Y-%m-%d')
		END,
		REPLACE(REPLACE(price, ',', ''), '$', ''),
		LOWER(REPLACE(`condition`, ' ', '_')) 
	FROM inventory;


#Seems to be good? But there might be an issue with the staff linking...
INSERT INTO stg_checkout(checkout_id, tool_id, member_id, staff_id, checkout_date, due_date, return_date, late_fee)
	SELECT * FROM ( 
		SELECT DISTINCT 
			loan_id,
			tool_id,
			(SELECT member_id FROM stg_member WHERE stg_member.email = LOWER(TRIM(loans.member_email))),
			(SELECT staff_id FROM stg_staff WHERE stg_staff.email = LOWER(TRIM(loans.staff_email))),
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
		FROM loans) AS derivedLoanInfo
	WHERE (tool_id IN (SELECT tool_id FROM stg_tools)) AND (returnValue IS NULL OR returnValue >= outValue);


#Seems to be good
INSERT INTO stg_category(category_id, name, daily_late_fee, max_loan_days, requires_certification)
	SELECT 
		category_id,
		name,
		daily_late_fee, #THIS NEEDS TO BE TURNED INTO DOLLAR FORMAT?
		max_loan_days,
		CASE 
 			WHEN requires_cert = 'Y' THEN TRUE
 			ELSE FALSE
 		END
	FROM categories

#Seems to be good
INSERT INTO stg_certification(member_id, category_id, certified_on)
	SELECT
		(SELECT member_id FROM stg_member WHERE stg_member.email = LOWER(TRIM(certifications.member_email))),
		(SELECT category_id FROM stg_category WHERE stg_category.name = LOWER(TRIM(certifications.category))),
		CASE
			WHEN LOCATE('/', certified_on) != 0 THEN STR_TO_DATE(certified_on,'%m/%d/%Y') 
			ELSE STR_TO_DATE(certified_on,'%Y-%m-%d')
		END
	FROM certifications;

#Seems to be good
INSERT INTO stg_staff(staff_id, first_name, last_name, email)
	SELECT
		staff_id,
		first_name,
		last_name,
		LOWER(TRIM(email))
	FROM staff;
