
-- QUESTION #1
SELECT
    c.customer_name
    ,p.product_name
    ,s.total_amount
FROM sales AS s 
LEFT JOIN customers AS c 
    ON s.customer_id = c.customer_id 
LEFT JOIN products AS p 
    ON s.product_id = p.product_id 
WHERE s.sale_date >= ADDDATE(CURDATE(), INTERVAL -30 DAY);

--QUESTION #2
SELECT 
    p.category
    ,SUM(s.total_amount)
FROM sales AS s 
LEFT JOIN products AS p 
    ON s.product_id = p.product_id
WHERE s.sale_date >= ADDDATE(CURDATE(), INTERVAL -1 YEAR)
GROUP BY p.category;

-- QUESTION #3
SELECT 
    DISTINCT c.customer_name
FROM sales AS s 
LEFT JOIN customers AS c
    ON s.customer_id = c.customer_id
WHERE YEAR(s.sale_date) = 2023
    AND c.sales_region = 'West';

-- QUESTION #4
SELECT
    c.customer_name as "Customer Name"
    ,COUNT(DISTINCT s.sales_id) as "Total Number of Sales"
    ,SUM(s.quantity) as "Total Quantity Sold"
    ,SUM(s.quantity * p.price) as "Total Revenue"
FROM sales AS s 
LEFT JOIN customers AS c 
    ON s.customer_id = c.customer_id
LEFT JOIN products AS p 
    ON s.product_id = p.product_id
GROUP BY c.customer_id;

-- QUESTION 5
SELECT 
    c.customer_name
    ,SUM(s.quantity * p.price) as "Total Revenue"
FROM sales AS s 
LEFT JOIN customers AS c
    ON s.customer_id = c.customer_id
LEFT JOIN products AS p 
    ON s.product_id = p.product_id
WHERE YEAR(s.sale_date) = 2023
GROUP BY c.customer_id
ORDER BY "Total Revenue" DESC
LIMIT 3;

-- QUESTION 6
WITH ttl_qnty AS (
    SELECT 
        p.product_id
        ,SUM(s.quantity) as tqs
    FROM sales AS s 
    LEFT JOIN products AS p 
        ON s.product_id = p.product_id
    WHERE YEAR(s.sale_date) = 2023
    GROUP BY s.product_id 
)
SELECT 
    p.product_name 
    ,t.tqs as "Total Quantity Sold"
    ,RANK() OVER (ORDER BY t.tqs DESC) as "Rank"
FROM ttl_qnty AS t
LEFT JOIN products AS p
    ON p.product_id = t.product_id
ORDER BY t.tqs DESC;

-- QUESTION #7
SELECT 
    customer_name
    ,sales_region 
    ,CASE 
        WHEN sign_up_date >= ADDDATE(CURDATE(), INTERVAL -6 MONTH) THEN "New"
        ELSE "Existing"
    END as category 
FROM customers;

-- QUESTION #8
WITH ttl_sales AS (
    SELECT 
        LAST_DAY(s.sale_date) as ldotm
        ,p.price * s.quantity as ttl_revenue
    FROM sales AS s 
    LEFT JOIN products AS p 
        ON s.product_id = p.product_id
    WHERE s.sale_date >= ADDDATE(CURDATE(), INTERVAL -12 MONTH)
)
SELECT 
    CONCAT(MONTHNAME(ldotm), ' ', YEAR(ldotm)) as month_year
    ,SUM(ttl_revenue) as total_sales
FROM ttl_sales
GROUP BY ldotm;

-- QUESTION #9
SELECT
    p.category
FROM sales AS s 
LEFT JOIN products AS p
    ON s.product_id = p.product_id
WHERE s.sale_date >= ADDDATE(CURDATE(), INTERVAL -6 MONTH)
GROUP BY p.category
HAVING SUM(p.price * s.quantity) > 50000;

-- QUESTION #10
SELECT 
    s.sales_id
FROM sales AS s 
LEFT JOIN products AS p 
    ON s.product_id = p.product_id
WHERE (p.price * s.quantity) != s.total_amount;