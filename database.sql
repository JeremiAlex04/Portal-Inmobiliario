-- ============================================================
--  InmobiX · Portal Inmobiliario Peruano
--  Base de Datos MySQL — Esquema Completo v1.0
--  Generado para integración con Java Jakarta EE (JDBC)
-- ============================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE DATABASE IF NOT EXISTS inmobix
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE inmobix;


-- ============================================================
--  BLOQUE 1 · GEOGRAFÍA PERUANA (Ubigeo INEI)
-- ============================================================

CREATE TABLE departamentos (
    id_departamento   CHAR(2)      NOT NULL,
    nombre            VARCHAR(80)  NOT NULL,
    PRIMARY KEY (id_departamento)
) ENGINE=InnoDB COMMENT='Departamentos del Perú (código INEI 2 dígitos)';

CREATE TABLE provincias (
    id_provincia      CHAR(4)      NOT NULL,   -- ej. '1501'
    id_departamento   CHAR(2)      NOT NULL,
    nombre            VARCHAR(80)  NOT NULL,
    PRIMARY KEY (id_provincia),
    CONSTRAINT fk_prov_dep FOREIGN KEY (id_departamento)
        REFERENCES departamentos(id_departamento)
) ENGINE=InnoDB COMMENT='Provincias del Perú (código INEI 4 dígitos)';

CREATE TABLE distritos (
    id_distrito       CHAR(6)      NOT NULL,   -- ej. '150101'
    id_provincia      CHAR(4)      NOT NULL,
    nombre            VARCHAR(100) NOT NULL,
    lat               DECIMAL(10,7),
    lng               DECIMAL(10,7),
    PRIMARY KEY (id_distrito),
    CONSTRAINT fk_dist_prov FOREIGN KEY (id_provincia)
        REFERENCES provincias(id_provincia)
) ENGINE=InnoDB COMMENT='Distritos del Perú con coordenadas para mapas';

CREATE TABLE urbanizaciones (
    id_urbanizacion   INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_distrito       CHAR(6)      NOT NULL,
    nombre            VARCHAR(150) NOT NULL,
    tipo              ENUM('URBANIZACION','ASENTAMIENTO_HUMANO','COOPERATIVA',
                           'ASOCIACION','RESIDENCIAL','OTRO') NOT NULL DEFAULT 'URBANIZACION',
    CONSTRAINT fk_urb_dist FOREIGN KEY (id_distrito)
        REFERENCES distritos(id_distrito)
) ENGINE=InnoDB COMMENT='Urbanizaciones y asentamientos humanos por distrito';


-- ============================================================
--  BLOQUE 2 · USUARIOS, ROLES Y AUTENTICACIÓN (RF-01)
-- ============================================================

CREATE TABLE roles (
    id_rol    TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre    VARCHAR(50)  NOT NULL UNIQUE,   -- VISITANTE, COMPRADOR, AGENTE, CONSTRUCTORA, ADMIN
    descripcion VARCHAR(200)
) ENGINE=InnoDB;

INSERT INTO roles (nombre, descripcion) VALUES
  ('VISITANTE',     'Usuario no autenticado, puede explorar el portal'),
  ('COMPRADOR',     'Usuario registrado que busca o alquila inmuebles'),
  ('AGENTE',        'Agente inmobiliario que publica propiedades'),
  ('CONSTRUCTORA',  'Empresa desarrolladora que publica proyectos'),
  ('ADMIN',         'Administrador con acceso total al sistema');

CREATE TABLE usuarios (
    id_usuario        BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_rol            TINYINT UNSIGNED NOT NULL DEFAULT 2,   -- COMPRADOR por defecto
    nombres           VARCHAR(100) NOT NULL,
    apellidos         VARCHAR(100) NOT NULL,
    email             VARCHAR(150) NOT NULL UNIQUE,
    password_hash     VARCHAR(255),                          -- Bcrypt; NULL si sólo usa OAuth
    telefono          VARCHAR(20),
    telefono_whatsapp VARCHAR(20),                           -- Puede diferir del telefono principal
    avatar_url        VARCHAR(500),
    estado            ENUM('PENDIENTE','ACTIVO','SUSPENDIDO','ELIMINADO') NOT NULL DEFAULT 'PENDIENTE',
    email_verificado  TINYINT(1) NOT NULL DEFAULT 0,
    -- Cumplimiento Ley N° 29733 —————
    acepta_terminos       TINYINT(1) NOT NULL DEFAULT 0,
    fecha_acepta_terminos DATETIME,
    acepta_marketing      TINYINT(1) NOT NULL DEFAULT 0,
    ip_registro           VARCHAR(45),                       -- IPv4/IPv6
    -- ——————————————————————————————
    created_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at        DATETIME,                              -- Soft delete
    CONSTRAINT fk_usr_rol FOREIGN KEY (id_rol)
        REFERENCES roles(id_rol)
) ENGINE=InnoDB COMMENT='Tabla maestra de usuarios del portal';

