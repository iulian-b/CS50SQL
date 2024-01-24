CREATE TABLE "cipher" (
    "id" INTEGER,
    "start" INTEGER,
    "length" INTEGER,
    PRIMARY KEY("id")
);

INSERT INTO "cipher" ("id","start","length")
VALUES
    (14,98,4),
    (114, 3, 5),
    (618, 72, 9),
    (630, 7, 3),
    (932, 12, 5),
    (2230, 50, 7),
    (2346, 44, 10),
    (3041, 14, 5);

CREATE VIEW "message" AS
SELECT substr("sentence", "cipher"."start", "cipher"."length") AS "phrase" FROM "sentences", "cipher" WHERE "sentences"."id" = "cipher"."id";
