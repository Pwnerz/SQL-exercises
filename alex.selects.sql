/*Subconsultas
Ejercicio 1:
Obtener el nombre del producto más caro. Realizar el ejercicio como una subconsulta y luego como una consulta simple para que dicha consulta sea más eficiente.*/
SELECT 
    Nombre
FROM
    Productos
WHERE
    PrecioVenta = (SELECT 
            MAX(PrecioVenta)
        FROM
            Productos);
/*Consulta Simple*/
SELECT 
    Nombre
FROM
    Productos
GROUP BY 1
ORDER BY MAX(PrecioVenta) DESC
LIMIT 1;
/*Ejercicio 2:
Obtener el nombre del producto del que más unidades se hayan vendido en un mismo pedido.*/
SELECT 
    Nombre
FROM
    Productos
WHERE
    CodigoProducto = (SELECT 
            CodigoProducto
        FROM
            DetallePedidos
        ORDER BY Cantidad DESC
        LIMIT 1);
/*Ejercicio 3:
Obtener el nombre de los clientes que hayan hecho pedidos en 2008.*/
SELECT 
    NombreCliente
FROM
    Clientes
WHERE
    CodigoCliente IN (SELECT 
            CodigoCliente
        FROM
            Pedidos
        WHERE
            YEAR(FechaPedido) = 2008);
/*Ejercicio 4:Obtener los clientes que han pedido más de 200 unidades de cualquier producto.*/
SELECT 
    NombreCliente
FROM
    Clientes
WHERE
    CodigoCliente IN (SELECT 
            CodigoCliente
        FROM
            Pedidos
        WHERE
            CodigoPedido IN (SELECT 
                    CodigoPedido
                FROM
                    DetallePedidos
                GROUP BY CodigoPedido
                HAVING SUM(Cantidad) > 200));
/*Ejercicio 5:
Obtener los clientes que residen en ciudades donde no hay oficinas.*/
SELECT 
    CodigoCliente
FROM
    Clientes
WHERE
    Ciudad NOT IN (SELECT 
            Ciudad
        FROM
            Oficinas);
/*Ejercicio 6:Obtener el nombre, los apellidos y el email de los empleados a cargo de Alberto Soria.*/
SELECT 
    Nombre, Apellido1, Apellido2, Email
FROM
    Empleados
WHERE
    CodigoJefe = (SELECT 
            CodigoEmpleado
        FROM
            Empleados
        WHERE
            Nombre = 'Alberto'
                AND Apellido1 = 'Soria');
/*Ejercicio 7: Obtener el nombre de los clientes a los que no se les ha entregado a tiempo algún pedido.*/
SELECT 
    NombreCliente
FROM
    Clientes
WHERE
    CodigoCliente IN (SELECT 
            CodigoCliente
        FROM
            Pedidos
        WHERE
            FechaEntrega > FechaEsperada);
/*Ejercicio 8: Obtener el nombre y teléfono de los clientes que hicieron algún pago en 2007, ordenados alfabéticamente por nombre.*/
SELECT 
    NombreCliente, Telefono
FROM
    Clientes
WHERE
    CodigoCliente IN (SELECT 
            CodigoCliente
        FROM
            Pagos
        WHERE
            YEAR(FechaPago) = 2007);
/*Ejercicio 9: Obtener la gama, el proveedor y la cantidad de aquellos productos cuyo estado sea pendiente.*/
SELECT 
    Gama, Proveedor, COUNT(CodigoProducto)
FROM
    Productos
WHERE
    CodigoProducto IN (SELECT 
            CodigoProducto
        FROM
            DetallePedidos
        WHERE
            CodigoPedido IN (SELECT 
                    CodigoPedido
                FROM
                    Pedidos
                WHERE
                    Estado = 'Pendiente'))
GROUP BY Gama , Proveedor;
/*Consultas simples*/
SELECT 
    Ciudad, Telefono
FROM
    Oficinas
WHERE
    Pais = 'EEUU';
/*Ejercicio 2: Obtener el cargo, nombre, apellidos e email del jefe de la empresa.*/
SELECT 
    Puesto, Nombre, Apellido1, Apellido2, Email
FROM
    Empleados
WHERE
    CodigoJefe IS NULL;
