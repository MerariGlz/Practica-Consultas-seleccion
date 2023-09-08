
-------------------------------Northwind------------------------------------------------------------------------------------------------------------------ 


-- Esta consulta une la tabla Customers con la tabla Orders
-- para mostrar los clientes que han realizado pedidos junto con el total de sus ventas.
SELECT
    c.CustomerID,
    c.ContactName,
    SUM(od.UnitPrice * od.Quantity) AS TotalVentas
FROM Customers AS c
JOIN Orders AS o ON c.CustomerID = o.CustomerID
JOIN OrderDetails AS od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.ContactName
HAVING SUM(od.UnitPrice * od.Quantity) > 10000
ORDER BY TotalVentas DESC;

-- Esta consulta une la tabla Products con la tabla Categories
-- para mostrar las categorías de productos junto con el total de productos vendidos de cada categoría.
SELECT
    c.CategoryName,
    p.ProductName,
    SUM(od.Quantity) AS TotalProductosVendidos
FROM Products AS p
JOIN Categories AS c ON p.CategoryID = c.CategoryID
JOIN OrderDetails AS od ON p.ProductID = od.ProductID
GROUP BY c.CategoryName, p.ProductName
ORDER BY TotalProductosVendidos DESC;

-- Esta consulta une la tabla Employees con la tabla Orders
-- para mostrar información sobre los empleados y la cantidad promedio de productos por pedido que han atendido.
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    COUNT(o.OrderID) AS TotalPedidos,
    AVG(o.OrderDetailsCount) AS PromedioProductosPorPedido
FROM Employees AS e
JOIN (
    SELECT
        o.EmployeeID,
        o.OrderID,
        COUNT(od.ProductID) AS OrderDetailsCount
    FROM Orders AS o
    JOIN OrderDetails AS od ON o.OrderID = od.OrderID
    GROUP BY o.EmployeeID, o.OrderID
) AS o ON e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY TotalPedidos DESC;

 -- Esta consulta une la tabla Suppliers con la tabla Products
-- para mostrar los proveedores y el producto más caro que suministran.
SELECT
    s.SupplierID,
    s.SupplierName,
    p.ProductName,
    MAX(p.UnitPrice) AS PrecioMasAlto
FROM Suppliers AS s
JOIN Products AS p ON s.SupplierID = p.SupplierID
GROUP BY s.SupplierID, s.SupplierName, p.ProductName
ORDER BY PrecioMasAlto DESC;

-- Esta consulta une la tabla Customers con la tabla Orders
-- para mostrar el total de ventas por país y filtrar los países con ventas superiores a $100,000.
SELECT
    c.Country,
    SUM(od.UnitPrice * od.Quantity) AS TotalVentas
FROM Customers AS c
JOIN Orders AS o ON c.CustomerID = o.CustomerID
JOIN OrderDetails AS od ON o.OrderID = od.OrderID
GROUP BY c.Country
HAVING SUM(od.UnitPrice * od.Quantity) > 100000
ORDER BY TotalVentas DESC;

-- Esta consulta une la tabla Customers con la tabla Orders
-- y luego con la tabla Employees para mostrar qué empleado atendió a cada cliente en sus pedidos.
SELECT
    c.CustomerID,
    c.ContactName,
    e.FirstName AS EmployeeFirstName,
    e.LastName AS EmployeeLastName
FROM Customers AS c
JOIN Orders AS o ON c.CustomerID = o.CustomerID
JOIN Employees AS e ON o.EmployeeID = e.EmployeeID
ORDER BY c.CustomerID;

-- Esta consulta une la tabla Categories con la tabla Products
-- para mostrar el precio promedio de los productos en cada categoría.
SELECT
    c.CategoryName,
    AVG(p.UnitPrice) AS PrecioPromedio
FROM Categories AS c
JOIN Products AS p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryName
ORDER BY PrecioPromedio DESC;

-- Esta consulta une la tabla Employees con la tabla Orders
-- para mostrar qué cliente ha realizado más compras atendido por cada empleado.
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    c.ContactName AS ClienteQueMasCompro,
    COUNT(o.OrderID) AS TotalPedidos
FROM Employees AS e
JOIN Orders AS o ON e.EmployeeID = o.EmployeeID
JOIN (
    SELECT
        o.CustomerID,
        COUNT(o.OrderID) AS TotalOrdenes
    FROM Orders AS o
    GROUP BY o.CustomerID
    HAVING COUNT(o.OrderID) = (
        SELECT MAX(TotalOrdenes) FROM (
            SELECT
                o.CustomerID,
                COUNT(o.OrderID) AS TotalOrdenes
            FROM Orders AS o
            GROUP BY o.CustomerID
        ) AS Temp
    )
) AS c ON o.CustomerID = c.CustomerID
GROUP BY e.EmployeeID, e.FirstName, e.LastName, c.ContactName
ORDER BY e.EmployeeID;

-- Esta consulta une la tabla Products con la tabla Suppliers
-- para mostrar los productos y la cantidad mínima disponible de cada producto.
SELECT
    p.ProductName,
    s.SupplierName,
    MIN(p.UnitsInStock) AS CantidadMinimaDisponible
FROM Products AS p
JOIN Suppliers AS s ON p.SupplierID = s.SupplierID
GROUP BY p.ProductName, s.SupplierName
ORDER BY CantidadMinimaDisponible;

-- Esta consulta une la tabla Customers con la tabla Orders
-- para mostrar el cliente que realizó el mayor número de compras en un mes específico.
SELECT
    c.CustomerID,
    c.ContactName,
    EXTRACT(MONTH FROM o.OrderDate) AS MesDeCompra,
    COUNT(o.OrderID) AS TotalComprasEnMes
FROM Customers AS c
JOIN Orders AS o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.ContactName, MesDeCompra
HAVING COUNT(o.OrderID) = (
    SELECT MAX(TotalComprasEnMes) FROM (
        SELECT
            c.CustomerID,
            EXTRACT(MONTH FROM o.OrderDate) AS MesDeCompra,
            COUNT(o.OrderID) AS TotalComprasEnMes
        FROM Customers AS c
        JOIN Orders AS o ON c.CustomerID = o.CustomerID
        GROUP BY c.CustomerID, MesDeCompra
    ) AS Temp
)
ORDER BY TotalComprasEnMes DESC;

