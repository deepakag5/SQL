--1 Find the titles of all movies directed by Steven Spielberg.

SELECT title
FROM Movie
WHERE director ='Steven Spielberg'

--2 Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.

SELECT year
FROM Movie
WHERE mID IN (SELECT mID FROM Rating WHERE stars IN (4 , 5))
ORDER BY year;