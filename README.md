
To download MySQL server Please follow below link :

1. Windows

https://dev.mysql.com/downloads/file/?id=480824

2. MacOS

https://dev.mysql.com/downloads/file/?id=480551


If you face issues just make a connection to Amazon RDS using MySQL workbench


Hostname: sqlworkshop.cltt6gz5c47c.us-east-1.rds.amazonaws.com

Username : mysqldb

Password: mysql123






### SQL
SQL Queries and Information

## 1. Getting Information about a database

### show all databases
show databases; 

### invoke a specific database (world)
use world;

### list tables in this database
show tables;

### describe a table
describe city;

### show columns from table city
show columns from city;

### show create table 
show create table city;


## 2. Working With SELECT CLAUSE 

### All countries
SELECT * FROM country;

### this won't work - Name of tables, columns, database case sensitive 
use World;
SELECT * FROM Country;


## Total number of countries 
SELECT COUNT(*) FROM country;

### Using limit clause to select 10 rows from table
SELECT * FROM country limit 10;

### Selecting few columns from table 
SELECT Name, LifeExpectancy FROM country;

SELECT Name, CountryCode, Population from city;

### Using alias for columns AS
SELECT Name AS Country, Code AS ISO, Region, Population AS Pop FROM country;


### Using basic operations in Select clause
SELECT Name AS Country, Code AS ISO, Region, Population / 1000 AS 'Population (1000s)' FROM country;


## 3. Working With Order By 

### All countries in alphabetical order
SELECT * FROM country ORDER BY Name;

### List the first 5 countries in alphabetical order
SELECT * FROM country ORDER BY Name limit 5;

### Country name and life expectancy in descending order
SELECT Name, LifeExpectancy AS 'Life Expectancy' FROM country ORDER BY LifeExpectancy DESC;

### Country Name, ISO code, region and population ordered by ISO Code
SELECT Name AS Country, Code AS ISO, Region, Population FROM country ORDER BY Code;

### City name, country code and population ordered by city name
SELECT Name, CountryCode, Population from city ORDER BY Name;

### Country name, continent and region and order by continent, region and name
SELECT Name, Continent, Region FROM country ORDER BY Continent DESC, Region, Name;


## 4. Working with Where clause 

### List of countries with population greater than 100 million
SELECT Name, Continent, Population FROM country WHERE Population > 100000000;

### List of countries that have population less than 100,000
SELECT Name, Continent, Population FROM country WHERE Population < 100000;


### List official languages of China
SELECT CountryCode,Language FROM countrylanguage WHERE Countrycode = 'CHN';


## 5. Updating the values in column

### change Workbench Preference /SQL editor and then uncheck safe updates.  Reconnect to Workbench
select * from country;

### change country name
UPDATE country SET name = 'China Republic' WHERE Code = 'CHN';

### SET SQL_SAFE_UPDATES = 0;

select * from country where Code='CHN';

### Update multiple columns
UPDATE country SET name = 'People Republic of China', IndepYear=1900 WHERE Code = 'CHN';

select * from country where Code='CHN';



## 6. Working With Operators (Like and IN)

### Country names that start with United ##
SELECT Name, Continent, Population FROM country WHERE Name LIKE 'United%' ORDER BY Name;

### Country names that end with Island ##
SELECT Name, Continent, Population FROM country WHERE Name LIKE '%island' ORDER BY Name;

### All countries that are in Africa and North America continents ## 
SELECT Name, Continent FROM country WHERE Continent IN ( 'Africa', 'North America' );

## https://www.w3schools.com/sql/sql_wildcards.asp



## 7. Working With JOINS

### List all countries and corresponding cities
SELECT co.Name as Country, c.Name as City
FROM country co, city c
WHERE co.Code  = c.CountryCode 
ORDER BY Country, city;

SELECT co.Name as Country, c.Name as City
FROM country co
	INNER JOIN city c on co.Code = c.CountryCode
ORDER BY Country, City;


SELECT co.Code,co.Name as Country, c.Name as City
FROM country co
	LEFT JOIN city c on co.Code = c.CountryCode
ORDER BY Country, City;


SELECT co.Code,co.Name as Country, c.Name as City
FROM city c 
	RIGHT JOIN country co  on co.Code = c.CountryCode
ORDER BY Country, City;


select * from country where Code='ATA';

## 8. Working With WHERE, GROUP BY, HAVING

### select continent and countries 
select Continent, Name from country;

### find number of countries in each Continent
SELECT 
    Continent, COUNT(*) AS 'No. of Countries'
FROM
    country
GROUP BY Continent;

### find number of countries in each Continent and Region
SELECT 
    Continent, Region, COUNT(*) AS 'No. of Countries'
FROM
    country
GROUP BY Continent , Region;

### find number of countries in each Continent and Region where Region Name ends in America
SELECT 
    Continent, Region, COUNT(*) AS 'No. of Countries'
FROM
    country
WHERE
    Region LIKE '%America'
GROUP BY Continent , Region;

#### can't do this
select Continent, Region, count(*) AS 'No. of Countries' from country where Region like '%America' group by Continent,Region having 'No. of Countries'>5;

### find number of countries in each Continent and Region where Region Name ends in America and number of countries greater than 5
SELECT 
    Continent, Region, COUNT(*) AS 'No. of Countries'
FROM
    country
WHERE
    Region LIKE '%America'
GROUP BY Continent , Region
HAVING COUNT(*) > 5;

## 9. Deleting

### Delete a record
DELETE FROM country WHERE Name = 'China Republic';

### Query the country table after the delete 
SELECT * FROM country;


## 10. Drop table 

#### Drop the city table 
DROP TABLE city;
