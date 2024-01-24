
-- *** The Lost Letter ***

-- First, i searched Anekke's address in the ADDRESSES table:
--  SELECT * FROM "addresses"
--  WHERE "address" LIKE '900 Somerville Avenue';

-- Then i used her address id to find all of the packages sent from there: 
--  SELECT * FROM "packages"
--  WHERE "from_address_id" = (
--    SELECT "id" FROM "addresses"
--    WHERE "address" = '900 Somerville Avenue'
--  );

-- That query tells me that the missing letter (named 'Congratulatory letter') was sent to and address with id 854.
-- So i searched that address:
--  SELECT "address", "type"
--  FROM "adresses"
--  WHERE "id" = (
--    SELECT "to_address_id"
--    FROM "packages"
--    WHERE "contents" = 'Congratulatory letter'
--    AND "from_address_id" = (
--      SELECT "id"
--      FROM "addresses"
--      WHERE "address" = '900 Somerville Avenue'
--    )
-- );
-- This tells me that the letter was sent to '2 FinnIgan Street', not '2 FinnEgan Street'.

-- *** The Devious Delivery ***

-- First thing i do is searching for a package without a "from_address_id":
--  SELECT * FROM "packages" WHERE "from_address_id" IS NULL

-- The only item without a from_address_id is a 'Duck debugger', which has a "to_address_id" of 50.
-- So i searched that address:
--  SELECT "address", "type"
--  FROM "addresses"
--  WHERE "id" = (
--    SELECT "to_address_id"
--    FROM "packages"
--    WHERE "contents" = 'Duck debugger'
--    AND "from_address_id" IS NULL
--  );
-- The address found is '123 Sesame Street'.

-- With all this information, i decided to see the "scans" table to check if it ended up at 123 Sesame Street:
--  SELECT * FROM "scans" 
--  WHERE "package_id" = (
--    SELECT "id"
--    FROM "packages"
--    WHERE "contents" = 'Duck debugger'
-- );
-- And i get 2 entries: the package was PICKED up from address 50 (123 Sesame Street), and was DROPPED at address 348.

-- A quick look at address 348 tells me where it ended up:
--  SELECT "address", "type"
--  FROM "addresses"
--  WHERE "id" = 348;
-- The result is '7 Humboldt Place', a Police Station. 

-- *** The Forgotten Gift ***

-- Since i don't know anything about the package itself but only the addresses, i first searched them out:
--  SELECT * FROM "addresses" WHERE "address" = '728 Maple Place';
--  SELECT * FROM "addresses" WHERE "address" = '109 Tileston Street';

-- Since both addresses are there, i can look for a package using them:
--  SELECT *
--  FROM "packages"
--  WHERE "from_address_id" = (
--    SELECT "id"
--    FROM "addresses"
--    WHERE "address" = '109 Tileston Street')
--  AND "to_address_id" = (
--    SELECT "id"
--    FROM "addresses"
--    WHERE "address" = '728 Maple Place');

-- Which gives me 1 package with id 9523 and contents of 'Flowers'.
-- So i searched that package's scans:
--  SELECT * FROM "scans" WHERE "package_id" = 9523;
-- And found out that the package was first picked up from '109 Tileston Street', then dropped at an address with id 7432 (not the correct address, whose is 4983), and then picked up again from that last address.

-- Because the package was last picked up, but not dropped somewhere, it means that it's in possesion of a delivery driver.
-- So i searched for that delivery driver:
--  SELECT "name"
--  FROM "drivers"
--  WHERE "id" = 17;
-- The driver's name is Mikel, he has the package. 
-- A driver with id 11 (Maegan) Picked up and deliverd the Flowers to the wrong address, so Mikel stepped in 6 days later and took the package back. 
