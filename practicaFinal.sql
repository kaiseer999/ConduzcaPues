CREATE DATABASE ConduzcaPues
ON PRIMARY
(NAME ='conduzcapues', FILENAME='C:\\Users\\usuario\\Desktop\\cris\\sql\\PracticaFinal\\DATA\\ConduzcaPues.mdf',
SIZE = 50MB,
FILEGROWTH = 25%)
LOG ON
(NAME ='conduzcapuesLog', FILENAME='C:\\Users\\usuario\\Desktop\\cris\\sql\\PracticaFinal\\DATA\\ConduzcaPues.ldf',
SIZE = 25MB,
FILEGROWTH = 25%);

-- Tabla de Licencias
CREATE TABLE Licencias (
    idLicencia INT PRIMARY KEY,
    tipoLicencia VARCHAR(50) NOT NULL
);

-- Tabla de Profesores
CREATE TABLE Profesores (
    cod_Profesor INT PRIMARY KEY,
    num_instructor INT IDENTITY(1,1),
    nom_instructor VARCHAR(50) NOT NULL DEFAULT 'NomPro',
    ape_instructor VARCHAR(50) NOT NULL DEFAULT 'ApePro',
    fechaContrato DATE NOT NULL DEFAULT GETDATE(),
    Horarioinstructor VARCHAR(100) NOT NULL DEFAULT '',
    telefono VARCHAR(20) NOT NULL DEFAULT '999',
    correo_instructor VARCHAR(100) NOT NULL DEFAULT 'profe@test.com',
    idLicencia INT NOT NULL,
    CONSTRAINT FK_Profesores_Licencias FOREIGN KEY (idLicencia) REFERENCES Licencias(idLicencia)
);

-- Tabla de Estudiantes
CREATE TABLE Estudiantes (
    idEstudiante INT PRIMARY KEY,
    num_estudiante INT IDENTITY(1,1),
    nom_estudiante VARCHAR(50) NOT NULL DEFAULT 'NomUsu',
    ape_estudiante VARCHAR(50) NOT NULL DEFAULT 'ApeUsu',
    fechaNacimiento DATE NOT NULL DEFAULT '1900-01-01',
    direccion VARCHAR(255) NOT NULL DEFAULT 'callemalamuerte',
    telefono VARCHAR(20) NOT NULL DEFAULT '666',
    correo_estudiante VARCHAR(100) NOT NULL DEFAULT 'estu@test.com',
    fechaInscripcion DATE NOT NULL DEFAULT GETDATE(),
    cod_Profesor INT,
    CONSTRAINT FK_Estudiantes_Profesores FOREIGN KEY (cod_Profesor) REFERENCES Profesores(cod_Profesor)
);

-- Tabla de Marcas
CREATE TABLE Marcas (
    idMarca INT PRIMARY KEY,
    marca VARCHAR(50) NOT NULL
);

-- Tabla de Modelos
CREATE TABLE Modelos (
    idModelo INT PRIMARY KEY,
    modelo VARCHAR(50) NOT NULL
);

-- Tabla de Vehiculos
CREATE TABLE Vehiculos (
    placaVehiculo VARCHAR(10) PRIMARY KEY,
    num_vehiculo INT IDENTITY(1,1),
    ano_fabricacion INT NOT NULL DEFAULT 1980,
    fechaAdquisi DATE NOT NULL DEFAULT '1900-01-01',
    idMarca INT NOT NULL,
    idModelo INT NOT NULL,
    CONSTRAINT FK_Vehiculos_Marcas FOREIGN KEY (idMarca) REFERENCES Marcas(idMarca),
    CONSTRAINT FK_Vehiculos_Modelos FOREIGN KEY (idModelo) REFERENCES Modelos(idModelo)
);

-- Tabla de Estados de Clase
CREATE TABLE EstadosClase (
    idEstadoClase INT PRIMARY KEY,
    estadoClase VARCHAR(50) NOT NULL
);

