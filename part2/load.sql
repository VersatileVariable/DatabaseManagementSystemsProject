TRUNCATE TABLE library_test.stg_category;


LOAD DATA INFILE '../data/category.csv' 
INTO TABLE library_test.stg_category 
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES;

INSERT INTO library_test.category (category_id, name, daily_late_fee, max_loan_days, requires_certification) 
SELECT 
    CAST(TRIM(category_id) AS SIGNED), 
    TRIM(name), 
    CAST(TRIM(daily_late_fee) AS DECIMAL(6,2)), 
    CAST(TRIM(max_loan_days) AS SIGNED),
    CAST(TRIM(requires_certification) AS SIGNED)
FROM library_test.stg_category 
WHERE category_id IS NOT NULL AND TRIM(category_id) != '';


--unresolved

BULK INSERT library_test.member
FROM '..\data\member.csv'
WITH 
(
    join_date DATE,
    FIRSTROW=2
)

BULK INSERT library_test.staff
FROM '..\data\staff.csv'
WITH 
(
    FIRSTROW=2
)


BULK INSERT library_test.tool
FROM '..\data\tool.csv'
WITH 
(
    purchase_date DATE,
    FIRSTROW=2
)

BULK INSERT library_test.certification
FROM '..\data\certification.csv'
WITH 
(
    certified_on DATE,
    FIRSTROW=2
)

BULK INSERT library_test.checkout
FROM '..\data\checkout.csv'
WITH 
(
    checkout_date DATE,
    due_date DATE,
    return_date DATE,
    FIRSTROW=2
)