--Extracting all the data to see if it matches my original data/table
SELECT * from coffeeshop.brightlearn.brightlearn_coffee_shop_2;

--Investigating the data
--To show how many stores are in the dataset
SELECT COUNT(DISTINCT store_id) AS total_stores
FROM coffeeshop.brightlearn.brightlearn_coffee_shop_2;

--Checking the different products sold
SELECT DISTINCT product_type
FROM coffeeshop.brightlearn.brightlearn_coffee_shop_2
ORDER BY product_type;

--Checking the top-selling products in descending order
SELECT
  product_detail,
  SUM(transaction_qty) AS total_quantity_sold
  FROM coffeeshop.brightlearn.brightlearn_coffee_shop_2
  GROUP BY product_detail
  ORDER BY total_quantity_sold DESC;

  --This is to show the top 3 best selling products
SELECT product_type, sum(transaction_qty) as Total_Drinks_Sold 
FROM coffeeshop.brightlearn.brightlearn_coffee_shop_2
GROUP BY product_type 
ORDER BY SUM(transaction_qty) DESC LIMIT 3;

--This is to show the 3 worst selling products
SELECT product_type, sum(transaction_qty) as Total_Drinks_Sold 
FROM coffeeshop.brightlearn.brightlearn_coffee_shop_2
GROUP BY product_type 
ORDER BY SUM(transaction_qty);

--Checking the number of transactions/ total revenue each store has
SELECT
  store_id,
  COUNT(*) AS total_transactions
FROM coffeeshop.brightlearn.brightlearn_coffee_shop_2
GROUP BY store_id
ORDER BY total_transactions DESC;

--Calculating the total revenue for all the stores
--This forms part of the new columns
SELECT
   SUM(CAST(REPLACE(unit_price, ',', '.') AS DECIMAL(10,2))
        * transaction_qty) AS total_revenue
FROM coffeeshop.brightlearn.brightlearn_coffee_shop_2;

--Calculating the first and last transaction dates (Jan - June)
  SELECT MIN(transaction_date) AS start_dt,
       MAX(transaction_date) AS last_dt 
FROM coffeeshop.brightlearn.brightlearn_coffee_shop_2;

--Checking the operating hours of the stores
SELECT MIN(transaction_time) AS opening_time,
       MAX(transaction_time) AS closing_time 
FROM coffeeshop.brightlearn.brightlearn_coffee_shop_2;

--Checking the number of products we are selling
SELECT  COUNT(DISTINCT product_id)AS number_of_products
FROM coffeeshop.brightlearn.brightlearn_coffee_shop_2;

--Coffee Shop "Big Code"
SELECT 
    transaction_date,
    store_location,
    product_category,
    product_type,
    product_detail,
    DAYNAME(transaction_date) AS Day_name,
    MONTHNAME(transaction_date) AS Month_name,
     COUNT(transaction_id) AS number_of_sales,
     SUM(transaction_qty) AS units_sold,
     COUNT(DISTINCT product_id) AS unique_products,
     COUNT(store_id) AS number_of_stores,
     SUM(transaction_qty * CAST(REPLACE(unit_price, ',', '.') AS DECIMAL(10,2))) AS revenue,

--Adding new columns, namely day_classification and time_classification using the CASE STATEMENT
--This is to classify the days of the week and time of day to further analyse our data and be able to categorise the data 
    CASE 
        WHEN DAYNAME(transaction_date) IN ('Sat','Sun') THEN 'Weekend'
        WHEN DAYNAME(transaction_date) IN ('Mon','Tue','Wed','Thu','Fri') THEN 'Weekday'
    END AS day_classification,

    CASE 
        WHEN HOUR(transaction_time) >= 6 AND HOUR(transaction_time) < 12 THEN 'Morning'
        WHEN HOUR(transaction_time) >= 12 AND HOUR(transaction_time) < 18 THEN 'Afternoon'
        WHEN HOUR(transaction_time) >= 18 AND HOUR(transaction_time) < 21 THEN 'Evening'
        ELSE 'Night' 
        END AS time_classification
     
FROM coffeeshop.brightlearn.brightlearn_coffee_shop_2

GROUP BY ALL;

--Checking the number of total orders made per day
SELECT DAYNAME(transaction_date) AS order_day,
COUNT(DISTINCT transaction_id) AS total_orders 
FROM coffeeshop.brightlearn.brightlearn_coffee_shop_2
 GROUP BY DAYNAME(transaction_date);

--Checking the number of total orders made per hour
SELECT HOUR(transaction_time) AS order_hours, 
COUNT(DISTINCT transaction_id) 
AS total_orders 
FROM coffeeshop.brightlearn.brightlearn_coffee_shop_2
GROUP BY order_hours 
ORDER BY order_hours;

--Checking the % of drink sales by category
SELECT product_category, 
SUM(transaction_qty * CAST(REPLACE(unit_price, ',', '.') AS DOUBLE)) as total_sales, 
SUM(transaction_qty * CAST(REPLACE(unit_price, ',', '.') AS DOUBLE))*100/SUM(SUM(transaction_qty * CAST(REPLACE(unit_price, ',', '.') AS DOUBLE))) OVER () AS percent_of_total_sales
FROM coffeeshop.brightlearn.brightlearn_coffee_shop_2
GROUP BY product_category;

--Checking the % of drink sales by size in descending order
SELECT element_at(split(product_detail, ' '), -1) AS drink_size, 
SUM(transaction_qty * CAST(REPLACE(unit_price, ',', '.') AS DOUBLE)) as total_sales, 
SUM(transaction_qty * CAST(REPLACE(unit_price, ',', '.') AS DOUBLE))*100/SUM(SUM(transaction_qty * CAST(REPLACE(unit_price, ',', '.') AS DOUBLE))) OVER () AS percent_of_total_sales
FROM coffeeshop.brightlearn.brightlearn_coffee_shop_2
GROUP BY drink_size
ORDER BY percent_of_total_sales DESC;

--Checking the total drinks sold by category
SELECT product_category, sum(transaction_qty) as total_drinks_sold 
FROM coffeeshop.brightlearn.brightlearn_coffee_shop_2
GROUP BY product_category;


--End of "Big Code"
