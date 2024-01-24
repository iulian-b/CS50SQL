-- List all of the episodes from the first 10 seasons of the show who contain the words 'hack' or 'cyber' in their title
SELECT "title", "season"
FROM "episodes"
WHERE "season" <= 10
AND "title" LIKE '%hack%' OR "title" LIKE '%cyber%';
