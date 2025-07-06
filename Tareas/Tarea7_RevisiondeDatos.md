# Reporte de Hallazgos y Limpieza de Datos  
**Base de Datos de Ventas en Nuevo León**   
_Autor:_ Jennifer Loyola Quintero

---

**Objetivo:** Evaluar la integridad de una base de datos relacional de ventas basadas en municipios de Nuevo León, generada con datos del DENUE y datos simulados, para identificar inconsistencias, realizar ajustes y facilitar el análisis con vistas y subconsultas SQL.

## Hallazgos Detectados:

- **Clientes sin compras:**  
  Se detectaron **49 clientes** registrados en la base de datos que no tienen ninguna venta asociada.  
  > Esto puede indicar carga anticipada o falta de actividad del cliente.

- **Productos y establecimientos sin ventas:**  
  Todos los productos tienen al menos una venta.  
  Todos los establecimientos registrados han realizado al menos una venta.

- **Ventas con totales incorrectos:**  
  Se encontraron **2,999 registros** en la tabla `VENTAS` cuyo campo `total` no coincidía con la suma de los subtotales de los productos asociados (tabla `DETALLE_VENTA`).

## Acciones Realizadas:

- **Corrección de totales erróneos:**  
  Se ejecutó la siguiente consulta para corregir automáticamente los totales:

  ```sql
  UPDATE VENTAS v
  JOIN (
      SELECT id_venta, SUM(subtotal) AS suma_detalle
      FROM DETALLE_VENTA
      GROUP BY id_venta
  ) AS dv_sum ON v.id_venta = dv_sum.id_venta
  SET v.total = dv_sum.suma_detalle;
  ```

- **Creación de vista para análisis cruzado:**
   Se creó la vista vista_ventas_completas que une la información de clientes, productos, establecimientos, ventas y detalle de venta para facilitar reportes y análisis.

- **Optimización con índices:**
  Se añadieron índices para mejorar el rendimiento de búsqueda en columnas frecuentes:
  ```sql
  CREATE INDEX idx_fecha_venta ON VENTAS(fecha_venta);
  CREATE INDEX idx_venta_cliente ON VENTAS(id_cliente);
  CREATE INDEX idx_venta_establecimiento ON VENTAS(id_establecimiento);
  ```