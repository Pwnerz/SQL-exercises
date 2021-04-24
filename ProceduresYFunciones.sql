/*1. Escribe un procedimiento que reciba el nombre de un país como
 parámetro de entrada y realice una consulta sobre la tabla cliente 
 para obtener todos los clientes que existen en la tabla de ese país.*/
DELIMITER $$
DROP PROCEDURE IF EXISTS clientes_del_pais$$
CREATE PROCEDURE clientes_del_pais(IN vpais VARCHAR(120))
BEGIN
SELECT * FROM Clientes c WHERE c.pais = vpais;
END $$
/*2.2. Escribe un procedimiento que reciba como parámetro de entrada una 
forma de pago, que será una cadena de caracteres (Ejemplo: PayPal, Transferencia, etc).
 Y devuelva como salida el pago de máximo valor realizado para esa forma de pago. 
Deberá hacer uso de la tabla pago de la base de datos jardineria.*/
DELIMITER $$
DROP PROCEDURE IF EXISTS calcular_maximo_pago$$
CREATE PROCEDURE calcular_maximo_pago(IN vforma_pago VARCHAR(40), OUT vmaximo FLOAT)
BEGIN
SET vmaximo = (
SELECT MAX(Cantidad)
FROM Pagos p
WHERE p.forma_pago= vforma_pago);
END$$
DELIMITER ;
CALL calcular_maximo_pago('PayPal',@vmaximo);
SELECT @vmaximo;
/*Ejercicio 2 con función.*/
DELIMITER $$
DROP FUNCTION IF EXISTS calcular_maximo_pagof$$
CREATE FUNCTION calcular_maximo_pagof(vforma_pago VARCHAR(40), vmaximo FLOAT)
RETURNS FLOAT
BEGIN
SET vmaximo = (
SELECT MAX(Cantidad)
FROM Pagos p
WHERE p.forma_pago= vforma_pago);
RETURN vmaximo;
END$$
CALL calcular_maximo_pagof('PayPal',@maximo);
SELECT @vmaximo;
/*3. Escribe un procedimiento que reciba como parámetro de entrada una forma de pago, que será una cadena de caracteres (Ejemplo: PayPal, Transferencia, etc).
 Y devuelva como salida los siguientes valores teniendo en cuenta la forma de pago seleccionada como parámetro de entrada: • el pago de máximo valor, • el pago de mínimo valor, 
 • el valor medio de los pagos realizados, • la suma de todos los pagos, • el número de pagos realizados para esa forma de pago. Deberá hacer uso de la tabla pago de la base de datos jardineria.*/
 DELIMITER //
 DROP PROCEDURE IF EXISTS valores_payform//
 CREATE PROCEDURE valores_payform(IN vformapago VARCHAR(40), OUT vmaximo FLOAT, OUT vminimo FLOAT, OUT vaverage FLOAT, OUT vsuma FLOAT, OUT vnumpagos INTEGER)
 BEGIN
 CALL calcular_maximo_pago(vformapago,@maximo);
 SET vmaximo = (SELECT @maximo);
 SET vminimo = (SELECT MIN(Cantidad)
FROM Pagos p
WHERE p.forma_pago= vforma_pago);
SET vaverage = (SELECT AVG(Cantidad)
FROM Pagos p
WHERE p.forma_pago= vforma_pago);
SET vsuma = (SELECT SUM(Cantidad)
FROM Pagos p
WHERE p.forma_pago= vforma_pago);
SET vnumpagos = (SELECT COUNT(Cantidad)
FROM Pagos p
WHERE p.forma_pago= vforma_pago);
END//
DELIMITER ;
CALL valores_payform('Paypal',@vmaximo,@vminimo,@vaverage,@vsuma,@vnumpagos);
SELECT @vmaximo,@vminimo,@vaverage,@vsuma,@vnumpagos;
/*Con cursor INTO*/
 DELIMITER //
 DROP PROCEDURE IF EXISTS valores_payform//
 CREATE PROCEDURE valores_payform(IN vformapago VARCHAR(40), OUT vmaximo FLOAT, OUT vminimo FLOAT, OUT vaverage FLOAT, OUT vsuma FLOAT, OUT vnumpagos INTEGER)
 BEGIN
 SELECT MAX(total), MIN(total), AVG(total), SUM(total), COUNT(total) 
 INTO vmaximo, vminimo, vmedia, vsuma, vnum_pagos