/*Ejercicio 3:
Obtener el nombre, apellidos y cargo de aquellos que no sean representantes de ventas.*/
SELECT 
    Nombre, Apellido1, Apellido2, Puesto
FROM
    Empleados
WHERE
    Puesto != 'Representante de Ventas';
/*Ejercicio 4:
Obtener el número de clientes que tiene la empresa.*/
SELECT 
    COUNT(CodigoCliente)
FROM
    Clientes;
/*Ejercicio 5: Obtener el nombre de los clientes españoles.*/
SELECT 
    NombreCliente
FROM
    Clientes
WHERE
    Pais = 'Spain';
/*Ejercicio 6: Obtener cuántos clientes tiene la empresa en cada país.*/
SELECT 
    COUNT(CodigoCliente), Pais
FROM
    Clientes
GROUP BY Pais;
/*Ejercicio 7:Obtener cuántos clientes tiene la empresa en la ciudad de Madrid.*/
SELECT 
    COUNT(CodigoCliente), Ciudad
FROM
    Clientes
WHERE
    Ciudad = 'Madrid';
/*Ejercicio 8: Obtener el código de empleado y el número de clientes al que atiende cada representante de ventas.*/
SELECT 
    CodigoEmpleadoRepVentas, COUNT(CodigoCliente)
FROM
    Clientes
GROUP BY CodigoEmpleadoRepVentas;
/*Ejercicio 9:Obtener cuál fue el primer y último pago que hizo el cliente cuyo código es el 3.*/
SELECT 
    CodigoCliente, MIN(FechaPago), MAX(FechaPago)
FROM
    Pagos
WHERE
    CodigoCliente = 3;
/*Ejercicio 10: Obtener el código de cliente de aquellos clientes que hicieron pagos en 2008*/
SELECT 
    CodigoCliente
FROM
    Pagos
WHERE
    YEAR(FechaPago) = 2008;
/*Consultas simples de la Base de Datos “Jardineria” (II)*/
SELECT DISTINCT
    (Estado)
FROM
    Pedidos;
/*Ejercicio 12: Obtener el número de pedido, código de cliente, fecha requerida y fecha de entrega de los pedidos que no han sido entregados a tiempo.*/
SELECT 
    CodigoPedido, CodigoCliente, FechaEsperada, FechaEntrega
FROM
    Pedidos
WHERE
    FechaEntrega > FechaEsperada;
/*Ejercicio 13: Obtener cuántos productos existen en cada línea de pedido.*/
SELECT 
    COUNT(CodigoProducto), NumeroLinea
FROM
    DetallePedidos
GROUP BY NumeroLinea;
/*Ejercicio 14: Obtener un listado de los 20 códigos de productos más pedidos ordenado por cantidad pedida.*/
SELECT 
    CodigoProducto, Cantidad
FROM
    DetallePedidos
ORDER BY Cantidad DESC
LIMIT 20;
/*Ejercicio 15: Obtener el número de pedido, código de cliente, fecha requerida y fecha de entrega de los pedidos cuya fecha de entrega ha sido al menos dos días antes de la fecha requerida. (Usar la función addDate)*/
SELECT 
    CodigoPedido, CodigoCliente, FechaEsperada, FechaEntrega
FROM
    Pedidos
WHERE
    FechaEntrega <= ADDDATE(FechaEsperada, INTERVAL - 2 DAY);
/*Ejercicio 16: Obtener el nombre, apellidos, oficina y cargo de aquellos que no sean representantes de ventas.*/
SELECT 
    Nombre, Apellido1, Apellido2, CodigoOficina, Puesto
FROM
    Empleados
WHERE
    Puesto != 'Representante de Ventas';
/*Ejercicio 17: Obtener el número de clientes que tiene asignado cada representante de ventas.*/
SELECT 
    CodigoEmpleadoRepVentas, COUNT(CodigoCliente)
FROM
    Clientes
GROUP BY 1;
/*Ejercicio 18: Obtener un listado con el precio total de cada pedido.*/
SELECT 
    CodigoPedido, SUM(PrecioUnidad)
FROM
    DetallePedidos
GROUP BY CodigoPedido;
/*Ejercicio 19: Obtener cuántos pedidos tiene cada cliente en cada estado.*/
SELECT 
    CodigoCliente, COUNT(CodigoPedido), Estado
