-- Find the Team Size
SELECT employee_id, team_size FROM employee e
JOIN (SELECT team_id, count(*) as team_size
      FROM employee GROUP BY team_id) as t
ON e.team_id=t.team_id;

-- Product Sales Analysis I
SELECT p.product_name, s.year, s.price
FROM Sales as s
LEFT JOIN Product p
ON s.product_id=p.product_id;

-- Product Sales Analysis II
SELECT product_id, sum(quantity) as total_quantity
FROM Sales
GROUP BY product_id;

-- Game Play Analysis I
SELECT player_id, MIN(event_date) as first_login
FROM activity
GROUP BY player_id

-- Average Selling Price
SELECT p.product_id, ROUND(SUM(units*price)/ SUM(units),2) as average_price
FROM prices p
JOIN unitssold u
ON p.product_id=u.product_id
WHERE u.purchase_date BETWEEN p.start_date AND p.end_date
GROUP BY p.product_id;

-- Immediate Food Delivery I
SELECT ROUND(COUNT(*)/(SELECT COUNT(*) FROM delivery)*100,2) as immediate_percentage
FROM delivery as d
WHERE d.order_date=d.customer_pref_delivery_date;

SELECT round(100 * SUM(order_date = customer_pref_delivery_date) / COUNT(*), 2) as immediate_percentage
FROM delivery;  -- sum can directly be applied to boolean in MySQL

-- Reformat Department Table
SELECT id,
       SUM(IF(month='Jan', revenue, null)) as Jan_Revenue,
       SUM(IF(month='Feb', revenue, null)) as Feb_Revenue,
       SUM(IF(month="Mar"), revenue, null) as Mar_Revenue,
       SUM(IF(month="Apr", revenue, null)) as Apr_Reveue,
       SUM(IF(month="May", revenue, null)) as May_Reveue,
       SUM(IF(month="Jun", revenue, null)) as June_Reveue,
       SUM(IF(month="Jul", revenue, null)) as July_Reveue,
       SUM(IF(month="Aug", revenue, null)) as Aug_Reveue,
       SUM(IF(month="Sep", revenue, null)) as Sept_Reveue,
       SUM(IF(month="Oct", revenue, null)) as Oct_Reveue,
       SUM(IF(month="Nov", revenue, null)) as Nov_Reveue,
       SUM(IF(month="Dec", revenue, null)) as Dec_Reveue
FROM department
GROUP BY id;


