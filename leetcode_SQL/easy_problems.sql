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

-- using IF
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

-- using CASE WHEN

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
UPDATE salary SET sex = CASE WHEN sex = 'm' THEN 'f' ELSE 'm' END;


-- Actors and Directors Who Cooperated At Least Three Times

SELECT actor_id, director_id
FROM actordirector
GROUP BY actor_id, director_id
HAVING COUNT(*)>=3;

-- Number of Comments per Post

-- using subquery
SELECT DISTINCT s1.sub_id, (SELECT COUNT(DISTINCT sub_id) FROM submissions s2 WHERE s1.sub_id=s2.parent_id)
FROM submissions s1
WHERE s1.parent_id is null
ORDER BY s1.sub_id;

-- using self-join
SELECT s1.sub_id as post_id, COUNT(DISTINCT s2.sub_id) as number_of_comments
FROM submissions s1
LEFT JOIN
     submissions s2
ON s1.sub_id=s2.parent_id
WHERE s1.parent_id is null
GROUP BY s1.sub_id
ORDER BY s1.sub_id;

-- Sales Analysis I

SELECT seller_id
FROM Sales
GROUP BY seller_id
HAVING SUM(price) = (SELECT SUM(price) as max_sale_price
FROM Sales
GROUP BY seller_id
ORDER BY SUM(price) DESC
LIMIT 1);

-- Students and Examinations

--notice that we have put ON statement after all joins perfectly valid and
-- also required as A has relation with C and B has relation with C
-- Also, yes we can specify columns by numbers in both group by and order by
SELECT a.student_id, a.student_name, b.subject_name, COUNT(c.subject_name) as attended_exams
FROM Students a
JOIN Subjects b
LEFT JOIN Examinations c
ON a.student_id=c.student_id AND b.subject_name=c.subject_name
GROUP BY 1,2,3
ORDER BY 1,3;


-- Customer Placing the Largest Number of Orders

SELECT customer_number
FROM orders
GROUP BY customer_number
HAVING COUNT(*) = (SELECT COUNT(*) as max_orders
FROM orders
GROUP BY customer_number
ORDER BY COUNT(*) DESC
LIMIT 1)

-- Find Customer Referee

SELECT name
FROM customer
WHERE referee_id is null or referee_id!=2;

-- Queries Quality and Percentage

-- using case when
SELECT query_name, ROUND(AVG(rating/position),2) as quality,
                   ROUND(AVG(CASE WHEN rating<3 THEN 1 ELSE 0 END)*100,2) as poor_query_percentage
FROM queries
GROUP BY query_name

-- using subquery and self join
SELECT a.query_name, ROUND(AVG(rating/position),2) as quality,
                     IFNULL(ROUND(num_poor_ratings/COUNT(a.query_name)*100,2),0) as poor_query_percentage
FROM queries as a
LEFT JOIN
(SELECT query_name, COUNT(query_name) as num_poor_ratings
FROM queries
WHERE rating < 3
GROUP BY query_name) as b
ON a.query_name=b.query_name
GROUP BY a.query_name

-- Weather Type in Each Country

-- using CASE
SELECT country_name, CASE WHEN AVG(weather_state)<=15 THEN "Cold"
                          WHEN AVG(weather_state)>=25 THEN "Hot"
                          ELSE "Warm"
                     END as weather_type
FROM countries as c
JOIN weather as w
ON c.country_id=w.country_id
WHERE w.day BETWEEN "2019-11-01" AND "2019-11-30"
GROUP BY country_name;

-- using IF
SELECT country_name, IF(AVG(weather_state)<=15,"Cold", IF(AVG(weather_state)>=25, "Hot", "Warm")) as weather_type
FROM countries as c
JOIN weather as w
ON c.country_id=w.country_id
WHERE w.day BETWEEN "2019-11-01" AND "2019-11-30"
GROUP BY country_name;

-- Not Boring Movies

SELECT id, movie, description, rating
FROM cinema
WHERE id%2!=0 AND description!='boring'
ORDER BY rating DESC;

-- Employee Bonus

SELECT name, bonus
FROM employee e
LEFT JOIN bonus b
ON e.empid=b.empid
WHERE bonus is null or bonus<1000;

-- Triangle Judgement

SELECT x,y,z, CASE WHEN x+y<=z OR x+z<=y OR y+z<=x THEN 'No' ELSE 'Yes' END as triangle
FROM triangle;

-- Project Employees I

SELECT project_id, ROUND(AVG(experience_years),2) as average_years
FROM Project p
JOIN EMployee e
ON p.employee_id=e.employee_id
GROUP BY project_id;

-- Sales Person

-- using subquery

SELECT name
FROM salesperson
WHERE sales_id NOT IN
(SELECT sales_id
 FROM orders as a
 LEFT JOIN company as b
 ON a.com_id=b.com_id
 WHERE b.name='RED');

-- using only joins - both INNER AND RIGHT join (no subquery)

SELECT a.name
FROM orders a
JOIN company b
ON a.com_id=b.com_id
AND c.name='RED'
RIGHT JOIN salesperson as c
ON a.sales_id=c.sales_id
WHERE o.sales_id is NULL;

