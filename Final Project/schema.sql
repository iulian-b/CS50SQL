--------------------------------------------- [COMPONENTS TABLES]
CREATE TABLE "cpus" (
    -- Base info
    "id" INTEGER,
    "model" TEXT NOT NULL,
    "manufacturer" TEXT NOT NULL,
    "release_date" INTEGER,
    "price" REAL NOT NULL, -- Assume MSRP. If not found, then amazon.com
    -- Specs
    "cores" INTEGER CHECK("cores" % 2 = 0) NOT NULL,
    "threads" INTEGER CHECK("threads" > "cores") CHECK("threads" % 2 = 0) NOT NULL,
    "base_frequency" REAL NOT NULL,
    "turbo_frequency" REAL CHECK("turbo_frequency" > "base_frequency"),
    "cache" INTEGER CHECK("cache" > 0) NOT NULL,
    --"tpd" INTEGER, --assume base, not turbo

    PRIMARY KEY("id")
);

CREATE TABLE "gpus" (
    -- Base info
    "id" INTEGER,
    "model" TEXT NOT NULL,
    "manufacturer" TEXT NOT NULL,
    "release_date" INTEGER,
    "price" REAL NOT NULL, -- Assume MSRP. If not found, then amazon.com
    -- Specs
    "cores" INTEGER NOT NULL,
    "memory" INTEGER NOT NULL,
    "membus" INTEGER NOT NULL,
    "tflops" REAL, -- Assume FP16(half)
    "tbp" INTEGER NOT NULL,

    PRIMARY KEY("id")
);

CREATE TABLE "psus" (
    -- Base info
    "id" INTEGER,
    "model" TEXT NOT NULL,
    "manufacturer" TEXT NOT NULL,
    "release_date" INTEGER,
    "price" REAL NOT NULL, -- Assume MSRP. If not found, then amazon.com
    -- Specs
    "output" INTEGER NOT NULL,
    "efficency" TEXT CHECK("efficency" IN('None','80 PLUS','80 PLUS Bronze','80 PLUS Silver','80 PLUS Gold','80 PLUS Platinum','80 PLUS Titanium')) DEFAULT('None'),
    "form_factor" TEXT NOT NULL,
    "modularity" TEXT CHECK("modularity" IN('None','Semi','Full')) DEFAULT('None'),

    PRIMARY KEY("id")
);

CREATE TABLE "mobos" (
    -- Base info
    "id" INTEGER,
    "model" TEXT NOT NULL,
    "manufacturer" TEXT NOT NULL,
    "release_date" INTEGER,
    "price" REAL NOT NULL, -- Assume MSRP. If not found, then amazon.com
    -- Specs
    "socket" TEXT CHECK("socket" IN('AM4','LGA1700','LGA1200')) NOT NULL,
    "form_factor" TEXT CHECK("form_factor" IN('ATX','E-ATX','mATX','ITX')) NOT NULL,
    "chipset" TEXT NOT NULL,
    "wifi" TEXT CHECK("wifi" IN('yes','no')) DEFAULT('no'),

    PRIMARY KEY("id")
);

--------------------------------------------- [COMPUTERS TABLE]
CREATE TABLE "computers" (
    -- Base info
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "storage" REAL CHECK("quantity" > 0.00) NOT NULL,
    "ram" INTEGER CHECK("quantity" > 0) NOT NULL,
    --"deleted" INTEGER CHECK ("deleted" IN(1,0) DEFAUKT('0')
    --components
    "cpu" INTEGER NOT NULL,
    "gpu" INTEGER NOT NULL,
    "psu" INTEGER NOT NULL,
    "mobo" INTEGER NOT NULL,

    FOREIGN KEY("cpu") REFERENCES "cpus"("id") ON DELETE CASCADE,
    FOREIGN KEY("gpu") REFERENCES "gpus"("id") ON DELETE CASCADE,
    FOREIGN KEY("psu") REFERENCES "psus"("id") ON DELETE CASCADE,
    FOREIGN KEY("mobo") REFERENCES "mobos"("id") ON DELETE CASCADE,
    PRIMARY KEY("id")
);

--------------------------------------------- [CUSTOMERS & ORDERS TABLES]
CREATE TABLE "customers" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,

    PRIMARY KEY("id")
);

CREATE TABLE "orders" (
    "id" INTEGER,
    "customer_id" INTEGER NOT NULL,
    "timestamp" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "address" TEXT NOT NULL,

    FOREIGN KEY("customer_id") REFERENCES "customers"("id") ON DELETE SET NULL,
    PRIMARY KEY("id")
);

