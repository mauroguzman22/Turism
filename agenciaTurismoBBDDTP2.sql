
CREATE DATABASE IF NOT EXISTS AgenciaTurismo;
USE AgenciaTurismo;


CREATE TABLE IF NOT EXISTS Clientes (
    ID_Cliente INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50),
    Apellido VARCHAR(50),
    CorreoElectronico VARCHAR(100),
    Telefono VARCHAR(15),
    Direccion VARCHAR(100)
);


CREATE TABLE IF NOT EXISTS Destinos (
    ID_Destino INT AUTO_INCREMENT PRIMARY KEY,
    NombreDestino VARCHAR(100),
    Descripcion TEXT,
    PrecioPorPersona DECIMAL(10, 2)
);

CREATE TABLE IF NOT EXISTS Empleados (
    ID_Empleado INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50),
    Apellido VARCHAR(50),
    CorreoElectronico VARCHAR(100),
    Telefono VARCHAR(15),
    Puesto VARCHAR(50),
    Salario DECIMAL(10, 2)
);

CREATE TABLE IF NOT EXISTS Reservas (
    ID_Reserva INT AUTO_INCREMENT PRIMARY KEY,
    ID_Cliente INT,
    ID_Destino INT,
    ID_Empleado INT,
    FechaReserva DATE,
    FechaViaje DATE,
    NumeroPersonas INT,
    EstadoPago BOOLEAN,
    FOREIGN KEY (ID_Cliente) REFERENCES Clientes(ID_Cliente),
    FOREIGN KEY (ID_Destino) REFERENCES Destinos(ID_Destino),
    FOREIGN KEY (ID_Empleado) REFERENCES Empleados(ID_Empleado)
);



CREATE TABLE IF NOT EXISTS PaquetesTuristicos (
    ID_Paquete INT AUTO_INCREMENT PRIMARY KEY,
    NombrePaquete VARCHAR(100),
    Descripcion TEXT,
    PrecioPaquete DECIMAL(10, 2),
    ID_EmpleadoResponsable INT,
    FOREIGN KEY (ID_EmpleadoResponsable) REFERENCES Empleados(ID_Empleado)
);


CREATE TABLE IF NOT EXISTS Paquete_Destino (
    ID_Paquete INT,
    ID_Destino INT,
    PRIMARY KEY (ID_Paquete, ID_Destino),
    FOREIGN KEY (ID_Paquete) REFERENCES PaquetesTuristicos(ID_Paquete),
    FOREIGN KEY (ID_Destino) REFERENCES Destinos(ID_Destino)
);


INSERT INTO Clientes (Nombre, Apellido, CorreoElectronico, Telefono, Direccion) VALUES
('Juan', 'Pérez', 'juan.perez@example.com', '123456789', 'Calle 123'),
('María', 'González', 'maria.gonzalez@example.com', '987654321', 'Avenida 456'),
('Carlos', 'Sánchez', 'carlos.sanchez@example.com', '456123789', 'Boulevard 789');


INSERT INTO Destinos (NombreDestino, Descripcion, PrecioPorPersona) VALUES
('Playa del Carmen', 'Hermosas playas de arena blanca en el Caribe', 500.00),
('París', 'La ciudad del amor y la luz', 800.00),
('Kioto', 'Antigua ciudad japonesa llena de templos y tradiciones', 600.00);


INSERT INTO Empleados (Nombre, Apellido, CorreoElectronico, Telefono, Puesto, Salario) VALUES
('Luis', 'Martínez', 'luis.martinez@example.com', '111222333', 'Agente de Viajes', 2000.00),
('Ana', 'López', 'ana.lopez@example.com', '444555666', 'Gerente de Ventas', 3000.00),
('Pedro', 'García', 'pedro.garcia@example.com', '777888999', 'Asistente de Reservas', 1500.00);


INSERT INTO Reservas (ID_Cliente, ID_Destino, ID_Empleado, FechaReserva, FechaViaje, NumeroPersonas, EstadoPago) VALUES
(1, 1, 1, '2023-09-25', '2023-10-10', 2, 1),
(2, 2, 2, '2023-09-26', '2023-11-15', 1, 0),
(3, 3, 3, '2023-09-27', '2023-12-20', 4, 1);



INSERT INTO PaquetesTuristicos (NombrePaquete, Descripcion, PrecioPaquete, ID_EmpleadoResponsable) VALUES
('Escapada Romántica', 'Paquete ideal para parejas', 1200.00, 2),
('Aventura en la Naturaleza', 'Paquete para los amantes de la naturaleza y la aventura', 1500.00, 3),
('Viaje Cultural', 'Descubre la historia y la cultura de diferentes destinos', 1800.00, 1);