FROM
    Pedidos
GROUP BY CodigoCliente , Estado;
/*Ejercicio 20: Obtener una lista con el código de oficina, ciudad, región y país de aquellas oficinas que estén en países que cuyo nombre empiece por “E”.*/
SELECT 
    CodigoOficina, Ciudad, Region, Pais
FROM
    Oficinas
WHERE
    Pais LIKE 'E%';
/*Ejercicio 21: Obtener el nombre, gama, dimensiones, cantidad en stock y el precio de venta de los cinco productos más caros.*/
SELECT 
    Nombre, Gama, Dimensiones, CantidadEnStock, PrecioVenta
FROM
    Productos
ORDER BY PrecioVenta DESC
LIMIT 5;
/*Ejercicio 22: Obtener el código y la facturación de aquellos pedidos mayores de 2000 euros.*/
SELECT 
    CodigoPedido, SUM(Cantidad * PrecioUnidad)
FROM
    DetallePedidos
GROUP BY CodigoPedido
HAVING SUM(Cantidad * PrecioUnidad) > 2000;
/*Ejercicio 23: Obtener una lista de los productos mostrando el stock total, la gama y el proveedor.*/
SELECT 
    CodigoProducto, CantidadEnStock, Gama, Proveedor
FROM
    Productos;
/*Ejercicio 24: Obtener el número de pedidos y código de cliente de aquellos pedidos cuya fecha de pedido sea igual a la de la fecha de entrega.*/
SELECT 
    CodigoCliente, CodigoPedido, FechaPedido, FechaEntrega
FROM
    Pedidos
WHERE
    FechaPedido = FechaEntrega;
/*Consultas multitablas de la Base de Datos “Jardineria” (I)*/
SELECT 
    a.NombreCliente,
    SUM(b.cantidad) AS PagosPedidos,
    LimiteCredito
FROM
    Clientes a,
    Pagos b
WHERE
    a.CodigoCliente = b.CodigoCliente
GROUP BY a.CodigoCliente
HAVING a.LimiteCredito > PagosPedidos;
/*Ejercicio 2: Obtener el nombre de los clientes y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante. Utliza WHERE en lugar de JOIN para la unión de tablas*/
SELECT 
    NombreCliente, CodigoEmpleadoRepVentas, o.Ciudad
FROM
    Clientes c,
    Empleados e,
    Oficinas o
WHERE
    c.CodigoEmpleadoRepVentas = e.CodigoEmpleado
        AND e.CodigoOficina = o.CodigoOficina;
/*Ejercicio 3: Obtener el nombre de los clientes y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante. Utliza JOIN en lugar de WHERE para la unión de tablas.*/
SELECT 
    a.NombreCliente, b.Nombre, c.Ciudad
FROM
    Clientes a,
    Empleados b,
    Oficinas c
WHERE
    a.CodigoEmpleadoRepVentas = b.CodigoEmpleado
        AND b.CodigoOficina = c.CodigoOficina
ORDER BY 1;
/*Ejercicio 4: Obtener un listado de clientes indicando el nombre del cliente y cuantos pedidos ha realizado.*/
SELECT 
    c.NombreCliente, COUNT(p.CodigoPedido)
FROM
    Clientes c,
    Pedidos p
WHERE
    c.CodigoCliente = p.CodigoCliente
GROUP BY c.NombreCliente;
/*Ejercicio 5: Obtener un listado con los nombres de los clientes y el total pagado por cada uno de ellos.*/
SELECT 
    c.NombreCliente, SUM(p.Cantidad)
FROM
    Clientes c,
    Pagos p
WHERE
    c.CodigoCliente = p.CodigoCliente
GROUP BY c.NombreCliente;
/*Ejercicio 6: Obtener el nombre y apellidos de los empleados así como el nombre de cliente de aquellos empleados que representen a clientes que hayan efectuado algún pago mediante Paypal.*/
SELECT 
    e.Nombre,
    CONCAT(e.Apellido1, ' ', e.Apellido2) AS Apellidos,
    c.NombreCliente
FROM
    Empleados e,
    Clientes c,
    Pagos p
