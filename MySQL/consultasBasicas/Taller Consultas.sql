use world;
SELECT * FROM country;
SELECT * FROM city limit 10000000;
SELECT * FROM countrylanguage;


/*
CREATE INDEX index_name
		ON table_name(column1, column2, ...);
*/


-- Consulta n°1
select CountryCode, Name
	from city
    where CountryCode = 'COL';


-- Consulta n°2
-- Las subconsultas crean tablas en memoria las cuales se comportan como tal. Tener cuidado
-- de realizar subconsultas repetitivas o poco relevantes para ahorrar memoria y ganar agilidad.
-- El objetivo es tener eficiencia en las consultas de MySQL.

create table tPopulationCity as
	select *
		from (
			select Name as cityName, Population, CountryCode
            from city
            order by Population desc
        ) as ciudades
        
		inner join (
			select Code, Name as CountryName, Continent
				from country
        ) as countryFilter on ciudades.CountryCode = countryFilter.Code
        
        where Continent <> 'Oceania' and Continent <> 'Antarctica'
        limit 4025;

select *
	from (
		select *
		from (
			select Code, CountryName, CityName, Continent, format(Population, 0) as PopulationCity
			from tPopulationCity
			where Continent = 'South America' or Continent = 'North America'
			order by Population desc
			limit 5
		) as PopulationCitiesAmerica

		union

		select *
			from (
				select Code, CountryName, CityName, Continent, format(Population, 0) as PopulationCity
				from tPopulationCity
				where Continent = 'Europe'
				order by Population desc
				limit 5
			) as PopulationCitiesEurope

		union

		select *
			from (
				select Code, CountryName, CityName, Continent, format(Population, 0) as PopulationCity
				from tPopulationCity
				where Continent = 'Asia'
				order by Population desc
				limit 5
			) as PopulationCitiesAsia

		union

		select * 
			from (
				select Code, CountryName, CityName, Continent, format(Population, 0) as PopulationCity
				from tPopulationCity
				where Continent = 'Africa'
				order by Population desc
				limit 5
			) as PopulationCitiesAfrica
    ) as orderCitiesPopulation
    order by Continent asc, CityName desc;
    
use world;


-- Consulta n°3
select CodeCountry, NameCountry, Language
	from (
		select Code as CodeCountry, Name as NameCountry, Continent
		from country
        where Continent = 'Africa'
    ) as CountryAfrica
    inner join (
		select *
		from countrylanguage
        inner join country on countrylanguage.CountryCode = country.Code
        where IsOfficial = 'T'
    ) as CountryAfricaLanguage on CountryAfrica.CodeCountry = CountryAfricaLanguage.CountryCode
    order by Language asc;

-- Consulta n°4
# La función "distinct" permite dejar solo lo que es distinto entre dos tablas o consulta. Solo puede tener un 
# argumento a la vez.
select concat(CountryCode, ' - Santander  ') as CountryRegion, Language
	from countrylanguage
    where CountryCode = 'COL' and IsOfficial = 'F';

-- Consulta n°5
select CF.Code CodeCountry, CF.Name NameCountry, CF.Population
	from (select C.Code, C.Name, C.Population from country C) as CF
    left join (
		select distinct CL.CountryCode
			from countrylanguage CL
            where IsOfficial = 'T'
    ) vCCT on CF.Code = vCCT.CountryCode
    where vCCT.CountryCode is null
    order by CF.Code asc;
    
-- ejercicio 6
select C.Continent, CL.CountryCode, C.Name CountryName, CI.ID, 
CI.Name CityName, CL.Language, CI.Population, C.LocalName
	from countrylanguage CL
    inner join country C on CL.CountryCode = C.Code
    inner join city CI on CL.CountryCode = CI.CountryCode
    where Continent = 'Asia' and Language = 'English'
    order by C.Population desc;