CREATE INDEX idx_usuarios_email   ON usuarios(email);
CREATE INDEX idx_usuarios_estado  ON usuarios(estado);

-- Cuentas OAuth vinculadas (Google, Facebook, Apple)
CREATE TABLE oauth_cuentas (
    id_oauth      BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_usuario    BIGINT UNSIGNED NOT NULL,
    proveedor     ENUM('GOOGLE','FACEBOOK','APPLE') NOT NULL,
    proveedor_uid VARCHAR(255) NOT NULL,                     -- Sub/ID del proveedor
    access_token  TEXT,
    refresh_token TEXT,
    token_expira  DATETIME,
    created_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_oauth (proveedor, proveedor_uid),
    CONSTRAINT fk_oauth_usr FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Tokens de verificación de correo y recuperación de cuenta
CREATE TABLE tokens_usuario (
    id_token      BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_usuario    BIGINT UNSIGNED NOT NULL,
    tipo          ENUM('VERIFICACION_EMAIL','RECUPERACION_CLAVE','INVITACION') NOT NULL,
    token         VARCHAR(128) NOT NULL UNIQUE,
    usado         TINYINT(1) NOT NULL DEFAULT 0,
    expira_at     DATETIME NOT NULL,
    created_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_tok_usr FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Perfil extendido · Agentes (RF-01, código PN/PJ del MVCS)
CREATE TABLE agentes_perfil (
    id_usuario          BIGINT UNSIGNED PRIMARY KEY,
    razon_social        VARCHAR(150),
    codigo_mvcs         VARCHAR(30),                  -- Código PN o PJ del MVCS (opcional)
    tipo_agente         ENUM('PERSONA_NATURAL','PERSONA_JURIDICA') NOT NULL DEFAULT 'PERSONA_NATURAL',
    ruc                 VARCHAR(11),
    dni                 VARCHAR(8),
    descripcion_bio     TEXT,
    zona_cobertura      TEXT,                         -- Descripción libre de zonas
    verificado_mvcs     TINYINT(1) NOT NULL DEFAULT 0,
    fecha_verificacion  DATETIME,
    CONSTRAINT fk_agperfil_usr FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Perfil extendido · Constructoras/Desarrolladoras
CREATE TABLE constructoras_perfil (
    id_usuario          BIGINT UNSIGNED PRIMARY KEY,
    razon_social        VARCHAR(200) NOT NULL,
    ruc                 VARCHAR(11) NOT NULL,
    logo_url            VARCHAR(500),
    website             VARCHAR(300),
    descripcion         TEXT,
    anio_fundacion      YEAR,
    CONSTRAINT fk_conperfil_usr FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Consentimientos de datos (Ley 29733 — Banco de Datos Personales)
CREATE TABLE consentimientos_datos (
    id_consentimiento BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_usuario        BIGINT UNSIGNED NOT NULL,
    tipo              VARCHAR(100) NOT NULL,         -- ej. 'MARKETING', 'TERCEROS', 'PERFILAMIENTO'
    aceptado          TINYINT(1) NOT NULL,
    version_politica  VARCHAR(20) NOT NULL,          -- ej. '2024-01'
    ip_origen         VARCHAR(45),
    user_agent        VARCHAR(500),
    created_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_consen_usr FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='Registro de consentimientos para cumplimiento Ley N° 29733';


-- ============================================================
--  BLOQUE 3 · CATÁLOGOS DE PROPIEDADES
-- ============================================================

CREATE TABLE tipos_inmueble (
    id_tipo   SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre    VARCHAR(80)  NOT NULL,    -- Casa, Departamento, Terreno, Oficina, Local Comercial…
    slug      VARCHAR(80)  NOT NULL UNIQUE
) ENGINE=InnoDB;

INSERT INTO tipos_inmueble (nombre, slug) VALUES
  ('Casa','casa'), ('Departamento','departamento'), ('Terreno','terreno'),
  ('Oficina','oficina'), ('Local Comercial','local-comercial'),
  ('Almacén','almacen'), ('Casa de Playa','casa-de-playa'),
  ('Proyecto / Edificio','proyecto-edificio');

CREATE TABLE amenidades_catalogo (
    id_amenidad SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    categoria   VARCHAR(60)  NOT NULL,   -- 'Seguridad', 'Recreación', 'Servicios', etc.
    nombre      VARCHAR(100) NOT NULL,
    icono_slug  VARCHAR(60)
) ENGINE=InnoDB COMMENT='Catálogo maestro de amenidades/atributos de un inmueble';

INSERT INTO amenidades_catalogo (categoria, nombre) VALUES
  ('Seguridad','Vigilancia 24h'), ('Seguridad','Cámara CCTV'),
  ('Seguridad','Portón Eléctrico'), ('Recreación','Piscina'),
  ('Recreación','Gimnasio'), ('Recreación','Área de Juegos'),
  ('Recreación','Parque Privado'), ('Servicios','Ascensor'),
  ('Servicios','Sala de Reuniones'), ('Servicios','Recepción'),
  ('Servicios','Generador Eléctrico'), ('Sostenibilidad','Paneles Solares'),
  ('Sostenibilidad','Sistema de Reciclaje'), ('Financiero','Bono MiVivienda'),
  ('Financiero','Bono Verde'), ('Financiero','Techo Propio');


-- ============================================================
--  BLOQUE 4 · PROPIEDADES / FICHAS (RF-02)
-- ============================================================

CREATE TABLE propiedades (
    id_propiedad      BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_usuario        BIGINT UNSIGNED NOT NULL,          -- Agente o constructora propietaria
    id_tipo_inmueble  SMALLINT UNSIGNED NOT NULL,
    -- Identificación legal ——————————————————
    partida_registral VARCHAR(30),                       -- SUNARP
    -- Operación ——————————————————————————————
    operacion         ENUM('VENTA','ALQUILER','VENTA_ALQUILER') NOT NULL DEFAULT 'VENTA',
    -- Precios bimonetarios (RF-03, RNF-07) ——
    precio_soles      DECIMAL(14,2),
    precio_dolares    DECIMAL(14,2),
    moneda_principal  ENUM('PEN','USD') NOT NULL DEFAULT 'USD',
    precio_por_m2_soles   DECIMAL(10,2),                -- Calculado/guardado para filtros
    precio_por_m2_dolares DECIMAL(10,2),
    -- Superficies ——————————————————————————
    area_total        DECIMAL(10,2),                     -- m²
    area_techada      DECIMAL(10,2),                     -- m² construido
    -- Descripción física ——————————————————
    dormitorios       TINYINT UNSIGNED,
    banos             TINYINT UNSIGNED,
    medios_banos      TINYINT UNSIGNED DEFAULT 0,
    cocheras          TINYINT UNSIGNED DEFAULT 0,
    pisos             TINYINT UNSIGNED DEFAULT 1,
    antiguedad_anios  SMALLINT UNSIGNED,                 -- 0 = en planos / estreno
    -- Ubicación —————————————————————————————
    id_distrito       CHAR(6)      NOT NULL,
    id_urbanizacion   INT UNSIGNED,
    direccion         VARCHAR(300),                      -- Calle y número (puede ser privado)
    referencia        VARCHAR(300),                      -- "Frente al parque..."
    lat               DECIMAL(10,7),                     -- Para Google Maps (RF-04)
    lng               DECIMAL(10,7),
    -- Atributos especiales Perú ——————————
    bono_mivivienda   TINYINT(1) NOT NULL DEFAULT 0,
    bono_verde        TINYINT(1) NOT NULL DEFAULT 0,
    techo_propio      TINYINT(1) NOT NULL DEFAULT 0,
    -- Publicación ——————————————————————————
    titulo            VARCHAR(200) NOT NULL,
    descripcion       TEXT,
    estado            ENUM('BORRADOR','ACTIVO','PAUSADO','VENDIDO','ALQUILADO',
                           'ELIMINADO') NOT NULL DEFAULT 'BORRADOR',
    destacada         TINYINT(1) NOT NULL DEFAULT 0,     -- Plan comercial destacado
    premium           TINYINT(1) NOT NULL DEFAULT 0,     -- Plan premium
    slug              VARCHAR(250) UNIQUE,               -- URL amigable
    fecha_publicacion DATETIME,
    fecha_expiracion  DATETIME,
    created_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at        DATETIME,
    CONSTRAINT fk_prop_usr  FOREIGN KEY (id_usuario)        REFERENCES usuarios(id_usuario),
    CONSTRAINT fk_prop_tipo FOREIGN KEY (id_tipo_inmueble)  REFERENCES tipos_inmueble(id_tipo),
    CONSTRAINT fk_prop_dist FOREIGN KEY (id_distrito)       REFERENCES distritos(id_distrito),
    CONSTRAINT fk_prop_urb  FOREIGN KEY (id_urbanizacion)   REFERENCES urbanizaciones(id_urbanizacion)
) ENGINE=InnoDB COMMENT='Ficha maestra de cada propiedad publicada en el portal';

CREATE INDEX idx_prop_estado      ON propiedades(estado);
CREATE INDEX idx_prop_distrito    ON propiedades(id_distrito);
CREATE INDEX idx_prop_operacion   ON propiedades(operacion);
CREATE INDEX idx_prop_tipo        ON propiedades(id_tipo_inmueble);
CREATE INDEX idx_prop_precio_sol  ON propiedades(precio_soles);
CREATE INDEX idx_prop_precio_dol  ON propiedades(precio_dolares);
CREATE INDEX idx_prop_coords      ON propiedades(lat, lng);

-- Imágenes de la propiedad (hasta 30 fotos — RF-02)
CREATE TABLE propiedades_imagenes (
    id_imagen       BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_propiedad    BIGINT UNSIGNED NOT NULL,
    url_original    VARCHAR(500) NOT NULL,
    url_webp        VARCHAR(500),                        -- Versión optimizada WebP (RNF-01)
    url_thumbnail   VARCHAR(500),
    orden           TINYINT UNSIGNED NOT NULL DEFAULT 0,
    es_portada      TINYINT(1) NOT NULL DEFAULT 0,
    alt_texto       VARCHAR(200),
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_img_prop FOREIGN KEY (id_propiedad)
        REFERENCES propiedades(id_propiedad) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Multimedia: videos YouTube/Vimeo y Tours 360° (RF-02)
CREATE TABLE propiedades_multimedia (
    id_multimedia   INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_propiedad    BIGINT UNSIGNED NOT NULL,
    tipo            ENUM('YOUTUBE','VIMEO','TOUR_360','PLANO') NOT NULL,
    url             VARCHAR(500) NOT NULL,
    titulo          VARCHAR(150),
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_media_prop FOREIGN KEY (id_propiedad)
        REFERENCES propiedades(id_propiedad) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Amenidades asociadas a cada propiedad
CREATE TABLE propiedades_amenidades (
    id_propiedad  BIGINT UNSIGNED NOT NULL,
    id_amenidad   SMALLINT UNSIGNED NOT NULL,
    PRIMARY KEY (id_propiedad, id_amenidad),
    CONSTRAINT fk_pam_prop FOREIGN KEY (id_propiedad) REFERENCES propiedades(id_propiedad) ON DELETE CASCADE,
    CONSTRAINT fk_pam_ame  FOREIGN KEY (id_amenidad)  REFERENCES amenidades_catalogo(id_amenidad)
) ENGINE=InnoDB;


-- ============================================================
--  BLOQUE 5 · TIPO DE CAMBIO BIMONETARIO (RNF-07)
-- ============================================================

CREATE TABLE tipo_cambio (
    id_tc         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    fecha         DATE        NOT NULL UNIQUE,
    compra        DECIMAL(8,4) NOT NULL,   -- PEN/USD compra (SBS)
    venta         DECIMAL(8,4) NOT NULL,   -- PEN/USD venta (SBS)
    fuente        ENUM('SBS','SUNAT','MANUAL') NOT NULL DEFAULT 'SBS',
    created_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB COMMENT='Tipo de cambio diario consultado de SBS/SUNAT (RF-03, RNF-07)';


-- ============================================================
--  BLOQUE 6 · BÚSQUEDAS GUARDADAS Y ALERTAS (RF-03)
-- ============================================================

CREATE TABLE busquedas_guardadas (
    id_busqueda       BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_usuario        BIGINT UNSIGNED NOT NULL,
    nombre            VARCHAR(150),                     -- Nombre descriptivo que pone el usuario
    -- Parámetros de búsqueda (almacenados como JSON para flexibilidad)
    filtros_json      JSON NOT NULL,
    -- Alertas ——————————————————————————
    alerta_activa     TINYINT(1) NOT NULL DEFAULT 1,
    canal_alerta      ENUM('EMAIL','PUSH','AMBOS') NOT NULL DEFAULT 'EMAIL',
    frecuencia        ENUM('INMEDIATO','DIARIO','SEMANAL') NOT NULL DEFAULT 'DIARIO',
    ultima_alerta_at  DATETIME,
    created_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_bsq_usr FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE alertas_notificaciones (
    id_alerta         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_usuario        BIGINT UNSIGNED NOT NULL,
    id_busqueda       BIGINT UNSIGNED,                  -- NULL si es una alerta de sistema
    id_propiedad      BIGINT UNSIGNED,
    tipo              ENUM('NUEVA_PROPIEDAD','CAMBIO_PRECIO','VISITA_CONFIRMADA',
                           'LEAD_RECIBIDO','SISTEMA') NOT NULL,
    titulo            VARCHAR(200) NOT NULL,
    mensaje           TEXT,
    leida             TINYINT(1) NOT NULL DEFAULT 0,
    canal             ENUM('EMAIL','PUSH','SMS') NOT NULL DEFAULT 'EMAIL',
    enviada_at        DATETIME,
    created_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_alerta_usr  FOREIGN KEY (id_usuario)   REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
    CONSTRAINT fk_alerta_bsq  FOREIGN KEY (id_busqueda)  REFERENCES busquedas_guardadas(id_busqueda) ON DELETE SET NULL,
    CONSTRAINT fk_alerta_prop FOREIGN KEY (id_propiedad) REFERENCES propiedades(id_propiedad) ON DELETE SET NULL
) ENGINE=InnoDB;


-- ============================================================
--  BLOQUE 7 · FAVORITOS Y COMPARADOR (RF-06)
-- ============================================================

CREATE TABLE listas_favoritos (
    id_lista      INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_usuario    BIGINT UNSIGNED NOT NULL,
    nombre        VARCHAR(100) NOT NULL DEFAULT 'Mis favoritos',
    descripcion   VARCHAR(300),
    publica       TINYINT(1) NOT NULL DEFAULT 0,
    created_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_lista_usr FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE favoritos (
    id_lista      INT UNSIGNED     NOT NULL,
    id_propiedad  BIGINT UNSIGNED  NOT NULL,
    notas         VARCHAR(500),
    created_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_lista, id_propiedad),
    CONSTRAINT fk_fav_lista FOREIGN KEY (id_lista)     REFERENCES listas_favoritos(id_lista) ON DELETE CASCADE,
    CONSTRAINT fk_fav_prop  FOREIGN KEY (id_propiedad) REFERENCES propiedades(id_propiedad)  ON DELETE CASCADE
) ENGINE=InnoDB;

-- Sesiones de comparación (hasta 4 inmuebles — RF-06)
CREATE TABLE comparaciones (
    id_comparacion  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_usuario      BIGINT UNSIGNED,                    -- NULL para visitantes (por sesión)
    session_key     VARCHAR(128),                       -- Para visitantes no autenticados
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_comp_usr FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE comparaciones_detalle (
    id_comparacion  BIGINT UNSIGNED NOT NULL,
    id_propiedad    BIGINT UNSIGNED NOT NULL,
    orden           TINYINT UNSIGNED NOT NULL DEFAULT 1,   -- 1 a 4
    PRIMARY KEY (id_comparacion, id_propiedad),
    CONSTRAINT fk_compd_comp FOREIGN KEY (id_comparacion) REFERENCES comparaciones(id_comparacion) ON DELETE CASCADE,
    CONSTRAINT fk_compd_prop FOREIGN KEY (id_propiedad)   REFERENCES propiedades(id_propiedad) ON DELETE CASCADE
) ENGINE=InnoDB;


-- ============================================================
--  BLOQUE 8 · CONTACTO, LEADS Y VISITAS (RF-05)
-- ============================================================

CREATE TABLE leads (
    id_lead           BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_propiedad      BIGINT UNSIGNED NOT NULL,
    id_usuario        BIGINT UNSIGNED,                  -- NULL si es visitante
    -- Datos del contactante ——————————————
    nombre_contacto   VARCHAR(150),
    email_contacto    VARCHAR(150),
    telefono_contacto VARCHAR(20),
    -- Canal y contenido ————————————————
    canal             ENUM('FORMULARIO','WHATSAPP','LLAMADA','EMAIL') NOT NULL,
    mensaje           TEXT,
    utm_source        VARCHAR(100),                     -- Atribución de marketing
    utm_medium        VARCHAR(100),
    utm_campaign      VARCHAR(100),
    -- Estado del lead ——————————————————
    estado            ENUM('NUEVO','CONTACTADO','CALIFICADO','GANADO','PERDIDO') NOT NULL DEFAULT 'NUEVO',
    notas_agente      TEXT,
    created_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_lead_prop FOREIGN KEY (id_propiedad) REFERENCES propiedades(id_propiedad),
    CONSTRAINT fk_lead_usr  FOREIGN KEY (id_usuario)   REFERENCES usuarios(id_usuario) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='Registro de contactos/leads generados por propiedad (RF-05)';

CREATE INDEX idx_lead_propiedad ON leads(id_propiedad);
CREATE INDEX idx_lead_estado    ON leads(estado);

-- Visitas agendadas (RF-05 — calendario del agente)
CREATE TABLE visitas_agendadas (
    id_visita         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_lead           BIGINT UNSIGNED,
    id_propiedad      BIGINT UNSIGNED NOT NULL,
    id_agente         BIGINT UNSIGNED NOT NULL,
    id_comprador      BIGINT UNSIGNED,
    -- Datos de la visita ———————————————
    fecha_hora        DATETIME NOT NULL,
    duracion_min      SMALLINT UNSIGNED NOT NULL DEFAULT 60,
    modalidad         ENUM('PRESENCIAL','VIRTUAL') NOT NULL DEFAULT 'PRESENCIAL',
    estado            ENUM('PENDIENTE','CONFIRMADA','REALIZADA','CANCELADA','NO_SHOW')
                          NOT NULL DEFAULT 'PENDIENTE',
    notas             TEXT,
    -- Recordatorios ————————————————————
    recordatorio_sms  TINYINT(1) NOT NULL DEFAULT 1,
    recordatorio_email TINYINT(1) NOT NULL DEFAULT 1,
    created_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_visita_lead    FOREIGN KEY (id_lead)       REFERENCES leads(id_lead) ON DELETE SET NULL,
    CONSTRAINT fk_visita_prop    FOREIGN KEY (id_propiedad)  REFERENCES propiedades(id_propiedad),
    CONSTRAINT fk_visita_agente  FOREIGN KEY (id_agente)     REFERENCES usuarios(id_usuario),
    CONSTRAINT fk_visita_compra  FOREIGN KEY (id_comprador)  REFERENCES usuarios(id_usuario) ON DELETE SET NULL
) ENGINE=InnoDB;


-- ============================================================
--  BLOQUE 9 · PLANES COMERCIALES Y PAGOS (RF-07)
-- ============================================================

CREATE TABLE planes_comerciales (
    id_plan           SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre            ENUM('GRATIS','DESTACADO','PREMIUM') NOT NULL UNIQUE,
    descripcion       TEXT,
    precio_soles      DECIMAL(10,2) NOT NULL DEFAULT 0,
    precio_dolares    DECIMAL(10,2) NOT NULL DEFAULT 0,
    duracion_dias     SMALLINT UNSIGNED NOT NULL DEFAULT 30,
    max_publicaciones SMALLINT UNSIGNED,                -- NULL = ilimitado
    max_fotos         TINYINT UNSIGNED NOT NULL DEFAULT 10,
    tiene_destacado   TINYINT(1) NOT NULL DEFAULT 0,
    tiene_analytics   TINYINT(1) NOT NULL DEFAULT 0,
    tiene_whatsapp    TINYINT(1) NOT NULL DEFAULT 0,
    activo            TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB;

INSERT INTO planes_comerciales
  (nombre, precio_soles, precio_dolares, duracion_dias, max_publicaciones,
   max_fotos, tiene_destacado, tiene_analytics, tiene_whatsapp) VALUES
  ('GRATIS',    0,    0,   30,  1,  10, 0, 0, 0),
  ('DESTACADO', 99,  27,   30,  5,  20, 1, 1, 1),
  ('PREMIUM',  299,  80,   30, NULL, 30, 1, 1, 1);

CREATE TABLE suscripciones (
    id_suscripcion    BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_usuario        BIGINT UNSIGNED NOT NULL,
    id_plan           SMALLINT UNSIGNED NOT NULL,
    fecha_inicio      DATE NOT NULL,
    fecha_fin         DATE NOT NULL,
    estado            ENUM('ACTIVA','VENCIDA','CANCELADA') NOT NULL DEFAULT 'ACTIVA',
    renovacion_auto   TINYINT(1) NOT NULL DEFAULT 0,
    created_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_sus_usr  FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    CONSTRAINT fk_sus_plan FOREIGN KEY (id_plan)    REFERENCES planes_comerciales(id_plan)
) ENGINE=InnoDB;

CREATE TABLE pagos (
    id_pago           BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_suscripcion    BIGINT UNSIGNED NOT NULL,
    id_usuario        BIGINT UNSIGNED NOT NULL,
    -- Montos ————————————————————————————
    monto_soles       DECIMAL(10,2) NOT NULL,
    monto_dolares     DECIMAL(10,2),
    moneda_cobro      ENUM('PEN','USD') NOT NULL DEFAULT 'PEN',
    -- Pasarela de pago (Culqi, Niubiz, Izipay — RF-07) ——
    pasarela          ENUM('CULQI','NIUBIZ','IZIPAY','YAPE','PLIN','PAGOEFECTIVO','MANUAL')
                          NOT NULL,
    metodo_pago       ENUM('TARJETA_DEBITO','TARJETA_CREDITO','YAPE','PLIN',
                           'PAGOEFECTIVO','TRANSFERENCIA','EFECTIVO') NOT NULL,
    transaccion_id    VARCHAR(200),                     -- ID externo de la pasarela
    estado            ENUM('PENDIENTE','COMPLETADO','FALLIDO','REEMBOLSADO')
                          NOT NULL DEFAULT 'PENDIENTE',
    respuesta_json    JSON,                             -- Respuesta cruda de la pasarela
    created_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_pago_sus FOREIGN KEY (id_suscripcion) REFERENCES suscripciones(id_suscripcion),
    CONSTRAINT fk_pago_usr FOREIGN KEY (id_usuario)     REFERENCES usuarios(id_usuario)
) ENGINE=InnoDB;

-- Facturación electrónica SUNAT (CPE — RF-07)
CREATE TABLE comprobantes_electronicos (
    id_comprobante    BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_pago           BIGINT UNSIGNED NOT NULL,
    tipo_cpe          ENUM('BOLETA','FACTURA') NOT NULL,
    serie             VARCHAR(10) NOT NULL,             -- ej. 'B001', 'F001'
    correlativo       INT UNSIGNED NOT NULL,
    ruc_emisor        VARCHAR(11) NOT NULL,
    -- Datos del receptor ——————————————
    tipo_doc_receptor ENUM('DNI','RUC','CE','PASAPORTE') NOT NULL,
    num_doc_receptor  VARCHAR(20) NOT NULL,
    razon_social_rec  VARCHAR(200),
    direccion_rec     VARCHAR(300),
    -- Montos ————————————————————————————
    subtotal          DECIMAL(10,2) NOT NULL,
    igv               DECIMAL(10,2) NOT NULL,
    total             DECIMAL(10,2) NOT NULL,
    -- Estado SUNAT ——————————————————————
    estado_sunat      ENUM('PENDIENTE','ACEPTADO','RECHAZADO','ANULADO')
                          NOT NULL DEFAULT 'PENDIENTE',
    codigo_hash       VARCHAR(200),
    xml_firmado       LONGTEXT,
    cdr_respuesta     LONGTEXT,
    ose_proveedor     VARCHAR(100),                     -- Nombre del OSE/PSE
    created_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_cpe_serie (serie, correlativo),
    CONSTRAINT fk_cpe_pago FOREIGN KEY (id_pago) REFERENCES pagos(id_pago)
) ENGINE=InnoDB COMMENT='Comprobantes de pago electrónicos SUNAT (Boletas y Facturas CPE)';


-- ============================================================
--  BLOQUE 10 · ANALYTICS (RF-08)
-- ============================================================

CREATE TABLE analytics_propiedades (
    id_analytics      BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_propiedad      BIGINT UNSIGNED NOT NULL UNIQUE,
    total_impresiones BIGINT UNSIGNED NOT NULL DEFAULT 0,   -- Veces que apareció en resultados
    total_visitas_pag BIGINT UNSIGNED NOT NULL DEFAULT 0,   -- Visitas a la ficha
    clics_ver_telefono INT UNSIGNED NOT NULL DEFAULT 0,     -- RF-08: "Ver Teléfono"
    leads_whatsapp    INT UNSIGNED NOT NULL DEFAULT 0,      -- RF-08: botón WhatsApp
    leads_formulario  INT UNSIGNED NOT NULL DEFAULT 0,
    favoritos_count   INT UNSIGNED NOT NULL DEFAULT 0,
    comparaciones_count INT UNSIGNED NOT NULL DEFAULT 0,
    updated_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_analy_prop FOREIGN KEY (id_propiedad) REFERENCES propiedades(id_propiedad) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='Métricas agregadas por propiedad para el dashboard del agente (RF-08)';

-- Eventos de analítica granulares (para histórico mensual)
CREATE TABLE analytics_eventos (
    id_evento         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_propiedad      BIGINT UNSIGNED NOT NULL,
    id_usuario        BIGINT UNSIGNED,                  -- NULL para visitantes
    tipo_evento       ENUM('IMPRESION','VISITA_FICHA','CLIC_TELEFONO',
                           'CLIC_WHATSAPP','LEAD_FORMULARIO','FAVORITO_ADD',
                           'FAVORITO_REMOVE','COMPARACION','COMPARTIR') NOT NULL,
    ip                VARCHAR(45),
    user_agent        VARCHAR(500),
    referrer          VARCHAR(500),
    created_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    -- Particionamiento recomendado por YEAR(created_at)
    CONSTRAINT fk_evento_prop FOREIGN KEY (id_propiedad) REFERENCES propiedades(id_propiedad) ON DELETE CASCADE,
    CONSTRAINT fk_evento_usr  FOREIGN KEY (id_usuario)   REFERENCES usuarios(id_usuario) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='Log granular de eventos para analítica histórica';

CREATE INDEX idx_evento_prop_fecha ON analytics_eventos(id_propiedad, created_at);
CREATE INDEX idx_evento_tipo       ON analytics_eventos(tipo_evento, created_at);


-- ============================================================
--  BLOQUE 11 · CONFIGURACIÓN Y AUDITORÍA DEL SISTEMA
-- ============================================================

CREATE TABLE configuracion_sistema (
    clave       VARCHAR(100) PRIMARY KEY,
    valor       TEXT         NOT NULL,
    descripcion VARCHAR(300),
    updated_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

INSERT INTO configuracion_sistema (clave, valor, descripcion) VALUES
  ('TC_FUENTE',           'SBS',  'Fuente del tipo de cambio: SBS o SUNAT'),
  ('TC_HORA_ACTUALIZACION','08:00','Hora de actualización diaria del TC'),
  ('MAX_FOTOS_GRATIS',    '10',   'Máximo de fotos para plan gratuito'),
  ('MAX_COMPARACION',     '4',    'Máximo de inmuebles a comparar simultáneamente'),
  ('VERSIÓN_POLÍTICA',    '2024-01', 'Versión vigente de política de privacidad (Ley 29733)'),
  ('WHATSAPP_PAIS',       '+51',  'Prefijo de país para botones WhatsApp');

-- Log de auditoría de acciones críticas
CREATE TABLE auditoria_log (
    id_log        BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_usuario    BIGINT UNSIGNED,
    accion        VARCHAR(100) NOT NULL,                -- ej. 'ELIMINAR_PROPIEDAD'
    tabla_afectada VARCHAR(60),
    id_registro   VARCHAR(50),
    datos_antes   JSON,
    datos_despues JSON,
    ip            VARCHAR(45),
    user_agent    VARCHAR(500),
    created_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_audit_usr FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='Registro de auditoría para trazabilidad de operaciones críticas';

CREATE INDEX idx_audit_usuario ON auditoria_log(id_usuario, created_at);
CREATE INDEX idx_audit_accion  ON auditoria_log(accion, created_at);


-- ============================================================
--  BLOQUE 12 · VISTAS ÚTILES PARA EL BACKEND JAVA (JDBC)
-- ============================================================

-- Vista principal de búsqueda de propiedades (RF-03)
CREATE OR REPLACE VIEW v_propiedades_busqueda AS
SELECT
    p.id_propiedad,
    p.slug,
    p.titulo,
    p.operacion,
    p.precio_soles,
    p.precio_dolares,
    p.moneda_principal,
    p.precio_por_m2_soles,
    p.precio_por_m2_dolares,
    p.area_total,
    p.area_techada,
    p.dormitorios,
    p.banos,
    p.cocheras,
    p.antiguedad_anios,
    p.bono_mivivienda,
    p.bono_verde,
    p.techo_propio,
    p.lat,
    p.lng,
    p.estado,
    p.destacada,
    p.premium,
    p.fecha_publicacion,
    -- Ubicación desnormalizada para filtros rápidos
    d.id_distrito,
    d.nombre AS nombre_distrito,
    pr.id_provincia,
    pr.nombre AS nombre_provincia,
    dep.id_departamento,
    dep.nombre AS nombre_departamento,
    u.nombre AS nombre_urbanizacion,
    -- Tipo de inmueble
    ti.nombre AS tipo_inmueble,
    ti.slug AS tipo_inmueble_slug,
    -- Agente/propietario
    usr.nombres AS agente_nombres,
    usr.apellidos AS agente_apellidos,
    usr.telefono_whatsapp AS agente_whatsapp,
    -- Imagen de portada
    (SELECT img.url_webp FROM propiedades_imagenes img
     WHERE img.id_propiedad = p.id_propiedad AND img.es_portada = 1 LIMIT 1) AS imagen_portada,
    -- Métricas
    COALESCE(ap.total_impresiones, 0) AS total_impresiones,
    COALESCE(ap.leads_whatsapp, 0)    AS leads_whatsapp
FROM propiedades p
INNER JOIN distritos d      ON p.id_distrito     = d.id_distrito
INNER JOIN provincias pr    ON d.id_provincia    = pr.id_provincia
INNER JOIN departamentos dep ON pr.id_departamento = dep.id_departamento
LEFT  JOIN urbanizaciones u ON p.id_urbanizacion = u.id_urbanizacion
INNER JOIN tipos_inmueble ti ON p.id_tipo_inmueble = ti.id_tipo
INNER JOIN usuarios usr      ON p.id_usuario     = usr.id_usuario
LEFT  JOIN analytics_propiedades ap ON p.id_propiedad = ap.id_propiedad
WHERE p.deleted_at IS NULL
  AND p.estado = 'ACTIVO';

-- Vista del dashboard del agente (RF-08)
CREATE OR REPLACE VIEW v_dashboard_agente AS
SELECT
    p.id_propiedad,
    p.titulo,
    p.estado,
    p.fecha_publicacion,
    COALESCE(ap.total_impresiones,   0) AS impresiones,
    COALESCE(ap.total_visitas_pag,   0) AS visitas_ficha,
    COALESCE(ap.clics_ver_telefono,  0) AS clics_telefono,
    COALESCE(ap.leads_whatsapp,      0) AS leads_whatsapp,
    COALESCE(ap.leads_formulario,    0) AS leads_formulario,
    COALESCE(
        ROUND(
            (ap.leads_whatsapp + ap.leads_formulario) /
            NULLIF(ap.total_visitas_pag, 0) * 100, 2
        ), 0
    ) AS tasa_conversion_pct,
    p.id_usuario AS id_agente
FROM propiedades p
LEFT JOIN analytics_propiedades ap ON p.id_propiedad = ap.id_propiedad
WHERE p.deleted_at IS NULL;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
--  FIN DEL SCRIPT — InmobiX Database v1.0
-- ============================================================
