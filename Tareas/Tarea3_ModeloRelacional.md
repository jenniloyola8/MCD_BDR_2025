# Modelo entidad relación.  
_Autor:_ Jennifer Loyola Quintero

---

## Modelo Entidad-Relación – Análisis de Ventas en Nuevo León

Para el análisis de ventas en el estado de **Nuevo León**, organizamos los datos en una base de datos relacional estructurada. Esta base de datos permite representar las relaciones entre clientes, ventas, productos y detalles de cada venta.

El modelo entidad-relación representa visualmente cómo se relacionan las entidades:

- Un **cliente** puede hacer muchas **ventas**.
- Cada **venta** puede incluir uno o más **productos**.
- La relación entre una venta y los productos vendidos se almacena en la entidad intermedia **detalle_venta**.

A continuación se muestra el equema del modelo relacional entidad-relación junto con los dominios de los atributos principales.

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

##  Diagrama Relacional – Análisis de Ventas en Nuevo León

A continuación, se presenta el modelo relacional derivado del esquema de análisis de ventas, adaptado para bases de datos como MySQL. Las relaciones incluyen llaves primarias (PK) y foráneas (FK) para estructurar adecuadamente la información.

### CLIENTES
- **id_cliente** (PK)
- nombre
- ciudad
- estado
- codigo_postal

### VENTAS
- **id_venta** (PK)
- fecha_venta
- total
- **id_cliente** (FK → CLIENTES.id_cliente)

### PRODUCTOS
- **id_producto** (PK)
- nombre
- categoria
- precio

### DETALLE_VENTA
- **id_detalle** (PK)
- **id_venta** (FK → VENTAS.id_venta)
- **id_producto** (FK → PRODUCTOS.id_producto)
- cantidad
- subtotal

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

---