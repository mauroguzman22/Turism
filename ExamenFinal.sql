CREATE DATABASE IF NOT EXISTS examenFinalSQL;
USE examenFinalSQL;

CREATE TABLE IF NOT EXISTS Categoria (
    ID_Categoria INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS Producto (
    ID_Producto INT AUTO_INCREMENT PRIMARY KEY,
    ID_Categoria INT,
    Nombre VARCHAR(50),
    Cantidad DECIMAL(10, 2),
    Precio DECIMAL(10, 2),
    FOREIGN KEY (ID_Categoria) REFERENCES Categoria(ID_Categoria)
);

INSERT INTO Categoria (Nombre) VALUES 
('Electronico'),
('Hogar'),
('Bazar'),
('Decoracion');

INSERT INTO Producto (Nombre, Cantidad, Precio) VALUES
('Toshiba', '10', '700'),
('Cooler', '2', '100'),
('Teclado Gammer', '3', '90'),
('Mouse LG', '0', '200'),
('Monitor Samsung 19', '20', '1900.36');

INSERT INTO Producto (ID_Categoria) VALUES
('1'),
('2'),
('1'),
('2'),
('2');


DELETE FROM Producto
WHERE Nombre IN ('Toshiba', 'Cooler', 'Teclado Gammer', 'Mouse LG', 'Monitor Samsung 19');


DELETE FROM Producto
WHERE ID_Categoria IN (1, 2);

SET SQL_SAFE_UPDATES = 0;

TRUNCATE TABLE Producto;

INSERT INTO Producto (ID_Categoria,Nombre, Cantidad, Precio) VALUES
('1','Toshiba', '10', '700'),
('2','Cooler', '2', '100'),
('1','Teclado Gammer', '3', '90'),
('2','Mouse LG', '0', '200'),
('2','Monitor Samsung 19', '20', '1900.36');

-- Punto 1
SELECT Nombre, Cantidad
FROM Producto
WHERE Cantidad < 5
ORDER BY Cantidad DESC;

-- Punto 2
SELECT *
FROM Producto
WHERE Precio BETWEEN 50 AND 200;

-- Punto 3
SELECT Producto.Nombre AS nombre_producto, Categoria.Nombre AS nombre_categoria, Producto.Precio
FROM Producto
JOIN Categoria ON Producto.ID_Categoria = Categoria.ID_Categoria
WHERE Producto.Precio > 100;

-- Punto 4
CREATE VIEW VistaProductosMasCaros AS
SELECT Producto.Nombre AS nombre_producto, Categoria.Nombre AS nombre_categoria, Producto.Precio
FROM Producto
JOIN Categoria ON Producto.ID_Categoria = Categoria.ID_Categoria
ORDER BY Producto.Precio DESC
LIMIT 5;
SELECT * FROM VistaProductosMasCaros;

-- Punto 5
SELECT Categoria.Nombre AS nombre_categoria, COUNT(Producto.ID_Producto) AS numero_productos
FROM Categoria
LEFT JOIN Producto ON Categoria.ID_Categoria = Producto.ID_Categoria
GROUP BY Categoria.ID_Categoria, Categoria.Nombre;

-- Punto 6
SELECT
    Categoria.ID_Categoria AS id,
    Categoria.Nombre AS nombre,
    COUNT(Producto.ID_Producto) AS cantidad
FROM
    Categoria
LEFT JOIN
    Producto ON Categoria.ID_Categoria = Producto.ID_Categoria
GROUP BY
    Categoria.ID_Categoria, Categoria.Nombre;
    
-- Punto 7
SELECT
    ID_Categoria AS id,
    Nombre AS nombre
FROM
    Categoria
WHERE NOT EXISTS (
    SELECT 1
    FROM Producto
    WHERE Producto.ID_Categoria = Categoria.ID_Categoria
);

-- Punto 8
SELECT
    Categoria.Nombre AS nombre_categoria,
    COUNT(Producto.ID_Producto) * 100 / (SELECT COUNT(*) FROM Producto) AS porcentaje
FROM
    Categoria
LEFT JOIN
    Producto ON Categoria.ID_Categoria = Producto.ID_Categoria
GROUP BY
    Categoria.ID_Categoria, Categoria.Nombre;

-- Punto 9
DELIMITER //

CREATE PROCEDURE InsertarCategoria(
    IN nombre_categoria VARCHAR(50)
)
BEGIN
    INSERT INTO Categoria (Nombre) VALUES (nombre_categoria);
END //

DELIMITER ;
-- Prueba
CALL InsertarCategoria('Alimentos');

-- Punto 10

CALL InsertarCategoria('Oficina');
INSERT INTO Producto (ID_Categoria, Nombre, Cantidad, Precio)
VALUES (
    (SELECT ID_Categoria FROM Categoria WHERE Nombre = 'Oficina'),
    'Escritorios',
    10,
    1000.00
);

-- Punto 11

UPDATE Producto
SET Cantidad = 30
WHERE ID_Categoria = (SELECT ID_Categoria FROM Categoria WHERE Nombre = 'Electrónico');

-- Punto 12

CREATE TABLE IF NOT EXISTS log_categoria (
    ID_Log INT AUTO_INCREMENT PRIMARY KEY,
    ID_Categoria INT,
    Nombre_Categoria VARCHAR(50),
    Usuario_Eliminacion VARCHAR(50),
    Fecha_Hora_Eliminacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE TRIGGER before_delete_categoria
BEFORE DELETE
ON Categoria
FOR EACH ROW
BEGIN
    INSERT INTO log_categoria (ID_Categoria, Nombre_Categoria, Usuario_Eliminacion)
    VALUES (OLD.ID_Categoria, OLD.Nombre, 'NombreUsuario'); -- Reemplaza 'NombreUsuario' con el nombre del usuario que realiza la eliminación
END //

DELIMITER ;


