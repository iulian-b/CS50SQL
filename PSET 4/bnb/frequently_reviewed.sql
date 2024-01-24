CREATE VIEW "frequently_reviewed" AS
SELECT "listings"."id", "property_type","host_name", count("reviews"."id") AS "total reviews"
FROM "listings", "reviews"
WHERE "listings"."id" = "reviews"."listing_id"
GROUP BY "reviews"."listing_id"
ORDER BY "total reviews" DESC, "property_type" ASC, "host_name" ASC
