SELECT COUNT("title") AS 'episodes in last 6 years'
FROM "episodes"
WHERE "air_date" BETWEEN '2018-01-01' AND '2023-12-31'; 
