--------------------------------------------- [SELECT QUERIES]
------- COMPUTERS
----- Show all available PCs
SELECT *
FROM "computers_prices";
----- Show all computers specs
SELECT *
FROM "computers_specs";
----- SHow all Computers under $1000 and their specifications
SELECT *
FROM "computers_specs"
WHERE "Price (USD)" <= 2000;
----- Show GPU info about computer 'Green Devil'
SELECT *
FROM "computers_gpu_details"
WHERE "Computer" = 'Green Devil';
----- Show CPU info about computer 'Beastmasters'
SELECT * FROM "computers_cpu_details"
WHERE "Computer" = 'Beastmaster';


------- COMPONENTS
----- Show all CPUs
SELECT *
FROM "cpus";
----- Show all Intel CPUs
SELECT *
FROM "cpus"
WHERE "manufacturer" = 'Intel';
----- Show all Intel 8 core i7 CPUs, ordered by their base frequency (higher to lower)
SELECT *
FROM "cpus"
WHERE "manufacturer" = 'Intel'
AND "model" LIKE 'i7%'
AND "cores" = 8
ORDER BY "base_frequency" DESC;

------- ORDERS
----- Show all orders
SELECT *
FROM "all_orders";
----- Show details about a certain order
SELECT *
FROM "all_orders_details"
WHERE "Order Nr." = 3;
----- Show all items bought by David Malan
SELECT *
FROM "all_orders_details"
WHERE "First Name" = 'David'
AND "Last Name" = 'Malan';

--------------------------------------------- [INSERT QUERIES]
----- Add a gpu
INSERT INTO "gpus"("model","manufacturer","release_date","price","cores","memory","membus","tflops","tbp")
VALUES ('RTX 3090 Ti','Nvidia','2022',1999.00,10752,24,384,40.00,450);
----- Add a computer
INSERT INTO "computers"("computer_id","name","storage","cpu","gpu","psu","mobo")
VALUES (10,'Exampluter','0.5TB',1,2,3,4),
----- Add a customer
INSERT INTO "customers"("first_name","last_name")
VALUES ('Boaty','McBoatface');
----- Add an order with 2 Exampluters and 1 Beastmaster (id 4)
INSERT INTO "orders"("order_id","customer_id","timestamp","address")
VALUES (10,5,'2023-11-22 11:23:45','Somewhere Str. 101');
INSERT INTO "order_items"("order_id","computer_id","quantity")
VALUES  (10,10,2),
        (10,4,1);

--------------------------------------------- [UPDATE QUERIES]
----- Change the first name of a customer
UPDATE "customers"
SET "first_name" = "Iulian Ionel"
WHERE "first_name" = "Iulian"
AND "last_name" = "Bocse";
----- Reduce the price of a component by 50%
UPDATE "psus"
SET "price" = ("price"/2)
WHERE "model" = 'SF750';

--------------------------------------------- [DELETE QUERIES]
----- Remove a computer
DELETE FROM "computers"
WHERE "name" = 'Topaz Pro';
----- Remove all power supply units older than 2019
DELETE FROM "psus"
WHERE "release_date" < 2019;
