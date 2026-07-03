-- CUSTOMERS
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state CHAR(2)
);

-- SELLERS
CREATE TABLE sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state CHAR(2)
);

-- PRODUCT
CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g FLOAT,
    product_length_cm FLOAT,
    product_height_cm FLOAT,
    product_width_cm FLOAT
);

--Product Category Translation
CREATE TABLE product_category_translation (
    product_category_name VARCHAR(100) PRIMARY KEY,
    product_category_name_english VARCHAR(100)
);

-- Orders
CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(30),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP,

    CONSTRAINT fk_customer
    FOREIGN KEY(customer_id)
    REFERENCES customers(customer_id)
);

-- Order Items
CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date TIMESTAMP,
    price NUMERIC(10,2),
    freight_value NUMERIC(10,2),

    PRIMARY KEY(order_id, order_item_id),

    FOREIGN KEY(order_id)
    REFERENCES orders(order_id),

    FOREIGN KEY(product_id)
    REFERENCES products(product_id),

    FOREIGN KEY(seller_id)
    REFERENCES sellers(seller_id)
);

-- Order Payments
CREATE TABLE order_payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(30),
    payment_installments INT,
    payment_value NUMERIC(10,2),

    PRIMARY KEY(order_id, payment_sequential),

    FOREIGN KEY(order_id)
    REFERENCES orders(order_id)
);
-- 8. Order Reviews
CREATE TABLE order_reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP,

    PRIMARY KEY(review_id),

    FOREIGN KEY(order_id)
    REFERENCES orders(order_id)
);
-- 9. Geolocation
CREATE TABLE geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat DOUBLE PRECISION,
    geolocation_lng DOUBLE PRECISION,
    geolocation_city VARCHAR(100),
    geolocation_state CHAR(2)
);

SELECT COUNT(*) FROM order_reviews;

SELECT review_id, COUNT(*)
FROM order_reviews
GROUP BY review_id
HAVING COUNT(*) > 1;

TRUNCATE TABLE order_reviews;


SELECT COUNT(*) FROM order_reviews;

SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM sellers;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM product_category_translation;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM order_items;
SELECT COUNT(*) FROM order_payments;
SELECT COUNT(*) FROM order_reviews;
SELECT COUNT(*) FROM geolocation;
-- Total Orders, Total Revenue & Average Order Value
SELECT
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(op.payment_value), 2) AS total_revenue,
    ROUND(SUM(op.payment_value) / COUNT(DISTINCT o.order_id), 2) AS average_order_value
FROM orders o
JOIN order_payments op
ON o.order_id = op.order_id;

--  Order Count by Status
SELECT
    order_status,
    COUNT(*) AS total_orders,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- Top 10 Product Categories by Revenue
SELECT
    pct.product_category_name_english AS category,
    ROUND(SUM(op.payment_value), 2) AS total_revenue
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
JOIN order_payments op
    ON o.order_id = op.order_id
JOIN products p
    ON oi.product_id = p.product_id
JOIN product_category_translation pct
    ON p.product_category_name = pct.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY pct.product_category_name_english
ORDER BY total_revenue DESC
LIMIT 10;
-- Top 10 States by Number of Orders
SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY total_orders DESC
LIMIT 10;
-- Monthly Order Trend (2016–2018)
SELECT
    DATE_TRUNC('month', order_purchase_timestamp) AS order_month,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY DATE_TRUNC('month', order_purchase_timestamp)
ORDER BY order_month;

-- Average Delivery Time (Actual vs Estimated) by State
SELECT
    c.customer_state,
    ROUND(
        AVG(
            o.order_delivered_customer_date::DATE -
            o.order_purchase_timestamp::DATE
        ),
        2
    ) AS avg_actual_delivery_days,

    ROUND(
        AVG(
            o.order_estimated_delivery_date::DATE -
            o.order_purchase_timestamp::DATE
        ),
        2
    ) AS avg_estimated_delivery_days

FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id

WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL

GROUP BY c.customer_state

ORDER BY avg_actual_delivery_days DESC;
-- states performing worse than expected
SELECT
    c.customer_state,

    ROUND(
        AVG(
            (o.order_delivered_customer_date::DATE -
             o.order_estimated_delivery_date::DATE)
        ),
        2
    ) AS avg_delay_days

FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id

WHERE o.order_status = 'delivered'

GROUP BY c.customer_state

ORDER BY avg_delay_days DESC;


