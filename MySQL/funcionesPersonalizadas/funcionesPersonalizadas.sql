-- ------------------------------------------- --
-- Funciones Definidas por el Usuario en MySQL --
-- ------------------------------------------- --


/* Importancia
- Eficiencia y reusabilidad: Reutilizar código
- Mantenibilidad: Centraliza la lógica
- Claridad y Legibilidad: Encapsular operaciones complejas

SINTAXIS
CREATE FUNCTION nombre_funcion(parametros)
RETURNS tipo_retorno
BEGIN
	-- Cuerpo de la función
    RETURN valor;
END

EJEMPLO:
*/

create database funcionesPersonalizadas;
use funcionesPersonalizadas;


DELIMITER $$
CREATE FUNCTION calcularAreaCirculo(radio DOUBLE)
RETURNS DOUBLE  #El tipo de dato que va a retornar la función. 
DETERMINISTIC  #El resultado siempre va a ser igual. 
BEGIN
	DECLARE area DOUBLE;
    SET area = PI() * radio * radio;
    RETURN area;  #Salida de la función. 
END$$
DELIMITER ;
select calcularAreaCirculo(10) 'Area Circulo';


-- Función que me devuelva la clasificación de una película según su edad
delimiter $$
create function clasificarPelicula(edad int)
returns varchar(30)
deterministic
begin
	if edad < 13 then
		return "Para niños";
	elseif edad < 18 then
		return "Para adolecentes";
	else
		return "Para adultos";
	end if;
end$$
delimiter ;

select nombre, clasificarPelicula(edad) as Clasificación
	from pelicula;

select clasificarPelicula(12) 'Clasificación';


-- Crear una función para calcular el factorial de un número
delimiter $$
create function factorial(numero int)
returns int 
deterministic
begin
	declare f int default 1;
    while numero > 1 do
		set f = f * numero;
        set numero = numero - 1;
    end while;
    return f;
end$$
delimiter ;
select format(factorial(10), 0) Factorial;


use miPrimeraBaseDeDatos;
-- Crear una función que devuelva el nombre del coche más antiguo
delimiter $$
create function menorKilometros()
returns double
deterministic
begin
	declare kilometrosCarro double;
    select kilometros into kilometrosCarro
		from coches
        order by kilometros asc
        limit 1;
	return kilometrosCarro;
end$$
delimiter ;

select *
	from coches
    where kilometros = menorKilometros();



use tienda;
-- Función que calcula un descuento al precio
drop function calcularDescuento;

delimiter $$
create function calcularDescuento(valor decimal(10,2), porc decimal(10,2))
returns decimal(10,2)
deterministic
begin
	if porc > 0 and porc <= 100 then
		return valor * (porc / 100);
	elseif porc > 100 then
		return valor;
	else
		return 0;
	end if;
end$$
delimiter ;
   
set @proc = 25;
select nombre, precio, calcularDescuento(precio, @proc) as descuento, precio - calcularDescuento(precio, @proc) as "Precio final"
	from producto;

-- Función de Cálculo de Promedios
CREATE TABLE ventas(
	id INT AUTO_INCREMENT,
    vendedir_id INT,
    monto_venta DECIMAL(10,2),
    PRIMARY KEY (id)
);
SELECT promedioVentas(123) as promedioVentasVendedor;



/* Función calcular el descuento dependiendo de la categoría del cliente

- Creación de la función para calcular el descuento teniendo en cuenta la categoría del cliente.
- Se da la estructura y la consulta:
*/
CREATE TABLE ordenes(
	id INT AUTO_INCREMENT,
    cliente_id INT,
    precio DECIMAL(10,2),
    categoria_cliente VARCHAR(10),
    PRIMARY KEY(id)
);

delimiter $$
create function calcularDescuentoProducto(precio decimal(10,2), categoriaCliente varchar(1))
returns decimal(10,2)
deterministic
begin
	if upper(categoriaCliente) = 'A' then
		return precio * (10 / 100);
	elseif upper(categoriaCliente) = 'B' then
		return precio * (20 / 100);
	elseif upper(categoriaCliente) = 'C' then
		return precio * (35 / 100);
	elseif upper(categoriaCliente) = 'D' then
		return precio * (50 / 100);
	else
		return 0;
	end if;
end$$
delimiter ;

SELECT calcularDescuentoProducto(precio, categoria_cliente) as precioFinal
	FROM ordenes;



-- ------------------------------------------------ --
-- Funciones Determinísticas vs. No Determinísticas --
-- ------------------------------------------------ --
delimiter $$
CREATE FUNCTION horaActualFormato()
RETURNS VARCHAR(100)
NOT DETERMINISTIC
BEGIN
	RETURN CONCAT('La hora actual es: ', CURRENT_TIME());
END$$;
delimiter ;


-- Función de división entre 0
use prueba;
drop function dividir;

delimiter $$
create function dividir(dividendo double, divisor double)
returns double
deterministic
begin
	if divisor = 0 then
		signal sqlstate '45000' set message_text = 'Error. División por cero no permitida.';
	end if;
	return dividendo / divisor;
end$$
delimiter ;

select dividir(6, 0) as resultado;