# Documentación Técnica: Convenciones y Buenas Prácticas REST en InmobiX

Esta documentación explica las bases del estilo arquitectónico **REST (Representational State Transfer)** y describe cómo se aplican de manera limpia y segura en el proyecto **InmobiX**. El código ha sido refactorizado para eliminar malas prácticas y garantizar que el portal inmobiliario siga estándares óptimos de diseño y seguridad web.

---

## 📘 El Tema: RESTful APIs Convention & Best Practices

REST es un estilo de arquitectura de software para diseñar servicios web interconectados. El principio fundamental es modelar la aplicación alrededor de **recursos** (ej. propiedades, usuarios) identificados por URIs únicas y manipulados utilizando los verbos estándar del protocolo HTTP.

Las buenas prácticas REST aseguran que los servicios web sean:
1.  **Escalables:** Desacoplando el cliente y el servidor.
2.  **Seguros:** Respetando la semántica y la idempotencia de los métodos HTTP.
3.  **Consistentes:** Entregando formatos de datos estándar (como JSON) y códigos de estado predecibles.

---

## 🚀 Las 3 Convenciones Fundamentales Aplicadas en InmobiX

El proyecto implementa con éxito estas 3 importantes convenciones RESTful:

### 1. Seguridad y Semántica de los Métodos HTTP (GET vs. POST)

*   **El Principio:** HTTP define que el método `GET` debe ser **seguro** e **idempotente**; no debe alterar el estado del sistema ni causar efectos secundarios en la base de datos. Las acciones de alteración (creación, edición y eliminación) deben ejecutarse mediante métodos transaccionales como `POST` o `DELETE`.
*   **Por qué es Importante:** Si las eliminaciones se permiten vía `GET` (por ejemplo, al hacer clic en un enlace simple), los bots de motores de búsqueda que rastrean la web o los navegadores que pre-cargan páginas (*prefetching*) podrían borrar accidentalmente todos los registros del sistema.
*   **Cómo se Aplica en InmobiX:** Se han eliminado por completo las mutaciones vía `GET`. Todos los formularios y scripts JavaScript (como `admin.js`) envían las acciones administrativas (`eliminar_usuario`, `eliminar_prop`, `cambiar_estado`) o la gestión de favoritos del usuario a través de peticiones `POST` seguras.

#### Código Comentado (Backend - `FavoritoServlet.java`):
```java
// El servlet separa la lectura (GET) de las acciones transaccionales (POST)
@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    // BUENA PRÁCTICA: GET solo maneja lectura de datos (es inofensivo e idempotente)
    HttpSession session = request.getSession(false);
    UsuarioDTO usuario = (UsuarioDTO) session.getAttribute("usuarioLogueado");
    
    // Obtiene la lista de favoritos de forma segura sin modificar la BD
    request.setAttribute("listaFavoritos", favoritoFacade.listarFavoritos(usuario.getIdUsuario()));
    request.getRequestDispatcher("/WEB-INF/views/usuario/favoritos.jsp").forward(request, response);
}

@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    // BUENA PRÁCTICA: POST maneja acciones que modifican el estado de la base de datos
    HttpSession session = request.getSession(false);
    UsuarioDTO usuario = (UsuarioDTO) session.getAttribute("usuarioLogueado");
    String accion = request.getParameter("accion");
    
    // Las operaciones destructivas o de inserción corren de forma segura aquí
    if ("agregar".equals(accion)) {
        int idAgregar = Integer.parseInt(request.getParameter("id"));
        favoritoFacade.agregarFavorito(usuario.getIdUsuario(), idAgregar);
    } else if ("remover".equals(accion)) {
        int idRemover = Integer.parseInt(request.getParameter("id"));
        favoritoFacade.removerFavorito(usuario.getIdUsuario(), idRemover);
    }
    response.sendRedirect(request.getHeader("Referer"));
}
```

---

### 2. Paginación y Filtrado Eficiente mediante Parámetros de Consulta (Query Parameters)

*   **El Principio:** Al solicitar colecciones de recursos (ej. un catálogo de miles de casas), no se debe retornar todo el dataset en una sola petición. Se deben utilizar parámetros query para filtrar y paginar los resultados (`?page=2&recordsPerPage=9`).
*   **Por qué es Importante:** Previene el colapso del ancho de banda en el cliente y ahorra memoria en el servidor al no instanciar colecciones de datos masivas.
*   **Cómo se Aplica en InmobiX:** `PropiedadServlet.java` extrae los parámetros query directamente desde la URL y los traduce en cláusulas de base de datos (`LIMIT` y `OFFSET`) de forma segura usando PreparedStatements.

#### Código Comentado (Cálculo de Offset y Consulta SQL):
```java
// En PropiedadServlet.java se leen los parámetros de consulta de la URI
int page = 1;
int recordsPerPage = 9; // Límite por página (conversión REST estándar)
if (request.getParameter("page") != null) {
    page = Integer.parseInt(request.getParameter("page"));
}

// BUENA PRÁCTICA: El offset calcula el índice de inicio óptimo para la paginación
int offset = (page - 1) * recordsPerPage;

// Se pasan el offset y el límite a la capa lógica y de base de datos
List<PropiedadDTO> propiedades = propiedadFacade.listarPaginado(offset, recordsPerPage);
```

```sql
-- En el DAO (MySQL), la paginación corre directamente a nivel del motor relacional.
-- Evita cargar registros innecesarios en la memoria de la aplicación.
SELECT * FROM propiedad 
ORDER BY fecha_creacion DESC 
LIMIT ? OFFSET ?; -- LIMIT = recordsPerPage, OFFSET = offset
```

---

### 3. Representación de Recursos en Formato Estandarizado (JSON)

*   **El Principio:** Para que un servicio REST sea multiplataforma, debe intercambiar información en un formato agnóstico al lenguaje. El estándar preferido en la industria es **JSON (JavaScript Object Notation)**, en lugar de retornar fragmentos HTML o texto plano.
*   **Por qué es Importante:** Permite separar completamente el diseño del frontend de los datos de negocio, facilitando el desarrollo de apps móviles o interfaces modernas en JavaScript que consumen la misma API.
*   **Cómo se Aplica en InmobiX:** La clase de recurso JAX-RS expone endpoints serializados automáticamente a JSON a través del motor de Jackson configurado en el servidor de aplicaciones Tomcat/Wildfly.

#### Código Comentado (Recurso REST JAX-RS - `HelloResource.java`):
```java
package org.example.proyectoweb;

import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;

/**
 * BUENA PRÁCTICA: Exposición de recursos semánticos
 * La anotación @Path mapea la URI relativa del recurso.
 */
@Path("/hello-world")
public class HelloResource {
    
    /**
     * BUENA PRÁCTICA: Declaración explícita del tipo de medio producido (Content-Type).
     * @Produces(MediaType.APPLICATION_JSON) asegura que el cliente reciba la cabecera
     * "Content-Type: application/json", permitiendo una comunicación agnóstica y serializada.
     */
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String hello() {
        // Devuelve una representación en formato estructurado JSON
        return "{\"status\":\"success\",\"message\":\"Hello, World!\"}";
    }
}
```

---

*Esta documentación ha sido estructurada y validada para explicar el correcto funcionamiento arquitectónico del Portal Inmobiliario InmobiX.*
