-- https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/jump_to/i4x://DB/SQL/sequential/seq-exercise-sql_social_query_core

-- Q1 Find the names of all students who are friends with someone named Gabriel
-- solution to this query can be written in following three ways

-- 1. query cost - 34.46
SELECT
    name
FROM
    Highschooler h
        JOIN
    Friend f ON h.ID = f.ID1
WHERE
    f.ID2 IN (SELECT
            ID
        FROM
            Highschooler
        WHERE
            name = 'Gabriel');


-- 2. query cost - 39.51
SELECT
    h1.name
FROM
    Highschooler h1,
    Highschooler h2,
    Friend
WHERE
    h1.ID = Friend.ID1
        AND h2.name = 'Gabriel'
        AND h2.ID = Friend.ID2;


-- 3. query cost - 43.88
SELECT
    name
FROM
    Highschooler
WHERE
    id IN (SELECT ID1 FROM Friend WHERE id1 = id
                AND id2 IN (SELECT id FROM Highschooler WHERE name = 'Gabriel'));


-- As we can see the query 1 is the fastest as it involves only two table scans
-- while query 2 and 3 involve three table scans (two times for HighSchooler)
-- query 3 is slowest as it has two inner sub-queries

-- Q2 For every student who likes someone 2 or more grades younger than themselves, return that
-- student's name and grade, and the name and grade of the student they like.

-- solution to this query can be written in following two ways

-- 1. query cost - 88.26
SELECT
      h1.name, h1.grade, h2.name, h2.grade
FROM
    Highschooler h1
JOIN
    Likes l
ON
    h1.ID = l.ID1
JOIN
    Highschooler h2
ON
    h2.ID = l.ID2
WHERE
    h1.grade - h2.grade >= 2



-- 2. query cost - 109.26


SELECT
      t1.name, t1.grade, t2.name, t2.grade
FROM
    (SELECT * FROM Highschooler h, Likes l where h.ID = l.ID1) t1
JOIN
    (SELECT * FROM Highschooler h, Likes l where h.ID = l.ID2) t2
ON
    t1.ID2 = t2.ID2
WHERE
    t1.grade- t2.grade >= 2


-- As we can see the query 1 is the fastest as it involves only three table scans
-- while query 2 involve four table scans


-- Q3 For every pair of students who both like each other, return the name and grade of both students.
-- Include each pair only once, with the two names in alphabetical order

-- 1. query cost - 109.26

SELECT
      t1.name, t1.grade, t2.name, t2.grade
FROM
    (SELECT * FROM Highschoolers h, Likes l WHERE h.ID=l.ID1) t1

JOIN
    (SELECT * FROM Highschoolers h, Likes l WHERE h.ID=l.ID1) t2
ON
    t1.ID = t2.ID2 AND t2.ID = t1.ID2

WHERE
      t1.name < t2.name   --- to remove the duplicates
ORDER BY
      t1.name, t2.name

-- 2. query cost - 109.26

SELECT
    h1.name, h1.grade, h2.name, h2.grade
FROM
    Highschoolers h1, Likes l1, Highschoolers h2, Likes l2
WHERE
      (h1.ID = l1.ID1 AND h2.ID=l1.ID2) AND (h2.ID=l2.ID1 AND h1.ID=l2.ID2)
  AND h1.name < h2.name
ORDER BY
      h1.name, h2.name

-- both query takes same time as query execution plan is same to scan four tables


-- Q4 Find all students who do not appear in the Likes table (as a student who likes or is liked)
-- and return their names and grades. Sort by grade, then by name within each grade.

-- query cost 20.20
SELECT
	DISTINCT name, grade
FROM
	Highschooler
WHERE
	ID NOT IN (SELECT ID1 FROM Likes) AND h.ID NOT IN (SELECT ID2 FROM Likes)
ORDER BY
	grade, name;


-- query cost 20.20
SELECT
  DISTINCT name, grade
FROM
    Highschooler