CREATE TABLE "order_items" (
    "order_id" INTEGER,
    "computer_id" INTEGER,
    "quantity" INTEGER NOT NULL CHECK("quantity" > 0),

    FOREIGN KEY("computer_id") REFERENCES "computers"("id") ON DELETE SET NULL,
    FOREIGN KEY("order_id") REFERENCES "orders"("id") ON DELETE CASCADE,
    PRIMARY KEY("order_id","computer_id")
);

--------------------------------------------- [VIEWS]
----- NOTE: 24.99 IS THE ARBITRARY ASSEMBLY FEE
--- SHOW ALL COMPUTERS AND PRICES (ORDERED BY PRICE, HIGH->LOW)
CREATE VIEW "computers_prices" AS
SELECT "computers"."name" AS "Name", "cpus"."price" + "gpus"."price" + "psus"."price" + "mobos"."price" + 24.99 AS "Price (USD)"
FROM "computers"
JOIN "cpus" ON "cpus"."id" = "computers"."cpu"
JOIN "gpus" ON "gpus"."id" = "computers"."gpu"
JOIN "psus" ON "psus"."id" = "computers"."psu"
JOIN "mobos" ON "mobos"."id" = "computers"."mobo"
ORDER BY "Price (USD)" DESC;

--- SHOW ALL COMPUTERS, SPECS AND PRICES (ORDERED BY PRICE, HIGH->LOW)
CREATE VIEW "computers_specs" AS
SELECT "computers"."name" AS "Name",
"cpus"."manufacturer" || " " || "cpus"."model" AS "Processor",
"gpus"."manufacturer" || " " || "gpus"."model" AS "Graphics Card",
"psus"."manufacturer" || " " || "psus"."model" AS "Power Supply",
"mobos"."manufacturer" || " " || "mobos"."model" AS "Motherboard",
"computers"."storage" AS "Storage (TB)",
"computers"."ram" AS "RAM (GB)",
"cpus"."price" + "gpus"."price" + "psus"."price" + "mobos"."price" + 24.99 AS "Price (USD)"
FROM "computers"
JOIN "cpus" ON "cpus"."id" = "computers"."cpu"
JOIN "gpus" ON "gpus"."id" = "computers"."gpu"
JOIN "psus" ON "psus"."id" = "computers"."psu"
JOIN "mobos" ON "mobos"."id" = "computers"."mobo"
ORDER BY "Price (USD)" DESC;

--- SHOW ALL COMPUTER'S CPU INFO (ORDERED BY CPU RELEASE YEAR, NEW->OLD)
CREATE VIEW "computers_cpu_details" AS
SELECT "computers"."name" AS "Computer", "manufacturer" AS "Brand", "model" AS "Model",
"release_date" AS "Released In", "cores" AS "Cores", "threads" AS "Threads",
"base_frequency" AS "Frequency (GHz)", "turbo_frequency" AS "Turbo Frequency (GHz)",
"cache" AS "Cache (MB)"
FROM "cpus"
JOIN "computers" ON "computers"."cpu" = "cpus"."id"
ORDER BY "cpus"."release_date" DESC;

--- SHOW ALL COMPUTER'S GPU INFO (ORDERED BY TLFOPS, MORE->LESS)
CREATE VIEW "computers_gpu_details" AS
SELECT "computers"."name" AS "Computer", "manufacturer" AS "Brand", "model" AS "Model",
"release_date" AS "Released In", "cores" AS "Cores", "memory" AS "GDDR6 Memory (GB)",
"membus" AS "Bus Width (bit)", "tflops" AS "TeraFlops", "tbp" AS "Typical Board Power (W)"
FROM "gpus"
JOIN "computers" ON "computers"."gpu" = "gpus"."id"
ORDER BY "gpus"."tflops" DESC;

--- SHOW ALL COMPUTER'S PSU INFO (ORDERED BY OUTPUT, MORE->LESS)
CREATE VIEW "computers_psu_details" AS
SELECT "computers"."name" AS "Computer", "manufacturer" AS "Brand", "model" AS "Model",
"release_date" AS "Released In", "output" AS "Output (W)", "efficency" AS "Efficency Rating"
FROM "psus"
JOIN "computers" ON "computers"."psu" = "psus"."id"
ORDER BY "psus"."output" DESC;

--- SHOW ALL COMPUTER'S MOBO INFO (ORDERED BY RELEASE YEAR, NEW->LESS)
CREATE VIEW "computers_mobo_details" AS
SELECT "computers"."name" AS "Computer", "manufacturer" AS "Brand", "model" AS "Model",
"release_date" AS "Released In", "chipset" AS "Chipset", "form_factor" AS "Size",
"wifi" AS "Has WiFi"
FROM "mobos"
JOIN "computers" ON "computers"."mobo" = "mobos"."id"
ORDER BY "mobos"."release_date" DESC;