-- Esta consulta une la tabla Employees con la tabla Orders
-- para mostrar el empleado que ha atendido la mayor venta total.
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    SUM(od.UnitPrice * od.Quantity) AS VentaTotal
FROM Employees AS e
JOIN Orders AS o ON e.EmployeeID = o.EmployeeID
JOIN OrderDetails AS od ON o.OrderID = od.OrderID
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY VentaTotal DESC
LIMIT 1;

-- Esta consulta une la tabla Products con la tabla OrderDetails
-- para mostrar el producto más vendido junto con la cantidad total vendida.
SELECT
    p.ProductName,
    SUM(od.Quantity) AS CantidadTotalVendida
FROM Products AS p
JOIN OrderDetails AS od ON p.ProductID = od.ProductID
GROUP BY p.ProductName
ORDER BY CantidadTotalVendida DESC
LIMIT 1;

-- Esta consulta une la tabla Customers con la tabla Orders
-- para mostrar el total de compras por cliente y ordena los resultados por el total de compras de manera descendente.
SELECT
    c.CustomerID,
    c.ContactName,
    SUM(od.UnitPrice * od.Quantity) AS TotalCompras
FROM Customers AS c
JOIN Orders AS o ON c.CustomerID = o.CustomerID
JOIN OrderDetails AS od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.ContactName
ORDER BY TotalCompras DESC;

-- Esta consulta une la tabla Products con la tabla Categories
-- para mostrar la cantidad promedio de productos vendidos por categoría.
SELECT
    c.CategoryName,
    AVG(od.Quantity) AS CantidadPromedioVendida
FROM Categories AS c
JOIN Products AS p ON c.CategoryID = p.CategoryID
JOIN OrderDetails AS od ON p.ProductID = od.ProductID
GROUP BY c.CategoryName
ORDER BY CantidadPromedioVendida DESC;

-- Esta consulta une la tabla Employees con la tabla Orders
-- para mostrar el cliente que realizó el pedido más reciente atendido por cada empleado.
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    c.ContactName AS ClientePedidoMasReciente,
    MAX(o.OrderDate) AS FechaPedidoMasReciente
FROM Employees AS e
JOIN Orders AS o ON e.EmployeeID = o.EmployeeID
JOIN Customers AS c ON o.CustomerID = c.CustomerID
GROUP BY e.EmployeeID, e.FirstName, e.LastName, c.ContactName
ORDER BY e.EmployeeID;

-- Esta consulta une la tabla Products con la tabla OrderDetails
-- para mostrar el producto menos vendido junto con la cantidad total vendida.
SELECT
    p.ProductName,
    SUM(od.Quantity) AS CantidadTotalVendida
FROM Products AS p
JOIN OrderDetails AS od ON p.ProductID = od.ProductID
GROUP BY p.ProductName
ORDER BY CantidadTotalVendida ASC
LIMIT 1;

-- Esta consulta une la tabla Customers con la tabla Orders
-- para mostrar el total de compras por país y ordena los resultados por el total de compras de manera descendente.
SELECT
    c.Country,
    SUM(od.UnitPrice * od.Quantity) AS TotalCompras
FROM Customers AS c
JOIN Orders AS o ON c.CustomerID = o.CustomerID
JOIN OrderDetails AS od ON o.OrderID = od.OrderID
GROUP BY c.Country
ORDER BY TotalCompras DESC;

-- Esta consulta une la tabla Employees con la tabla Orders
-- para mostrar el total de ventas por empleado y ordena los resultados por el total de ventas de manera descendente.
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    SUM(od.UnitPrice * od.Quantity) AS TotalVentas
FROM Employees AS e
JOIN Orders AS o ON e.EmployeeID = o.EmployeeID
JOIN OrderDetails AS od ON o.OrderID = od.OrderID
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY TotalVentas DESC;

-- Esta consulta une la tabla Categories con la tabla Products
-- para mostrar la cantidad máxima de productos vendidos por categoría.
SELECT
    c.CategoryName,
    MAX(od.Quantity) AS CantidadMaximaVendida
FROM Categories AS c
JOIN Products AS p ON c.CategoryID = p.CategoryID
JOIN OrderDetails AS od ON p.ProductID = od.ProductID
GROUP BY c.CategoryName
ORDER BY CantidadMaximaVendida DESC;

-- Esta consulta une la tabla Customers con la tabla Orders
-- para mostrar la mayor compra realizada por cada cliente.
SELECT
    c.CustomerID,
    c.ContactName,
    MAX(od.UnitPrice * od.Quantity) AS MayorCompra
FROM Customers AS c
JOIN Orders AS o ON c.CustomerID = o.CustomerID
JOIN OrderDetails AS od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.ContactName;

-- Esta consulta une la tabla Products con la tabla Suppliers
-- para mostrar el producto más antiguo suministrado por cada proveedor.
SELECT
    s.SupplierID,
    s.SupplierName,
    p.ProductName AS ProductoMasAntiguo
FROM Suppliers AS s
JOIN Products AS p ON s.SupplierID = p.SupplierID
WHERE p.ProductID = (
    SELECT ProductID
    FROM Products
    WHERE SupplierID = s.SupplierID
    ORDER BY Discontinued ASC, ProductID ASC
    LIMIT 1
);
-- Esta consulta une la tabla Employees con la tabla Orders
-- para mostrar el promedio de días entre pedidos atendidos por cada empleado.
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    AVG(DATEDIFF(o2.OrderDate, o1.OrderDate)) AS PromedioDiasEntrePedidos
FROM Employees AS e
JOIN Orders AS o1 ON e.EmployeeID = o1.EmployeeID
JOIN Orders AS o2 ON e.EmployeeID = o2.EmployeeID AND o2.OrderDate > o1.OrderDate
GROUP BY e.EmployeeID, e.FirstName, e.LastName;

-- Esta consulta une la tabla Customers con la tabla Orders
-- para mostrar la cantidad de pedidos realizados por cada cliente en cada año.
SELECT
    c.CustomerID,
    c.ContactName,
    EXTRACT(YEAR FROM o.OrderDate) AS Anio,
    COUNT(o.OrderID) AS CantidadPedidos
