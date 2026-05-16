-- ============================================================
--  InmobiX - Portal Inmobiliario Perú
--  Base de Datos MySQL - Esquema Completo
--  Versión: 1.0
-- ============================================================

-- DROP DATABASE IF EXISTS inmobix_db;

-- CREATE DATABASE inmobix_db
--    CHARACTER SET utf8mb4
--    COLLATE utf8mb4_unicode_ci;

-- USE inmobix_db;

-- ============================================================
-- BLOQUE 1: GEOGRAFÍA PERUANA
-- ============================================================

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

-- Datos de Prueba Geográficos
INSERT INTO departamento (id_departamento, nombre, codigo_ubigeo) VALUES (1, 'Lima', '15');
INSERT INTO provincia (id_provincia, id_departamento, nombre, codigo_ubigeo) VALUES (1, 1, 'Lima', '1501');
INSERT INTO distrito (id_distrito, id_provincia, nombre, codigo_ubigeo) VALUES 
(1, 1, 'Miraflores', '150122'), (2, 1, 'San Isidro', '150131'), (3, 1, 'Santiago de Surco', '150140'),
(4, 1, 'La Molina', '150114'), (5, 1, 'Lima Cercado', '150101'), (6, 1, 'San Borja', '150130'),
(7, 1, 'Barranco', '150104'), (8, 1, 'Jesús María', '150113'), (9, 1, 'Lince', '150116'),
(10, 1, 'Magdalena del Mar', '150117'), (11, 1, 'Pueblo Libre', '150121'), (12, 1, 'San Miguel', '150136'),
(13, 1, 'Chorrillos', '150108'), (14, 1, 'Ate', '150103'), (15, 1, 'Los Olivos', '150115');


CREATE TABLE urbanizacion (
    id_urbanizacion   INT UNSIGNED     NOT NULL AUTO_INCREMENT,
    id_distrito       INT UNSIGNED     NOT NULL,
    nombre            VARCHAR(120)     NOT NULL,
    tipo              ENUM('URBANIZACION','ASENTAMIENTO_HUMANO',
                          'COOPERATIVA','PUEBLO_JOVEN','RESIDENCIAL','OTRO')
                      NOT NULL DEFAULT 'URBANIZACION',
    PRIMARY KEY (id_urbanizacion),
    CONSTRAINT fk_urb_dist FOREIGN KEY (id_distrito)
        REFERENCES distrito(id_distrito) ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- BLOQUE 2: USUARIOS Y ROLES (RF-01)
-- ============================================================

CREATE TABLE rol (
    id_rol            TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre            VARCHAR(40)      NOT NULL,
    descripcion       VARCHAR(200)     NULL,
    PRIMARY KEY (id_rol),
    UNIQUE KEY uq_rol_nombre (nombre)
) ENGINE=InnoDB COMMENT='Visitante, Comprador, Agente, Constructora, Administrador';

INSERT INTO rol (nombre, descripcion) VALUES
    ('VISITANTE',      'Acceso de solo lectura sin registro'),
    ('COMPRADOR',      'Usuario registrado que busca inmuebles'),
    ('AGENTE',         'Agente inmobiliario que publica propiedades'),
    ('CONSTRUCTORA',   'Empresa desarrolladora con acceso a proyectos en masa'),
    ('ADMINISTRADOR',  'Control total de la plataforma');

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
) ENGINE=InnoDB COMMENT='Tabla central de usuarios - Ley 29733';

-- Datos de Prueba: 1 Admin, 2 Agentes (Password para todos: 123456)
INSERT INTO usuario (id_usuario, id_rol, nombres, apellidos, correo, password_hash, telefono, activo, verificado) VALUES
(1, 3, 'Carlos', 'Mendoza López', 'agente@inmobix.com', '$2a$10$Gtq9fAQEJWhkZi0fZXnVH.90d09O/L1amhSzPar/OlQsCuAHk9IFO', '987654321', 1, 1),
(2, 5, 'Super', 'Administrador', 'admin@inmobix.pe', '$2a$10$Gtq9fAQEJWhkZi0fZXnVH.90d09O/L1amhSzPar/OlQsCuAHk9IFO', '999888777', 1, 1),
(3, 3, 'María', 'Torres Gutiérrez', 'maria.torres@inmobix.com', '$2a$10$Gtq9fAQEJWhkZi0fZXnVH.90d09O/L1amhSzPar/OlQsCuAHk9IFO', '912345678', 1, 1);


