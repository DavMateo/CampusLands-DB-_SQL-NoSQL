-- --------------------------------------
-- SESIÓN 3 - GESTIÓN DE DATOS CON SQL --
-- --------------------------------------


-- CREAR TABLAS TEMPORALES
/*
	CREATE TABLE nueva_tabla
		AS
		SELECT columna1, columna2, ...
        FROM tabla_origen
        WHERE condition;
*/


use world;

CREATE TABLE expVida as
	select name, lifeExpectancy
    FROM country
    WHERE Continent = 'Europe' and LifeExpectancy is not null
    ORDER BY LifeExpectancy ASC
    LIMIT 5;



-- EJERCICIO #1
-- Crea una tabla temporal llamada empleados_departamentos_x la cual
-- contendrá la información de los empleados (nombre y salario) de la tabla empleados. Estos empleados 
-- trabajan en el Departamento X y ganan más de $1.200.000.
CREATE TABLE empleados_departamentos_x as
	SELECT nombre, salario
    FROM empleados
    WHERE departamento = 'X' and salario > 1200000;


-- EJERCICIO #2
-- "Crear una nueva tabla llamada tempPais que contenga las columnas 'nombre' y 'población', seleccionando
-- los registros de la tabla 'country' donde la población sea igual o inferior a 100,000,000. La tabla
-- se encuentra en la base de datos world.
CREATE TABLE tempPais AS 
	SELECT name, population
    FROM country
    WHERE population <= 100000000;

describe tempPais;




-- RELACIONES ENTRE TABLAS
-- Relación de Uno a Muchos

CREATE SCHEMA library;

use library;

-- Crear tabla libro
create table book(
	id int primary key,
    title varchar(100),
    author varchar(100)
);

-- Crear la tabla préstamos
create table loan(
	id int primary key,
    id_book int,
    loanDate date,
    returnDate date,
    foreign key(id_book) references book(id)
);

-- RELACIÓN DE MUCHOS A MUCHOS
-- Estudiante e Inscripción a cursos (N:M)
create table student(
	id int primary key,
    name varchar(100)
);

create table course(
	id int primary key,
    name varchar(100),
    description text
);

create table registration(
	id_student int,
    id_course int,
    registrationDate date,
    primary key(id_student, id_course),
    foreign key(id_student) references student(id),
    foreign key(id_course) references course(id)
);



create schema exerciseRelation;

-- EJERCICIO RELACIONALES N°1
create table country(
	id int primary key,
    name varchar(20),
    mainland varchar(50),
    population int
);

create table city(
	id int primary key,
    name varchar(20),
    id_country int,
    foreign key(id_country) references country(id)
);


-- EJERCICIO RELACIONES N°2
create table language(
	id int primary key,
    language varchar(50)
);

create table country(
	id int primary key,
    name varchar(20),
    mainland varchar(50),
    population int
);

create table language_country(
	id_language int,
    id_country int,
    is_official tinyint(1),
    primary key(id_language, id_country),
    foreign key(id_language) references language(id),
    foreign key(id_country) references country(id)
);



-- REVISIÓN DE ESTRUCTURAS DE UNA TABLA

-- Comando DESCRIBE o desc

-- Comando SHOW COLUMNS FROM
use mundo;
show columns from tpais;

-- Comando: SHOW CREATE TABLE --> MUestra la estructura de como se creó la tabla.
use library;
show create table registration;

-- Comando: SHOW TABLE STATUS --> Información general de la tabla
show table status like "registration";

-- Comando: INFORMATION_SCHEMA.TABLES e INFORMATION_SCHEMA.COLUMNS
select *
	from INFORMATION_SCHEMA.COLUMNS
    where table_name = "registration";

select *
	from information_schema.tables
    where table_schema = "biblioteca";


-- Funciones y Comandos en Campos en MySQL

-- 1. CONCAT: Concatena dos o más cadenas de texto.
use world;

select concat(name, " - ", region) as Ubicacion
	from country
    limit 5;


-- 2. UPPER: Convierte una cadena a mayúsculas.
select upper(concat(name, " ", region)) as Ubicacion
	from country
    limit 5;


-- 3. LOWER: Convierte una cadena a minúsculas.
select lower(concat(name, " ", region)) as Ubicacion
	from country
    limit 5;


-- 4. LENGTH: Devuelve la longitud de una cadena.
select (concat(name, " ", region)) as Ubicacion, length(concat(name, " ", region)) as Largo
	from country
    order by Largo 
    limit 5;



-- EJERCICIO 1: Muestren un listado con los 3 países con el nombre más largo, ordenados del más largo al menor.
select concat(name, " ", region) as Ubicacion, length(concat(name, " ", region)) as longitud, region
	from country
    order by longitud desc
    limit 3;


-- 5. SUBSTRING() Extrae una parte de una cadena.
select substring(concat(name, " ", region), 1, 3) as "Inicial Ubicación"
	from country
    limit 5;


