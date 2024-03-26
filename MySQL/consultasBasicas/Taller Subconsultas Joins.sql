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


USE tienda;
SELECT * FROM fabricante;
SELECT * FROM producto;



-- CONSULTA N°1
select P.id_fabricante, F.nombre
	from producto P
    inner join fabricante F on P.id_fabricante = F.id
    group by id_fabricante
    having count(*) > 1;

-- CONSULTA N°2
select F.nombre, count(F.nombre) total
	from fabricante F
    inner join (
		select P.precio, F.id
			from fabricante F
            inner join producto P on F.id = P.id_fabricante
            group by P.precio, F.id
            having P.precio >= 220
    ) FIF on F.id = FIF.id  #FIF = Fabricante Información Filtrada
    group by F.nombre
    order by total desc;

-- CONSULTA N°3
select F.nombre, count(FIF.id) total
	from (
		select P.precio, F.id
			from fabricante F
            inner join producto P on F.id = P.id_fabricante
            where P.precio >= 220
    ) FIF
    right join fabricante F on FIF.id = F.id
    group by FIF.id, F.nombre
    order by total desc, F.nombre desc;
    
-- CONSULTA N°4
select nombre, concat(format(precio, 2), '€') precio
	from(
		select F.nombre, sum(P.precio) precio
			from fabricante F
            inner join producto P on F.id = P.id_fabricante
            group by F.nombre
            having precio > 1000
    ) infoFormateado;

-- CONSULTA N°5
select substr(RCP.precio_producto, locate(',', RCP.precio_producto) + 1) Producto, 
	   concat('$', format(substr(RCP.precio_producto, 1, locate(',', RCP.precio_producto) - 1), 2)) Precio,
       marca Marca
	from (
		select EPMPF.marca, max(precio_producto) precio_producto
			from (
				select F.nombre marca, concat(P.precio, ',', P.nombre) precio_producto
					from fabricante F
                    inner join producto P on F.id = P.id_fabricante
            ) EPMPF  #EPMPF = Encontrar el Precio Máximo del Producto por Fabricante
            group by marca
    ) RCP;  #RCP = Resultado Consulta Principal

-- CONSULTA N°6
select nombre, precio
	from producto
    group by nombre, precio
    having precio >= all(select precio from producto);

-- CONSULTA N°7
select nombre, precio
	from producto
    group by nombre, precio
    having precio <= all(select precio from producto);

-- CONSULTA N°8
select F.nombre marca, P.nombre producto
	from fabricante F
    inner join producto P on F.id = P.id_fabricante
    group by marca, producto
    having marca = any(select nombre from fabricante);

-- CONSULTA N°9
select *
	from fabricante F
    group by id
    having id = any(
		select temp.id
			from (
				select P.id_fabricante, F.id
					from fabricante F
                    left join producto P on F.id = P.id_fabricante
                    where id_fabricante is null
            ) temp
    );
    
-- CONSULTA N°10
select *
	from fabricante
    where id in (select id_fabricante from producto);

-- CONSULTA N°11
select *
	from fabricante
    where id not in (select id_fabricante from producto);

-- CONSULTA N°12
select F.nombre
	from(
		select distinct id_fabricante
			from producto
            where exists(select id from fabricante)
    ) ID
    inner join fabricante F on ID.id_fabricante = F.id;

-- CONSULTA N°13
select F.nombre
	from(
		select distinct id_fabricante
			from producto
            where exists(select id from fabricante)
    ) ID
    right join fabricante F on ID.id_fabricante = F.id
    where ID.id_fabricante is null;




-- ---------------------------------------- --
-- Con la base de datos siguiente, hacer... --
-- ---------------------------------------- --
DROP DATABASE IF EXISTS ventas;
CREATE DATABASE ventas CHARACTER SET utf8mb4;
USE ventas;