--- SHOW ALL ORDERS WITH TOTALS (ORDERED BY ORDER ID)
CREATE VIEW "all_orders" AS
SELECT "orders"."id" AS " Order Nr.",
"customers"."first_name" AS "First Name",
"customers"."last_name" AS "Last Name",
"orders"."address" AS "Shipping Address",
strftime('%d/%m',"orders"."timestamp") AS "Date",
SUM(("cpus"."price" + "gpus"."price" + "psus"."price" + "mobos"."price" + 24.99) * "quantity") AS "Total (USD)"
FROM "order_items"
JOIN "orders" ON "orders"."id" = "order_items"."order_id"
JOIN "computers" ON "order_items"."computer_id" = "computers"."id"
JOIN "customers" ON "orders"."customer_id" = "customers"."id"
JOIN "cpus" ON "cpus"."id" = "computers"."cpu"
JOIN "gpus" ON "gpus"."id" = "computers"."gpu"
JOIN "psus" ON "psus"."id" = "computers"."psu"
JOIN "mobos" ON "mobos"."id" = "computers"."mobo"
GROUP BY "orders"."id";

--- SHOW ALL ORDERS WITH ITEMS, QUANTITIES AND ITEMS TOTAL PRICES (ORDERED BY ORDER ID)
CREATE VIEW "all_orders_details" AS
SELECT "orders"."id" AS "Order Nr.",
"customers"."first_name" AS "First Name",
"customers"."last_name" AS "Last Name",
"orders"."address" AS "Shipping Address",
"orders"."timestamp" AS "Timestamp",
"computers"."name" AS "Item",
"order_items"."quantity" AS "Quantity",
("cpus"."price" + "gpus"."price" + "psus"."price" + "mobos"."price") * "quantity" AS "Items Total (USD)",
"quantity" * 24.99 AS "Assembly Fee (USD)"
FROM "order_items"
JOIN "orders" ON "orders"."id" = "order_items"."order_id"
JOIN "computers" ON "order_items"."computer_id" = "computers"."id"
JOIN "customers" ON "orders"."customer_id" = "customers"."id"
JOIN "cpus" ON "cpus"."id" = "computers"."cpu"
JOIN "gpus" ON "gpus"."id" = "computers"."gpu"
JOIN "psus" ON "psus"."id" = "computers"."psu"
JOIN "mobos" ON "mobos"."id" = "computers"."mobo"
ORDER BY "orders"."id";

--------------------------------------------- [INDEXES]
CREATE INDEX "cpu_index" ON "cpus"("manufacturer","model");
CREATE INDEX "gpu_index" ON "gpus"("manufacturer","model");
CREATE INDEX "psu_index" ON "psus"("manufacturer","model");
CREATE INDEX "mobo_index" ON "mobos"("manufacturer","model");

CREATE INDEX "customers_index" ON "customers"("first_name","last_name");

--------------------------------------------- [POPULATE DB WITH INITIAL DATA]
----- CPUs
INSERT INTO "cpus"("model","manufacturer","release_date","price","cores","threads","base_frequency","turbo_frequency","cache")
--- Intel
-- i9
VALUES  ('i9-13900KS','Intel','2023',699.00,24,32,3.20,6.00,36),
        ('i9-13900','Intel','2023',579.00,24,32,2.00,5.60,36),
        ('i9-11900','Intel','2023',493.00,8,16,2.50,5.20,16),
-- i7
        ('i7-13700','Intel','2023',394.00,16,24,2.10,5.20,30),
        ('i7-11700','Intel','2021',365.00,8,16,2.50,4.90,16),
        ('i7-10700F','Intel','2020',338.00,8,16,2.90,4.80,16),
-- i5
        ('i5-13400','Intel','2023',231.00,10,16,2.50,4.60,20),
        ('i5-13500','Intel','2023',242.00,14,20,2.50,4.80,24),
        ('i5-12500','Intel','2023',232.00,6,12,3.00,4.60,18),
--- AMD
-- R5000
        ('Ryzen 7 5700G','AMD','2021',359.00,8,16,3.80,4.60,18),
        ('Ryzen 5 5600G','AMD','2021',259.00,6,12,3.90,4.40,16),
        ('Ryzen 3 5300G','AMD','2021',89.99,4,8,4.00,4.20,8),
-- R4000
        ('Ryzen 7 4700G','AMD','2020',190.00,8,16,3.60,4.40,8),
        ('Ryzen 5 4600G','AMD','2020',154.00,6,12,3.70,4.20,3),
        ('Ryzen 3 4300G','AMD','2020',98.99,4,8,3.80,4.00,2);

----- GPUs
INSERT INTO "gpus"("model","manufacturer","release_date","price","cores","memory","membus","tflops","tbp")
--- Nvidia
-- 4000 Series
VALUES  ('RTX 4090','Nvidia','2022',1599.00,16384,24,384,82.58,450),
        ('RTX 4080','Nvidia','2022',1199.00,9728,16,256,48.74,320),
        ('RTX 4070 Ti','Nvidia','2023',799.00,7680,12,192,40.09,285),
