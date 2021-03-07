/*Deshabilitar el autocommit*/
SET autocommit=0;
/*Marcamos el ISOLATION LEVEL como serializable.*/
SET GLOBAL TRANSACTION ISOLATION LEVEL SERIALIZABLE;
/*Lockeamos la tabla Clientes para escritura.*/
LOCK TABLE Clientes WRITE;
/*Comenzamos una transaccion.*/
BEGIN;
/*Insertamos en la tabla Clientes con los siguientes valores.*/
INSERT INTO Clientes VALUES (CodigoCliente, NombreCliente, NombreContacto, ApellidoContacto, Telefono, Fax, LineaDireccion1, Ciudad) 
(39,"Xiang", 'Xiangcito','Son', 234234234,2342342,'Madrid','Madrid');
/*Updateamos el siguiente registro de la tabla clientes.*/
UPDATE Clientes SET Fax = (SELECT Fax FROM (SELECT * FROM Clientes) AS c WHERE CodigoCliente = 38) WHERE CodigoCliente = 39;
/*Borramos un registro.*/
DELETE FROM Clientes WHERE CodigoCliente = 39;
/*Hacemos commit a la transaccion.*/
COMMIT;
/*Unlockeamos las tablas.*/
UNLOCK TABLES;
