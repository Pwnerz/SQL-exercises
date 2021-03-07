/*Deshabilitar el autocommit*/
SET autocommit=0;

SET GLOBAL TRANSACTION ISOLATION LEVEL SERIALIZABLE;

LOCK TABLE Clientes WRITE;

BEGIN;

INSERT INTO Clientes VALUES (CodigoCliente, NombreCliente, NombreContacto, ApellidoContacto, Telefono, Fax, LineaDireccion1, Ciudad) 
(39,"Xiang", 'Xiangcito','Son', 234234234,2342342,'Madrid','Madrid');

UPDATE Clientes SET Fax = (SELECT Fax FROM (SELECT * FROM Clientes) AS c WHERE CodigoCliente = 38) WHERE CodigoCliente = 39;

DELETE FROM Clientes WHERE CodigoCliente = 39;

COMMIT;

UNLOCK TABLES;