-- ------------------------ --
-- DESARROLLO SEGUNDA PARTE --
-- ------------------------ --
DROP DATABASE IF EXISTS tienda;
CREATE DATABASE tienda CHARACTER SET utf8mb4;
USE tienda;

CREATE TABLE fabricante(
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE producto(
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DOUBLE NOT NULL,
    id_fabricante INT UNSIGNED NOT NULL,
    FOREIGN KEY(id_fabricante) REFERENCES fabricante(id)
);

INSERT INTO fabricante VALUES(1, 'Asus');
INSERT INTO fabricante VALUES(2, 'Lenovo');
INSERT INTO fabricante VALUES(3, 'Hewlett-Packard');
INSERT INTO fabricante VALUES(4, 'Samsung');
INSERT INTO fabricante VALUES(5, 'Seagate');
INSERT INTO fabricante VALUES(6, 'Crucial');
INSERT INTO fabricante VALUES(7, 'Gigabyte');
INSERT INTO fabricante VALUES(8, 'Huawei');
INSERT INTO fabricante VALUES(9, 'Xiaomi');
INSERT INTO producto VALUES(1, 'Disco duro SATA3 1TB', 86.99, 5);
INSERT INTO producto VALUES(2, 'Memoria RAM DDR4 8GB', 120, 6);
INSERT INTO producto VALUES(3, 'Disco SSD 1 TB', 150.99, 4);
INSERT INTO producto VALUES(4, 'GeForce GTX 1050Ti', 185, 7);
INSERT INTO producto VALUES(5, 'GeForce GTX 1080 Xtreme', 755, 6);
INSERT INTO producto VALUES(6, 'Monitor 24 LED Full HD', 202, 1);
INSERT INTO producto VALUES(7, 'Monitor 27 LED Full HD', 245.99, 1);
INSERT INTO producto VALUES(8, 'Portátil Yoga 520', 559, 2);
INSERT INTO producto VALUES(9, 'Portátil Ideapd 320', 444, 2);
INSERT INTO producto VALUES(10, 'Impresora HP Deskjet 3720', 59.99, 3);
INSERT INTO producto VALUES(11, 'Impresora HP Laserjet Pro M26nw', 180, 3);

select * from producto;
select * from fabricante;


-- Consulta n°1
select P.id idProducto, P.nombre, F.nombre, P.precio
	from producto P
    inner join fabricante F on P.id_fabricante = F.id;

-- Consulta n°2
select P.id idProducto, P.nombre nombreProducto, F.nombre nombreFabricante, P.precio
	from fabricante F
    inner join producto P on F.id = P.id_fabricante
    order by F.nombre;

-- Consulta n°3
select P.id idProducto, P.nombre NombreProducto, F.id idFabricante, F.nombre nombreFabricante
	from fabricante F
    inner join producto P on F.id = P.id_fabricante;

-- Consulta n°4
select P.nombre nombreProducto, P.precio, F.nombre marca
	from fabricante F
    inner join producto P on F.id = P.id_fabricante
    order by P.precio asc
    limit 1;

-- Consulta n°5
select P.nombre nombreProducto, P.precio, F.nombre marca
	from fabricante F
    inner join producto P on F.id = P.id_fabricante
    order by P.precio desc
    limit 1;

-- Consulta n°6
select P.id, P.nombre nombreProducto, F.nombre nombreFabricante, concat("$", format(P.precio, 2)) precio
	from fabricante F
    inner join producto P on F.id = P.id_fabricante
    where lower(F.nombre) = 'lenovo';

-- Consulta n°7
select P.id, P.nombre nombreProducto, F.nombre nombreFabricante, concat(format(P.precio, 2), "€") precio
	from fabricante F
    inner join producto P on F.id = P.id_fabricante
    where lower(F.nombre) = 'crucial' and P.precio > 200;

-- Consulta n°8
select P.id, P.nombre nombreProducto, F.nombre nombreFabricante, concat('$', format(P.precio, 2)) precio
	from fabricante F
    inner join producto P on F.id = P.id_fabricante
    where lower(F.nombre) = 'asus' or lower(F.nombre) = 'hewlett-packard' or lower(F.nombre) = 'seagate';

-- Consulta n°9
select P.id, P.nombre nombreProducto, F.nombre nombreFabricante, concat('$', format(P.precio, 2)) precio
	from fabricante F
    inner join producto P on F.id = P.id_fabricante
    where lower(F.nombre) in ('asus', 'hewlett-packard', 'seagate');

-- Consulta n°10
select P.nombre nombreProducto, F.nombre marca, concat('$', format(P.precio, 2)) precio
	from fabricante F
    inner join producto P on F.id = P.id_fabricante
    where right(lower(F.nombre), 1) = 'e';

-- Consulta n°11
select P.nombre nombreProducto, F.nombre marca, concat('$', format(P.precio, 2)) precio
	from fabricante F
    inner join producto P on F.id = P.id_fabricante
    where locate('w', lower(F.nombre));

-- Consulta n°12
select P.nombre producto, F.nombre marca, concat(format(P.precio, 2), '€') precio
	from fabricante F
    inner join producto P on F.id = P.id_fabricante
    where P.precio >= 180
    order by P.precio desc, P.nombre asc;

-- Consulta n°13
select distinct F.id, F.nombre
	from fabricante F
    left join producto P on F.id = P.id_fabricante
    where P.id_fabricante is not null;

-- Consulta n°14
select F.id, F.nombre marca, P.nombre producto
	from fabricante F
    left join producto P on F.id = P.id_fabricante;

-- Consulta n°15
select F.id, F.nombre marca, P.nombre producto,
		if(P.precio is null, '$0', concat(format(P.precio, 2), '$')) precio
	from fabricante F
    left join producto P on F.id = P.id_fabricante
    where P.id_fabricante is null;

-- Consulta n° 16
# Pregunta teórica :D

-- Consulta n°17
select P.id, P.nombre producto, F.nombre marca, concat('$', format(P.precio, 2)) precio
	from fabricante F
    right join producto P on F.id = P.id_fabricante
    where lower(F.nombre) = 'lenovo';

-- Consulta n°18
create view fabricanteProducto as
	select P.id_fabricante, F.nombre marca, P.id idProducto, P.nombre producto, concat('$', format(P.precio, 2)) precio
		from fabricante F
        right join producto P on F.id = P.id_fabricante;
        
-- ------------------------------------------------------- --
--  /* consulta 18                                         --
-- select F.nombre, P.nombre, P.precio                     --
--     from producto as P                                  --
--     left join fabricante F on F.id = P.id_fabricante    --
--     where P.precio >= 559 or F.nombre != "Lenovo"       --
--     order by P.precio desc                              --
--     limit 2;                                            --
-- */                                                      --
-- ------------------------------------------------------- --


select *
	from fabricanteProducto
    where (
		select precio
			from fabricanteProducto
            where lower(marca) = 'lenovo'
            order by precio desc
            limit 1
    ) = precio;

-- Consulta n°19
select P.nombre producto
	from fabricante F
    inner join producto P on F.id = P.id_fabricante
    where lower(F.nombre) = 'lenovo'
    order by precio desc
    limit 1;

-- Consulta n°20
select P.nombre producto
	from fabricante F
    inner join producto P on F.id = P.id_fabricante
    where lower(F.nombre) = 'hewlett-packard'
    order by precio asc
    limit 1;

-- Consulta n°21
# Reutilizando la tabla creada en la consulta n°18
select *
	from fabricanteProducto
    where format(substr(precio, 2), 0) + 0 >= (
		select format(substr(precio, 2), 0)
			from fabricanteProducto
            where lower(marca) = 'lenovo'
            order by precio desc
            limit 1
    );
        
-- Consulta n°22
select *
	from fabricanteProducto
    where substr(precio, 2) > (
		select avg(substr(precio, 2))
        from fabricanteProducto
        where lower(marca) = 'asus'
    );