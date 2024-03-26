-- -------- --
-- GROUP BY --
-- -------- --

/*
	1. Agurpa valores idénticos de una tabla.
    2. Tenemos como resultado una única fila resumen por cada grupo de elementos únicos formados.
    3. Funciones de agregación:
       3.1. COUNT(), SUM(), MAX(), MIN(), AVG(), STDEV(), VAR(), VARP()
*/


DROP SCHEMA IF EXISTS miPrimeraBaseDeDatos;
CREATE SCHEMA IF NOT EXISTS miPrimeraBaseDeDatos DEFAULT CHARACTER SET  utf8mb3;
SHOW WARNINGS;
USE miPrimeraBaseDeDatos;

-- Table "Coches"

DROP TABLE IF EXISTS coches;

CREATE TABLE IF NOT EXISTS coches(
	id INT(11) NOT NULL AUTO_INCREMENT,
    marca VARCHAR(45) NOT NULL,
    modelo VARCHAR(45) NOT NULL,
    kilometros INT(11) NOT NULL,
    PRIMARY KEY(id)
)
ENGINE = InnoDB
AUTO_INCREMENT = 10
DEFAULT CHARACTER SET = utf8;


INSERT INTO coches(id, marca, modelo, kilometros) VALUES 
	(1, 'Renault', 'Clio', 10),
    (2, 'Renault', 'Megane', 23000),
    (3, 'Seat', 'Ibiza', 9000),
    (4, 'Seat', 'Leon', 20),
    (5, 'Opel', 'Corsa', 999),
    (6, 'Renault', 'Clio', 34000),
    (7, 'Seat', 'Ibiza', 2000), 
    (8, 'Seat', 'Cordoba',99999),
    (9, 'Renault', 'Clio', 88888);
    


SELECT marca 
	FROM choches 
    GROUP BY marca;

SELECT marca, modelo
	FROM coches
    GROUP BY marca, modelo;

SELECT marca, COUNT(*) AS contador
	FROM coches
    GROUP BY marca
    ORDER BY contador DESC;

SELECT marca, SUM(kilometros)
	FROM coches
    GROUP BY marca;

SELECT marca, MAX(kilometros)
	FROM coches
    GROUP BY marca;

SELECT marca, MIN(kilometros)
	FROM coches
    GROUP BY marca;


SELECT fabricante.nombre, AVG(producto.precio)
	FROM producto
    INNER JOIN fabricante ON producto.codigo_fabricante = fabricante.codigo
    WHERE fabricante.nombre != 'Seagate'
    GROUP BY fabricante.codigo
    HAVING AVG(producto.precio) >= 150;