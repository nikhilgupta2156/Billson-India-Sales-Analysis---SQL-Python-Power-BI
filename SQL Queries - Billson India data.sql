-- ================================
-- 1. CONVERT DATE COLUMN (B_DATE)
-- ================================

-- BILL_WISE_DATA
ALTER TABLE billson_india.bill_wise_data
ADD COLUMN date DATE;
UPDATE billson_india.bill_wise_data 
SET date = STR_TO_DATE(B_DATE, '%d/%m/%Y');
ALTER TABLE billson_india.bill_wise_data
DROP COLUMN B_DATE,
CHANGE date B_DATE DATE;

-- ITEM_WISE_DATA
ALTER TABLE billson_india.item_wise_data
ADD COLUMN date DATE;
UPDATE billson_india.item_wise_data 
SET date = STR_TO_DATE(B_DATE, '%d/%m/%Y');
ALTER TABLE billson_india.item_wise_data
DROP COLUMN B_DATE,
CHANGE date B_DATE DATE;

-- ================================
-- 2. DATA CLEANING + TYPE CHANGES
-- ================================

-- BILL_WISE_DATA
UPDATE billson_india.bill_wise_data
SET NET_AMT = REPLACE(NET_AMT, ',','');
ALTER TABLE billson_india.bill_wise_data
  MODIFY COLUMN B_PARTY VARCHAR(300),
  MODIFY COLUMN NET_AMT DECIMAL(12,2),
  MODIFY COLUMN CSH_1_CRD_2 TINYINT,
  DROP COLUMN B_C,
  DROP COLUMN GST_NO,
  DROP COLUMN TAXABLE,
  DROP COLUMN SGST,
  DROP COLUMN CGST,
  DROP COLUMN IGST,
  DROP COLUMN CESS,
  DROP COLUMN COMP_GST,
  DROP COLUMN SAO,
  DROP COLUMN MyUnknownColumn,
  DROP COLUMN `MyUnknownColumn_[0]`,
  DROP COLUMN `MyUnknownColumn_[1]`,
  DROP COLUMN TCS;

-- ITEM_WISE_DATA
UPDATE billson_india.item_wise_data
SET NET_AMT = REPLACE(NET_AMT, ',','');
ALTER TABLE billson_india.item_wise_data
  MODIFY COLUMN B_NO INT,
  MODIFY COLUMN S_ITEM VARCHAR(255),
  MODIFY COLUMN S_PCS INT,
  MODIFY COLUMN NET_AMT DECIMAL(12,2),
  DROP COLUMN S_QTY,
  DROP COLUMN UNIT,
  DROP COLUMN DISOUNT,
  DROP COLUMN TAXABLE,
  DROP COLUMN GST,
  DROP COLUMN S_SGST,
  DROP COLUMN S_CGST,
  DROP COLUMN IGST,
  DROP COLUMN S_CESS,
  DROP COLUMN S_RATE,
  DROP COLUMN BILL_NO,
  DROP COLUMN B_PARTY,
  DROP COLUMN S_TYPE,
  DROP COLUMN ONF;
  

-- CUSTOMER DATA (CTE):
   WITH customer_data AS (
      SELECT
        DISTINCT customer, LOWER(TRIM(REPLACE(REPLACE(city, "-", ""), ".", ""))) AS city
      FROM (
          SELECT
            PARTICULARS AS customer, CITY AS city
          FROM billson_india.customer_data_1
          UNION ALL
          SELECT
            PARTICULARS AS customer, CITY AS city
          FROM billson_india.customer_data_2
          UNION ALL
          SELECT
            PARTICULARS AS customer, CITY AS city
          FROM billson_india.customer_data_3
          UNION ALL
          SELECT
            PARTICULARS AS customer, CITY AS city
          FROM billson_india.customer_data_4
          UNION ALL
          SELECT
            PARTICULARS AS customer, CITY AS city
          FROM billson_india.customer_data_5
          UNION ALL
          SELECT
            PARTICULARS AS customer, CITY AS city
          FROM billson_india.customer_data_6
      ) AS tbl
      WHERE city IS NOT NULL
),

-- BILL WISE DATA (CTE):

bill_data AS (
  SELECT
    B_DATE AS date,
    B_NO AS bill_no,
    B_PARTY AS customer,
    NET_AMT AS total_amount,
    CSH_1_CRD_2 AS cash_online,
    CASE
      WHEN CSH_1_CRD_2 = 1 THEN 'Cash'
      ELSE 'Online'
    END AS payment_mode
  FROM billson_india.bill_wise_data
  ORDER BY date, bill_no
),

-- ITEM WISE DATA (CTE):
item_data AS (
   SELECT
     B_DATE AS date,
     B_NO AS bill_no,
     S_ITEM AS item,
     S_PCS AS quantity
     -- NET_AMT AS item_amount
   FROM billson_india.item_wise_data
   ORDER BY date, bill_no
),


-- FINAL COMBINED DATA (CTE):

