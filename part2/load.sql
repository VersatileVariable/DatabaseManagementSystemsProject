CREATE TABLE stg_category (
  category_id INT PRIMARY KEY,
  name VARCHAR(50) UNIQUE,
  daily_late_fee DECIMAL(6,2) CHECK(daily_late_fee >= 0),
  max_loan_days INT CHECK (max_loan_days >= 1),
  requires_certification VARCHAR(1)
);

CREATE TABLE stg_member (
  member_id INT PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(100),
  zip CHAR(5),
  join_date VARCHAR(10),
  status ENUM('active', 'suspended')
);

CREATE TABLE stg_staff (
  staff_id INT PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(100) UNIQUE
);

CREATE TABLE stg_tool (
  tool_id INT PRIMARY KEY,
  name VARCHAR(100),
  brand VARCHAR(50),
  category_name VARCHAR(50),
  purchase_date VARCHAR(15),
  purchase_price VARCHAR(50),
  tool_condition VARCHAR(50)
);

CREATE TABLE stg_certification (
  member_email VARCHAR(100),
  category_name VARCHAR(50),
  certified_on VARCHAR(15)
);

CREATE TABLE stg_checkout (
  loan_id INT,
  tool_id INT,
  tool_name VARCHAR(100),
  category VARCHAR(50),
  member_email VARCHAR(100),
  member_name VARCHAR(100),
  member_zip CHAR(5),
  out_date VARCHAR(20),
  due_date VARCHAR(20),
  back_date VARCHAR(20),
  staff_email VARCHAR(100),
  fee_charged VARCHAR(20)
);

LOAD DATA
	LOCAL INFILE 'data/categories.csv'
	INTO TABLE stg_category
	FIELDS TERMINATED BY ',' 
	OPTIONALLY ENCLOSED BY '"' 
	LINES TERMINATED BY '\n' 
	IGNORE 1 LINES;

LOAD DATA
	LOCAL INFILE 'data/members.csv'
	INTO TABLE stg_member
	FIELDS TERMINATED BY ',' 
	OPTIONALLY ENCLOSED BY '"' 
	LINES TERMINATED BY '\n' 
	IGNORE 1 LINES;

LOAD DATA
	LOCAL INFILE 'data/staff.csv'
	INTO TABLE stg_staff
	FIELDS TERMINATED BY ',' 
	OPTIONALLY ENCLOSED BY '"' 
	LINES TERMINATED BY '\n' 
	IGNORE 1 LINES;

LOAD DATA
	LOCAL INFILE 'data/inventory.csv'
	INTO TABLE stg_tool
	FIELDS TERMINATED BY ',' 
	OPTIONALLY ENCLOSED BY '"' 
	LINES TERMINATED BY '\n' 
	IGNORE 1 LINES;

LOAD DATA
	LOCAL INFILE 'data/certifications.csv'
	INTO TABLE stg_certification
	FIELDS TERMINATED BY ',' 
	OPTIONALLY ENCLOSED BY '"' 
	LINES TERMINATED BY '\n' 
	IGNORE 1 LINES;

LOAD DATA
	LOCAL INFILE 'data/loans.csv'
	INTO TABLE stg_checkout
	FIELDS TERMINATED BY ',' 
	OPTIONALLY ENCLOSED BY '"' 
	LINES TERMINATED BY '\n' 
	IGNORE 1 LINES;

INSERT INTO category(category_id, name, daily_late_fee, max_loan_days, requires_certification)
	SELECT 
		category_id,
		name,
		daily_late_fee,
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

INSERT INTO checkout(checkout_id, tool_id, member_id, staff_id, checkout_date, due_date, return_date,late_fee)
	SELECT loan_id, tool_id, mem_id, stff_id, outDate, dueDate, returnDate,
		(CASE 
			WHEN returnDate IS NULL THEN 0
			WHEN returnDate <= dueDate THEN 0
			ELSE (DATEDIFF(returnDate, dueDate) * 
				(SELECT daily_late_fee FROM category 
					WHERE category_id = (SELECT category_id FROM tool WHERE derivedLoanInfo.tool_id = tool.tool_id)))
		END) AS late_fee
	FROM ( 
		SELECT DISTINCT 
			loan_id,
			tool_id,
			(SELECT member_id FROM `member` WHERE `member`.email = LOWER(TRIM(stg_checkout.member_email))) AS mem_id,
			(SELECT staff_id FROM staff WHERE staff.email = LOWER(TRIM(stg_checkout.staff_email))) AS stff_id,
			CASE 
				WHEN LOCATE('/', out_date) != 0 THEN STR_TO_DATE(out_date,'%m/%d/%Y') 
				ELSE STR_TO_DATE(out_date,'%Y-%m-%d') 
			END AS outDate,
			CASE
				WHEN LOCATE('/', due_date) != 0 THEN STR_TO_DATE(due_date,'%m/%d/%Y') 
				ELSE STR_TO_DATE(due_date,'%Y-%m-%d') 
			END AS dueDate,
			CASE
				WHEN LOCATE('/', back_date) != 0 THEN STR_TO_DATE(back_date,'%m/%d/%Y') 
				WHEN LOCATE('-', back_date) != 0 THEN STR_TO_DATE(back_date,'%Y-%m-%d') 
				ELSE NULL
			END AS returnDate
		FROM stg_checkout) AS derivedLoanInfo
	WHERE (tool_id IN (SELECT tool_id FROM tool)) AND (returnDate IS NULL OR returnDate >= outDate);
