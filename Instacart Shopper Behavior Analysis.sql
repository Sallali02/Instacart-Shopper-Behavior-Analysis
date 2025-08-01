---PRELIMINARY ANALYSIS----

-- See how many rows each table has (gives you a sense of dataset size)
SELECT 'orders' AS table_name, COUNT(*) AS total_rows FROM orders
UNION ALL
SELECT 'order_products_prior', COUNT(*) FROM order_products_prior
UNION ALL
SELECT 'order_products_train', COUNT(*) FROM order_products_train
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'departments', COUNT(*) FROM departments
UNION ALL
SELECT 'aisles', COUNT(*) FROM aisles;


-- See column names & data types for the orders table
PRAGMA table_info(orders);

-- Repeat for other tables if needed
PRAGMA table_info(order_products_prior);


-- Check missing values for orders table
SELECT 
  SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS missing_order_id,
  SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS missing_user_id,
  SUM(CASE WHEN order_number IS NULL THEN 1 ELSE 0 END) AS missing_order_number,
  SUM(CASE WHEN order_dow IS NULL THEN 1 ELSE 0 END) AS missing_order_dow,
  SUM(CASE WHEN days_since_prior_order IS NULL THEN 1 ELSE 0 END) AS missing_days_since_prior_order
FROM orders;


-- Check if there are duplicate product_id entries in products table
SELECT product_id, COUNT(*) AS cnt
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1
LIMIT 10;


-- Quick min/max/avg for numeric columns in orders
SELECT 
  MIN(order_number) AS min_order_number,
  MAX(order_number) AS max_order_number,
  AVG(order_number) AS avg_order_number,
  MIN(days_since_prior_order) AS min_days,
  MAX(days_since_prior_order) AS max_days,
  AVG(days_since_prior_order) AS avg_days
FROM orders;



-- Find unusual values in days_since_prior_order
SELECT days_since_prior_order, COUNT(*) AS count_rows
FROM orders
GROUP BY days_since_prior_order
ORDER BY days_since_prior_order DESC;



-- How many orders per day of week?
SELECT order_dow, COUNT(*) AS num_orders
FROM orders
GROUP BY order_dow
ORDER BY order_dow;

-- Most popular departments
SELECT d.department, COUNT(*) AS product_count
FROM products p
JOIN departments d ON p.department_id = d.department_id
GROUP BY d.department
ORDER BY product_count DESC;


-------------ANSWERING ANALYTICAL BUSINESS QUESTIONS--------------

-- Code Chunk 0: Create combined table for prior orders 
CREATE TABLE all_data AS
SELECT 
    op.order_id,
    op.product_id,
    p.product_name,
    a.aisle,
    d.department,
    op.reordered,
    o.order_number,
    o.order_dow,
    o.order_hour_of_day,
    o.days_since_prior_order
FROM order_products_prior op
JOIN products p ON op.product_id = p.product_id
JOIN aisles a ON p.aisle_id = a.aisle_id
JOIN departments d ON p.department_id = d.department_id
JOIN orders o ON op.order_id = o.order_id
WHERE o.eval_set = 'prior';




-- 1️ Which days of the week have the highest number of orders?
SELECT 
  order_dow AS day_of_week,
  COUNT(*) AS total_orders
FROM orders
GROUP BY order_dow
ORDER BY total_orders DESC;
--This output shows that Sunday (0) had the highest number of orders, while Thursday (4) had the fewest. From a business perspective, this suggests that customer demand peaks on weekends, likely due to people restocking groceries during their free time. This insight can guide staffing, inventory planning, and marketing promotions to align with peak order days.


-- 2️ Which hours of the day are most popular for placing orders?
SELECT 
  order_hour_of_day,
  COUNT(*) AS total_orders
FROM orders
GROUP BY order_hour_of_day
ORDER BY total_orders DESC;
---This output shows that most orders are placed between 9 AM and 4 PM, peaking around 10–11 AM, while order activity is lowest during late-night and early-morning hours (especially between 12 AM and 5 AM). From a business perspective, this pattern highlights midday as the prime window for customer engagement, ideal for running promotions or ensuring system and staff readiness.


-- 3️ What are the top 10 most frequently purchased products?
SELECT 
  p.product_name,
  COUNT(*) AS total_purchases
FROM order_products_prior op
JOIN products p ON op.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_purchases DESC
LIMIT 15;
---This output shows that fresh produce, especially organic items like bananas, strawberries, and spinach, are the most frequently purchased products. From a business standpoint, this suggests that customers prioritize healthy, fresh food options, which could guide inventory planning, marketing campaigns, and supplier partnerships to focus more on organic and perishable goods.



-- 4️ Which departments receive the highest number of orders?
SELECT 
  d.department,
  COUNT(*) AS total_orders
FROM order_products_prior op
JOIN products p ON op.product_id = p.product_id
JOIN departments d ON p.department_id = d.department_id
GROUP BY d.department
ORDER BY total_orders DESC;
---This output indicates that the Produce, Dairy & Eggs, and Beverages departments receive the highest number of orders, highlighting their role as essential and frequently replenished categories in customers' shopping habits. From a business perspective, this insight can help prioritize stocking, promotions, and supplier relationships for these top-performing departments to maximize sales and customer satisfaction.


-- 5️ What is the average number of products per order?
SELECT 
  ROUND(AVG(product_count), 2) AS avg_products_per_order