FROM Pagos p
WHERE p.forma_pago= vforma_pago;
END//
DELIMITER ;
CALL valores_payform('Paypal',@vmaximo,@vminimo,@vaverage,@vsuma,@vnum_pagos);
SELECT @vmaximo,@vminimo,@vaverage,@vsuma,@vnum_pagos;
/*4.Escribe una función para la base de datos jardineria 
que devuelva el número total de productos que hay en la tabla productos.*/
DELIMITER //
DROP FUNCTION IF EXISTS total_products//
CREATE FUNCTION total_products()
RETURNS INTEGER
BEGIN
DECLARE total INT;
SET total = (SELECT COUNT(*)
FROM Productos);
RETURN total;
END//
DELIMITER ;
SELECT total_products();
/*5.Escribe una función para la base de datos jardinería que devuelva el valor medio del precio de los productos de un determinado fabricante que se recibirá como parámetro de entrada. 
El parámetro de entrada será el nombre del fabricante.*/
DELIMITER //
DROP FUNCTION IF EXISTS valor_medio//
CREATE FUNCTION valor_medio(vfabricante VARCHAR(50))
RETURNS FLOAT
BEGIN
DECLARE vmedio FLOAT;
SET vmedio = (SELECT AVG(PrecioVenta) 
FROM Productos
WHERE Proveedor = vfabricante);
RETURN vmedio; 
END//
DELIMITER ;
CALL valor_medio('Valencia Garden Service');
SELECT @vmedio;
/*6.Crea una base de datos llamada test que contenga una tabla llamada alumno. La tabla debe tener cuatro columnas:*/
DROP DATABASE IF EXISTS test;
CREATE DATABASE test;
USE test;
CREATE TABLE alumno (
ID INT UNSIGNED,
Nombre VARCHAR(50),
Apellido1 VARCHAR(50),
Apellido2 VARCHAR(50),
PRIMARY KEY(ID)
);
DELIMITER //
DROP PROCEDURE IF EXISTS insertar_alumno//
CREATE PROCEDURE insertar_alumno(IN vId INT,IN vnombre VARCHAR(50),IN vapellido1 VARCHAR(50), IN vapellido2 VARCHAR(50), OUT v_error TINYINT)
BEGIN 
    DECLARE CONTINUE HANDLER FOR 1062
        BEGIN 
             SET ERROR = 1;
        END;
    SET ERROR = 0;
    INSERT INTO Alumnos VALUES (vId,vnombre,vapellido1,vapellido2);
END //
DELIMITER ;
CALL insert_alumno(2,'Xiang','Zhou','Xiang',@v_error);
SELECT @v_error;
CALL insertar_alumno(2,'Sara','Perez','Gomez',@v_error);
SELECT @v_error;
/*7.*/
DROP DATABASE IF EXISTS cine;
CREATE DATABASE cine;
CREATE TABLE cuentas(
id_cuenta INT UNSIGNED,
saldo FLOAT UNSIGNED,
PRIMARY KEY(id_cuenta));
CREATE TABLE entradas(
id_butaca INT UNSIGNED,
nif VARCHAR(9),
PRIMARY KEY(id_butaca));
DROP PROCEDURE IF EXISTS comprar_entrada;
DELIMITER //
CREATE PROCEDURE comprar_entrada(IN v_nif VARCHAR(9),IN v_id_cuenta INT UNSIGNED, IN v_id_butaca INT UNSIGNED, OUT v_error BOOL)
BEGIN
DECLARE CONTINUE HANDLER FOR 1264,1062
	BEGIN  
		SET v_error = 1;
	END;