CREATE TABLE cliente(
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido1 VARCHAR(100) NOT NULL,
    apellido2 VARCHAR(100),
    ciudad VARCHAR(100),
    categoria INT UNSIGNED
);

CREATE TABLE comercial(
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido1 VARCHAR(100) NOT NULL,
    apellido2 VARCHAR(100),
    comision FLOAT
);

CREATE TABLE pedido(
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    total DOUBLE NOT NULL,
    fecha DATE,
    id_cliente INT UNSIGNED NOT NULL,
    id_comercial INT UNSIGNED NOT NULL,
    FOREIGN KEY(id_cliente) REFERENCES cliente(id),
    FOREIGN KEY(id_comercial) REFERENCES comercial(id)
);

INSERT INTO cliente VALUES(1, 'Aarón', 'Rivero', 'Gómez', 'Almería', 100);
INSERT INTO cliente VALUES(2, 'Adela', 'Salas', 'Díaz', 'Granada', 200);
INSERT INTO cliente VALUES(3, 'Adolfo', 'Rubio', 'Flores', 'Sevilla', NULL);
INSERT INTO cliente VALUES(4, 'Adrián', 'Suárez', NULL, 'Jaén', 300);
INSERT INTO cliente VALUES(5, 'Marcos', 'Loyola', 'Méndez', 'Almería', 200);
INSERT INTO cliente VALUES(6, 'María', 'Santana', 'Moreno', 'Cádiz', 100);
INSERT INTO cliente VALUES(7, 'Pilar', 'Ruiz', NULL, 'Sevilla', 300);
INSERT INTO cliente VALUES(8, 'Pepe', 'Ruiz', 'Santana', 'Huelva', 200);
INSERT INTO cliente VALUES(9, 'Guillermo', 'López', 'Gómez', 'Granada', 225);
INSERT INTO cliente VALUES(10, 'Daniel', 'Santana', 'Loyola', 'Sevilla', 125);


INSERT INTO comercial VALUES(1, 'Daniel', 'Sáez', 'Vega', 0.15);
INSERT INTO comercial VALUES(2, 'Juan', 'Gómez', 'López', 0.13);
INSERT INTO comercial VALUES(3, 'Diego','Flores', 'Salas', 0.11);
INSERT INTO comercial VALUES(4, 'Marta','Herrera', 'Gil', 0.14);
INSERT INTO comercial VALUES(5, 'Antonio','Carretero', 'Ortega', 0.12);
INSERT INTO comercial VALUES(6, 'Manuel','Domínguez', 'Hernández', 0.13);
INSERT INTO comercial VALUES(7, 'Antonio','Vega', 'Hernández', 0.11);
INSERT INTO comercial VALUES(8, 'Alfredo','Ruiz', 'Flores', 0.05);


INSERT INTO pedido VALUES(1, 150.5, '2017-10-05', 5, 2);
INSERT INTO pedido VALUES(2, 270.65, '2016-09-10', 1, 5);
INSERT INTO pedido VALUES(3, 65.26, '2017-10-05', 2, 1);
INSERT INTO pedido VALUES(4, 110.5, '2016-08-17', 8, 3);
INSERT INTO pedido VALUES(5, 948.5, '2017-09-10', 5, 2);
INSERT INTO pedido VALUES(6, 2400.6, '2016-07-27', 7, 1);
INSERT INTO pedido VALUES(7, 5760, '2015-09-10', 2, 1);
INSERT INTO pedido VALUES(8, 1983.43, '2017-10-10', 4, 6);
INSERT INTO pedido VALUES(9, 2480.4, '2016-10-10', 8, 3);
INSERT INTO pedido VALUES(10, 250.45, '2015-06-27', 8, 2);
INSERT INTO pedido VALUES(11, 75.29, '2016-08-17', 3, 7);
INSERT INTO pedido VALUES(12, 3045.6, '2017-04-25', 2, 1);
INSERT INTO pedido VALUES(13, 545.75, '2019-01-25', 6, 1);
INSERT INTO pedido VALUES(14, 145.82, '2017-02-02', 6, 1);
INSERT INTO pedido VALUES(15, 370.85, '2019-03-11', 1, 5);
INSERT INTO pedido VALUES(16, 2389.23, '2019-03-11', 1, 5);