FROM Customers AS c
JOIN Orders AS o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.ContactName, Anio
ORDER BY Anio, CantidadPedidos DESC;

-- Esta consulta une la tabla Categories con la tabla Products
-- para mostrar el precio mínimo y máximo de productos en cada categoría.
SELECT
    c.CategoryName,
    MIN(p.UnitPrice) AS PrecioMinimo,
    MAX(p.UnitPrice) AS PrecioMaximo
FROM Categories AS c
JOIN Products AS p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryName;

-- Esta consulta une la tabla Employees con la tabla Orders
-- para mostrar el empleado que tuvo el mes de mayor venta y el monto de esa venta.
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    EXTRACT(MONTH FROM o.OrderDate) AS MesDeMayorVenta,
    MAX(TotalVentas) AS MayorVentaMensual
FROM Employees AS e
JOIN Orders AS o ON e.EmployeeID = o.EmployeeID
JOIN (
    SELECT
        EmployeeID,
        EXTRACT(MONTH FROM OrderDate) AS Mes,
        SUM(UnitPrice * Quantity) AS TotalVentas
    FROM Orders AS o
    JOIN OrderDetails AS od ON o.OrderID = od.OrderID
    GROUP BY EmployeeID, Mes
) AS VentasPorMes ON e.EmployeeID = VentasPorMes.EmployeeID AND EXTRACT(MONTH FROM o.OrderDate) = VentasPorMes.Mes
GROUP BY e.EmployeeID, e.FirstName, e.LastName, MesDeMayorVenta;

-- Esta consulta une la tabla Customers con la tabla Orders
-- para mostrar el promedio de valor de compras por cliente.
SELECT
    c.CustomerID,
    c.ContactName,
    AVG(od.UnitPrice * od.Quantity) AS PromedioValorCompras
FROM Customers AS c
JOIN Orders AS o ON c.CustomerID = o.CustomerID
JOIN OrderDetails AS od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.ContactName
ORDER BY PromedioValorCompras DESC;

-- Esta consulta une la tabla Employees con la tabla Orders
-- para mostrar la fecha del primer pedido atendido por cada empleado.
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    MIN(o.OrderDate) AS PrimerPedidoAtendido
FROM Employees AS e
JOIN Orders AS o ON e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName;

-- Esta consulta une la tabla Products con la tabla OrderDetails
-- para mostrar la cantidad promedio de productos vendidos por producto.
SELECT
    p.ProductName,
    AVG(od.Quantity) AS CantidadPromedioVendida
FROM Products AS p
JOIN OrderDetails AS od ON p.ProductID = od.ProductID
GROUP BY p.ProductName
ORDER BY CantidadPromedioVendida DESC;

-- Esta consulta une la tabla Categories con la tabla Products
-- para mostrar la cantidad de productos en cada categoría.
SELECT
    c.CategoryName,
    COUNT(p.ProductID) AS CantidadProductos
FROM Categories AS c
JOIN Products AS p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryName
ORDER BY CantidadProductos DESC;

-- Esta consulta une la tabla Customers con la tabla Orders
-- para mostrar el país con el mayor volumen de compras y el total de compras en ese país.
SELECT
    c.Country,
    SUM(od.UnitPrice * od.Quantity) AS TotalCompras
FROM Customers AS c
JOIN Orders AS o ON c.CustomerID = o.CustomerID
JOIN OrderDetails AS od ON o.OrderID = od.OrderID
GROUP BY c.Country
ORDER BY TotalCompras DESC
LIMIT 1;

-- Esta consulta une la tabla Employees con la tabla Orders
-- para mostrar el empleado que tuvo el mes de mayor venta y el monto de esa venta.
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    EXTRACT(MONTH FROM o.OrderDate) AS MesDeMayorVenta,
    MAX(TotalVentas) AS MayorVentaMensual
FROM Employees AS e
JOIN Orders AS o ON e.EmployeeID = o.EmployeeID
JOIN (
    SELECT
        EmployeeID,
        EXTRACT(MONTH FROM OrderDate) AS Mes,
        SUM(UnitPrice * Quantity) AS TotalVentas
    FROM Orders AS o
    JOIN OrderDetails AS od ON o.OrderID = od.OrderID
    GROUP BY EmployeeID, Mes
) AS VentasPorMes ON e.EmployeeID = VentasPorMes.EmployeeID AND EXTRACT(MONTH FROM o.OrderDate) = VentasPorMes.Mes
GROUP BY e.EmployeeID, e.FirstName, e.LastName, MesDeMayorVenta;

-- Esta consulta une la tabla Products con la tabla OrderDetails
-- para mostrar el producto menos vendido junto con la cantidad total vendida.
SELECT
    p.ProductName,
    SUM(od.Quantity) AS CantidadTotalVendida
FROM Products AS p
JOIN OrderDetails AS od ON p.ProductID = od.ProductID
GROUP BY p.ProductName
ORDER BY CantidadTotalVendida ASC
LIMIT 1;

-- Esta consulta une la tabla Customers con la tabla Orders
-- para mostrar el total de compras por país y ordena los resultados por el total de compras de manera descendente.
SELECT
    c.Country,
    SUM(od.UnitPrice * od.Quantity) AS TotalCompras
FROM Customers AS c
JOIN Orders AS o ON c.CustomerID = o.CustomerID
JOIN OrderDetails AS od ON o.OrderID = od.OrderID
GROUP BY c.Country
ORDER BY TotalCompras DESC;

-- Esta consulta une la tabla Employees con la tabla Orders
-- para mostrar el total de ventas por empleado y ordena los resultados por el total de ventas de manera descendente.
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    SUM(od.UnitPrice * od.Quantity) AS TotalVentas
FROM Employees AS e
JOIN Orders AS o ON e.EmployeeID = o.EmployeeID
JOIN OrderDetails AS od ON o.OrderID = od.OrderID
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY TotalVentas DESC;
	
	-- Esta consulta une la tabla Categories con la tabla Products
-- para mostrar el precio mínimo y máximo de productos en cada categoría.
SELECT
    c.CategoryName,
    MIN(p.UnitPrice) AS PrecioMinimo,
    MAX(p.UnitPrice) AS PrecioMaximo
