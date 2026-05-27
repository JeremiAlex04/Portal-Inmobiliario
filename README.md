# InmobiX - Portal Inmobiliario Premium (Academic Project)

InmobiX es una plataforma web académica diseñada para demostrar la aplicación de patrones de arquitectura empresarial en el contexto del mercado inmobiliario peruano. El sistema actúa como un portal que conecta usuarios interesados en inmuebles con agentes inmobiliarios que publican anuncios.

---

## 🏛️ 1. Descripción General del Sistema

El proyecto destaca por incorporar las siguientes características diferenciadoras:
*   **Localización Peruana Precisa**: Segmentación geográfica jerárquica (Departamento → Provincia → Distrito → Urbanización) adaptada a la división política del Perú y el comportamiento del usuario local.
*   **Sistema Bimonetario**: Gestión dual de precios en Soles (PEN) y Dólares (USD) con conversión de tipo de cambio en tiempo real mediante base de datos.
*   **Arquitectura Autocontenida**: Independiente de APIs o servicios externos de pago/mensajería comerciales, facilitando su despliegue y validación en entornos académicos controlados.
*   **Enfoque en Patrones de Diseño**: Implementación rigurosa del patrón MVC con capas desacopladas, inyección de dependencias básicas y JSTL/EL libre de scriptlets.

---

## 🛠️ 2. Arquitectura y Tecnologías

### 2.1 Stack Tecnológico
*   **Backend**: Java Jakarta EE 10, Apache Tomcat 10.x, JDBC (sin ORMs de terceros), MySQL 8.x.
*   **Frontend**: JSP con JSTL 3.x (sin scriptlets `<% %>`), Expression Language (EL), JSF (Jakarta Server Faces) para flujos específicos (Consultas), Tailwind CSS y JavaScript Vanilla.
*   **Visualización Geográfica**: Leaflet.js con capas de OpenStreetMap (cero dependencia de API keys de pago).

### 2.2 Restricciones Técnicas y Alternativas Implementadas
Para mantener un control absoluto del entorno de ejecución, el proyecto utiliza alternativas locales autogestionadas:

| Servicio Externo Restringido | Solución / Alternativa Local Implementada | Ventaja / Control Académico |
| :--- | :--- | :--- |
| **OAuth de Google / Facebook** | Sistema de autenticación local con hash de contraseña propia | Seguridad aislada y control total de usuarios. |
| **Google Maps API** | Biblioteca Javascript open-source `Leaflet.js` con OpenStreetMap | Mapa interactivo funcional y local sin requerir API Key ni pagos. |
| **Pasarelas (Culqi/Niubiz)** | Módulo de pagos simulados (registro de transacciones y estados) | Registro contable ficticio sin procesamiento real. |
| **Mensajería (Twilio/SendGrid)**| Registro de notificaciones internas y logs persistidos en MySQL | Simulación interactiva dentro de la plataforma. |
| **Almacenamiento Cloud (S3)** | Carpeta física temporal `uploads/` en el propio servidor Tomcat | Cero dependencia de servicios de AWS u otras nubes. |

### 2.3 Capas de la Arquitectura MVC

| Capa | Ubicación / Paquete | Responsabilidad Principal | Regla de Oro / Restricción |
| :--- | :--- | :--- | :--- |
| **Vista (JSP)** | `src/main/webapp/WEB-INF/views/` | Renderizar interfaz de usuario (HTML dinámico) | Cero scriptlets (`<% ... %>`). Solo JSTL y EL. |
| **Controlador (Servlet)**| `org.example.proyectoweb.controller` | Manejo de peticiones HTTP, procesamiento de sesión y redirecciones | Captura datos y los encapsula en DTOs. Invoca a Facades (nunca DAOs). |
| **Fachada (Facade)** | `org.example.proyectoweb.facade` | Orquestación de múltiples DAOs y aplicación de lógica de negocio | Centraliza validaciones complejas. Desacopla controladores de persistencia. |
| **Acceso a Datos (DAO)**| `org.example.proyectoweb.dao` | Consultas CRUD contra la base de datos MySQL | Uso obligado de `PreparedStatement` (previene SQL Injection). |
| **Modelo (DTO)** | `org.example.proyectoweb.dto` | Objetos simples de intercambio de datos sin lógicas complejas | Atributos privados con getters, setters y constructores. |

---

## 🔄 3. Flujo de Funcionamiento del Sistema

El sistema implementa de forma estricta la separación de responsabilidades. El siguiente diagrama de secuencia detalla cómo viaja una petición de datos en una operación común del negocio (ej. Registrar Propiedad):