CREATE TABLE recuperacion_cuenta (
    id_recuperacion   BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    id_usuario        BIGINT UNSIGNED  NOT NULL,
    token             VARCHAR(100)     NOT NULL,
    expira_en         DATETIME         NOT NULL,
    usado             TINYINT(1)       NOT NULL DEFAULT 0,
    fecha_solicitud   DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_recuperacion),
    INDEX idx_rec_token (token),
    CONSTRAINT fk_rec_usr FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='Tokens para recuperación de contraseña (RF-01)';

CREATE TABLE consentimiento_datos (
    id_consentimiento BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    id_usuario        BIGINT UNSIGNED  NOT NULL,
    tipo              ENUM('TERMINOS','DATOS_PERSONALES','MARKETING') NOT NULL,
    aceptado          TINYINT(1)       NOT NULL DEFAULT 0,
    ip_registro       VARCHAR(45)      NULL,
    fecha             DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_consentimiento),
    CONSTRAINT fk_con_usr FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='Registro de consentimiento - Ley 29733 (RNF-02)';

-- ============================================================
-- BLOQUE 3: CATÁLOGOS DE PROPIEDADES
-- ============================================================

CREATE TABLE tipo_inmueble (
    id_tipo           TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre            VARCHAR(60)      NOT NULL COMMENT 'Casa, Departamento, Terreno, Local, Oficina…',
    PRIMARY KEY (id_tipo)
) ENGINE=InnoDB;

INSERT INTO tipo_inmueble (nombre) VALUES
    ('Casa'),('Departamento'),('Terreno'),('Local Comercial'),
    ('Oficina'),('Industrial'),('Cochera'),('Proyecto Multifamiliar');

CREATE TABLE operacion (
    id_operacion      TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre            VARCHAR(30)      NOT NULL COMMENT 'VENTA, ALQUILER, ANTICRESIS',
    PRIMARY KEY (id_operacion)
) ENGINE=InnoDB;

INSERT INTO operacion (nombre) VALUES ('VENTA'),('ALQUILER'),('ANTICRESIS');

-- ============================================================
-- BLOQUE 4: PROPIEDADES (RF-02)
-- ============================================================

CREATE TABLE propiedad (
    id_propiedad          BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,

    -- Relaciones
    id_usuario_agente     BIGINT UNSIGNED  NOT NULL COMMENT 'Agente o constructora propietaria',
    id_tipo_inmueble      TINYINT UNSIGNED NOT NULL,
    id_operacion          TINYINT UNSIGNED NOT NULL,
    id_urbanizacion       INT UNSIGNED     NULL,
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

    -- Datos Técnicos (RF-02)
    area_total_m2         DECIMAL(10,2)    NULL COMMENT 'Área total del terreno',
    area_techada_m2       DECIMAL(10,2)    NULL COMMENT 'Área techada/construida',
    num_dormitorios       TINYINT UNSIGNED NULL,
    num_banos             TINYINT UNSIGNED NULL,
    num_cocheras          TINYINT UNSIGNED NULL,
    num_pisos             TINYINT UNSIGNED NULL,
    anio_construccion     SMALLINT UNSIGNED NULL,

    -- Precio Bimonetario (RF-03, RNF-07)
    moneda_base           ENUM('PEN','USD') NOT NULL DEFAULT 'USD',
    precio                DECIMAL(14,2)    NOT NULL,

    -- Atributos Especiales (RF-02)
    bono_mi_vivienda      TINYINT(1)       NOT NULL DEFAULT 0,
    bono_verde            TINYINT(1)       NOT NULL DEFAULT 0,
    tour_360_url          VARCHAR(255)     NULL,

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
    CONSTRAINT fk_prop_urb      FOREIGN KEY (id_urbanizacion)
        REFERENCES urbanizacion(id_urbanizacion),
    CONSTRAINT fk_prop_dist     FOREIGN KEY (id_distrito)
        REFERENCES distrito(id_distrito)
) ENGINE=InnoDB COMMENT='Tabla principal de propiedades (RF-02)';

