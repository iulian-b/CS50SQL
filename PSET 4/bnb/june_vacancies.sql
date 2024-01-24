CREATE VIEW "june_vacancies" AS
SELECT "listings"."id", "property_type","host_name", count("availabilities"."id") AS "days available"
FROM "listings", "availabilities"
WHERE "listings"."id" = "availabilities"."listing_id"
AND "date" LIKE '2023-06-%' AND "available" = 'TRUE'
GROUP BY "availabilities"."listing_id";