```mermaid
sequenceDiagram
    autonumber
    actor Usuario
    participant JSP as Vista (JSP/JSTL/EL)
    participant Servlet as Controlador (Servlet)
    participant DTO as Objeto de Transferencia (DTO)
    participant Facade as Capa de Mediación (Facade)
    participant DAO as Acceso a Datos (DAO)
    database DB as Base de Datos (MySQL)

    Usuario->>JSP: Completa y envía formulario (POST)
    JSP->>Servlet: Petición HTTP con parámetros
    Servlet->>Servlet: Valida formatos de entrada (campos obligatorios, numéricos)
    Servlet->>DTO: Setea valores en instancia DTO
    Servlet->>Facade: Invoca lógica de negocio (ej. crearPropiedad(dto))
    Facade->>Facade: Aplica reglas de negocio (precios, límites del plan)
    Facade->>DAO: Invoca método CRUD (ej. crear(dto))
    DAO->>DB: Ejecuta SQL preparado (PreparedStatement)
    DB-->>DAO: Retorna filas afectadas / ID generado
    DAO-->>Facade: Retorna estado de persistencia
    Facade-->>Servlet: Retorna confirmación de negocio
    Servlet->>Servlet: Inserta mensaje en Request (request.setAttribute)
    Servlet->>JSP: Redirige flujo (RequestDispatcher.forward)
    JSP-->>Usuario: Renderiza vista actualizada con JSTL/EL
```

### Flujo de la Búsqueda Inteligente (Caso de Uso Reciente)
El buscador limpia dinámicamente las sugerencias con formato `"Distrito (Provincia)"` para evitar fallos de concordancia de base de datos:

```mermaid
graph TD
    A[Buscador: Miraflores (Lima)] -->|GET /propiedades?q=Miraflores+...| B[PropiedadServlet]
    B -->|Invoca buscarPropiedadesAvanzado| C[PropiedadFacade]
    C -->|Invoca buscarPropiedades| D[PropiedadDAO]
    D -->|cleanKeyword| E[cleanKeyword: 'Miraflores']
    E -->|SQL LIKE %Miraflores%| F[(MySQL DB)]
    F -->|Registros SQL| D
    D -->|Instancia DTOs y resuelve Foto URLs| C
    C -->|Retorna List| B
    B -->|RequestDispatcher| G[propiedades.jsp]
    G -->|EL: getFotoPrincipalUrl| H[Renderiza tarjetas con imágenes correctas]
```

---

## 📁 4. Estructura de Carpetas del Proyecto

El código y los recursos se encuentran organizados siguiendo el principio de alta cohesión y bajo acoplamiento:

```text
Portal-Inmobiliario/
├── src/main/java/org/example/proyectoweb/
│   ├── bean/              # Managed Beans de JSF (ej. ConsultaBean.java para JSF)
│   ├── controller/        # Controladores MVC Servlets (ej. PropiedadServlet.java)
│   ├── dao/               # Clases de acceso a datos JDBC (ej. PropiedadDAO.java)
│   ├── dto/               # Modelos de Intercambio de Datos (ej. PropiedadDTO.java)
│   ├── facade/            # Fachadas de negocio unificadas (ej. PropiedadFacade.java)
│   └── util/              # Conexión DB y configuraciones de utilidad
├── src/main/webapp/
│   ├── WEB-INF/
│   │   ├── views/         # Vistas protegidas (No accesibles directamente por URL)
│   │   │   ├── admin/     # Consola administrativa
│   │   │   ├── agente/    # Creación, edición y administración de propiedades de Agentes
│   │   │   ├── layout/    # Fragmentos de diseño común (header.jsp)
│   │   │   ├── public/    # Catálogo público, comparador y detalles
│   │   │   └── usuario/   # Perfil y favoritos del cliente final
│   │   └── web.xml        # Descriptor de Despliegue de la aplicación
│   ├── assets/            # Archivos estáticos unificados (CSS, JS, logos)
│   ├── index.jsp          # Página de aterrizaje principal
│   ├── confirmacion.xhtml # Vista de confirmación en JSF
│   └── nuevaConsulta.xhtml# Formulario de consultas estructurado en JSF
├── inmobix_db.sql         # Script SQL completo de inicialización de Base de Datos
└── pom.xml                # Descriptor de dependencias de Maven
```

---

## 🎯 5. Alcance Incremental por Sprints

### Sprint 1: Prototipo Funcional
*   **Login y Sesiones**: Autenticación de roles (Agente, Usuario Regular). Redirección controlada e invalidación de sesión.
*   **Publicación Localizada (Agentes)**: Formulario de características con dropdowns dinámicos de Departamento, Provincia y Distrito de Lima.
*   **Catálogo Público**: Lista interactiva con paginación, filtros por distrito/tipo y botón de detalle.
*   **Panel Administrativo**: Consola con gestión global de usuarios, ubicaciones y propiedades.

### Sprint 2: Multimedia y Búsqueda Avanzada
*   **Gestión Multimedia**: Carga de imagen principal (`foto_principal`) por Multipart/Form-Data en disco local.
*   **Búsqueda Multicriterio**: Filtrado por rangos de precio, dormitorios, baños y conversión automática bimonetaria.
*   **Bimonetariedad**: Tipo de cambio vigente referencial para equivalencias en PEN/USD.
*   **Favoritos**: Registro e indicadores visuales de propiedades de interés del usuario.