-- Late Delivery Rate by Product Category
SELECT
    pct.product_category_name_english AS product_category,

    COUNT(*) AS total_orders,

    SUM(
        CASE
            WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS late_orders,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS late_delivery_rate

FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
JOIN product_category_translation pct
    ON p.product_category_name = pct.product_category_name

WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL

GROUP BY pct.product_category_name_english

HAVING COUNT(*) >= 100

ORDER BY late_delivery_rate DESC;

-- Payment Type Distribution & Average Order Value
SELECT
    payment_type,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(payment_value), 2) AS total_revenue,
    ROUND(AVG(payment_value), 2) AS avg_order_value,

    ROUND(
        COUNT(DISTINCT order_id) * 100.0 /
        SUM(COUNT(DISTINCT order_id)) OVER (),
        2
    ) AS order_percentage

FROM order_payments

GROUP BY payment_type

ORDER BY total_revenue DESC;

-- Sellers with More Than 100 Orders and Their Average Review Score
SELECT
    s.seller_id,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    ROUND(AVG(orv.review_score), 2) AS avg_review_score
FROM sellers s
JOIN order_items oi
    ON s.seller_id = oi.seller_id
JOIN orders o
    ON oi.order_id = o.order_id
JOIN order_reviews orv
    ON o.order_id = orv.order_id

WHERE o.order_status = 'delivered'

GROUP BY s.seller_id

HAVING COUNT(DISTINCT oi.order_id) > 100

ORDER BY avg_review_score DESC, total_orders DESC;
-- Repeat Customer Rate
-- WITH customer_orders AS (
--     SELECT
--         customer_id,
--         COUNT(order_id) AS total_orders
--     FROM orders
--     WHERE order_status = 'delivered'
--     GROUP BY customer_id
-- )

-- SELECT
--     COUNT(*) AS total_customers,

--     SUM(
--         CASE
--             WHEN total_orders > 1 THEN 1
--             ELSE 0
--         END
--     ) AS repeat_customers,

--     ROUND(
--         100.0 *
--         SUM(
--             CASE
--                 WHEN total_orders > 1 THEN 1
--                 ELSE 0
--             END
--         ) / COUNT(*),
--         2
--     ) AS repeat_customer_rate
-- FROM customer_orders;



WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(o.order_id) AS total_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)

SELECT
    COUNT(*) AS total_customers,

    SUM(
        CASE
            WHEN total_orders > 1 THEN 1
            ELSE 0
        END
    ) AS repeat_customers,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN total_orders > 1 THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS repeat_customer_rate
FROM customer_orders;


-- Month-over-Month (MoM) Revenue Growth using LAG()
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month,
        ROUND(SUM(op.payment_value), 2) AS total_revenue
    FROM orders o
    JOIN order_payments op
        ON o.order_id = op.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp)
)

SELECT
    order_month,
    total_revenue,

    LAG(total_revenue) OVER (ORDER BY order_month) AS previous_month_revenue,

    ROUND(
        (
            (total_revenue -
            LAG(total_revenue) OVER (ORDER BY order_month))
            /
            LAG(total_revenue) OVER (ORDER BY order_month)
        ) * 100,
        2
    ) AS mom_growth_percentage

FROM monthly_revenue
ORDER BY order_month;
-- Rank Sellers by Revenue Within Each State
WITH seller_revenue AS (
    SELECT
        s.seller_state,
        s.seller_id,
        ROUND(SUM(op.payment_value), 2) AS total_revenue
    FROM sellers s
    JOIN order_items oi
        ON s.seller_id = oi.seller_id
    JOIN orders o
        ON oi.order_id = o.order_id
    JOIN order_payments op
        ON o.order_id = op.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY s.seller_state, s.seller_id
)

SELECT
    seller_state,
    seller_id,
    total_revenue,

    RANK() OVER (
        PARTITION BY seller_state
        ORDER BY total_revenue DESC
    ) AS seller_rank

FROM seller_revenue

ORDER BY seller_state, seller_rank;

-- Running Total Revenue using Window Function
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month,
        ROUND(SUM(op.payment_value), 2) AS monthly_revenue
    FROM orders o
    JOIN order_payments op
        ON o.order_id = op.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp)
)

SELECT
    order_month,
    monthly_revenue,

    ROUND(
        SUM(monthly_revenue)
        OVER (
            ORDER BY order_month
        ),
        2
    ) AS running_total_revenue

FROM monthly_revenue

ORDER BY order_month;

-- Customer Cohort Analysis (Monthly Retention)
--
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month
    FROM orders o
    JOIN customers c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),

