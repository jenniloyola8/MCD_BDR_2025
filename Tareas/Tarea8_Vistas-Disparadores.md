# Reporte de Vistas y Disparadores 
**Base de Datos de Ventas en Nuevo León**   
_Autor:_ Jennifer Loyola Quintero

---

> **Objetivo:** 
    Facilitar el análisis, la consulta y la gestión de datos en una base de datos relacional de ventas (basada en DENUE), mediante la creación de vistas y disparadores que:
        - Mejoren la legibilidad de los datos.
        - Eviten errores de actualización manual.
        - Permitan identificar patrones, excepciones o inconsistencias.
        - Sirvan como base para reportes o dashboards.

## Crear vistas sobre consultas significativas, recurrentes, entre otras, las cuales:
### a) Vista con JOIN 
- **¿Qué hace?**
    Combina varias tablas (VENTAS, CLIENTES, DETALLE_VENTA, PRODUCTOS y ESTABLECIMIENTOS) para mostrar un detalle completo de cada venta.
    Muestra una vista completa de cada venta: incluye el cliente, el establecimiento, los productos vendidos, la cantidad, el subtotal y la fecha.

- **Contenido de la vista:**
    - Fecha de la venta.
    - Cliente que compró.
    - Producto comprado.
    - Cantidad y subtotal.
    - Establecimiento donde se realizó la compra.

> **Objetivo:**
    Tener una vista integrada de cada transacción para facilitar el análisis de ventas, como si fuera un reporte listo para visualizar.

- **Codigo en MySQL**
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
- **¿Qué hace?**
    Incluye todos los clientes, incluso los que no tienen ventas. Muestra la información del cliente junto con el total de compras (si tiene).

- **Contenido de la vista:**
    - Nombre del cliente.
    - ID de cliente.
    - Total gastado (o NULL si no ha comprado nada).

> **Objetivo:**
    Detectar clientes inactivos o nuevos y ayudar en campañas de seguimiento, marketing o fidelización.

- **Codigo en MySQL**
```sql 
    CREATE OR REPLACE VIEW vista_clientes_ventas AS
    SELECT 
        c.id_cliente,
        c.nombre,
        v.id_venta,
        v.total
    FROM CLIENTES c
    LEFT JOIN VENTAS v ON c.id_cliente = v.id_cliente;

    SELECT * FROM vista_clientes_ventas;
```

### c) Vista con RIGHT JOIN
- **¿Qué hace?**
    Muestra todos los productos, incluso aquellos que no se han vendido aún. Muestra cantidad vendida y nombre.

- **Contenido de la vista:**
    - ID del producto.
    - Nombre del producto.
    - Cantidad vendida (o NULL si no se ha vendido).

> **Objetivo:**
    Detectar productos sin rotación, exceso de inventario o desactualizados.

- **Codigo en MySQL**
```sql
    CREATE OR REPLACE VIEW vista_productos_ventas AS
    SELECT 
        dv.id_venta,
        p.id_producto,
        p.nombre AS producto,
        dv.cantidad,
        dv.subtotal
    FROM DETALLE_VENTA dv
    RIGHT JOIN PRODUCTOS p ON dv.id_producto = p.id_producto;

    SELECT * FROM vista_productos_ventas;
```

### d) Vista con subconsulta
- **¿Qué hace?**
    Muestra sólo aquellas ventas cuyo monto total es mayor al promedio general de todas las ventas.

- **Contenido de la vista:**
    - ID de venta.
    - Fecha.
    - Total.
    - Cliente.
    - Establecimiento.

> **Objetivo:**
    Identificar ventas sobresalientes que pueden ser relevantes para estudios de alto consumo, promociones efectivas o comportamiento de clientes frecuentes.

- **Codigo en MySQL**
```sql
    CREATE OR REPLACE VIEW vista_ventas_sobresalientes AS
    SELECT * FROM VENTAS
    WHERE total > (
        SELECT AVG(total) FROM VENTAS
    );

    SELECT * FROM vista_ventas_sobresalientes;
```

## Crear almenos un disparador de inserción (TRIGGER), actualizacion o eliminacion.
> TRIGGER:
- **¿Qué hace?**
    Cada vez que se inserta un nuevo detalle de venta en DETALLE_VENTA, el disparador:
        1. Calcula la suma de los subtotales para esa venta.
        2. Actualiza el campo total en la tabla VENTAS.

> **Objetivo:**
    Automatizar la actualización del total de una venta, eliminando errores manuales y asegurando que la información esté siempre consistente.

- **Codigo en MySQL**
```sql
    DELIMITER $$

    CREATE TRIGGER actualizar_total_venta
    AFTER INSERT ON DETALLE_VENTA
    FOR EACH ROW
    BEGIN
        UPDATE VENTAS
        SET total = (
            SELECT SUM(subtotal)
            FROM DETALLE_VENTA
            WHERE id_venta = NEW.id_venta
        )
    WHERE id_venta = NEW.id_venta;
    END$$
```