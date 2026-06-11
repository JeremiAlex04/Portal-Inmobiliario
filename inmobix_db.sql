-- ============================================================
--  InmobiX - Portal Inmobiliario Perú
--  Base de Datos MySQL
--  Versión: 2.2 (Estructura Ordenada, 15 Propiedades y Datos Proporcionales)
-- ============================================================

-- DROP DATABASE IF EXISTS inmobix_db;
-- CREATE DATABASE inmobix_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- USE inmobix_db;

-- SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================
-- ELIMINACIÓN DE TABLAS Y VISTAS EXISTENTES (Limpieza)
-- ============================================================
-- DROP VIEW IF EXISTS v_propiedades_bimonetarias;
-- DROP TABLE IF EXISTS evento_auditoria;
-- DROP TABLE IF EXISTS estadisticas_propiedad;
-- DROP TABLE IF EXISTS pago;
-- DROP TABLE IF EXISTS suscripcion;
-- DROP TABLE IF EXISTS plan;
-- DROP TABLE IF EXISTS contacto;
-- DROP TABLE IF EXISTS contactos_whatsapp;
-- DROP TABLE IF EXISTS consultas;
-- DROP TABLE IF EXISTS propiedad_fotos;
-- DROP TABLE IF EXISTS usuario_favorito;
-- DROP TABLE IF EXISTS propiedad;
-- DROP TABLE IF EXISTS tipo_cambio;
-- DROP TABLE IF EXISTS operacion;
-- DROP TABLE IF EXISTS tipo_inmueble;
-- DROP TABLE IF EXISTS usuario;
-- DROP TABLE IF EXISTS rol;
-- DROP TABLE IF EXISTS distrito;
-- DROP TABLE IF EXISTS provincia;
-- DROP TABLE IF EXISTS departamento;

-- SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- PARTE 1: DEFINICIÓN DE TABLAS (DDL)
-- ============================================================

-- Bloque 1.1: Geografía Peruana
CREATE TABLE departamento (
    id_departamento   INT UNSIGNED     NOT NULL AUTO_INCREMENT,
    nombre            VARCHAR(80)      NOT NULL,
    codigo_ubigeo     CHAR(2)          NOT NULL COMMENT 'Código INEI (ej: 15 = Lima)',
    PRIMARY KEY (id_departamento),
    UNIQUE KEY uq_dep_ubigeo (codigo_ubigeo)
) ENGINE=InnoDB COMMENT='Departamentos del Perú (INEI)';