-- Datos de Prueba: 10 Propiedades de Catálogo (Sprint 1)
INSERT INTO propiedad (
    id_usuario_agente, id_tipo_inmueble, id_operacion, id_distrito, partida_sunarp, titulo, descripcion, direccion, 
    area_total_m2, area_techada_m2, num_dormitorios, num_banos, num_cocheras, anio_construccion, moneda_base, precio, bono_mi_vivienda, bono_verde, estado
) VALUES 
(1, 1, 1, 1, '11002233', 'Casa Moderna de Estreno cerca al Malecón', 'Hermosa casa de 2 pisos con jardín interno, amplia terraza y finos acabados en zona residencial tranquila, a 3 cuadras de los parques.', 'Av. Pardo 1234', 250.00, 200.00, 4, 4, 2, 2023, 'USD', 450000.00, 0, 0, 'ACTIVO'),
(1, 2, 2, 2, '11223344', 'Departamento Amoblado Flat con vista panorámica', 'Lujoso departamento completamente amoblado en el piso 8. Cuenta con vista espectacular a la ciudad, gimnasio, piscina y seguridad 24/7.', 'Av. Javier Prado Oeste 789', 110.00, 110.00, 2, 2, 1, 2018, 'PEN', 3500.00, 0, 0, 'ACTIVO'),
(1, 2, 1, 3, '11445566', 'Departamento Proyecto Ecológico y Familiar', 'Moderno departamento ideal para familias. Excelente iluminación natural, áreas comunes ecológicas y pet friendly. Califica a bonos del estado.', 'Jr. El Cortijo 456', 80.00, 80.00, 3, 2, 1, 2024, 'PEN', 280000.00, 1, 1, 'ACTIVO'),
(3, 3, 1, 4, '22001100', 'Terreno Ideal para Proyecto Inmobiliario', 'Terreno plano de 500m2 con habilitación urbana completa. Zonificación RDM. Excelente ubicación para proyecto multifamiliar.', 'Av. La Molina 890', 500.00, 0.00, 0, 0, 0, 0, 'USD', 320000.00, 0, 0, 'ACTIVO'),
(3, 1, 1, 6, '22112233', 'Casa Amplia con Piscina en San Borja', 'Elegante casa de 3 pisos con piscina, jardín, sala de cine y acabados de lujo. Ubicada en zona exclusiva con seguridad privada.', 'Av. San Borja Sur 567', 350.00, 280.00, 5, 5, 3, 2019, 'USD', 780000.00, 0, 0, 'ACTIVO'),
(1, 2, 2, 7, '33001122', 'Departamento Bohemio en Barranco', 'Acogedor departamento con balcón y vista al mar. A pocas cuadras del Puente de los Suspiros. Ideal para artistas y creativos.', 'Jr. Cajamarca 234', 75.00, 75.00, 1, 1, 0, 2015, 'PEN', 2800.00, 0, 0, 'ACTIVO'),
(3, 2, 1, 8, '33112233', 'Departamento Nuevo en Jesús María', 'Departamento de estreno en edificio con ascensor. Cocina equipada, closets empotrados y áreas comunes modernas.', 'Av. Brasil 1567', 90.00, 85.00, 3, 2, 1, 2025, 'PEN', 350000.00, 1, 0, 'ACTIVO'),
(1, 4, 2, 5, '44001122', 'Local Comercial en el Centro de Lima', 'Amplio local comercial en esquina con alto tránsito peatonal. Ideal para restaurante, tienda o academia. Con licencia de funcionamiento.', 'Jr. de la Unión 800', 120.00, 120.00, 0, 2, 0, 1990, 'PEN', 8500.00, 0, 0, 'ACTIVO'),
(3, 1, 1, 13, '55001122', 'Casa Económica cerca a la Playa', 'Casa de playa renovada con 3 dormitorios. Terraza con vista al mar, garaje para 2 autos. Perfecta para familia joven.', 'Av. Defensores del Morro 456', 180.00, 140.00, 3, 2, 2, 2010, 'USD', 195000.00, 0, 0, 'ACTIVO'),
(1, 2, 1, 12, '55112233', 'Departamento en San Miguel con Club House', 'Departamento con vista a parque interior, club house con gimnasio, piscina y zona BBQ. Excelente para inversión o vivienda.', 'Av. La Marina 2345', 70.00, 65.00, 2, 1, 1, 2024, 'PEN', 245000.00, 1, 1, 'ACTIVO');