final_data AS (
  SELECT
    b.date,
    b.bill_no,
    b.customer,
    b.total_amount,
    b.cash_online,
    b.payment_mode,
    CASE
      WHEN b.customer LIKE '%A/C%' THEN 'N/A'
      ELSE c.city
    END AS city,
    i.item,
    i.quantity
  -- i.item_amount
  FROM bill_data AS b
  LEFT JOIN customer_data AS c
    ON b.customer = c.customer
  LEFT JOIN item_data AS i
    ON b.bill_no = i.bill_no
  ORDER BY b.date, bill_no
),

-- MONTHLY SALES (CTE) --

monthly_sales AS (
    SELECT
        YEAR(date) AS year,
        MONTH(date) AS month,
        SUM(total_amount) AS total_amount
    FROM bill_data
    GROUP BY YEAR(date), MONTH(date)
),

-- YEARLY SALES (CTE) --

yearly_sales AS (
    SELECT
        YEAR(date) AS year,
        SUM(total_amount) AS total_amount
    FROM bill_data
    GROUP BY YEAR(date)
)
-- ========================================
-- YEARLY TOTAL SALE 
-- ========================================

SELECT
    YEAR(date) AS year,
    ROUND(SUM(total_amount)) AS total_sales
FROM bill_data
GROUP BY YEAR(date)
ORDER BY year;

-- ========================================
-- YEARLY AVERAGE SALE
-- ========================================

SELECT
    YEAR(date) AS year,
    ROUND(AVG(total_amount),2) AS avg_sales
FROM bill_data
GROUP BY YEAR(date)
ORDER BY year;

-- ========================================
-- SALES TREND
-- ========================================

SELECT
  YEAR(date) AS year,
  COUNT(DISTINCT bill_no) AS total_bills,
  ROUND(SUM(total_amount), 2) AS total_sales,
  ROUND(AVG(total_amount), 2) AS avg_order_value
FROM bill_data
GROUP BY YEAR(date)
ORDER BY year;

-- ========================================
-- YEAR-WISE PERCENTAGE CHANGE IN SALES
-- ========================================

SELECT
    year,
    total_amount,
    LAG(total_amount) OVER (ORDER BY year) AS prev_year_amount,
    ROUND((total_amount - LAG(total_amount) OVER (ORDER BY year)) /
        LAG(total_amount) OVER (ORDER BY year) * 100, 2) AS percentage_change
FROM yearly_sales
ORDER BY year;

-- ========================================
-- MONTH-WISE PERCENTAGE CHANGE IN SALES
-- ========================================

SELECT
    year,
    month,
    total_amount,
    LAG(total_amount) OVER (ORDER BY year, month) AS prev_month_amount,
    ROUND((total_amount - LAG(total_amount) OVER (ORDER BY year, month)) /
          LAG(total_amount) OVER (ORDER BY year, month) * 100, 2) AS percentage_change
FROM monthly_sales
ORDER BY year, month;

-- ========================================
-- PRODUCT-WISE PERFORMANCES (TOP 20)
-- ========================================

SELECT
  item,
  SUM(quantity) AS total_units_sold,
  ROUND(SUM(total_amount),1) AS total_revenue,
  ROUND(AVG(total_amount),1) AS avg_revenue
FROM final_data
GROUP BY item
ORDER BY total_revenue DESC, avg_revenue DESC
LIMIT 20;

-- ========================================
-- TOP 10 CUSTOMERS IN EACH YEAR
-- ========================================

SELECT *
FROM (
  SELECT *,
       RANK() OVER(PARTITION BY year ORDER BY total_sales DESC) AS sales_rank
  FROM (
    SELECT
      YEAR(date) AS year,
      customer,
      ROUND(SUM(total_amount), 1) AS total_sales
    FROM bill_data
    GROUP BY YEAR(date), customer
  ) AS sub
) AS ranked
WHERE sales_rank <= 10
ORDER BY year, sales_rank;

-- ========================================
-- REGIONAL SALES PERFORMANCE
-- ========================================

SELECT
  city,
  ROUND(SUM(total_amount),2) AS total_sales,
  ROUND(SUM(total_amount) / SUM(SUM(total_amount)) OVER () * 100,2) AS pct_share
FROM final_data
WHERE city IS NOT NULL
GROUP BY city
ORDER BY pct_share DESC;

-- ========================================
-- FREQUENTLY BOUGHT TOGETHER (TOP 20)
-- ========================================

SELECT 
  a.item AS item1,
  b.item AS item2,
  COUNT(*) AS times_bought_together
FROM final_data a
JOIN final_data b
  ON a.bill_no = b.bill_no
  AND a.item < b.item
GROUP BY item1, item2
ORDER BY times_bought_together DESC
LIMIT 20;

-- ========================================
-- CUSTOMER SEGMENTATION
-- ========================================

SELECT 
  customer,
  COUNT(DISTINCT bill_no) AS orders_count,
  ROUND(SUM(total_amount), 2) AS total_spent,
  CASE 
    WHEN COUNT(DISTINCT bill_no) BETWEEN 4 AND 25 THEN 'Loyal'
    WHEN COUNT(DISTINCT bill_no) > 25 THEN 'Agent/Dealer/Reseller'
    ELSE 'Occasional'
  END AS customer_segment