INSERT INTO Paquete_Destino (ID_Paquete, ID_Destino) VALUES
(1, 2),
(2, 3),
(3, 1);


CREATE VIEW Vista_Reservas_Clientes AS
SELECT R.ID_Reserva, R.FechaReserva, R.FechaViaje, R.NumeroPersonas, R.EstadoPago, 
C.Nombre AS NombreCliente, C.Apellido AS ApellidoCliente, C.CorreoElectronico AS CorreoCliente
FROM Reservas R
JOIN Clientes C ON R.ID_Cliente = C.ID_Cliente;


CREATE VIEW Vista_Paquetes_Destinos AS
SELECT PT.NombrePaquete, PT.Descripcion AS DescripcionPaquete, PT.PrecioPaquete, 
D.NombreDestino, D.Descripcion AS DescripcionDestino, D.PrecioPorPersona
FROM PaquetesTuristicos PT
JOIN Paquete_Destino PD ON PT.ID_Paquete = PD.ID_Paquete
JOIN Destinos D ON PD.ID_Destino = D.ID_Destino;


CREATE VIEW Vista_Empleados AS
SELECT ID_Empleado, Nombre, Apellido, CorreoElectronico, Telefono, Puesto, Salario
FROM Empleados;


CREATE VIEW Vista_Reservas_Empleados_Destinos AS
SELECT R.ID_Reserva, R.FechaReserva, R.FechaViaje, R.NumeroPersonas, R.EstadoPago, 
C.Nombre AS NombreCliente, C.Apellido AS ApellidoCliente, 
E.Nombre AS NombreEmpleado, E.Apellido AS ApellidoEmpleado, 
D.NombreDestino, D.Descripcion AS DescripcionDestino, D.PrecioPorPersona
FROM Reservas R
JOIN Clientes C ON R.ID_Cliente = C.ID_Cliente
JOIN Empleados E ON R.ID_Empleado = E.ID_Empleado
JOIN Destinos D ON R.ID_Destino = D.ID_Destino;

USE agenciaTurismo;


DELIMITER $$
CREATE FUNCTION ObtenerNombreCompletoEmpleado(IDEmpleado INT) RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE NombreCompleto VARCHAR(100);
    SELECT CONCAT(Nombre, ' ', Apellido) INTO NombreCompleto
    FROM Empleados
    WHERE ID_Empleado = IDEmpleado;
    RETURN NombreCompleto;
END;


USE agenciaTurismo;


DELIMITER $$
CREATE PROCEDURE ActualizarPrecioPaquete(IN IDPaquete INT, IN NuevoPrecio DECIMAL(10, 2))
BEGIN
    UPDATE PaquetesTuristicos
    SET PrecioPaquete = NuevoPrecio
    WHERE ID_Paquete = IDPaquete;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE MostrarReservasCliente(IN IDCliente INT)
BEGIN
    SELECT *
    FROM Reservas
    WHERE ID_Cliente = IDCliente;
END$$
DELIMITER ;

USE agenciaTurismo;


DELIMITER //
CREATE TRIGGER ActualizarSalarioEmpleado 
BEFORE UPDATE ON Empleados
FOR EACH ROW
BEGIN
    IF NEW.Puesto = 'Gerente' THEN
        SET NEW.Salario = OLD.Salario * 1.1;
    ELSEIF NEW.Puesto = 'Asistente' THEN
        SET NEW.Salario = OLD.Salario * 1.05;
    END IF;
END//
DELIMITER ;


USE agenciaTurismo;
DELIMITER //

CREATE TRIGGER ActualizarPrecioTotalPaquete 
AFTER INSERT ON Reservas
FOR EACH ROW
BEGIN
    DECLARE PrecioTotalPaquete DECIMAL(10, 2);
    SET PrecioTotalPaquete = (SELECT CalcularPrecioTotalPaquete(NEW.ID_Reserva));
    UPDATE PaquetesTuristicos
    SET PrecioPaquete = PrecioTotalPaquete
    WHERE ID_Paquete = (SELECT ID_Paquete FROM Paquete_Destino WHERE ID_Destino = NEW.ID_Destino);
END//

DELIMITER ;


USE agenciaTurismo;

DELIMITER //
CREATE FUNCTION CalcularPrecioTotalPaquete(IDPaquete INT) RETURNS DECIMAL(10, 2) DETERMINISTIC
BEGIN
    DECLARE PrecioTotal DECIMAL(10, 2);
    SELECT SUM(PrecioPorPersona) INTO PrecioTotal
    FROM Destinos
    WHERE ID_Destino IN (SELECT ID_Destino FROM Paquete_Destino WHERE ID_Paquete = IDPaquete);
    RETURN PrecioTotal;
END//
DELIMITER ;