CREATE TABLE propiedad_multimedia (
    id_multimedia     BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    id_propiedad      BIGINT UNSIGNED  NOT NULL,
    tipo              ENUM('FOTO','PLANO','VIDEO') NOT NULL DEFAULT 'FOTO',
    url               VARCHAR(255)     NOT NULL,
    formato           VARCHAR(10)      NULL COMMENT 'webp, jpg, mp4 (RNF-01)',
    orden             TINYINT UNSIGNED NOT NULL DEFAULT 0,
    es_portada        TINYINT(1)       NOT NULL DEFAULT 0,
    fecha_subida      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_multimedia),
    INDEX idx_mm_propiedad (id_propiedad),
    CONSTRAINT fk_mm_prop FOREIGN KEY (id_propiedad)
        REFERENCES propiedad(id_propiedad) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='Hasta 30 fotos por propiedad + tours 360° (RF-02)';

CREATE TABLE propiedad_caracteristica (
    id_caracteristica BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    id_propiedad      BIGINT UNSIGNED  NOT NULL,
    nombre            VARCHAR(80)      NOT NULL COMMENT 'Ej: Piscina, Gimnasio, Seguridad 24h',
    valor             VARCHAR(80)      NULL      COMMENT 'Ej: Incluido, Sí, 2 unidades',
    PRIMARY KEY (id_caracteristica),
    CONSTRAINT fk_carac_prop FOREIGN KEY (id_propiedad)
        REFERENCES propiedad(id_propiedad) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='Atributos adicionales / amenities';

-- ============================================================
-- BLOQUE 5: TIPO DE CAMBIO (RF-03, RNF-07)
-- ============================================================

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
) ENGINE=InnoDB COMMENT='Tipo de cambio diario SBS/SUNAT (RNF-07)';

-- Datos de Prueba: Tipo de Cambio del día para que la vista SQL no devuelva nulos
INSERT INTO tipo_cambio (par_moneda, compra, venta, fuente, fecha_vigencia) VALUES
('USD/PEN', 3.7500, 3.7800, 'SBS', CURDATE());

-- ============================================================
-- BLOQUE 6: BÚSQUEDA Y ALERTAS (RF-03)
-- ============================================================

CREATE TABLE busqueda_guardada (
    id_busqueda       BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    id_usuario        BIGINT UNSIGNED  NOT NULL,
    nombre            VARCHAR(100)     NULL COMMENT 'Alias dado por el usuario',
    filtros_json      JSON             NOT NULL  COMMENT 'Criterios: tipo, precio, distrito, etc.',
    alertas_activas   TINYINT(1)       NOT NULL DEFAULT 1,
    canal_alerta      SET('EMAIL','PUSH') NOT NULL DEFAULT 'EMAIL',
    fecha_creacion    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_busqueda),
    INDEX idx_bsq_usuario (id_usuario),
    CONSTRAINT fk_bsq_usr FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='Búsquedas guardadas y alertas (RF-03)';

-- ============================================================
-- BLOQUE 7: FAVORITOS Y COMPARADOR (RF-06)
-- ============================================================