FROM Categories AS c
JOIN Products AS p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryName;

-- Esta consulta une la tabla Products con la tabla Categories y OrderDetails
-- para mostrar el producto más vendido por cada categoría junto con la cantidad total vendida.
SELECT
    c.CategoryName,
    p.ProductName AS ProductoMasVendido,
    SUM(od.Quantity) AS CantidadTotalVendida
FROM Categories AS c
JOIN Products AS p ON c.CategoryID = p.CategoryID
JOIN OrderDetails AS od ON p.ProductID = od.ProductID
WHERE (p.CategoryID, od.Quantity) IN (
    SELECT
        p.CategoryID,
        MAX(od.Quantity) AS MaxCantidadVendida
    FROM Products AS p
    JOIN OrderDetails AS od ON p.ProductID = od.ProductID
    GROUP BY p.CategoryID
)
GROUP BY c.CategoryName, ProductoMasVendido
ORDER BY c.CategoryName;

-- Esta consulta une la tabla Employees con la tabla Orders
-- para mostrar el total de pedidos realizados por cada empleado.
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    COUNT(o.OrderID) AS TotalPedidos
FROM Employees AS e
JOIN Orders AS o ON e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY TotalPedidos DESC;

-- Esta consulta une la tabla Suppliers con la tabla Products
-- para mostrar el proveedor y el producto más caro que suministra.
SELECT
    s.SupplierID,
    s.SupplierName,
    p.ProductName,
    p.UnitPrice AS PrecioMasAlto
FROM Suppliers AS s
JOIN Products AS p ON s.SupplierID = p.SupplierID
WHERE (s.SupplierID, p.UnitPrice) IN (
    SELECT
        SupplierID,
        MAX(UnitPrice) AS MaxPrecio
    FROM Products
    GROUP BY SupplierID
)
ORDER BY s.SupplierID;

-- Esta consulta une la tabla Customers con la tabla Orders
-- para mostrar la mayor compra realizada por cada cliente.
SELECT
    c.CustomerID,
    c.ContactName,
    o.OrderID,
    MAX(od.UnitPrice * od.Quantity) AS MayorCompra
FROM Customers AS c
JOIN Orders AS o ON c.CustomerID = o.CustomerID
JOIN OrderDetails AS od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.ContactName, o.OrderID;

-- Esta consulta une la tabla Categories con la tabla Products
-- para mostrar el número de productos en cada categoría.
SELECT
    c.CategoryName,
    COUNT(p.ProductID) AS NumeroDeProductos
FROM Categories AS c
JOIN Products AS p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryName
ORDER BY NumeroDeProductos DESC;

-- Esta consulta une la tabla Products con la tabla OrderDetails y Orders
-- para mostrar el producto más vendido en un año específico junto con la cantidad total vendida.
SELECT
    EXTRACT(YEAR FROM o.OrderDate) AS Anio,
    p.ProductName AS ProductoMasVendido,
    SUM(od.Quantity) AS CantidadTotalVendida
FROM Products AS p
JOIN OrderDetails AS od ON p.ProductID = od.ProductID
JOIN Orders AS o ON od.OrderID = o.OrderID
WHERE (o.OrderDate BETWEEN '1997-01-01' AND '1997-12-31')
GROUP BY Anio, ProductoMasVendido
HAVING SUM(od.Quantity) = (
    SELECT MAX(CantidadTotalVendida)
    FROM (
        SELECT
            EXTRACT(YEAR FROM o2.OrderDate) AS Anio,
            p2.ProductName AS ProductoMasVendido,
            SUM(od2.Quantity) AS CantidadTotalVendida
        FROM Products AS p2
        JOIN OrderDetails AS od2 ON p2.ProductID = od2.ProductID
        JOIN Orders AS o2 ON od2.OrderID = o2.OrderID
        WHERE (o2.OrderDate BETWEEN '1997-01-01' AND '1997-12-31')
        GROUP BY Anio, ProductoMasVendido
    ) AS VentasAnuales
)
ORDER BY Anio;

-- Esta consulta une la tabla Customers con la tabla Orders y OrderDetails
-- para mostrar la cantidad de compras mensuales por cliente.
SELECT
    c.CustomerID,
    c.ContactName,
    EXTRACT(YEAR FROM o.OrderDate) AS Anio,
    EXTRACT(MONTH FROM o.OrderDate) AS Mes,
    COUNT(o.OrderID) AS ComprasMensuales
FROM Customers AS c
JOIN Orders AS o ON c.CustomerID = o.CustomerID
JOIN OrderDetails AS od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.ContactName, Anio, Mes
ORDER BY Anio, Mes, ComprasMensuales DESC;

-- Esta consulta une la tabla Employees con la tabla Orders y OrderDetails
-- para mostrar el promedio de ventas diarias por empleado.
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    AVG(TotalVentasDiarias) AS PromedioVentasDiarias
FROM Employees AS e
JOIN (
    SELECT
        o.EmployeeID,
        DATE(o.OrderDate) AS FechaOrden,
        SUM(od.UnitPrice * od.Quantity) AS TotalVentasDiarias
    FROM Orders AS o
    JOIN OrderDetails AS od ON o.OrderID = od.OrderID
    GROUP BY o.EmployeeID, FechaOrden
) AS VentasDiarias ON e.EmployeeID = VentasDiarias.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName;

-- Esta consulta une la tabla Suppliers con la tabla Products
-- para mostrar el precio promedio de productos suministrados por cada proveedor.
SELECT
    s.SupplierID,
    s.SupplierName,
    AVG(p.UnitPrice) AS PrecioPromedio
FROM Suppliers AS s
JOIN Products AS p ON s.SupplierID = p.SupplierID
GROUP BY s.SupplierID, s.SupplierName;

-- Esta consulta une la tabla Categories con la tabla Products, OrderDetails y Orders
-- para mostrar el total de ventas por categoría.
SELECT
    c.CategoryName,
    SUM(od.UnitPrice * od.Quantity) AS TotalVentas