first_purchase AS (
    SELECT
        customer_unique_id,
        MIN(order_month) AS cohort_month
    FROM customer_orders
    GROUP BY customer_unique_id
),

cohort_data AS (
    SELECT
        fp.cohort_month,
        co.order_month,

        (
            EXTRACT(YEAR FROM AGE(co.order_month, fp.cohort_month)) * 12
            +
            EXTRACT(MONTH FROM AGE(co.order_month, fp.cohort_month))
        ) AS cohort_index,

        co.customer_unique_id

    FROM customer_orders co
    JOIN first_purchase fp
        ON co.customer_unique_id = fp.customer_unique_id
)

SELECT
    cohort_month,
    cohort_index,
    COUNT(DISTINCT customer_unique_id) AS active_customers
FROM cohort_data
GROUP BY
    cohort_month,
    cohort_index
ORDER BY
    cohort_month,
    cohort_index;
-- Top 3 Product Categories by Revenue in Each State
WITH category_revenue AS (

    SELECT
        c.customer_state,
        pct.product_category_name_english AS product_category,

        ROUND(
            SUM(oi.price + oi.freight_value),
            2
        ) AS total_revenue

    FROM orders o

    JOIN customers c
        ON o.customer_id = c.customer_id

    JOIN order_items oi
        ON o.order_id = oi.order_id

    JOIN products p
        ON oi.product_id = p.product_id

    LEFT JOIN product_category_translation pct
        ON p.product_category_name = pct.product_category_name

    WHERE o.order_status = 'delivered'

    GROUP BY
        c.customer_state,
        pct.product_category_name_english
),

ranked_categories AS (

    SELECT
        customer_state,
        product_category,
        total_revenue,

        ROW_NUMBER() OVER (
            PARTITION BY customer_state
            ORDER BY total_revenue DESC
        ) AS category_rank

    FROM category_revenue
)

SELECT
    customer_state,
    product_category,
    total_revenue,
    category_rank

FROM ranked_categories

WHERE category_rank <= 3

ORDER BY
    customer_state,
    category_rank;


--RFM Analysis
WITH customer_rfm AS (

    SELECT
        c.customer_unique_id,

        MAX(o.order_purchase_timestamp::DATE) AS last_purchase_date,

        (
            SELECT MAX(order_purchase_timestamp::DATE)
            FROM orders
        ) -
        MAX(o.order_purchase_timestamp::DATE)
        AS recency,

        COUNT(DISTINCT o.order_id) AS frequency,

        ROUND(
            SUM(oi.price + oi.freight_value),
            2
        ) AS monetary

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    JOIN order_items oi
        ON o.order_id = oi.order_id

    WHERE o.order_status = 'delivered'

    GROUP BY
        c.customer_unique_id
),

rfm_scores AS (

SELECT
*,

-- NTILE(5) OVER(
-- ORDER BY recency ASC
-- ) AS recency_score,

(6 - NTILE(5) OVER(
    ORDER BY recency ASC
)) AS recency_score,

NTILE(5) OVER(
ORDER BY frequency
) AS frequency_score,

NTILE(5) OVER(
ORDER BY monetary
) AS monetary_score

FROM customer_rfm

)

SELECT
customer_unique_id,
recency,
frequency,
monetary,
recency_score,
frequency_score,
monetary_score,

CONCAT(
recency_score,
frequency_score,
monetary_score
) AS rfm_score,

CASE
    WHEN recency_score >= 4 AND frequency_score >= 4 THEN 'Champion'
    WHEN recency_score >= 3 AND frequency_score >= 3 THEN 'Loyal Customer'
    WHEN recency_score >= 4 AND frequency_score <= 2 THEN 'New Customer'
    WHEN recency_score <= 2 AND frequency_score >= 3 THEN 'At Risk'
    WHEN recency_score <= 2 AND frequency_score <= 2 THEN 'Lost'
    ELSE 'Potential Loyalist'
END AS customer_segment

FROM rfm_scores
ORDER BY rfm_score DESC;

-- Delivery Delay Root Cause Analysis
SELECT
    s.seller_state,
    c.customer_state,

    COUNT(DISTINCT o.order_id) AS total_orders,

    ROUND(
        AVG(
            o.order_delivered_customer_date::DATE -
            o.order_estimated_delivery_date::DATE
        ),
        2
    ) AS avg_delay_days

FROM orders o

JOIN customers c
    ON o.customer_id = c.customer_id

