# Creacion de Base de Datos, Tablas y Subida de Datos "Manual"
_Autor:_ Jennifer Loyola Quintero

Creacion de base de datos, tablas y subida de los datos de forma manual.

La base de datos 'ventas_nuevoleon' está diseñada para registrar y analizar las ventas realizadas en establecimientos comerciales del estado de Nuevo León, México. Su estructura permite vincular clientes, productos, establecimientos y las transacciones realizadas entre ellos.
Contiene las siguientes tablas principales:

1. CLIENTES
Registra información básica de los compradores, incluyendo nombre, municipio y código postal.

2. PRODUCTOS
Contiene el catálogo de productos disponibles para la venta, clasificados por categoría y precio.

3. ESTABLECIMIENTOS
Describe los comercios donde se realizan las ventas, incluyendo su tipo (micro, pequeña), sector económico, municipio y si operan en línea.

4. VENTAS
Almacena cada transacción realizada, vinculando al cliente y al establecimiento donde ocurrió, junto con la fecha y el total.

5. DETALLE_VENTA
Representa los productos específicos vendidos en cada venta (relación de muchos a muchos entre ventas y productos), indicando cantidad y subtotal.

Hasta el momento solo puse 20 datos, se me esta dificultando un poco la generalizacon de todos los datos ya que estoy limpiando la base que encontre por lo que tuve que poner los datos de manera manual.

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
(1,  'Cliente Monterrey',     'Monterrey',       'Nuevo León', '64000'),
(2,  'Cliente Apodaca',       'Apodaca',         'Nuevo León', '66600'),
(3,  'Cliente San Nicolás',   'San Nicolás',     'Nuevo León', '66400'),
(4,  'Cliente Escobedo',      'Escobedo',        'Nuevo León', '66000'),
(5,  'Cliente Garcia',        'García',          'Nuevo León', '66020'),
(6,  'Cliente Guadalupe',     'Guadalupe',       'Nuevo León', '67100'),
(7,  'Cliente Santa Catarina','Santa Catarina',  'Nuevo León', '66350'),
(8,  'Cliente Juárez',        'Juárez',          'Nuevo León', '67250'),
(9,  'Cliente Linares',       'Linares',         'Nuevo León', '67700'),
(10, 'Cliente Cadereyta',     'Cadereyta',       'Nuevo León', '67480'),
(11, 'Cliente Sabinas',       'Sabinas Hidalgo', 'Nuevo León', '65200'),
(12, 'Cliente Salinas',       'Salinas Victoria','Nuevo León', '65500'),
(13, 'Cliente Pesquería',     'Pesquería',       'Nuevo León', '66670'),
(14, 'Cliente Zuazua',        'General Zuazua',  'Nuevo León', '65770'),
(15, 'Cliente Allende',       'Allende',         'Nuevo León', '67350'),
(16, 'Cliente Montemorelos',  'Montemorelos',    'Nuevo León', '67500'),
(17, 'Cliente Santiago',      'Santiago',        'Nuevo León', '67300'),
(18, 'Cliente Higueras',      'Higueras',        'Nuevo León', '65510'),
(19, 'Cliente China',         'China',           'Nuevo León', '67920'),
(20, 'Cliente Doctor Arroyo', 'Doctor Arroyo',   'Nuevo León', '67900');


-- Insertar productos 
INSERT INTO PRODUCTOS VALUES  
(1,  'Refresco 600ml',             'Alimentos y bebidas',   18.00),
(2,  'Taco de Bistec',             'Alimentos y bebidas',   20.00),
(3,  'Ibuprofeno 400mg',           'Farmacia',              45.00),
(4,  'Shampoo 750ml',              'Farmacia',              95.00),
(5,  'Pan de dulce',               'Alimentos y bebidas',   12.00),
(6,  'Bistec de res (kg)',         'Carnicería',           150.00),
(7,  'Aceite 1L',                  'Comercio minorista',    38.00),
(8,  'Detergente 1kg',             'Comercio minorista',    32.00),
(9,  'Arroz 1kg',                  'Comercio minorista',    24.00),
(10, 'Pasta dental 90g',           'Farmacia',              25.00),
(11, 'Sabritas 45g',               'Miscelánea',            14.00),
(12, 'Pan blanco',                 'Panadería',             35.00),
(13, 'Agua purificada 1.5L',       'Miscelánea',            17.00),
(14, 'Tortillas de maíz 1kg',      'Miscelánea',            19.00),
(15, 'Té de hierbas',              'Naturista',             60.00),
(16, 'Crema para golpes',          'Naturista',             90.00),
(17, 'Pala metálica',              'Ferretería',           230.00),
(18, 'Juego de desarmadores',      'Ferretería',           120.00),
(19, 'Filtro de aceite',           'Refaccionaria',         95.00),
(20, 'Aceite para motor 1L',       'Refaccionaria',        185.00);


