-- DESARROLLO EJERCICIO, ENUNCIADO #1
create database miau;
use miau;

create table catTable(
	id int unsigned unique auto_increment primary key,
    name varchar(100) not null,
    breed varchar(75) not null,
    coloration varchar(30) not null,
    age int unsigned not null,
	sex char(1) not null,
    fav_toy varchar(100)
);

drop table catTable;

insert into catTable(id, name, breed, coloration, age, sex, fav_toy) values
	(1, 'Noemi', 'persa', 'unicolor', 4, 'F', 'provocador'),
    (2, 'Odie', 'Oriental', 'bicolor', 5, 'F', 'provocador'),
    (3, 'Sandy', 'siamesa', 'atigrado', 4, 'F', 'provocador'),
    (4, 'Copito', 'egipcio', 'bicolor', 7, 'F', 'provocador');

select *
	from catTable
    where fav_toy = '';

select * from catTable;


select id, name, breed, coloration, sex, fav_toy
	from catTable
    where breed <> lower("siamesa")
		  and breed <> lower("persa")
          and sex = 'F'
          and fav_toy = "provocador";


-- DESARROLLO EJERCICIO, ENUNCIADO #2
use world;
select * from countrylanguage;
select * from country;


-- Consulta n°1
create table consult1 as
	select *
	from countrylanguage
    where length(Language) = 25;

create table consult2 as
	select Name, Code
	from country
    where Code = 'DEU' or Code = 'SWE'
    order by Name desc;

create table tLanguageCountryLargest as
	select CountryCode, Name, Language, length(Language) as LengthWord
    from consult1, consult2
    order by Name desc
    limit 2;

drop table consult1;
drop table consult2;
drop table tLanguageCountryLargest;
select * from tLanguageCountryLargest;

use world;
select * from country;
select * from countrylanguage;
select * from city;


-- Consulta n°2
select Name, if(IndepYear is null or IndepYear = '', 'N/A', IndepYear) as 'Year Independency'
	from country;


-- Consulta n°3
select Name, IndepYear, 
	if(IndepYear is null or IndepYear = '', 'N/A', 
		if(IndepYear > 1899, "Recién Independizado", "Antiguamente Independizado")) as "State Independency"
	from country;

use world;

select IndepYear
	from country
    where IndepYear is null or IndepYear = '';

-- Primero determinar si predomina los datos null o con información. Esto con el fin de determinar 
-- la mejor petición para hacer la DB más eficiente.

-- Consulta n°4
select concat(format(avg(LifeExpectancy), 1), "%") as 'Promedio nivel de vida África'
	from country
    where Continent = 'Africa';


-- Consulta n°5
create table tLowLifeExpectancy as
	select min(LifeExpectancy) as lowLifeExp
		from country;

select lowLifeExp, Code, Name, LifeExpectancy
	from tLowLifeExpectancy, country
    where LifeExpectancy = lowLifeExp;


-- Consulta n°6
create table tHighLifeExpectancy as
	select max(LifeExpectancy) as highLifeExp
		from country;

select highLifeExp, Code, Name, LifeExpectancy
	from tHighLifeExpectancy, country
    where LifeExpectancy = highLifeExp;


-- Consulta n°7
select *
	from (
		select Code, Name, Continent, IndepYear, GNP, format((GNP / (Population/SurfaceArea)), 2) as riqueza
	from country
    where Continent = 'North America' or Continent = 'South America'
    order by riqueza desc, Name asc
    );

-- Consulta n°8
create table tSecondName as 
	select Code, Name, trim(substr(Name, locate(" ", Name))) as divisionPalabra
		from country
        where Continent = 'Europe';

select *, if(substr(divisionPalabra, 1,  locate(" ", divisionPalabra)) = '', divisionPalabra, substr(divisionPalabra, 1,  locate(" ", divisionPalabra))) as SECOND_NAME
	from tSecondName
    where divisionPalabra <> ""
    order by SECOND_NAME asc;


-- Consulta n°9
create table tCountryLetterA as
	select Name, Continent, length(Name) - length(replace(lower(Name), 'a', '')) as countLetterA
		from country
        where Continent = 'South America' or Continent = 'North America';

select *
	from tCountryLetterA
    where countLetterA <> 0
    order by countLetterA desc;