SET v_error = 0;
START TRANSACTION;
UPDATE cuentas SET saldo = saldo-5 WHERE id_cuenta = v_id_cuenta;
INSERT INTO entradas VALUES(v_id_butaca,v_nif);
IF v_error = 1 THEN
    ROLLBACK;
ELSE
    COMMIT;
END IF;
END//
DELIMITER ;
INSERT INTO cuentas VALUES (1,10);
CALL comprar_entradas('0876',1,4,@error);
SELECT * FROM cuentas;
/*Error = 0*/
SELECT @v_error;
/*ERROR 1062.*/
CALL comprar_entradas("nif2",1,4,@v_error);
SELECT @v_error;
/*ERROR 1264.*/
CALL comprar_entradas("002",1,3,@v_error);
SELECT @v_error;

/*Ej.7 con EXIT HANDLER*/
DROP DATABASE IF EXISTS cine;
CREATE DATABASE cine;
CREATE TABLE cuentas(
id_cuenta INT UNSIGNED,
saldo FLOAT UNSIGNED,
PRIMARY KEY(id_cuenta));
CREATE TABLE entradas(
id_butaca INT UNSIGNED,
nif VARCHAR(9),
PRIMARY KEY(id_butaca));
DROP PROCEDURE IF EXISTS comprar_entrada;
DELIMITER //
CREATE PROCEDURE comprar_entrada(IN v_nif VARCHAR(9),IN v_id_cuenta INT UNSIGNED, IN v_id_butaca INT UNSIGNED, OUT v_error BOOL)
BEGIN
DECLARE EXIT HANDLER FOR 1264,1062
	BEGIN  
		SET v_error = 1;
        ROLLBACK;
	END;
SET v_error = 0;
START TRANSACTION;
UPDATE cuentas SET saldo = saldo-5 WHERE id_cuenta = v_id_cuenta;
INSERT INTO entradas VALUES (v_id_butaca,v_nif);
COMMIT;
END//
DELIMITER ;
INSERT INTO cuentas VALUES (1,10);
CALL comprar_entrada('0876',1,4,@error);
SELECT * FROM cuentas;
/*Error = 0*/
SELECT @v_error;
/*ERROR 1062.*/
CALL comprar_entrada("nif2",1,4,@v_error);
SELECT @v_error;
/*ERROR 1264.*/
CALL comprar_entrada("002",1,3,@v_error);
SELECT @v_error;
/*Ejercicio 8*/
DROP DATABASE IF EXISTS test;
CREATE DATABASE test;
USE test;
DROP TABLE IF EXISTS alumnos;
CREATE TABLE alumnos (
ID INT UNSIGNED,
nombre VARCHAR(20) NOT NULL,
apellido1 VARCHAR(20) NOT NULL,
apellido2 VARCHAR(20) NOT NULL,
fecha_nacimiento DATE NOT NULL, 
PRIMARY KEY(ID));
ALTER TABLE alumnos ADD edad INT UNSIGNED;
INSERT INTO alumnos (ID,nombre,apellido1,apellido2,fecha_nacimiento) VALUES (001,"Xiang", "Xiang", "Xiang",1997-06-05);
DROP FUNCTION IF EXISTS calcular_edad;
DELIMITER //
CREATE FUNCTION calcular_edad(vfecha DATE)
RETURNS INT
BEGIN
DECLARE v_edad INT;
SET v_edad = TRUNCATE(DATEDIFF(NOW(),vfecha)/365,0);
RETURN v_edad;
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS actualizar_edad;
DELIMITER //
CREATE PROCEDURE actualizar_edad()
BEGIN
DECLARE vfecha_nacimiento DATE;
DECLARE vedad INT;
DECLARE vid INT;
DECLARE fin INT DEFAULT 0;
DECLARE c1 CURSOR FOR SELECT ID, fecha_nacimiento FROM alumnos;
DECLARE CONTINUE HANDLER FOR NOT FOUND
BEGIN
	SET fin=1;