FROM Categories AS c
JOIN Products AS p ON c.CategoryID = p.CategoryID
JOIN OrderDetails AS od ON p.ProductID = od.ProductID
JOIN Orders AS o ON od.OrderID = o.OrderID
GROUP BY c.CategoryName
ORDER BY TotalVentas DESC;









	----------------------------------Pubs-----------------------------------------------------------------------------------------------------
	
	-- Esta consulta muestra los nombres de los clientes y los números de factura de ventas.
SELECT nombre_cliente, NULL AS numero_factura FROM clientes
UNION
SELECT NULL AS nombre_cliente, numero_factura FROM ventas
ORDER BY nombre_cliente, numero_factura;

-- Esta consulta muestra todos los nombres de los clientes y los números de factura de ventas.
SELECT nombre_cliente, NULL AS numero_factura FROM clientes
UNION ALL
SELECT NULL AS nombre_cliente, numero_factura FROM ventas
ORDER BY nombre_cliente, numero_factura;

-- Esta consulta muestra los nombres de los clientes que también han realizado ventas.
SELECT nombre_cliente FROM clientes
INTERSECT
SELECT nombre_cliente FROM ventas
ORDER BY nombre_cliente;

-- Esta consulta muestra los nombres de los clientes que no han realizado ventas.
SELECT nombre_cliente FROM clientes
EXCEPT
SELECT nombre_cliente FROM ventas
ORDER BY nombre_cliente;

-- Esta consulta muestra los clientes que han realizado más de 3 compras.
SELECT nombre_cliente, COUNT(numero_factura) AS cantidad_compras
FROM clientes
LEFT JOIN ventas ON clientes.id_cliente = ventas.id_cliente
GROUP BY nombre_cliente
HAVING COUNT(numero_factura) > 3
ORDER BY cantidad_compras DESC;

-- Esta consulta muestra todos los nombres de clientes y números de factura de ventas, ordenados alfabéticamente por nombre de cliente y número de factura.
SELECT nombre_cliente, NULL AS numero_factura FROM clientes
UNION
SELECT NULL AS nombre_cliente, numero_factura FROM ventas
ORDER BY nombre_cliente ASC, numero_factura ASC;

-- Esta consulta muestra los nombres de clientes y sus saldos pendientes, así como los números de factura y el total de ventas, incluyendo todas las filas, incluso si no hay coincidencias en las ventas.
SELECT nombre_cliente, saldo_pendiente FROM clientes
UNION ALL
SELECT 'Total de Ventas' AS nombre_cliente, SUM(total_venta) FROM ventas
ORDER BY nombre_cliente;

-- Esta consulta muestra los nombres de clientes que también han realizado ventas de cerveza.
SELECT nombre_cliente FROM clientes
INTERSECT
SELECT nombre_cliente FROM ventas WHERE producto = 'cerveza'
ORDER BY nombre_cliente;

-- Esta consulta muestra los nombres de clientes que no han realizado ventas o cuyo saldo pendiente es superior a $1000.
SELECT nombre_cliente, COALESCE(SUM(total_venta), 0) AS total_ventas
FROM clientes
LEFT JOIN ventas ON clientes.id_cliente = ventas.id_cliente
GROUP BY nombre_cliente
HAVING COALESCE(SUM(total_venta), 0) <= 1000
ORDER BY total_ventas DESC;

-- Esta consulta muestra una lista de todos los productos vendidos y la cantidad total vendida, tanto por clientes como por el total general de ventas.
SELECT producto, SUM(cantidad) AS cantidad_vendida FROM (
    SELECT producto, cantidad FROM ventas WHERE id_cliente IS NOT NULL
    UNION ALL
    SELECT producto, SUM(cantidad) FROM ventas WHERE id_cliente IS NULL GROUP BY producto
) AS ventas_totales
GROUP BY producto
ORDER BY cantidad_vendida DESC;

-- Esta consulta muestra una lista de todos los productos vendidos por clientes y el total general de ventas, excluyendo productos con menos de 10 unidades vendidas.
SELECT producto, SUM(cantidad) AS cantidad_vendida FROM (
    SELECT producto, cantidad FROM ventas WHERE id_cliente IS NOT NULL
    UNION ALL
    SELECT producto, SUM(cantidad) FROM ventas WHERE id_cliente IS NULL GROUP BY producto
) AS ventas_totales
GROUP BY producto
HAVING SUM(cantidad) >= 10
ORDER BY cantidad_vendida DESC;

-- Esta consulta muestra la cantidad total de ventas realizadas por cada cliente y su saldo pendiente.
SELECT clientes.nombre_cliente, SUM(ventas.total_venta) AS total_ventas, clientes.saldo_pendiente
FROM clientes
LEFT JOIN (
    SELECT id_cliente, SUM(total_venta) AS total_venta
    FROM ventas
    GROUP BY id_cliente
) AS ventas_por_cliente ON clientes.id_cliente = ventas_por_cliente.id_cliente
ORDER BY total_ventas DESC;

-- Esta consulta muestra los nombres de clientes y la cantidad total de ventas realizadas, incluyendo clientes que no han realizado ventas.
SELECT nombre_cliente, COALESCE(total_ventas, 0) AS total_ventas FROM (
    SELECT nombre_cliente, (
        SELECT SUM(total_venta)
        FROM ventas
        WHERE ventas.id_cliente = clientes.id_cliente
    ) AS total_ventas
    FROM clientes
) AS clientes_ventas
UNION ALL
SELECT 'Total de Ventas', SUM(total_venta) FROM ventas;

-- Esta consulta muestra los clientes que han realizado al menos una venta y tienen un saldo pendiente superior a $500.
SELECT clientes.nombre_cliente, SUM(ventas.total_venta) AS total_ventas, clientes.saldo_pendiente
FROM clientes
INNER JOIN ventas ON clientes.id_cliente = ventas.id_cliente
GROUP BY clientes.nombre_cliente, clientes.saldo_pendiente
HAVING clientes.saldo_pendiente > 500
ORDER BY total_ventas DESC;

-- Esta consulta muestra los nombres de clientes y las fechas de sus últimas compras, incluyendo clientes que no han realizado compras.
SELECT nombre_cliente, MAX(fecha_compra) AS ultima_compra FROM (
    SELECT nombre_cliente, fecha_compra FROM clientes
    LEFT JOIN ventas ON clientes.id_cliente = ventas.id_cliente
    UNION ALL
    SELECT NULL AS nombre_cliente, fecha_compra FROM ventas
) AS compras_totales
GROUP BY nombre_cliente
ORDER BY ultima_compra DESC;

