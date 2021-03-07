#Borro base de datos si existe.
DROP Database IF EXISTS ASBjardineria2;
#Creo base de datos
CREATE database ASBjardineria2;
#Selecciona la base de datos
USE ASBjardineria2;
#Borra la tabla si existe
DROP table IF EXISTS Oficinas;
CREATE TABLE Oficinas (
    CodigoOficina VARCHAR(10) NOT NULL,
    Ciudad VARCHAR(50) NOT NULL,
    Pais VARCHAR(50) NOT NULL,
    Region VARCHAR(50) DEFAULT NULL,
    CodigoPostal VARCHAR(10) NOT NULL,
    Telefono VARCHAR(20) NOT NULL,
    LineaDireccion1 VARCHAR(50) NOT NULL,
    LineaDireccion2 VARCHAR(50) DEFAULT NULL,
    PRIMARY KEY (CodigoOficina)
)  ENGINE=INNODB;
#Borra la tabla si existe
DROP table IF EXISTS Empleados;
CREATE TABLE Empleados (
    CodigoEmpleado INT(11) NOT NULL,
    Nombre VARCHAR(50) NOT NULL,
    Apellido1 VARCHAR(50) NOT NULL,
    Apellido2 VARCHAR(50) DEFAULT NULL,
    Extension VARCHAR(10) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    CodigoOficina VARCHAR(10) NOT NULL,
    CodigoJefe INT(11) DEFAULT NULL,
    Puesto VARCHAR(50) DEFAULT NULL,
    PRIMARY KEY (CodigoEmpleado),
    CONSTRAINT Empleados_OficinasFK FOREIGN KEY (CodigoOficina)
        REFERENCES Oficinas (CodigoOficina),
    CONSTRAINT Empleados_EmpleadosFK FOREIGN KEY (CodigoJefe)
        REFERENCES Empleados (CodigoEmpleado)
)  ENGINE=INNODB;
#Borra la tabla si existe.
DROP table IF EXISTS GamasProductos;
CREATE TABLE GamasProductos (
    Gama VARCHAR(50) NOT NULL,
    DescripcionTexto TEXT,
    DescripcionHTML TEXT,
    Imagen BLOB,
    PRIMARY KEY (Gama)
)  ENGINE=INNODB;
#Borra la tabla si existe.
DROP table IF EXISTS Clientes;
CREATE TABLE Clientes (
    CodigoCliente INT(11) NOT NULL,
    NombreCliente VARCHAR(50) NOT NULL,
    NombreContacto VARCHAR(30) DEFAULT NULL,
    ApellidoContacto VARCHAR(30) DEFAULT NULL,
    Telefono VARCHAR(15) NOT NULL,
    Fax VARCHAR(15) NOT NULL,
    LineaDireccion1 VARCHAR(50) NOT NULL,
    LineaDireccion2 VARCHAR(50) DEFAULT NULL,
    Ciudad VARCHAR(50) NOT NULL,
    Region VARCHAR(50) DEFAULT NULL,
    Pais VARCHAR(50) DEFAULT NULL,
    CodigoPostal VARCHAR(10) DEFAULT NULL,
    CodigoEmpleadoRepVentas INT(11) DEFAULT NULL,
    LimiteCredito NUMERIC(15 , 2 ) DEFAULT NULL,
    PRIMARY KEY (CodigoCliente),
    CONSTRAINT Clientes_EmpleadosFK FOREIGN KEY (CodigoEmpleadoRepVentas)
        REFERENCES Empleados (CodigoEmpleado)
)  ENGINE=INNODB;
#Borra la tabla si existe.
DROP table IF EXISTS Pedidos;
CREATE TABLE Pedidos (
    CodigoPedido INT(11) NOT NULL,
    FechaPedido DATE NOT NULL,
    FechaEsperada DATE NOT NULL,
    FechaEntrega DATE DEFAULT NULL,
    Estado VARCHAR(15) NOT NULL,
    Comentarios TEXT,
    CodigoCliente INT(11) NOT NULL,
    PRIMARY KEY (CodigoPedido),
    CONSTRAINT Pedidos_Cliente FOREIGN KEY (CodigoCliente)
        REFERENCES Clientes (CodigoCliente)
)  ENGINE=INNODB;
#Borra la tabla si existe.
DROP table IF EXISTS Productos ;
CREATE TABLE Productos (
    CodigoProducto VARCHAR(15) NOT NULL,
    Nombre VARCHAR(70) NOT NULL,
    Gama VARCHAR(50) NOT NULL,
    Dimensiones VARCHAR(25) NULL,
    Proveedor VARCHAR(50) DEFAULT NULL,
    Descripcion TEXT NULL,
    CantidadEnStock SMALLINT(6) NOT NULL,
    PrecioVenta NUMERIC(15 , 2 ) NOT NULL,
    PrecioProveedor NUMERIC(15 , 2 ) DEFAULT NULL,
    PRIMARY KEY (CodigoProducto),
    CONSTRAINT Productos_gamaFK FOREIGN KEY (Gama)
        REFERENCES GamasProductos (Gama)
)  ENGINE=INNODB;
#Borra la tabla si existe.
DROP table IF EXISTS DetallePedidos ;
CREATE TABLE DetallePedidos (
    CodigoPedido INT(11) NOT NULL,
    CodigoProducto VARCHAR(15) NOT NULL,
    Cantidad INT(11) NOT NULL,
    PrecioUnidad NUMERIC(15 , 2 ) NOT NULL,
    NumeroLinea SMALLINT(6) NOT NULL,
    PRIMARY KEY (CodigoPedido , CodigoProducto),
    CONSTRAINT DetallePedidos_PedidoFK FOREIGN KEY (CodigoPedido)
        REFERENCES Pedidos (CodigoPedido),
    CONSTRAINT DetallePedidos_ProductoFK FOREIGN KEY (CodigoProducto)
        REFERENCES Productos (CodigoProducto)
)  ENGINE=INNODB;
#Borra la tabla si existe.
DROP table IF EXISTS Pagos  ;
CREATE TABLE Pagos (
    CodigoCliente INT(11) NOT NULL,
    FormaPago VARCHAR(40) NOT NULL,
    IDTransaccion VARCHAR(50) NOT NULL,
    FechaPago DATE NOT NULL,
    Cantidad NUMERIC(15 , 2 ) NOT NULL,
    PRIMARY KEY (CodigoCliente , IDTransaccion),
    CONSTRAINT Pagos_clienteFK FOREIGN KEY (CodigoCliente)
        REFERENCES Clientes (CodigoCliente)
)  ENGINE=INNODB;
#Cambio de datos de la tabla Clientes.
DESCRIBE Clientes;
ALTER TABLE Clientes CHANGE Telefono TelefonoMovil VARCHAR(15) NOT NULL;
ALTER TABLE Clientes ADD TelefonoFijo VARCHAR(15) AFTER TelefonoMovil;
ALTER TABLE Clientes CHANGE LineaDireccion1 Direccion1 VARCHAR(50);
ALTER TABLE Clientes CHANGE LineaDireccion2 Direccion2 VARCHAR(50);
ALTER TABLE Clientes ALTER Pais SET DEFAULT 'Spain';
ALTER TABLE Clientes ADD CONSTRAINT Const_countryCheck CHECK (Pais LIKE 'USA'OR'Spain'OR'France'OR'Australia'OR'United Kingdom');
CREATE INDEX idx_telefonoMovil ON Clientes (TelefonoMovil);
CREATE VIEW v_PaisNombreMovil AS
    SELECT 
        Pais, NombreCliente, TelefonoMovil
    FROM
        Clientes
    ORDER BY Pais ASC;
