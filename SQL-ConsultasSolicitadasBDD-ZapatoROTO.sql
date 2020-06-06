--Consulta la facturación de un cliente en específico.

--Esta consulta muestra el total a pagar por los zapatos adquiridos a partir de un número de documento del cliente
--Se hace uso de una tabla temporal con la sentencia WITH para poder simular el calculo total a pagar por el cliente
WITH resFactura as ( SELECT 
	Cliente.nombre as Nombre,
	Cliente.noDocumento as Identificacion,
	Producto.nombre as Articulo,
	Factura.fechaCompra as FechaCompra,
	Factura.cantidad as Cantidad,
	Producto.precio as Precio,
	Factura.cantidad * Producto.precio as Subtotal, 
	Descuento.valor as Descuento, 
	Impuesto.valor as Impuesto,
	---Si el Zapato comprado TIENE algun descuento de la tabla Descuento.valor, 
	---se realiza la siguiente operación; y se asgina al ALIAS TOTAL1
	Producto.precio * Impuesto.valor +  Producto.precio * Descuento.valor * Factura.cantidad as Total1,
	---Si el Zapato comprado NO TIENE DESCUENTO, 
	--se realiza la siguiente operación; y se asgina al ALIAS TOTAL2
	Producto.precio * Impuesto.valor +  Producto.precio * Factura.cantidad as Total2
	FROM Factura
JOIN  Producto
ON Factura.idProducto= Producto.idProducto
JOIN Descuento
ON Producto.idDescuento= Descuento.idDescuento
JOIN Impuesto
ON Producto.idImpuesto= Impuesto.idImpuesto
JOIN Cliente
ON Cliente.idCliente = Factura.idCliente 
JOIN Identificacion
ON Identificacion.idIdentificacion = Cliente.idIdentificacion
where Cliente.noDocumento='98T5634218796JH'
)
select Identificacion,Nombre, Articulo, FechaCompra, Cantidad, Precio, Subtotal, Descuento, Impuesto,
TotalConDescuento=
case
--Cuando el producto adquirido tenga un descuento
when  Descuento>0.00 then Total1
end,
TotalSinDescuento=
case
--Cuando el producto adquirido no tiene ningun descuento
when  Descuento=0.00 then Total2
end
from resFactura;



--Consulta la facturación de un producto en específico.
--Se realiza la consulta de un producto a partir de un idProducto especifico
----Se hace uso de una tabla temporal con la sentencia WITH para poder simular el calculo total a pagar por el cliente
WITH resFacturaProducto as ( SELECT 
	Producto.nombre as Articulo,
	Factura.fechaCompra as FechaCompra,
	Factura.cantidad as Cantidad,
	Producto.precio as Precio,
	Factura.cantidad * Producto.precio as Subtotal, 
	Descuento.valor as Descuento, 
	Impuesto.valor as Impuesto,
	---Si el Zapato comprado TIENE algun descuento de la tabla Descuento.valor, 
	---se realiza la siguiente operación; y se asgina al ALIAS TOTAL1
	Producto.precio * Impuesto.valor +  Producto.precio * Descuento.valor * Factura.cantidad as Total1,
	---Si el Zapato comprado NO TIENE DESCUENTO, 
	--se realiza la siguiente operación; y se asgina al ALIAS TOTAL2
	Producto.precio * Impuesto.valor +  Producto.precio * Factura.cantidad as Total2
	FROM Factura
JOIN  Producto
ON Factura.idProducto= Producto.idProducto
JOIN Descuento
ON Producto.idDescuento= Descuento.idDescuento
JOIN Impuesto
ON Producto.idImpuesto= Impuesto.idImpuesto
where Producto.idProducto=20
)
select  Articulo, FechaCompra, Cantidad, Precio, Subtotal, Descuento, Impuesto,
TotalConDescuento=
case
when  Descuento>0.00 then Total1
end,
TotalSinDescuento=
case
when  Descuento=0.00 then Total2
end
from resFacturaProducto;



--Consulta la facturación de un rango de fechas.
--Se filtran las facturas a apartir de la fecha de compra
WITH resFacturaProducto as ( SELECT 
	Producto.nombre as Articulo,
	Factura.fechaCompra as FechaCompra,
	Factura.cantidad as Cantidad,
	Producto.precio as Precio,
	Factura.cantidad * Producto.precio as Subtotal, 
	Descuento.valor as Descuento, 
	Impuesto.valor as Impuesto,
	---Si el Zapato comprado TIENE algun descuento de la tabla Descuento.valor, 
	---se realiza la siguiente operación; y se asgina al ALIAS TOTAL1
	Producto.precio * Impuesto.valor +  Producto.precio * Descuento.valor * Factura.cantidad as Total1,
	---Si el Zapato comprado NO TIENE DESCUENTO, 
	--se realiza la siguiente operación; y se asgina al ALIAS TOTAL2
	Producto.precio * Impuesto.valor +  Producto.precio * Factura.cantidad as Total2
	FROM Factura
JOIN  Producto
ON Factura.idProducto= Producto.idProducto
JOIN Descuento
ON Producto.idDescuento= Descuento.idDescuento
JOIN Impuesto
ON Producto.idImpuesto= Impuesto.idImpuesto
where Factura.FechaCompra between '2020-05-01' and '2020-06-05'
)
select  Articulo, FechaCompra, Cantidad, Precio, Subtotal, Descuento, Impuesto,
TotalConDescuento=
case
when  Descuento>0.00 then Total1
end,
TotalSinDescuento=
case
when  Descuento=0.00 then Total2
end
from resFacturaProducto;



--De la facturación, consulta los clientes únicos (es decir, se requiere el listado de los clientes que han comprado 
--por lo menos una vez, pero en el listado no se deben repetir los clientes)
--Se filtran los clientes con sus respectivas identificaciones que comprarón al menos un producto
SELECT 
	distinct Cliente.nombre,
	Cliente.noDocumento
	FROM Factura
JOIN Cliente
ON Cliente.idCliente = Factura.idCliente 
JOIN Identificacion
ON Identificacion.idIdentificacion = Cliente.idIdentificacion
