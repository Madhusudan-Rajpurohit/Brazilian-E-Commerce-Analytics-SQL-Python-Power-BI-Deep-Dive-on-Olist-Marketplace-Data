CREATE DATABASE Brazilian_E_Commerce_Database;

USE Brazilian_E_Commerce_Database;

-- Primary Keys

A LTER TABLE customers ADD PRIMARY KEY (customer_id);
ALTER TABLE products ADD PRIMARY KEY (product_id);
ALTER TABLE sellers ADD PRIMARY KEY (seller_id);
ALTER TABLE category_translation ADD PRIMARY KEY (product_category_name);
ALTER TABLE orders ADD PRIMARY KEY (order_id);
ALTER TABLE reviews ADD PRIMARY KEY (review_id);

-- COMPOSITE keys

ALTER TABLE order_items ADD PRIMARY KEY (order_id, order_item_id);
ALTER TABLE payments ADD PRIMARY KEY (order_id, payment_sequential);

-- Foreign keys
ALTER TABLE orders
    ADD FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

ALTER TABLE order_items
    ADD FOREIGN KEY (order_id) REFERENCES orders(order_id),
    ADD FOREIGN KEY (product_id) REFERENCES products(product_id),
    ADD FOREIGN KEY (seller_id) REFERENCES sellers(seller_id);

ALTER TABLE payments
    ADD FOREIGN KEY (order_id) REFERENCES orders(order_id);

ALTER TABLE reviews
    ADD FOREIGN KEY (order_id) REFERENCES orders(order_id);
    
/* Top 5 most expensive products ever sold */

SELECT product_id, price
FROM order_items
ORDER BY price DESC
LIMIT 5;


/* Order count by status */

SELECT order_status, count(*) AS num_orders
FROM orders
GROUP BY order_status
ORDER BY num_orders DESC;


/* Average freight cost per order */

SELECT round(AVG(freight_value), 2) AS avg_freight_cost
FROM order_items;


/* Category with the most items sold */

SELECT
    ct.product_category_name_english AS category,
    count(oi.order_item_id) AS items_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN category_translation ct ON p.product_category_name = ct.product_category_name
GROUP BY category
ORDER BY items_sold DESC
LIMIT 1;


/* Unique customers vs. total orders */

SELECT
    count(DISTINCT customer_unique_id) AS unique_customers,
    count(order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id;


/* Top 5 customers by total spend */

SELECT
    c.customer_unique_id,
    count(DISTINCT o.order_id) AS num_orders,
    round(sum(oi.price + oi.freight_value), 2) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_unique_id
ORDER BY total_spent DESC
LIMIT 5;


/* Monthly revenue trend */

SELECT 
   date_format(o.order_purchase_timestamp, '%Y-%m') AS Month,
   round(sum(oi.price + oi.freight_value), 2) AS Total_Revenue,
   count(distinct o.order_id) AS Total_Orders
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status != 'canceled'
GROUP BY month
ORDER BY month;

/* Top 10 categories by revenue  */

SELECT
    ct.product_category_name_english AS category,
    round(sum(oi.price), 2) AS total_revenue,
    count(oi.order_item_id) AS items_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN category_translation ct ON p.product_category_name = ct.product_category_name
GROUP BY category
ORDER BY total_revenue DESC
LIMIT 10;

/* Monthly revenue growth */

WITH monthly_revenue AS (
    SELECT
        date_format(o.order_purchase_timestamp, '%Y-%m') AS month,
        sum(oi.price + oi.freight_value) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status != 'canceled'
    GROUP BY month
)
SELECT
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS prev_month_revenue,
    round(((revenue - LAG(revenue) OVER (ORDER BY month)) / LAG(revenue) OVER (ORDER BY month)) * 100, 2) AS pct_growth
FROM monthly_revenue
ORDER BY month;

/* Top seller per category, ranked */

SELECT * FROM (
    SELECT
        ct.product_category_name_english AS category,
        oi.seller_id,
        sum(oi.price) AS revenue,
        RANK() OVER (
            PARTITION BY ct.product_category_name_english
            ORDER BY sum(oi.price) DESC
        ) AS rank_in_category
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    JOIN category_translation ct ON p.product_category_name = ct.product_category_name
    GROUP BY category, oi.seller_id
) AS ranked
WHERE rank_in_category <= 3
ORDER BY category, rank_in_category;

/* Delivery performance: % of orders delivered late */

SELECT
    round(100.0 * SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END)
          / COUNT(*), 2) AS pct_late,
    count(*) AS total_delivered_orders
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;

/* Delivery delay vs. review score */

SELECT
    r.review_score,
    round(AVG(datediff(o.order_delivered_customer_date, o.order_estimated_delivery_date)), 2) AS avg_delay_days,
    count(*) AS num_orders
FROM orders o
JOIN reviews r ON o.order_id = r.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY r.review_score
ORDER BY r.review_score;

/* Payment method breakdown by order value tier */

SELECT
    payment_type,
    count(*) AS num_payments,
    round(AVG(payment_value), 2) AS avg_payment_value,
    round(sum(payment_value), 2) AS total_value
FROM payments
GROUP BY payment_type
ORDER BY total_value DESC;

/* Revenue by state  */

SELECT
    c.customer_state,
    round(sum(oi.price + oi.freight_value), 2) AS total_revenue,
    count(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC;


/* First and most recent order date per customer */

SELECT
    c.customer_unique_id,
    min(o.order_purchase_timestamp) AS first_order_date,
    max(o.order_purchase_timestamp) AS most_recent_order_date,
    count(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
ORDER BY total_orders DESC;














