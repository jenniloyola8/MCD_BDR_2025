# Modelo entidad relación.  
_Autor:_ Jennifer Loyola Quintero

## Modelo entidad-relacion por medio de diagrama entidad-relacion.
![Insert base de datos](https://github.com/jenniloyola8/MCD_BDR_2025/blob/main/Tarea%201/diagrama_er_ventas.png)

## Modelo entidad-relacion de la base de datos de ventas por region.
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