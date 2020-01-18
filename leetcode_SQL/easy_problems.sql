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
       SUM(IF(month='Mar', revenue, null)) as Mar_Revenue,
       SUM(IF(month='Apr', revenue, null)) as Apr_Revenue,
       SUM(IF(month='May', revenue, null)) as May_Revenue,
       SUM(IF(month='Jun', revenue, null)) as Jun_Revenue,
       SUM(IF(month='Jul', revenue, null)) as Jul_Revenue,
       SUM(IF(month='Aug', revenue, null)) as Aug_Revenue,
       SUM(IF(month='Sep', revenue, null)) as Sep_Revenue,
       SUM(IF(month='Oct', revenue, null)) as Oct_Revenue,
       SUM(IF(month='Nov', revenue, null)) as Nov_Revenue,
       SUM(IF(month='Dec', revenue, null)) as Dec_Revenue
FROM department
GROUP BY id;

SELECT id,
       SUM(CASE WHEN month='Jan' THEN revenue ELSE null END)) as Jan_Revenue,
       SUM(CASE WHEN month='Feb' THEN revenue ELSE null END)) as Feb_Revenue,
       SUM(CASE WHEN month='Mar' THEN revenue ELSE null END)) as Mar_Revenue,
       SUM(CASE WHEN month='Apr' THEN revenue ELSE null END)) as Apr_Revenue,
       SUM(CASE WHEN month='May' THEN revenue ELSE null END)) as May_Revenue,
       SUM(CASE WHEN month='Jun' THEN revenue ELSE null END)) as Jun_Revenue,
       SUM(CASE WHEN month='Jul' THEN revenue ELSE null END)) as Jul_Revenue,
       SUM(CASE WHEN month='Aug' THEN revenue ELSE null END)) as Aug_Revenue,
       SUM(CASE WHEN month='Sep' THEN revenue ELSE null END)) as Sep_Revenue,
       SUM(CASE WHEN month='Oct' THEN revenue ELSE null END)) as Oct_Revenue,
       SUM(CASE WHEN month='Nov' THEN revenue ELSE null END)) as Nov_Revenue,
       SUM(CASE WHEN month='Dec' THEN revenue ELSE null END)) as Dec_Revenue
FROM department
GROUP BY id;

-- Big Countries
SELECT name, population, area
FROM world
WHERE area>3000000 OR population>25000000;

-- Shortest Distance in a line
SELECT MIN(ABS(a.x-b.x)) as shortest
FROM point a
JOIN point b
ON a.x>b.x

-- Article Views
SELECT author_id as id
FROM views as v
WHERE v.author_id=v.viewer_id
GROUP BY author_id
ORDER BY author_id;

-- Swap Salary
UPDATE salary SET sex = IF(sex='m','f','m')

-- Actors and Directors Who Cooperated At Least Three Times
SELECT actor_id, director_id
FROM actordirector
GROUP BY actor_id, director_id
HAVING COUNT(*)>=3;

-- Number of Comments per Post
SELECT s1.sub_id as post_id, COUNT(DISTINCT s2.sub_id) as number_of_comments
FROM submissions s1
LEFT JOIN
     submissions s2
ON s1.sub_id=s2.parent_id
WHERE s1.parent_id is null
GROUP BY s1.sub_id
ORDER BY s1.sub_id;