-- Tabla de Clases
CREATE TABLE Clases (
    id_clase INT PRIMARY KEY,
    num_clase INT IDENTITY(1,1),
    fecha_hora DATETIME NOT NULL DEFAULT '1900-01-01 00:00:00',
    tipo_clase VARCHAR(50) NOT NULL DEFAULT 'Teorica',
    idInstructor INT NOT NULL,
    placaVehiculo VARCHAR(10) NOT NULL,
    idEstudiante INT NOT NULL,
    idEstadoClase INT NOT NULL,
    CONSTRAINT FK_Clases_Instructores FOREIGN KEY (idInstructor) REFERENCES Profesores(cod_Profesor),
    CONSTRAINT FK_Clases_Vehiculos FOREIGN KEY (placaVehiculo) REFERENCES Vehiculos(placaVehiculo),
    CONSTRAINT FK_Clases_Estudiantes FOREIGN KEY (idEstudiante) REFERENCES Estudiantes(idEstudiante),
    CONSTRAINT FK_Clases_EstadosClase FOREIGN KEY (idEstadoClase) REFERENCES EstadosClase(idEstadoClase)
);

-- Tabla de Evaluaciones
CREATE TABLE Evaluaciones (
    idEvaluacion INT PRIMARY KEY,
    num_calificacion INT IDENTITY(1,1),
    idEstudiante INT NOT NULL,
    idClase INT NOT NULL,
    nota_teorica DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    nota_practica DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    Observacion VARCHAR(100) NOT NULL DEFAULT '',
    CONSTRAINT FK_Evaluaciones_Estudiantes FOREIGN KEY (idEstudiante) REFERENCES Estudiantes(idEstudiante),
    CONSTRAINT FK_Evaluaciones_Clases FOREIGN KEY (idClase) REFERENCES Clases(id_clase)
);

-- Profesores
ALTER TABLE Profesores
ADD CONSTRAINT CHK_Telefono_Profesores CHECK (LEN(telefono) BETWEEN 7 AND 15);

ALTER TABLE Profesores
ADD CONSTRAINT CHK_Correo_Instructor_Profesores CHECK (CHARINDEX('@', correo_instructor) > 0);

-- Estudiantes
ALTER TABLE Estudiantes
ADD CONSTRAINT CHK_Telefono_Estudiantes CHECK (LEN(telefono) BETWEEN 7 AND 15);

ALTER TABLE Estudiantes
ADD CONSTRAINT CHK_Correo_Estudiantes CHECK (CHARINDEX('@', correo_estudiante) > 0);

-- Vehiculos
ALTER TABLE Vehiculos
ADD CONSTRAINT CHK_PlacaVehiculo CHECK (LEN(placaVehiculo) = 6);


-- Evaluaciones
ALTER TABLE Evaluaciones
ADD CONSTRAINT CHK_Nota_Teorica_Evaluaciones CHECK (nota_teorica >= 0 AND nota_teorica <= 5);

ALTER TABLE Evaluaciones
ADD CONSTRAINT CHK_Nota_Practica_Evaluaciones CHECK (nota_practica >= 0 AND nota_practica <= 5);



-- Índice no agrupado en la tabla de Clases
CREATE NONCLUSTERED INDEX IX_Clases_Fecha_Hora
ON Clases (fecha_hora);

-- Índice columnar en la tabla de Evaluaciones
CREATE NONCLUSTERED COLUMNSTORE INDEX IX_Evaluaciones_Columnar
ON Evaluaciones (idEstudiante, idClase, nota_teorica, nota_practica);

-- Índice único en la tabla de Profesores en la columna correo_instructor
CREATE UNIQUE INDEX IX_Profesores_Correo
ON Profesores (correo_instructor);

-- Índice no agrupado en la tabla de Vehiculos en las columnas idMarca y idModelo
CREATE NONCLUSTERED INDEX IX_Vehiculos_Marca_Modelo
ON Vehiculos (idMarca, idModelo);

-- Índice filtrado en la tabla de Estudiantes para estudiantes activos
CREATE NONCLUSTERED INDEX IX_Estudiantes_Activos
ON Estudiantes (fechaInscripcion)
WHERE fechaInscripcion >= '2023-01-01';


-- Insertar datos en la tabla de Licencias
INSERT INTO Licencias (idLicencia, tipoLicencia) VALUES
(1, 'Licencia Clase A1'),
(2, 'Licencia Clase A2'),
(3, 'Licencia Clase B1'),
(4, 'Licencia Clase B2'),
(5, 'Licencia Clase B3'),
(6, 'Licencia Clase C1'),
(7, 'Licencia Clase C2'),
(8, 'Licencia Clase C3');