-- 3000 Series
        ('RTX 3090','Nvidia','2020',1499.00,10496,24,384,35.58,350),
        ('RTX 3080 Ti','Nvidia','2021',1199.00,10240,12,384,34.10,350),
        ('RTX 3060','Nvidia','2021',329.00,3584,12,192,12.74,170),
--- AMD
-- RX 7000
        ('Radeon RX 7900 XTX','AMD','2022',999.00,6144,24,384,122.8,355),
        ('Radeon RX 7900 XT','AMD','2022',899.00,5376,20,320,103.0,300),
-- RX 6000
        ('Radeon RX 6950 XT','AMD','2022',1099.00,5120,16,256,47.31,335),
        ('Radeon RX 6800','AMD','2020',579.00,3840,16,256,32.33,250),
--- Intel
-- A700
        ('Arc A770','Intel','2022',329.00,4096,16,256,39.32,225),
        ('Arc A750','Intel','2022',289.00,3584,8,256,34.41,210);

----- PSUs
INSERT INTO "psus"("model","manufacturer","release_date","price","output","efficency","form_factor","modularity")
VALUES  ('SX1000','SilverStone','2021',269.79,1000,'80 PLUS Platinum','SFX-L','Full'),
        ('AX1600i','Corsair','2018',609.99,1600,'80 PLUS Titanium','ATX12V','Full'),
        ('SF750','Corsair','2019',184.99,750,'80 PLUS Platinum','SFX','Full'),
        ('Toughpower GF3 1350W','Thermaltake','2022',259.99,1350,'80 PLUS Gold','ATX12V','Full'),
        ('Toughpower 750W ','Thermaltake','2016',109.99,750,'80 PLUS Gold','ATX12V','Semi'),
        ('MAG A850GL','MSI','2023',139.99,850,'80 PLUS Gold','ATX','Semi');

----- MOBOs
INSERT INTO "mobos"("model","manufacturer","release_date","price","socket","form_factor","chipset","wifi")
--- AM4
VALUES  ('N7 B550','NZXT','2023',229.99,'AM4','ATX','AMD B550','yes'),
        ('ROG Strix B550-F','ASUS','2020',209.99,'AM4','ATX','AMD B550','yes'),
        ('X570 Aorus Ultra','Gigabyte','2020',299.99,'AM4','ATX','AMD X570','yes'),
--- LGA1700
        ('MAG Z790','MSI','2020',299.99,'LGA1700','ATX','Intel Z790','yes'),
        ('TUF B760M-PLUS','ASUS','2021',179.99,'LGA1700','mATX','Intel B760','yes'),
        ('MEG Z790 GODLIKE','MSI','2020',1199.99,'LGA1700','E-ATX','Intel Z790','no'),
--- LGA1200
        ('MEG Z590','MSI','2021',199.99,'LGA1200','ATX','Intel Z590','yes'),
        ('H410M','Gigabyte','2020',81.92,'LGA1200','mATX','Intel H410','no'),
        ('Z590','ASUS','2021',299.99,'LGA1200','ATX','Intel Z590','yes');

----- Computers
--- Green Team
INSERT INTO "computers"("name","storage","cpu","gpu","psu","mobo","ram")
VALUES  ('Green Devil Pro',2,1,1,2,6,64),
        ('Green Devil',1,3,3,1,4,32),
        ('Goblin',1.5,9,6,5,7,16),
--- Red Team
        ('Beastmaster',4,10,7,3,3,64),
        ('Ruby Gaming',2,11,9,1,1,32),
        ('Leclerc',1,15,10,5,2,16),
--- Blue Team
        ('Topaz Pro',2,2,11,5,6,32),
        ('Topaz',2,13,12,4,3,20);

----- Customers
INSERT INTO "customers"("first_name","last_name")
VALUES  ('Carter','Zenke'),
        ('Iulian','Bocse'),
        ('David','Malan'),
        ('Riccardo','Stalmano');

----- Orders
INSERT INTO "orders"("customer_id","timestamp","address")
VALUES  (4,'2021-09-18 07:52:18','Freedom Blvd. 100'),
        (2,'2022-05-04 03:12:34','Duck Str. 12'),
        (1,'2023-11-22 09:32:54','Sequelite Avn. 3'),
        (3,'2023-11-23 11:11:11','Cambridge, MA 02138');

----- Order ITEMs
INSERT INTO "order_items"("order_id","computer_id","quantity")
VALUES  (1,2,1),
        (2,4,1),
        (3,3,5),
        (3,6,5),
        (4,7,1),
        (4,1,3);
