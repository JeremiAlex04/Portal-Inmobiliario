// ============================================================
//  InmobiX — Datos Simulados (basados en inmobix_db.sql v2.2)
// ============================================================

export const TIPO_CAMBIO = { compra: 3.75, venta: 3.78, fuente: 'SBS', fecha: '2026-10-04' };

export const roles = [
  { id_rol: 1, nombre: 'VISITANTE' },
  { id_rol: 2, nombre: 'COMPRADOR' },
  { id_rol: 3, nombre: 'AGENTE' },
  { id_rol: 4, nombre: 'CONSTRUCTORA' },
  { id_rol: 5, nombre: 'ADMINISTRADOR' },
];

export const usuarios = [
  { id_usuario: 1, id_rol: 3, nombres: 'Carlos', apellidos: 'Mendoza López', correo: 'agente@inmobix.com', clave: '123456', telefono: '987654321', activo: true, verificado: true, avatar_url: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Carlos', fecha_registro: '2025-08-15' },
  { id_usuario: 2, id_rol: 5, nombres: 'Super', apellidos: 'Administrador', correo: 'admin@inmobix.pe', clave: '123456', telefono: '999888777', activo: true, verificado: true, avatar_url: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Admin', fecha_registro: '2025-08-01' },
  { id_usuario: 3, id_rol: 3, nombres: 'María', apellidos: 'Torres Gutiérrez', correo: 'maria.torres@inmobix.com', clave: '123456', telefono: '912345678', activo: true, verificado: true, avatar_url: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Maria', fecha_registro: '2025-09-01' },
  { id_usuario: 4, id_rol: 2, nombres: 'Pedro', apellidos: 'Ramírez Castro', correo: 'comprador@inmobix.pe', clave: '123456', telefono: '955444333', activo: true, verificado: true, avatar_url: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Pedro', fecha_registro: '2025-09-20' },
];

export const distritos = [
  { id_distrito: 1,  nombre: 'Miraflores',       codigo_ubigeo: '150122', lat: -12.119, lng: -77.029 },
  { id_distrito: 2,  nombre: 'San Isidro',        codigo_ubigeo: '150131', lat: -12.095, lng: -77.035 },
  { id_distrito: 3,  nombre: 'Santiago de Surco', codigo_ubigeo: '150140', lat: -12.115, lng: -76.975 },
  { id_distrito: 4,  nombre: 'La Molina',         codigo_ubigeo: '150114', lat: -12.088, lng: -76.942 },
  { id_distrito: 5,  nombre: 'Lima Cercado',      codigo_ubigeo: '150101', lat: -12.046, lng: -77.031 },
  { id_distrito: 6,  nombre: 'San Borja',         codigo_ubigeo: '150130', lat: -12.106, lng: -76.999 },
  { id_distrito: 7,  nombre: 'Barranco',          codigo_ubigeo: '150104', lat: -12.148, lng: -77.021 },
  { id_distrito: 8,  nombre: 'Jesús María',       codigo_ubigeo: '150113', lat: -12.078, lng: -77.049 },
  { id_distrito: 9,  nombre: 'Lince',             codigo_ubigeo: '150116', lat: -12.091, lng: -77.037 },
  { id_distrito: 10, nombre: 'Magdalena del Mar', codigo_ubigeo: '150117', lat: -12.093, lng: -77.067 },
  { id_distrito: 11, nombre: 'Pueblo Libre',      codigo_ubigeo: '150121', lat: -12.077, lng: -77.062 },
  { id_distrito: 12, nombre: 'San Miguel',        codigo_ubigeo: '150136', lat: -12.079, lng: -77.085 },
  { id_distrito: 13, nombre: 'Chorrillos',        codigo_ubigeo: '150108', lat: -12.175, lng: -77.019 },
  { id_distrito: 14, nombre: 'Ate',               codigo_ubigeo: '150103', lat: -12.027, lng: -76.918 },
  { id_distrito: 15, nombre: 'Los Olivos',        codigo_ubigeo: '150115', lat: -11.977, lng: -77.078 },
];

export const tiposInmueble = [
  { id_tipo: 1, nombre: 'Casa' },
  { id_tipo: 2, nombre: 'Departamento' },
  { id_tipo: 3, nombre: 'Terreno' },
  { id_tipo: 4, nombre: 'Local Comercial' },
  { id_tipo: 5, nombre: 'Oficina' },
  { id_tipo: 6, nombre: 'Industrial' },
  { id_tipo: 7, nombre: 'Cochera' },
  { id_tipo: 8, nombre: 'Proyecto Multifamiliar' },
];

export const operaciones = [
  { id_operacion: 1, nombre: 'VENTA' },
  { id_operacion: 2, nombre: 'ALQUILER' },
  { id_operacion: 3, nombre: 'ANTICRESIS' },
];

export const planes = [
  { id_plan: 1, nombre: 'GRATUITO', precio_pen: 0,   duracion_dias: 30, max_propiedades: 1,  max_fotos: 5,  destacada: false, analytics: false, descripcion: '1 propiedad activa. Publicación básica.' },
  { id_plan: 2, nombre: 'BÁSICO',   precio_pen: 50,  duracion_dias: 30, max_propiedades: 5,  max_fotos: 20, destacada: false, analytics: false, descripcion: '5 propiedades activas. Visibilidad estándar.' },
  { id_plan: 3, nombre: 'PREMIUM',  precio_pen: 150, duracion_dias: 30, max_propiedades: 20, max_fotos: 30, destacada: true,  analytics: true,  descripcion: '20 propiedades destacadas. Analytics y prioridad.' },
];

export const propiedades = [
  {
    id_propiedad: 1, id_usuario_agente: 1, id_tipo_inmueble: 1, id_operacion: 1, id_distrito: 1,
    partida_sunarp: '11002233',
    titulo: 'Casa Moderna de Estreno cerca al Malecón',
    descripcion: 'Hermosa casa de 2 pisos con jardín interno, amplia terraza y finos acabados en zona residencial de Miraflores. Materiales de primera importados, domótica integrada y sistema de paneles solares. A 3 cuadras del Malecón de la Reserva y parques ecológicos.',
    direccion: 'Av. Pardo 1234', referencia: 'A 3 cuadras del Malecón de la Reserva',
    latitud: -12.119, longitud: -77.029,
    area_total_m2: 250, area_techada_m2: 200, num_dormitorios: 4, num_banos: 4, num_cocheras: 2, num_pisos: 2, anio_construccion: 2023,
    moneda_base: 'USD', precio: 450000,
    bono_mi_vivienda: false, bono_verde: false,
    foto_principal: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?fm=jpg&q=80&w=1200',
    fotos: [
      'https://images.unsplash.com/photo-1513584684374-8bab748fbf90?fm=jpg&q=80&w=1200',
      'https://images.unsplash.com/photo-1505691938895-1758d7feb511?fm=jpg&q=80&w=1200',
      'https://images.unsplash.com/photo-1484154218962-a197022b5858?fm=jpg&q=80&w=1200',
    ],
    estado: 'ACTIVO', destacada: true, premium: true,
    fecha_publicacion: '2026-09-01', numero_vistas: 382,
  },
  {
    id_propiedad: 2, id_usuario_agente: 1, id_tipo_inmueble: 2, id_operacion: 2, id_distrito: 2,
    partida_sunarp: '11223344',
    titulo: 'Departamento Amoblado Flat con vista panorámica al Golf',
    descripcion: 'Lujoso departamento completamente amoblado en el piso 8. Cuenta con vista espectacular al Golf de San Isidro, gimnasio y piscina. Cocina integrada de diseño italiano, pisos de parqué y sistema de seguridad 24/7.',
    direccion: 'Av. Javier Prado Oeste 789', referencia: 'Cerca al Country Club Lima Hotel',
    latitud: -12.095, longitud: -77.035,
    area_total_m2: 110, area_techada_m2: 110, num_dormitorios: 2, num_banos: 2, num_cocheras: 1, num_pisos: 1, anio_construccion: 2018,
    moneda_base: 'PEN', precio: 3500,
    bono_mi_vivienda: false, bono_verde: false,
    foto_principal: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?fm=jpg&q=80&w=1200',
    fotos: [
      'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?fm=jpg&q=80&w=1200',
      'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?fm=jpg&q=80&w=1200',
    ],
    estado: 'ACTIVO', destacada: false, premium: false,
    fecha_publicacion: '2026-09-05', numero_vistas: 214,
  },
  {
    id_propiedad: 3, id_usuario_agente: 1, id_tipo_inmueble: 2, id_operacion: 1, id_distrito: 3,
    partida_sunarp: '11445566',
    titulo: 'Departamento Proyecto Ecológico y Familiar Surco',
    descripcion: 'Moderno departamento ideal para familias en Santiago de Surco. Áreas comunes ecológicas y pet friendly. Califica a Bono Mivivienda y Bono Verde. Jardines verticales, paneles solares compartidos y área de compostaje.',
    direccion: 'Jr. El Cortijo 456', referencia: 'Frente al Club Golf Los Inkas',
    latitud: -12.115, longitud: -76.975,
    area_total_m2: 80, area_techada_m2: 80, num_dormitorios: 3, num_banos: 2, num_cocheras: 1, num_pisos: 1, anio_construccion: 2024,
    moneda_base: 'PEN', precio: 280000,
    bono_mi_vivienda: true, bono_verde: true,
    foto_principal: 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?fm=jpg&q=80&w=1200',
    fotos: [
      'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?fm=jpg&q=80&w=1200',
      'https://images.unsplash.com/photo-1484154218962-a197022b5858?fm=jpg&q=80&w=1200',
    ],
    estado: 'ACTIVO', destacada: true, premium: false,
    fecha_publicacion: '2026-09-10', numero_vistas: 156,
  },
  {
    id_propiedad: 4, id_usuario_agente: 3, id_tipo_inmueble: 3, id_operacion: 1, id_distrito: 4,
    partida_sunarp: '22001100',
    titulo: 'Terreno Ideal para Proyecto Inmobiliario La Molina',
    descripcion: 'Terreno plano de 500m2 en La Molina con habilitación urbana completa. Zonificación RDM. Excelente ubicación residencial, ideal para proyecto multifamiliar o casa de lujo. Todos los servicios instalados.',
    direccion: 'Av. La Molina 890', referencia: 'A 2 cuadras de la USIL',
    latitud: -12.088, longitud: -76.942,
    area_total_m2: 500, area_techada_m2: 0, num_dormitorios: 0, num_banos: 0, num_cocheras: 0, num_pisos: 0, anio_construccion: null,
    moneda_base: 'USD', precio: 320000,
    bono_mi_vivienda: false, bono_verde: false,
    foto_principal: 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?fm=jpg&q=80&w=1200',
    fotos: [],
    estado: 'ACTIVO', destacada: false, premium: false,
    fecha_publicacion: '2026-09-12', numero_vistas: 89,
  },
  {
    id_propiedad: 5, id_usuario_agente: 3, id_tipo_inmueble: 1, id_operacion: 1, id_distrito: 6,
    partida_sunarp: '22112233',
    titulo: 'Elegante Casa de Estreno con Piscina y Jardín',
    descripcion: 'Elegante casa de 3 pisos con piscina, amplio jardín en San Borja. Acabados de lujo en mármol y granito, zona residencial vigilada. Sala de cine privada, cuarto de servicio y bodega climatizada.',
    direccion: 'Av. San Borja Sur 567', referencia: 'Cerca al Pentagonito',
    latitud: -12.106, longitud: -76.999,
    area_total_m2: 350, area_techada_m2: 280, num_dormitorios: 5, num_banos: 5, num_cocheras: 3, num_pisos: 3, anio_construccion: 2019,
    moneda_base: 'USD', precio: 780000,
    bono_mi_vivienda: false, bono_verde: false,
    foto_principal: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?fm=jpg&q=80&w=1200',
    fotos: [],
    estado: 'ACTIVO', destacada: true, premium: true,
    fecha_publicacion: '2026-09-15', numero_vistas: 421,
  },
  {
    id_propiedad: 6, id_usuario_agente: 1, id_tipo_inmueble: 2, id_operacion: 2, id_distrito: 7,
    partida_sunarp: '33001122',
    titulo: 'Departamento Bohemio y Acogedor en Barranco',
    descripcion: 'Acogedor departamento con balcón y vista al mar en el distrito bohemio de Barranco. A pocas cuadras del Puente de los Suspiros. Perfecto para artistas o profesionales que buscan ambiente cultural y tranquilo.',
    direccion: 'Jr. Cajamarca 234', referencia: 'A una cuadra de la Bajada de Baños',
    latitud: -12.148, longitud: -77.021,
    area_total_m2: 75, area_techada_m2: 75, num_dormitorios: 1, num_banos: 1, num_cocheras: 0, num_pisos: 1, anio_construccion: 2015,
    moneda_base: 'PEN', precio: 2800,
    bono_mi_vivienda: false, bono_verde: false,
    foto_principal: 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?fm=jpg&q=80&w=1200',
    fotos: [],
    estado: 'ACTIVO', destacada: false, premium: false,
    fecha_publicacion: '2026-09-18', numero_vistas: 178,
  },
  {
    id_propiedad: 7, id_usuario_agente: 3, id_tipo_inmueble: 2, id_operacion: 1, id_distrito: 8,
    partida_sunarp: '33112233',
    titulo: 'Departamento de Estreno con Excelentes Áreas Comunes',
    descripcion: 'Departamento de estreno en Jesús María con ascensor inteligente. Cocina equipada con encimera de granito y áreas recreativas. Lobby de diseño, salón de eventos y terraza jardín en el último piso.',
    direccion: 'Av. Brasil 1567', referencia: 'Cerca al Campo de Marte',
    latitud: -12.078, longitud: -77.049,
    area_total_m2: 90, area_techada_m2: 85, num_dormitorios: 3, num_banos: 2, num_cocheras: 1, num_pisos: 1, anio_construccion: 2025,
    moneda_base: 'PEN', precio: 350000,
    bono_mi_vivienda: true, bono_verde: false,
    foto_principal: 'https://images.unsplash.com/photo-1560185007-cde436f6a4d0?fm=jpg&q=80&w=1200',
    fotos: [],
    estado: 'ACTIVO', destacada: false, premium: false,
    fecha_publicacion: '2026-09-20', numero_vistas: 133,
  },
  {
    id_propiedad: 8, id_usuario_agente: 1, id_tipo_inmueble: 4, id_operacion: 2, id_distrito: 5,
    partida_sunarp: '44001122',
    titulo: 'Amplio Local Comercial en Zona de Alto Tránsito',
    descripcion: 'Amplio local comercial en esquina con alto tránsito peatonal en pleno centro histórico de Lima. Ideal para oficinas o comercio. Fachada de vidrio templado, depósito en semisótano y acceso para personas con movilidad reducida.',
    direccion: 'Jr. de la Unión 800', referencia: 'A una cuadra de la Plaza Mayor de Lima',
    latitud: -12.046, longitud: -77.031,
    area_total_m2: 120, area_techada_m2: 120, num_dormitorios: 0, num_banos: 2, num_cocheras: 0, num_pisos: 1, anio_construccion: 1990,
    moneda_base: 'PEN', precio: 8500,
    bono_mi_vivienda: false, bono_verde: false,
    foto_principal: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?fm=jpg&q=80&w=1200',
    fotos: [],
    estado: 'ACTIVO', destacada: false, premium: false,
    fecha_publicacion: '2026-09-22', numero_vistas: 97,
  },
  {
    id_propiedad: 9, id_usuario_agente: 3, id_tipo_inmueble: 1, id_operacion: 1, id_distrito: 13,
    partida_sunarp: '55001122',
    titulo: 'Casa de Playa con Hermosa Vista al Océano',
    descripcion: 'Casa de playa renovada de 2 pisos en Chorrillos. Amplia terraza con vista al mar y cochera privada. Lista para mudarse. Renovación integral 2022, sistema de agua caliente solar y jardín con palmeras.',
    direccion: 'Av. Defensores del Morro 456', referencia: 'Frente al Club Regatas Chorrillos',
    latitud: -12.175, longitud: -77.019,
    area_total_m2: 180, area_techada_m2: 140, num_dormitorios: 3, num_banos: 2, num_cocheras: 2, num_pisos: 2, anio_construccion: 2010,
    moneda_base: 'USD', precio: 195000,
    bono_mi_vivienda: false, bono_verde: false,
    foto_principal: 'https://images.unsplash.com/photo-1499793983690-e29da59ef1c2?fm=jpg&q=80&w=1200',
    fotos: [],
    estado: 'ACTIVO', destacada: false, premium: false,
    fecha_publicacion: '2026-09-25', numero_vistas: 205,
  },
  {
    id_propiedad: 10, id_usuario_agente: 1, id_tipo_inmueble: 2, id_operacion: 1, id_distrito: 12,
    partida_sunarp: '55112233',
    titulo: 'Departamento en San Miguel con Club House',
    descripcion: 'Departamento moderno en San Miguel con vista a parque. Club house completo con piscina temperada y zona de BBQ. A 5 minutos de la Costa Verde y centros comerciales.',
    direccion: 'Av. La Marina 2345', referencia: 'Cerca a Plaza San Miguel',
    latitud: -12.079, longitud: -77.085,
    area_total_m2: 70, area_techada_m2: 65, num_dormitorios: 2, num_banos: 1, num_cocheras: 1, num_pisos: 1, anio_construccion: 2024,
    moneda_base: 'PEN', precio: 245000,
    bono_mi_vivienda: true, bono_verde: true,
    foto_principal: 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?fm=jpg&q=80&w=1200',
    fotos: [],
    estado: 'ACTIVO', destacada: true, premium: false,
    fecha_publicacion: '2026-09-28', numero_vistas: 312,
  },
  {
    id_propiedad: 11, id_usuario_agente: 3, id_tipo_inmueble: 5, id_operacion: 2, id_distrito: 2,
    partida_sunarp: '66001122',
    titulo: 'Oficina Prime Corporativa en Centro Financiero',
    descripcion: 'Exclusiva oficina corporativa en el corazón de San Isidro. Plantas libres de estreno con aire acondicionado central y disipadores sísmicos. Certificación LEED en trámite, estacionamiento en semisótano.',
    direccion: 'Av. Andrés Reyes 450', referencia: 'A media cuadra de la estación Canaval y Moreyra',
    latitud: -12.094, longitud: -77.027,
    area_total_m2: 200, area_techada_m2: 200, num_dormitorios: 0, num_banos: 4, num_cocheras: 5, num_pisos: 1, anio_construccion: 2021,
    moneda_base: 'USD', precio: 3200,
    bono_mi_vivienda: false, bono_verde: false,
    foto_principal: 'https://images.unsplash.com/photo-1497366216548-37526070297c?fm=jpg&q=80&w=1200',
    fotos: [],
    estado: 'ACTIVO', destacada: true, premium: true,
    fecha_publicacion: '2026-10-01', numero_vistas: 88,
  },
  {
    id_propiedad: 12, id_usuario_agente: 1, id_tipo_inmueble: 2, id_operacion: 1, id_distrito: 9,
    partida_sunarp: '66112233',
    titulo: 'Moderno Departamento de Estreno Lince Límite San Isidro',
    descripcion: 'Moderno departamento de estreno en excelente ubicación en Lince. Cerca a parques y centros comerciales, acabados de primera. Lobby con recepción 24h, área de coworking y gimnasio equipado.',
    direccion: 'Jr. Sinchi Roca 2500', referencia: 'A espaldas del CC Risso',
    latitud: -12.091, longitud: -77.037,
    area_total_m2: 78, area_techada_m2: 78, num_dormitorios: 2, num_banos: 2, num_cocheras: 1, num_pisos: 1, anio_construccion: 2025,
    moneda_base: 'USD', precio: 135000,
    bono_mi_vivienda: true, bono_verde: true,
    foto_principal: 'https://images.unsplash.com/photo-1502005229762-fc1b2b812ca5?fm=jpg&q=80&w=1200',
    fotos: [],
    estado: 'ACTIVO', destacada: false, premium: false,
    fecha_publicacion: '2026-10-02', numero_vistas: 67,
  },
  {
    id_propiedad: 13, id_usuario_agente: 3, id_tipo_inmueble: 1, id_operacion: 1, id_distrito: 11,
    partida_sunarp: '77001122',
    titulo: 'Casa Colonial Remodelada Ideal para Vivienda u Oficina',
    descripcion: 'Hermosa casa colonial restaurada y remodelada en Pueblo Libre. Ambientes de techos altos y patio central colonial, muy amplia. Conserva elementos arquitectónicos originales del siglo XIX integrados con comodidades modernas.',
    direccion: 'Jr. Gamarra 320', referencia: 'A 2 cuadras del Museo Larco',
    latitud: -12.077, longitud: -77.062,
    area_total_m2: 320, area_techada_m2: 250, num_dormitorios: 6, num_banos: 3, num_cocheras: 2, num_pisos: 2, anio_construccion: 1980,
    moneda_base: 'PEN', precio: 890000,
    bono_mi_vivienda: false, bono_verde: false,
    foto_principal: 'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?fm=jpg&q=80&w=1200',
    fotos: [],
    estado: 'ACTIVO', destacada: false, premium: false,
    fecha_publicacion: '2026-10-03', numero_vistas: 141,
  },
  {
    id_propiedad: 14, id_usuario_agente: 1, id_tipo_inmueble: 2, id_operacion: 1, id_distrito: 10,
    partida_sunarp: '77112233',
    titulo: 'Departamento Flat con Vista Impresionante al Mar',
    descripcion: 'Moderno flat con balcón amplio y vista panorámica al mar en Magdalena. Áreas comunes de primer nivel, gimnasio y zona coworking. Cocina abierta con isla de granito, dormitorio en suite y walk-in closet.',
    direccion: 'Jr. Bolognesi 540', referencia: 'Frente al Malecón de Magdalena',
    latitud: -12.093, longitud: -77.067,
    area_total_m2: 85, area_techada_m2: 85, num_dormitorios: 2, num_banos: 2, num_cocheras: 1, num_pisos: 1, anio_construccion: 2023,
    moneda_base: 'USD', precio: 160000,
    bono_mi_vivienda: false, bono_verde: true,
    foto_principal: 'https://images.unsplash.com/photo-1515263487990-61b07816b324?fm=jpg&q=80&w=1200',
    fotos: [],
    estado: 'ACTIVO', destacada: true, premium: false,
    fecha_publicacion: '2026-10-04', numero_vistas: 194,
  },
  {
    id_propiedad: 15, id_usuario_agente: 3, id_tipo_inmueble: 8, id_operacion: 1, id_distrito: 15,
    partida_sunarp: '88001122',
    titulo: 'Proyecto Residencial Las Palmeras de Los Olivos',
    descripcion: 'Departamentos de estreno en pre-venta en Los Olivos. Edificio moderno de 8 pisos con ascensor, excelente ubicación residencial y segura. Entrega estimada Q2 2026. Sala de usos múltiples, lavandería compartida y áreas verdes.',
    direccion: 'Av. Las Palmeras 1200', referencia: 'A 3 cuadras de la Municipalidad de Los Olivos',
    latitud: -11.977, longitud: -77.078,
    area_total_m2: 1200, area_techada_m2: 850, num_dormitorios: 3, num_banos: 2, num_cocheras: 1, num_pisos: 8, anio_construccion: 2026,
    moneda_base: 'PEN', precio: 235000,
    bono_mi_vivienda: true, bono_verde: true,
    foto_principal: 'https://images.unsplash.com/photo-1570129477492-45c003edd2be?fm=jpg&q=80&w=1200',
    fotos: [],
    estado: 'ACTIVO', destacada: false, premium: false,
    fecha_publicacion: '2026-10-04', numero_vistas: 56,
  },
];

export const consultas = [
  { id_consulta: 1, id_propiedad: 1, id_usuario: 4, nombre: 'Pedro Ramírez Castro', email: 'comprador@inmobix.pe', telefono: '955444333', mensaje: 'Buenas tardes Carlos, estoy muy interesado en la casa de Miraflores. ¿Cuándo podría programar una visita guiada?', estado: 'PENDIENTE', fecha: '2026-10-03' },
  { id_consulta: 2, id_propiedad: 3, id_usuario: null, nombre: 'Juan Carlos Quispe', email: 'j.quispe@gmail.com', telefono: '988777666', mensaje: 'Hola, quisiera saber si el departamento en Surco aplica para el Bono Verde y cuál es la cuota inicial mínima.', estado: 'PENDIENTE', fecha: '2026-10-03' },
  { id_consulta: 3, id_propiedad: 5, id_usuario: null, nombre: 'Sofía Alejandra Rojas', email: 'sofia.rojas@outlook.com', telefono: '944333222', mensaje: 'Hola María, me interesa la casa en San Borja. ¿El precio en dólares es negociable? Quedo atenta.', estado: 'LEIDA', fecha: '2026-10-02' },
  { id_consulta: 4, id_propiedad: 11, id_usuario: null, nombre: 'Renzo Alva Merino', email: 'ralva@corporacionperu.com', telefono: '922111000', mensaje: 'Estimada María, represento a una empresa comercial y buscamos alquilar la oficina en San Isidro. Quisiera saber si incluye las cocheras.', estado: 'RESPONDIDA', fecha: '2026-10-01' },
];

export const favoritos = [1, 3, 5, 10, 14]; // IDs de propiedades favoritas del comprador Pedro

export const estadisticas = [
  { id_propiedad: 1, fecha: '2026-10-02', num_vistas: 15 },
  { id_propiedad: 1, fecha: '2026-10-03', num_vistas: 22 },
  { id_propiedad: 1, fecha: '2026-10-04', num_vistas: 35 },
  { id_propiedad: 3, fecha: '2026-10-03', num_vistas: 10 },
  { id_propiedad: 3, fecha: '2026-10-04', num_vistas: 18 },
  { id_propiedad: 5, fecha: '2026-10-04', num_vistas: 25 },
  { id_propiedad: 11, fecha: '2026-10-04', num_vistas: 8 },
  { id_propiedad: 14, fecha: '2026-10-04', num_vistas: 14 },
];

export const eventosAuditoria = [
  { id_evento: 1, id_usuario: 1, entidad: 'propiedad', id_entidad: 1, accion: 'CREAR', ip_origen: '192.168.1.15', fecha_evento: '2026-09-01 10:30:00' },
  { id_evento: 2, id_usuario: 3, entidad: 'propiedad', id_entidad: 5, accion: 'CREAR', ip_origen: '192.168.1.28', fecha_evento: '2026-09-15 09:15:00' },
  { id_evento: 3, id_usuario: 2, entidad: 'usuario', id_entidad: 4, accion: 'CREAR', ip_origen: '192.168.1.10', fecha_evento: '2026-09-20 14:00:00' },
  { id_evento: 4, id_usuario: 1, entidad: 'usuario', id_entidad: 1, accion: 'LOGIN', ip_origen: '192.168.1.15', fecha_evento: '2026-10-04 08:05:00' },
  { id_evento: 5, id_usuario: 3, entidad: 'usuario', id_entidad: 3, accion: 'LOGIN', ip_origen: '192.168.1.28', fecha_evento: '2026-10-04 08:22:00' },
];

// ── Helpers ──────────────────────────────────────────────────────────────────

export function getDistrito(id) { return distritos.find(d => d.id_distrito === id); }
export function getTipo(id) { return tiposInmueble.find(t => t.id_tipo === id); }
export function getOperacion(id) { return operaciones.find(o => o.id_operacion === id); }
export function getAgente(id) { return usuarios.find(u => u.id_usuario === id); }

export function formatPrecio(precio, moneda) {
  if (moneda === 'USD') {
    return { usd: `$${precio.toLocaleString('es-PE')}`, pen: `S/ ${(precio * TIPO_CAMBIO.venta).toLocaleString('es-PE', { maximumFractionDigits: 0 })}` };
  } else {
    return { pen: `S/ ${precio.toLocaleString('es-PE')}`, usd: `$${(precio / TIPO_CAMBIO.venta).toLocaleString('es-PE', { maximumFractionDigits: 0 })}` };
  }
}

export function getPropiedadesByAgente(id_agente) {
  return propiedades.filter(p => p.id_usuario_agente === id_agente);
}

export const suscripciones = [
  { id_suscripcion: 1, id_usuario: 1, id_plan: 3, fecha_inicio: '2026-09-29', fecha_fin: '2026-10-29', estado: 'ACTIVA' },
  { id_suscripcion: 2, id_usuario: 3, id_plan: 2, fecha_inicio: '2026-09-24', fecha_fin: '2026-10-24', estado: 'ACTIVA' },
];
