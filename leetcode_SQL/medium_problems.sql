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
