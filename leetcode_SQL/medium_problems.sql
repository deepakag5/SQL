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
WHERE manager_id in (SELECT employee_id FROM employees WHERE employee_id!=manager_id AND manager_id=1)

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

