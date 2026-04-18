CREATE DATABASE IF NOT EXISTS inmobiliaria_db;
USE inmobiliaria_db;

CREATE TABLE IF NOT EXISTS propiedades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL,
    ubicacion VARCHAR(150) NOT NULL
);

INSERT INTO propiedades (titulo, descripcion, precio, ubicacion) VALUES 
('Departamento Moderno', 'Excelente depa de 3 habitaciones con balcón.', 120000.00, 'Santiago de Surco'),
('Casa de Playa', 'Ubicada a 5 minutos del mar, piscina privada.', 240000.00, 'Asia'),
('Oficina Céntrica', 'Oficina equipada en centro empresarial.', 85000.00, 'San Isidro');
