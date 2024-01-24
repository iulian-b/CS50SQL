SELECT "players"."first_name", "players"."last_name", "salaries"."salary"
FROM "players"
JOIN "salaries" ON "salaries"."player_id" = "players"."id"
WHERE "salaries"."year" = 2001
ORDER BY "salaries"."salary" ASC, "players"."first_name" ASC, "players"."last_name" ASC, "players"."id" ASC 
LIMIT 50;
