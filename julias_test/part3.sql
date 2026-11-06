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