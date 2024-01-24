SELECT "players"."first_name", "players"."last_name", ("salaries"."salary" / "performances"."H") AS "dollars per hit"
FROM "players"
JOIN "performances" ON "performances"."player_id" = "players"."id"
JOIN "salaries" ON "salaries"."player_id" = "players"."id"
WHERE "performances"."H" IS NOT 0
AND "salaries"."year" = 2001
AND "performances"."year" = 2001
ORDER BY "dollars per hit" ASC, "players"."first_name" ASC, "players"."last_name" ASC
LIMIT 10;