-- Esta consulta muestra una lista de productos vendidos y la cantidad total, así como una columna que indica si el producto es un "bestseller" (más de 100 unidades vendidas) o no.
SELECT producto, SUM(cantidad) AS cantidad_vendida,
    CASE
        WHEN SUM(cantidad) > 100 THEN 'Bestseller'
        ELSE 'No Bestseller'
    END AS estado_producto
FROM ventas
GROUP BY producto
ORDER BY cantidad_vendida DESC;

-- Esta consulta muestra los clientes que han realizado compras y su gasto promedio en cada compra.
SELECT c.nombre_cliente, AVG(v.total_venta) AS gasto_promedio
FROM clientes AS c
INNER JOIN (
    SELECT id_cliente, total_venta
    FROM ventas
) AS v ON c.id_cliente = v.id_cliente
GROUP BY c.nombre_cliente
ORDER BY gasto_promedio DESC;

-- Esta consulta muestra los nombres de los clientes y el saldo pendiente, incluyendo clientes sin ventas y con un saldo pendiente de 0.
SELECT nombre_cliente, COALESCE(saldo_pendiente, 0) AS saldo_pendiente
FROM clientes
LEFT JOIN (
    SELECT id_cliente, SUM(total_venta) AS saldo_pendiente
    FROM ventas
    GROUP BY id_cliente
) AS ventas_por_cliente ON clientes.id_cliente = ventas_por_cliente.id_cliente
UNION ALL
SELECT 'Sin Ventas' AS nombre_cliente, 0 AS saldo_pendiente
WHERE NOT EXISTS (SELECT 1 FROM ventas WHERE ventas.id_cliente IS NOT NULL);

-- Esta consulta muestra los clientes que han realizado compras en los últimos 30 días y su estado de actividad (activo o inactivo).
SELECT nombre_cliente,
    CASE
        WHEN MAX(fecha_compra) >= DATEADD(day, -30, GETDATE()) THEN 'Activo'
        ELSE 'Inactivo'
    END AS estado_actividad
FROM clientes
LEFT JOIN ventas ON clientes.id_cliente = ventas.id_cliente
GROUP BY nombre_cliente
HAVING MAX(fecha_compra) >= DATEADD(day, -30, GETDATE())
ORDER BY estado_actividad DESC;

-- Esta consulta muestra los nombres de los clientes y su saldo pendiente, junto con el total de ventas realizadas y la cantidad de productos vendidos.
SELECT nombre_cliente, saldo_pendiente, total_ventas, cantidad_vendida
FROM (
    SELECT c.nombre_cliente, c.saldo_pendiente, v.total_ventas, COALESCE(p.cantidad_vendida, 0) AS cantidad_vendida
    FROM clientes c
    LEFT JOIN (
        SELECT id_cliente, SUM(total_venta) AS total_ventas
        FROM ventas
        GROUP BY id_cliente
    ) v ON c.id_cliente = v.id_cliente
    LEFT JOIN (
        SELECT id_cliente, COUNT(*) AS cantidad_vendida
        FROM ventas
        GROUP BY id_cliente
    ) p ON c.id_cliente = p.id_cliente
) AS datos_clientes
UNION ALL
SELECT 'Total General', SUM(saldo_pendiente), SUM(total_ventas), SUM(cantidad_vendida)
FROM datos_clientes;

-- Esta consulta muestra los clientes que realizaron compras en un día laborable (de lunes a viernes) y su última compra en ese día.
SELECT c.nombre_cliente, MAX(v.fecha_compra) AS ultima_compra_dia_laborable
FROM clientes c
INNER JOIN (
    SELECT id_cliente, fecha_compra
    FROM ventas
    WHERE DATEPART(weekday, fecha_compra) BETWEEN 2 AND 6 -- Días laborables (de lunes a viernes)
) v ON c.id_cliente = v.id_cliente
GROUP BY c.nombre_cliente;

-- Esta consulta muestra los nombres de los clientes y la cantidad total gastada en compras, incluyendo clientes sin compras.
SELECT nombre_cliente, COALESCE(total_gastado, 0) AS total_gastado
FROM clientes
LEFT JOIN (
    SELECT id_cliente, SUM(total_venta) AS total_gastado
    FROM ventas
    GROUP BY id_cliente
) AS compras_por_cliente ON clientes.id_cliente = compras_por_cliente.id_cliente
UNION
SELECT 'Sin Compras', 0
WHERE NOT EXISTS (SELECT 1 FROM ventas WHERE ventas.id_cliente IS NOT NULL);

-- Esta consulta muestra los tres clientes con las compras más recientes.
SELECT nombre_cliente, fecha_compra
FROM (
    SELECT c.nombre_cliente, v.fecha_compra,
           ROW_NUMBER() OVER (PARTITION BY c.id_cliente ORDER BY v.fecha_compra DESC) AS rn
    FROM clientes c
    INNER JOIN ventas v ON c.id_cliente = v.id_cliente
) AS compras_recientes
WHERE rn <= 3;

-- Esta consulta muestra los nombres de los clientes y la fecha de su última compra, incluyendo clientes sin compras.
SELECT nombre_cliente, COALESCE(ultima_compra, 'Nunca compró') AS ultima_compra
FROM clientes
LEFT JOIN (
    SELECT id_cliente, MAX(fecha_compra) AS ultima_compra
    FROM ventas
    GROUP BY id_cliente
) AS ultimas_compras ON clientes.id_cliente = ultimas_compras.id_cliente
UNION ALL
SELECT 'Sin Compras', 'Nunca compró'
WHERE NOT EXISTS (SELECT 1 FROM ventas WHERE ventas.id_cliente IS NOT NULL);

-- Esta consulta muestra los clientes que han realizado compras después de un período de inactividad de al menos 90 días.
SELECT c.nombre_cliente, v.fecha_compra
FROM clientes c
INNER JOIN (
    SELECT id_cliente, fecha_compra,
           LAG(fecha_compra) OVER (PARTITION BY id_cliente ORDER BY fecha_compra) AS fecha_compra_anterior
    FROM ventas
) v ON c.id_cliente = v.id_cliente
WHERE DATEDIFF(day, v.fecha_compra_anterior, v.fecha_compra) >= 90;