select * from cliente;
select * from comercial;
select * from pedido;


-- CONSULTA N°1
select distinct C.id, C.nombre, concat(C.apellido1, ' ', if(C.apellido2 is not null, C.apellido2, '')) apellido
	from cliente C
    inner join pedido P on C.id = P.id_cliente
    order by apellido asc;


-- CONSULTA N°2
select P.id idPedido, C.nombre, C.apellido1, C.ciudad, C.categoria, concat('$', format(P.total, 2)) precioTotal, P.fecha
	from cliente C
    inner join pedido P on C.id = P.id_cliente
    order by C.nombre asc;


-- CONSULTA N°3
select P.id_comercial, 
	   concat(trim(C.nombre), ' ', trim(apellido1), ' ', trim(if(apellido2 is not null, apellido2, ''))) 'Nombre Comercial',
       C.comision Comisión, P.id idPedido, 
       concat('$', format(P.total, 2)) 'Precio Total',
       P.fecha Fecha, P.id_cliente
	from comercial C
    inner join pedido P on C.id = P.id_comercial
    order by Nombre asc;


-- CONSULTA N°4
select P.id_cliente,
       concat(trim(Cli.nombre), ' ', trim(Cli.apellido1), ' ', trim(if(Cli.apellido2 is not null, Cli.apellido2, ''))) 'Nombre Cliente',
       Cli.ciudad Ciudad, Cli.categoria Categoria, P.id_comercial, 
       concat(trim(Com.nombre), ' ', trim(Com.apellido1), ' ', trim(if(Com.apellido2 is not null, Com.apellido2, ''))) 'Nombre Comercial',
       Com.comision Comisión, P.id id_pedido, P.fecha Fecha,
       concat('$', format(P.total, 2)) 'Precio Total'
	from pedido P
    right join comercial Com on P.id_comercial = Com.id
    right join cliente Cli on P.id_cliente = Cli.id;


-- CONSULTA N°5
select id_cliente,
	   concat(trim(nombre), trim(apellido1), trim(if(apellido2 is not null, apellido2, ''))) nombre,
       ciudad, categoria, id_comercial, concat('$', format(total, 2)) total, fecha
	from(
		select P.id_cliente, nombre, apellido1, apellido2, ciudad, categoria, id_comercial, total, fecha
			from cliente C
            inner join pedido P on C.id = P.id_cliente
            where cast(substr(P.fecha, 1, locate('-', P.fecha) - 1) as unsigned) = 2017
    ) FPA  #FPA = Filtrado Por Año
    where format(FPA.total, 0) between 300 and 1000;


-- CONSULTA N°6
select distinct P.id_comercial, concat(trim(Com.nombre), ' ', trim(Com.apellido1), ' ', trim(if(Com.apellido2 is not null, Com.apellido2, ''))) 'Nombre Comerciante'
	from pedido P
    inner join cliente C on P.id_cliente = C.id
    inner join comercial Com on P.id_comercial = Com.id
    where concat(trim(C.nombre), ' ', trim(C.apellido1), ' ', trim(if(C.apellido2 is not null, C.apellido2, ''))) = 'Marí­a Santana Moreno';


-- CONSULTA N°7
select distinct P.id_cliente, concat(trim(Cli.nombre), ' ', trim(Cli.apellido1), ' ', trim(if(Cli.apellido2 is not null, Cli.apellido2, ''))) 'Nombre Cliente'
	from pedido P
    inner join cliente Cli on P.id_cliente = Cli.id
    inner join comercial Com on P.id_comercial = Com.id
    where concat(trim(Com.nombre), ' ', trim(Com.apellido1), ' ', trim(if(Com.apellido2 is not null, Com.apellido2, ''))) = 'Daniel Sáez Vega';


