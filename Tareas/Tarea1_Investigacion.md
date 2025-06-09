# Investigacion sobre SGBD y descripción de Base de datos.
_**Autor:**_ Jennifer Loyola Quintero

## Descripción de Base de datos

En este proyecto estoy trabajando con una base de datos enfocada en el análisis de ventas por región geográfica probablemente con el Superstore Sales Dataset de Kaggle o con  conjunto de datos del INEGI. La idea es organizar los datos en varias tablas relacionadas entre sí, como por ejemplo: una tabla de `clientes` (con datos como `id_cliente` [INT], `nombre` [VARCHAR], `estado/municipio` [VARCHAR], etc.), otra de `ventas` (con `id_venta`, `fecha_venta`, `total`), una de `productos` y una más de `detalle_venta` para registrar qué productos se vendieron en cada compra. Estas tablas están conectadas mediante claves foráneas (por ejemplo, `id_cliente` en ventas) y permiten analizar cosas como qué estados venden más, qué productos son más populares o cuáles clientes compran con más frecuencia. Según Nutanix (s.f.), gestionar bien una base de datos como esta permite acceder a la información más rápido y tomar decisiones con base en datos reales.

## Investigación sobre SGBD

Un **SGBD** (_Sistema de Gestión de Bases de Datos_) es básicamente el software que se encarga de manejar toda la información: crea tablas, guarda los datos, permite consultarlos con SQL y mantiene todo en orden. En este proyecto estoy usando **MySQL**, que es uno de los más usados en el mundo. Es gratuito, rápido, y funciona muy bien con bases de datos relacionales como esta. Además, te permite trabajar desde la terminal o con herramientas visuales. Como se menciona en Hostinger (2023), este tipo de sistemas también ayudan a mantener la integridad de los datos y permiten que varias personas trabajen sobre la misma base sin errores.


> Fuentes consultadas: 
> - Hostinger. (2023). [¿Qué es un SGBD?](https://www.hostinger.com/mx/tutoriales/sgbd) 
> - Nutanix. (s.f.). [Database Management](https://www.nutanix.com/mx/info/database-management)
