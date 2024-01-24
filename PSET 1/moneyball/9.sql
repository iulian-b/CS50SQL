SELECT "teams"."name", ROUND(AVG("salaries"."salary"),2) AS "average salary"
FROM "salaries"
LEFT JOIN "teams" ON "teams"."id" = "salaries"."team_id"
WHERE "salaries"."year" = 2001
--AND "average salary" <= (
--	SELECT ROUND(AVG("salary"),2)
--	FROM "salaries"
--	WHERE "year" = 2021
--)
GROUP BY "salaries"."team_id"
ORDER BY "average salary" ASC
LIMIT 5;
