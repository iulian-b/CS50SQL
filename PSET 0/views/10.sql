-- List the brightest prints about mountain passes, from brightest to least bright
SELECT "english_title" AS 'brightest passes prints'
FROM "views"
WHERE "english_title" LIKE '%pass%'
ORDER BY "brightness" DESC;