CREATE TABLE lista_favoritos (
    id_lista          BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    id_usuario        BIGINT UNSIGNED  NOT NULL,
    nombre            VARCHAR(80)      NOT NULL DEFAULT 'Mis Favoritos',
    fecha_creacion    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_lista),
    CONSTRAINT fk_lista_usr FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='Listas personalizadas de favoritos (RF-06)';

CREATE TABLE favorito (
    id_favorito       BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    id_lista          BIGINT UNSIGNED  NOT NULL,
    id_propiedad      BIGINT UNSIGNED  NOT NULL,
    fecha_agregado    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_favorito),
    UNIQUE KEY uq_fav (id_lista, id_propiedad),
    CONSTRAINT fk_fav_lista FOREIGN KEY (id_lista)
        REFERENCES lista_favoritos(id_lista) ON DELETE CASCADE,
    CONSTRAINT fk_fav_prop  FOREIGN KEY (id_propiedad)
        REFERENCES propiedad(id_propiedad) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE sesion_comparador (
    id_sesion         BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    id_usuario        BIGINT UNSIGNED  NULL COMMENT 'NULL = sesión anónima',
    token_sesion      VARCHAR(100)     NULL,
    fecha_creacion    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_sesion)
) ENGINE=InnoDB COMMENT='Sesión del comparador (máx. 4 inmuebles, RF-06)';

CREATE TABLE comparador_item (
    id_item           BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    id_sesion         BIGINT UNSIGNED  NOT NULL,
    id_propiedad      BIGINT UNSIGNED  NOT NULL,
    orden             TINYINT UNSIGNED NOT NULL DEFAULT 1,
    PRIMARY KEY (id_item),
    UNIQUE KEY uq_comp (id_sesion, id_propiedad),
    CONSTRAINT chk_max_4 CHECK (orden BETWEEN 1 AND 4),
    CONSTRAINT fk_comp_sesion FOREIGN KEY (id_sesion)
        REFERENCES sesion_comparador(id_sesion) ON DELETE CASCADE,
    CONSTRAINT fk_comp_prop   FOREIGN KEY (id_propiedad)
        REFERENCES propiedad(id_propiedad) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='Hasta 4 inmuebles por sesión (RF-06)';

-- ============================================================
-- BLOQUE 8: CONTACTO Y LEAD MANAGEMENT (RF-05)
-- ============================================================

CREATE TABLE `lead` (
    id_lead           BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    id_propiedad      BIGINT UNSIGNED  NOT NULL,
    id_usuario        BIGINT UNSIGNED  NULL COMMENT 'NULL si es visitante anónimo',
    nombre_contacto   VARCHAR(120)     NOT NULL,
    correo_contacto   VARCHAR(120)     NOT NULL,
    telefono_contacto VARCHAR(15)      NULL,
    canal             ENUM('FORMULARIO','WHATSAPP','LLAMADA','SMS') NOT NULL,
    mensaje           TEXT             NULL,
    estado            ENUM('NUEVO','CONTACTADO','NEGOCIACION','CERRADO','DESCARTADO')
                      NOT NULL DEFAULT 'NUEVO',
    fecha_creacion    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME       NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id_lead),
    INDEX idx_lead_prop (id_propiedad),
    INDEX idx_lead_estado (estado),
    CONSTRAINT fk_lead_prop FOREIGN KEY (id_propiedad)
        REFERENCES propiedad(id_propiedad) ON DELETE CASCADE,
    CONSTRAINT fk_lead_usr  FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='Gestión de leads (RF-05)';

CREATE TABLE visita_agendada (
    id_visita         BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    id_lead           BIGINT UNSIGNED  NOT NULL,
    id_agente         BIGINT UNSIGNED  NOT NULL,
    fecha_visita      DATETIME         NOT NULL,
    duracion_min      SMALLINT UNSIGNED NOT NULL DEFAULT 60,
    modalidad         ENUM('PRESENCIAL','VIRTUAL') NOT NULL DEFAULT 'PRESENCIAL',
    estado            ENUM('PENDIENTE','CONFIRMADA','REALIZADA','CANCELADA')
                      NOT NULL DEFAULT 'PENDIENTE',
    notas             TEXT             NULL,
    recordatorio_sms  TINYINT(1)       NOT NULL DEFAULT 1,
    fecha_creacion    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_visita),
    INDEX idx_vis_agente (id_agente),
    INDEX idx_vis_fecha  (fecha_visita),
    CONSTRAINT fk_vis_lead   FOREIGN KEY (id_lead)
        REFERENCES `lead`(id_lead) ON DELETE CASCADE,
    CONSTRAINT fk_vis_agente FOREIGN KEY (id_agente)
        REFERENCES usuario(id_usuario)
) ENGINE=InnoDB COMMENT='Calendario de visitas con recordatorio SMS (RF-05)';

