-- List all of the players whose birthday is in the current month, ordered first by birth day and then first name, last name
SELECT "first_name", "last_name", "birth_day"
FROM "players"
WHERE "birth_month" = strftime('%m','now')
ORDER BY "birth_day" ASC, "first_name", "last_name";