-- 6. LOCATE: Encuentra la posición de una subcadena.
select substring(concat(name, " ", region), 1, 3) as "Sigla de la posición",
	   locate('g', substring(concat(name, " ", region), 1, 3)) as POS_G
    from country
    limit 5;



-- EJERCICIO 2: Construya un listado con el primer nombre de los países con nombre compuestos. Ordene el listado por nombre del país.
select substring(concat(name, " ", region), 1, locate(' ', name)) as "Primer nombre", name as Pais, locate(' ', name) as "Posición Compuesto"
	from country
    where locate(' ', name) > 0
    order by name asc;
    
    

-- 7. TRIM: Quita los espacios al principio y al final (existe el RTRIM() a la derecha, LTRIM() a la izquierda)
select TRIM(substr(name, 1, locate(' ', name))) as Primer_Nombre,
	name as pais,
    locate(' ', name) as compuesto,
    length(substr(name, 1, locate(' ', name))) as "SIN TRIM",
    length(trim(substr(name, 1, locate(' ', name)))) as "CON TRIM";



-- 9. REPLACE: Reemplaza una subcadena por otra cadena.
use world;

select name
	from country
    where region = "South America";

select name, replace(name, "Gu", "YUL") as REEMPLAZO
	from country
    where region = "South America";

-- EJERCICIO 3: Mostrar el listado de los países en los cuales es posible hacer el reemplazo de "GU" por "YUL"
select name, replace(name, "Gu", "YUL") as REEMPLAZO
	from country
    where continent = "South America" and name <> replace(name, "Gu", "YUL");


-- REPEAT: Repite una cadena un número especificado de veces
select tabla_de_dots('Hola Mundo', 1, ' mi ');


-- MAX: Devuelve el valor máximo de una columna
select max(lifeexpectancy) from country;

-- MIN: Devuelve el valor mínimo de una columna
select min(lifeexpectancy) from country;



-- DATE_FORMAT(): Formatea una fecha de acuerdo con el formato especificado
select date_format(now(), '%Y-%m-%d') as fecha_col;

-- NOW(): Devuelve la fecha y hora actuales
select date_format(now(), '%d/%m/%Y') as 'fecha actual';



-- CONDICIONAL IF: IF(condición, valor_si_verdadero, valor_si_falso)
select name, format(population, 0) as población,
		if(population < 20000000, "Pais desnutrido", if(population < 40000000, "Pais en forma", "Pais con sobrepeso")) as Estado
	from country
    where region = "South America"
    order by population desc;


-- EJERCICIO 4: Calcular la densidad de población de los países de América. Si la densidad de población es mayor al 60% entonces mostrar 
-- que está super-poblado, si está entre [30 y 60)% mostrar que está poblado, si está entre [10, 30)% que está poco poblado y si es 
-- menor del 10% mostrar que está despoblado.alter
select name, population, surfacearea as area, (population/surfacearea) as density, if((population/surfacearea) > 30, "Sobrepoblado",
		if((population/surfacearea) > 20 and (population/surfacearea) <= 30, "Poblado",
        if ((population/surfacearea) > 10 and (population/surfacearea) <= 20, "Poco poblado", "Despoblado")) ) as status, region
	from country
    where continent = "North America" or continent = "South America"
    order by density desc;
    
    
    SELECT * FROM countrylanguage;
    
/*    select CountryCode, Language
 		if()
    from countrylanguage
*/





-- SEMANA NUEVA, EJERCICIOS NUEVOS :D
use world;

select 
	if (locate(" ", seg_nombre) = 0,
		seg_nombre,
        substr(seg_nombre, 1, locate(" ", seg_nombre)-1) ) as segundo_nombre
	from(
		select name,
			locate(" ", name) as pos1,
			substr(name, locate(" ", name) + 1) as seg_nombre
            from world.country
            where Continent = "Europe" and locate(" ", name) > 0) as S;


-- OPERACIONES DE COMBINACIÓN DE TABLAS (JOINS)
use world;

-- Producirá 974881 filas. Eso es un producto cruz, es decir, se revuelven todos con todos.
select C.code, C.name, D.id, D.name, D.countrycode
	from country as C, city as D
    limit 100000000;


-- Ciudades de Colombia (inner join: solo toma las relaciones entre A y B)
select P.name, C.name
	from country as P
		inner join city as C on P.code = C.countrycode
        where P.name = "Colombia";

-- Ciudades de Colombia (Left Join: Todos los elementos del conjunto A y donde no exista 
-- relación con B entonces es NULL.

select L.language, P.name
	from countrylanguage as L
    left join country as P on L.countrycode = P.code
	where L.language = "Quiché";

-- Ciudades de Colombia (Right Join: Todos los elementos del conjunto B y donde no exista
-- relación con A, entonces es NULL.
insert into countrylanguage(countrycode, language, isofficial, percentage) values("ZZZ", "Marciano", "T", 100);

select P.name, C.name
	from city as C
    right join country as P on C.countrycode = P.code
    where P.name = "Colombia";