-- Duplicate Emails

SELECT Email
FROM Person
GROUP BY Email
HAVING COUNT(*)>1;

-- Ads Performance

SELECT ad_id, IFNULL(ROUND(AVG(CASE WHEN action='Clicked' THEN 1
                    WHEN action='Viewed' THEN 0
                    ELSE NULL
              END)*100,2),0) as ctr
FROM Ads
GROUP BY ad_id
ORDER BY 2 DESC, 1;

-- alternate solution

SELECT ad_id, CASE WHEN num_clicked+num_viewed=0 THEN 0.00 ELSE ROUND(num_clicked/(num_clicked+num_viewed)*100,2) END as ctr
FROM
(
SELECT ad_id, SUM(CASE WHEN action='Clicked' THEN 1 ELSE 0 END) as num_clicked,
              SUM(CASE WHEN action='Viewed' THEN 1 ELSE 0 END) as num_viewed
FROM Ads
GROUP BY ad_id
) as T
ORDER BY 2 DESC, 1;

-- alternate solution (brute force)

SELECT A.ad_id, CASE WHEN ctr IS NULL THEN 0.00 ELSE ROUND(ctr*100,2) END as ctr
FROM
(SELECT ad_id
FROM Ads
GROUP BY ad_id) as A
LEFT JOIN
(SELECT T1.ad_id, clicked/clicked_or_viewed as ctr
FROM
(SELECT ad_id, COUNT(*) as clicked
FROM Ads
WHERE action IN ('Clicked')
GROUP BY ad_id) as T1
INNER JOIN
(SELECT ad_id, COUNT(*) as clicked_or_viewed
FROM Ads
WHERE action in ('Clicked', 'Viewed')
GROUP BY ad_id) as T2
ON T1.ad_id=T2.ad_id) as T3
ON A.ad_id=T3.ad_id
ORDER BY 2 DESC, 1;


-- Combine Two Tables

SELECT FirstName, LastName, City, State
FROM Person as p
LEFT JOIN Address as a
ON p.PersonId=a.PersonId;


-- Game Play Analysis II

SELECT player_id, device_id
FROM activity
WHERE (player_id, event_date)
IN (
SELECT player_id, min(event_date)
FROM activity
GROUP BY player_id
)

-- alternate solution

SELECT player_id, device_id
FROM
(
SELECT player_id, device_id, ROW_NUMBER() OVER(PARTITION BY player_id, device_id
                                                  ORDER BY event_date) as row_device
FROM activity
WHERE row_device=1
) as t

-- Sales Analysis III

SELECT p.product_id, product_name
FROM
Product as p
INNER JOIN
Sales as s
ON p.product_id=s.product_id
GROUP By p.product_id
HAVING min(sale_date)>='2019-01-01' AND max(sale_date)<='2019-03-31'

-- User Activity for the Past 30 Days I

SELECT activity_date as day, count(distinct user_id) as active_users
FROM activity
WHERE activity_date>='2019-06-28' and activity_date<='2019-07-27'
GROUP BY activity_date
HAVING count(distinct user_id)>0

-- Project Employees II

SELECT p.project_id
FROM project as p
GROUP BY project_id
HAVING COUNT(employee_id)
=(
SELECT COUNT(employee_id)
FROM project as p
GROUP BY project_id
ORDER BY COUNT(employee_id) DESC
LIMIT 1
)


-- List Products Ordered in a Period

# Write your MySQL query statement below
SELECT p.product_name, SUM(unit) as unit
FROM products as p
INNER JOIN orders as o
ON p.product_id=o.product_id
WHERE order_date BETWEEN '2020-02-01' AND '2020-02-29'
GROUP BY 1
HAVING SUM(unit)>=100

-- employee salary greater than manager

SELECT e1.name as employee
FROM employee as e1
LEFT JOIN employee as e2
ON e1.managerid=e2.id
WHERE e1.salary>e2.salary

-- Sales Analysis II

SELECT buyer_id
FROM sales as s
INNER JOIN product as p
ON s.product_id=p.product_id
GROUP BY buyer_id
HAVING SUM(CASE WHEN product_name='S8' THEN 1 ELSE 0 END) > 0
AND SUM(CASE WHEN product_name='iPhone' THEN 1 ELSE 0 END) = 0

-- Customers who never ordered

SELECT name as customers
FROM customers as c
LEFT JOIN orders as o
ON c.id=o.customerid
WHERE o.customerid IS NULL

-- Biggest Single Number

SELECT MAX(num) as num
FROM
(
SELECT num
FROM my_numbers
GROUP BY num
HAVING COUNT(1)=1
) as t

-- Friend Requests I: Overall Acceptance Rate

SELECT ROUND(IFNULL((SELECT COUNT(*) FROM (SELECT DISTINCT requester_id, accepter_id FROM
                                         request_accepted) as T1) /
                    (SELECT COUNT(*) FROM (SELECT DISTINCT sender_id, send_to_id FROM
                                          friend_request) as T2),0), 2) as accept_rate






