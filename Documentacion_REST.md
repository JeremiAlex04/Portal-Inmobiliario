# RESTful APIs: Convention & Best Practices
## Documentación del Tema y su Aplicación en el Proyecto InmobiX

---

## 1. Introducción

### ¿Qué es REST?

**REST** (Representational State Transfer) es un estilo de arquitectura de software para sistemas distribuidos, definido por Roy Fielding en su tesis doctoral en el año 2000. Establece un conjunto de restricciones que, al ser aplicadas al protocolo HTTP, permiten diseñar servicios web escalables, simples y desacoplados.

Una **API RESTful** es aquella que implementa estas restricciones para exponer recursos de forma estandarizada a través de la web.

### Principios Fundamentales

| Principio | Descripción |
|-----------|-------------|
| **Cliente-Servidor** | Separación entre la interfaz de usuario y el almacenamiento/procesamiento de datos |
| **Sin estado (Stateless)** | Cada petición HTTP contiene toda la información necesaria para ser procesada |
| **Interfaz uniforme** | Uso consistente de URIs, verbos HTTP y códigos de estado |
| **Sistema de capas** | El cliente no distingue si se comunica con el servidor final o un intermediario |

### Proyecto de Referencia

**InmobiX** es un portal inmobiliario desarrollado en **Java/Jakarta EE** que implementa estas convenciones utilizando:
- **Jakarta Servlets** (`HttpServlet`) para el manejo de peticiones HTTP
- **JAX-RS (Jersey)** para endpoints REST con respuestas JSON
- **JSPs** para las vistas del frontend
- **MySQL** como base de datos relacional

---

## 2. Convención 1: Uso Correcto de los Verbos HTTP (GET / POST)

### Definición Teórica

La especificación HTTP define que cada verbo tiene una **semántica precisa** que debe respetarse:

| Verbo | Propósito | ¿Seguro? | ¿Idempotente? |
|-------|-----------|----------|---------------|
| **GET** | Obtener/leer datos sin alterar el servidor | ✅ Sí | ✅ Sí |
| **POST** | Crear recursos o ejecutar acciones con efectos secundarios | ❌ No | ❌ No |
| **PUT** | Reemplazar completamente un recurso existente | ❌ No | ✅ Sí |
| **DELETE** | Eliminar un recurso del servidor | ❌ No | ✅ Sí |

**Regla fundamental:**
> Las operaciones `GET` **nunca deben modificar datos** en el servidor. Son operaciones de solo lectura. Cualquier acción que cree, modifique o elimine un recurso debe usar `POST`, `PUT` o `DELETE`.

**¿Por qué es crítico?**
- Los navegadores modernos realizan **prefetch** de enlaces `GET` para mejorar la velocidad: un enlace de eliminación por `GET` podría ejecutarse sin intervención del usuario.
- Los motores de búsqueda (Google, Bing) rastrean enlaces `<a href>`. Si un enlace `GET` elimina datos, un crawler podría vaciar la base de datos.
- Las peticiones `GET` pueden ser **cacheadas** por proxies o CDNs, produciendo comportamientos impredecibles.

### Implementación en InmobiX

El proyecto separa de forma estricta las operaciones de **lectura** (GET) y **escritura** (POST) en todos sus controladores.

#### a) Servlet de Favoritos (`FavoritoServlet.java`)

El método `doGet` se reserva exclusivamente para **listar** los favoritos del usuario (lectura segura), mientras que `doPost` procesa las acciones de **agregar** y **remover** (modificación de datos):

```java
@WebServlet("/favorito")
public class FavoritoServlet extends HttpServlet {

    // GET — Solo lectura: listar favoritos (operación segura, sin efectos secundarios)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        UsuarioDTO usuario = (UsuarioDTO) session.getAttribute("usuarioLogueado");

        request.setAttribute("listaFavoritos",
                favoritoFacade.listarFavoritos(usuario.getIdUsuario()));
        request.getRequestDispatcher("/WEB-INF/views/usuario/favoritos.jsp")
                .forward(request, response);
    }

    // POST — Escritura: agregar y remover favoritos (operaciones con efectos secundarios)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UsuarioDTO usuario = (UsuarioDTO) session.getAttribute("usuarioLogueado");
        String accion = request.getParameter("accion");

        switch (accion) {
            case "agregar":
                int idAgregar = Integer.parseInt(request.getParameter("id"));
                favoritoFacade.agregarFavorito(usuario.getIdUsuario(), idAgregar);
                break;
            case "remover":
                int idRemover = Integer.parseInt(request.getParameter("id"));
                favoritoFacade.removerFavorito(usuario.getIdUsuario(), idRemover);
                break;
        }
    }
}
```

