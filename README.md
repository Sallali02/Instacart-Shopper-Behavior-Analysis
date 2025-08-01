# Instacart-Shopper-Behavior-Analysis
Analyzed Instacart grocery data to uncover customer shopping patterns, product popularity, and reorder behavior. Explored market basket insights to identify frequently bought-together items and optimal ordering times. Provides actionable recommendations for boosting sales and improving customer experience.

## Project Goals
This project begins with using SQL for preliminary analysis to explore the Instacart data and answer key business questions about customer behavior and product trends. The next phase involves using R for deeper statistical analysis and machine learning to uncover patterns and predict user actions. Finally, Tableau is used to create interactive dashboards that bring all insights together for clear and effective storytelling.

## Data
The Instacart dataset contains over 3 million grocery orders from 200,000 users. It includes six tables: orders, order_products_prior, order_products_train, products, aisles, and departments. Key variables include user ID, product ID, order timing (day and hour), product names, department and aisle information, and flags indicating if a product was reordered. The data captures both past (prior) and current (train) orders, allowing for in-depth analysis of user behavior and product trends.

## 📊Instacart Data Analysis Summary

**Understanding Customer Ordering Patterns**</br>
Analysis of order volume by day of the week shows that Sundays experience the highest number of orders, while mid-week days like Thursday see the fewest. This suggests that customers tend to shop more on weekends, likely due to having more free time to restock groceries. Similarly, hourly order data reveals that most purchases occur between 9 AM and 4 PM, peaking around 10–11 AM. Instacart can leverage these insights by optimizing staffing, marketing campaigns, and delivery logistics to match these peak demand times, ensuring smooth customer experiences and efficient operations.

**Popular Products, Departments, and Shopping Behavior**</br>
The top purchased products are largely fresh, organic produce such as bananas, strawberries, and spinach, highlighting customers’ preference for healthy food options. Departments like Produce, Dairy & Eggs, and Beverages dominate in order counts, confirming that fresh and essential grocery categories are the backbone of customer shopping habits. Moreover, the average order contains about 10 products, indicating customers prefer bulk shopping rather than quick single-item trips. This presents opportunities for cross-selling and bundling complementary items to increase basket sizes and enhance sales.

**Customer Loyalty and Repeat Purchases**</br>
More than half of the purchases (around 59%) are reorders, demonstrating strong customer loyalty and predictable shopping habits. Staple items like milk and purified water exhibit especially high reorder rates, suggesting that these essentials drive repeat business. Instacart can capitalize on this by offering subscription options, loyalty deals, or priority stocking to ensure these products are always available, thus improving customer satisfaction and retention.

**Purchase Frequency and Customer Segmentation**</br>
Customers place orders roughly every 10 days on average, with some reordering on the same day. Understanding this purchasing cadence enables Instacart to time personalized promotions, reminders, or discounts effectively to increase repeat purchase rates. Additionally, the analysis of first-time purchases shows that new customers are most attracted to Produce and Dairy & Eggs departments. Targeting marketing efforts and introductory promotions in these categories can help attract and retain new shoppers.

**Insights from Product Pairing and Aisle Popularity**</br>
Market basket analysis reveals that certain product pairs—like Organic Strawberries and Bananas or Organic Baby Spinach and Hass Avocados—are frequently bought together. These complementary purchasing patterns can guide bundling strategies and personalized recommendations to increase order value. Fresh vegetables and fruits also lead the list of aisles with the highest product purchases, reinforcing the importance of maintaining strong supply chains and inventory for these categories to meet demand and maximize sales.