END;
OPEN c1; 
b1:LOOP
FETCH c1 INTO vid, vfechanacimiento;
IF fin=1 THEN
LEAVE b1;
END IF;
SET vedad = calcular_edad(vfecha_nacimiento);
UPDATE alumnos SET edad=vedad WHERE id=vid;
END LOOP;
CLOSE c1;
END//
DELIMITER ;
CALL actualizar_edad();
SELECT * FROM alumnos;
/*Ejercicio 9*/
ALTER TABLE alumnos ADD email VARCHAR(150);
DELIMITER //
CREATE PROCEDURE crear_email(IN v_nombre VARCHAR(20),IN v_apellido1 VARCHAR (20), IN v_apellido2 VARCHAR(20), IN v_dominio VARCHAR (50), OUT v_email VARCHAR(150))
BEGIN 
SET v_email = LOWER(CONCAT(
SUBSTRING (v_nombre,1,1),
SUBSTRING (v_apellido1, 1, 3),
SUBSTRING (v_apellido2, 1, 3),
'@',
v_dominio));
END //
DELIMITER ;
CALL crear_email('xiang','xiang','xiang','gmail.com',@v_email);
SELECT @v_email;
xxiaxia@gmail.COMMENT 

DELIMITER //

CREATE PROCEDURE actualizar_email (IN v_dominio VARCHAR(50))
BEGIN 
DECLARE fin INT DEFAULT 0; DECLARE v_id INT; DECLARE v_nombre VARCHAR(20); DECLARE v_apellido1 VARCHAR(20); DECLARE v_apellido2 VARCHAR(20);
DECLARE c1 CURSOR FOR SELECT id,nombre,apellido1,apellido2;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = 0;
OPEN c1;
i: LOOP
    FETCH c1 INTO v_id,v_nombre,v_apellido1,v_apellido2;
    IF 
    fin=1 THEN LEAVE b1;
    END IF;
    CALL crear_email(v_nombre,v_apellido1,v_apellido2,v_dominio,@v_email);
    UPDATE alumnos SET email = @v_email WHERE id=v_id;
    END LOOP;
    CLOSE c1;
END//
CALL actualizar_email('educa.madrid.org');
SELECT * FROM alumnos;
/*Ejercicio 10*/
/*Insert trigger.*/
DROP DATABASE IF EXISTS test;
CREATE DATABASE test;
DROP TABLE IF EXISTS test_table;
CREATE TABLE test_table (
ID INT UNSIGNED,
NOMBRE VARCHAR(30) NOT NULL,
APELLIDO1 VARCHAR(30) NOT NULL,
APELLIDO2 VARCHAR(30) NOT NULL,
NOTA FLOAT NOT NULL,
PRIMARY KEY(ID)
);
DELIMITER //
CREATE TRIGGER check_nota_before_insert BEFORE INSERT 
ON test_table FOR EACH ROW 
BEGIN
	IF NEW.NOTA > 10 THEN SET NEW.NOTA = 10;
	END IF;
    IF NEW.NOTA < 0 THEN SET NEW.NOTA = 0;
    END IF;
END//
/*Update trigger.*/
CREATE TRIGGER trigger_check_nota_before_update BEFORE UPDATE
ON test_table FOR EACH ROW
BEGIN
	IF NEW.NOTA > 10 THEN SET NEW.NOTA = 10;
	ELSEIF
    NEW.NOTA < 0 THEN SET NEW.NOTA = 0;
    ELSEIF
    OLD.NOTA > NEW.NOTA THEN SET NEW.NOTA = OLD.NOTA;
    END IF; 
END//