# Modelo entidad relación.  
_Autor:_ Jennifer Loyola Quintero

## Modelo relacional a partir de modelo entidad-relacion de la base de datos de ventas por region.
```mermaid
erDiagram
    CLIENTES ||--o{ VENTAS : Realiza
    VENTAS ||--|{ DETALLE_VENTA : Contiene
    PRODUCTOS ||--o{ DETALLE_VENTA : vendido_en

    CLIENTES {
        int id_cliente 
        string nombre
        string ciudad
        string estado
        string codigo_postal
    }

    VENTAS {
        int id_venta 
        date fecha_venta
        decimal total
        int id_cliente 
    }

    DETALLE_VENTA {
        int id_detalle 
        int id_venta 
        int id_producto 
        int cantidad
        decimal subtotal
    }

    PRODUCTOS {
        int id_producto 
        string nombre
        string categoria
        decimal precio
    }
````

---

## Operaciones del Álgebra Relacional – Análisis de Ventas en Nuevo León

Estas son algunas operaciones del álgebra relacional aplicadas a una base de datos que almacena información sobre ventas, clientes y productos en el estado de **Nuevo León**.

### 1. **Selección (σ)**  
**Consulta:** Obtener todas las ventas realizadas por clientes que viven en el estado de "Nuevo León".

**Expresión:**
σ estado = 'Nuevo león' (CLIENTES ⨝ VENTAS)

**Explicación:**  
Se combinan las tablas CLIENTES y VENTAS (por `id_cliente`) y luego se filtran únicamente aquellas ventas en las que el cliente pertenece al estado de Nuevo León.

### 2. **Proyección (π)**  
**Consulta:** Ver solo los nombres y precios de los productos vendidos en Nuevo León.

**Expresión:**
π nombre, precio(PRODUCTOS ⨝ DETALLE_VENTA ⨝ VENTAS ⨝ CLIENTES), estado = 'Nuevo León'

**Explicación:**  
Después de unir las tablas PRODUCTOS, DETALLE_VENTA, VENTAS y CLIENTES, se filtran las ventas en Nuevo León y se seleccionan solo las columnas de nombre y precio del producto.

### 3. **Join natural (⨝)**  
**Consulta:** Obtener los detalles completos de cada venta (cliente, producto y subtotal) en Nuevo León.

**Expresión:**
CLIENTES ⨝ VENTAS ⨝ DETALLE_VENTA ⨝ PRODUCTOS, estado = 'Nuevo León'

**Explicación:**  
Se unen todas las tablas para mostrar información completa sobre qué se vendió, a quién y por cuánto, pero solo si el cliente vive en Nuevo León.

### 4. **Agregación (γ)**  
**Consulta:** Calcular el total de ventas por ciudad dentro de Nuevo León.

**Expresión:**
γ ciudad, SUM(total) → total_ventas(CLIENTES ⨝ VENTAS), estado = 'Nuevo León'

**Explicación:**  
Se agrupan las ventas por ciudad (dentro del estado de Nuevo León) y se suman los totales de ventas para obtener el monto total vendido en cada ciudad.