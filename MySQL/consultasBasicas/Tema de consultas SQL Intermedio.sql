create database prueba;
use prueba;

-- Creación de la tabla Vehículo
create table vehiculo(
	vhc_id int primary key,
    marca varchar(50) not null,
    modelo varchar(50) not null,
    matricula varchar(10) not null,
    anioFabricacion int not null
);

-- Creación de la tabla Empleado
create table empleado(
	e_id int primary key,
    apellidos varchar(50) not null,
    nombre varchar(50) not null,
    vhc_id int,
    foreign key (vhc_id) references vehiculo(vhc_id)
);

-- Inserción de datos en la tabla Vehículo
insert into vehiculo(vhc_id, marca, modelo, matricula, anioFabricacion) values
	(1, 'VW', 'Caddy', 'C 0000 YZ', 2016),
    (2, 'Opel', 'Astra', 'C 001 YZ', 2010),
    (3, 'BMW', 'X6', 'C 0002 YZ', 2017),
    (4, 'Porsche', 'Boxster', 'C 0003 YZ', 2018);

-- Inserción de datos en la tabla Empleado
insert into empleado(e_id, apellidos, nombre, vhc_id) values
	(1, 'García Hurtado', 'Macarena', 3),
    (2, 'Ocaña Martínez', 'Francisco', 1),
    (3, 'Gutiérrez Doblado', 'Elena', 1),
    (4, 'Hernández Soria', 'Manuela', 2),
    (5, 'Oliva Cansino', 'Andrea', NULL);


-- CONSULTAS SQL

-- 1. Muestre todos los empleados con sus vehículos.
select *
	from empleado
    left join vehiculo on empleado.vhc_id = vehiculo.vhc_id;

-- 2. Muestre todos los empleados que no tienen un vehículo.
select *
	from empleado
    left join vehiculo on empleado.vhc_id = vehiculo.vhc_id
    where empleado.vhc_id is not NULL
    order by e_id asc;


-- 3. Muestre todos los empleados con los vehículos que tengan asgignados.
-- Si hay un vehículo que no haya sido asignado, de igua manera mostrarlo.



-- 4. ¿Cuál es el conjunto completo de empleados y vehículos, incluyendo aquellos 
-- empleados sin vehículo asignado y aquellos vehículos sin un empleado asociado?

-- Simulación de FULL JOIN con LEFT JOIN y RIGHT JOIN combinados con UNION
select E.*, V.*
	from empleado E
    left join vehiculo V on E.vhc_id = V.vhc_id

union

select E.*, V.*
	from empleado E
    right join vehiculo V on E.vhc_id = V.vhc_id;

-- WHERE E.vhc_id IS NULL;
-- Para evitar duplicados, se puede excluir las filas que ya aparecieron en el LEFT JOIN.



-- CONSULTAS ANIDADAS
use world;
select * from countrylanguage;

select Name, Population
	from country
    where Population > (select avg(Population) from country);


SELECT AVG(Population)
	FROM (
		SELECT Population
        FROM city
        WHERE CountryCode = "VEN"
    ) AS CiudadesPais1;


SELECT Name, (
	SELECT COUNT(*)
		FROM city C
        WHERE C.CountryCode = P.Code
) AS NumeroCiudades
	FROM country P
    WHERE P.Continent = "North America" or P.Continent = "South America"
    ORDER BY NumeroCiudades DESC;


SELECT C1.Name, C1.Population
	FROM city AS C1
    INNER JOIN country P ON C1.CountryCode = P.Code
    WHERE (P.Continent = "North America" or P.Continent = "South America") AND
		   C1.Population > (
				SELECT AVG(C2.Population)
					FROM city AS C2
                    WHERE C2.CountryCode = C1.CountryCode
           );