CREATE TABLE provincia (
    id_provincia      INT UNSIGNED     NOT NULL AUTO_INCREMENT,
    id_departamento   INT UNSIGNED     NOT NULL,
    nombre            VARCHAR(80)      NOT NULL,
    codigo_ubigeo     CHAR(4)          NOT NULL COMMENT 'Código INEI (ej: 1501 = Lima)',
    PRIMARY KEY (id_provincia),
    UNIQUE KEY uq_prov_ubigeo (codigo_ubigeo),
    CONSTRAINT fk_prov_dep FOREIGN KEY (id_departamento)
        REFERENCES departamento(id_departamento) ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE distrito (
    id_distrito       INT UNSIGNED     NOT NULL AUTO_INCREMENT,
    id_provincia      INT UNSIGNED     NOT NULL,
    nombre            VARCHAR(80)      NOT NULL,
    codigo_ubigeo     CHAR(6)          NOT NULL COMMENT 'Código INEI (ej: 150101 = Lima Cercado)',
    PRIMARY KEY (id_distrito),
    UNIQUE KEY uq_dist_ubigeo (codigo_ubigeo),
    CONSTRAINT fk_dist_prov FOREIGN KEY (id_provincia)
        REFERENCES provincia(id_provincia) ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Bloque 1.2: Usuarios y Roles
CREATE TABLE rol (
    id_rol            TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre            VARCHAR(40)      NOT NULL,
    descripcion       VARCHAR(200)     NULL,
    PRIMARY KEY (id_rol),
    UNIQUE KEY uq_rol_nombre (nombre)
) ENGINE=InnoDB COMMENT='Visitante, Comprador, Agente, Constructora, Administrador';

CREATE TABLE usuario (
    id_usuario        BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    id_rol            TINYINT UNSIGNED NOT NULL,
    nombres           VARCHAR(80)      NOT NULL,
    apellidos         VARCHAR(80)      NOT NULL,
    correo            VARCHAR(120)     NOT NULL,
    password_hash     CHAR(60)         NOT NULL COMMENT 'Bcrypt (RNF-02)',
    telefono          VARCHAR(15)      NULL,
    dni_ruc           VARCHAR(11)      NULL     COMMENT 'DNI 8 dígitos o RUC 11 dígitos',
    avatar_url        VARCHAR(255)     NULL,
    verificado        TINYINT(1)       NOT NULL DEFAULT 0,
    token_verificacion VARCHAR(100)    NULL,
    activo            TINYINT(1)       NOT NULL DEFAULT 1,
    fecha_registro    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME       NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id_usuario),
    UNIQUE KEY uq_usr_correo (correo),
    CONSTRAINT fk_usr_rol FOREIGN KEY (id_rol)
        REFERENCES rol(id_rol) ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Tabla central de usuarios';

-- Bloque 1.3: Catálogos de Propiedades
CREATE TABLE tipo_inmueble (
    id_tipo           TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre            VARCHAR(60)      NOT NULL COMMENT 'Casa, Departamento, Terreno, Local, Oficina…',
    PRIMARY KEY (id_tipo)
) ENGINE=InnoDB;

CREATE TABLE operacion (
    id_operacion      TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre            VARCHAR(30)      NOT NULL COMMENT 'VENTA, ALQUILER, ANTICRESIS',
    PRIMARY KEY (id_operacion)
) ENGINE=InnoDB;

-- Bloque 1.4: Tipo de Cambio
CREATE TABLE tipo_cambio (
    id_tipo_cambio    INT UNSIGNED     NOT NULL AUTO_INCREMENT,
    par_moneda        CHAR(7)          NOT NULL DEFAULT 'USD/PEN' COMMENT 'Par: USD/PEN',
    compra            DECIMAL(8,4)     NOT NULL,
    venta             DECIMAL(8,4)     NOT NULL,
    fuente            ENUM('SBS','SUNAT','MANUAL') NOT NULL DEFAULT 'SBS',
    fecha_vigencia    DATE             NOT NULL,
    fecha_registro    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_tipo_cambio),
    UNIQUE KEY uq_tc_fecha (par_moneda, fecha_vigencia),
    INDEX idx_tc_vigencia (fecha_vigencia)
) ENGINE=InnoDB COMMENT='Tipo de cambio diario SBS/SUNAT';

-- Bloque 1.5: Planes y Suscripciones (Monetización)
CREATE TABLE plan (
    id_plan           TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre            VARCHAR(40)      NOT NULL COMMENT 'GRATUITO, BASICO, PREMIUM',
    precio_pen        DECIMAL(10,2)    NOT NULL DEFAULT 0.00,
    duracion_dias     SMALLINT UNSIGNED NOT NULL DEFAULT 30,
    max_propiedades   SMALLINT UNSIGNED NOT NULL DEFAULT 1,
    max_fotos         TINYINT UNSIGNED NOT NULL DEFAULT 10,
    destacada         TINYINT(1)       NOT NULL DEFAULT 0,
    analytics         TINYINT(1)       NOT NULL DEFAULT 0,
    descripcion       TEXT             NULL,
    activo            TINYINT(1)       NOT NULL DEFAULT 1,
    PRIMARY KEY (id_plan)
) ENGINE=InnoDB COMMENT='Planes de suscripción';

CREATE TABLE suscripcion (
    id_suscripcion    BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    id_usuario        BIGINT UNSIGNED  NOT NULL,
    id_plan           TINYINT UNSIGNED NOT NULL,
    fecha_inicio      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_fin         DATETIME         NOT NULL,
    estado            ENUM('ACTIVA','VENCIDA','CANCELADA') NOT NULL DEFAULT 'ACTIVA',
    PRIMARY KEY (id_suscripcion),
    INDEX idx_sus_usuario (id_usuario),
    CONSTRAINT fk_sus_usr  FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario),
    CONSTRAINT fk_sus_plan FOREIGN KEY (id_plan)
        REFERENCES plan(id_plan)
) ENGINE=InnoDB;

CREATE TABLE pago (
    id_pago           BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    id_suscripcion    BIGINT UNSIGNED  NOT NULL,
    monto             DECIMAL(10,2)    NOT NULL,
    moneda            CHAR(3)          NOT NULL DEFAULT 'PEN',
    metodo            ENUM('TARJETA','YAPE','PLIN','PAGO_EFECTIVO','TRANSFERENCIA') NOT NULL,
    pasarela          ENUM('CULQI','NIUBIZ','IZIPAY','OTRO') NOT NULL,
    referencia_externa VARCHAR(100)    NULL COMMENT 'ID de transacción o código op.',
    estado            ENUM('PENDIENTE','APROBADO','RECHAZADO','REEMBOLSADO') NOT NULL DEFAULT 'PENDIENTE',
    fecha_pago        DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_pago),
    INDEX idx_pago_sus (id_suscripcion),
    CONSTRAINT fk_pago_sus FOREIGN KEY (id_suscripcion)
        REFERENCES suscripcion(id_suscripcion)
) ENGINE=InnoDB COMMENT='Registro de pagos';

