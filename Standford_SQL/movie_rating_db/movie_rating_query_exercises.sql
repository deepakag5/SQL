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

--Q4 Some reviewers didn't provide a date with their rating. Find the names of all reviewers
-- who have ratings with a NULL value for the date.

SELECT name
FROM Reviewer
WHERE Reviewer.rID IN (SELECT rID FROM Rating WHERE ratingDate is NULL)

--Q5 Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate.
--Also, sort the data, first by reviewername, then by movie title, and lastly by number of stars.

SELECT DISTINCT name,title,stars,ratingDate
FROM Reviewer,Movie,Rating
WHERE Reviewer.rID=Rating.rID AND Rating.mID=Movie.mID
ORDER BY name,title,stars


--Q6 For all cases where the same reviewer rated the same movie twice and gave it a higher
-- rating the second time, return the reviewer's name and the title of the movie

SELECT s1.name, s1.title
FROM (SELECT name, title, stars, ratingDate
    FROM Reviewer rw, Movie m, Rating r
    WHERE rw.rID = r.rID AND r.mID = m.mID
    ORDER BY name , title , stars) s1,
    (SELECT name, title, stars, ratingDate
    FROM Reviewer rw, Movie m, Rating r
    WHERE rw.rID = r.rID AND r.mID = m.mID
    ORDER BY name , title , stars) s2
WHERE s1.name = s2.name
      AND s1.title = s2.title
      AND s1.stars < s2.stars
      AND s1.ratingDate < s2.ratingDate;


--Q7 For each movie that has at least one rating, find the highest number of stars that movie
-- received. Return the movie title and number of stars. Sort by movie title.

SELECT title, MAX(stars)
FROM Movie m
JOIN Rating r ON m.mID = r.mID
GROUP BY title
ORDER BY title;

-Q8 For each movie, return the title and the 'rating spread', that is, the difference between highest
--and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title.

SELECT title, MAX(stars)-MIN(stars) as rating_spread
FROM Movie m
JOIN Rating r ON m.mID = r.mID
GROUP BY title
ORDER BY rating_spread DESC,title;
