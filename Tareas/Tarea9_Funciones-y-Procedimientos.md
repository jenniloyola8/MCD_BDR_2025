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

---

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
> **Interpretación:**
    - La función identifica cuántas comas hay en la cadena y suma 1. Por lo tanto, la cantidad de elementos = número de comas + 1.
    - Esto es útil cuando una columna contiene datos tipo lista, como: 'productoA,productoB,productoC'.

 - **Aplicación real:**
  Se puede usar para:
    - Contar etiquetas asignadas a productos.
    - Saber cuántas categorías tiene un artículo.
    - Validar que no haya errores (por ejemplo, si el campo debía tener 3 valores y el resultado es distinto).

---

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

**Resultados esperados (según inserciones):**

|ID	|nombre1	            |nombre2	          |distancia_levenshtein    |
|---|---------------------|-------------------|-------------------------|
|1	|Farmacia Guadalajara	|Farma Guadalajara	|3–5 (según lógica usada) |
|2	|Oxxo	                |Oxso	              |2                        |
|3	|Superama	            |Superrama	        |1–2                      |

> **Interpretación:**
    - Una distancia baja (1-2) indica que los textos son muy similares.
    - Distancias más altas (>5) indican textos diferentes.
    - Esta métrica ayuda a detectar posibles errores ortográficos o nombres duplicados con diferencias mínimas.

- **Aplicación real:**
  - Detección de duplicados en nombres de empresas o productos.
  - Corrección de errores ortográficos automáticamente.
  - Recomendaciones automáticas tipo "¿Quisiste decir...?".

---

  ### Conclusión General
|Elemento               |contar_elementos_arreglo                 |levenshtein                         |
|-----------------------|-----------------------------------------|------------------------------------|
|Tipo de función        |Escalar (devuelve número entero)         |Escalar (devuelve número entero)    |
|Entrada esperada       |Texto con comas	                        |Dos cadenas de texto                |
|Salida	                |Número de elementos separados por coma	  |Distancia (número de diferencias)   |
|Aplicaciones prácticas |Contar etiquetas, validar entradas	      |Deduplicación, limpieza, comparación|