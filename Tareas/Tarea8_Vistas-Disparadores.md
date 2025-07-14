# Reporte de Vistas y Disparadores 
**Base de Datos de Ventas en Nuevo León**   
_Autor:_ Jennifer Loyola Quintero

**Objetivo:** Facilitar el análisis, la consulta y la gestión de datos en una base de datos relacional de ventas (basada parcialmente en DENUE), mediante la creación de vistas y disparadores que:
- Mejoren la legibilidad de los datos.
- Eviten errores de actualización manual.
- Permitan identificar patrones, excepciones o inconsistencias.
- Sirvan como base para reportes o dashboards.

---

## Crear vistas sobre consultas significativas, recurrentes, entre otras, las cuales:
### a) Vista con JOIN 
- ¿Qué hace?
Combina varias tablas (VENTAS, CLIENTES, DETALLE_VENTA, PRODUCTOS y ESTABLECIMIENTOS) para mostrar un detalle completo de cada venta.
Muestra una vista completa de cada venta: incluye el cliente, el establecimiento, los productos vendidos, la cantidad, el subtotal y la fecha.

- Contenido de la vista:
    - Fecha de la venta.
    - Cliente que compró.
    - Producto comprado.
    - Cantidad y subtotal.
    - Establecimiento donde se realizó la compra.

``` sql
    CREATE OR REPLACE VIEW vista_ventas_detalladas AS
    SELECT 
        v.id_venta,
        c.nombre AS cliente,
        e.nombre AS establecimiento,
        p.nombre AS producto,
        dv.cantidad,
        dv.subtotal,
        v.fecha_venta
    FROM VENTAS v
    JOIN CLIENTES c ON v.id_cliente = c.id_cliente
    JOIN ESTABLECIMIENTOS e ON v.id_establecimiento = e.id_establecimiento
    JOIN DETALLE_VENTA dv ON v.id_venta = dv.id_venta
    JOIN PRODUCTOS p ON dv.id_producto = p.id_producto;
    
    SELECT * FROM vista_ventas_detalladas;
```

### b) Vista con LEFT JOIN

### c) Vista con RIGHT JOIN

### d) Vista con subconsulta

## Crear almenos un disparador de inserción (TRIGGER), actualizacion o eliminacion.