use aeropuerto;

CREATE TABLE aeropuerto(
	codigo_aero int unsigned primary key,
    ciudad_aero varchar(100) not null,
    prov_aero varchar(255) not null,
    nombre_aero varchar(255) not null,
    horaSalidaProg datetime not null,
    horaLlegadaProg datetime not null,
    horaSal datetime not null,
    horaLleg datetime not null
);

CREATE TABLE tipoAvion(
	nombre_avTipo varchar(100) primary key,
    maxAsientos_avTipo int unsigned not null,
    compañia_avTipo varchar(100) not null
);

/* Tabla intermedia entre la tabla de aeropuerto con la de tipoAvion: */
CREATE TABLE puede_aterrizar(
	aeropuerto_codigoAero int unsigned,
    tipoAvion_nombreAvTipo varchar(100) not null,
    PRIMARY key(aeropuerto_codigoAero, tipoAvion_nombreAvTipo),
    FOREIGN key(aeropuerto_codigoAero) REFERENCES aeropuerto(codigo_aero),
    FOREIGN key(tipoAvion_nombreAvTipo) REFERENCES tipoAvion(nombre_avTipo)
);

CREATE TABLE avion(
	id_avion int unsigned primary key,
    numTotalAsientos_avion int unsigned not null,
    tipoAvion_nombreAvTipo varchar(100) not null,
    FOREIGN key(tipoAvion_nombreAvTipo) REFERENCES tipoAvion(nombre_avTipo)
);

CREATE TABLE instanciaPlan(
	fecha_instPl date primary key,
    numPlazasDisponibles_instPl int unsigned not null,
    nombreCliente varchar(150) not null,
    telefonoCliente varchar(16) not null,
    horaSal datetime not null,
    horaLleg datetime not null,
    
    /* Declaración Foreign key */
    avion_idAvion int unsigned not null,
    aeropuerto_codigoAero int unsigned not null,
    planVuelo_numPlanPvuelo int unsigned not null,
    FOREIGN key(avion_idAvion) REFERENCES avion(id_avion),
    FOREIGN key(aeropuerto_codigoAero) REFERENCES aeropuerto(codigo_aero),
    FOREIGN key(planVuelo_numPlanPvuelo) REFERENCES planVuelo(numPlan_pvuelo)
);

CREATE TABLE plaza(
	num_plaza int unsigned primary key,
    nombreCliente varchar(150) not null,
    telefonoCliente varchar(16) not null,
    instanciaPlan_fechaInstPl date not null,
    FOREIGN key(instanciaPlan_fechaInstPl) REFERENCES instanciaPlan(fecha_instPl)
);

CREATE TABLE planVuelo(
	numPlan_pvuelo int unsigned primary key,
    horaSalidaProg datetime not null,
    horaLlegadaProg datetime not null,
    vuelo_numeroVuelo int unsigned not null,
    aeropuerto_codigoAero int unsigned not null,
    FOREIGN key(vuelo_numeroVuelo) REFERENCES vuelo(numero_vuelo),
    FOREIGN key(aeropuerto_codigoAero) REFERENCES aeropuerto(codigo_aero)
);

CREATE TABLE vuelo(
	numero_vuelo int unsigned primary key,
    aerolinea_vuelo varchar(100) not null,
    diasSem_vuelo int unsigned not null
);

CREATE TABLE tarifa(
	codigo_tar int unsigned primary key,
    cantidad_tar int unsigned not null,
    restricciones varchar(255) not null,
    vuelo_numeroVuelo int unsigned not null,
    FOREIGN key(vuelo_numeroVuelo) REFERENCES vuelo(numero_vuelo)
);