JOIN order_items oi
    ON o.order_id = oi.order_id

JOIN sellers s
    ON oi.seller_id = s.seller_id

WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL

GROUP BY
    s.seller_state,
    c.customer_state

HAVING COUNT(DISTINCT o.order_id) >= 30

ORDER BY
    avg_delay_days DESC;

-- Revenue Leakage Analysis

SELECT
    o.order_id,
    o.order_status,
    ROUND(SUM(op.payment_value), 2) AS payment_received,
    c.customer_state
FROM orders o
JOIN order_payments op
    ON o.order_id = op.order_id
JOIN customers c
    ON o.customer_id = c.customer_id
WHERE o.order_status IN ('canceled', 'unavailable')
GROUP BY
    o.order_id,
    o.order_status,
    c.customer_state
HAVING SUM(op.payment_value) > 0
ORDER BY payment_received DESC;

-- Summary KPI Query (Recommended)
SELECT
    COUNT(DISTINCT o.order_id) AS leaked_orders,
    ROUND(SUM(op.payment_value), 2) AS total_revenue_leakage
FROM orders o
JOIN order_payments op
    ON o.order_id = op.order_id
WHERE o.order_status IN ('canceled', 'unavailable')
AND op.payment_value > 0;
-- Seller Performance Report (fn_seller_report)
CREATE OR REPLACE FUNCTION fn_seller_report(p_seller_id VARCHAR)
RETURNS TABLE (
    seller_id VARCHAR,
    total_orders BIGINT,
    total_revenue NUMERIC,
    avg_review_score NUMERIC,
    avg_delivery_days NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN

RETURN QUERY

SELECT

    s.seller_id,

    COUNT(DISTINCT o.order_id) AS total_orders,

    ROUND(
        SUM(oi.price + oi.freight_value),
        2
    ) AS total_revenue,

    ROUND(
        AVG(orv.review_score),
        2
    ) AS avg_review_score,

    ROUND(
        AVG(
            o.order_delivered_customer_date::DATE -
            o.order_purchase_timestamp::DATE
        ),
        2
    ) AS avg_delivery_days

FROM sellers s

JOIN order_items oi
ON s.seller_id = oi.seller_id

JOIN orders o
ON oi.order_id = o.order_id

LEFT JOIN order_reviews orv
ON o.order_id = orv.order_id

WHERE
s.seller_id = p_seller_id
AND o.order_status='delivered'

GROUP BY s.seller_id;

END;
$$;

SELECT seller_id
FROM sellers
LIMIT 5;

SELECT *
FROM fn_seller_report('3442f8959a84dea7ee197c632cb2df15');

--Create View 
CREATE OR REPLACE VIEW vw_daily_kpi AS

SELECT

    o.order_purchase_timestamp::DATE AS order_date,

    COUNT(DISTINCT o.order_id) AS total_orders,

    ROUND(
        SUM(op.payment_value),
        2
    ) AS total_revenue,

    ROUND(
        AVG(orv.review_score),
        2
    ) AS avg_review_score,

    COUNT(
        CASE
            WHEN o.order_delivered_customer_date >
                 o.order_estimated_delivery_date
            THEN 1
        END
    ) AS late_delivery_count

FROM orders o

LEFT JOIN order_payments op
ON o.order_id = op.order_id

LEFT JOIN order_reviews orv
ON o.order_id = orv.order_id

WHERE o.order_status='delivered'

GROUP BY
o.order_purchase_timestamp::DATE;

SELECT *
FROM vw_daily_kpi
ORDER BY order_date;

---for 10 days
SELECT *
FROM vw_daily_kpi
ORDER BY order_date DESC
LIMIT 10;


------------------
-- Indexes banao
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_status ON orders(order_status);
CREATE INDEX idx_order_items_seller ON order_items(seller_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);

-- Before/After test karo
EXPLAIN ANALYZE
SELECT COUNT(*) FROM orders WHERE order_status = 'delivered';

-------------------
-- Audit log table
CREATE TABLE order_audit_log (
    log_id      SERIAL PRIMARY KEY,
    order_id    VARCHAR(50),
    action      VARCHAR(20),
    logged_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Trigger function
CREATE OR REPLACE FUNCTION trg_log_new_order()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO order_audit_log(order_id, action)
    VALUES (NEW.order_id, 'INSERT');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger
CREATE TRIGGER trg_after_order_insert
AFTER INSERT ON orders
FOR EACH ROW
EXECUTE FUNCTION trg_log_new_order();