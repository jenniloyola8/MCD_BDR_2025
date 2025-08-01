# Simulación de Sistema Educativo en SQL
**Base de Datos de Sistema Educativo generado en Mockaroo**   
_Autor:_ Jennifer Loyola Quintero

---
> **Objetivo:**
        Desarrollar un sistema escolar funcional usando SQL en DBeaver, que permita almacenar, consultar y relacionar información de alumnos, profesores, carreras, cursos e inscripciones. Aprendimos a aplicar diseño relacional, normalización, relaciones entre tablas y carga de datos desde archivos externos.

## Estructura del Sistema Escolar
Se crearon las siguientes tablas con claves primarias y foráneas:
- CARRERAS: ID y nombre de cada carrera (ej. Ingeniería, Psicología, etc.)
- ALUMNOS: Datos personales: nombre, apellido, género, fecha de nacimiento, correo, carrera.
- PROFESORES: Nombre, apellido y especialidad.
- CURSOS: Nombre del curso, créditos y profesor asignado.
- INSCRIPCIONES: Registra qué alumnos se inscriben a qué cursos y en qué fecha.

Cada tabla fue creada usando buenas prácticas (tipos de datos adecuados, restricciones NOT NULL, UNIQUE, FOREIGN KEY, AUTO_INCREMENT, y timestamps).

