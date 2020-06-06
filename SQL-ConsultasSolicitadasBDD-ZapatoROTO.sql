--Consulta la facturación de un cliente en específico.
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
	Producto.precio * Impuesto.valor +  Producto.precio * Descuento.valor * Factura.cantidad as Total1,
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
when  Descuento>0.00 then Total1
end,
TotalSinDescuento=
case
when  Descuento=0.00 then Total2
end
from resFactura;



--Consulta la facturación de un producto en específico.
WITH resFacturaProducto as ( SELECT 
	Producto.nombre as Articulo,
	Factura.fechaCompra as FechaCompra,
	Factura.cantidad as Cantidad,
	Producto.precio as Precio,
	Factura.cantidad * Producto.precio as Subtotal, 
	Descuento.valor as Descuento, 
	Impuesto.valor as Impuesto,
	Producto.precio * Impuesto.valor +  Producto.precio * Descuento.valor * Factura.cantidad as Total1,
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
WITH resFacturaProducto as ( SELECT 
	Producto.nombre as Articulo,
	Factura.fechaCompra as FechaCompra,
	Factura.cantidad as Cantidad,
	Producto.precio as Precio,
	Factura.cantidad * Producto.precio as Subtotal, 
	Descuento.valor as Descuento, 
	Impuesto.valor as Impuesto,
	Producto.precio * Impuesto.valor +  Producto.precio * Descuento.valor * Factura.cantidad as Total1,
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

SELECT 
	distinct Cliente.nombre,
	Cliente.noDocumento
	FROM Factura
JOIN Cliente
ON Cliente.idCliente = Factura.idCliente 
JOIN Identificacion
ON Identificacion.idIdentificacion = Cliente.idIdentificacion