-- Esta consulta muestra los nombres de los clientes que realizaron compras en un día específico de la semana y la cantidad de compras que hicieron en ese día.
SELECT DAYNAME(fecha_compra) AS dia_semana, COUNT(*) AS cantidad_compras
FROM ventas
GROUP BY dia_semana
HAVING COUNT(*) > 0
ORDER BY cantidad_compras DESC;

-- Esta consulta muestra los clientes que han realizado compras en los últimos 90 días y cuántos días han pasado desde su última compra.
SELECT c.nombre_cliente, MAX(v.fecha_compra) AS ultima_compra,
    DATEDIFF(day, MAX(v.fecha_compra), GETDATE()) AS dias_desde_ultima_compra
FROM clientes c
INNER JOIN ventas v ON c.id_cliente = v.id_cliente
GROUP BY c.nombre_cliente
HAVING DATEDIFF(day, MAX(v.fecha_compra), GETDATE()) <= 90
ORDER BY dias_desde_ultima_compra ASC;

-- Esta consulta muestra los nombres de los clientes y la cantidad total de compras realizadas, incluyendo clientes sin compras.
SELECT nombre_cliente, COALESCE(total_compras, 0) AS total_compras
FROM clientes
LEFT JOIN (
    SELECT id_cliente, COUNT(*) AS total_compras
    FROM ventas
    GROUP BY id_cliente
) AS compras_por_cliente ON clientes.id_cliente = compras_por_cliente.id_cliente
UNION ALL
SELECT 'Sin Compras', 0
WHERE NOT EXISTS (SELECT 1 FROM ventas WHERE ventas.id_cliente IS NOT NULL);

-- Esta consulta muestra la cantidad de compras realizadas por cada cliente en cada día de la semana.
SELECT nombre_cliente,
    CASE
        WHEN DATEPART(weekday, fecha_compra) = 1 THEN 'Domingo'
        WHEN DATEPART(weekday, fecha_compra) = 2 THEN 'Lunes'
        WHEN DATEPART(weekday, fecha_compra) = 3 THEN 'Martes'
        WHEN DATEPART(weekday, fecha_compra) = 4 THEN 'Miércoles'
        WHEN DATEPART(weekday, fecha_compra) = 5 THEN 'Jueves'
        WHEN DATEPART(weekday, fecha_compra) = 6 THEN 'Viernes'
        WHEN DATEPART(weekday, fecha_compra) = 7 THEN 'Sábado'
    END AS dia_semana,
    COUNT(*) AS cantidad_compras
FROM clientes
LEFT JOIN ventas ON clientes.id_cliente = ventas.id_cliente
GROUP BY nombre_cliente, dia_semana;

-- Esta consulta muestra los clientes que han realizado compras en días consecutivos y cuántos días seguidos han comprado.
SELECT c.nombre_cliente, MAX(v.fecha_compra) AS ultima_compra,
    DATEDIFF(day, MIN(v.fecha_compra), MAX(v.fecha_compra)) + 1 AS dias_consecutivos_compra
FROM clientes c
INNER JOIN (
    SELECT id_cliente, fecha_compra,
           LEAD(fecha_compra) OVER (PARTITION BY id_cliente ORDER BY fecha_compra) AS fecha_compra_siguiente
    FROM ventas
) v ON c.id_cliente = v.id_cliente
WHERE DATEDIFF(day, v.fecha_compra_siguiente, v.fecha_compra) = 1
GROUP BY c.nombre_cliente
HAVING COUNT(*) > 1
ORDER BY dias_consecutivos_compra DESC;

-- Esta consulta muestra los nombres de los clientes y el total de ventas realizadas, incluyendo clientes sin ventas.
SELECT nombre_cliente, COALESCE(total_ventas, 0) AS total_ventas
FROM clientes
LEFT JOIN (
    SELECT id_cliente, SUM(total_venta) AS total_ventas
    FROM ventas
    GROUP BY id_cliente
) AS ventas_por_cliente ON clientes.id_cliente = ventas_por_cliente.id_cliente
UNION ALL
SELECT 'Sin Ventas', 0
WHERE NOT EXISTS (SELECT 1 FROM ventas WHERE ventas.id_cliente IS NOT NULL);

-- Esta consulta muestra los tres clientes con el gasto más alto, considerando empates.
SELECT nombre_cliente, total_gastado
FROM (
    SELECT nombre_cliente, total_gastado,
           RANK() OVER (ORDER BY total_gastado DESC) AS ranking
    FROM (
        SELECT c.nombre_cliente, SUM(v.total_venta) AS total_gastado
        FROM clientes c
        LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
        GROUP BY c.nombre_cliente
    ) AS gasto_por_cliente
) AS ranking_clientes
WHERE ranking <= 3;

-- Esta consulta muestra los clientes que realizaron compras de productos específicos y su cantidad total de compras.
SELECT c.nombre_cliente, COALESCE(SUM(v.total_venta), 0) AS total_compras
FROM clientes c
LEFT JOIN (
    SELECT id_cliente, total_venta
    FROM ventas
    WHERE producto IN ('cerveza', 'vino')
) v ON c.id_cliente = v.id_cliente
GROUP BY c.nombre_cliente
HAVING COALESCE(SUM(v.total_venta), 0) > 0
ORDER BY total_compras DESC;

-- Esta consulta muestra la cantidad de clientes que han realizado diferentes cantidades de compras.
SELECT 'Clientes con 1 compra' AS categoria, COUNT(*) AS cantidad_clientes
FROM (
    SELECT id_cliente, COUNT(*) AS cantidad_compras
    FROM ventas
    GROUP BY id_cliente
) AS compras_por_cliente
WHERE cantidad_compras = 1
UNION ALL
SELECT 'Clientes con 2 compras', COUNT(*)
FROM (
    SELECT id_cliente, COUNT(*) AS cantidad_compras
    FROM ventas
    GROUP BY id_cliente
) AS compras_por_cliente
WHERE cantidad_compras = 2
UNION ALL
SELECT 'Clientes con 3 compras', COUNT(*)
FROM (
    SELECT id_cliente, COUNT(*) AS cantidad_compras
    FROM ventas
    GROUP BY id_cliente
) AS compras_por_cliente
WHERE cantidad_compras = 3;