-- CONSULTA N°8
select C.id 'ID Cliente', 
       concat(trim(C.apellido1), ' ', trim(if(C.apellido2 is not null, C.apellido2, '')), ' ', trim(C.nombre)) 'Nombre Cliente',
       C.ciudad, P.id 'ID Pedido', concat('$', format(P.total, 2)) Total, P.fecha, Com.id 'ID Comerciante',
       concat(trim(Com.nombre), ' ', trim(Com.apellido1), ' ', trim(if(Com.apellido2 is not null, Com.apellido2, ''))) 'Nombre Comerciante',
       Com.comision
	from pedido P
    right join cliente C on P.id_cliente = C.id
    left join comercial Com on P.id_comercial = Com.id
    order by C.apellido1 asc, C.apellido2 asc, C.nombre asc;


-- CONSULTA N°9
select Com.id 'ID Comerciante',
	   concat(trim(Com.apellido1), ' ', trim(if(Com.apellido2 is not null, Com.apellido2, '')), ' ', trim(Com.nombre)) 'Nombre Comerciante',
       Com.comision, P.id 'ID Pedido', concat('$', format(P.total, 2)) Total, P.fecha, C.id 'ID Cliente',
       concat(trim(C.nombre), ' ', trim(C.apellido1), ' ', trim(if(C.apellido2 is not null, C.apellido2, ''))) 'Nombre Cliente',
       C.ciudad
	from pedido P
    right join comercial Com on P.id_comercial = Com.id
    left join cliente C on P.id_cliente = C.id
    order by Com.apellido1 asc, Com.apellido2 asc, Com.nombre asc;


-- CONSULTA N°10
select C.*
	from pedido P
    right join cliente C on P.id_cliente = C.id
    where P.id is null;


-- CONSULTA N°11
select Com.*
	from pedido P
    right join comercial Com on P.id_comercial = Com.id
    where P.id is null;


-- CONSULTA N°12
select Rol, id ID, concat(trim(apellido1), ' ', trim(if(apellido2 is not null, apellido2, '')), ' ', trim(nombre)) Nombre
	from (
		select concat('Cliente') Rol, C.id, C.nombre, C.apellido1, C.apellido2
        from pedido P
        right join cliente C on P.id_cliente = C.id
        where P.id is null
        
        union
        
        select concat('Comercial') Rol, Com.id, Com.nombre, Com.apellido1, Com.apellido2
        from pedido P
        right join comercial Com on P.id_comercial = Com.id
        where P.id is null
    ) FCPR  #FCPR = Filtrado de Clientes sin Pedidos Registrados
    order by apellido1 asc, apellido2 asc, nombre asc;
    

-- CONSULTA N°13
# Es una pregunta teorica :D


-- CONSULTA N°14
select C.id 'ID Cliente', nombre, concat(trim(apellido1), ' ', trim(ifnull(apellido2, ''))) apellidos, 
	   PFPMF.fechaPedido, concat('$', format(PFPMF.precioTotal, 2)) 'Precio Total'
	from(
		select *
		from (
			select fecha fechaPedido, max(total) precioTotal
            from pedido
            group by fechaPedido
        ) PMFF  #PMFF = Precio Máximo Filtrado por Fecha
        inner join pedido P on PMFF.fechaPedido = P.fecha
        where PMFF.precioTotal = P.total
    ) PFPMF  #PFPMF = Pedido Filtrado por el Precio Máximo y por Fecha
    inner join cliente C on PFPMF.id_cliente = C.id
    order by PFPMF.fechaPedido desc;


-- CONSULTA N°15
select fecha, max(total) precioTotal
	from pedido
    group by fecha
    having precioTotal > 2000
    order by precioTotal desc;

