-- -------------------------- --
-- Procedimientos Almacenados --
-- -------------------------- --

/* LOOP
- Ejecuta un bloque de código repetidamente hasta encontrar una sentencia LEAVE.
- Ideal para cuando necesitas ejecutar un bloque de código indefinidamente hasta que se cumpla una condición.
- Usarse cuando no se sabe cuántas veces se necesitará iterar.


SINTAXIS:
LOOP
	-- Acciones a repetir
    IF condicion_salida THEN
		LEAVE loop_label;
	END IF;
END LOOP loop_label


EJEMPLO:
*/
CREATE TABLE empleados(
	id INT AUTO_INCREMENT,
    nombre VARCHAR(100),
    salario DECIMAL(10, 2),
    PRIMARY KEY(id)
);

DELIMITER //

CREATE PROCEDURE aumentarSalario(IN empleadoID INT)
BEGIN
	LOOP
		UPDATE empleados SET salario = salario * 1.1 WHERE id = empleadoID AND salario <= 5000;
        IF salario > 5000 THEN
			LEAVE;
		END IF;
	END LOOP;
END //

DELIMITER ;


/* REPEAT
- Se ejecuta hasta que una condición específica se cumple.
- Útil cuando sabes que el bloque de código debe ejecutarse al menos una vez y continuar hasta que se cumpla una condición.
- Opta por REPEAT cuando la condición de terminación es más importante que la condición de inicio.


SINTAXIS:
REPEAT
	-- Acciones a repetir
UNTIL condicion
END REPEAT;


EJEMPLO:
*/
DELIMITER //

CREATE PROCEDURE aumentarSalarios()
BEGIN
	REPEAT
		UPDATE empleados SET salario = salario * 1.05 WHERE salario < 3000;
        UNTIL (SELECT COUNT(*) FROM empleados WHERE salario < 3000) = 0  #La condición debe ser algo que de negativo.
        END REPEAT;
END //

DELIMITER ;


/* WHILE
- Ejecuta un bloque de código mientras una condición sea verdadera.
- Ideal para situaciones donde necesitas continuar la ejecución mientras se cumpla una condición.
- Usa WHILE cuando la condición de inicio es más crítica que la de terminación.


SINTAXIS:
WHILE condicion DO
	-- Acciones a repetir
END WHILE;


EJEMPLO:
*/
DELIMITER //
CREATE PROCEDURE contarEmpleadosAltosSalarios()
BEGIN
	DECLARE contador INT DEFAULT 0;
    DECLARE totalEmpleados INT DEFAULT 0;
    SELECT COUNT(*) INTO totalEmpleados FROM empleados WHERE salario > 4000;
    WHILE contador < totalEmpleados DO  #La condición debe ser algo que de verdadero
		SET contador = contador + 1;
	END WHILE;
    SELECT contador;
END //

DELIMITER ;



/* CASE
- Es similar a las declaraciones "switch" en otros lenguajes de programación.
- Útil para evaluar una variable o expresión contra una serie de valores o condiciones distintas.
- Es especialmente útil en procedimientos almacenados y funciones para simplificar la lógica condicional compleja.


SINTAXIS:
CASE expresion
	WHEN valor1 THEN
		-- Acciones para valor1
	WHEN valor2 THEN
		-- Acciones para valor2
	ELSE
		-- Acciones si no se cumple ninguno de los casos anteriores.
END CASE;


EJEMPLO:
*/

CREATE TABLE empleados(
	id INT AUTO_INCREMENT,
    nombre VARCHAR(100),
    salario DECIMAL(10, 2),
    categoria VARCHAR(20),
    PRIMARY KEY(id)
);

DELIMITER //
CREATE PROCEDURE asignarCategoriaSalario()
BEGIN
	DECLARE done INT DEFAULT FALSE;  #La variable done se declara inicialmente en falso
    DECLARE empid INT;
    DECLARE empsal DECIMAL(10, 2);
    DECLARE cur1 CURSOR FOR SELECT id, salario FROM empleados;  #Es una "tabla" en memoria tipo matriz que sirve para recorrer una tabla temporal.
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE; 
    
    OPEN cur1;
    read_loop: LOOP   #read_loop Es una etiqueta
		FETCH cur1 INTO empid, empsal;  
			#Recorrerá todos los campos uno por uno para llenar "empid" y "empsal" con información.
            #FETCH es como un FOREACH
        IF done THEN
			LEAVE read_loop;
		END IF;
        
        CASE
			WHEN empsal <= 3000 THEN
				UPDATE empleados SET categoria = 'Entrada' WHERE id = empid;  #SET es como un LET
                
			WHEN empsal > 3000 AND empsal <= 7000 THEN
				UPDATE empleados SET categoria = 'Media' WHERE id = empid;
			
            ELSE
				UPDATE empleados SET categoria = 'Alta' WHERE id = empid;
		END CASE;
	END LOOP;
    
    CLOSE cur1;
END //
DELIMITER ;


-- Manejo de errores
# Si el "select" está solo, funciona como un "print()"