#### b) Panel Administrativo (`AdminServlet.java`)

Las operaciones críticas de administración como eliminar usuarios, cambiar roles y estados, y eliminar propiedades se ejecutan exclusivamente mediante `POST`:

```java
@WebServlet("/admin")
public class AdminServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UsuarioDTO admin = validarAdmin(request, response);
        String accion = request.getParameter("accion");

        switch (accion) {
            // Operación destructiva — POST obligatorio
            case "eliminar_usuario":
                int idEliminar = Integer.parseInt(request.getParameter("id"));
                usuarioFacade.eliminarUsuario(idEliminar);
                response.sendRedirect("admin?accion=usuarios&mensaje=eliminado");
                break;

            // Cambio de estado — POST obligatorio
            case "cambiar_estado":
                int idEstado = Integer.parseInt(request.getParameter("id"));
                int nuevoEstado = Integer.parseInt(request.getParameter("estado"));
                usuarioFacade.cambiarEstadoUsuario(idEstado, nuevoEstado);
                response.sendRedirect("admin?accion=usuarios");
                break;

            // Cambio de rol — POST obligatorio
            case "cambiar_rol":
                int idRolUser = Integer.parseInt(request.getParameter("id"));
                int nuevoRol = Integer.parseInt(request.getParameter("rol"));
                usuarioFacade.cambiarRolUsuario(idRolUser, nuevoRol);
                response.sendRedirect("admin?accion=usuarios");
                break;
        }
    }
}
```

#### c) Frontend — Formularios POST Dinámicos (`admin.js`)

En el frontend, las acciones destructivas se envían al servidor mediante formularios `POST` creados dinámicamente por JavaScript, evitando el uso de enlaces `GET`:

```javascript
// Envía una petición POST dinámica en lugar de redirigir por GET
function confirmarEliminacion(formAction, params) {
    if (confirm("¿Estás seguro que deseas ELIMINAR permanentemente este elemento?")) {
        var form = document.createElement('form');
        form.method = 'POST';
        form.action = formAction;

        for (var key in params) {
            if (params.hasOwnProperty(key)) {
                var input = document.createElement('input');
                input.type = 'hidden';
                input.name = key;
                input.value = params[key];
                form.appendChild(input);
            }
        }
        document.body.appendChild(form);
        form.submit();
    }
}
```

Y en las vistas JSP, los botones de favoritos usan formularios inline con método `POST`:

```html
<!-- Vista public/propiedades.jsp — Botón de favoritos con POST -->
<form action="${pageContext.request.contextPath}/favorito" method="POST">
    <input type="hidden" name="accion" value="agregar">
    <input type="hidden" name="id" value="${propiedad.id}">
    <button type="submit" title="Guardar en favoritos">❤</button>
</form>
```

---

## 3. Convención 2: Códigos de Estado HTTP Apropiados

### Definición Teórica

Cada respuesta HTTP debe incluir un **código de estado** numérico que comunique al cliente el resultado de su petición de forma estandarizada:

| Rango | Categoría | Significado |
|-------|-----------|-------------|
| **2xx** | Éxito | La petición fue recibida y procesada correctamente |
| **3xx** | Redirección | El cliente debe realizar una acción adicional |
| **4xx** | Error del cliente | La petición tiene un problema (autenticación, permisos, recurso inexistente) |
| **5xx** | Error del servidor | El servidor falló al procesar la petición |

**Códigos más importantes en APIs REST:**

| Código | Nombre | Uso |
|--------|--------|-----|
| `200 OK` | Éxito | Respuesta exitosa para GET, PUT |
| `201 Created` | Recurso creado | Respuesta exitosa para POST de creación |
| `301/302` | Redirección | El recurso se movió o se redirige tras una acción POST exitosa |
| `400 Bad Request` | Datos inválidos | Validación fallida del lado del cliente |
| `401 Unauthorized` | No autenticado | El usuario no ha iniciado sesión |
| `403 Forbidden` | Sin permisos | El usuario autenticado no tiene el rol necesario |
| `404 Not Found` | No existe | El recurso solicitado no existe en el servidor |
| `500 Internal Server Error` | Error interno | Excepción no controlada en el servidor |

### Implementación en InmobiX

El proyecto utiliza códigos HTTP semánticos en cada punto de decisión de sus controladores:

#### a) Error 403 — Forbidden (Acceso Denegado por Rol)

