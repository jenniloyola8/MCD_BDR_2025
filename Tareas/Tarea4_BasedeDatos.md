# Creacion de Base de Datos, Tablas y Subida de Datos "Manual"
_Autor:_ Jennifer Loyola Quintero

## Codigo en MySQL

```mysql

-- Eliminar base anterior (si deseas reiniciar todo)
DROP DATABASE IF EXISTS ventas_nuevoleon;

-- Crear nueva base
CREATE DATABASE ventas_nuevoleon;
USE ventas_nuevoleon;

-- Tabla CLIENTES
CREATE TABLE CLIENTES (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(100),
    ciudad VARCHAR(100),
    estado VARCHAR(100),
    codigo_postal VARCHAR(10)
);

-- Tabla PRODUCTOS
CREATE TABLE PRODUCTOS (
    id_producto INT PRIMARY KEY,
    nombre VARCHAR(100),
    categoria VARCHAR(50),
    precio DECIMAL(10,2)
);

-- Tabla ESTABLECIMIENTOS (con base en DENUE)
CREATE TABLE ESTABLECIMIENTOS (
    id_establecimiento INT PRIMARY KEY, -- puedes usar 'id' del DENUE
    nombre VARCHAR(150),
    tipo VARCHAR(50),
    sector VARCHAR(100),
    municipio VARCHAR(100),
    online BOOLEAN
);

-- Tabla VENTAS
CREATE TABLE VENTAS (
    id_venta INT PRIMARY KEY,
    fecha_venta DATE,
    total DECIMAL(10,2),
    id_cliente INT,
    id_establecimiento INT,
    FOREIGN KEY (id_cliente) REFERENCES CLIENTES(id_cliente),
    FOREIGN KEY (id_establecimiento) REFERENCES ESTABLECIMIENTOS(id_establecimiento)
);

-- Tabla DETALLE_VENTA
CREATE TABLE DETALLE_VENTA (
    id_detalle INT PRIMARY KEY,
    id_venta INT,
    id_producto INT,
    cantidad INT,
    subtotal DECIMAL(10,2),
    FOREIGN KEY (id_venta) REFERENCES VENTAS(id_venta),
    FOREIGN KEY (id_producto) REFERENCES PRODUCTOS(id_producto)
);

-- Tabla INDICADORES MENSUALES
CREATE TABLE INDICADORES_MENSUALES (
    id_indicador INT PRIMARY KEY AUTO_INCREMENT,
    fecha CHAR(7), -- formato 'YYYY-MM'
    ingreso_mayor DECIMAL(14,2),
    ingreso_menor DECIMAL(14,2),
    personal_mayor INT,
    personal_menor INT,
    rem_mun_mayor DECIMAL(14,2),
    rem_mun_menor DECIMAL(14,2)
);

-- Insertar clientes con base en municipios de Nuevo León
INSERT INTO CLIENTES VALUES
(1, 'Cliente Monterrey',  'Monterrey',      'Nuevo León', '64000'),
(2, 'Cliente Apodaca',     'Apodaca',        'Nuevo León', '66600'),
(3, 'Cliente San Nicolás', 'San Nicolás',    'Nuevo León', '66400'),
(4, 'Cliente Escobedo',    'Escobedo',       'Nuevo León', '66000'),
(5, 'Cliente Garcia',      'García',         'Nuevo León', '66020');

-- Insertar productos 
INSERT INTO PRODUCTOS VALUES 
(1, 'Laptop HP', 'Electrónica', 15000.00),
(2, 'Mouse Logitech', 'Accesorios', 350.00),
(3, 'Audífonos Sony', 'Accesorios', 500.00),
(4, 'Teclado Redragon', 'Accesorios', 640.00);

-- Insertar establecimientos 
INSERT INTO ESTABLECIMIENTOS (id_establecimiento, nombre, tipo, sector, municipio, online) VALUES
(101112, 'Tacos Don Julio', 'Micro', 'Alimentos y bebidas', 'Monterrey', FALSE),
(101113, 'Farmacia San Jorge', 'Pequeña', 'Salud', 'Apodaca', TRUE),
(101114, 'Miscelánea Lupita', 'Micro', 'Comercio minorista', 'San Nicolás', FALSE),
(101115, 'Carnicería El Toro', 'Micro', 'Alimentos', 'Guadalupe', FALSE),
(101116, 'MiniSuper El Águila', 'Micro', 'Comercio minorista', 'Escobedo', TRUE);

-- Insertar ventas con referencia a establecimientos 
INSERT INTO VENTAS (id_venta, fecha_venta, total, id_cliente, id_establecimiento) VALUES
(1, '2025-06-20', 150.00, 1, 101112),
(2, '2025-06-21', 300.00, 2, 101113),
(3, '2025-06-22', 225.00, 3, 101114),
(4, '2025-06-23', 980.00, 4, 101115),
(5, '2025-06-24', 640.00, 5, 101116);

-- Insertar detalle de ventas (productos válidos)
INSERT INTO DETALLE_VENTA VALUES
(1, 1, 2, 1, 150.00),
(2, 2, 3, 1, 300.00),
(3, 3, 2, 1, 225.00),
(4, 4, 1, 1, 980.00),
(5, 5, 4, 1, 640.00);

-- Consultas para ver resultados
SELECT * FROM CLIENTES;
SELECT * FROM ESTABLECIMIENTOS;
SELECT * FROM VENTAS;
SELECT * FROM PRODUCTOS;
SELECT * FROM DETALLE_VENTA;


-- Hasta el momento solo puse pocos datos aun estoy tratando de poner los demas.
```