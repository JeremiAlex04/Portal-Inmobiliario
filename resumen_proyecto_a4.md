# InmobiX — Portal Inmobiliario · Resumen del Proyecto

## ¿Qué es?
Plataforma web para publicar, buscar y comparar inmuebles en Perú. Construida con **Java 17 + Jakarta EE 10**, desplegada en **Tomcat 10**, con base de datos **MySQL 8**. Vistas en **JSP/JSF + Tailwind CSS**, mapas con **Leaflet.js** y gráficos con **Chart.js**.

## Arquitectura MVC por Capas
```
Usuario → Vista (JSP/XHTML) → Controlador (Servlet) → Fachada → DAO → MySQL
```
Cada capa tiene una responsabilidad única: la **Vista** renderiza HTML, el **Controlador** gestiona peticiones HTTP, la **Fachada** aplica reglas de negocio, el **DAO** ejecuta SQL, y el **DTO** transporta datos entre capas.

## Estructura de Carpetas y su Función

### Backend — `src/main/java/org/example/proyectoweb/`

| Carpeta | Qué contiene | Función |
|:---|:---|:---|
| `bean/` | 11 Managed Beans JSF | Controladores de las vistas `.xhtml` (login, admin, agente, propiedades, favoritos, pagos) |
| `controller/` | 13 Servlets HTTP | Reciben peticiones del navegador y redirigen a las vistas JSP. Ej: `PropiedadServlet` → `/propiedades`, `UsuarioServlet` → `/usuario`, `AdminServlet` → `/admin` |
| `dao/` | 11 clases DAO | Acceso directo a MySQL con `PreparedStatement`. Ej: `PropiedadDAO` hace CRUD, búsqueda avanzada y paginación; `UsuarioDAO` registra con hash BCrypt |
| `dto/` | 11 clases DTO | Objetos planos (POJOs) que transportan datos: `PropiedadDTO`, `UsuarioDTO`, `PagoDTO`, etc. |
| `facade/` | 6 fachadas | Capa de reglas de negocio. Ej: `PropiedadFacade` valida que precio de venta ≥ 10,000, alquiler ≥ 100, título obligatorio, distrito obligatorio |
| `util/` | 3 clases | `ConexionDB` gestiona la conexión JDBC; `TestDB` prueba la conexión; `LocalePhaseListener` maneja idioma |

### Frontend — `src/main/webapp/`

| Carpeta | Función |
|:---|:---|
| `*.jsp / *.xhtml` (raíz) | Páginas públicas: inicio, login, registro, catálogo, detalle, contacto, planes, FAQ |
| `WEB-INF/views/public/` | Vistas JSP protegidas: catálogo con filtros, detalle con mapa y galería, comparador, login, registro |
| `WEB-INF/views/agente/` | Panel del agente: dashboard con gráficos, formulario de publicación de propiedades |
| `WEB-INF/views/admin/` | Panel admin: gestión de usuarios, propiedades, ubicaciones, pagos, auditoría de seguridad |
| `WEB-INF/views/usuario/` | Panel comprador: favoritos, perfil, historial de pagos |
| `WEB-INF/views/layout/` | Componentes reutilizables: header, footer, head (incluidos en todas las páginas) |
| `WEB-INF/templates/` | Plantillas JSF: layout público, admin, agente y auth |
| `assets/css/` | Estilos CSS personalizados |
| `assets/js/` | JavaScript: buscador con autocompletado, registro de propiedades, gráficos analytics, panel admin |
| `assets/img/` | Logos e imágenes estáticas |

### Otros archivos raíz

| Archivo | Función |
|:---|:---|
| `pom.xml` | Dependencias Maven (Servlet, JSF, MySQL, BCrypt, JSTL, Jersey, Weld/CDI) |
| `inmobix_db.sql` | Base de datos completa: **15 tablas** (geografía, usuarios, propiedades, fotos, favoritos, consultas, planes, pagos, auditoría) + vista `v_propiedades_bimonetarias` que calcula precios PEN/USD automáticamente + datos semilla (15 propiedades, 4 usuarios) |
| `web.xml` | Configura FacesServlet, CDI/Weld, página de bienvenida y páginas de error |

## Roles del Sistema

| | Comprador | Agente | Admin |
|:---|:---:|:---:|:---:|
| Buscar, ver mapa, comparar | ✅ | ✅ | ✅ |
| Favoritos y consultas | ✅ | — | — |
| Publicar propiedades y analytics | — | ✅ | ✅ |
| Moderar usuarios, auditoría | — | — | ✅ |

## Flujo Resumido
**Buscar**: Usuario busca "Miraflores" → `PropiedadServlet` → `PropiedadFacade` → `PropiedadDAO` (SQL con `LIKE`) → MySQL → devuelve lista de `PropiedadDTO` → renderiza tarjetas en `propiedades.jsp`.
**Publicar**: Agente llena formulario → `POST /propiedades` → Servlet construye DTO → Fachada valida reglas → DAO inserta en BD → registra auditoría → redirige al panel.

**Usuarios de prueba** (contraseña: `123456`): `admin@inmobix.pe` · `agente@inmobix.com` · `comprador@inmobix.pe`