DESCRIBE Clientes;
#Cambio de datos de la tabla Empleados.
DESCRIBE Empleados;
ALTER TABLE Empleados ADD Telefono VARCHAR(15) AFTER Apellido2;
ALTER TABLE Empleados ADD CONSTRAINT Const_puestoCheck CHECK (Puesto IN('Director General','Subdirector Marketing','Subdirector Ventas','Secretaria','Representante Ventas','Director Oficina'));
CREATE VIEW V_NombrePuesto AS
    SELECT 
        Apellido1, Apellido2, Nombre, Puesto
    FROM
        Empleados
    ORDER BY Apellido1 ASC;
DESCRIBE Empleados;
#Cambio de datos de la tabla Oficinas.
DESCRIBE Oficinas;
ALTER TABLE Oficinas CHANGE LineaDireccion1 Direccion1 VARCHAR(50);
ALTER TABLE Oficinas CHANGE LineaDireccion2 Direccion2 VARCHAR(50);
ALTER TABLE Oficinas ADD CONSTRAINT Const_countryOfficeCheck CHECK (Pais LIKE 'España'OR'EEUU'OR'France'OR'Australia'OR'Inglaterra'OR'Japón');
CREATE VIEW V_PaisTelDir AS
    SELECT 
        Pais, Telefono, Direccion1
    FROM
        Oficinas
    ORDER BY Pais ASC;
#Cambiamos el nombre de la tabla de GamasProductos.
SHOW tables;
ALTER TABLE GamasProductos RENAME TO Gama;
SHOW tables;
#Creación de usuarios y adjudicación de privilegios:
#Eliminamos los usuarios en caso de que existan.
DROP USER 'adminASB'@'localhost';
DROP USER 'consultASB'@'localhost';
FLUSH PRIVILEGES;
#Creamos los usuarios (admin con todos los privilegios y consult con solo privilegios para seleccionar) y adjudicamos los privilegios. Flusheamos para actualizar.
CREATE USER 'adminASB'@'localhost' IDENTIFIED BY 'jamonyork';
CREATE USER 'consultASB'@'localhost' IDENTIFIED BY 'pan';
GRANT ALL PRIVILEGES ON ASBjardineria2.* TO 'adminASB'@'localhost';
GRANT SELECT ON ASBjardineria2.* TO 'consultASB'@'localhost';
FLUSH PRIVILEGES;
