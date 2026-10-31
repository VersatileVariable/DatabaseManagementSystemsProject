CREATE TABLE category (
  category_id INT PRIMARY KEY,
  name VARCHAR(50) unique,
  daily_late_fee DECIMAL(6,2),
  max_loan_days INT,
  requires_certification BOOLEAN
);

CREATE TABLE member (
  member_id INT PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),

  email VARCHAR(100) UNIQUE,
  zip CHAR(5),
  join_date DATE,
  status ENUM('active', 'suspended')
);

CREATE TABLE staff (
  staff_id INT PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(100) UNIQUE
);

CREATE TABLE tool (
  tool_id INT PRIMARY KEY,
  name VARCHAR(100),
  brand VARCHAR(50),
  category_id INT FOREIGN KEY REFERENCES category(category_id),

  purchase_date DATE,
  purchase_price DECIMAL(8,2),
  tool_condition ENUM('good', 'fair', 'needs_repair', 'retired')
);

CREATE TABLE certification (
  --composite primary key for member and category (I need help making it)
  member_id INT FOREIGN KEY REFERENCES member(member_id) ,
  category_id INT FOREIGN KEY REFERENCES category(category_id),

  certified_on DATE
);

CREATE TABLE checkout (
  checkout_id INT AUTO_INCREMENT PRIMARY KEY,
  tool_id INT FOREIGN KEY REFERENCES tool(tool_id),
  member_id INT FOREIGN KEY REFERENCES member(member_id),
  staff_id INT FOREIGN KEY REFERENCES staff(staff_id),

  checkout_date DATE,
  due_date DATE,
  --nullable return date
  return_date DATE,

  late_fee DECIMAL(8,2) DEFAULT 0.00
);