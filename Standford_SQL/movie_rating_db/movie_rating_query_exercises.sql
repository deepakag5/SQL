--Q1 Find the titles of all movies directed by Steven Spielberg

SELECT title
FROM Movie
WHERE director ='Steven Spielberg'

--Q2 Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order

SELECT year
FROM Movie
WHERE mID IN (SELECT mID FROM Rating WHERE stars IN (4 , 5))
ORDER BY year;

-- Q3 Find the titles of all movies that have no ratings
-- query cost 2.6
SELECT title
FROM Movie
WHERE Movie.mID NOT IN (SELECT mID FROM Rating);

-- query cost 8.5
SELECT m.title
FROM Movie m
LEFT JOIN Rating r
ON  m.mID=r.mID
WHERE r.mID is NULL;

-- second query took more time as it need to perform join