-- ====================================================================================================================
-- = People database                                                                                                  =
-- =                                                                                                                  =
-- = Author: Andrew B. Collier <andrew@exegetic.biz> | @datawookie                                                    =
-- ====================================================================================================================

-- CREATE DATABASE ------------------------------------------------------------------------------------------

CREATE DATABASE people;

USE people;

-- CREATE TABLES --------------------------------------------------------------------------------------------

CREATE TABLE profession (
  id                INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  description       VARCHAR(128)
);

CREATE TABLE person (
  id                INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name              VARCHAR(128),
  gender            CHAR(1) NOT NULL,
  height            REAL,
  birth             DATE,
  job_id            INTEGER DEFAULT 1 NOT NULL,
  FOREIGN KEY (job_id) REFERENCES profession(id)
);

-- Get a list of tables.
--
SHOW TABLES;
--
-- Checking the structure of a table.
--
EXPLAIN profession;
EXPLAIN person;

-- INSERT DATA ----------------------------------------------------------------------------------------------

INSERT INTO profession (id) VALUES (0);
INSERT INTO profession (Description) VALUES ('Data Scientist');
INSERT INTO profession (Description) VALUES ('Data Analyst');
INSERT INTO profession (Description) VALUES ('Database Administrator');
INSERT INTO profession (Description) VALUES ('Statistician');
INSERT INTO profession (Description) VALUES ('Developer');
INSERT INTO profession (Description) VALUES ('Team Lead');

INSERT INTO person (name, gender, birth) VALUES ('Thomas',  'M',  '2003-03-19');
--
-- What profession has been assigned to Thomas? Why?
--
INSERT INTO person (name, gender, birth) VALUES ('Andrea',  'F',  '2001-06-13');
INSERT INTO person (name, gender, birth) VALUES ('Roberta', 'F',  '2002-06-25');
INSERT INTO person (name, gender, height, birth) VALUES ('Rudy',    'M',  182.5, '2001-11-24');
INSERT INTO person (name, gender, height, birth) VALUES ('Maria',   'F',  175.3, '2002-06-28');
INSERT INTO person (name, gender, height, birth) VALUES ('Anthony', 'M',  184.7, '2001-12-23');
INSERT INTO person (name, gender) VALUES ('Carl',   'M');
INSERT INTO person (name, gender) VALUES ('Arthur', 'M');
INSERT INTO person (name, gender, height) VALUES ('Frankie', 'F', 173.8);
--
-- This won't work! Why?
--
INSERT INTO person (name) VALUES ('Chris');

-- SIMPLE QUERIES -------------------------------------------------------------------------------------------

SELECT * FROM person;

SELECT * FROM person WHERE gender = 'F' AND birth IS NULL;   -- All females with missing birth
SELECT * FROM person WHERE birth >= '2002-06-01';            -- All with birth after 1 June 2002

-- Q. Select all males whose height is not NULL.
-- Q. Select all people whose names begin with 'A'.

-- Ordering.
--
SELECT name, birth FROM person ORDER BY birth DESC;

-- Aggregation (https://www.sqlite.org/lang_aggfunc.html)
--
SELECT gender, AVG(height) AS Avgheight, MIN(height) AS Minheight, MAX(height) AS Maxheight
    FROM person
    GROUP BY gender;
--
-- A WHERE clause cannot be applied to the results of aggregation.
--
SELECT gender, COUNT(*) AS population
    FROM person
    GROUP BY gender
    HAVING population > 4;

-- ALTER TABLE ----------------------------------------------------------------------------------------------

-- Add a column to a table.
--
ALTER TABLE person ADD tax_reference CHAR(12);

-- Q. Take a look at the structure of the person table again.

-- UPDATING DATA --------------------------------------------------------------------------------------------

-- Update existing records.
--
UPDATE person SET tax_reference = '250602X783U2' WHERE name = 'Roberta';
UPDATE person SET tax_reference = '241101Y129U0' WHERE name = 'Rudy';
--
-- Q. How could the above statements possibly go wrong? Think about a larger data set.

UPDATE person SET birth = '2001-12-21' WHERE id = 7;
UPDATE person SET birth = '2001-06-16' WHERE name = 'Thomas';

UPDATE person SET job_id = 1;
UPDATE person SET job_id = 4 WHERE name IN ('Andrea', 'Maria');
UPDATE person SET job_id = 2 WHERE id = 4;

SELECT * FROM person;

-- DELETING DATA --------------------------------------------------------------------------------------------

-- Deleting data should be approached with great care. There is no "Are you sure?" prompt.
--
DELETE FROM person WHERE name = 'Frankie';

-- This won't work! Why?
--
DELETE FROM profession WHERE id = 1;

-- SUB-QUERIES AND COMPOUND QUERIES -------------------------------------------------------------------------

-- A Sub-Query is a nested query (one query within another).
--
SELECT * FROM person WHERE job_id IN (SELECT id FROM profession WHERE Description LIKE 'Data%');

-- TABLE JOINS ----------------------------------------------------------------------------------------------

-- Information on FOREIGN KEY support in SQLite: https://www.sqlite.org/foreignkeys.html

-- INNER JOIN
--
SELECT    name, gender, Description AS Job
FROM      person P
JOIN      profession Q
ON
          P.job_id = Q.id;

-- OUTER JOIN
--
SELECT Description, name
FROM    profession P
LEFT JOIN
        person Q
ON
        P.id = Q.job_id;

-- JOIN and Sub-Query
--
SELECT    description, workers
FROM
          (SELECT job_id, COUNT(*) AS workers FROM person GROUP BY job_id) A
INNER JOIN
          profession B
ON
          A.job_id = B.id;

-- DELETE TABLE ---------------------------------------------------------------------------------------------

-- DROP TABLE person;
-- DROP TABLE profession;
