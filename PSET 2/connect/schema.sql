CREATE TABLE "users" (
    "id" INTEGER,
    "first_name" TEXT,
    "last_name" TEXT,
    "username" TEXT NOT NULL UNIQUE,
    "password" TEXT NOT NULL,
    PRIMARY KEY("id")
);

CREATE TABLE "schools_universities" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "type" TEXT,
    "location" TEXT,
    "founded_year" INTEGER,
    PRIMARY KEY("id")
);

CREATE TABLE "companies" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "industry" TEXT,
    "location" TEXT,
    PRIMARY KEY("id")
);

CREATE TABLE "con_users" (
    "user_a" INTEGER NOT NULL,
    "user_b" INTEGER NOT NULL,
    FOREIGN KEY("user_a") REFERENCES "users"("id"),
    FOREIGN KEY("user_b") REFERENCES "users"("id")
);

CREATE TABLE "con_education" (
    "id" INTEGER,
    "user_id" INTEGER NOT NULL,
    "school_uni_id" INTEGER NOT NULL,
    "education_start" NUMERIC NOT NULL,
    "education_end" NUMERIC,
    "degree" TEXT,
    FOREIGN KEY("user_id") REFERENCES "users"("id"),
    FOREIGN KEY("school_uni_id") REFERENCES "schools_universities"("id"),
    PRIMARY KEY("id")
);

CREATE TABLE "con_employment" (
    "id" INTEGER,
    "user_id" INTEGER NOT NULL,
    "company_id" INTEGER NOT NULL,
    "employment_start" NUMERIC NOT NULL,
    "employment_end" NUMERIC,
    "title" TEXT,
    FOREIGN KEY("user_id") REFERENCES "users"("id"),
    FOREIGN KEY("company_id") REFERENCES "companies"("id"),
    PRIMARY KEY("id")
);
