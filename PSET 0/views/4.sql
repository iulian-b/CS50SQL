SELECT COUNT("english_title") AS 'hiroshige prints with eastern capital in name'
FROM "views"
WHERE "artist" = 'Hiroshige'
AND "english_title" LIKE '%eastern_capital%';
