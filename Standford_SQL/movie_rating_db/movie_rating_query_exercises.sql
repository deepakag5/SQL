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

--Q4 Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date.

SELECT name
FROM Reviewer
WHERE Reviewer.rID IN (SELECT rID FROM Rating WHERE ratingDate is NULL)

--Q5 Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate.
--Also, sort the data, first by reviewername, then by movie title, and lastly by number of stars.

SELECT DISTINCT name,title,stars,ratingDate
FROM Reviewer,Movie,Rating
WHERE Reviewer.rID=Rating.rID AND Rating.mID=Movie.mID
ORDER BY name,title,stars