### Sprint 3: Funcionalidades Avanzadas (JSF, Comparador y Mapas)
*   **Galería Multimedia**: Carga múltiple de hasta 5 fotos secundarias con visor interactivo en lightbox.
*   **Comparador**: Selección y visualización de hasta 4 propiedades en tabla técnica con destaque cromático de diferencias.
*   **Analytics del Agente**: Gráficos interactivos de visualizaciones con Chart.js.
*   **Geolocalización**: Ubicación aproximada mapeada con Leaflet.js.
*   **Pagos Simulados**: Modelado de facturación y cambio de planes para el Agente (Gratis, Básico, Premium).

---

## 📋 6. Roles, Permisos y Requerimientos

### 6.1 Matriz de Roles y Permisos (RF-01)
El sistema gestiona de forma diferenciada las funcionalidades según el rol del usuario autenticado:

| Módulo / Funcionalidad | Usuario Regular | Agente Inmobiliario | Administrador |
| :--- | :---: | :---: | :---: |
| Registrarse y Login | ✔️ | ✔️ | ✔️ |
| Buscar propiedades / Catálogo | ✔️ | ✔️ | ✔️ |
| Ver detalles con mapa Leaflet.js | ✔️ | ✔️ | ✔️ |
| Guardar favoritos (Comprador) | ✔️ | ✔️ | ❌ |
| Comparar inmuebles (máx. 4) | ✔️ | ✔️ | ❌ |
| Enviar consultas a agentes | ✔️ | ❌ | ❌ |
| Publicar / Editar sus propiedades | ❌ | ✔️ | ✔️ (Todas) |
| Ver analytics y reportes de vistas | ❌ | ✔️ | ❌ |
| Comprar / Upgrade de planes de pago | ❌ | ✔️ | ❌ |
| Moderar publicaciones y usuarios | ❌ | ❌ | ✔️ |
| Registrar/Editar ubicaciones en BD | ❌ | ❌ | ✔️ |

### 6.2 Tabla Comparativa de Planes de Publicación (RF-07)

| Característica | Plan Gratuito | Plan Básico | Plan Premium |
| :--- | :---: | :---: | :---: |
| **Costo Mensual** | S/. 0 | S/. 50 | S/. 150 |
| **Límite de Propiedades Activas**| 1 propiedad | 5 propiedades | 20 propiedades |
| **Duración de Publicación** | 30 días | 60 días | Ilimitado |
| **Cantidad Máxima de Fotos** | 3 fotos | 10 fotos | 30 fotos |
| **Visibilidad en Catálogo** | Estándar | Regular | Destacado (Badge especial) |
| **Analytics** | Básico (Vistas totales) | Completo (Gráficos) | Avanzado (Gráficos e insights) |
| **Soporte** | FAQ | Email | Prioritario |

### 6.3 Requerimientos Funcionales y No Funcionales
*   **RF-02 · Gestión de Propiedades**: Estados de publicación (Borrador, Activa, Pausada, Eliminada). Integración de Partida Registral SUNARP y Bonos Habitacionales.
*   **RF-03 · Búsqueda Bimonetaria**: Filtros acumulativos con lógica `AND` y mantenimiento de parámetros tras recargas.
*   **RF-04 · Visualización Geográfica**: Captura de coordenadas y renderizado de pines dinámicos en mapas.
*   **RF-05 · Leads**: Formularios de contacto, simulación de clics de WhatsApp y agendamiento de visitas.
*   **RF-06 · Comparador**: Detección inteligente de menor precio por $m^2$ y mejor relación dormitorios/costo.
*   **RF-08 · Analytics**: Registro histórico diario e insights de desempeño.
*   **RNF-01 · UX y Rendimiento**: Tiempo de carga inicial inferior a 3 segundos (Lighthouse performance > 70).
*   **RNF-02 · Seguridad**: Prevención de SQL Injection y Cross-Site Scripting (XSS). Encriptación de contraseñas.
*   **RNF-03 · Portabilidad**: Despliegue agnóstico en sistemas operativos que admitan JVM 17+.

---

## 🚀 7. Compilación y Despliegue

### Compilar Proyecto
```bash
./mvnw.cmd compile
```

### Inicializar Base de Datos
1.  Asegúrese de tener MySQL corriendo en el puerto por defecto (3306).
2.  Ejecute las sentencias de `inmobix_db.sql` en su cliente SQL preferido para crear el esquema e inyectar la semilla con fotos de demostración.

### Despliegue en Servidor
1.  Configure su servidor Apache Tomcat 10+ apuntando el archivo WAR o directorio de despliegue al contexto `/proyectoweb` o raíz `/`.
2.  Inicie el servidor y acceda desde `http://localhost:8080/proyectoweb`.
