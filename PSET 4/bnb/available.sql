CREATE VIEW "available" AS
SELECT "listings"."id", "property_type","host_name", "date"
FROM "listings", "availabilities"
WHERE "listings"."id" = "availabilities"."listing_id"
AND "available" = 'TRUE'
