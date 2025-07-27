# Funciones y Procedimientos en SQL
**Base de Datos de Ventas en Nuevo León**   
_Autor:_ Jennifer Loyola Quintero

---
> **Objetivo:**
    Automatizar operaciones repetitivas o complejas, modularizar código y mejorar el mantenimiento y reutilización de lógica dentro de la base de datos.

Las funciones devuelven un valor y se pueden usar dentro de consultas (SELECT, WHERE, etc.).

Los procedimientos permiten realizar múltiples operaciones (lecturas, inserciones, condiciones, ciclos) y pueden devolver varios resultados o efectos, incluso sin regresar valores directamente.


### Tablas de prueba:
- datos_correlacion
Se usa para análisis estadístico entre dos variables x y y (como correlación y regresión).
Ejemplo: ¿a mayor x, también aumenta y?

- establecimientos_similares
Permite probar la función levenshtein, comparando nombres de empresas o marcas parecidas.
## 1. Función contar_elementos_arreglo(cadena TEXT)
**¿Qué hace?**
Cuenta cuántos elementos hay en una cadena de texto separados por comas.

*Ejemplo:*
contar_elementos_arreglo('manzana,pera,uva') → devuelve 3.

**¿Para qué sirve?**
Ideal para contar valores en campos con listas de texto (como etiquetas, categorías, etc.).

- **Codigo en MySQL**
``` sql 
-- ===============================================================================================
--            1. FUNCION: contar_elementos_arreglo
-- ===============================================================================================
DROP FUNCTION IF EXISTS contar_elementos_arreglo;

CREATE FUNCTION contar_elementos_arreglo(cadena TEXT)
RETURNS INT
DETERMINISTIC
BEGIN
  RETURN LENGTH(cadena) - LENGTH(REPLACE(cadena, ',', '')) + 1;
END;

-- Probar función
SELECT contar_elementos_arreglo('manzana,pera,uva') AS total_elementos;
```

## 2. Función levenshtein(s1, s2)
**¿Qué hace?**
Calcula una distancia aproximada entre dos cadenas (Levenshtein) basada en cuántos caracteres diferentes hay al comparar posición por posición.

*Ejemplo simplificado:*
Compara "Farmacia" y "Farma" → devuelve cuántos caracteres son distintos en cada posición.

**¿Para qué sirve?**
Detectar similitud entre nombres, útil para deduplicar, corregir errores de escritura o agrupar textos similares.

``` sql
-- ===============================================================================================
--            2. FUNCION: levenshtein
-- ===============================================================================================
DROP FUNCTION IF EXISTS levenshtein;

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

-- ===============================================================================================
--            Tabla de prueba para levenshtein
-- ===============================================================================================
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

-- Probar función levenshtein
SELECT 
  id,
  nombre1,
  nombre2,
  levenshtein(nombre1, nombre2) AS distancia_levenshtein
FROM establecimientos_similares;
```