-- Insertar datos en la tabla de Profesores
INSERT INTO Profesores (cod_Profesor, nom_instructor, ape_instructor, fechaContrato, Horarioinstructor, telefono, correo_instructor, idLicencia) VALUES
(3345755, 'Oscar', 'Mejia', '2023-12-12', '6am-4pm', '3017550621', 'oscar@test.com', 3),
(4475068, 'Raquel', 'Moreno', '2023-12-12', '8am-6pm', '311899696', 'raquel@test.com', 3),
(7589125, 'Jose', 'Perez', '2023-12-12', '6am-4pm', '323635786', 'jose@test.com', 3),
(1234567, 'Carlos', 'Gonzalez', '2023-12-12', '9am-5pm', '3001234567', 'carlos@test.com', 8),
(2345678, 'Maria', 'Rodriguez', '2023-12-12', '10am-6pm', '3002345678', 'maria@test.com', 3),
(3456789, 'Juan', 'Martinez', '2023-12-12', '11am-7pm', '3003456789', 'juan@test.com', 3),
(4567890, 'Ana', 'Garcia', '2023-12-12', '12pm-8pm', '3004567890', 'ana@test.com', 5),
(5678901, 'Diego', 'Lopez', '2023-12-12', '1pm-9pm', '3005678901', 'diego@test.com', 3),
(6789012, 'Sofia', 'Hernandez', '2023-12-12', '2pm-10pm', '3006789012', 'sofia@test.com', 5),
(7890123, 'Miguel', 'Torres', '2023-12-12', '3pm-11pm', '3007890123', 'miguel@test.com', 3),
(8901234, 'Laura', 'Sanchez', '2023-12-12', '4pm-12am', '3008901234', 'laura@test.com', 3),
(9012345, 'Sergio', 'Castro', '2023-12-12', '5pm-1am', '3009012345', 'sergio@test.com', 5),
(0123456, 'Isabel', 'Ramirez', '2023-12-12', '6pm-2am', '3000123456', 'isabel@test.com', 8);


-- Insertar datos en la tabla de Estudiantes
INSERT INTO Estudiantes (idEstudiante, nom_estudiante, ape_estudiante, fechaNacimiento, direccion, telefono, correo_estudiante, fechaInscripcion, cod_Profesor) VALUES
(10005893, 'Juan', 'Gomez', '2000-01-03', 'Calle 10 #22-34, Medellín', '3005556677', 'juan@test.com', '2023-01-03', 0123456),
(5777894, 'Maria', 'Perez', '2000-02-04', 'Carrera 20 #45-67, Medellín', '3008889900', 'maria@test.com', '2023-02-04', 9012345),
(6969695, 'Cristian', 'Rodriguez', '2000-03-05', 'Avenida 30 #56-78, Medellín', '3001112233', 'carlos@test.com', '2023-03-05', 3345755),
(7845136, 'Ana', 'Martinez', '2000-04-06', 'Diagonal 40 #32-54, Medellín', '3004445566', 'ana@test.com', '2023-04-06', 4475068),
(635187, 'Jorge', 'Gonzalez', '2000-05-07', 'Transversal 50 #23-45, Medellín', '3007778899', 'jorge@test.com', '2023-05-07', 6789012),
(101226058, 'Sofia', 'Ramirez', '2000-06-08', 'Circular 60 #34-56, Medellín', '3002223344', 'sofia@test.com', '2023-06-08', 2345678),
(120518669, 'Diego', 'Torres', '2000-07-09', 'Calle 70 #45-67, Medellín', '3005557788', 'diego@test.com', '2023-07-09', 7589125),
(7750010, 'Evelin', 'Garcia', '2000-08-10', 'Carrera 80 #56-78, Medellín', '3008889911', 'laura@test.com', '2023-08-10', 3345755),
(89710311, 'Tomas', 'Lopez', '2000-09-11', 'Avenida 90 #32-54, Medellín', '3001112244', 'sergio@test.com', '2023-09-11', 4567890),
(91218, 'Isabel', 'Morales', '2000-10-12', 'Diagonal 100 #23-45, Medellín', '3004445577', 'isabel@test.com', '2023-10-12', 7890123);


-- Insertar datos en la tabla de Marcas
INSERT INTO Marcas (idMarca, marca) VALUES
(123, 'Mazda'),
(456, 'Nissan'),
(789, 'Toyota'),
(012, 'Chevrolet'),
(912, 'Ford'),
(266, 'Honda'),
(753, 'Hyundai'),
(159, 'Volkswagen'),
(452, 'Mercedes-Benz'),
(784, 'BMW');


-- Insertar datos en la tabla de Modelos
INSERT INTO Modelos (idModelo, modelo) VALUES
(145, 'Sedán'),
(436, 'Hatchback'),
(895, 'SUV'),
(636, 'Coupé'),
(777, 'Convertible'),
(964, 'Camioneta'),
(149, 'Minivan'),
(130, 'Deportivo'),
(261, 'Pickup'),
(192, 'Furgoneta');


