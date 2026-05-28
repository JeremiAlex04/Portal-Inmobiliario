# InmobiX — Portal Inmobiliario
**Proyecto Académico · Arquitectura MVC por Capas · Jakarta EE**

Plataforma web para la publicación, búsqueda y comparación de inmuebles en el mercado peruano. Implementa el patrón MVC con separación estricta de responsabilidades mediante capas desacopladas.

---

## 1. Stack Tecnológico

| Componente | Tecnología |
| :--- | :--- |
| **Lenguaje** | Java 17 + Jakarta EE 10 |
| **Servidor** | Apache Tomcat 10.x |
| **Base de Datos** | MySQL 8.x con JDBC nativo |
| **Vistas** | JSP + JSTL 3.x + Expression Language |
| **Estilos** | Tailwind CSS |
| **Mapas** | Leaflet.js + OpenStreetMap |
| **Gráficos** | Chart.js |
| **Build** | Maven Wrapper |

---

## 2. Arquitectura MVC por Capas

| Capa | Paquete | Función |
| :--- | :--- | :--- |
| **Vista** | webapp/WEB-INF/views/ | Renderiza HTML con JSTL y EL. Sin scriptlets. |
| **Controlador** | controller/ | Servlets que reciben peticiones HTTP y gestionan sesiones. |
| **Fachada** | facade/ | Orquesta DAOs y aplica reglas de negocio. |
| **DAO** | dao/ | Ejecuta consultas SQL con PreparedStatement. |
| **DTO** | dto/ | Objetos planos para transportar datos entre capas. |
| **Utilidades** | util/ | Clase ConexionDB para gestión de conexiones JDBC. |

---

## 3. Diagramas del Sistema

### 3.1 Flujo de una operación MVC

Secuencia completa desde que el usuario envía un formulario hasta que recibe la respuesta renderizada:

```mermaid
sequenceDiagram
    autonumber
    actor Usuario
    participant V as Vista JSP
    participant C as Servlet
    participant D as DTO
    participant F as Facade
    participant A as DAO
    participant B as MySQL

    Usuario->>V: Envía formulario POST
    V->>C: Petición HTTP con parámetros
    C->>C: Valida campos obligatorios
    C->>D: Crea instancia DTO con datos
    C->>F: Invoca lógica de negocio
    F->>F: Valida reglas de negocio
    F->>A: Invoca método CRUD
    A->>B: Ejecuta PreparedStatement
    B-->>A: Retorna resultado
    A-->>F: Retorna estado
    F-->>C: Retorna confirmación
    C->>V: forward con atributos en request
    V-->>Usuario: Renderiza HTML con JSTL/EL
```

### 3.2 Infraestructura y viaje de la información

Comunicación física entre los componentes del sistema durante una petición con carga de imagen:

```mermaid
sequenceDiagram
    autonumber
    participant Nav as Navegador
    participant Tom as Tomcat 10
    participant App as App Java MVC
    participant Fs as uploads/propiedades/
    participant Jdbc as ConexionDB
    participant Db as MySQL 3306

    Nav->>Tom: Petición HTTP puerto 8080
    Tom->>App: Enruta al Servlet correspondiente

    alt Carga de imagen
        App->>Fs: Guarda archivo físico
        Fs-->>App: Retorna ruta relativa
    end

    App->>Jdbc: Solicita conexión
    Jdbc->>Db: Abre socket TCP puerto 3306
    Db-->>Jdbc: Conexión activa
    Jdbc-->>App: Objeto Connection

    App->>Db: Ejecuta SQL parametrizado
    Db-->>App: Retorna ResultSet

    App->>Jdbc: Cierra recursos en finally

    App->>Tom: forward al JSP
    Tom->>Nav: Respuesta HTTP con HTML compilado
```

### 3.3 Flujo del buscador inteligente

Normalización de la cadena de búsqueda autocompletada antes de consultar la base de datos:

```mermaid
graph TD
    A["Buscador: Miraflores Lima"] -->|GET /propiedades| B[PropiedadServlet]
    B --> C[PropiedadFacade]
    C --> D[PropiedadDAO]
    D --> E["cleanKeyword extrae solo Miraflores"]
    E --> F[(MySQL)]
    F --> D
    D --> C
    C --> B
    B --> G[propiedades.jsp]
    G --> H["Renderiza tarjetas con imágenes"]
```

---

## 4. Estructura de Carpetas

```text
Portal-Inmobiliario/
├── src/main/java/org/example/proyectoweb/
│   ├── bean/              # Managed Beans JSF
│   ├── controller/        # Servlets HTTP
│   ├── dao/               # Acceso a datos JDBC
│   ├── dto/               # Objetos de transferencia
│   ├── facade/            # Lógica de negocio
│   └── util/              # ConexionDB y utilidades
├── src/main/webapp/
│   ├── WEB-INF/views/
│   │   ├── admin/         # Panel de administración
│   │   ├── agente/        # Panel y registro del agente
│   │   ├── layout/        # Componente header.jsp
│   │   ├── public/        # Catálogo, detalle, comparador
│   │   └── usuario/       # Favoritos del comprador
│   ├── assets/            # CSS, JS, logos
│   ├── index.jsp          # Página de inicio
│   └── *.xhtml            # Vistas JSF
├── inmobix_db.sql         # Script de base de datos
└── pom.xml                # Dependencias Maven
```

---

## 5. Roles y Permisos

| Funcionalidad | Usuario | Agente | Admin |
| :--- | :---: | :---: | :---: |
| Buscar y ver propiedades | ✔ | ✔ | ✔ |
| Ver mapa interactivo | ✔ | ✔ | ✔ |
| Guardar favoritos | ✔ | ✔ | — |
| Comparar inmuebles | ✔ | ✔ | — |
| Enviar consultas | ✔ | — | — |
| Publicar propiedades | — | ✔ | ✔ |
| Ver analytics y gráficos | — | ✔ | — |
| Contratar planes | — | ✔ | — |
| Moderar usuarios y contenido | — | — | ✔ |
| Gestionar ubicaciones | — | — | ✔ |


---

## 6. Evidencias Visuales del Avance

A continuación se presentan las capturas de pantalla que sustentan la funcionalidad operativa del sistema:

1. **Página de inicio** — Buscador inteligente con autocompletado de distritos.
   ![Página de Inicio](./capturas_avance2/Pagina_Inicial.png)
2. **Catálogo con filtros** — Resultados filtrados por precio, tipo y distrito.
   ![Catálogo con Filtros](./capturas_avance2/catalogo_filtros.png)
3. **Detalle del inmueble** — Galería de fotos, descripción y mapa.
   ![Detalle del Inmueble 1](./capturas_avance2/detalle_inmueble_1.png)
   ![Detalle del Inmueble 2](./capturas_avance2/detalle_inmueble_2.png)
4. **Comparador** — Tabla comparativa con especificaciones y precios.
   ![Comparador](./capturas_avance2/comparador.png)
5. **Panel del agente** — Gráfico de visitas y control de publicaciones.
   ![Panel del Agente](./capturas_avance2/panel_agente.png)
6. **Panel de administración** — Dashboard con gestión de usuarios, propiedades y auditoría.
   ![Panel de Administración](./capturas_avance2/panel_admin.png)

---

## 7. Compilación y Despliegue

```bash
# Compilar
./mvnw.cmd compile

# Base de datos
# 1. Iniciar MySQL en puerto 3306
# 2. Importar inmobix_db.sql

# Despliegue
# Desplegar WAR en Tomcat 10+ con contexto /proyectoweb
# Acceder en http://localhost:8080/proyectoweb
```
