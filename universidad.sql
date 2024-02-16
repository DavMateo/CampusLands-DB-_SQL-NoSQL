use universidad;

CREATE TABLE profesores(
	dni_profe int unsigned primary key,
    nombre_profe varchar(100) not null,
    direccion_profe varchar(200) not null,
    telefono_profe varchar(16) not null
);

CREATE TABLE modulo(
	codigo_mod int unsigned primary key,
    nombre_mod varchar(100) not null,
    dni_profe int unsigned not null,
    FOREIGN key(dni_profe) REFERENCES profesores(dni_profe)
);

CREATE TABLE modulo_has_alumno(
	codigo_mod int unsigned,
    numExpediente_estu int unsigned,
    PRIMARY key(codigo_mod, numExpediente_estu),
    FOREIGN key(codigo_mod) REFERENCES modulo(codigo_mod),
    FOREIGN key(numExpediente_estu) REFERENCES alumno(numExpediente_estu)
);

CREATE TABLE alumno(
	numExpediente_estu int unsigned primary key,
    nombre_estu varchar(100) not null,
    apellidos_estu varchar(100) not null,
    fechaNacimiento_estu date not null,
    numExped_estu int unsigned,
    FOREIGN key(numExped_estu) REFERENCES alumno(numExpediente_estu)
);