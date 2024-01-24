CREATE TABLE `users` (
    `id` INT UNSIGNED AUTO_INCREMENT,
    `first_name` VARCHAR(32) NOT NULL,
    `last_name` VARCHAR(32) NOT NULL,
    `username` VARCHAR(32) NOT NULL UNIQUE,
    `password` VARCHAR(128) NOT NULL,
    PRIMARY KEY(`id`)
);

CREATE TABLE `schools_universities` (
    `id` INT UNSIGNED AUTO_INCREMENT,
    `name` VARCHAR(32) NOT NULL,
    `type` ENUM('Primary','Secondary','Higher Education') NOT NULL,
    `location` VARCHAR(32),
    -- YEAR ONLY GOES FROM 1901 TO 2155
    `founded_year` SMALLINT UNSIGNED,
    PRIMARY KEY(`id`)
);

CREATE TABLE `companies` (
    `id` INT UNSIGNED AUTO_INCREMENT,
    `name` TEXT NOT NULL,
    `industry` ENUM('Technology','Education','Business'),
    `location` TEXT,
    PRIMARY KEY(`id`)
);

CREATE TABLE `con_users` (
    `user_a` INT UNSIGNED NOT NULL,
    `user_b` INT UNSIGNED NOT NULL,
    FOREIGN KEY(`user_a`) REFERENCES `users`(`id`),
    FOREIGN KEY(`user_b`) REFERENCES `users`(`id`)
);

CREATE TABLE `con_education` (
    `id` INT UNSIGNED AUTO_INCREMENT,
    `user_id` INT UNSIGNED NOT NULL,
    `school_uni_id` INT UNSIGNED NOT NULL,
    `education_start` DATE NOT NULL,
    `education_end` DATE,
    `degree` VARCHAR(32),
    FOREIGN KEY(`user_id`) REFERENCES `users`(`id`),
    FOREIGN KEY(`school_uni_id`) REFERENCES `schools_universities`(`id`),
    PRIMARY KEY(`id`)
);

CREATE TABLE `con_employment` (
    `id` INT UNSIGNED AUTO_INCREMENT,
    `user_id` INT UNSIGNED NOT NULL,
    `company_id` INT UNSIGNED NOT NULL,
    `employment_start` DATE NOT NULL,
    `employment_end` DATE,
    `title` VARCHAR(32),
    FOREIGN KEY(`user_id`) REFERENCES `users`(`id`),
    FOREIGN KEY(`company_id`) REFERENCES `companies`(`id`),
    PRIMARY KEY(`id`)
);