FROM bill_data
WHERE customer != 'CASH A/C'
GROUP BY customer
ORDER BY orders_count DESC;

-- ========================================
-- OVERALL MONTHLY SALES TREND AFTER 2021
-- ========================================

SELECT
  YEAR(date) AS year,
  MONTH(date) AS month,
  ROUND(SUM(total_amount), 2) AS total_revenue,
  SUM(quantity) AS total_units_sold
FROM final_data
WHERE YEAR(date) > 2021
GROUP BY YEAR(date), MONTH(date)
ORDER BY year, month;

-- ========================================
-- PAYMENT MODE SHARE BY YEAR
-- ========================================

SELECT  
  year,
  payment_mode,
  ROUND(SUM(total_amount), 2) AS total_revenue,
  COUNT(DISTINCT bill_no) AS total_orders,
  ROUND(SUM(total_amount) / SUM(SUM(total_amount)) OVER (PARTITION BY year) * 100, 2) AS pct_share
FROM (
  SELECT *,
    YEAR(date) AS year
  FROM bill_data
) AS tbl
GROUP BY year, payment_mode
ORDER BY year, total_revenue DESC;

-- ========================================
-- YEAR-ON-YEAR SALES GROWTH BY CITY
-- ========================================

SELECT
  city,
  year,
  total_sales,
  LAG(total_sales) OVER (PARTITION BY city ORDER BY year) AS prev_year_sales,
  ROUND((total_sales - LAG(total_sales) OVER (PARTITION BY city ORDER BY year)) /
      LAG(total_sales) OVER (PARTITION BY city ORDER BY year) * 100, 1) AS yoy_percentage_change
FROM (
      SELECT
        TRIM(city) AS city,
        YEAR(date) AS year,
        SUM(total_amount) AS total_sales
      FROM final_data
      WHERE city IS NOT NULL
      GROUP BY city, YEAR(date)
    ) AS yearly_city_sales
ORDER BY city, year;

-- ========================================
-- CLV (CUSTOMER'S LIFETIME VALUE
-- ========================================

SELECT 
  customer,
  ROUND(SUM(total_amount),2) AS lifetime_value,
  MIN(date) AS first_purchase,
  MAX(date) AS last_purchase,
  TIMESTAMPDIFF(MONTH, MIN(date), MAX(date)) AS months_active
FROM bill_data
WHERE customer != 'CASH A/C'
GROUP BY customer
ORDER BY lifetime_value DESC, months_active DESC;

-- ========================================
-- MONTHLY ITEM TRENDS
-- ========================================

SELECT
  YEAR(date) AS year,
  MONTH(date) AS month,
  item,
  SUM(quantity) AS units_sold
FROM final_data
-- WHERE item = ''
GROUP BY year, month, item
ORDER BY year, month, units_sold DESC;


-- ========================================
-- BEST SELLING PRODUCTS BY CITY
-- ========================================

SELECT *
FROM (
    SELECT
        city,
        item,
        SUM(quantity) AS units_sold,
        DENSE_RANK() OVER(PARTITION BY city ORDER BY SUM(quantity) DESC) AS rank_in_city
    FROM final_data
    WHERE city IS NOT NULL
    GROUP BY city, item
) AS ranked_products
WHERE rank_in_city <= 5 and city != ''
ORDER BY city, rank_in_city;

-- ========================================
-- BILL SIZE DISTRIBUTION
-- ========================================

SELECT
  CASE 
    WHEN total_amount < 2000 THEN 'Low (<2000)'
    WHEN total_amount BETWEEN 2000 AND 5000 THEN 'Medium (2000-5000)'
    WHEN total_amount BETWEEN 5000 AND 20000 THEN 'High (5000-20000)'
    ELSE 'Very High (>20000)'
  END AS bill_category,
  COUNT(*) AS num_orders,
  ROUND(SUM(total_amount),2) AS total_revenue
FROM bill_data
GROUP BY bill_category
ORDER BY total_revenue DESC;

-- ========================================
-- REPEAT VS ONE-TIME CUSTOMERS
-- ========================================

SELECT
  CASE 
    WHEN orders > 1 THEN 'Repeat'
    ELSE 'One-time'
  END AS customer_type,
  COUNT(*) AS customers,
  ROUND(SUM(total_spent),2) AS revenue
FROM (
  SELECT customer, COUNT(DISTINCT bill_no) AS orders, SUM(total_amount) AS total_spent
  FROM bill_data
  WHERE customer != 'CASH A/C'
  GROUP BY customer
) sub
GROUP BY customer_type;


-- ================================================
-- RFM SEGMENTATION (Recency, Frequency, Monetary)
-- ================================================

SELECT
  customer,
  DATEDIFF(CURDATE(), MAX(date)) AS recency,
  COUNT(DISTINCT bill_no) AS frequency,
  ROUND(SUM(total_amount),2) AS monetary
FROM bill_data
WHERE customer != 'CASH A/C'
GROUP BY customer;