-- Bloque 1.6: Propiedades
CREATE TABLE propiedad (
    id_propiedad          BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,

    -- Relaciones
    id_usuario_agente     BIGINT UNSIGNED  NOT NULL COMMENT 'Agente o constructora propietaria',
    id_tipo_inmueble      TINYINT UNSIGNED NOT NULL,
    id_operacion          TINYINT UNSIGNED NOT NULL,
    id_distrito           INT UNSIGNED     NOT NULL,

    -- Identificación Registral
    partida_sunarp        VARCHAR(20)      NULL COMMENT 'Partida Registral SUNARP (RF-02)',

    -- Descripción
    titulo                VARCHAR(200)     NOT NULL,
    descripcion           TEXT             NULL,
    direccion             VARCHAR(200)     NOT NULL,
    referencia            VARCHAR(200)     NULL COMMENT 'Ej: A 2 cuadras del Óvalo Gutierrez',
    latitud               DECIMAL(10,7)    NULL,
    longitud              DECIMAL(10,7)    NULL,

    -- Datos Técnicos
    area_total_m2         DECIMAL(10,2)    NULL COMMENT 'Área total del terreno',
    area_techada_m2       DECIMAL(10,2)    NULL COMMENT 'Área techada/construida',
    num_dormitorios       TINYINT UNSIGNED NULL,
    num_banos             TINYINT UNSIGNED NULL,
    num_cocheras          TINYINT UNSIGNED NULL,
    num_pisos             TINYINT UNSIGNED NULL,
    anio_construccion     SMALLINT UNSIGNED NULL,

    -- Precio Bimonetario
    moneda_base           ENUM('PEN','USD') NOT NULL DEFAULT 'USD',
    precio                DECIMAL(14,2)    NOT NULL,

    -- Atributos Especiales
    bono_mi_vivienda      TINYINT(1)       NOT NULL DEFAULT 0,
    bono_verde            TINYINT(1)       NOT NULL DEFAULT 0,
    tour_360_url          VARCHAR(255)     NULL,
    
    -- Multimedia / Vistas principales
    foto_principal        VARCHAR(255)     NULL COMMENT 'Ruta relativa a la foto principal',
    numero_vistas         INT UNSIGNED     NOT NULL DEFAULT 0 COMMENT 'Contador de vistas en detalle',

    -- Estado de publicación
    estado                ENUM('BORRADOR','ACTIVO','PAUSADO','VENDIDO','ELIMINADO')
                          NOT NULL DEFAULT 'BORRADOR',
    destacada             TINYINT(1)       NOT NULL DEFAULT 0,
    premium               TINYINT(1)       NOT NULL DEFAULT 0,
    fecha_publicacion     DATETIME         NULL,
    fecha_expiracion      DATETIME         NULL,

    -- Auditoría
    fecha_creacion        DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion   DATETIME         NULL ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (id_propiedad),
    INDEX idx_prop_distrito  (id_distrito),
    INDEX idx_prop_estado    (estado),
    INDEX idx_prop_tipo      (id_tipo_inmueble),
    INDEX idx_prop_operacion (id_operacion),
    INDEX idx_prop_precio    (moneda_base, precio),
    INDEX idx_prop_coords    (latitud, longitud),
    FULLTEXT INDEX ft_prop_titulo_desc (titulo, descripcion),

    CONSTRAINT fk_prop_agente   FOREIGN KEY (id_usuario_agente)
        REFERENCES usuario(id_usuario) ON UPDATE CASCADE,
    CONSTRAINT fk_prop_tipo     FOREIGN KEY (id_tipo_inmueble)
        REFERENCES tipo_inmueble(id_tipo),
    CONSTRAINT fk_prop_op       FOREIGN KEY (id_operacion)
        REFERENCES operacion(id_operacion),
    CONSTRAINT fk_prop_dist     FOREIGN KEY (id_distrito)
        REFERENCES distrito(id_distrito)
) ENGINE=InnoDB COMMENT='Tabla principal de propiedades';

-- Bloque 1.7: Multimedia y Favoritos
CREATE TABLE usuario_favorito (
    id_favorito       BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    id_usuario        BIGINT UNSIGNED  NOT NULL,
    id_propiedad      BIGINT UNSIGNED  NOT NULL,
    fecha_agregado    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_favorito),
    UNIQUE KEY uq_usr_fav (id_usuario, id_propiedad),
    CONSTRAINT fk_ufav_usr FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    CONSTRAINT fk_ufav_prop FOREIGN KEY (id_propiedad)
        REFERENCES propiedad(id_propiedad) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='Favoritos del usuario';

CREATE TABLE propiedad_fotos (
    id_foto           BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    id_propiedad      BIGINT UNSIGNED  NOT NULL,
    ruta_archivo      VARCHAR(255)     NOT NULL,
    orden             TINYINT UNSIGNED NOT NULL DEFAULT 0,
    es_principal      TINYINT(1)       NOT NULL DEFAULT 0,
    fecha_subida      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_foto),
    INDEX idx_pf_propiedad (id_propiedad),
    CONSTRAINT fk_pf_prop FOREIGN KEY (id_propiedad)
        REFERENCES propiedad(id_propiedad) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='Galería de fotos por propiedad';

