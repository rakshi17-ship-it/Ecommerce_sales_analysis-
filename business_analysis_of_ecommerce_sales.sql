--1. How many records and orders are in the dataset?

---Business purpose: Understand the size of the dataset and how many distinct orders it contains.

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT order_id) AS unique_orders
FROM cleaned_ecommerce_sales;

---Business solution: This helps establish the scope of the analysis and identify whether repeated orders need further investigation.
------------------
--2. What is the total recorded order value?

---Business purpose: Calculate the sum of the available monetary totals.

SELECT
    SUM(total) AS total_recorded_order_value
FROM cleaned_ecommerce_sales;

---Business solution: This gives an initial measure of the order value recorded in the dataset, but it should not automatically be reported as actual realized revenue.

--------------
--3. What is the average order value?

----Business purpose: Find the average recorded order amount.

SELECT
    ROUND(AVG(total), 2) AS average_recorded_order_value
FROM cleaned_ecommerce_sales;

---Business solution: Average order value can help a business understand typical transaction size.However, if the table contains multiple rows for the same order, this is an average per row,not necessarily an average per order.
----------------------------------
--4. How many orders are in each status?

---Business purpose: Understand how orders are distributed across their current statuses.
SELECT
    status,
    COUNT(*) AS record_count,
    COUNT(DISTINCT order_id) AS unique_orders
FROM cleaned_ecommerce_sales
GROUP BY status
ORDER BY record_count DESC;

----Business solution: A large number of processing or cancelled orders may indicate areas worth investigating. The data alone won't establish the reason.
---------------------------
--5. What percentage of orders have been delivered?

---Business purpose: Measure the share of records with a delivered status.

SELECT
    COUNT(*) AS total_records,
    COUNT(*) FILTER (
        WHERE LOWER(TRIM(status)) = 'delivered'
    ) AS delivered_records,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE LOWER(TRIM(status)) = 'delivered'
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS delivered_record_percentage
FROM cleaned_ecommerce_sales;

---Business solution: This provides a basic delivery-status indicator. Because the percentage uses records rather than distinct orders, label it a delivered-record percentage. If each order has multiple rows, we'll need to calculate the percentage at the order level instead.
-----------------------
-- Question 6: Which product categories have the highest recorded sales value?

---Business purpose: Compare recorded order value by category.

SELECT
    category,
    SUM(total) AS recorded_order_value
FROM cleaned_ecommerce_sales
GROUP BY category
ORDER BY recorded_order_value DESC NULLS LAST;

-- Business solution:The Books category has the highest recorded order value (37,604.71), followed by Home (24,429.71) and Clothing (23,203.03). Missing category labels and the negative Electronics value require further investigation before making final business decisions.

-------------------------------------
-- Question 7: Which products have the highest recorded sales value?

---Business purpose: Rank products by recorded order value.

SELECT
    product,
    SUM(total) AS recorded_order_value
FROM cleaned_ecommerce_sales
GROUP BY product
ORDER BY recorded_order_value DESC NULLS LAST;

-- Business solution:
-- Shoes has the highest recorded order value (16,987.08),
-- followed by Comics (14,454.34) and Lamp (14,306.44).
-- Blender has a large negative value (-11,924.62)
-- that requires further investigation.
-------------------------
-- Question 8: Which products have the highest total quantity?
-- Business purpose: Compare quantities across products.

SELECT
    product,
    SUM(quantity) AS total_quantity
FROM cleaned_ecommerce_sales
GROUP BY product
ORDER BY total_quantity DESC NULLS LAST;

-- Business solution: Shoes has the highest total quantity at 33 units,followed by Comics (25) and Science (24). Headphones has the lowest quantity at 3 units.

---------------------------------

-- Question 9: Which payment methods are used most frequently?
-- Business purpose: Compare payment-method usage.

SELECT
    payment_method,
    COUNT(*) AS record_count
FROM cleaned_ecommerce_sales
GROUP BY payment_method
ORDER BY record_count DESC;

-- Business solution: Cash on Delivery is the most popular payment method. Offering prepaid discounts may encourage digital payments.

---------------------------------------

-- Question 10: How does recorded order value vary by payment method?
-- Business purpose: Compare available totals across payment methods.

SELECT
    payment_method,
    SUM(total) AS recorded_order_value
FROM cleaned_ecommerce_sales
GROUP BY payment_method
ORDER BY recorded_order_value DESC NULLS LAST;
-------------------------
-- Question 11: Which customers have the highest recorded order value?
-- Business purpose: Identify the top 10 customers by total recorded order value.

SELECT
    customer_name,
    SUM(total) AS recorded_order_value,
    COUNT(DISTINCT order_id) AS total_orders
FROM cleaned_ecommerce_sales
GROUP BY customer_name
ORDER BY recorded_order_value DESC NULLS LAST
LIMIT 10;

-- Business solution: Customer_142 has the highest recorded order value (4,548.71).

---------------------------------

-- Question 12: Which payment methods are used most frequently?
-- Business purpose: Compare payment-method usage.

SELECT
    payment_method,
    COUNT(*) AS record_count
FROM cleaned_ecommerce_sales
GROUP BY payment_method
ORDER BY record_count DESC;

-- Business solution: Cash on Delivery is the most frequently used payment method (33 records). Bank Transfer is the least used (22 records).

----------------------------
-- Question 13: Which payment methods have the highest recorded order value?
-- Business purpose: Compare available order totals by payment method.

SELECT
    payment_method,
    SUM(total) AS recorded_order_value
FROM cleaned_ecommerce_sales
GROUP BY payment_method
ORDER BY recorded_order_value DESC NULLS LAST;

-- Business solution: Bank Transfer has the highest recorded order value (41,612.83). Cash on Delivery has the lowest (21,241.65).

---------------------------------

-- Question 14: How does order status vary across product categories?
-- Business purpose: Examine category-level order status patterns.

SELECT
    category,
    status,
    COUNT(*) AS record_count
FROM cleaned_ecommerce_sales
GROUP BY category, status
ORDER BY category, record_count DESC;

-- Business solution: Compare order statuses across categories to identify where cancellations, returns, or processing delays may need attention.
----------------------------------------------------------------

-- Project Conclusion:
-- Analyzed e-commerce sales, product quantities, payment methods,
-- customer order values, and order statuses.
-- Identified sales patterns and data quality issues for further investigation.

