-- ============================================================
-- BLOQUE 9: PLANES Y PAGOS (RF-07)
-- ============================================================

CREATE TABLE plan (
    id_plan           TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre            VARCHAR(40)      NOT NULL COMMENT 'GRATIS, DESTACADO, PREMIUM',
    precio_pen        DECIMAL(10,2)    NOT NULL DEFAULT 0.00,
    duracion_dias     SMALLINT UNSIGNED NOT NULL DEFAULT 30,
    max_propiedades   SMALLINT UNSIGNED NOT NULL DEFAULT 1,
    max_fotos         TINYINT UNSIGNED NOT NULL DEFAULT 10,
    destacada         TINYINT(1)       NOT NULL DEFAULT 0,
    analytics         TINYINT(1)       NOT NULL DEFAULT 0,
    descripcion       TEXT             NULL,
    activo            TINYINT(1)       NOT NULL DEFAULT 1,
    PRIMARY KEY (id_plan)
) ENGINE=InnoDB COMMENT='Planes de suscripción (RF-07)';

INSERT INTO plan (nombre, precio_pen, duracion_dias, max_propiedades, max_fotos, destacada, analytics) VALUES
    ('GRATIS',    0.00, 30,  1,  5, 0, 0),
    ('DESTACADO', 99.00, 30, 5, 20, 1, 0),
    ('PREMIUM',  299.00, 30, 20, 30, 1, 1);

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
    metodo            ENUM('TARJETA','YAPE','PLIN','PAGO_EFECTIVO','TRANSFERENCIA')
                      NOT NULL,
    pasarela          ENUM('CULQI','NIUBIZ','IZIPAY','OTRO') NOT NULL,
    referencia_externa VARCHAR(100)    NULL COMMENT 'ID de transacción en la pasarela',
    estado            ENUM('PENDIENTE','APROBADO','RECHAZADO','REEMBOLSADO')
                      NOT NULL DEFAULT 'PENDIENTE',
    fecha_pago        DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_pago),
    INDEX idx_pago_sus (id_suscripcion),
    CONSTRAINT fk_pago_sus FOREIGN KEY (id_suscripcion)
        REFERENCES suscripcion(id_suscripcion)
) ENGINE=InnoDB COMMENT='Pagos: Culqi, Niubiz, Izipay, Yape, Plin (RF-07)';

CREATE TABLE comprobante_electronico (
    id_comprobante    BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    id_pago           BIGINT UNSIGNED  NOT NULL,
    tipo              ENUM('BOLETA','FACTURA') NOT NULL,
    serie             VARCHAR(4)       NOT NULL COMMENT 'Ej: B001 / F001',
    numero            INT UNSIGNED     NOT NULL,
    ruc_emisor        CHAR(11)         NOT NULL,
    ruc_receptor      CHAR(11)         NULL COMMENT 'Solo en Factura',
    razon_social_rec  VARCHAR(200)     NULL,
    monto_base        DECIMAL(10,2)    NOT NULL COMMENT 'Sin IGV',
    igv               DECIMAL(10,2)    NOT NULL,
    monto_total       DECIMAL(10,2)    NOT NULL,
    xml_cpe_url       VARCHAR(255)     NULL COMMENT 'XML firmado enviado a OSE/PSE (RF-07)',
    cdr_url           VARCHAR(255)     NULL COMMENT 'CDR de aceptación SUNAT',
    estado_sunat      ENUM('PENDIENTE','ACEPTADO','RECHAZADO') NOT NULL DEFAULT 'PENDIENTE',
    fecha_emision     DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_comprobante),
    UNIQUE KEY uq_cpe (serie, numero),
    CONSTRAINT fk_cpe_pago FOREIGN KEY (id_pago)
        REFERENCES pago(id_pago)
) ENGINE=InnoDB COMMENT='Boletas y Facturas Electrónicas CPE - SUNAT (RF-07)';

