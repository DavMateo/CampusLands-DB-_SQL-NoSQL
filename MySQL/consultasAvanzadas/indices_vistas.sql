-- ÍNDICES EN MYSQL
/*
	CREATE INDEX index_name
		ON table_name(column1, column2, ...);
*/


-- Índices Simples: Buscan optimizar búsquedas en UNA sola columna.
use world;
create index idx_name on country(name);


-- Borrar índice
drop index idx_name on country;

-- Índice único sobre el nombre del País


/* Índice para buscar por texto
 CREATE FULLTEXT INDEX idx_article_content ON articles(content); */
 

create view view_PopulationCity as
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
        
        where Continent <> 'Oceania' and Continent <> 'Antarctica';

select * from view_PopulationCity;


select *
	from (
		select *
		from (
			select Code, CountryName, CityName, Continent, format(Population, 0) as PopulationCity
			from view_PopulationCity
			where Continent = 'South America' or Continent = 'North America'
			order by Population desc
			limit 5
		) as PopulationCitiesAmerica

		union

		select *
			from (
				select Code, CountryName, CityName, Continent, format(Population, 0) as PopulationCity
				from view_PopulationCity
				where Continent = 'Europe'
				order by Population desc
				limit 5
			) as PopulationCitiesEurope

		union

		select *
			from (
				select Code, CountryName, CityName, Continent, format(Population, 0) as PopulationCity
				from view_PopulationCity
				where Continent = 'Asia'
				order by Population desc
				limit 5
			) as PopulationCitiesAsia

		union

		select * 
			from (
				select Code, CountryName, CityName, Continent, format(Population, 0) as PopulationCity
				from view_PopulationCity
				where Continent = 'Africa'
				order by Population desc
				limit 5
			) as PopulationCitiesAfrica
    ) as orderCitiesPopulation
    order by Continent asc, CityName desc;
    
    set @continente := "Africa";

	create or replace view PopulationCitiesContinent as
		select * 
			from (
				select Code, CountryName, CityName, Continent, format(Population, 0) as PopulationCity
				from view_PopulationCity
				where Continent = "Asia"
				order by Population desc
				limit 5
			) as test;
	
    select * from PopulationCitiesContinent;

-- Sintaxis para cambiar una vista
/*
	CREATE OR REPLACE VIEW nombre_vista AS
		SELECT columnas
        FROM tablas
        WHERE condiciones;
*/


select L.Language, 
		if(L.IsOfficial = "F", "No oficial", "Oficial") as Tipo,
        case
			when L.IsOfficial = "F" then "No oficial"
            else "Oficial"
		end as Tipo2,
        case
			when L.Percentage < 0.3 then "Poco hablado"
            when L.Percentage between 0.4 and 49 then "Madianamente hablado"
            else "Muy hablado"
        end as Frecuencia
        
	from world.countrylanguage L
    join world.country P on L.countryCode = P.Code
    where P.Name = "Colombia";