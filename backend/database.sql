CREATE DATABASE IF NOT EXISTS fruit_explorer CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE fruit_explorer;

-- --------------------------------------------------------
-- 1. Tabla de Regiones Geográficas
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS regiones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- --------------------------------------------------------
-- 2. Tabla de Frutas (Catálogo Base)
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS frutas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    nombre_cientifico VARCHAR(150),
    sabor TEXT,
    aroma TEXT,
    forma TEXT,
    cascara TEXT,
    interior TEXT,
    -- Macronutrientes por porción estándar (ej: 100g)
    calorias DECIMAL(6,2),
    carbohidratos DECIMAL(6,2),
    proteinas DECIMAL(6,2),
    grasas DECIMAL(6,2),
    fibra DECIMAL(6,2),
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- --------------------------------------------------------
-- 3. Tabla Intermedia: Frutas por Región (Muchos a Muchos)
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS fruta_regiones (
    fruta_id INT NOT NULL,
    region_id INT NOT NULL,
    PRIMARY KEY (fruta_id, region_id),
    CONSTRAINT fk_fr_fruta FOREIGN KEY (fruta_id) REFERENCES frutas(id) ON DELETE CASCADE,
    CONSTRAINT fk_fr_region FOREIGN KEY (region_id) REFERENCES regiones(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- --------------------------------------------------------
-- 4. Tabla de Micronutrientes (Vitaminas y Minerales)
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS micronutrientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL, -- Ej: 'Vitamina C', 'Potasio', 'Vitamina A'
    tipo ENUM('vitamina', 'mineral') NOT NULL
) ENGINE=InnoDB;

-- --------------------------------------------------------
-- 5. Tabla Intermedia: Contenido de Micronutrientes en Frutas
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS fruta_micronutrientes (
    fruta_id INT NOT NULL,
    micronutriente_id INT NOT NULL,
    cantidad VARCHAR(50) NOT NULL, -- Ej: '30 mg', '250 mcg'
    PRIMARY KEY (fruta_id, micronutriente_id),
    CONSTRAINT fk_fm_fruta FOREIGN KEY (fruta_id) REFERENCES frutas(id) ON DELETE CASCADE,
    CONSTRAINT fk_fm_micro FOREIGN KEY (micronutriente_id) REFERENCES micronutrientes(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- --------------------------------------------------------
-- 6. Tabla de Galería de Imágenes (Para ángulos, cortes y modelo)
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS fruta_imagenes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fruta_id INT NOT NULL,
    url_imagen VARCHAR(255) NOT NULL,
    tipo_vista VARCHAR(50) DEFAULT 'entera', -- Ej: 'entera', 'cortada', 'racimo'
    CONSTRAINT fk_img_fruta FOREIGN KEY (fruta_id) REFERENCES frutas(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- --------------------------------------------------------
-- 7. Tabla de Registro de Consultas (Parte 02 del Proyecto)
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS query_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fruit_id INT NOT NULL,
    metodo_deteccion VARCHAR(50) NOT NULL, 
    tts_usado BOOLEAN DEFAULT FALSE,       
    ubicacion_zona VARCHAR(100) DEFAULT 'Desconocida', 
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_log_fruit FOREIGN KEY (fruit_id) REFERENCES frutas(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- --------------------------------------------------------
-- 8. Datos Iniciales (Seed Data con Maracuyá)
-- --------------------------------------------------------

-- Regiones
INSERT INTO regiones (id, nombre, descripcion) VALUES 
(1, 'Selva', 'Zona tropical húmeda con gran biodiversidad.'),
(2, 'Costa', 'Región árida y de valles fértiles.'),
(3, 'Sierra', 'Región montañosa con valles interandinos.');

-- Fruta: Maracuyá
INSERT INTO frutas (id, nombre, nombre_cientifico, sabor, aroma, forma, cascara, interior, calorias, carbohidratos, proteinas, grasas, fibra) VALUES 
(
    1, 
    'Maracuyá', 
    'Passiflora edulis', 
    'Predominantemente ácido y refrescante, equilibrado con notas dulces.', 
    'Muy intenso y tropical, producto de decenas de compuestos aromáticos.',
    'Redonda u ovalada, de tamaño pequeño a mediano (4 a 8 cm).',
    'Gruesa y firme; amarilla brillante o morada, arrugada al madurar.',
    'Pulpa gelatinosa y jugosa amarillo-anaranjado con semillas crujientes.',
    97.00, 23.30, 2.20, 0.70, 10.40
);

-- Relación de Maracuyá con Regiones (Se cultiva en Costa y Selva)
INSERT INTO fruta_regiones (fruta_id, region_id) VALUES (1, 1), (1, 2);

-- Micronutrientes de ejemplo
INSERT INTO micronutrientes (id, nombre, tipo) VALUES 
(1, 'Vitamina C', 'vitamina'),
(2, 'Vitamina A', 'vitamina'),
(3, 'Potasio', 'mineral');

-- Asignar micronutrientes a la Maracuyá
INSERT INTO fruta_micronutrientes (fruta_id, micronutriente_id, cantidad) VALUES 
(1, 1, '30 mg'),
(1, 2, '1270 IU'),
(1, 3, '348 mg');

-- Imágenes de referencia para la Maracuyá
INSERT INTO fruta_imagenes (fruta_id, url_imagen, tipo_vista) VALUES 
(1, 'https://example.com/images/maracuya_entera.jpg', 'entera'),
(1, 'https://example.com/images/maracuya_cortada.jpg', 'cortada');