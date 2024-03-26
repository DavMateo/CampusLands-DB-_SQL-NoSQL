create database estoyCansadoJefe;
use estoyCansadoJefe;

-- -------------------- --
-- NORMALIZACIÓN EN LAS --
--    BASES DE DATOS    --
-- -------------------- --



-- EJERCICIO n°1:
/* Tabla Original
CREATE TABLE estudiante(
	id INT,
    nombre VARCHAR(100),
    telefonos VARCHAR(255)
);
*/

CREATE TABLE estudiante(
	id INT UNSIGNED PRIMARY KEY,
    id_nombreEstudiante INT UNSIGNED NOT NULL,
    id_telefonoEstudiante INT UNSIGNED NOT NULL,
    FOREIGN KEY(id_nombreEstudiante) REFERENCES nombreEstudiante(id),
    FOREIGN KEY(id_telefonoEstudiante) REFERENCES telefonoEstudiante(id)
);

CREATE TABLE nombreEstudiante(
	id INT UNSIGNED PRIMARY KEY,
    nombre1 VARCHAR(50) NOT NULL,
    nombre2 VARCHAR(50),
    apellido1 VARCHAR(50) NOT NULL,
    apellido2 VARCHAR(50)
);

CREATE TABLE telefonoEstudiante(
	id INT UNSIGNED PRIMARY KEY,
    indicadorPais INT UNSIGNED,
    telefono INT UNSIGNED
);


-- EJERCICIO n°2
/* Tabla Original
CREATE TABLE cursoEstudiante(
	cursoID INT,
    estudianteID INT,
    nombreCurso VARCHAR(100),
    nombreEstudiante VARCHAR(100),
    PRIMARY KEY(cursoID, estudianteID)
);
*/

CREATE TABLE cursoEstudiante(
	cursoID INT PRIMARY KEY,
    id_infoEstudiante INT UNSIGNED NOT NULL,
    id_nombreCurso INT UNSIGNED NOT NULL,
    PRIMARY KEY(id_infoEstudiante, id_nombreCurso),
    FOREIGN KEY(id_infoEstudiante) REFERENCES infoEstudiante(id),
    FOREIGN KEY(id_nombreCurso) REFERENCES nombreCurso(id)
);

CREATE TABLE infoEstudiante(
	id INT UNSIGNED PRIMARY KEY,
    nombre1 VARCHAR(50) NOT NULL,
    nombre2 VARCHAR(50),
    apellido1 VARCHAR(50) NOT NULL,
    apellido2 VARCHAR(50)
);

CREATE TABLE nombreCurso(
	id INT UNSIGNED PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL
);


-- EJERCICIO n°3
/* Tabla Original
CREATE TABLE profesor(
	profesorID int,
    nombre VARCHAR(100),
    departamentoID int,
    nombreDepartamento VARCHAR(100)
);
*/

CREATE TABLE profesor(
	id INT UNSIGNED PRIMARY KEY,
    id_nombreProf INT UNSIGNED NOT NULL,
    id_departamento INT UNSIGNED NOT NULL,
    FOREIGN KEY(id_nombreProf) REFERENCES nombreProf(id),
    FOREIGN KEY(id_departamento) REFERENCES departamento(id)
);

CREATE TABLE nombreProf(
	id INT UNSIGNED PRIMARY KEY,
    nombre1 VARCHAR(50) NOT NULL,
    nombre2 VARCHAR(50),
    apellido1 VARCHAR(50) NOT NULL,
    apellido2 VARCHAR(50)
);

CREATE TABLE departamento(
	id INT UNSIGNED PRIMARY KEY,
    nombre VARCHAR(75) NOT NULL,
    tipo VARCHAR(75) NOT NULL
);



-- EJERCICIO n°4
/* Tabla Original
CREATE TABLE asignacion(
	profesorID INT,
    cursoID INT,
    horario VARCHAR(50),
    PRIMARY KEY(profesorID, cursoID)
);
*/

CREATE TABLE asignacion(
	id INT UNSIGNED
);

CREATE TABLE profesorAsig(
	id INT UNSIGNED PRIMARY KEY,
    # Nombres y Apellidos del profesor
    primerNombre VARCHAR(50) NOT NULL,
    segundoNombre VARCHAR(50),
    primerApellido VARCHAR(50) NOT NULL,
    segundoApellido VARCHAR(50),
    # Teléfono del Profesor
    prefijoTel INT UNSIGNED,
    telefono INT UNSIGNED,
    # Correo del Profesor
    correo VARCHAR(50)
);




-- EJERCICIO n°5
