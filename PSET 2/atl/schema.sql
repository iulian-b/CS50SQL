CREATE TABLE "passengers" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "age" INTEGER NOT NULL,
    PRIMARY KEY("id")
);


CREATE TABLE "airlines" (
    "id" INTEGER,
    "name" TEXT NOT NULL UNIQUE,
    -- "concourse" TEXT CHECK("concourse" IN('A','B','C','D','E','F','T',)),
    "concourse" TEXT,
    PRIMARY KEY("id")
);

CREATE TABLE "flights" (
    "id" INTEGER,
    "number" INTEGER NOT NULL,
    "airline_id" INTEGER,
    "departure_code" TEXT NOT NULL,
    "arrival_code" TEXT NOT NULL,
    "departure_datetime" NUMERIC NOT NULL,
    "arrival_datetime" NUMERIC,
    FOREIGN KEY("airline_id") REFERENCES "airlines"("id"),
    PRIMARY KEY("id")
);

CREATE TABLE "checkins" (
    "id" INTEGER,
    "checkin_time" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "flight_id" INTEGER NOT NULL,
    "passenger_id" INTEGER NOT NULL,
    FOREIGN KEY("flight_id") REFERENCES "flights"("id"),
    FOREIGN KEY("passenger_id") REFERENCES "passengers"("id"),
    PRIMARY KEY("id")
);