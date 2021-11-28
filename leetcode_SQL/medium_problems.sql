-- All People Report to the Given Manager

SELECT e1.employee_id
FROM employees as e1
JOIN employees as e2
ON e1.manager_id=e2.employee_id
JOIN employees as e3
ON e2.manager_id=e3.employee_id
WHERE e1.employee_id!=1 AND e3.manager_id=1;  -- e3 is manager of manager

-- alternate solution

SELECT employee_id
FROM employees
WHERE employee_id!=manager_id AND manager_id=1

UNION

SELECT employee_id
FROM employees
WHERE manager_id in
(
SELECT employee_id
FROM employees
WHERE employee_id!=manager_id
AND manager_id=1
)

UNION

SELECT employee_id
FROM employees
WHERE manager_id IN
(
SELECT employee_id
FROM employees
WHERE manager_id IN
(
SELECT employee_id
FROM employees
WHERE employee_id!=manager_id
AND manager_id=1)
)

--  Running Total for Different Genders

SELECT s1.gender, s1.day, SUM(s2.score_points)
FROM scores as s1
JOIN scores as s2
ON s1.gender=s2.gender
AND s2.day<=s1.day   -- as after joining we want to get sum for days less than s1
GROUP BY 1,2

-- Find the Start and End Number of Continuous Ranges

SELECT MIN(log_id) as start_id, MAX(log_id) as end_id
FROM
(SELECT log_id, ROW_NUMBER() OVER(ORDER BY log_id) as num
FROM logs) as T
GROUP BY log_id-num
ORDER BY 1

SELECT MIN(log_id) as start_id, MAX(start_id) as end_id
FROM
(SELECT log_id, ABS(log_id-ROW_NUMBER() OVER(ORDER BY log_id)) as seq
FROM logs) as T
GROUP BY seq
ORDER BY 1

-- Project Employees III

SELECT project_id, employee_id
FROM
(SELECT p.project_id, e.employee_id, DENSE_RANK() OVER(PARTITION BY p.project_id ORDER BY e.experience_years DESC) as rnk
FROM project p
JOIN employee e
ON p.employee_id=e.employee_id)
WHERE rnk = 1;

-- alternate solution

SELECT p.project_id, e.employee_id
FROM project as p
INNER JOIN employee as e
ON p.employee_id=e.employee_id
WHERE (p.project_id, e.experience_years)  -- important to note
IN (
SELECT p.project_id, max(e.experience_years)
FROM project as p
INNER JOIN employee as e
ON p.employee_id=e.employee_id
GROUP BY p.project_id
)

-- Game Play Analysis III

SELECT a1.player_id, a1.event_date, SUM(a2.games_played) as games_played_so_far
FROM activity as a1
JOIN activity as a2
ON a1.player_id=a2.player_id
AND a2.event_date<=a1.event_date
GROUP BY 1,2

-- Active Businesses

SELECT business_id
FROM events as e
JOIN
(
SELECT event_type, IFNULL(AVG(occurences),0) as avg_event
FROM events
GROUP BY 1
) as T
ON e.event_type=T.event_type
WHERE e.occurences>T.avg_event
GROUP BY business_id
HAVING COUNT(e.event_type)>1


-- Last Person to Fit in the Elevator

SELECT person_name
FROM queue as Q
LEFT JOIN
(
SELECT q1.person_id, q1.turn, SUM(q2.weight) as running_weight
FROM queue as q1
JOIN queue as q2
ON q2.turn<=q1.turn
GROUP BY 2,1
) as T
ON Q.person_id=T.person_id
WHERE T.running_weight<=1000
ORDER BY T.running_weight DESC
LIMIT 1

-- alternate solution

SELECT q1.person_name
FROM Queue q1
JOIN Queue q2
ON q1.turn >= q2.turn
GROUP BY q1.turn
HAVING SUM(q2.weight) <= 1000
ORDER BY SUM(q2.weight) DESC
LIMIT 1

-- customers who bought all products

SELECT customer_id
FROM customer c
GROUP BY customer_id
HAVING COUNT(DISTINCT c.product_key)=
(
SELECT COUNT(*)
FROM product
)

-- Monthly Transactions I

