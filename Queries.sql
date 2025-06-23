-- Questions 

USE pizzahut;

-- Retrive the total number of orders placed
SELECT count(*) AS total_orders FROM orders;

-- Calculate the total revenue generated from pizza sales.
SELECT round(sum(od.quantity*pz.price),2) as total_sales FROM order_details as od
JOIN pizzas as pz ON
	pz.pizza_id=od.pizza_id;


-- Identify the highest-priced pizza.
SELECT pt.name,pz.price FROM pizza_types as pt 
JOIN pizzas as pz ON
	pt.pizza_type_id=pz.pizza_type_id 
ORDER BY pz.price desc limit 1;


-- Identify the most common pizza size ordered.
SELECT pz.size,sum(od.quantity) as order_count FROM pizzas as pz
JOIN order_details as od ON
	od.pizza_id=pz.pizza_id
GROUP BY pz.size;

SELECT pz.size,COUNT(od.order_details_id) FROM pizzas as pz
JOIN order_details as od ON
	od.pizza_id=pz.pizza_id
GROUP BY pz.size;


-- List the top 5 most ordered pizza types along with their quantities.
SELECT pt.name,sum(od.quantity)as sum FROM pizzas as pz
JOIN pizza_types as pt ON
	pt.pizza_type_id=pz.pizza_type_id
JOIN order_details as od ON
	od.pizza_id=pz.pizza_id
GROUP BY pt.name
ORDER BY sum DESC LIMIT 5;

-- Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT pt.catogery,sum(od.quantity) as quantity
FROM pizza_types as pt
JOIN pizzas as pz ON
	pz.pizza_type_id=pt.pizza_type_id
JOIN order_details as od ON
	od.pizza_id=pz.pizza_id
GROUP BY pt.catogery ORDER BY quantity DESC;


-- Determine the distribution of orders by hour of the day.
SELECT hour(order_time) as time,count(order_id) as order_count
FROM orders as ods
GROUP BY time;

-- Join relevant tables to find the category-wise distribution of pizzas.
SELECT catogery,count(name) as count FROM pizza_types
GROUP BY catogery;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
select round(avg(quantity),0) as avg_order_per_day FROM
(SELECT ods.order_date,sum(od.quantity) as quantity FROM orders as ods
JOIN order_details as od ON
	ods.order_id=od.order_id
GROUP BY ods.order_date) as order_quantity;


-- Determine the top 3 most ordered pizza types based on revenue.
SELECT pizza_types.name,sum(order_details.quantity*pizzas.price) as revenue
FROM pizza_types
JOIN pizzas ON pizzas.pizza_type_id=pizza_types.pizza_type_id
JOIN order_details ON order_details.pizza_id=pizzas.pizza_id
GROUP BY pizza_types.name ORDER BY revenue DESC LIMIT 3;


-- Calculate the percentage contribution of each pizza type to total revenue.
SELECT pt.catogery,(sum(od.quantity*pz.price)/(select
		round(sum(od.quantity*pz.price),2) as total_sales
        FROM order_details as od
        JOIN pizzas as pz ON 
			pz.pizza_id=od.pizza_id))*100 as revenue
FROM pizza_types as pt 
JOIN pizzas as pz ON 
	pz.pizza_type_id=pt.pizza_type_id
JOIN order_details as od ON
	od.pizza_id=pz.pizza_id
GROUP BY pt.catogery ORDER BY revenue DESC;

-- Analyze the cumulative revenue generated over time.
SELECT order_date,sum(revenue) over(order by order_date) as cum_revenue FROM 
(SELECT ods.order_date,sum(od.quantity*pz.price) as revenue
FROM order_details as od 
JOIN pizzas as pz ON
	pz.pizza_id=od.pizza_id
JOIN orders as ods ON
	ods.order_id=od.order_id
GROUP BY ods.order_date) as sales;


-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
SELECT name,revenue FROM
(SELECT catogery,name,revenue,rank() over(partition by catogery order by revenue desc) as rn
FROM
(SELECT pt.catogery,pt.name,sum(od.quantity*pz.price) as revenue 
FROM pizza_types as pt
JOIN pizzas as pz ON
	pt.pizza_type_id=pz.pizza_type_id
JOIN order_details as od ON
	od.pizza_id=pz.pizza_id
GROUP BY pt.catogery,pt.name) as a) as b WHERE rn<=3;