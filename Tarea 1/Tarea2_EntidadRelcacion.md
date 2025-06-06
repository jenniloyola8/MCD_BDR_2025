# Modelo entidad relación.  
_Autor:_ Jennifer Loyola Quintero

## Modelo entidad-relacion de la base de datos de ventas por region.
```mermaid
erDiagram
    CLIENTES ||--o|| VENTAS : realiza
    VENTAS ||--|| DETALLE_VENTA : contiene
    PRODUCTOS ||--o{ DETALLE_VENTA : vendido_en

    CLIENTES {
        int id_cliente PK
        string nombre
        string ciudad
        string estado
        string codigo_postal
    }

    VENTAS {
        int id_venta PK
        date fecha_venta
        decimal total
        int id_cliente FK
    }

    DETALLE_VENTA {
        int id_detalle PK
        int id_venta FK
        int id_producto FK
        int cantidad
        decimal subtotal
    }

    PRODUCTOS {
        int id_producto PK
        string nombre
        string categoria
        decimal precio
    }
````