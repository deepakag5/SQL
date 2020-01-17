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