SELECT
    left(trans_date,7) as month,
    country,
    count(*) as trans_count,
    sum(case when state='approved' then 1 else 0 end) as approved_count,
    sum(amount) as trans_total_amount,
    sum(case when state='approved' then amount else 0 end) as approved_total_amount
FROM transactions
GROUP BY 1,2

-- Highest grade for each student

SELECT
      student_id,
      min(course_id) as course_id,
      grade
FROM enrollments
WHERE (student_id,grade)
IN (
SELECT student_id, max(grade) as grade
FROM enrollments
GROUP BY 1
    )
GROUP BY 1,3
ORDER BY 1

-- Page Recommendations

SELECT
      DISTINCT page_id as recommended_page
FROM likes
WHERE user_id
IN
(
SELECT user2_id as user_id
FROM friendship
WHERE user1_id=1
UNION ALL
SELECT user1_id as user_id
FROM friendship
WHERE user2_id=1
)
AND page_id NOT IN (SELECT page_id FROM likes WHERE user_id=1)


-- manager with at least 5 direct report

# Write your MySQL query statement below
SELECT
    name
FROM
    employee
WHERE
    id IN (SELECT
            managerid
        FROM
            employee
        WHERE
            managerid IS NOT NULL
        GROUP BY managerid
        HAVING COUNT(DISTINCT id) >= 5)


-- number of trusted contacts of a customer

SELECT
    invoice_id,
    customer_name,
    price,
    COALESCE(t.contacts_count, 0) AS contacts_cnt,
    COALESCE(t1.trusted_contact_cnt, 0) AS trusted_contacts_cnt
-- CASE
--         WHEN t1.trusted_contact_cnt IS NULL THEN 0
--         ELSE t1.trusted_contact_cnt
--     END AS trusted_contacts_cnt
FROM
    invoices i
        JOIN
    customers c ON c.customer_id = i.user_id
        LEFT JOIN
    (SELECT
        user_id, COUNT(*) AS contacts_count
    FROM
        contacts
    GROUP BY user_id) AS t ON c.customer_id = t.user_id
        LEFT JOIN
    (SELECT
        customer_id, COUNT(*) trusted_contact_cnt
    FROM
        customers c
    LEFT JOIN contacts con ON c.customer_id = con.user_id
    WHERE
        con.contact_email IN (SELECT DISTINCT
                email
            FROM
                customers)
    GROUP BY customer_id) AS t1 ON c.customer_id = t1.customer_id
ORDER BY invoice_id;

-- tree node

SELECT id,
      CASE WHEN id = (SELECT id FROM tree WHERE p_id is null) THEN "Root"
           WHEN id in (SELECT p_id FROM tree) THEN "Inner"
           ELSE "Leaf"
      END as type
FROM tree


-- nth highest salary

CREATE FUNCTION getNthHighestSalary (N INT) RETURNS INT
BEGIN
  RETURN
    (
    SELECT DISTINCT salary
    FROM
    (
      SELECT salary, DENSE_RANK() OVER(PARTITION BY id ORDER BY salary DESC) AS SAL_RANK
      FROM employee
  ) AS T
    WHERE SAL_RANK=N
);
END


-- rank scores

SELECT score, DENSE_RANK() OVER(ORDER BY score DESC) AS `rank`
FROM scores

-- consecutive numbers

SELECT DISTINCT l1.num as consecutiveNums
FROM Logs as l1,
     Logs as l2,
     Logs as l3
WHERE l1.id=l2.id-1
      AND l2.id=l3.id-1
      AND l1.num=l2.num
      AND l2.num=l3.num
;


-- department highest salary

WITH CTE AS
(
  SELECT `name`,
         departmentId,
         salary,
         DENSE_RANK() OVER(PARTITION BY departmentId ORDER BY salary DESC) AS dept_sal_rank
  FROM employee
)
SELECT
      d.name AS departmentName,
      t.name AS employeeName,
      t.salary
FROM CTE as t
LEFT JOIN department as d
ON t.departmentId=d.id
WHERE dept_sal_rank=1
;


--  managers with at least 5 direct reports

SELECT
      Name
