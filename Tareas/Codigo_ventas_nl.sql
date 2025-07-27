-- Eliminar base anterior (si deseas reiniciar todo)
DROP DATABASE IF EXISTS ventas_nl;

-- Crear nueva base
CREATE DATABASE ventas_nl;
USE ventas_nl;

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
    categoria VARCHAR(150),
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

-- Consultas para ver resultados
SELECT * FROM CLIENTES;
SELECT * FROM ESTABLECIMIENTOS;
SELECT * FROM VENTAS;
SELECT * FROM PRODUCTOS;
SELECT * FROM DETALLE_VENTA;
SELECT * FROM INDICADORES_MENSUALES;

USE ventas_nl;

-- Frecuencia por establecimiento:
SELECT 
  id_establecimiento, 
  COUNT(*) AS frecuencia_ventas
FROM VENTAS
GROUP BY id_establecimiento
ORDER BY frecuencia_ventas DESC;

-- Media, mínimo y máximo del total:
SELECT
  AVG(total) AS media_total,
  MIN(total) AS minimo_total,
  MAX(total) AS maximo_total
FROM VENTAS;

-- Cuantil (ej. 25%): (MySQL >= 8.0)
SELECT FLOOR(COUNT(*) * 0.25) AS offset_25 FROM VENTAS;
SELECT AVG(total) AS cuantil_25
FROM (
  SELECT total
  FROM VENTAS
  ORDER BY total
  LIMIT 2 OFFSET 10  -- ← cámbialo por el número que obtuviste
) AS subquery;


-- Mediana:
-- Paso 1: Ejecuta esta consulta primero para contar filas y calcular el offset
SELECT
  COUNT(*) AS total_filas,
  FLOOR((COUNT(*) - 1) / 2) AS offset_calculado
FROM VENTAS;
-- Paso 2: Usa ese número directamente en la siguiente consulta
SELECT AVG(total) AS mediana
FROM (
  SELECT total
  FROM VENTAS
  ORDER BY total
  LIMIT 2 OFFSET 9
) AS median_rows;


-- Moda:
SELECT total, COUNT(*) AS frecuencia
FROM VENTAS
GROUP BY total
ORDER BY frecuencia DESC
LIMIT 1;

USE ventas_nl;
-- Ver si hay productos sin ventas
SELECT p.id_producto, p.nombre 
FROM PRODUCTOS p
LEFT JOIN DETALLE_VENTA dv ON p.id_producto = dv.id_producto
WHERE dv.id_producto IS NULL;

-- Establecimientos sin ventas 
SELECT e.id_establecimiento, e.nombre
FROM ESTABLECIMIENTOS e
LEFT JOIN VENTAS v ON e.id_establecimiento = v.id_establecimiento
WHERE v.id_establecimiento IS NULL;

-- Clientes que no han comprado nada
SELECT c.id_cliente, c.nombre
FROM CLIENTES c
LEFT JOIN VENTAS v ON c.id_cliente = v.id_cliente
WHERE v.id_cliente IS NULL;

-- Verificar si hay ventas con total distinto a la suma del detalle 
SELECT v.id_venta, v.total AS total_venta, 
       SUM(dv.subtotal) AS suma_detalle
FROM VENTAS v
JOIN DETALLE_VENTA dv ON v.id_venta = dv.id_venta
GROUP BY v.id_venta
HAVING ABS(v.total - SUM(dv.subtotal)) > 0.01;

-- Correccion de ventas NULL
SELECT 
    v.id_venta,
    v.total AS total_venta,
    SUM(dv.subtotal) AS suma_detalle
FROM VENTAS v
JOIN DETALLE_VENTA dv ON v.id_venta = dv.id_venta
GROUP BY v.id_venta
HAVING ABS(v.total - SUM(dv.subtotal)) > 0.01;

UPDATE VENTAS v
JOIN (
    SELECT id_venta, SUM(subtotal) AS suma_detalle
    FROM DETALLE_VENTA
    GROUP BY id_venta
) AS dv_sum ON v.id_venta = dv_sum.id_venta
SET v.total = dv_sum.suma_detalle;

-- Crear una vista con ventas completas
CREATE OR REPLACE VIEW vista_ventas_detalle AS
SELECT v.id_venta, v.fecha_venta, c.nombre AS cliente, e.nombre AS establecimiento,
       p.nombre AS producto, dv.cantidad, dv.subtotal
FROM VENTAS v
JOIN CLIENTES c ON v.id_cliente = c.id_cliente
JOIN ESTABLECIMIENTOS e ON v.id_establecimiento = e.id_establecimiento
JOIN DETALLE_VENTA dv ON v.id_venta = dv.id_venta
JOIN PRODUCTOS p ON dv.id_producto = p.id_producto;

