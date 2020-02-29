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