-- Esta consulta muestra los clientes y la lista de productos que han comprado, concatenados en una sola cadena.
SELECT c.nombre_cliente, STUFF((
    SELECT ', ' + v.producto
    FROM ventas v
    WHERE v.id_cliente = c.id_cliente
    FOR XML PATH('')), 1, 2, '') AS productos_comprados
FROM clientes c;

-- Esta consulta muestra los clientes que realizaron al menos 3 compras y cuándo hicieron su última compra.
SELECT c.nombre_cliente, v.fecha_compra AS ultima_compra
FROM (
    SELECT id_cliente, fecha_compra,
           ROW_NUMBER() OVER (PARTITION BY id_cliente ORDER BY fecha_compra DESC) AS rn
    FROM ventas
) AS v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente
WHERE rn <= 3;

-- Esta consulta muestra los clientes y sus direcciones completas en una sola cadena.
SELECT c.nombre_cliente,
    CONCAT(c.direccion, ', ', c.ciudad, ', ', c.estado, ', ', c.codigo_postal) AS direccion_completa
FROM clientes c;

-- Esta consulta muestra el número de clientes nuevos y recurrentes en un rango de fechas específico.
SELECT 'Nuevos Clientes' AS tipo_cliente, COUNT(*) AS cantidad
FROM clientes
WHERE fecha_registro BETWEEN '2023-01-01' AND '2023-12-31'
UNION ALL
SELECT 'Clientes Recurrentes', COUNT(*)
FROM clientes
WHERE fecha_registro < '2023-01-01'
AND id_cliente IN (SELECT DISTINCT id_cliente FROM ventas WHERE fecha_compra BETWEEN '2023-01-01' AND '2023-12-31');

-- Esta consulta muestra los clientes que tienen un gasto promedio superior al promedio general de todos los clientes.
SELECT c.nombre_cliente, AVG(v.total_venta) AS gasto_promedio
FROM clientes c
INNER JOIN ventas v ON c.id_cliente = v.id_cliente
GROUP BY c.nombre_cliente
HAVING AVG(v.total_venta) > (SELECT AVG(total_venta) FROM ventas);

-- Esta consulta muestra la cantidad de compras realizadas en cada día de la semana, incluyendo días sin compras.
SELECT 'Lunes' AS dia_semana, COUNT(*) AS cantidad_compras
FROM ventas
WHERE DATEPART(weekday, fecha_compra) = 2
UNION ALL
SELECT 'Martes', COUNT(*)
FROM ventas
WHERE DATEPART(weekday, fecha_compra) = 3
UNION ALL
SELECT 'Miércoles', COUNT(*)
FROM ventas
WHERE DATEPART(weekday, fecha_compra) = 4
UNION ALL
SELECT 'Jueves', COUNT(*)
FROM ventas
WHERE DATEPART(weekday, fecha_compra) = 5
UNION ALL
SELECT 'Viernes', COUNT(*)
FROM ventas
WHERE DATEPART(weekday, fecha_compra) = 6
UNION ALL
SELECT 'Sábado', COUNT(*)
FROM ventas
WHERE DATEPART(weekday, fecha_compra) = 7
UNION ALL
SELECT 'Domingo', COUNT(*)
FROM ventas
WHERE DATEPART(weekday, fecha_compra) = 1;

-- Esta consulta muestra los clientes que no han realizado compras en los últimos 60 días y cuántos días han pasado desde su última compra.
SELECT c.nombre_cliente, MAX(v.fecha_compra) AS ultima_compra,
    DATEDIFF(day, MAX(v.fecha_compra), GETDATE()) AS dias_desde_ultima_compra
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
GROUP BY c.nombre_cliente
HAVING MAX(v.fecha_compra) IS NULL OR DATEDIFF(day, MAX(v.fecha_compra), GETDATE()) > 60;

-- Esta consulta muestra la cantidad de compras realizadas en cada mes del año actual.
SELECT 'Enero' AS mes, COUNT(*) AS cantidad_compras
FROM ventas
WHERE YEAR(fecha_compra) = YEAR(GETDATE()) AND MONTH(fecha_compra) = 1
UNION ALL
SELECT 'Febrero', COUNT(*)
FROM ventas
WHERE YEAR(fecha_compra) = YEAR(GETDATE()) AND MONTH(fecha_compra) = 2
-- Repite para los otros meses del año.

-- Esta consulta muestra los clientes y una lista de los productos que han comprado, separados por comas.
SELECT c.nombre_cliente,
    STRING_AGG(v.producto, ', ') WITHIN GROUP (ORDER BY v.producto) AS productos_comprados
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
GROUP BY c.nombre_cliente;

-- Esta consulta muestra los clientes y una lista de los productos que han comprado, separados por comas.
SELECT c.nombre_cliente,
    STRING_AGG(v.producto, ', ') WITHIN GROUP (ORDER BY v.producto) AS productos_comprados
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
GROUP BY c.nombre_cliente;

-- Esta consulta muestra la cantidad de compras realizadas en días laborables y fines de semana.
SELECT 'Días Laborables' AS tipo_dia, COUNT(*) AS cantidad_compras
FROM ventas
WHERE DATEPART(weekday, fecha_compra) BETWEEN 2 AND 6
UNION ALL
SELECT 'Fines de Semana', COUNT(*)
FROM ventas
WHERE DATEPART(weekday, fecha_compra) IN (1, 7);

-- Esta consulta muestra los clientes que realizaron compras hace más de un año y cuántos años han pasado desde su última compra.
SELECT c.nombre_cliente, MAX(v.fecha_compra) AS ultima_compra,
    DATEDIFF(year, MAX(v.fecha_compra), GETDATE()) AS años_desde_ultima_compra
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
GROUP BY c.nombre_cliente
HAVING MAX(v.fecha_compra) IS NULL OR DATEDIFF(year, MAX(v.fecha_compra), GETDATE()) > 1;


