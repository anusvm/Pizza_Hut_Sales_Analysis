CREATE DATABASE pizzahut;
use pizzahut;

CREATE TABLE pizza_types (
    pizza_type_id VARCHAR(30) PRIMARY KEY,
    name TEXT,
    catogery VARCHAR(25),
    ingredients TEXT
);
SELECT * FROM pizza_types;


CREATE TABLE pizzas (
	pizza_id VARCHAR(30) NOT NULL PRIMARY KEY,
    pizza_type_id VARCHAR(30),
    size TEXT,
    price FLOAT
);
SELECT * FROM pizzas;

ALTER TABLE pizzas
	ADD CONSTRAINT fk_pizza_type
	FOREIGN KEY (pizza_type_id) REFERENCES pizza_types(pizza_type_id);



DROP TABLE orders;
CREATE TABLE orders (
	order_id INT NOT NULL PRIMARY KEY,
    order_data DATE,
    order_time TIME
);
SELECT * FROM orders;

ALTER TABLE orders
	RENAME COLUMN order_data TO order_date;



DROP TABLE order_details;
CREATE TABLE order_details (
	order_details_id INT NOT NULL PRIMARY KEY,
    order_id INT NOT NULL,
    pizza_id VARCHAR(30) NOT NULL,
    quantity INT NOT NULL
);
SELECT * FROM order_details;

ALTER TABLE order_details
	ADD CONSTRAINT fk_order_id
    FOREIGN KEY(order_id) REFERENCES orders(order_id),
    ADD CONSTRAINT fk_pizza_id
    FOREIGN KEY(pizza_id) REFERENCES pizzas(pizza_id);