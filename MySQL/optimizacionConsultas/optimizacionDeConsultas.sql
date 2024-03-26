-- ------------------------- --
-- Optimización de Consultas --
-- ------------------------- --


-- Instrucción Like
use world;

select name
	from country
    where name like "Co%";  #Busca los países que inicien en 'Co' y todo lo que le siga a esa instrucción. 

select name
	from country
    where name like "%cia";  #Busca los países que inicien en cualquier cosa pero que terminen en 'cia'. 


/* COMODIN_
- Representa un único caracter.
*/
select *
	from country
    where name like "F___ce";  #Busca los países que empiecen por F, seguido de tres caracteres cualquiera y termine en 'ce'. 

select *
	from country
    where name like "_%san%";  #Busca los países que empiecen por lo que sea pero que en LA MITAD contenga la cadena 'san' y termine en cualquier cosa. 

#Encontrar todos los países que incluyan en su nombre todas las vocales. 
select *
	from country
    where name like "%a%" and name like "%e%" and name like "%i%" and name like "%o%" and name like "%u%";

#Encontrar los países que tienen nombres compuestos. 
select *
	from country
    where trim(name) like "% %";


-- Listar los países que no contengan la expresión USA en su nombre
select *
	from country
    where name not like "USA";

-- Listar todos los países donde el continente sea América
select *
	from country
    where trim(lower(Continent)) like "%america";



/* OPTIMIZACIÓN DE CONSULTAS
	1. Creación de índices e índices compuestos para acelerar la velocidad de la consulta.
    
    2. Evitar las subconsultas que no sean necesarias. Evaluar si se ejecuta solo una vez o si lee por campos.
		2.1. Utilizar el 'JOIN' en vez de la subconsulta siempre y cuando sea posible, esto debido a que al momento de la 
        unión, las llaves están mejor optimizadas para operar con ellos. 
	
    3. Usar el caching de consultas en MySQL.
		3.1. Se carga en memoria una consulta para que cargue más rápido y ejecutarla en un rango de horas determinado.
        3.2. Se consulta una vez al disco y se entrega la información con múltiples peticiones a la vez sin ir a buscar en disco. 
	
    4. El tamaño SI importa. 
		4.1. Una base de datos más grande, más complicado y pesado será de leer. Para ello se recomienda crear particiones a la 
        base de datos. 
        4.2. Se divide la información en 'tablas' más pequeños con las cuales se puede consultar y manipular sin problema alguno.
	
    5. Prestar atención al nombre de las tablas, estas deben ser descriptivas y por lo general están en singular.
    
    6. Usar tipos de datos acorde a las necesidades específicas encontrando equilíbrio entre rendimiento y utilidad.
*/

CREATE TABLE libros(
	id INT AUTO_INCREMENT,
    titulo VARCHAR(100),
    autor VARCHAR(100),
    anio INT,
    PRIMARY KEY(id)
);

SELECT * FROM libros WHERE autor = 'Gabriel García Marquez';  #Esto es poco eficiente. 
#Método Eficiente:
CREATE INDEX idx_autor ON libros(autor);

SELECT * FROM libros WHERE anio > 2000 AND autor IN ('Autor1', 'Autor2', 'Autor3'); #Esto es poco eficiente. 
#Método más Eficiente:
CREATE INDEX idx_anio_autor ON libros(anio, autor);  #Índice Compuesto.


-- Punto 2:
#Ineficiente:
SELECT nombre
	FROM usuarios
    WHERE id_usuario IN (SELECT id_usuario FROM compras);

#Eficiente
SELECT DISTINCT usuarios.nombre
	FROM usuarios
    JOIN compras ON usuarios.id_usuario = compras.id_usuario;


-- Caching de Consultas en MySQL
#Pseudocódigo en Python con uso de cache: 
/*
	noticias_cacheadas = obtener_de_cache("últimas noticias");
    if noticias_cacheadas is None:
		noticias = ejecutar_consulta_sql("SELECT * FROM noticias ORDER BY fecha_publicacion DESC LIMIT 10;")
        guardar_en_cache("últimas_noticias", noticias, tiempo_expiracion_db)
	else:
		noticias = noticias_cacheadas
*/


-- Particionar la base de datos
use prueba;

CREATE TABLE employees(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    fname VARCHAR(25) NOT NULL,
    lname VARCHAR(25) NOT NULL,
    store_id INT NOT NULL,
    departament_id INT NOT NULL
)
	PARTITION BY RANGE(id) (
		PARTITION p0 VALUES LESS THAN (5),
        PARTITION p1 VALUES LESS THAN (10),
        PARTITION p2 VALUES LESS THAN (15),
        PARTITION p3 VALUES LESS THAN MAXVALUE
    );


INSERT INTO employees VALUES
    (NULL, 'Bob', 'Taylor', 3, 2), (NULL, 'Frank', 'Williams', 1, 2),
    (NULL, 'Ellen', 'Johnson', 3, 4), (NULL, 'Jim', 'Smith', 2, 4),
    (NULL, 'Mary', 'Jones', 1, 1), (NULL, 'Linda', 'Black', 2, 3),
    (NULL, 'Ed', 'Jones', 2, 1), (NULL, 'June', 'Wilson', 3, 1),
    (NULL, 'Andy', 'Smith', 1, 3), (NULL, 'Lou', 'Waters', 2, 4),
    (NULL, 'Jill', 'Stone', 1, 4), (NULL, 'Roger', 'White', 3, 2),
    (NULL, 'Howard', 'Andrews', 1, 2), (NULL, 'Fred', 'Goldberg', 3, 3),
    (NULL, 'Barbara', 'Brown', 2, 3), (NULL, 'Alice', 'Rogers', 2, 2),
    (NULL, 'Mark', 'Morgan', 3, 3), (NULL, 'Karen', 'Cole', 3, 2);


SELECT *
	from employees
    partition (p1);

# Seleccionar todos los valores de la tabla 'employees' provenientes de la partición p0 y p2, donde el nombre la 
# columna 'lname' inicie con la letra 'S' y termine con cualquier cosa.
SELECT *
	FROM employees
    PARTITION (p0, p2)
    WHERE lname LIKE 'S%';

SELECT id, CONCAT(fname, ' ', lname) AS name
	FROM employees
    PARTITION (p0)
    ORDER BY lname;



/* TRANSACCIONES
	- Son operaciones que se consideran o se tratan como si fuera una sola.
	- Entonces si falla, se deshace y elimina. 
*/

start transaction;
INSERT INTO employees VALUES
	(NULL, 'Yulieth', 'Taylor', 3, 2);
commit;

#Transacción más complicada porque si. 
create table orden(
	idOrden int primary key,
    estado varchar(50)
);

create table factura(
	idfactura int primary key,
    idOrden int,
    cantidad int,
    foreign key(idOrden) references orden(idOrden)
);  
 
 
start transaction;
insert into orden values (101, "Completado");
insert into factura values (1, 101, 3);
commit;

select * from orden;
select * from factura;

rollback;