-- Query that show which schools the "dropped" rate is higher than 50% 
SELECT "schools"."name", "schools"."city", "graduation_rates"."dropped"
FROM "schools"
JOIN "graduation_rates" ON "graduation_rates"."school_id" = "schools"."id"
WHERE "graduation_rates"."dropped" > 50.0
ORDER BY "graduation_rates"."dropped" DESC;

