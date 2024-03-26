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
    FOREIGN KEY (id_fabricante) REFERENCES fabricante(id)
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


select * from fabricante;
select * from producto;

-- Índices identificados
create index idx_productName on producto(nombre);
create index idx_producerName on fabricante(nombre);

-- Consulta n°1
select P.nombre nombreProducto, concat("$", format(precio, 2)) precioProducto, F.nombre nombreFabricante
	from fabricante F
    inner join producto P on F.id = P.id;


-- Consulta n°2
select P.nombre nombreProducto, concat("$", format(precio, 2)) precioProducto, F.nombre nombreFabricante
	from fabricante F
    inner join producto P on F.id = P.id
    order by nombreFabricante asc;


-- Consulta n°3
select P.id, P.nombre nombreProducto, F.id id_fabricante, F.nombre nombreFabricante
	from fabricante F
    inner join producto P on F.id = P.id;


-- Consulta n°4
select P.nombre nombreProducto, concat("$", format(precio, 2)) precioProducto, F.nombre nombreFabricante
	from fabricante F
    inner join producto P on F.id = P.id
	order by precio asc
    limit 1;


-- Consulta n°5
select P.nombre nombreProducto, concat("$", format(precio, 2)) precioProducto, F.nombre nombreFabricante 
	from fabricante F
    inner join producto P on F.id = P.id
    order by precio desc
    limit 1;


-- Consulta n°6
select F.id id_fabricante, F.nombre nombreFabricante, P.id id_producto, P.nombre nombreProducto, concat("$", format(precio, 2)) precioProducto
	from fabricante F
    inner join producto P on F.id = P.id
    where F.nombre = 'Lenovo';


-- Consulta n°7
select F.id id_fabricante, F.nombre nombreFabricante, P.id id_producto, P.nombre nombreProducto, concat("$", format(precio, 2)) precioProducto
	from fabricante F
    inner join producto P on F.id = P.id
    where F.nombre = 'Crucial' and P.Precio > 200;


-- Consulta n°8
select F.id id_fabricante, F.nombre nombreFabricante, P.id id_producto, P.nombre nombreProducto, concat("$", format(precio, 2)) precioProducto
	from fabricante F
    inner join producto P on F.id = P.id
    where F.nombre = 'Asus' or F.nombre = 'Hewlett-Packardy' or F.nombre = 'Seagate';


-- Consulta n°9
select * 
	from fabricante F
    inner join producto P on F.id = P.id
    where F.nombre in ('Asus', 'Hewlett-Packardy', 'Seagate');


-- Consulta n°10
select F.id id_fabricante, F.nombre nombreFabricante, P.id id_producto, P.nombre nombreProducto, concat("$", format(precio, 2)) precioProducto
	from fabricante F
    inner join producto P on F.id = P.id
    where trim(lower(right(F.nombre, 1))) = 'e';


-- Consulta n°11
select F.id id_fabricante, F.nombre nombreFabricante, P.id id_producto, P.nombre nombreProducto, concat("$", format(precio, 2)) precioProducto
	from fabricante F
    inner join producto P on F.id = P.id
    where locate("w", lower(F.nombre));


-- Consulta n°12
select F.nombre nombreFabricante, P.nombre nombreProducto, concat(format(P.precio, 2), "€") precioProducto
	from fabricante F
    inner join producto P on F.id = P.id
    where precio >= 180
    order by precio desc, F.nombre asc;


-- Consulta n°13
select *
	from fabricante F
    where F.id in (
		select P.id_fabricante
		from producto P
    );


-- Consulta n°14
select F.id id_fabricante, F.nombre nombreFabricante, P.id id_producto, P.nombre nombreProducto, concat("$", format(P.precio, 2)) precioProducto
	from fabricante F
    inner join producto P on F.id = P.id;


-- Consulta n°15
select *
	from fabricante F
    left join producto P on F.id = P.id_fabricante
    where P.id_fabricante is null;