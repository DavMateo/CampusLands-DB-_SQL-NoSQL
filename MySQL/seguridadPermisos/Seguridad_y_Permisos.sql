-- -------------------- --
-- Seguridad y Permisos --
-- -------------------- --

SELECT user, host FROM mysql.user;

/* Operaciones básicas para crear y dar permisos a un usuario
- Al crear un nuevo usuario, este solo recibirá permisos básicos
*/
create user 'cacas'@localhost identified by 'cacas2024';
	#Creación del nuevo usuario.

grant select, insert, update on prueba.* to 'cacas'@localhost;
	#Con grant se le puede dar a un usuario uno o más opciones de modificación. SINTAXIS: GRANT permissions ON database.table TO 'username'@localhost;

show grants for 'cacas'@localhost;
	#Muestra los privilegios que tiene sobre una base de datos en específico.

drop user 'cacas'@localhost;
	#Elimina un usuario en específico.
    
grant insert on prueba.empleado to 'cacas'@localhost;
	#Especificando un nuevo permiso a una tabla específica sobre una base de datos determinada relacionada a un usuario con el objetivo de eliminarle
    #luego ese permiso puntual.
    
revoke insert on prueba.empleado from 'cacas'@localhost;
	#Remueve al usuario uno o más permisos sobre una tabla determinada almacenada en una base de datos especificada. Se debe hacerlo puntualmente con GRANT.
    #SINTAXIS: REVOKE permission ON database.table FROM 'username'@localhost;
grant usage on prueba.* to 'cacas'@localhost;

alter user 'cacas'@'localhost' with max_queries_per_hour 100;
	#Se define un permiso de uso sobre la base de datos prueba para todas las tablas al usuario 'cacas'.
		#SINTAXIS: GRANT USAGE ON database.table TO 'username'@localhost;
    #El alter user especifica el usuario al cuál se le dará un límite de consultas por hora.
		#SINTAXIS: ALTER USER 'username'@'routeConnection' WITH MAX_QUERIES_PER_HOUR numberQueriesMax.


select user, host 
from mysql.user
where user = '';
	#Identifica los usuarios anónimos registrados en mysql.

drop user ''@localhost;
	#Elimina un usuario anónimo o sin nombre.

alter user 'cacas'@localhost identified by 'C@c@$2024';
	#Permite cambiar una contraseña de un usuario por otra más robusta.

revoke all privileges on *.* from 'cacas'@localhost;
grant select on prueba.* to 'cacas'@localhost;

create user 'admin'@'%' identified by 'campus2024';
grant all privileges on *.* to 'admin'@'%' with grant option;
	#Se crea el usuario 'admin' a nivel global (local y remoto) bajo la contraseña 'campus2024'.
		#SINTAXIS: CREATE USER 'username'@'access' IDENTIFIED BY 'password'
	#Luego sobre ese nuevo usuario, se le asignan todos los privilegios posibles a todas las bases de datos con permisos administrador.
		#SINTAXIS: GRANT ALL PRIVILEGES ON database.table TO 'username'@'access' WITH GRANT OPTION.



#Recargar los privilegios del servidor para aplicar cambios
FLUSH PRIVILEGES;


#Comandos para especificar desde dónde se conecta el usuario.
GRANT UPDATE, INSERT, SELECT ON mundo.pais TO 'campus'@'%.campusland.com';
CREATE USER 'user2'@'%.campusland.com' IDENTIFIED BY 'Campus2023;';
GRANT UPDATE, INSERT, SELECT ON campus.* TO 'user2'@'%.campusland.com';
flush privileges;  #Forzar a que el servidor aplique los comandos especificados anteriormente. 

/* Especificación de Bases de Datos y Tablas
.  -->  Todas las bases de datos y tablas
base.*  -->  Todas las tablas de una base de datos específica
base.tabla  -->  Tabla específica de una base de datos específica
*/


-- ----------------- --
-- Prepare & Execute --
-- ----------------- --
use world;
select * from city where countrycode = 'COL';

-- Evita la inyección de sql a la consulta anterior:
prepare stmt from 'select * from city where countrycode = ?';

set @pais = 'COL';  #Variable 'pais' con el valor 'COL'.
execute stmt using @pais;

deallocate prepare stmt;
/*
Prepare: Crea una versión preparada de la sentencia SQL.
Execute: Ejecuta la sentencia preparada. Solo recibe un parámetro, todo código SQL no se ejecutará.

Después de realizar la consulta preparada, es una BUENA PRÁCTICA deshacer esa consulta preparada.
*/