-- CONSULTA N°16
select C.id, C.nombre,
	   concat(trim(C.apellido1), ' ', trim(if(C.apellido2 is not null, C.apellido2, ''))) apellidos,
       concat('$', format(RFPF.total, 2)) total
	from(
		select id_comercial, fecha, max(total) total
        from pedido
        group by id_comercial, fecha
        having fecha = '2016-08-17'
    ) RFPF  #RFPF = Resultado Filtrado Por Fecha
    inner join comercial C on RFPF.id_comercial = C.id;


-- CONSULTA N°17
select C.id, C.nombre, 
	   concat(trim(C.apellido1), ' ', trim(if(C.apellido2 is not null, C.apellido2, ''))) apellidos,
       if(FCP.cantidadPedidos is not null, FCP.cantidadPedidos, 0) cantidadPedidos
	from(
		select id_cliente, count(id_cliente) cantidadPedidos
        from pedido
        group by id_cliente
    ) FCP  #FCP = Filtrado por Cantidad de Pedidos
    right join cliente C on FCP.id_cliente = C.id;


-- CONSULTA N°18
select C.id, C.nombre,
	   concat(trim(C.apellido1), ' ', trim(if(C.apellido2 is not null, C.apellido2, ''))) apellidos,
       RFDS.cantidadPedidos
	from(
		select id_cliente, count(id_cliente) cantidadPedidos
        from (
			select *
			from pedido
            where substr(fecha, 1, locate('-', fecha) - 1) = '2017'
        ) primerPaso
        group by id_cliente
    ) RFDS  #RFDS = Resultado del Filtrado de Datos Solicitados
    inner join cliente C on RFDS.id_cliente = C.id;


-- CONSULTA N°19
select C.id, C.nombre, C.apellido1, 
	   concat('$', format(if(maxTotal is not null, maxTotal, 0), 2)) maxTotal
	from(
		select id_cliente, max(total) maxTotal
        from pedido
        group by id_cliente
    ) PMC  #PMC = Pedido Máximo por Cliente
    right join cliente C on PMC.id_cliente = C.id;


-- CONSULTA N°20
select TFD.id 'ID Producto', concat('$', format(TFD.total, 2)) Precio, TFD.fecha 'Fecha Pedido',
	   Cli.id 'ID Cliente', 
	   concat(trim(Cli.nombre), ' ', trim(Cli.apellido1), ' ', trim(ifnull(Cli.apellido2, ''))) 'Nombre Cliente',
	   Com.id 'ID Comercial', 
	   concat(trim(Com.nombre), ' ', trim(Com.apellido1), ' ', trim(ifnull(Com.apellido2, ''))) 'Nombre Comerciante'
       
	from(
		select *, cast(total as decimal(10, 2)) totalPrecio
        from pedido
    ) TFD  #TFD = Total en Formato Decimal(10,2)
    
    inner join (
		select substr(ICFT.fechaTotal, 1, locate('-', ICFT.fechaTotal) - 1) fecha,
			   max(cast(substr(ICFT.fechaTotal, locate(',', ICFT.fechaTotal) + 1) as decimal(10,2))) pedMaxVal
        from(
			select concat(trim(fecha), ',', trim(total)) fechaTotal
            from pedido
        ) ICFT  #ICFT = Información Concatenada por Fecha y Total
        group by substr(ICFT.fechaTotal, 1, locate('-', ICFT.fechaTotal) - 1)
        
    ) IFFVPMA  #IFFVPMA = Información Filtrada por Fecha y el Valor del Precio Máximo por Año
    on TFD.totalPrecio = IFFVPMA.pedMaxVal
    
    inner join cliente Cli on TFD.id_cliente = Cli.id
    inner join comercial Com on TFD.id_comercial = Com.id;


-- CONSULTA N°21
select Fecha, count(fecha) numPedidos
	from (select substr(fecha, 1, locate('-', fecha) - 1) Fecha from pedido) anioFecha
    group by Fecha
    order by Fecha desc;