-- ------------------------------------------------------------

drop procedure insertarFabricante;
use tienda;

delimiter $$
create procedure insertarFabricante(in idfab int, in nomfab varchar(100))
begin
	declare exit handler for 1062 
    select concat("Error. El fabricante con el id ", idfab, " - ", nomfab, " ya existe.") as Error;
    
    insert into fabricante values (idfab, nomfab);
end$$
delimiter ;

use tienda;
call insertarFabricante(10, "Motorola");


# Una transacción es un conjunto de datos en donde todas las consultas deben
# realizarse exitosamente, si alguna falla, todo lo demás se deshace.


DELIMITER //
CREATE PROCEDURE actualizarUsuario(IN userId INT, IN newEmail VARCHAR(100))
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		-- Se podría registrar el error en una tabla de logs
        INSERT INTO error_logs(error_message) VALUES ('Error al actualizar usuario.');
        ROLLBACK;  #Revertir la transacción
	END;
    
    START TRANSACTION;  #Empieza una operación transaccional. Si algo ocurre, toda la operación se deshace
    UPDATE usuarios SET email = newEmail WHERE id = userId;
    COMMIT;
END;
DELIMITER ;



/* Modularidad
Crea uno o más procedimientos "PROCEDURE" para completar una funcionalidad en específico.
*/

CREATE DATABASE IF NOT EXISTS Tienda2;
USE Tienda2;

CREATE TABLE Productos (
    id INT AUTO_INCREMENT,
    nombre VARCHAR(255),
    precio DECIMAL(10, 2),
    stock INT,
    PRIMARY KEY (id)
);

CREATE TABLE Clientes (
    id INT AUTO_INCREMENT,
    nombre VARCHAR(255),
    email VARCHAR(255),
    PRIMARY KEY (id)
);

CREATE TABLE Ventas (
    id INT AUTO_INCREMENT,
    producto_id INT,
    cliente_id INT,
    cantidad INT,
    fecha_venta DATE,
    PRIMARY KEY (id),
    FOREIGN KEY (producto_id) REFERENCES Productos(id),
    FOREIGN KEY (cliente_id) REFERENCES Clientes(id)
);


DELIMITER //
CREATE PROCEDURE AñadirProducto(IN nombre VARCHAR(255), IN precio DECIMAL(10, 2), IN stock INT)
BEGIN
    INSERT INTO Productos(nombre, precio, stock) VALUES (nombre, precio, stock);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE RegistrarCliente(IN nombre VARCHAR(255), IN email VARCHAR(255))
BEGIN
    INSERT INTO Clientes(nombre, email) VALUES (nombre, email);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE RealizarVenta(IN productoID INT, IN clienteID INT, IN cantidad INT)
BEGIN
    -- Aquí podrías añadir lógica para actualizar el stock, verificar disponibilidad, etc.
    INSERT INTO Ventas(producto_id, cliente_id, cantidad, fecha_venta) VALUES (productoID, clienteID, cantidad, CURDATE());
END //
DELIMITER ;

CALL AñadirProducto('Producto 1', 10.99, 50);
CALL AñadirProducto('Producto 2', 15.49, 30);
CALL AñadirProducto('Producto 3', 8.99, 20);
CALL AñadirProducto('Producto 4', 20.99, 40);
CALL AñadirProducto('Producto 5', 12.99, 60);

CALL RegistrarCliente('Cliente 1', 'cliente1@example.com');
CALL RegistrarCliente('Cliente 2', 'cliente2@example.com');
CALL RegistrarCliente('Cliente 3', 'cliente3@example.com');
CALL RegistrarCliente('Cliente 4', 'cliente4@example.com');
CALL RegistrarCliente('Cliente 5', 'cliente5@example.com');

CALL RealizarVenta(1, 1, 2); -- Venta del Producto 1 al Cliente 1 con cantidad 2
CALL RealizarVenta(2, 2, 1); -- Venta del Producto 2 al Cliente 2 con cantidad 1
CALL RealizarVenta(3, 3, 3); -- Venta del Producto 3 al Cliente 3 con cantidad 3
CALL RealizarVenta(4, 4, 2); -- Venta del Producto 4 al Cliente 4 con cantidad 2
CALL RealizarVenta(5, 5, 1); -- Venta del Producto 5 al Cliente 5 con cantidad 1
CALL RealizarVenta(1, 2, 1); -- Venta del Producto 1 al Cliente 2 con cantidad 1
CALL RealizarVenta(2, 3, 2); -- Venta del Producto 2 al Cliente 3 con cantidad 2
CALL RealizarVenta(3, 4, 1); -- Venta del Producto 3 al Cliente 4 con cantidad 1
CALL RealizarVenta(4, 5, 3); -- Venta del Producto 4 al Cliente 5 con cantidad 3
CALL RealizarVenta(5, 1, 2); -- Venta del Producto 5 al Cliente 1 con cantidad 2




-- EJERCICIOS
DELIMITER //
create procedure infoEmpleados(IN );

DELIMIRER;