-- Insertar datos en la tabla de Vehiculos
INSERT INTO Vehiculos (placaVehiculo, ano_fabricacion, fechaAdquisi, idMarca, idModelo) VALUES
('DEF456', 2017, '2020-08-01', 123, 145),
('GHI789', 2018, '2019-12-01', 456, 436),
('JKL012', 2019, '2021-09-01', 789, 895),
('MNO345', 2020, '2020-01-01', 012, 636),
('PQR678', 2021, '2021-01-01', 912, 777),
('STU901', 2022, '2022-01-01', 266, 964),
('VWX234', 2023, '2023-11-01', 753, 149),
('YZA567', 2017, '2017-01-01', 159, 130),
('BCD890', 2018, '2018-09-12', 452, 261),
('EFG123', 2019, '2019-10-01', 784, 192);

-- Insertar datos en la tabla de EstadosClase
INSERT INTO EstadosClase (idEstadoClase, estadoClase) VALUES
(1, 'Activa'),
(2, 'Cancelada');

-- Insertar datos en la tabla de Clases
INSERT INTO Clases (id_clase, fecha_hora, tipo_clase, idInstructor, placaVehiculo, idEstudiante, idEstadoClase) VALUES
(356, '2023-11-03 12:00:00', 'Teorica', 3345755, 'DEF456', 10005893, 1),
(478, '2023-07-04 06:00:00', 'Practica', 4475068, 'GHI789', 5777894, 2),
(965, '2023-08-05 14:00:00', 'Teorica', 7589125, 'JKL012', 6969695, 1),
(126, '2023-05-06 15:00:00', 'Practica', 1234567, 'MNO345', 7845136, 1),
(647, '2023-01-07 16:00:00', 'Teorica', 2345678, 'PQR678', 635187, 1),
(988, '2023-01-08 17:00:00', 'Practica', 3456789, 'STU901', 101226058, 2),
(999, '2023-10-09 18:00:00', 'Teorica', 4567890, 'VWX234', 120518669, 1),
(457, '2023-01-10 06:00:00', 'Practica', 5678901, 'YZA567', 7750010, 1),
(731, '2023-01-11 08:00:00', 'Practica', 6789012, 'BCD890', 89710311, 1),
(689, '2023-01-12 10:00:00', 'Practica', 7890123, 'EFG123', 91218, 2);


-- Insertar datos en la tabla de Evaluaciones
INSERT INTO Evaluaciones (idEvaluacion, idEstudiante, idClase, nota_teorica, nota_practica, Observacion) VALUES
(378, 10005893, 356, 4.5, 2.0, 'Buena participación en clase teórica'),
(994, 5777894, 478, 2.3, 3.5, 'Necesita mejorar en estacionamiento durante la clase práctica'),
(475, 6969695, 965, 4.0, 4.8, 'Excelente desempeño en clase teórica'),
(886, 7845136, 126, 2.0, 4.5, 'Buen control del vehículo en clase práctica'),
(799, 635187, 647, 3.5, 1.9, 'Debe participar más en clase teórica'),
(214, 101226058, 988, 2.9, 3.0, 'Debe practicar más el estacionamiento en clase práctica'),
(782, 120518669, 999, 4.5, 3.8, 'Muy buena participación en clase teórica'),
(109, 7750010, 457, 0, 4.0, 'Buen manejo en clase práctica'),
(112, 89710311, 731, 3.5, 4.2, 'Debe mejorar en participación en clase teórica'),
(654, 91218, 689, 1.5, 4.5, 'Excelente control del vehículo en clase práctica');




SELECT * FROM Evaluaciones;


UPDATE Estudiantes
SET correo_estudiante = 'evelin@test.com'
WHERE idEstudiante = 7750010;

UPDATE Estudiantes
SET correo_estudiante = 'cristianmejia301979@correo.itm.edu.co'
WHERE idEstudiante = 6969695;

UPDATE Estudiantes
SET correo_estudiante = 'tomas@test.com'
WHERE idEstudiante = 89710311;

DELETE FROM Licencias WHERE idLicencia = 1;

DELETE FROM Licencias WHERE idLicencia = 2;

--la sentencia esta presente mas no se puede aplicar con exito debido a que esta tabla es un fk de otras tablas
TRUNCATE TABLE EstadosClase;
--aca si funciona Xd
TRUNCATE TABLE Evaluaciones;


