SELECT "salaries"."year", "salaries"."salary"
FROM "salaries"
JOIN "players" ON "players"."id" = "salaries"."player_id"
WHERE "salaries"."player_id" = (
	SELECT "id" FROM "players"
	WHERE "first_name" = 'Cal'
	AND "last_name" = 'Ripken'
)
ORDER BY "salaries"."year" DESC;
