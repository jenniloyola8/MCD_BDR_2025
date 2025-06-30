# Creacion de Datos Ficticios o de otras fuentes de manera Automática y Uso de funciones de agregación 
_Autor:_ Jennifer Loyola Quintero

*Objetivo:*
- Agregar datos ficticios o de otras fuentes de manera automatica (mediante funciones como las vistas en esta tarea).
- Reportar en menos de 5 minutos hallasgos, dificultades, recomendaciones o recursos que sean relevantes.
- Usar funciones de agregación para calcular en tu base de datos (conteo de frecuencias o media, mínimos o máximos, cuantil cuyo resultado sea distinto a la mediana, moda, reporta hallasgos, dificultades, implementación de soluciones encontradas en línea, etc.).
- Haz al menos un ejemplo de cada una de estas consultas.

---

## Generación de Base de Datos con FillDB (https://filldb.info/dummy)

###  Hallazgos

- La herramienta [FillDB](https://filldb.info/dummy) permite generar datos ficticios de manera rápida a partir de un esquema SQL proporcionado por el usuario.
- Los datos generados son compatibles con bases de datos relacionales comunes como MySQL, PostgreSQL o SQLite.
- Es posible personalizar los datos por columna utilizando comentarios (`--`) como `-- full_name`, `-- integer(1,100)`, `-- float(min, max)` o `-- date_between(...)`.
- El sistema es útil para crear prototipos de bases de datos y probar relaciones entre tablas.

###  Dificultades encontradas

1. **Errores por claves duplicadas**  
   Si se genera una tabla con `PRIMARY KEY` y un rango pequeño, y se piden más registros que valores únicos posibles, aparece el error:  
   > “Maximum retries of 10000 reached without finding a unique value”
   
   **Solución:** Usar `AUTO_INCREMENT` para claves primarias o ampliar el rango de generación de IDs.

2. **Campos sin datos generados**  
   Algunas columnas como `total`, `id_cliente`, `cantidad`, etc., quedaban vacías si no se especificaba un tipo de dato con un comentario. 

   **Solución:** Agregar comentarios como `-- float(100, 3000)` o `-- integer(1, 50)`.

3. **Paso 2 obligatorio**  
   Aunque el Paso 2 dice “Optional”, es necesario **marcar al menos una tabla** para que se generen datos.  
   
   **Solución:** Seleccionar todas las tablas relevantes antes de hacer clic en “Fill DB”.

4. **Relaciones entre tablas no automáticas**  
   FillDB no valida claves foráneas automáticamente. Por ejemplo, los valores en `id_cliente` de la tabla `ventas` no siempre coinciden con los existentes en la tabla `clientes`.  
   
   **Solución:** Asegurar que los valores de claves foráneas estén en el mismo rango que los IDs generados en las tablas relacionadas.

###  Recomendaciones

- Usar `AUTO_INCREMENT` en todas las columnas `PRIMARY KEY` para evitar errores por duplicados.
- Definir explícitamente el tipo de dato que se desea generar usando los comentarios sugeridos por FillDB.
- Generar primero las tablas base (`clientes`, `productos`, `establecimientos`) y después las dependientes (`ventas`, `detalle_venta`).
- Verificar los resultados antes de usarlos en un entorno real: FillDB no garantiza consistencia referencial.
- Guardar el script SQL antes de hacer clic en “Fill DB”, ya que la página no guarda los cambios.

###  Recursos adicionales

- Herramienta usada: [https://filldb.info/dummy](https://filldb.info/dummy)
- Alternativas recomendadas:
  - [https://mockaroo.com](https://mockaroo.com): Más control y tipos de datos más variados.
  - Python + `Faker`: Ideal para generar datasets más complejos y reproducibles.
  - `pandas` y `sqlite3`: Para procesar y validar datos localmente.

---

_El uso de herramientas como FillDB acelera el desarrollo y pruebas en entornos académicos y profesionales, pero requiere una configuración cuidadosa para evitar errores de consistencia o duplicados._

---

## Consultas de la base de datos Ventas en Nuevo León.

### Consultas basicas:
1. Frecuencia por establecimiento:
 ```sql 
 SELECT id_establecimiento, COUNT(*) AS frecuencia
 FROM ventas
 GROUP BY id_establecimiento;

  ```
2. Media, mínimo y máximo del total:
 ```sql 
 SELECT 
    AVG(total) AS media,
    MIN(total) AS minimo,
    MAX(total) AS maximo
 FROM ventas;
  ```
3. Cuantil (ej. 25%): (MySQL >= 8.0)
 ```sql 
 SELECT COUNT(*) * 0.25 FROM ventas;
 SELECT total
 FROM ventas
 ORDER BY total
 LIMIT 1 OFFSET 5;
  ```
4. Mediana
 ```sql 
 SELECT AVG(t.total) AS mediana
 FROM (
     SELECT @row := @row + 1 AS fila, total
     FROM ventas, (SELECT @row := -1) r
     ORDER BY total
 ) AS t
 WHERE t.fila IN (
     FLOOR((@total := (SELECT COUNT(*) FROM ventas)) / 2),
     FLOOR((@total - 1) / 2)
 );
 ```
 ---

 ### Hallazgos:
- La mayoría de las ventas generadas se concentraron en ciertos establecimientos y productos, lo cual puede reflejar un comportamiento natural en datos comerciales donde unos pocos locales o ítems concentran más actividad.

- El análisis del total de ventas por ticket mostró una distribución con sesgo positivo: hay muchos tickets de bajo valor y pocos de alto valor.

- La media y el cuartil 25% fueron notablemente distintos, lo que sugiere dispersión y valores atípicos.

- En algunas simulaciones, los valores de subtotal y cantidad no siempre eran coherentes con el precio, lo cual es típico cuando los datos se generan sin relaciones directas entre tablas.

### Dificultades encontradas
- Error de generación de datos en FillDB: El sistema arrojaba errores como “Maximum retries of 10000 reached without finding a unique value” cuando se pedían más filas que valores únicos posibles para claves primarias ('id_cliente', 'id_producto', etc.).

**_Solución:_** se utilizó AUTO_INCREMENT en las claves primarias.

- Columnas vacías o sin datos generados: Algunas columnas (total, id_cliente, etc.) venían vacías al no tener definidos comentarios con pistas (-- float(...), -- integer(...)) en el esquema SQL.

**_Solución:_** se añadieron comentarios con tipos de datos esperados según las recomendaciones de FillDB.

- Cálculo de cuartiles y mediana en MySQL: Las versiones anteriores a MySQL 8 no soportan funciones como PERCENTILE_CONT(), lo que impidió calcular la mediana o cuartiles con funciones estándar.

**_Solución:_** se implementó una técnica con LIMIT y OFFSET, además de variables de usuario (@row) para calcular posiciones centrales manualmente.

### Implementación de soluciones encontradas en línea
- Se investigaron alternativas en Stack Overflow, blogs de SQL y documentación oficial de MySQL para simular funciones estadísticas faltantes.

- Se usaron subconsultas con ORDER BY + LIMIT OFFSET como sustituto de funciones de percentil.

- En vez de depender de librerías externas como Faker en Python, se usó FillDB.info para generar datos falsos controlados en SQL directamente.

- Se utilizó pandas en pruebas paralelas para validar la coherencia estadística de los resultados obtenidos con SQL.
---