/*1.Crear una tabla temporal llamada “TempClientes” que contenga todos los datos de la tabla Clientes.*/
CREATE TABLE TempClientes AS SELECT * FROM Clientes; 
INSERT INTO TempClientes SELECT * FROM Clientes; 
/*2.Desactivar el autocommit.*/
SET AUTOCOMMIT=0;
/*3.Consultar el número de registros de la tabla.*/
SELECT *
FROM TempClientes;
/*4.Empezar una transacción.*/
BEGIN;
/*5.Insertar el siguiente registro:*/
INSERT INTO TempClientes (CodigoCliente,NombreCliente,NombreContacto,ApellidoContacto,Telefono,Fax,LineaDireccion1,Ciudad,Region,Pais,CodigoPostal,CodigoEmpleadoRepVentas,LimiteCredito) 
VALUES (39, 'Mi Empresa S.A','Juan','Moreno',34912345678,34123456789,'C/Puerta del Angel, 7','Madrid','Madrid','Spain',28013,8,153240);
/*6.Consultar el registro insertado.*/
SELECT *
FROM TempClientes 
WHERE CodigoCliente = 39;
/*7.Deshacer la transacción.*/
ROLLBACK;
/*8.Consultar que el registro insertado no ha sido insertado.*/
SELECT *
FROM TempClientes 
WHERE CodigoCliente = 39;
/*9.Volver a insertar el registro.*/
BEGIN;
INSERT INTO TempClientes (CodigoCliente,NombreCliente,NombreContacto,ApellidoContacto,Telefono,Fax,LineaDireccion1,Ciudad,Region,Pais,CodigoPostal,CodigoEmpleadoRepVentas,LimiteCredito) 
VALUES (39, 'Mi Empresa S.A','Juan','Moreno',34912345678,34123456789,'C/Puerta del Angel, 7','Madrid','Madrid','Spain',28013,8,153240);
/*10.Consultar que el registro ha sido insertado.*/
SELECT *
FROM TempClientes 
WHERE CodigoCliente = 39;
/*11.Confirmar la transacción.*/
COMMIT;
/*12.Consultar que el registro ha sido insertado.*/
SELECT *
FROM TempClientes 
WHERE CodigoCliente = 39;
/*13.Empezar otra transacción para modificar el registro insertado.*/
BEGIN;
UPDATE TempClientes
SET Fax = 3491543256785
WHERE CodigoCliente = 39;
/*15.Consultar el valor que tienen Fax.*/
 SELECT Fax
 FROM TempClientes
 WHERE CodigoCliente = 39;
 /*16.	Deshacer la transacción.*/
 ROLLBACK;
 /*17.	Consultar el valor de Fax.*/
 SELECT Fax
 FROM TempClientes
 WHERE CodigoCliente = 39;
 /*18.	Modificar de nuevo Fax con el valor 3491543256785*/
 BEGIN;
 UPDATE TempClientes
 SET Fax = 3491543256785
 WHERE CodigoCliente = 39;
 /*19.	Consultar su valor.*/
 SELECT Fax
 FROM TempClientes
 WHERE CodigoCliente = 39;
 /*20.Confirmar la transacción.*/
 COMMIT;
 /*21.	Volver a verificar el valor de Fax.*/
 SELECT Fax
 FROM TempClientes
 WHERE CodigoCliente = 39;
 /*22.	Empezar una transacción.*/
 BEGIN;
/*23.Eliminar el registro insertado.*/
DELETE FROM TempClientes
WHERE CodigoCliente = 39;
/*24.Verificar que el registro ha sido eliminado.*/
SELECT *
 FROM TempClientes
 WHERE CodigoCliente = 39;
/*25.Deshacer la transacción.*/
ROLLBACK;
/*26.Volver a eliminar el registro.*/
BEGIN;
DELETE FROM TempClientes
WHERE CodigoCliente = 39;
/*27.Verificar que ha sido eliminado.*/
SELECT *
 FROM TempClientes
 WHERE CodigoCliente = 39;
/*28.Confirmar la transacción.*/
COMMIT;
/*29.Verificar que el registro no existe y que el número de registros de la tabla es el mismo que al principio.*/
SELECT *
FROM TempClientes
WHERE CodigoCliente = 39;
SELECT COUNT(*) 
FROM TempClientes;
/*30.Eliminar la tabla temporal.*/
DROP TABLE TempClientes;
/*-----------------------------------------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------------------------------------------*/
/*Deshabilitar el autocommit*/
SET autocommit=0;
/*Marcamos el ISOLATION LEVEL como serializable.*/
SET GLOBAL TRANSACTION ISOLATION LEVEL SERIALIZABLE;
/*Lockeamos la tabla Clientes para escritura.*/
LOCK TABLE Clientes WRITE;
/*Comenzamos una transaccion.*/
BEGIN;
/*Insertamos en la tabla Clientes con los siguientes valores.*/
INSERT INTO Clientes (CodigoCliente, NombreCliente, NombreContacto, ApellidoContacto, Telefono, Fax, LineaDireccion1, Ciudad) 
VALUES (39,"Xiang", 'Xiangcito','Son', 234234234,2342342,'Madrid','Madrid');
/*Updateamos el siguiente registro de la tabla clientes.*/
UPDATE Clientes SET Fax = (SELECT Fax FROM (SELECT * FROM Clientes) AS c WHERE CodigoCliente = 38) WHERE CodigoCliente = 39;
/*Borramos un registro.*/
DELETE FROM Clientes WHERE CodigoCliente = 39;
/*Hacemos commit a la transaccion.*/
COMMIT;
/*Unlockeamos las tablas.*/
UNLOCK TABLES;
