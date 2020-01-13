-- Q1 It's time for the seniors to graduate. Remove all 12th graders from Highschooler

DELETE FROM Highschooler
WHERE grade = 12;


-- Q2 If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple

DELETE FROM Likes
WHERE ID2 IN (
  SELECT ID2
  FROM Friend
  WHERE Friend.ID1 = Likes.ID1
) AND ID2 NOT IN (
  SELECT L.ID1
  FROM Likes L
  WHERE L.ID2 = Likes.ID1
);


-- Q3 For all cases where A is friends with B, and B is friends with C,
-- add a new friendship for the pair A and C. Do not add duplicate friendships,
-- friendships that already exist, or friendships with oneself

INSERT INTO Friend
SELECT DISTINCT F1.ID1, F2.ID2
FROM Friend F1, Friend F2
WHERE F1.ID2 = F2.ID1 AND F1.ID1 <> F2.ID2 AND F1.ID1 NOT IN (
  SELECT F3.ID1
  FROM Friend F3
  WHERE F3.ID2 = F2.ID2
);