-- Consulta n°10
create table tFilterWords as
	select Code, Name, if(trim(locate(" ", Name)) <> 0, "", Name) as test
		from country;

select * 
	from tFilterWords
    where test <> "" and right(lower(test), 3) = 'bia';




-- DESARROLLO EJERCICIO, ENUNCIADO #3
create table orchestras(
	id int unsigned primary key,
    name varchar(32) not null,
    rating decimal unsigned not null,
    city_origin varchar(32) not null,
    country_origin varchar(32) not null,
    year int unsigned not null
);

create table concerts(
	id int unsigned primary key,
    city varchar(64) not null,
    country varchar(32) not null,
    year int unsigned not null,
    rating decimal unsigned not null,
    orchestra_id int unsigned not null,
    foreign key(orchestra_id) references orchestras(id)
);

create table members(
	id int unsigned primary key,
    name varchar(64) not null,
    position varchar(32) not null,
    experience int unsigned not null,
    wage int unsigned not null,
    orchestra_id int unsigned not null,
    foreign key(orchestra_id) references orchestras(id)
);

select * from orchestras;
drop table orchestras;

select * from concerts;
drop table concerts;

select * from members;
drop table members;

insert into orchestras(id, name, rating, city_origin, country_origin, year) values
	(1, 'Los musicólogos', 9.3, 'Floridablanca', 'Colombia', 2002),
    (2, 'Dragonfly', 8.3, 'Cali', 'Colombia', 2008),
    (3, 'ACME', 6.9, 'Buenos Aires', 'Argentina', 1985),
    (4, 'Valpalhueco', 8.8, 'Valdivia', 'Chile', '2010'),
    (5, 'Orquesta de Cámara', 7.1, 'Quito', 'Ecuador', 1992),
    (6, 'Los Santos Musicales', 7.4, 'Ciudad de México', 'México', 2017),
    (7, 'Los Catchaponeadores', 10.0, 'Piedecuesta', 'Colombia', 1983);
 
insert into concerts(id, city, country, year, rating, orchestra_id) values
	(415, 'Buenos Aires', 'Argentina', 2013, 6.1, 3),
    (289, 'gerger', 'Chile', 2021, 6.8, 4),
    (741, 'Quito', 'Ecuador', 1994, 8.1, 5),
    (108, 'Floridablanca', 'Colombia', 2022, 8.4, 1),
    (325, 'dfsgfsdg de sdfsdgbs', 'México', 2024, 4.7, 6),
    (846, 'Caetferglsgsgfds', 'Colombia', 2013, 8.2, 2);

insert into members(id, name, position, experience, wage, orchestra_id) values
    (51, 'Licenciado Romero', 'Guitarrista', 7, 800000, 7),
    (19, 'Licenciado Cabrera', 'Pianista', 15, 1200000, 7),
    (85, 'Licenciado Díaz', 'Guitarrista', 11, 950000, 7),
    (08, 'Licenciado Zapata', 'Violinista', 8, 1200500, 7),
    (01, 'Licenciado Ordoñez', 'Bajista', 25, 1500000, 7),
    (98, 'Licenciado Fuentes', 'Baterísta', 20, 2550000, 7),
    (41, 'Licenciado Aguilar', 'Violinista', 7, 1050000, 7);



-- Consulta #1:
select *
	from orchestras O
    inner join concerts C on O.id = C.orchestra_id
    where O.city_origin = C.city and C.year = 2013;
    
-- Consulta #2
select name, position
	from members M
    where M.orchestra_id in (
		select ORC.id from orchestras ORC where rating >= 8
	) and M.experience > 10;

-- Consulta #3:
# El primer miembro de la orquesta es el que determinará el id de la misma, esto 
# permitirá validar que todos los miembros pertenezcan a la misma agrupación.
select *
	from members MORC -- MORC = Members Orchestras
    where (select M.orchestra_id from members M limit 1) = MORC.orchestra_id 
		and MORC.wage > (select avg(M.wage) from members M where lower(M.position) = 'violinista');

-- Consulta #4:
select *
	from orchestras ORC
    where ORC.id between (
		select id
			from orchestras
            where lower(name) = 'orquesta de cámara'
    ) and (select max(id) from orchestras) and rating > 7.5;