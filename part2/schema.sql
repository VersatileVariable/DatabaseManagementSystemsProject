CREATE TABLE category (
  category_id INT PRIMARY KEY NOT NULL,
  name VARCHAR(50) unique NOT NULL,
  daily_late_fee DECIMAL(6,2) NOT NULL,
  max_loan_days INT NOT NULL,
  requires_certification BOOLEAN NOT NULL
);

CREATE TABLE member (
  member_id INT PRIMARY KEY NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,

  email VARCHAR(100) UNIQUE NOT NULL,
  zip CHAR(5) NOT NULL,
  join_date DATE NOT NULL,
  status ENUM('active', 'suspended') NOT NULL
);

CREATE TABLE staff (
  staff_id INT PRIMARY KEY NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE tool (
  tool_id INT PRIMARY KEY NOT NULL,
  name VARCHAR(100) NOT NULL,
  brand VARCHAR(50) NOT NULL,
  category_id INT FOREIGN KEY REFERENCES category(category_id) NOT NULL,

  purchase_date DATE NOT NULL,
  purchase_price DECIMAL(8,2) NOT NULL,
  tool_condition ENUM('good', 'fair', 'needs_repair', 'retired') NOT NULL
);

CREATE TABLE certification (
  --composite primary key for member and category (I need help making it)
  member_id INT FOREIGN KEY REFERENCES member(member_id) NOT NULL,
  category_id INT FOREIGN KEY REFERENCES category(category_id) NOT NULL,

  certified_on DATE NOT NULL,
  PRIMARY KEY (member_id, category_id)
);

CREATE TABLE checkout (
  checkout_id INT AUTO_INCREMENT PRIMARY KEY,
  tool_id INT FOREIGN KEY REFERENCES tool(tool_id) NOT NULL,
  member_id INT FOREIGN KEY REFERENCES member(member_id) NOT NULL,
  staff_id INT FOREIGN KEY REFERENCES staff(staff_id) NOT NULL,

  checkout_date DATE NOT NULL,
  due_date DATE NOT NULL,
  --nullable return date
  return_date DATE,

  late_fee DECIMAL(8,2) DEFAULT 0.00 NOT NULL
);