-- Insertar establecimientos 
INSERT INTO ESTABLECIMIENTOS (id_establecimiento, nombre, tipo, sector, municipio, online) VALUES
(101112, 'Tacos Don Julio',       'Micro',    'Alimentos y bebidas', 'Monterrey',       FALSE),
(101113, 'Farmacia San Jorge',    'Pequeña',  'Salud',               'Apodaca',         TRUE),
(101114, 'Miscelánea Lupita',     'Micro',    'Comercio minorista',  'San Nicolás',     FALSE),
(101115, 'Carnicería El Toro',    'Micro',    'Alimentos',           'Guadalupe',       FALSE),
(101116, 'MiniSuper El Águila',   'Micro',    'Comercio minorista',  'Escobedo',        TRUE),
(101117, 'Papelería El Sol',      'Micro',    'Comercio minorista',  'Guadalupe',       FALSE),
(101118, 'Panadería Los Pinos',   'Micro',    'Alimentos',           'Santa Catarina',  FALSE),
(101119, 'TechZone',              'Pequeña',  'Tecnología',          'Monterrey',       TRUE),
(101120, 'Farmacia Nueva Vida',   'Pequeña',  'Salud',               'Linares',         FALSE),
(101121, 'Bodega Express',        'Micro',    'Comercio minorista',  'Apodaca',         TRUE),
(101122, 'Comida Doña Mary',      'Micro',    'Alimentos',           'Juárez',          FALSE),
(101123, 'Super El Buen Precio',  'Pequeña',  'Comercio minorista',  'Cadereyta',       TRUE),
(101124, 'Farmacia Popular',      'Micro',    'Salud',               'Sabinas Hidalgo', FALSE),
(101125, 'Ferretería del Norte',  'Pequeña',  'Construcción',        'Santa Catarina',  TRUE),
(101126, 'Refaccionaria El Motor','Micro',    'Automotriz',          'Escobedo',        FALSE),
(101127, 'Tienda Naturista Luz',  'Micro',    'Salud',               'Santiago',        TRUE),
(101128, 'Minisúper Don Beto',    'Micro',    'Comercio minorista',  'Montemorelos',    FALSE),
(101129, 'Taquería El Güero',     'Micro',    'Alimentos',           'Zuazua',          FALSE),
(101130, 'Abarrotes El 10',       'Micro',    'Comercio minorista',  'Allende',         TRUE),
(101131, 'Miscelánea Lupita 2',   'Micro',    'Comercio minorista',  'Salinas Victoria',FALSE);


-- Insertar ventas con referencia a establecimientos 
INSERT INTO VENTAS (id_venta, fecha_venta, total, id_cliente, id_establecimiento) VALUES
(1,  '2025-06-10',  60.00,  1, 101112), -- Tacos Don Julio
(2,  '2025-06-11',  90.00,  2, 101113), -- Farmacia San Jorge
(3,  '2025-06-12',  48.00,  3, 101114), -- Miscelánea Lupita
(4,  '2025-06-13', 150.00,  4, 101115), -- Carnicería El Toro
(5,  '2025-06-14',  70.00,  5, 101116), -- MiniSuper El Águila
(6,  '2025-06-15',  32.00,  6, 101117), -- Papelería El Sol
(7,  '2025-06-16',  50.00,  7, 101118), -- Panadería Los Pinos
(8,  '2025-06-17',  95.00,  8, 101119), -- TechZone
(9,  '2025-06-18',  70.00,  9, 101120), -- Farmacia Nueva Vida
(10, '2025-06-19',  62.00, 10, 101121), -- Bodega Express
(11, '2025-06-20', 150.00, 11, 101122), -- Comida Doña Mary
(12, '2025-06-21',  90.00, 12, 101123), -- Super El Buen Precio
(13, '2025-06-22',  45.00, 13, 101124), -- Farmacia Popular
(14, '2025-06-23', 230.00, 14, 101125), -- Ferretería del Norte
(15, '2025-06-24', 185.00, 15, 101126), -- Refaccionaria El Motor
(16, '2025-06-25',  60.00, 16, 101127), -- Naturista Luz
(17, '2025-06-26',  80.00, 17, 101128), -- Minisúper Don Beto
(18, '2025-06-27',  33.00, 18, 101129), -- Taquería El Güero
(19, '2025-06-28',  55.00, 19, 101130), -- Abarrotes El 10
(20, '2025-06-29',  38.00, 20, 101131); -- Miscelánea Lupita 2


-- Insertar detalle de ventas (productos válidos)
INSERT INTO DETALLE_VENTA VALUES
(1,  1,  2, 3,  60.00),  -- 3 tacos
(2,  2,  3, 2,  90.00),  -- 2 ibuprofenos
(3,  3, 11, 2,  28.00),  -- 2 sabritas
(4,  4,  6, 1, 150.00),  -- 1 kg bistec
(5,  5,  7, 1,  38.00),
(6,  5, 13, 1,  17.00),
(7,  6,  8, 1,  32.00),
(8,  7,  5, 4,  48.00),
(9,  8,  4, 1,  95.00),
(10, 9, 10, 2,  50.00),
(11, 9,  3, 1,  45.00),
(12, 10, 7, 1,  38.00),
(13, 10, 9, 1,  24.00),
(14, 11, 2, 5, 100.00),
(15, 11, 1, 2,  36.00),
(16, 12, 8, 2,  64.00),
(17, 13, 3, 1,  45.00),
(18, 14,17, 1, 230.00),
(19, 15,20, 1, 185.00),
(20, 16,16, 1,  90.00);


-- Consultas para ver resultados
SELECT * FROM CLIENTES;
SELECT * FROM ESTABLECIMIENTOS;
SELECT * FROM VENTAS;
SELECT * FROM PRODUCTOS;
SELECT * FROM DETALLE_VENTA;
```