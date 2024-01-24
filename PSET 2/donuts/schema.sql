CREATE TABLE "ingredients" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "price" REAL NOT NULL CHECK("amount" > 0.00),
    PRIMARY KEY("id")
);

CREATE TABLE "donuts" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "gluten_free" INTEGER NOT NULL DEFAULT 0,
    "price" REAL NOT NULL CHECK("amount" > 0.00),
    PRIMARY KEY("id")
);

CREATE TABLE "donut_ingredient" (
    "donut_id" INTEGER NOT NULL,
    "ingredient_id" INTEGER NOT NULL,
    -- "ingredient_amount" NUMERIC,
    FOREIGN KEY("donut_id") REFERENCES "donuts"("id"),
    FOREIGN KEY("ingredient_id") REFERENCES "ingredients"("id"),
    PRIMARY KEY("donut_id", "ingredient_id")
);

CREATE TABLE "customers" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    PRIMARY KEY("id")
);

CREATE TABLE "order" (
    "id" INTEGER,
    "customer_id" INTEGER NOT NULL,
    "order_datetime" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY("customer_id") REFERENCES "customers"("id"),
    PRIMARY KEY("id")
);

CREATE TABLE "order_item" (
    "order_id" INTEGER,
    "donut_id" INTEGER,
    "quantity" INTEGER NOT NULL CHECK("quantity" > 0),
    FOREIGN KEY("donut_id") REFERENCES "donuts"("id"),
    FOREIGN KEY("order_id") REFERENCES "orders"("id"),
    PRIMARY KEY("order_id","donut_id")
);
