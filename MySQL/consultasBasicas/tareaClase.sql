use world;

SELECT * FROM country;

SELECT * FROM city;

SELECT * FROM countrylanguage;


-- 1. Mostrar el país con mayor población
SELECT Name, Population FROM country ORDER BY Population DESC LIMIT 1;


-- 2. Mostrar las ciudades con población menor a 1 millón de habitantes. El listado debe estar ordenado por población de menor a mayor y si hay dos ciudades
-- con la misma población, mostrarlas en orden alfabético.
SELECT Name, Population
	FROM city
    WHERE Population < 1000000
    ORDER BY Population ASC, Name ASC
    LIMIT 10000;


-- 3. Mostrar los 3 países con mayor población de sur américa
SELECT Name, Population, region
	FROM country
    WHERE region = "South America"
    ORDER BY Population DESC
    LIMIT 3;


-- 4. Mostrar los idiomas no oficiales hablados en Colombia. Los idiomas debe estar ordenados ascendentemente por el porcentaje de habla.
SELECT *
	FROM countrylanguage
    WHERE CountryCode = 'COL' and  IsOfficial = 'F'
    ORDER BY Percentage ASC, Language DESC;
	

-- 5. Mostrar los 5 países de Europa con menor expectativa de vida. Mostrar el listado descendentemente por la expectativa de vida y el nombre del país.
SELECT * FROM (SELECT Name, Continent, LifeExpectancy
	FROM country
    WHERE Continent = 'Europe' and LifeExpectancy is Not Null
    ORDER BY LifeExpectancy ASC, Name DESC
    LIMIT 5) country ORDER BY LifeExpectancy DESC;
    
    