SELECT DISTINCT nom_instructor
FROM Profesores
ORDER BY nom_instructor ASC;

SELECT *
FROM Estudiantes
ORDER BY fechaNacimiento DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

SELECT DISTINCT correo_instructor
FROM Profesores;

SELECT *
FROM Estudiantes
ORDER BY fechaInscripcion DESC
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;

SELECT *
FROM Vehiculos
WHERE placaVehiculo LIKE 'D%';

SELECT *
FROM Vehiculos
WHERE placaVehiculo LIKE '%3';


SELECT *
FROM Vehiculos
WHERE idModelo NOT IN (SELECT idModelo FROM Modelos WHERE modelo IN ('Sedán', 'SUV', 'Camioneta'));

SELECT *
FROM Vehiculos
WHERE idModelo IN (SELECT idModelo FROM Modelos WHERE modelo IN ('Sedán', 'SUV', 'Camioneta'));

SELECT *
FROM Vehiculos
WHERE idModelo IN (SELECT idModelo FROM Modelos WHERE modelo IN ('Coupé', 'Convertible', 'Deportivo'));


SELECT *
FROM Vehiculos
WHERE ano_fabricacion BETWEEN 2018 AND 2021;

SELECT cod_Profesor, COUNT(*) as num_estudiantes
FROM Estudiantes
GROUP BY cod_Profesor
HAVING COUNT(*) > 1
ORDER BY num_estudiantes DESC;

SELECT idMarca, COUNT(*) as num_vehiculos
FROM Vehiculos
GROUP BY idMarca
HAVING COUNT(*) > 1
ORDER BY num_vehiculos DESC;


SELECT V.placaVehiculo, M.marca, Mo.modelo
FROM Vehiculos V
INNER JOIN Marcas M ON V.idMarca = M.idMarca
INNER JOIN Modelos Mo ON V.idModelo = Mo.idModelo
WHERE M.marca IN ('Mazda', 'Toyota', 'Chevrolet') AND Mo.modelo IN ('Sedán', 'SUV', 'Camioneta');

SELECT E.nom_estudiante, P.nom_instructor
FROM Estudiantes E
INNER JOIN Profesores P ON E.cod_Profesor = P.cod_Profesor;

SELECT V.placaVehiculo, M.marca
FROM Vehiculos V
LEFT JOIN Marcas M ON V.idMarca = M.idMarca;


SELECT P.cod_Profesor, P.nom_instructor
FROM Profesores P
WHERE P.idLicencia IN (3, 5, 8)
AND EXISTS (SELECT 1 FROM Estudiantes E WHERE E.cod_Profesor = P.cod_Profesor AND E.nom_estudiante IN ('Juan', 'Maria', 'Carlos'));

--voy a volver a repoblar la tabla Evaluaciones para poder las consultas de este punto

INSERT INTO Evaluaciones (idEvaluacion, idEstudiante, idClase, nota_teorica, nota_practica, Observacion) VALUES
(378, 10005893, 356, 4.5, 2.0, 'Buena participación en clase teórica'),
(994, 5777894, 478, 2.3, 3.5, 'Necesita mejorar en estacionamiento durante la clase práctica'),
(475, 6969695, 965, 4.0, 4.8, 'Excelente desempeño en clase teórica'),
(886, 7845136, 126, 2.0, 4.5, 'Buen control del vehículo en clase práctica'),
(799, 635187, 647, 3.5, 1.9, 'Debe participar más en clase teórica'),
(214, 101226058, 988, 2.9, 3.0, 'Debe practicar más el estacionamiento en clase práctica'),
(782, 120518669, 999, 4.5, 3.8, 'Muy buena participación en clase teórica'),
(109, 7750010, 457, 0, 4.0, 'Buen manejo en clase práctica'),
(112, 89710311, 731, 3.5, 4.2, 'Debe mejorar en participación en clase teórica'),
(654, 91218, 689, 1.5, 4.5, 'Excelente control del vehículo en clase práctica');


SELECT SUM(nota_teorica) as total_teorica,
       COUNT(*) as conteo_teorica,
       MIN(nota_teorica) as min_teorica,
       MAX(nota_teorica) as max_teorica,
       AVG(nota_teorica) as promedio_teorica
FROM Evaluaciones;

SELECT SUM(nota_practica) as total_practica,
       COUNT(*) as conteo_practica,
       MIN(nota_practica) as min_practica,
       MAX(nota_practica) as max_practica,
       AVG(nota_practica) as promedio_practica
