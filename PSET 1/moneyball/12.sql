SELECT "players"."first_name", "players"."last_name"
FROM "players"
WHERE "id" IN (
	SELECT "players"."id"
	FROM "players"
	JOIN "salaries" ON "salaries"."player_id" = "players"."id"
	JOIN "performances" ON "performances"."player_id" = "salaries"."player_id"
	WHERE "salaries"."year" = 2001
	AND "salaries"."year" = "performances"."year"
	AND "performances"."H" > 0
	ORDER BY "salaries"."salary" / "performances"."H", "players"."first_name", "players"."last_name"
	LIMIT 10
)
AND "id" IN (
	SELECT "players"."id"
	FROM "players"
	JOIN "salaries" ON "salaries"."player_id" = "players"."id"
	JOIN "performances" ON "performances"."player_id" = "salaries"."player_id"
	WHERE "salaries"."year" = 2001
	AND "salaries"."year" = "performances"."year"
	AND "performances"."RBI" > 0
	ORDER BY "salaries"."salary" / "performances"."RBI", "players"."first_name", "players"."last_name"
	LIMIT 10
)
ORDER BY "players"."id";
