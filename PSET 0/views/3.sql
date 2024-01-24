SELECT COUNT("english_title") AS 'hokusai prints with fuji in name'
FROM "views"
WHERE "artist" = 'Hokusai'
AND "english_title" LIKE '%fuji%';