WHERE
    e.CodigoEmpleado = c.CodigoEmpleadoRepVentas
        AND c.CodigoCliente = p.CodigoCliente
        AND c.CodigoCliente IN (SELECT 
            CodigoCliente
        FROM
            Pagos
        WHERE
            FormaPago = 'Paypal')
GROUP BY e.Nombre , Apellidos , c.NombreCliente;
/*Ejercicio 7: Obtener cuántos empleados tiene cada oficina, mostrando el nombre de la ciudad donde está la oficina.*/
SELECT 
    COUNT(e.CodigoEmpleado), o.Ciudad
FROM
    Empleados e,
    Oficinas o
WHERE
    e.CodigoOficina = o.CodigoOficina
GROUP BY o.Ciudad;
/*Ejercicio 8: Obtener el nombre, apellido, oficina (ciudad) y cargo del empleado que no represente a ningún cliente.*/
SELECT 
    e.Nombre, e.Apellido1, o.Ciudad, e.Puesto
FROM
    Empleados e,
    Oficinas o
WHERE
    e.CodigoOficina = o.CodigoOficina
        AND CodigoEmpleado NOT IN (SELECT 
            CodigoEmpleadoRepVentas
        FROM
            Clientes);
/*Ejercicio 9:  Obtener un listado con los clientes y el identificador de transacción de aquellos clientes que efectuaron algún pago en el año 2007.*/
SELECT 
    c.NombreCliente, p.IDTransaccion
FROM
    Clientes c
        INNER JOIN
    Pagos p ON c.CodigoCliente = p.CodigoCliente
WHERE
    YEAR(FechaPago) = '2007';
/*Ejercicio 10: Obtener los nombres de los clientes así como los nombres y apellidos de sus representantes de aquellos clientes que no han realizado pagos.*/
SELECT 
    c.NombreCliente,
    e.Nombre,
    CONCAT(e.Apellido1, ' ', e.Apellido2) AS Apellidos
FROM
    Clientes c,
    Empleados e
WHERE
    c.CodigoEmpleadoRepVentas = e.CodigoEmpleado
        AND c.CodigoCliente NOT IN (SELECT 
            CodigoCliente
        FROM
            Pagos);
/*Ejercicio 11: Obtener el nombre, gama y descripción de texto de los productos que nunca se han pedido.*/
SELECT 
    p.Nombre, p.Gama, gp.DescripcionTexto
FROM
    Productos p,
    GamasProductos gp
WHERE
    p.Gama = gp.Gama
        AND CodigoProducto NOT IN (SELECT 
            CodigoPedido
        FROM
            DetallePedidos);
/*Ejercicio 12: Obtener el nombre, apellidos y el código postal de todos los empleados que trabajan en Barcelona.*/
SELECT 
    e.Nombre,
    CONCAT(e.Apellido1, ' ', e.Apellido2) AS Apellidos,
    o.CodigoPostal
FROM
    Empleados e,
    Oficinas o
WHERE
    e.CodigoOFicina = o.CodigoOficina
        AND e.CodigoOficina IN (SELECT 
            CodigoOficina
        FROM
            Oficinas
        WHERE
            Ciudad = 'Barcelona');
/*Ejercicio 13: Obtener el código de producto, descripción del texto y la cantidad de veces que se ha pedido dicho producto.*/
SELECT 
    p.CodigoProducto, gp.DescripcionTexto, SUM(dp.Cantidad)
FROM
    Productos p,
    GamasProductos gp,
    DetallePedidos dp
WHERE
    p.Gama = gp.Gama
        AND p.CodigoProducto = dp.CodigoProducto
GROUP BY p.CodigoProducto , gp.DescripcionTexto;
/*Ejercicio 14: Obtener el nombre de los clientes de la ciudad de Madrid que han realizado algún pedido y el estado en que esté dicho pedido.*/
SELECT 
    c.NombreCliente, p.Estado
FROM
    Clientes c
        INNER JOIN
    Pedidos p ON c.CodigoCliente = p.CodigoCliente
WHERE
    CodigoEmpleadoRepVentas IN (SELECT 
            CodigoEmpleado
        FROM
            Empleados
        WHERE
            CodigoOficina IN (SELECT 
                    CodigoOficina
                FROM
                    Oficinas
                WHERE
                    Ciudad = 'Madrid'));