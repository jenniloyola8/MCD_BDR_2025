
Project "Ventas por Región" {
  database_type: "MySQL"
}

Table clientes {
  id_cliente int [pk]
  nombre varchar
  ciudad varchar
  estado varchar
  codigo_postal varchar
}

Table ventas {
  id_venta int [pk]
  id_cliente int [ref: > clientes.id_cliente]
  fecha_venta date
  total decimal
}

Table productos {
  id_producto int [pk]
  nombre varchar
  categoria varchar
  precio decimal
}

Table detalle_venta {
  id_detalle int [pk]
  id_venta int [ref: > ventas.id_venta]
  id_producto int [ref: > productos.id_producto]
  cantidad int
  subtotal decimal
}