-- Bloque 1.8: Interacciones
CREATE TABLE consultas (
    id_consulta       BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    id_propiedad      BIGINT UNSIGNED  NOT NULL,
    id_usuario        BIGINT UNSIGNED  NULL COMMENT 'NULL si es visitante',
    nombre            VARCHAR(120)     NOT NULL,
    email             VARCHAR(120)     NOT NULL,
    telefono          VARCHAR(15)      NULL,
    mensaje           TEXT             NOT NULL,
    estado            ENUM('PENDIENTE','LEIDA','RESPONDIDA','NO_INTERESADO') NOT NULL DEFAULT 'PENDIENTE',
    fecha             DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_consulta),
    INDEX idx_cons_prop (id_propiedad),
    INDEX idx_cons_estado (estado),
    CONSTRAINT fk_cons_prop FOREIGN KEY (id_propiedad)
        REFERENCES propiedad(id_propiedad) ON DELETE CASCADE,
    CONSTRAINT fk_cons_usr FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='Consultas de contacto por propiedad';

CREATE TABLE contactos_whatsapp (
    id_contacto       BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    id_propiedad      BIGINT UNSIGNED  NOT NULL,
    id_usuario        BIGINT UNSIGNED  NULL,
    fecha             DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_contacto),
    INDEX idx_cwa_prop (id_propiedad),
    CONSTRAINT fk_cwa_prop FOREIGN KEY (id_propiedad)
        REFERENCES propiedad(id_propiedad) ON DELETE CASCADE,
    CONSTRAINT fk_cwa_usr FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='Registro de contactos WhatsApp';

CREATE TABLE contacto (
    id_contacto       INT UNSIGNED     NOT NULL AUTO_INCREMENT,
    nombre            VARCHAR(120)     NOT NULL,
    email             VARCHAR(120)     NOT NULL,
    mensaje           TEXT             NOT NULL,
    fecha             DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_contacto)
) ENGINE=InnoDB COMMENT='Mensajes del formulario de contacto general';

