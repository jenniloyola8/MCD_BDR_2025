-- Eliminar la base si ya existía
DROP DATABASE IF EXISTS ventas_nuevoleon;

-- Crear base de datos
CREATE DATABASE ventas_nuevoleon;
USE ventas_nuevoleon;

-- Crear tabla CLIENTES
CREATE TABLE CLIENTES (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(100),
    ciudad VARCHAR(100),
    estado VARCHAR(100),
    codigo_postal VARCHAR(10)
);

-- Crear tabla PRODUCTOS
CREATE TABLE PRODUCTOS (
    id_producto INT PRIMARY KEY,
    nombre VARCHAR(100),
    categoria VARCHAR(50),
    precio DECIMAL(10,2)
);

-- Crear tabla VENTAS
CREATE TABLE VENTAS (
    id_venta INT PRIMARY KEY,
    fecha_venta DATE,
    total DECIMAL(10,2),
    id_cliente INT,
    FOREIGN KEY (id_cliente) REFERENCES CLIENTES(id_cliente)
);

-- Crear tabla DETALLE_VENTA
CREATE TABLE DETALLE_VENTA (
    id_detalle INT PRIMARY KEY,
    id_venta INT,
    id_producto INT,
    cantidad INT,
    subtotal DECIMAL(10,2),
    FOREIGN KEY (id_venta) REFERENCES VENTAS(id_venta),
    FOREIGN KEY (id_producto) REFERENCES PRODUCTOS(id_producto)
);

-- Insertar productos
INSERT INTO PRODUCTOS VALUES 
(1, 'Laptop HP', 'Electrónica', 15000.00),
(2, 'Mouse Logitech', 'Accesorios', 350.00);

-- Insertar clientes con base en municipios reales de Nuevo León
INSERT INTO CLIENTES VALUES
(1, 'Cliente Monterrey',  'Monterrey',      'Nuevo León', '64000'),
(2, 'Cliente Apodaca',     'Apodaca',        'Nuevo León', '66600'),
(3, 'Cliente San Nicolás', 'San Nicolás',    'Nuevo León', '66400'),
(4, 'Cliente Escobedo',    'Escobedo',       'Nuevo León', '66000'),
(5, 'Cliente Garcia',      'García',         'Nuevo León', '66020');

-- Insertar ventas
INSERT INTO VENTAS VALUES
(1, '2025-06-05', 500.00, 1),
(2, '2025-06-06', 750.00, 2),
(3, '2025-06-07', 300.00, 3),
(4, '2025-06-08', 1200.00, 4),
(5, '2025-06-09', 450.00, 5);

-- Insertar detalle de ventas (productos válidos)
INSERT INTO DETALLE_VENTA VALUES
(1, 1, 2, 1, 500.00),
(2, 2, 1, 1, 750.00),
(3, 3, 2, 1, 300.00),
(4, 4, 1, 1, 1200.00),
(5, 5, 2, 1, 450.00);


SELECT * FROM CLIENTES;
SELECT * FROM VENTAS;
SELECT * FROM PRODUCTOS;
SELECT * FROM DETALLE_VENTA;

-- Hasta el momento solo puse pocos datos aun estoy tratando de poner los demas.