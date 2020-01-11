-- https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/jump_to/i4x://DB/SQL/sequential/seq-exercise-sql_social_query_core

-- Find the names of all students who are friends with someone named Gabriel
-- this query can be written in following three ways

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
    id IN (SELECT
            ID1
        FROM
            Friend
        WHERE
            id1 = id
                AND id2 IN (SELECT
                    id
                FROM
                    Highschooler
                WHERE
                    name = 'Gabriel'));


-- As we can see the query 1 is the fastest as it involves only two table scans
-- while query 2 and 3 involve 3 table scans (two times for HighSchooler)
-- query 3 is slowest as it has two inner sub-queries

-- For every student who likes someone 2 or more grades younger than themselves, return that
-- student's name and grade, and the name and grade of the student they like.

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