FROM (
    SELECT 
        order_id,
        COUNT(product_id) AS product_count
    FROM order_products_prior
    GROUP BY order_id
);
---The average of 10.09 products per order suggests that Instacart customers tend to buy in bulk rather than making quick, one-off purchases. This indicates opportunities to optimize cross-selling and bundling strategies—for example, recommending complementary items (like milk with cereal or pasta with sauce) during checkout. Additionally, since shoppers are buying multiple items per order, Instacart can tailor promotions that encourage larger baskets (e.g., “Buy 10, get 1 free” or free delivery thresholds based on cart size), which can boost both order value and customer satisfaction.



-- 6️ Which products have the highest reorder rates (customer loyalty)?
SELECT 
  p.product_name,
  ROUND(AVG(CAST(op.reordered AS FLOAT)) * 100, 2) AS reorder_rate_percent,
  COUNT(*) AS total_orders
FROM order_products_prior op
JOIN products p ON op.product_id = p.product_id
GROUP BY p.product_name
HAVING COUNT(*) > 100  -- only consider products with decent sales volume
ORDER BY reorder_rate_percent DESC
LIMIT 10;
---This output shows that certain products, like milk and water, have very high reorder rates, meaning customers buy them again and again. These items are essential staples, so Instacart should make them easy to find and consider offering subscriptions or deals to increase customer loyalty. Ensuring these products are always in stock can also improve customer satisfaction and retention.


-- 7️ How many days do customers typically wait between orders?
SELECT 
  ROUND(AVG(days_since_prior_order), 2) AS avg_days_between_orders,
  MIN(days_since_prior_order) AS min_days,
  MAX(days_since_prior_order) AS max_days
FROM orders
WHERE days_since_prior_order IS NOT NULL;
--This output shows that on average, customers place a new order every 10.44 days. The minimum number of days between orders is 0, indicating some customers reorder on the same day. This suggests that Instacart customers tend to shop weekly to biweekly, which can help the business time personalized marketing, reminders, or discounts to align with their regular shopping cycles.


-- 8️ Which users place the most orders (top repeat customers)?
SELECT 
  user_id,
  COUNT(order_id) AS total_orders
FROM orders
GROUP BY user_id
ORDER BY total_orders DESC
LIMIT 10;


-- 9️ Which aisles have the highest number of purchased products?
SELECT 
  a.aisle,
  COUNT(*) AS total_products_purchased
FROM order_products_prior op
JOIN products p ON op.product_id = p.product_id
JOIN aisles a ON p.aisle_id = a.aisle_id
GROUP BY a.aisle
ORDER BY total_products_purchased DESC
LIMIT 10;
---This output shows that fresh vegetables and fruits are the top-selling aisles, indicating that Instacart shoppers prioritize fresh produce. This trend emphasizes the importance of maintaining strong supplier relationships, ensuring inventory availability, and potentially promoting related items or bundles to boost basket size in these high-demand categories.



-- 🔟 How many orders are reorders vs. first-time purchases?
SELECT 
  CASE 
    WHEN reordered = 1 THEN 'Reorder'
    ELSE 'First-time purchase'
  END AS purchase_type,
  COUNT(*) AS total_count,
  ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM order_products_prior), 2) AS percentage
FROM order_products_prior
GROUP BY purchase_type;
---This output shows that nearly 59% of products purchased on Instacart are reorders, meaning customers frequently repurchase the same items. This indicates strong customer loyalty and predictable shopping habits, which Instacart can leverage by improving personalized recommendations, offering subscription-style options, or promoting frequently reordered items more prominently.


-- 11. Which products are most frequently bought together?
-- This helps identify bundling opportunities and inform cross-selling strategies.
SELECT 
    a.product_name AS product_1, 
    b.product_name AS product_2, 
    COUNT(*) AS times_bought_together
FROM all_data a
JOIN all_data b 
    ON a.order_id = b.order_id AND a.product_id < b.product_id
GROUP BY a.product_name, b.product_name
ORDER BY times_bought_together DESC
LIMIT 10;
---This analysis reveals the top product pairs most frequently bought together by Instacart customers. For example, items like Organic Strawberries and Bananas or Organic Baby Spinach and Hass Avocados are often co-purchased, suggesting strong consumer preferences for certain healthy or complementary foods. Instacart can use this insight to create targeted product bundles, personalized recommendations, and promotional offers to boost sales and improve customer experience.



-- 12. What are the top departments where customers make first-time purchases?
-- This helps Instacart understand which categories are most appealing to new users.
SELECT 
    d.department, 
    COUNT(*) AS first_time_purchases
FROM order_products_prior p
JOIN orders o ON p.order_id = o.order_id
JOIN products pr ON p.product_id = pr.product_id
JOIN departments d ON pr.department_id = d.department_id
WHERE p.reordered = 0
GROUP BY d.department
ORDER BY first_time_purchases DESC
LIMIT 10;
---This output shows that the Produce and Dairy & Eggs departments have the highest number of first-time purchases, indicating that new customers are most likely to try fresh foods and everyday essentials when shopping on Instacart. This insight suggests that focusing marketing efforts and promotions on these departments could help attract and retain new users by highlighting popular, accessible products.


-- 13. How does time of day affect order volume?
-- This can guide marketing timing, staffing decisions, and delivery logistics.
SELECT 
    order_hour_of_day, 
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY order_hour_of_day
ORDER BY total_orders;
---This output confirms that the majority of Instacart orders occur during daytime hours, with a clear peak between 9 AM and 11 AM. Very few orders happen late at night or early morning, indicating that customer shopping activity is concentrated during typical waking hours. For the business, this means marketing campaigns, customer support, and delivery logistics should be optimized around these peak hours to maximize efficiency and customer satisfaction.



