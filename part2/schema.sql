CREATE TABLE category (
  category_id INT PRIMARY KEY NOT NULL,
  name VARCHAR(50) UNIQUE NOT NULL,
  daily_late_fee DECIMAL(6,2) NOT NULL CHECK(daily_late_fee >= 0),
  max_loan_days INT NOT NULL CHECK (max_loan_days >= 1),
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
  category_id INT NOT NULL,

  purchase_date DATE NOT NULL,
  purchase_price DECIMAL(8,2) NOT NULL CHECK (purchase_price >= 0),
  tool_condition ENUM('good', 'fair', 'needs_repair', 'retired') NOT NULL,
	
  FOREIGN KEY (category_id) REFERENCES category(category_id)

);

CREATE TABLE certification (
  member_id INT NOT NULL,
  category_id INT NOT NULL,
  certified_on DATE NOT NULL,
  PRIMARY KEY (member_id, category_id),
  FOREIGN KEY (member_id) REFERENCES member(member_id),
  FOREIGN KEY (category_id) REFERENCES category(category_id)
);

CREATE TABLE checkout (
  checkout_id INT AUTO_INCREMENT PRIMARY KEY,
  tool_id INT NOT NULL,
  member_id INT NOT NULL,
  staff_id INT NOT NULL,
  checkout_date DATE NOT NULL,
  due_date DATE NOT NULL,
  return_date DATE,
  late_fee DECIMAL(8,2) DEFAULT 0.00 NOT NULL CHECK (late_fee >= 0),
  FOREIGN KEY (tool_id) REFERENCES tool(tool_id),
  FOREIGN KEY (member_id) REFERENCES member(member_id),
  FOREIGN KEY (staff_id) REFERENCES staff(staff_id),
  CONSTRAINT check1 CHECK (due_date >= checkout_date),
  CONSTRAINT check2 CHECK(return_date IS NULL OR return_date >= checkout_date)
);