-- ============================================================
-- BLOQUE 10: ANALYTICS Y MÉTRICAS (RF-08)
-- ============================================================

CREATE TABLE metrica_propiedad (
    id_metrica        BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    id_propiedad      BIGINT UNSIGNED  NOT NULL,
    fecha             DATE             NOT NULL,
    impresiones       INT UNSIGNED     NOT NULL DEFAULT 0,
    clics_ver_telefono INT UNSIGNED    NOT NULL DEFAULT 0,
    clics_whatsapp    INT UNSIGNED     NOT NULL DEFAULT 0,
    leads_generados   INT UNSIGNED     NOT NULL DEFAULT 0,
    visitas_ficha     INT UNSIGNED     NOT NULL DEFAULT 0,
    PRIMARY KEY (id_metrica),
    UNIQUE KEY uq_met_prop_fecha (id_propiedad, fecha),
    CONSTRAINT fk_met_prop FOREIGN KEY (id_propiedad)
        REFERENCES propiedad(id_propiedad) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='Métricas diarias por propiedad (RF-08)';

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
    INDEX idx_audit_fecha   (fecha_evento)
) ENGINE=InnoDB COMMENT='Log de auditoría (RNF-02 - OWASP)';

-- ============================================================
-- BLOQUE 11: VISTAS ÚTILES
-- ============================================================

-- Vista: Propiedades activas con precio en ambas monedas
CREATE OR REPLACE VIEW v_propiedades_bimonetarias AS
SELECT
    p.id_propiedad,
    p.titulo,
    p.estado,
    p.moneda_base,
    p.precio                                                AS precio_base,
    CASE
        WHEN p.moneda_base = 'USD'
            THEN ROUND(p.precio * tc.venta, 2)
        ELSE p.precio
    END                                                     AS precio_pen,
    CASE
        WHEN p.moneda_base = 'PEN'
            THEN ROUND(p.precio / tc.venta, 2)
        ELSE p.precio
    END                                                     AS precio_usd,
    tc.venta                                                AS tipo_cambio_venta,
    tc.fecha_vigencia                                       AS tc_fecha,
    ti.nombre                                               AS tipo_inmueble,
    op.nombre                                               AS operacion,
    d.nombre                                                AS distrito,
    pr.nombre                                               AS provincia,
    dep.nombre                                              AS departamento,
    p.area_techada_m2,
    p.num_dormitorios,
    p.num_banos,
    p.bono_mi_vivienda,
    p.bono_verde
FROM propiedad p
JOIN tipo_inmueble  ti  ON ti.id_tipo       = p.id_tipo_inmueble
JOIN operacion      op  ON op.id_operacion  = p.id_operacion
JOIN distrito       d   ON d.id_distrito    = p.id_distrito
JOIN provincia      pr  ON pr.id_provincia  = d.id_provincia
JOIN departamento   dep ON dep.id_departamento = pr.id_departamento
LEFT JOIN (
    SELECT *
    FROM tipo_cambio
    WHERE par_moneda = 'USD/PEN'
      AND fecha_vigencia = (SELECT MAX(fecha_vigencia) FROM tipo_cambio WHERE par_moneda = 'USD/PEN')
) tc ON 1=1
WHERE p.estado = 'ACTIVO';