FROM Employee AS t1
JOIN
    (
      SELECT
            ManagerId
      FROM employee
      GROUP BY ManagerId
      HAVING COUNT(ManagerId) >= 5
    ) as t2
t1.Id=t2.ManagerId
;

-- alternate solution

WITH CTE AS
(
  SELECT e1.ManagerId,
         e2.Name,
         COUNT(DISTINCT e1.Id) AS cnt
  FROM employee as e1
  JOIN employee as e2
  ON e2.Id=e1.ManagerId
  GROUP BY 1,2
)
SELECT
      `Name`
FROM CTE
WHERE cnt >= 5
;


-- winning candidate

WITH CTE as
(
  SELECT
        candidateId
  FROM Vote
  GROUP BY candidateId
  ORDER BY COUNT(id) DESC
  LIMIT 1
)
SELECT
      name as `Name`
FROM Candidate as c
JOIN CTE as t
ON c.id=t.candidateId
;

-- Get Highest Answer Rate Question

WITH CTE AS
(
  SELECT
        question_id,
        COUNT(answer_id)/ COUNT(*) as answer_rate
  FROM
      survey_log
  GROUP BY 1
)
SELECT
      question_id as survey_log
FROM CTE
ORDER BY answer_rate DESC
LIMIT 1
;


-- Count Student Number in Departments

SELECT
    dept_name, COUNT(student_id) AS student_number
FROM
    department
        LEFT OUTER JOIN
    student ON department.dept_id = student.dept_id
GROUP BY department.dept_name
ORDER BY student_number DESC , department.dept_name
;


-- Investments in 2016

SELECT
    SUM(insurance.TIV_2016) AS TIV_2016
FROM
    insurance
WHERE
    insurance.TIV_2015 IN
    (
      SELECT
        TIV_2015
      FROM
        insurance
      GROUP BY TIV_2015
      HAVING COUNT(*) > 1
    )
    AND CONCAT(LAT, LON) IN
    (
      SELECT
        CONCAT(LAT, LON)
      FROM
        insurance
      GROUP BY LAT , LON
      HAVING COUNT(*) = 1
    )
;

-- Friend Requests II: Who Has the Most Friends

WITH all_user (`user`, friend) AS
(
  SELECT requester_id, acceptor_id
  FROM request_accepted
  UNION
  SELECT acceptor_id, requester_id
  FROM request_accepted
)
SELECT user as id, COUNT(DISTINCT friend) as num_friends
FROM CTE
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1
;

-- Second Degree Follower

WITH CTE AS
(
  SELECT followee, COUNT(DISTINCT follower) AS num
  FROM follow
  GROUP BY 1
)
SELECT followee AS follower, num
FROM CTE as t
WHERE followee IN (SELECT follower FROM follow)
ORDER BY 1
;


-- Product Sales Analysis III

WITH CTE AS
(
SELECT
       *,
       RANK() OVER (PARTITION BY product_id ORDER BY `year`) AS rnk
FROM sales
)
SELECT
      product_id,`year` AS first_year,quantity,price
FROM CTE
WHERE rnk = 1
;

-- Game Play Analysis IV

WITH CTE AS
(
  SELECT
        player_id,
        first_value(event_date) OVER(w) AS first_date,
        Nth_value(event_date) OVER(w) AS second_date
  FROM activity
  WINDOW w AS (PARTITION BY player_id ORDER BY event_date ASC)
)
SELECT
      ROUND(COUNT(DISTINCT player_id) / (SELECT COUNT(DISTINCT player_id) FROM activity),2) as fraction
FROM CTE
WHERE DATEDIFF(second_date, first_date) = 1


-- Unpopular Books

WITH CTE AS
(
  SELECT
        b.book_id,
        b.name,
        o.quantity
  FROM books AS b
  LEFT JOIN orders as o
  ON b.book_id=o.book_id
  AND o.dispatch_date >= ADDDATE('2019-06-23',-365)
    WHERE b.available_from <= ADDDATE('2019-06-23',-30)
)
SELECT
      book_id,
      `name`
FROM CTE
GROUP BY 1,2
HAVING COALESCE(SUM(quantity), 0) < 10
;


-- New Users Daily Count