-- Agregar un indice para mejorar consultas frecuentes
SHOW INDEX FROM VENTAS;
DROP INDEX idx_ventas_fecha ON VENTAS;

CREATE INDEX idx_ventas_fecha ON VENTAS(fecha_venta, id_cliente); -- ejemplo


-- ¿que cliente ha gastado más?
SELECT nombre, total_compras
FROM (
  SELECT c.nombre, SUM(v.total) AS total_compras
  FROM CLIENTES c
  JOIN VENTAS v ON c.id_cliente = v.id_cliente
  GROUP BY c.id_cliente
) AS sub
ORDER BY total_compras DESC
LIMIT 1;

-- ¿Cuál es el producto más vedido por cantidad?
SELECT nombre, total_vendido
FROM (
  SELECT p.nombre, SUM(dv.cantidad) AS total_vendido
  FROM PRODUCTOS p
  JOIN DETALLE_VENTA dv ON p.id_producto = dv.id_producto
  GROUP BY p.id_producto
) AS sub
ORDER BY total_vendido DESC
LIMIT 1;

-- ¿Municipio con más ventas (por monto)?
SELECT municipio, total_ventas
FROM (
  SELECT e.municipio, SUM(v.total) AS total_ventas
  FROM ESTABLECIMIENTOS e
  JOIN VENTAS v ON e.id_establecimiento = v.id_establecimiento
  GROUP BY e.municipio
) AS sub
ORDER BY total_ventas DESC
LIMIT 1;

-- a) Vista con JOIN
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


-- b) Vista con LEFT JOIN (clientes sin ventas)
CREATE OR REPLACE VIEW vista_clientes_ventas AS
SELECT 
  c.id_cliente,
  c.nombre,
  v.id_venta,
  v.total
FROM CLIENTES c
LEFT JOIN VENTAS v ON c.id_cliente = v.id_cliente;

SELECT * FROM vista_clientes_ventas;


-- c) Vista con RIGHT JOIN (productos con detalle de venta)
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


-- d) Vista con subconsulta (ventas mayores a la media)
CREATE OR REPLACE VIEW vista_ventas_sobresalientes AS
SELECT *
FROM VENTAS
WHERE total > (
  SELECT AVG(total) FROM VENTAS
);

SELECT * FROM vista_ventas_sobresalientes;


-- Disparador (Trigger)
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
end$$

DELIMITER ;

USE ventas_nl;

-- 1. Función contar elementos separados por coma
DROP FUNCTION IF EXISTS contar_elementos_arreglo;

CREATE FUNCTION contar_elementos_arreglo(cadena TEXT)
RETURNS INT
DETERMINISTIC
BEGIN
  RETURN LENGTH(cadena) - LENGTH(REPLACE(cadena, ',', '')) + 1;
end;

-- Probar función
SELECT contar_elementos_arreglo('manzana,pera,uva') AS total_elementos;

-- 2. Función Levenshtein simplificada
DROP FUNCTION IF EXISTS levenshtein;
-- No uses DELIMITER

CREATE FUNCTION levenshtein(s1 VARCHAR(255), s2 VARCHAR(255))
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE s1_len, s2_len, i, j, cost, d INT;
  SET s1_len = CHAR_LENGTH(s1);
  SET s2_len = CHAR_LENGTH(s2);

  IF s1_len = 0 THEN RETURN s2_len; END IF;
  IF s2_len = 0 THEN RETURN s1_len; END IF;

  SET d = 0;
  SET i = 1;
  WHILE i <= s1_len DO
    SET j = 1;
    WHILE j <= s2_len DO
      SET cost = IF(SUBSTRING(s1, i, 1) = SUBSTRING(s2, j, 1), 0, 1);
      SET d = d + cost;
      SET j = j + 1;
    END WHILE;
    SET i = i + 1;
  END WHILE;

  RETURN d;
END;

-- Probar Levenshtein
DROP TABLE IF EXISTS establecimientos_similares;
CREATE TABLE establecimientos_similares (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre1 VARCHAR(255),
  nombre2 VARCHAR(255)
);

INSERT INTO establecimientos_similares(nombre1, nombre2) VALUES
('Farmacia Guadalajara', 'Farma Guadalajara'),
('Oxxo', 'Oxso'),
('Superama', 'Superrama');

SELECT 
  id,
  nombre1,
  nombre2,
  levenshtein(nombre1, nombre2) AS distancia_levenshtein
FROM establecimientos_similares;
