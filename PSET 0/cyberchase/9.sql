SELECT COUNT("title") AS 'episodes in first 6 years'
FROM "episodes"
WHERE "air_date" BETWEEN '2002-01-01' AND '2007-12-31';