- **Codigo en MySQL**
``` sql 
    -- Eliminar base anterior (si deseas reiniciar todo)
DROP DATABASE IF EXISTS sistema_escolar;

-- Crear base de datos
CREATE DATABASE sistema_escolar;
USE sistema_escolar;

-- Tabla Carreras
CREATE TABLE CARRERAS (
    id_carrera INT AUTO_INCREMENT PRIMARY KEY,
    nombre_carrera VARCHAR(100) NOT NULL UNIQUE
);

-- Tabla Alumnos
CREATE TABLE ALUMNOS (
    id_alumno INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    genero ENUM('M', 'F', 'Otro') NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    id_carrera INT NOT NULL,
    correo_electronico VARCHAR(100) UNIQUE,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_carrera) REFERENCES CARRERAS(id_carrera)
);

-- Tabla Profesores
CREATE TABLE PROFESORES (
    id_profesor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    especialidad VARCHAR(100) NOT NULL
);

-- Tabla Cursos
CREATE TABLE CURSOS (
    id_curso INT AUTO_INCREMENT PRIMARY KEY,
    nombre_curso VARCHAR(100) NOT NULL,
    creditos INT NOT NULL,
    id_profesor INT,
    FOREIGN KEY (id_profesor) REFERENCES PROFESORES(id_profesor)
);

-- Tabla Inscripciones
CREATE TABLE INSCRIPCIONES (
    id_inscripcion INT AUTO_INCREMENT PRIMARY KEY,
    id_alumno INT NOT NULL,
    id_curso INT NOT NULL,
    fecha_inscripcion DATE NOT NULL,
    FOREIGN KEY (id_alumno) REFERENCES ALUMNOS(id_alumno),
    FOREIGN KEY (id_curso) REFERENCES CURSOS(id_curso)
);

/*
 * INSERTAR DATOS DE MANERA MANUAL*

-- Insertar carreras (ejemplos reales FCFM UANL MANUALMENTE)
 INSERT INTO CARRERAS (nombre_carrera) VALUES
('Ingeniería en Tecnologías de Software'),
('Matemáticas'),
('Ingeniería en Computación'),
('Actuaría'),
('Ciencia de Datos'),
('Ingeniería Física');

-- Insertar profesores
INSERT INTO PROFESORES (nombre, apellido, especialidad) VALUES
('María', 'Sánchez', 'Matemáticas'),
('José', 'Ramírez', 'Programación'),
('Lucía', 'Pérez', 'Estadística'),
('Pedro', 'Martínez', 'Ciencia de Datos');

-- Insertar cursos
INSERT INTO CURSOS (nombre_curso, creditos, id_profesor) VALUES
('Álgebra Lineal', 8, 1),
('Programación I', 10, 2),
('Estadística Aplicada', 6, 3),
('Bases de Datos', 9, 4);

-- Insertar alumnos (con id_carrera correcto)
INSERT INTO ALUMNOS (nombre, apellido, genero, fecha_nacimiento, id_carrera, correo_electronico) VALUES
('Andrea', 'López', 'F', '2004-03-12', 5, 'andrea.lopez@fcfm.uanl.mx'),
('Carlos', 'Martínez', 'M', '2003-07-09', 2, 'carlos.mtz@fcfm.uanl.mx'),
('Fernanda', 'Reyes', 'F', '2005-01-22', 3, 'fernanda.reyes@fcfm.uanl.mx'),
('Luis', 'González', 'M', '2004-11-10', 5, 'luis.gonzalez@fcfm.uanl.mx'),
('Valeria', 'Mendoza', 'F', '2002-06-18', 4, 'valeria.mendoza@fcfm.uanl.mx');

-- Insertar inscripciones
INSERT INTO INSCRIPCIONES (id_alumno, id_curso, fecha_inscripcion) VALUES
(1, 1, CURDATE()),
(1, 2, CURDATE()),
(2, 3, CURDATE()),
(3, 4, CURDATE());*/

SELECT * FROM ALUMNOS;
SELECT * FROM INSCRIPCIONES;
SELECT * FROM PROFESORES;
SELECT * FROM CARRERAS;
SELECT * FROM CURSOS;

-- Ejemplo: Alta y baja de alumno
-- dar de alta 
INSERT INTO ALUMNOS (nombre, apellido, genero, fecha_nacimiento, id_carrera, correo_electronico)
VALUES ('Ana', 'Martínez', 'F', '2002-04-15', 1, 'ana.martinez@mail.com');

-- dar de baja
DELETE FROM ALUMNOS WHERE id_alumno = 5;

-- Asignar curso a alumno
INSERT INTO INSCRIPCIONES (id_alumno, id_curso, fecha_inscripcion)
VALUES (3, 2, CURDATE());

-- 1. Consultas útiles
-- a) Listar todos los cursos en los que está inscrito un alumno
SELECT 
  a.nombre AS alumno_nombre,
  a.apellido AS alumno_apellido,
  c.nombre_curso,
  i.fecha_inscripcion
FROM INSCRIPCIONES i
JOIN ALUMNOS a ON i.id_alumno = a.id_alumno
JOIN CURSOS c ON i.id_curso = c.id_curso
WHERE a.id_alumno = 1;  -- Cambia por el id_alumno que quieras

-- b) Contar cuántos cursos tiene cada alumno
SELECT 
  a.nombre,
  a.apellido,
  COUNT(i.id_curso) AS cursos_inscritos
FROM ALUMNOS a
LEFT JOIN INSCRIPCIONES i ON a.id_alumno = i.id_alumno
GROUP BY a.id_alumno, a.nombre, a.apellido;

-- c) Mostrar profesores con los cursos que imparten
SELECT 
  p.nombre AS profesor_nombre,
  p.apellido AS profesor_apellido,
  c.nombre_curso
FROM PROFESORES p
LEFT JOIN CURSOS c ON p.id_profesor = c.id_profesor;

-- 2. Vista (View)
CREATE OR REPLACE VIEW vista_inscripciones AS
SELECT 
  i.id_inscripcion,
  CONCAT(a.nombre, ' ', a.apellido) AS alumno,
  c.nombre_curso,
  i.fecha_inscripcion
FROM INSCRIPCIONES i
JOIN ALUMNOS a ON i.id_alumno = a.id_alumno
JOIN CURSOS c ON i.id_curso = c.id_curso;

SELECT * FROM vista_inscripciones LIMIT 10;

-- 3. Trigger
DELIMITER $$

CREATE TRIGGER before_insert_inscripcion
BEFORE INSERT ON INSCRIPCIONES
FOR EACH ROW
BEGIN
  IF NEW.fecha_inscripcion IS NULL THEN
    SET NEW.fecha_inscripcion = CURDATE();
  END IF;
END$$

DELIMITER ;

INSERT INTO INSCRIPCIONES (id_alumno, id_curso) VALUES (1, 2);
SHOW TRIGGERS LIKE 'INSCRIPCIONES';

-- 4. Procedimiento almacenado (Stored Procedure)
-- Dar de alta a un estudiante.
DELIMITER $$

CREATE PROCEDURE alta_alumno(
  IN p_nombre VARCHAR(100),
  IN p_apellido VARCHAR(100),
  IN p_genero ENUM('M', 'F', 'Otro'),
  IN p_fecha_nacimiento DATE,
  IN p_id_carrera INT,
  IN p_correo VARCHAR(100)
)
BEGIN
  INSERT INTO ALUMNOS (nombre, apellido, genero, fecha_nacimiento, id_carrera, correo_electronico)
  VALUES (p_nombre, p_apellido, p_genero, p_fecha_nacimiento, p_id_carrera, p_correo);
END$$

DELIMITER ;

CALL alta_alumno('Luis', 'Fernández', 'M', '2003-09-01', 2, 'luis.fernandez@mail.com');

-- 5. Función (Function)
-- Función para contar cuántos cursos tiene un alumno
DELIMITER $$

CREATE FUNCTION total_cursos_alumno(p_id_alumno INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM INSCRIPCIONES WHERE id_alumno = p_id_alumno;
  RETURN total;
END$$

DELIMITER ;

SELECT total_cursos_alumno(1) AS cursos_inscritos;
```

## Generación de Datos con Mockaroo
Usamos Mockaroo para generar datos realistas y personalizados para cada tabla. Esto nos permitió:
- Crear listas de alumnos con nombres reales, fechas válidas y correos electrónicos.
- Asignar profesores a materias según su especialidad.
- Generar inscripciones aleatorias y realistas.


## Diferencias: Mockaroo vs. Dummy Data
|                |Característica	Mockaroo           |Dummy Data (manual o aleatorio)|
|----------------|-------------------------------------|-------------------------------|
|Realismo	     |Muy alto (nombres, fechas, correos)  |Bajo o repetitivo              |
|Variedad	     |Alta	                               |Limitada o copiada             |
|Automatización  |Sí, con exportación a CSV/JSON	   |No                             |
|Personalización |Muy flexible	                       |Poco o nulo                    |
|Eficiencia	     |Muy rápida para 100+ registros	   |Lenta y propensa a errores     |

**Conclusión:** Mockaroo fue esencial para generar datos limpios, variados y listos para importar, lo que mejoró la calidad del sistema.

---
### Fuentes: 
[Mockaroo](https://mockaroo.com)
[Dummy Data](https://filldb.info/dummy/)