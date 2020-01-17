-- Find the Team Size
SELECT employee_id, team_size FROM employee e
JOIN (SELECT team_id, count(*) as team_size
      FROM employee group by team_id) as t
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