-- CONSULTA N°22
select *
	from cliente
    where id = (
		select id_cliente 
			from pedido
			where substr(fecha, 1, locate('-', fecha) - 1) = '2019'
			order by total desc 
			limit 1
    );


-- CONSULTA N°23
select P.fecha, concat('$', format(P.total, 2)) Total
	from (
		select *
        from cliente
        where nombre = 'Pepe' and apellido1 = 'Ruiz' and apellido2 = 'Santana'
    ) C
    inner join pedido P on C.id = P.id_cliente
    order by P.total asc
    limit 1;


-- CONSULTA N°24
select C.id 'ID Cliente',
	   concat(trim(C.nombre), ' ', trim(C.apellido1), ' ', trim(ifnull(C.apellido2, ''))) nombre,
       C.ciudad, C.categoria, RFVM.id 'ID Producto', RFVM.fecha, 
       concat('$', format(RFVM.total,2)) precioTotal
	from(
		select * 
        from pedido
        where left(fecha, 4) = '2017' and (
			select avg(total) valorMedio 
            from pedido 
            where left(fecha, 4) = '2017'
        ) <= total
    ) RFVM  #RFVM = Resultados Filtrados según el Valor Medio del 2017
    inner join cliente C on RFVM.id_cliente = C.id;


-- CONSULTA N°25
select P.id, concat('$', format(P.total, 2)) precioTotal, P.fecha, P.id_cliente, P.id_comercial
	from(
		select id, total
        from pedido
        group by id, total
        having total >= all(select total from pedido)
    ) PMC  #PMC = Producto Más Caro
    inner join pedido P on PMC.id = P.id;


-- CONSULTA N°26
select C.id, concat(trim(C.nombre), ' ', trim(C.apellido1), ' ', trim(ifnull(C.apellido2, ''))) nombre,
       C.ciudad, C.categoria
	from (
		select P.id_cliente, C.id
        from pedido P
        right join cliente C on P.id_cliente = C.id
        group by P.id_cliente, C.id
        having C.id <> all(select id_cliente from pedido)
    ) CSP  #Cliente Sin Pedidos
    inner join cliente C on CSP.id = C.id;


-- CONSULTA N°27
select C.id, concat(trim(C.nombre), ' ', trim(C.apellido1), ' ', trim(ifnull(C.apellido2,''))) nombre, C.comision
	from (
		select P.id_comercial, C.id
        from pedido P
        right join comercial C on P.id_comercial = C.id
        group by P.id_comercial, C.id
        having C.id <> all(select id_comercial from pedido)
    ) CMSP  #CoMercial Sin Pedidos
    inner join comercial C on CMSP.id = C.id;


-- CONSULTA N°28
select id, concat(trim(nombre), ' ', trim(apellido1), ' ', trim(ifnull(apellido2, ''))) nombre,
       ciudad, categoria
	from cliente C
    where C.id not in (select id_cliente from pedido);


-- CONSULTA N°29
select id, concat(trim(nombre), ' ', trim(apellido1), ' ', trim(ifnull(apellido2, ''))) nombre, comision
	from comercial C
    where C.id not in (select id_comercial from pedido);


-- CONSULTA N°30
select id, concat(trim(nombre), ' ', trim(apellido1), ' ', trim(ifnull(apellido2, ''))) nombre, ciudad, categoria
	from (
		select distinct id_cliente
		from pedido
        where exists (select id from cliente)
    ) CE  #Clientes Existentes
    right join cliente C on CE.id_cliente = C.id
    where id_cliente is null;


-- CONSULTA N°31
select id, concat(trim(nombre), ' ', trim(apellido1), ' ', trim(ifnull(apellido2, ''))) nombre, comision
	from (
		select distinct id_comercial
        from pedido
        where exists (select id from comercial)
    ) CME  #CoMerciales Existentes
    right join comercial C on CME.id_comercial = C.id
    where id_comercial is null;