FROM Evaluaciones;

SELECT LOWER(Observacion) as observacion_minuscula
FROM Evaluaciones;

SELECT UPPER(Observacion) as observacion_mayuscula
FROM Evaluaciones;


SELECT GETDATE() as FechaHoraActual;

SELECT DAY(fecha_hora) as Dia, MONTH(fecha_hora) as Mes, YEAR(fecha_hora) as Año
FROM Clases;

SELECT DATEDIFF(day, fecha_hora, GETDATE()) as DiferenciaDias
FROM Clases;

SELECT CAST(id_clase AS FLOAT) as idClaseFloat
FROM Clases;

SELECT CONVERT(VARCHAR, fecha_hora, 101) as fechaFormatoUSA
FROM Clases;

SELECT CONVERT(VARCHAR, fecha_hora, 120) as fechaFormatoISO
FROM Clases;

SELECT cod_Profesor, nom_instructor, CHOOSE(idLicencia, '6am-4pm', '8am-6pm', '9am-5pm', '10am-6pm') as Horario
FROM Profesores;

SELECT cod_Profesor, nom_instructor, IIF(idLicencia = 3, 'Tiene licencia 3', 'No tiene licencia 3') as Licencia
FROM Profesores;

SELECT cod_Profesor, nom_instructor, ISNULL(telefono, 'No disponible') as Telefono
FROM Profesores;

SELECT cod_Profesor, NULLIF(nom_instructor, 'Oscar') as Nombre
FROM Profesores;

SELECT cod_Profesor, nom_instructor, COALESCE(telefono, correo_instructor) as Contacto
FROM Profesores;

CREATE VIEW Vista_Profesores AS
SELECT cod_Profesor, nom_instructor, ape_instructor
FROM Profesores;

CREATE VIEW Vista_Estudiantes AS
SELECT idEstudiante, nom_estudiante, ape_estudiante
FROM Estudiantes;

CREATE VIEW Vista_Vehiculos AS
SELECT placaVehiculo, ano_fabricacion, fechaAdquisi
FROM Vehiculos;

CREATE VIEW PromedioNotasPorInstructor AS
SELECT 
    P.nom_instructor AS 'Nombre del Instructor',
    AVG(E.nota_teorica) AS 'Promedio Nota Teórica',
    AVG(E.nota_practica) AS 'Promedio Nota Práctica'
FROM 
    Profesores P
INNER JOIN 
    Clases C ON P.cod_Profesor = C.idInstructor
INNER JOIN 
    Evaluaciones E ON C.id_clase = E.idClase
GROUP BY 
    P.nom_instructor;

CREATE VIEW NumeroEstudiantesPorTipoClase AS
SELECT 
    C.tipo_clase AS 'Tipo de Clase',
    COUNT(E.idEstudiante) AS 'Número de Estudiantes'
FROM 
    Clases C
INNER JOIN 
    Evaluaciones E ON C.id_clase = E.idClase
GROUP BY 
    C.tipo_clase;



CREATE PROCEDURE sp_Profesores
AS
SELECT * FROM Profesores;
GO

CREATE PROCEDURE sp_Estudiantes
AS
SELECT * FROM Estudiantes;
GO

CREATE PROCEDURE sp_Vehiculos
AS
SELECT * FROM Vehiculos;
GO

CREATE TRIGGER trg_Insert_Profesores
ON Profesores
AFTER INSERT
AS
PRINT 'Se ha insertado un nuevo profesor';
GO

CREATE TRIGGER trg_Update_Estudiantes
ON Estudiantes
AFTER UPDATE
AS
PRINT 'Se ha actualizado un estudiante';
GO

CREATE TRIGGER trg_Delete_Vehiculos
ON Vehiculos
AFTER DELETE
AS
PRINT 'Se ha eliminado un vehículo';
GO

CREATE TRIGGER ActualizarFechaInscripcion
AFTER INSERT ON Clases
FOR EACH ROW
BEGIN
    UPDATE Estudiantes
    SET fechaInscripcion = NEW.fecha_hora
    WHERE idEstudiante = NEW.idEstudiante;
END;



CREATE USER DataReader WITHOUT LOGIN;
GRANT SELECT ON Vista_Profesores TO DataReader;
GRANT EXECUTE ON sp_Profesores TO DataReader;
GRANT EXECUTE ON trg_Insert_Profesores TO DataReader;

