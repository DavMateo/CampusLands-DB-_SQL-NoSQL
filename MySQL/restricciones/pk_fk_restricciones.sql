CREATE DATABASE pk_fk_restricciones;
use pk_fk_restricciones;

/* RESTRICCIONES

-- Restricción de Unicidad (UNIQUE):
1. Garantiza que los valores en una columna o conjunto de columnas sean únicos en la tabla.

Ejemplo:
*/
CREATE TABLE empleados(
	id INT PRIMARY KEY,
    codigo_empleado INT UNIQUE,
    nombre VARCHAR(50)
);

/* RESTRICCIONES

-- Restricción de Valor Predeterminado (DEFAULT):
1. Define un valor predeterminado para una columna si no se proporciona un valor al insertar un nuevo registro.

EJEMPLO:
*/

CREATE TABLE pedidos(
	id INT PRIMARY KEY,
    fecha_pedido DATE DEFAULT (CURRENT_DATE),
    total DECIMAL(10, 2) DEFAULT 0.00
);
INSERT INTO pedidos(id, total) VALUES(1, 100), (2, 30), (3, 150), (5, NULL);
-- INSERT INTO pedidos(id) VALUES(5);
drop table pedidos;
select * from pedidos;


/* RESTRICCIONES

-- Restricción de Verificación (CHECK)
1. Permite definir una condición que debe cumplirse para que un valor se almacene en una columna.

EJEMPLO:
*/
CREATE TABLE producto (
	id INT PRIMARY KEY,
    nombre VARCHAR(50),
    cantidad INT CHECK(cantidad > 0)
);
INSERT INTO producto VALUES(1, "Bandeja Paisa", 0);


/* RESTRICCIONES

-- Restricción de No Nulos (NOT NULL)
1. Indica que una columna no puede contener valores nulos.

EJEMPLO:
*/
CREATE TABLE clientes (
	id INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);


/* RESTRICCIONES

-- Restricción de Valor Único en Clave Primaria (AUTO_INCREMENT):
1. Se utiliza para generar automáticamente valores únicos para una columna de clave primaria. 

EJEMPLO:
*/
CREATE TABLE empleados1(
	id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50)
);
INSERT INTO empleados1(nombre) VALUES("camilo"), ("lorenzo"), ("carlos");
SELECT * from empleados1;


/* ENTIDAD-RELACIÓN & MODELO RELACIONAL

-- Componentes principales del modelo E-R
1. Entidades: Objetos del mundo real de interés para el sistema
2. Atributos: Características o propiedades de las entidades.
3. Relaciones: Asociaciones o conexiones entre entidades.
4. Cardinalidad: Cantidad de instancias de una entidad en la otra (1:N) - (N:M) - (1:1). 

*/


/*

-- Modelo Relacional
1. Es una representación lógica más concreta y física de la base de datos
2. Los datos se organizan en tablas y relaciones
3. Las tablas contienen: filas(registros) y columnas(campos)
4. Las relaciones se hacen a traves de las llaves (primarias (PK) o foráneas (FK o externas))

*/