WITH CTE AS
(
  SELECT
        user_id,
        activity_date,
        ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY activity_date) as first_login
  FROM traffic
  WHERE activity='login'
)
SELECT
      activity_date AS login_date,
      COUNT(user_id) AS user_count
FROM CTE
WHERE first_login = 1 AND activity_date >= ADDDATE('2019-06-30',-90)
GROUP BY 1
ORDER BY 1
;

-- Reported Posts II

WITH CTE AS
(
    SELECT action_date, post_id
    FROM actions
    WHERE action='report' AND extra='spam'
    GROUP BY 1,2
),
CTE1 AS
(
    SELECT action_date as days, COUNT(DISTINCT r.post_id) / COUNT(DISTINCT t.post_id) AS removal_rate
    FROM CTE AS t
    LEFT JOIN removals as r
    ON t.post_id = r.post_id
    GROUP BY 1
)
SELECT
        ROUND(SUM(removal_rate)/ COUNT(days) *100, 2) AS average_daily_percent
FROM CTE1
;

-- Article Views II

WITH CTE as
(
  SELECT
        viewer_id,
        view_date,
        COUNT(DISTINCT article_id) AS article_cnt
  FROM `views`
  GROUP BY 1,2
)
SELECT DISTINCT viewer_id as id
FROM CTE
WHERE article_cnt > 1
;

-- Market Analysis I

WITH CTE AS
(
    SELECT
            buyer_id, COUNT(DISTINCT order_id) AS cnt_orders
    FROM orders
    WHERE order_date >= '2019-01-01' AND order_date <= '2019-12-31'
    GROUP BY 1
)
SELECT
      user_id, join_date, ifnull(cnt_orders, 0) AS orders_in_2019
FROM users AS u
LEFT JOIN CTE AS t
ON u.user_id = t.buyer_id
;


-- Monthly Transactions II

WITH CTE AS
(
    SELECT
          id, country, state, amount, date_format(trans_date, '%Y-%m') AS trans_month
    FROM transactions
    WHERE state = 'approved'

    UNION

    SELECT
          t.id, t.country, 'chargeback' AS state, t.amount, date_format(trans_date, '%Y-%m') AS trans_month
    FROM chargebacks AS c
    LEFT JOIN transactions AS t
    ON c.trans_id = t.id
)
SELECT
      trans_month AS `month`,
      country,
      SUM(CASE WHEN state='approved' THEN 1 ELSE 0 END) AS approved_count,
      SUM(CASE WHEN state='approved' THEN amount ELSE 0 END) AS approved_amount,
      SUM(CASE WHEN state='chargeback' THEN 1 ELSE 0 END) AS chargeback_count,
      SUM(CASE WHEN state='chargeback' THEN amount ELSE 0 END) AS chargeback_amount
FROM CTE
GROUP BY 1,2
;

-- Last Person to Fit in the Bus

WITH CTE AS
(
SELECT
      person_name, SUM(weight) OVER(ORDER BY turn ASC) AS cum_weight
FROM queue
)
SELECT
      person_name
FROM CTE
WHERE cum_weight <= 1000
ORDER BY cum_weight DESC
LIMIT 1
;


-- Immediate Food Delivery II

WITH CTE AS
(
    SELECT
            order_date,
            customer_pref_delivery_date,
            ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date ASC) as ord_rank
    FROM delivery
)
SELECT
        ROUND(SUM(CASE WHEN order_date=customer_pref_delivery_date THEN 1 ELSE 0 END)/ (SELECT COUNT(*) FROM CTE WHERE ord_rank=1) * 100 , 2) AS immediate_percentage
FROM CTE
WHERE ord_rank = 1
;


-- Product Price at a Given Date

WITH CTE AS
(
SELECT
      product_id,
      new_price,
      ROW_NUMBER() OVER(PARTITION BY product_id ORDER BY change_date DESC) AS rnk
FROM products
WHERE change_date <= '2019-08-16'
)
SELECT
        product_id, new_price AS price
FROM CTE
WHERE rnk = 1

UNION

SELECT
       product_id, COALESCE(null, 10) AS price
FROM products
WHERE product_id NOT IN (SELECT product_id FROM products WHERE change_date <= '2019-08-16')
;