CREATE VIEW "most_populated" AS
SELECT "district", SUM("families") AS 'Total Families', SUM("households") AS 'Total Households', SUM("population") AS 'Total Population', SUM("male") AS 'Total Males', SUM("female") AS 'Total Females' FROM "census"
GROUP BY "district"
ORDER BY "Total Population" DESC
