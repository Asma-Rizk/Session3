-- create db
CREATE DATABASE StoreDB
go

USE StoreDB1
go

-- create schemas
CREATE SCHEMA production;
go

CREATE SCHEMA sales;
go

-- create tables
CREATE TABLE production.categories (
	category_id INT IDENTITY (1, 1) PRIMARY KEY,
	category_name VARCHAR (255) NOT NULL
);
INSERT INTO production.categories (category_name)
VALUES ('Electronics'), ('Furniture'), ('Clothing');


CREATE TABLE production.brands (
	brand_id INT IDENTITY (1, 1) PRIMARY KEY,
	brand_name VARCHAR (255) NOT NULL
);

INSERT INTO production.brands (brand_name)
VALUES ('Samsung'), ('Apple'), ('Nike');


CREATE TABLE production.products (
	product_id INT IDENTITY (1, 1) PRIMARY KEY,
	product_name VARCHAR (255) NOT NULL,
	brand_id INT NOT NULL,
	category_id INT NOT NULL,
	model_year SMALLINT NOT NULL,
	list_price DECIMAL (10, 2) NOT NULL,
	FOREIGN KEY (category_id) REFERENCES production.categories (category_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (brand_id) REFERENCES production.brands (brand_id) ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO production.products (product_name, brand_id, category_id, model_year, list_price)
VALUES 
('Galaxy S21', 1, 1, 2022, 1200),
('iPhone 14', 2, 1, 2023, 1400),
('Smart TV', 1, 1, 2021, 2000),
('Sneakers', 3, 3, 2023, 500),
('Office Chair', 2, 2, 2020, 800);


CREATE TABLE sales.customers (
	customer_id INT IDENTITY (1, 1) PRIMARY KEY,
	first_name VARCHAR (255) NOT NULL,
	last_name VARCHAR (255) NOT NULL,
	phone VARCHAR (25),
	email VARCHAR (255) NOT NULL,
	street VARCHAR (255),
	city VARCHAR (50),
	state VARCHAR (25),
	zip_code VARCHAR (5)
);

INSERT INTO sales.customers (first_name, last_name, phone, email, street, city, state, zip_code)
VALUES 
('Ali', 'Ahmed', '0111111111', 'ali@gmail.com', 'Street 1', 'Cairo', 'CA', '12345'),
('Sara', 'Youssef', NULL, 'sara@yahoo.com', 'Street 2', 'New York', 'NY', '54321'),
('Khaled', 'Samir', '0102222222', 'khaled@gmail.com', 'Street 3', 'San Diego', 'CA', '98765');


CREATE TABLE sales.stores (
	store_id INT IDENTITY (1, 1) PRIMARY KEY,
	store_name VARCHAR (255) NOT NULL,
	phone VARCHAR (25),
	email VARCHAR (255),
	street VARCHAR (255),
	city VARCHAR (255),
	state VARCHAR (10),
	zip_code VARCHAR (5)
);
INSERT INTO sales.stores (store_name, phone, email, street, city, state, zip_code)
VALUES 
('Store A', '0109876543', 'storea@mail.com', 'Main St', 'Cairo', 'CA', '45678');


CREATE TABLE sales.staffs (
	staff_id INT IDENTITY (1, 1) PRIMARY KEY,
	first_name VARCHAR (50) NOT NULL,
	last_name VARCHAR (50) NOT NULL,
	email VARCHAR (255) NOT NULL UNIQUE,
	phone VARCHAR (25),
	active tinyint NOT NULL,
	store_id INT NOT NULL,
	manager_id INT,
	FOREIGN KEY (store_id) REFERENCES sales.stores (store_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (manager_id) REFERENCES sales.staffs (staff_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

INSERT INTO sales.staffs (first_name, last_name, email, phone, active, store_id, manager_id)
VALUES 
('Omar', 'Adel', 'omar@store.com', '0100000000', 1, 1, NULL),  
('Nada', 'Hassan', 'nada@store.com', NULL, 0, 1, 1);          


CREATE TABLE sales.orders (
	order_id INT IDENTITY (1, 1) PRIMARY KEY,
	customer_id INT,
	order_status tinyint NOT NULL,
	-- Order status: 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed
	order_date DATE NOT NULL,
	required_date DATE NOT NULL,
	shipped_date DATE,
	store_id INT NOT NULL,
	staff_id INT NOT NULL,
	FOREIGN KEY (customer_id) REFERENCES sales.customers (customer_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (store_id) REFERENCES sales.stores (store_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (staff_id) REFERENCES sales.staffs (staff_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

INSERT INTO sales.orders (customer_id, order_status, order_date, required_date, shipped_date, store_id, staff_id)
VALUES 
(1, 2, '2023-01-10', '2023-01-15', '2023-01-12', 1, 1),
(2, 4, '2023-02-10', '2023-02-20', NULL, 1, 2);


CREATE TABLE sales.order_items (
	order_id INT,
	item_id INT,
	product_id INT NOT NULL,
	quantity INT NOT NULL,
	list_price DECIMAL (10, 2) NOT NULL,
	discount DECIMAL (4, 2) NOT NULL DEFAULT 0,
	PRIMARY KEY (order_id, item_id),
	FOREIGN KEY (order_id) REFERENCES sales.orders (order_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (product_id) REFERENCES production.products (product_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE production.stocks (
	store_id INT,
	product_id INT,
	quantity INT,
	PRIMARY KEY (store_id, product_id),
	FOREIGN KEY (store_id) REFERENCES sales.stores (store_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (product_id) REFERENCES production.products (product_id) ON DELETE CASCADE ON UPDATE CASCADE
);

SELECT * FROM production.products
WHERE list_price>1000;

SELECT * FROM sales.customers
WHERE State IN ('CA', 'NY');

SELECT * FROM sales.orders
WHERE YEAR(order_date)=2023;

SELECT * FROM sales.customers
WHERE email LIKE '%@gmail.com';

SELECT * FROM sales.staffs
WHERE active = 0;

SELECT TOP 5 *
FROM production.products
ORDER BY list_price DESC;

SELECT TOP 10*
FROM sales.orders
ORDER BY order_date DESC;

SELECT TOP 3*
FROM sales.customers
ORDER BY last_name ASC;

SELECT *
FROM sales.customers
WHERE phone IS NULL;

SELECT *
FROM sales.staffs
WHERE manager_id IS NOT NULL;

SELECT category_id,
COUNT(*) AS total_products
FROM production.products
GROUP BY category_id;

SELECT state,
COUNT(*) AS total_customers
FROM sales.customers
GROUP BY state;

SELECT brand_id,
AVG(list_price) AS avg_price
FROM production.products
GROUP BY brand_id;

SELECT staff_id,
count (*) AS total_order
FROM sales.orders
GROUP BY staff_id;

SELECT customer_id
FROM sales.orders
GROUP BY customer_id
HAVING COUNT(*) > 2;


SELECT *
FROM production.products
WHERE list_price between 500 AND 1500;


SELECT *
FROM sales.customers
WHERE city LIKE 's%' ;


SELECT *
FROM sales.orders
WHERE order_status IN(2 , 4);

SELECT *
FROM production.products
WHERE category_id IN (1, 2, 3);

SELECT *
FROM sales.staffs
WHERE store_id = 1 OR phone IS NULL;