-- Vista: Dashboard del agente (RF-08)
CREATE OR REPLACE VIEW v_dashboard_agente AS
SELECT
    u.id_usuario,
    CONCAT(u.nombres, ' ', u.apellidos)                     AS agente,
    COUNT(DISTINCT p.id_propiedad)                          AS total_propiedades,
    SUM(mp.impresiones)                                     AS total_impresiones,
    SUM(mp.clics_whatsapp)                                  AS total_leads_whatsapp,
    SUM(mp.clics_ver_telefono)                              AS total_clics_telefono,
    SUM(mp.leads_generados)                                 AS total_leads,
    ROUND(
        CASE WHEN SUM(mp.impresiones) > 0
             THEN (SUM(mp.leads_generados) / SUM(mp.impresiones)) * 100
             ELSE 0
        END, 2
    )                                                       AS tasa_conversion_pct,
    MAX(mp.fecha)                                           AS ultima_actualizacion
FROM usuario u
JOIN propiedad p       ON p.id_usuario_agente = u.id_usuario
LEFT JOIN metrica_propiedad mp ON mp.id_propiedad = p.id_propiedad
WHERE u.id_rol IN (
    SELECT id_rol FROM rol WHERE nombre IN ('AGENTE','CONSTRUCTORA')
)
GROUP BY u.id_usuario, agente;

-- ============================================================
-- SPRINT 2: MULTIMEDIA Y BÚSQUEDA AVANZADA
-- ============================================================

-- Columna foto principal en propiedad
ALTER TABLE propiedad ADD COLUMN foto_principal VARCHAR(255) NULL COMMENT 'Ruta relativa a la foto principal' AFTER tour_360_url;

-- Contador de visualizaciones
ALTER TABLE propiedad ADD COLUMN numero_vistas INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Contador de vistas en detalle' AFTER foto_principal;

-- Tabla simplificada de favoritos (usuario ↔ propiedad)
CREATE TABLE IF NOT EXISTS usuario_favorito (
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
) ENGINE=InnoDB COMMENT='Favoritos del usuario (Sprint 2)';

-- ============================================================
-- SPRINT 3: FUNCIONALIDADES AVANZADAS
-- ============================================================

-- Galería de imágenes (hasta 5 fotos por propiedad)
CREATE TABLE IF NOT EXISTS propiedad_fotos (
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
) ENGINE=InnoDB COMMENT='Galería hasta 5 fotos por propiedad (Sprint 3)';

-- Consultas de contacto (sistema real, no simulado)
CREATE TABLE IF NOT EXISTS consultas (
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
) ENGINE=InnoDB COMMENT='Consultas de contacto por propiedad (Sprint 3)';

-- Contactos WhatsApp (registro real en BD)
CREATE TABLE IF NOT EXISTS contactos_whatsapp (
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
) ENGINE=InnoDB COMMENT='Registro de contactos WhatsApp (Sprint 3)';

-- Estadísticas diarias de propiedad (para gráfico Chart.js)
CREATE TABLE IF NOT EXISTS estadisticas_propiedad (
    id_estadistica    BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    id_propiedad      BIGINT UNSIGNED  NOT NULL,
    fecha             DATE             NOT NULL,
    num_vistas        INT UNSIGNED     NOT NULL DEFAULT 0,
    PRIMARY KEY (id_estadistica),
    UNIQUE KEY uq_est_prop_fecha (id_propiedad, fecha),
    CONSTRAINT fk_est_prop FOREIGN KEY (id_propiedad)
        REFERENCES propiedad(id_propiedad) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='Vistas diarias para analytics (Sprint 3)';

-- Actualizar planes según Sprint 3
UPDATE plan SET nombre='GRATUITO', precio_pen=0.00, max_propiedades=1, descripcion='1 propiedad activa. Publicación básica.' WHERE id_plan=1;
UPDATE plan SET nombre='BASICO', precio_pen=50.00, max_propiedades=5, descripcion='5 propiedades activas. Visibilidad estándar.' WHERE id_plan=2;
UPDATE plan SET nombre='PREMIUM', precio_pen=150.00, max_propiedades=20, destacada=1, analytics=1, descripcion='20 propiedades destacadas. Analytics y prioridad.' WHERE id_plan=3;

-- ============================================================
-- FIN DEL SCRIPT
-- ============================================================