-- Bloque 1.9: Analytics y Métricas
CREATE TABLE estadisticas_propiedad (
    id_estadistica    BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    id_propiedad      BIGINT UNSIGNED  NOT NULL,
    fecha             DATE             NOT NULL,
    num_vistas        INT UNSIGNED     NOT NULL DEFAULT 0,
    PRIMARY KEY (id_estadistica),
    UNIQUE KEY uq_est_prop_fecha (id_propiedad, fecha),
    CONSTRAINT fk_est_prop FOREIGN KEY (id_propiedad)
        REFERENCES propiedad(id_propiedad) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='Vistas diarias de propiedades';

-- Bloque 1.10: Seguridad (Auditoría)
CREATE TABLE evento_auditoria (
    id_evento         BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    id_usuario        BIGINT UNSIGNED  NULL,
    entidad           VARCHAR(50)      NOT NULL COMMENT 'Ej: propiedad, usuario, pago',
    id_entidad        BIGINT UNSIGNED  NOT NULL,
    accion            ENUM('CREAR','ACTUALIZAR','ELIMINAR','LOGIN','LOGOUT') NOT NULL,
    ip_origen         VARCHAR(45)      NULL,
    user_agent        VARCHAR(300)     NULL,
    detalle_json      JSON             NULL,
    fecha_evento      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_evento),
    INDEX idx_audit_usr    (id_usuario),
    INDEX idx_audit_entidad (entidad, id_entidad),
    INDEX idx_audit_fecha   (fecha_evento),
    CONSTRAINT fk_aud_usr  FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='Log de auditoría';


-- ============================================================
-- PARTE 2: INSERCIÓN DE DATOS SEMILLA (DML)
-- ============================================================

-- Bloque 2.1: Geografía Peruana (Lima como Departamento Central)
INSERT INTO departamento (id_departamento, nombre, codigo_ubigeo) VALUES 
(1, 'Lima', '15');

INSERT INTO provincia (id_provincia, id_departamento, nombre, codigo_ubigeo) VALUES 
(1, 1, 'Lima', '1501');

INSERT INTO distrito (id_distrito, id_provincia, nombre, codigo_ubigeo) VALUES 
(1, 1, 'Miraflores', '150122'), 
(2, 1, 'San Isidro', '150131'), 
(3, 1, 'Santiago de Surco', '150140'),
(4, 1, 'La Molina', '150114'), 
(5, 1, 'Lima Cercado', '150101'), 
(6, 1, 'San Borja', '150130'),
(7, 1, 'Barranco', '150104'), 
(8, 1, 'Jesús María', '150113'), 
(9, 1, 'Lince', '150116'),
(10, 1, 'Magdalena del Mar', '150117'), 
(11, 1, 'Pueblo Libre', '150121'), 
(12, 1, 'San Miguel', '150136'),
(13, 1, 'Chorrillos', '150108'), 
(14, 1, 'Ate', '150103'), 
(15, 1, 'Los Olivos', '150115');

-- Bloque 2.2: Roles Originales
INSERT INTO rol (id_rol, nombre, descripcion) VALUES
(1, 'VISITANTE',      'Acceso de solo lectura sin registro'),
(2, 'COMPRADOR',      'Usuario registrado que busca inmuebles'),
(3, 'AGENTE',         'Agente inmobiliario que publica propiedades'),
(4, 'CONSTRUCTORA',   'Empresa desarrolladora con acceso a proyectos en masa'),
(5, 'ADMINISTRADOR',  'Control total de la plataforma');

-- Bloque 2.3: Usuarios de Inicio Originales (Password para todos: 123456)
INSERT INTO usuario (id_usuario, id_rol, nombres, apellidos, correo, password_hash, telefono, activo, verificado) VALUES
(1, 3, 'Carlos', 'Mendoza López', 'agente@inmobix.com', '$2a$10$Gtq9fAQEJWhkZi0fZXnVH.90d09O/L1amhSzPar/OlQsCuAHk9IFO', '987654321', 1, 1),
(2, 5, 'Super', 'Administrador', 'admin@inmobix.pe', '$2a$10$Gtq9fAQEJWhkZi0fZXnVH.90d09O/L1amhSzPar/OlQsCuAHk9IFO', '999888777', 1, 1),
(3, 3, 'María', 'Torres Gutiérrez', 'maria.torres@inmobix.com', '$2a$10$Gtq9fAQEJWhkZi0fZXnVH.90d09O/L1amhSzPar/OlQsCuAHk9IFO', '912345678', 1, 1),
(4, 2, 'Pedro', 'Ramírez Castro', 'comprador@inmobix.pe', '$2a$10$Gtq9fAQEJWhkZi0fZXnVH.90d09O/L1amhSzPar/OlQsCuAHk9IFO', '955444333', 1, 1);

-- Bloque 2.4: Catálogos de Propiedades Originales
INSERT INTO tipo_inmueble (id_tipo, nombre) VALUES
(1, 'Casa'),
(2, 'Departamento'),
(3, 'Terreno'),
(4, 'Local Comercial'),
(5, 'Oficina'),
(6, 'Industrial'),
(7, 'Cochera'),
(8, 'Proyecto Multifamiliar');

INSERT INTO operacion (id_operacion, nombre) VALUES 
(1, 'VENTA'),
(2, 'ALQUILER'),
(3, 'ANTICRESIS');

-- Bloque 2.5: Tipo de Cambio SBS
INSERT INTO tipo_cambio (par_moneda, compra, venta, fuente, fecha_vigencia) VALUES
('USD/PEN', 3.7500, 3.7800, 'SBS', CURDATE());

-- Bloque 2.6: Planes de Suscripción Originales
INSERT INTO plan (id_plan, nombre, precio_pen, duracion_dias, max_propiedades, max_fotos, destacada, analytics, descripcion) VALUES
(1, 'GRATUITO',    0.00, 30,  1,  5, 0, 0, '1 propiedad activa. Publicación básica.'),
(2, 'BASICO',    50.00, 30,  5, 20, 0, 0, '5 propiedades activas. Visibilidad estándar.'),
(3, 'PREMIUM',  150.00, 30, 20, 30, 1, 1, '20 propiedades destacadas. Analytics y prioridad.');

-- Bloque 2.7: Suscripciones y Pagos (Proporcionales a los Agentes de Inicio)
-- Carlos (Agente 1) contrata Plan PREMIUM (ID 3)
INSERT INTO suscripcion (id_suscripcion, id_usuario, id_plan, fecha_inicio, fecha_fin, estado) VALUES 
(1, 1, 3, DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_ADD(NOW(), INTERVAL 25 DAY), 'ACTIVA');

INSERT INTO pago (id_pago, id_suscripcion, monto, moneda, metodo, pasarela, referencia_externa, estado, fecha_pago) VALUES 
(1, 1, 150.00, 'PEN', 'TARJETA', 'CULQI', 'OP-XYZ12345', 'APROBADO', DATE_SUB(NOW(), INTERVAL 5 DAY));

-- María (Agente 3) contrata Plan BASICO (ID 2)
INSERT INTO suscripcion (id_suscripcion, id_usuario, id_plan, fecha_inicio, fecha_fin, estado) VALUES 
(2, 3, 2, DATE_SUB(NOW(), INTERVAL 10 DAY), DATE_ADD(NOW(), INTERVAL 20 DAY), 'ACTIVA');

INSERT INTO pago (id_pago, id_suscripcion, monto, moneda, metodo, pasarela, referencia_externa, estado, fecha_pago) VALUES 
(2, 2, 50.00, 'PEN', 'YAPE', 'CULQI', 'OP-YAPE8888', 'APROBADO', DATE_SUB(NOW(), INTERVAL 10 DAY));

-- Bloque 2.8: 15 Propiedades (100% peruanas, con imágenes referenciales válidas y distintas)
INSERT INTO propiedad (
    id_propiedad, id_usuario_agente, id_tipo_inmueble, id_operacion, id_distrito, partida_sunarp, 
    titulo, descripcion, direccion, referencia, latitud, longitud, 
    area_total_m2, area_techada_m2, num_dormitorios, num_banos, num_cocheras, num_pisos, anio_construccion, 
    moneda_base, precio, bono_mi_vivienda, bono_verde, foto_principal, estado, destacada, fecha_publicacion, fecha_expiracion
) VALUES 
-- 1. Miraflores
(1, 1, 1, 1, 1, '11002233', 
 'Casa Moderna de Estreno cerca al Malecón', 
 'Hermosa casa de 2 pisos con jardín interno, amplia terraza y finos acabados en zona residencial de Miraflores.', 
 'Av. Pardo 1234', 'A 3 cuadras del Malecón de la Reserva', -12.1190000, -77.0290000, 
 250.00, 200.00, 4, 4, 2, 2, 2023, 
 'USD', 450000.00, 0, 0, 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?fm=jpg&q=80&w=1200', 'ACTIVO', 1, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY)),

-- 2. San Isidro
(2, 1, 2, 2, 2, '11223344', 
 'Departamento Amoblado Flat con vista panorámica al Golf', 
 'Lujoso departamento completamente amoblado en el piso 8. Cuenta con vista espectacular al Golf de San Isidro, gimnasio y piscina.', 
 'Av. Javier Prado Oeste 789', 'Cerca al Country Club Lima Hotel', -12.0950000, -77.0350000, 
 110.00, 110.00, 2, 2, 1, 1, 2018, 
 'PEN', 3500.00, 0, 0, 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?fm=jpg&q=80&w=1200', 'ACTIVO', 0, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY)),

-- 3. Santiago de Surco
(3, 1, 2, 1, 3, '11445566', 
 'Departamento Proyecto Ecológico y Familiar Surco', 
 'Moderno departamento ideal para familias en Santiago de Surco. Áreas comunes ecológicas y pet friendly. Califica a Bono Mivivienda.', 
 'Jr. El Cortijo 456', 'Frente al Club Golf Los Inkas', -12.1150000, -76.9750000, 
 80.00, 80.00, 3, 2, 1, 1, 2024, 
 'PEN', 280000.00, 1, 1, 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?fm=jpg&q=80&w=1200', 'ACTIVO', 1, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY)),

-- 4. La Molina
(4, 3, 3, 1, 4, '22001100', 
 'Terreno Ideal para Proyecto Inmobiliario La Molina', 
 'Terreno plano de 500m2 en La Molina con habilitación urbana completa. Zonificación RDM. Excelente ubicación residencial.', 
 'Av. La Molina 890', 'A 2 cuadras de la USIL', -12.0880000, -76.9420000, 
 500.00, 0.00, 0, 0, 0, 0, NULL, 
 'USD', 320000.00, 0, 0, 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?fm=jpg&q=80&w=1200', 'ACTIVO', 0, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY)),

-- 5. San Borja
(5, 3, 1, 1, 6, '22112233', 
 'Elegante Casa de Estreno con Piscina y Jardín', 
 'Elegante casa de 3 pisos con piscina, amplio jardín en San Borja. Acabados de lujo en mármol y granito, zona residencial vigilada.', 
 'Av. San Borja Sur 567', 'Cerca al Pentagonito', -12.1060000, -76.9990000, 
 350.00, 280.00, 5, 5, 3, 3, 2019, 
 'USD', 780000.00, 0, 0, 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?fm=jpg&q=80&w=1200', 'ACTIVO', 1, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY)),

-- 6. Barranco
(6, 1, 2, 2, 7, '33001122', 
 'Departamento Bohemio y Acogedor en Barranco', 
 'Acogedor departamento con balcón y vista al mar en el distrito bohemio de Barranco. A pocas cuadras del Puente de los Suspiros.', 
 'Jr. Cajamarca 234', 'A una cuadra de la Bajada de Baños', -12.1480000, -77.0210000, 
 75.00, 75.00, 1, 1, 0, 1, 2015, 
 'PEN', 2800.00, 0, 0, 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?fm=jpg&q=80&w=1200', 'ACTIVO', 0, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY)),

-- 7. Jesús María
(7, 3, 2, 1, 8, '33112233', 
 'Departamento de Estreno con Excelentes Áreas Comunes', 
 'Departamento de estreno en Jesús María con ascensor inteligente. Cocina equipada con encimera de granito y áreas recreativas.', 
 'Av. Brasil 1567', 'Cerca al Campo de Marte', -12.0780000, -77.0490000, 
 90.00, 85.00, 3, 2, 1, 1, 2025, 
 'PEN', 350000.00, 1, 0, 'https://images.unsplash.com/photo-1560185007-cde436f6a4d0?fm=jpg&q=80&w=1200', 'ACTIVO', 0, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY)),

-- 8. Lima Cercado
(8, 1, 4, 2, 5, '44001122', 
 'Amplio Local Comercial en Zona de Alto Tránsito', 
 'Amplio local comercial en esquina con alto tránsito peatonal en pleno centro histórico de Lima. Ideal para oficinas o comercio.', 
 'Jr. de la Unión 800', 'A una cuadra de la Plaza Mayor de Lima', -12.0460000, -77.0310000, 
 120.00, 120.00, 0, 2, 0, 1, 1990, 
 'PEN', 8500.00, 0, 0, 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?fm=jpg&q=80&w=1200', 'ACTIVO', 0, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY)),

-- 9. Chorrillos
(9, 3, 1, 1, 13, '55001122', 
 'Casa de Playa con Hermosa Vista al Océano', 
 'Casa de playa renovada de 2 pisos en Chorrillos. Amplia terraza con vista al mar y cochera privada. Lista para mudarse.', 
 'Av. Defensores del Morro 456', 'Frente al Club Regatas Chorrillos', -12.1750000, -77.0190000, 
 180.00, 140.00, 3, 2, 2, 2, 2010, 
 'USD', 195000.00, 0, 0, 'https://images.unsplash.com/photo-1499793983690-e29da59ef1c2?fm=jpg&q=80&w=1200', 'ACTIVO', 0, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY)),

-- 10. San Miguel
(10, 1, 2, 1, 12, '55112233', 
 'Departamento en San Miguel con Club House', 
 'Departamento moderno en San Miguel con vista a parque. Club house completo con piscina temperada y zona de BBQ.', 
 'Av. La Marina 2345', 'Cerca a Plaza San Miguel', -12.0790000, -77.0850000, 
 70.00, 65.00, 2, 1, 1, 1, 2024, 
 'PEN', 245000.00, 1, 1, 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?fm=jpg&q=80&w=1200', 'ACTIVO', 1, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY)),

-- 11. San Isidro (Oficina)
(11, 3, 5, 2, 2, '66001122', 
 'Oficina Prime Corporativa en Centro Financiero', 
 'Exclusiva oficina corporativa en el corazón de San Isidro. Plantas libres de estreno con aire acondicionado central y disipadores sísmicos.', 
 'Av. Andrés Reyes 450', 'A media cuadra de la estación Canaval y Moreyra', -12.0940000, -77.0270000, 
 200.00, 200.00, 0, 4, 5, 1, 2021, 
 'USD', 3200.00, 0, 0, 'https://images.unsplash.com/photo-1497366216548-37526070297c?fm=jpg&q=80&w=1200', 'ACTIVO', 1, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY)),

-- 12. Lince
(12, 1, 2, 1, 9, '66112233', 
 'Moderno Departamento de Estreno Lince Límite San Isidro', 
 'Moderno departamento de estreno en excelente ubicación en Lince. Cerca a parques y centros comerciales, acabados de primera.', 
 'Jr. Sinchi Roca 2500', 'A espaldas del CC Risso', -12.0910000, -77.0370000, 
 78.00, 78.00, 2, 2, 1, 1, 2025, 
 'USD', 135000.00, 1, 1, 'https://images.unsplash.com/photo-1502005229762-fc1b2b812ca5?fm=jpg&q=80&w=1200', 'ACTIVO', 0, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY)),

-- 13. Pueblo Libre
(13, 3, 1, 1, 11, '77001122', 
 'Casa Colonial Remodelada Ideal para Vivienda u Oficina', 
 'Hermosa casa colonial restaurada y remodelada en Pueblo Libre. Ambientes de techos altos y patio central colonial, muy amplia.', 
 'Jr. Gamarra 320', 'A 2 cuadras del Museo Larco', -12.0770000, -77.0620000, 
 320.00, 250.00, 6, 3, 2, 2, 1980, 
 'PEN', 890000.00, 0, 0, 'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?fm=jpg&q=80&w=1200', 'ACTIVO', 0, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY)),

-- 14. Magdalena del Mar
(14, 1, 2, 1, 10, '77112233', 
 'Departamento Flat con Vista Impresionante al Mar', 
 'Moderno flat con balcón amplio y vista panorámica al mar en Magdalena. Áreas comunes de primer nivel, gimnasio y zona coworking.', 
 'Jr. Bolognesi 540', 'Frente al Malecón de Magdalena', -12.0930000, -77.0670000, 
 85.00, 85.00, 2, 2, 1, 1, 2023, 
 'USD', 160000.00, 0, 1, 'https://images.unsplash.com/photo-1515263487990-61b07816b324?fm=jpg&q=80&w=1200', 'ACTIVO', 1, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY)),

-- 15. Los Olivos (Proyecto)
(15, 3, 8, 1, 15, '88001122', 
 'Proyecto Residencial Las Palmeras de Los Olivos', 
 'Departamentos de estreno en pre-venta en Los Olivos. Edificio moderno de 8 pisos con ascensor, excelente ubicación residencial y segura.', 
 'Av. Las Palmeras 1200', 'A 3 cuadras de la Municipalidad de Los Olivos', -11.9770000, -77.0780000, 
 1200.00, 850.00, 3, 2, 1, 8, 2026, 
 'PEN', 235000.00, 1, 1, 'https://images.unsplash.com/photo-1570129477492-45c003edd2be?fm=jpg&q=80&w=1200', 'ACTIVO', 0, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY));

-- Bloque 2.9: Fotos Secundarias de la Galería (Proporcionales y con enlaces válidos distintos)
INSERT INTO propiedad_fotos (id_foto, id_propiedad, ruta_archivo, orden, es_principal) VALUES
-- Galería para Propiedad 1 (Casa Miraflores)
(1, 1, 'https://images.unsplash.com/photo-1513584684374-8bab748fbf90?fm=jpg&q=80&w=1200', 1, 0),
(2, 1, 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?fm=jpg&q=80&w=1200', 2, 0),
(3, 1, 'https://images.unsplash.com/photo-1484154218962-a197022b5858?fm=jpg&q=80&w=1200', 3, 0),
-- Galería para Propiedad 2 (Dpto San Isidro)
(4, 2, 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?fm=jpg&q=80&w=1200', 1, 0),
(5, 2, 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?fm=jpg&q=80&w=1200', 2, 0),
-- Galería para Propiedad 3 (Dpto Surco)
(6, 3, 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?fm=jpg&q=80&w=1200', 1, 0),
(7, 3, 'https://images.unsplash.com/photo-1484154218962-a197022b5858?fm=jpg&q=80&w=1200', 2, 0);

-- Bloque 2.10: Favoritos (Proporcional: El comprador Pedro guarda algunas de las nuevas propiedades)
INSERT INTO usuario_favorito (id_favorito, id_usuario, id_propiedad) VALUES
(1, 4, 1),   -- Pedro guarda Casa Miraflores
(2, 4, 3),   -- Pedro guarda Dpto Surco
(3, 4, 5),   -- Pedro guarda Casa San Borja
(4, 4, 10),  -- Pedro guarda Dpto San Miguel
(5, 4, 14);  -- Pedro guarda Dpto Magdalena

-- Bloque 2.11: Consultas de Clientes (Proporcional, 100% peruanos y coherentes)
INSERT INTO consultas (id_consulta, id_propiedad, id_usuario, nombre, email, telefono, mensaje, estado) VALUES
(1, 1, 4, 'Pedro Ramírez Castro', 'comprador@inmobix.pe', '955444333', 
 'Buenas tardes Carlos, estoy muy interesado en la casa de Miraflores. ¿Cuándo podría programar una visita guiada?', 'PENDIENTE'),
(2, 3, NULL, 'Juan Carlos Quispe', 'j.quispe@gmail.com', '988777666', 
 'Hola, quisiera saber si el departamento en Surco aplica para el Bono Verde y cuál es la cuota inicial mínima.', 'PENDIENTE'),
(3, 5, NULL, 'Sofía Alejandra Rojas', 'sofia.rojas@outlook.com', '944333222', 
 'Hola María, me interesa la casa en San Borja. ¿El precio en dólares es negociable? Quedo atenta.', 'LEIDA'),
(4, 11, NULL, 'Renzo Alva Merino', 'ralva@corporacionperu.com', '922111000', 
 'Estimada María, represento a una empresa comercial y buscamos alquilar la oficina en San Isidro. Quisiera saber si incluye las cocheras.', 'RESPONDIDA');

-- Bloque 2.12: Contactos de WhatsApp (Métricas simuladas proporcionales)
INSERT INTO contactos_whatsapp (id_contacto, id_propiedad, id_usuario, fecha) VALUES
(1, 1, 4, DATE_SUB(NOW(), INTERVAL 2 DAY)),
(2, 3, NULL, DATE_SUB(NOW(), INTERVAL 1 DAY)),
(3, 5, NULL, NOW()),
(4, 14, 4, NOW());

-- Bloque 2.13: Estadísticas Diarias de Visitas (Proporcionales)
INSERT INTO estadisticas_propiedad (id_estadistica, id_propiedad, fecha, num_vistas) VALUES
(1, 1, DATE_SUB(CURDATE(), INTERVAL 2 DAY), 15),
(2, 1, DATE_SUB(CURDATE(), INTERVAL 1 DAY), 22),
(3, 1, CURDATE(), 35),
(4, 3, DATE_SUB(CURDATE(), INTERVAL 1 DAY), 10),
(5, 3, CURDATE(), 18),
(6, 5, CURDATE(), 25),
(7, 11, CURDATE(), 8),
(8, 14, CURDATE(), 14);

-- Bloque 2.14: Auditoría de Eventos de Seguridad (Coherentes con los datos semilla)
INSERT INTO evento_auditoria (id_evento, id_usuario, entidad, id_entidad, accion, ip_origen, user_agent, detalle_json) VALUES
(1, 1, 'propiedad', 1, 'CREAR', '192.168.1.15', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '{"titulo": "Casa Miraflores", "precio": 450000.00}'),
(2, 3, 'propiedad', 5, 'CREAR', '192.168.1.28', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)', '{"titulo": "Casa San Borja", "precio": 780000.00}'),
(3, 2, 'usuario', 4, 'CREAR', '192.168.1.10', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '{"correo": "comprador@inmobix.pe", "rol": 2}'),
(4, 1, 'usuario', 1, 'LOGIN', '192.168.1.15', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '{"status": "success"}'),
(5, 3, 'usuario', 3, 'LOGIN', '192.168.1.28', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)', '{"status": "success"}');

