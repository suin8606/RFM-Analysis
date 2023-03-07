
-- Step 1. Filter the dataset
WITH CTE AS (
SELECT 
	Customer_ID,
	Order_ID,
	Order_Date,
	Sales
FROM RFM_dataset
WHERE Segment = 'Consumer' and Country = 'USA'
),
-- Step 2. Exam the dataset
dataset AS (
SELECT 
	Customer_ID,
	Order_ID,
	Order_DAate,
	Sales,
	COUNT(Order_ID) OVER (PARTITION BY Customer_ID, Order_ID)
FROM RFM_dataset
),
-- Step 3. Summarize the dataset
CTE2 AS (
SELECT 
	Customer_ID,
	Order_ID,
	Order_Date,
	SUM(Sales) AS total_sales
FROM CTE
GROUP BY Customer_ID, rder_ID, Order_Date
)
-- Step 4. Put together the RFM report
SELECT
	Customer_ID,
	(SELECT MAX(Order_Date) FROM CTE2) AS max_order_date,
	(SELECT MAX(Order_Date) FROM CTE2 WHERE Customer_ID = CTE2.Customer_ID) AS max_order_date,
DATEDIFF(day, (SELECT MAX(Order_Date) FROM CTE2 WHERE Customer_ID = CTE2.Customer_ID), (SELECT MAX(Order_Date) FROM CTE2)) as recency,
COUNT(CTE2.Order_ID) AS frequency,
SUM(CTE2.total_sales) AS monetary,
NTILE(3) OVER (ORDER BY DATEDIFF(day, (SELECT MAX(Order_Date) FROM CTE2 WHERE Customer_ID = CTE2.Customer_ID), (SELECT MAX(Order_Date) FROM CTE2)) DESC)as R,
NTILE(3) OVER (ORDER BY COUNT(CTE2.totla_sales) ASC) AS F
FROM CTE2
GROUP BY CTE2.Customer_ID
ORDER 1, 3 DESC