SELECT "salaries"."salary"
FROM "performances"
INNER JOIN "salaries" ON "salaries"."player_id" = "performances"."player_id"
WHERE "salaries"."year" = 2001
AND "performances"."HR" = (
	SELECT MAX("HR")
	FROM "performances"
);