Cuando un usuario autenticado intenta acceder al panel de administración sin tener el rol de administrador (`idRol = 5`), el servidor responde con un **403 Forbidden**:

```java
// AdminServlet.java — Validación de acceso por roles
private UsuarioDTO validarAdmin(HttpServletRequest request, HttpServletResponse response)
        throws IOException {
    HttpSession session = request.getSession(false);
    if (session == null || session.getAttribute("usuarioLogueado") == null) {
        response.sendRedirect(request.getContextPath() + "/usuario?accion=login");
        return null;
    }
    UsuarioDTO usuario = (UsuarioDTO) session.getAttribute("usuarioLogueado");
    if (usuario.getIdRol() != 5) {
        // HTTP 403: El usuario está autenticado pero NO tiene permisos
        response.sendError(HttpServletResponse.SC_FORBIDDEN,
                "Acceso denegado. Se requiere rol de Administrador.");
        return null;
    }
    return usuario;
}
```

#### b) Error 404 — Not Found (Recurso Inexistente)

Cuando se solicita una propiedad que no existe en la base de datos, el servidor responde con un **404 Not Found**:

```java
// PropiedadServlet.java — Recurso no encontrado
case "ver":
    int idVer = Integer.parseInt(request.getParameter("id"));
    PropiedadDTO pVer = propiedadFacade.obtenerPropiedad(idVer);

    if (pVer != null) {
        request.setAttribute("propiedad", pVer);
        request.getRequestDispatcher("/WEB-INF/views/public/detalle_propiedad.jsp")
                .forward(request, response);
    } else {
        // HTTP 404: La propiedad solicitada no existe
        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Propiedad no encontrada");
    }
    break;
```

#### c) Error 500 — Internal Server Error (Fallo del Servidor)

Cuando ocurre una excepción inesperada durante el procesamiento, el servidor comunica un **500 Internal Server Error**:

```java
// PropiedadServlet.java — Manejo global de excepciones
try {
    switch (accion) {
        case "listar": ...
        case "ver": ...
    }
} catch (Exception e) {
    e.printStackTrace();
    // HTTP 500: Error inesperado del servidor
    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
            "Error procesando la solicitud");
}
```

#### d) Redirección 302 — Post/Redirect/Get (PRG)

Tras completar una operación POST exitosa (eliminar, cambiar estado), el servidor emite una **redirección 302** para prevenir el reenvío del formulario al refrescar el navegador. Este patrón se conoce como **Post/Redirect/Get (PRG)**:

```java
// AdminServlet.java — Redirección tras operación POST exitosa
case "eliminar_usuario":
    int idEliminar = Integer.parseInt(request.getParameter("id"));
    usuarioFacade.eliminarUsuario(idEliminar);

    // HTTP 302: Redirige al listado para evitar reenvío del formulario
    response.sendRedirect(request.getContextPath() + "/admin?accion=usuarios");
    break;
```

---

## 4. Convención 3: Paginación y Filtrado mediante Query Parameters

### Definición Teórica

Las APIs RESTful deben permitir a los clientes **controlar el volumen de datos** que reciben del servidor. Para ello se utilizan **parámetros de consulta** (query parameters) en la URL, sin alterar la ruta base del recurso:

| Tipo | Ejemplo de URL | Propósito |
|------|---------------|-----------|
| **Paginación** | `GET /propiedades?page=2&size=10` | Devolver un subconjunto de resultados por página |
| **Filtrado** | `GET /propiedades?tipo=Casa&operacion=VENTA` | Restringir resultados por criterios específicos |
| **Búsqueda** | `GET /propiedades?q=miraflores` | Buscar por palabra clave en campos de texto |
| **Combinado** | `GET /propiedades?q=casa&tipo=Departamento&page=3` | Aplicar múltiples criterios simultáneamente |

**¿Por qué es importante?**
- **Rendimiento:** Evita transferir miles de registros cuando el usuario solo necesita 10.
- **Eficiencia en BD:** Permite usar `LIMIT` y `OFFSET` en las consultas SQL.
- **Experiencia de Usuario:** Facilita la navegación entre páginas de resultados.

### Implementación en InmobiX

#### a) Controlador — Captura de Parámetros (`PropiedadServlet.java`)

El servlet de propiedades captura y procesa 7 parámetros de filtrado más la paginación, todo desde la URL sin alterar la ruta base `/propiedades`:

