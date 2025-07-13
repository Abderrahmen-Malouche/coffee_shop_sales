SELECT * FROM coffee_shop_sales;

UPDATE coffee_shop_sales
SET transaction_date = STR_TO_DATE(`transaction_date`,'%m/%d/%Y');

ALTER TABLE coffee_shop_sales
MODIFY COLUMN transaction_date date;

ALTER TABLE coffee_shop_sales
MODIFY COLUMN transaction_time time;

DESCRIBE coffee_shop_sales;


SELECT ROUND(SUM(transaction_qty * unit_price)) as Monthly_Sales
FROM coffee_shop_sales
WHERE month(transaction_date)=3;

SELECT 
	MONTH(transaction_date) as `month`,
    ROUND(SUM(unit_price * transaction_qty)) AS total_sales,
    (SUM(unit_price * transaction_qty) - LAG(SUM(unit_price * transaction_qty),1) -- MONTH sales DIFFERENCE
    OVER (ORDER BY MONTH(transaction_date)))/LAG (SUM(unit_price * transaction_qty),1) -- Division by Previous MONTH sales
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage -- PERCENTAGE
FROM 
	coffee_shop_sales
WHERE 
	MONTH(transaction_date) IN (4,5)
GROUP BY 
	MONTH(transaction_date)
ORDER BY 
	MONTH(transaction_date);

SELECT COUNT(transaction_id) AS total_number_of_orders
FROM coffee_shop_sales
WHERE MONTH(transaction_date)=3;

SELECT 
	MONTH(transaction_date) as `month`,
    COUNT(transaction_id) AS total_number_of_orders,
    (COUNT(transaction_id) - LAG(COUNT(transaction_id),1) -- MONTH number_of_orders DIFFERENCE
    OVER (ORDER BY MONTH(transaction_date)))/LAG (COUNT(transaction_id),1) -- Division by Previous MONTH sales
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage -- PERCENTAGE
FROM 
	coffee_shop_sales
WHERE 
	MONTH(transaction_date) IN (4,5)
GROUP BY 
	MONTH(transaction_date)
ORDER BY 
	MONTH(transaction_date);
    
    
SELECT SUM(transaction_qty) AS total_number_of_orders
FROM coffee_shop_sales
WHERE MONTH(transaction_date)=3;

SELECT 
	MONTH(transaction_date) as `month`,
    SUM(transaction_qty) AS total_number_of_orders,
    (SUM(transaction_qty) - LAG(SUM(transaction_qty),1) -- MONTH number_of_quantity_sold DIFFERENCE
    OVER (ORDER BY MONTH(transaction_date)))/LAG (SUM(transaction_qty),1) -- Division by Previous MONTH sales
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage -- PERCENTAGE
FROM 
	coffee_shop_sales
WHERE 
	MONTH(transaction_date) IN (4,5)
GROUP BY 
	MONTH(transaction_date)
ORDER BY 
	MONTH(transaction_date);
    
SELECT 
	CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,1),'K') AS Total_sales,
    CONCAT(ROUND(SUM(transaction_qty)/1000,1),'K')  AS Total_Qty_Sold,
    CONCAT(ROUND(COUNT(transaction_id)/1000,1),'K') AS Total_Orders
FROM coffee_shop_sales
WHERE transaction_date= '2023-05-18';


SELECT 
	CASE WHEN DAYOFWEEK(transaction_date) IN (1,7) THEN "Weekends"
    ELSE "Weekdays"
    END AS day_type,
    CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,1),'K') As Total_sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 5
GROUP BY 
	CASE WHEN DAYOFWEEK(transaction_date) IN (1,7) THEN "Weekends"
	ELSE 'Weekdays'
    END;
    
SELECT 
	store_location,
    CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,1),"K") AS Total_sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 5 
GROUP BY store_location
ORDER BY Total_sales DESC;