WHERE
    ID NOT IN (SELECT id1 FROM Likes  -- note that we don't need to do distinct id here as
                UNION                 -- union will itself perform sorting and remove duplicates
              SELECT id2 FROM Likes)  -- from both tables

ORDER BY grade , name;

-- both query takes same time as query execution plan is same to scan three tables

-- Q5 For every situation where student A likes student B, but we have no information about
-- whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B’s names and grades.

-- query cost 88.26
SELECT
    h1.name, h1.grade, h2.name, h2.grade
FROM
    Highschooler h1
JOIN
    Likes l ON h1.ID = l.ID1    -- A

JOIN
    Highschooler h2 ON h2.ID = l.ID2  -- likes B
WHERE
    h2.ID NOT IN (SELECT ID1 FROM Likes);  -- B not as ID1 in Likes


-- query cost 88.26
SELECT
    t1.name, t1.grade, t2.name, t2.grade
FROM
    (SELECT * FROM Highschoolers h, Likes l
    WHERE h.ID = l.ID1
            AND ID2 NOT IN (SELECT ID1 FROM Likes)) t1
        JOIN
    highschoolers t2 ON t2.ID = t1.ID2;

-- both query takes same time as query execution plan is same to scan four tables


-- Q6 Find names and grades of students who only have friends in the same grade.
-- Return the result sorted by grade, then by name within each grade

-- query cost 20.20
SELECT
      h1.name, h1.grade
FROM
    Highschooler h1
WHERE
    ID NOT IN (SELECT ID1 FROM Highschooler h2, Friend f  WHERE h1.ID=f.ID1 AND h2.ID=f.ID2 AND h1.grade!=h2.grade)
ORDER BY
    h1.grade, h1.name

-- query cost 20.20
SELECT
    name, grade
FROM
    Highschooler
WHERE
    ID NOT IN (SELECT t1.id FROM
    (SELECT * FROM Highschooler h1, Friend f WHERE h1.ID = f.ID1) t1
		JOIN Highschooler h2 ON h2.ID = t1.ID2
        WHERE t1.grade != h2.grade)
ORDER BY grade , name

-- STEPS TO BUILD ABOVE QUERY

-- (SELECT * FROM Highschooler h1, Friend f WHERE h1.ID=f.ID1) t1
-- (SELECT * FROM Highschooler h1, Friend f WHERE h1.ID=f.ID1) t1 JOIN Highschooler h2 ON h2.id=t1.ID2
-- (SELECT * FROM Highschooler h1, Friend f WHERE h1.ID=f.ID1) t1 JOIN Highschooler h2 ON h2.id=t1.ID2 where t1.grade!=h2.grade
-- (SELECT t1.ID FROM (SELECT * FROM Highschooler h1, Friend f WHERE h1.ID=f.ID1) t1 JOIN Highschooler h2 ON h2.id=t1.ID2 where t1.grade!=h2.grade)
-- Finally,
-- SELECT name, grade FROM Highschooler WHERE ID NOT IN (SELECT t1.ID FROM
-- (SELECT * FROM Highschooler h1, Friend f WHERE h1.ID=f.ID1) t1 JOIN Highschooler h2 ON h2.id=t1.ID2 where t1.grade!=h2.grade)



-- Q7 For each student A who likes a student B where the two are not friends,
-- find if they have a friend C in common (who can introduce them!). For all such trios,
-- return the name and grade of A, B, and C

SELECT
	DISTINCT h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade
FROM
    Highschooler h1,
    Highschooler h2,
    Highschooler h3,
    Likes l,
    Friend f1,
    Friend f2
WHERE
    h1.ID = l.ID1 AND h2.ID = l.ID2    -- A likes B
        AND h2.id NOT IN (SELECT ID2 FROM Friend WHERE h1.ID = ID1)  --  B not friends with A
        AND (h1.ID = f1.ID1 AND h3.ID = f1.ID2)   -- A friends with C
        AND (h2.ID = f2.ID1 AND h3.ID = f2.ID2);  -- B friends with C