```java
// PropiedadServlet.java — Paginación y filtrado avanzado
case "listar":
default:
    // Captura de filtros desde query parameters
    String keyword      = request.getParameter("q");           // ?q=miraflores
    String operacion    = request.getParameter("operacion");   // ?operacion=VENTA
    String tipoInmueble = request.getParameter("tipo");        // ?tipo=Casa
    String precioMinStr = request.getParameter("precioMin");   // ?precioMin=100000
    String precioMaxStr = request.getParameter("precioMax");   // ?precioMax=500000
    String dormitoriosStr = request.getParameter("dormitorios"); // ?dormitorios=3
    String banosStr     = request.getParameter("banos");       // ?banos=2

    // Conversión segura de tipos numéricos
    BigDecimal precioMin = null, precioMax = null;
    Integer dormitorios = null, banos = null;
    try { if (precioMinStr != null && !precioMinStr.isEmpty())
              precioMin = new BigDecimal(precioMinStr);
    } catch(Exception ignored) {}
    // ... (conversiones similares para los demás parámetros)

    // Cálculo de paginación
    int page = 1;
    int recordsPerPage = 10;
    if (request.getParameter("page") != null) {
        page = Integer.parseInt(request.getParameter("page"));
    }
    int offset = (page - 1) * recordsPerPage;

    // Consulta paginada y filtrada a la capa de negocio
    List<PropiedadDTO> listaPropiedades = propiedadFacade.buscarPropiedadesAvanzado(
            keyword, operacion, tipoInmueble,
            precioMin, precioMax, dormitorios, banos,
            offset, recordsPerPage);

    // Cálculo de total de páginas para la navegación
    int totalRecords = propiedadFacade.contarPropiedadesAvanzado(
            keyword, operacion, tipoInmueble,
            precioMin, precioMax, dormitorios, banos);
    int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

    // Atributos para la vista
    request.setAttribute("listaPropiedades", listaPropiedades);
    request.setAttribute("currentPage", page);
    request.setAttribute("totalPages", totalPages);
    break;
```

#### b) Capa de Datos — Consulta SQL Optimizada

Los parámetros de paginación se trasladan directamente a la consulta SQL mediante `LIMIT` y `OFFSET`, lo que garantiza que la base de datos solo procese las filas necesarias:

```sql
-- Consulta paginada y filtrada en MySQL
SELECT * FROM propiedad
WHERE estado = 'activo'
  AND (titulo LIKE ? OR descripcion LIKE ?)   -- Búsqueda por keyword
  AND operacion = ?                            -- Filtro por operación
  AND tipo_inmueble = ?                        -- Filtro por tipo
  AND precio_usd BETWEEN ? AND ?               -- Rango de precios
  AND num_dormitorios >= ?                     -- Filtro de dormitorios
  AND num_banos >= ?                           -- Filtro de baños
LIMIT ?                                        -- recordsPerPage = 10
OFFSET ?                                       -- (page - 1) * recordsPerPage
```

#### c) Ejemplo de URL Completa en el Proyecto

La siguiente URL combina paginación, búsqueda y filtrado de forma RESTful:

```
GET /propiedades?q=moderno&operacion=VENTA&tipo=Departamento&precioMin=50000&precioMax=200000&dormitorios=2&banos=1&page=2
```

Esta petición:
1. Busca propiedades que contengan "moderno" en su título o descripción
2. Filtra por operación de venta
3. Filtra por tipo Departamento
4. Establece un rango de precio entre $50,000 y $200,000 USD
5. Requiere al menos 2 dormitorios y 1 baño
6. Devuelve la página 2 de resultados (registros 11 al 20)

---

## 5. Resumen de Convenciones Aplicadas

| # | Convención REST | Implementación en InmobiX |
|---|----------------|---------------------------|
| 1 | **Uso correcto de verbos HTTP** | `GET` reservado para lectura; `POST` obligatorio para eliminaciones, cambios de estado y modificaciones de datos. Frontend alineado con formularios POST dinámicos. |
| 2 | **Códigos de estado HTTP apropiados** | `403 Forbidden` para acceso denegado por rol; `404 Not Found` para recursos inexistentes; `500 Internal Server Error` para excepciones; `302` para redirección Post/Redirect/Get. |
| 3 | **Paginación y filtrado por query params** | 7 filtros combinables + paginación con `page` y `offset`, trasladados a consultas SQL con `LIMIT/OFFSET` para eficiencia en base de datos. |

---

*Documento elaborado para la presentación académica sobre RESTful APIs: Convention & Best Practices.*
*Proyecto de referencia: InmobiX — Portal Inmobiliario (Java/Jakarta EE + MySQL).*
