InmobiX – Portal Inmobiliario
=================================

Objetivo del documento
----------------------
Este archivo sirve como guía de texto plano para el modelo NOTEBOOK LM. En él se describen las características principales del proyecto, su arquitectura, tecnologías usadas y los puntos clave que el modelo debe considerar al generar sugerencias, mejoras o extensiones.

Resumen del proyecto
--------------------
El proyecto es un portal inmobiliario académico que permite publicar, buscar, comparar y gestionar inmuebles. Está construido con la arquitectura MVC por capas utilizando Jakarta EE 10 y se despliega en Apache Tomcat 10.

Stack tecnológico
-----------------
- Lenguaje: Java 17
- Framework: Jakarta EE 10 (Servlets, JSP, JSTL, JSF)
- Servidor de aplicaciones: Apache Tomcat 10.x
- Base de datos: MySQL 8.x (acceso mediante JDBC)
- CSS: Tailwind CSS
- Mapas: Leaflet.js con OpenStreetMap
- Gráficos: Chart.js
- Gestión de dependencias: Maven Wrapper
- Pruebas: JUnit 5
- Seguridad: BCrypt para hash de contraseñas, control de acceso por roles (ADMIN, AGENTE, USUARIO)

Arquitectura (MVC por capas)
----------------------------
1. Vista: JSP + JSTL + EL (sin scriptlets) y archivos JSF.
2. Controlador: Servlets HTTP que reciben peticiones y delegan.
3. Fachada: Clases Facade que orquestan la lógica de negocio.
4. DAO: Clases DAO que ejecutan consultas SQL con PreparedStatement.
5. Base de datos: MySQL.

Estructura de carpetas (resumen)
---------------------------------
Portal-Inmobiliario/
├─ src/main/java/org/example/proyectoweb/
│   ├─ bean/          (Managed Beans JSF)
│   ├─ controller/    (Servlets)
│   ├─ dao/           (Acceso a datos con JDBC)
│   ├─ dto/           (Objetos de transferencia)
│   ├─ facade/        (Lógica de negocio)
│   └─ util/          (ConexionDB y utilidades)
├─ src/main/webapp/
│   ├─ WEB-INF/views/ (JSPs organizados por zonas: admin, agente, usuario, public)
│   ├─ assets/        (CSS, JS, imágenes, Tailwind, Leaflet, Chart.js)
│   ├─ index.jsp      (Página de inicio)
│   └─ uploads/       (Imágenes de propiedades)
├─ inmobix_db.sql      (Script de base de datos)
└─ pom.xml             (Dependencias Maven)

Principales componentes de código
---------------------------------
- bean.ConsultaBean: Managed bean que mantiene el estado de la vista de consultas.
- controller.*Servlet: Servlets que manejan peticiones y delegan a la capa de fachada.
- facade.*Facade: Orquestan la lógica de negocio y validan reglas antes de llamar a los DAO.
- dao.*DAO: Acceso directo a la base de datos usando PreparedStatement.
- dto.*DTO: Transferencia de datos entre capas.
- util.ConexionDB: Manejo de conexiones JDBC.
- HelloApplication: Configura la raíz del API REST bajo "/api".

Base de datos (esquema resumido)
--------------------------------
Tablas principales: usuarios (id, nombre, email, password, rol) y propiedades (id, titulo, descripcion, precio, direccion, distrito, tipo, agente_id). Existen tablas auxiliares para fotos, favoritos y analytics.

Compilación y despliegue
------------------------
1. Compilar: ./mvnw.cmd compile
2. Ejecutar pruebas: ./mvnw.cmd test
3. Generar el WAR: ./mvnw.cmd package
4. Copiar target/proyectoweb.war al directorio webapps de Tomcat y reiniciar.
5. Acceder mediante http://localhost:8080/proyectoweb

Seguridad y buenas prácticas
----------------------------
- Roles de usuario (ADMIN, AGENTE, USUARIO) gestionados en tabla usuarios.
- Contraseñas almacenadas con hash BCrypt.
- Uso de PreparedStatement para prevenir SQL Injection.
- Separación clara de responsabilidades por capas.
- Uso de Tailwind CSS para interfaces responsivas.
- Leaflet para mapas interactivos y Chart.js para dashboards.

Directrices para NOTEBOOK LM
---------------------------
Al generar sugerencias, NOTEBOOK LM debe:
1. Mantener la separación de capas (no mezclar lógica de negocio con código de presentación).
2. Proponer mejoras que respeten el patrón MVC, como introducir servicios adicionales en la capa de fachada o refactorizar DAO para usar un patrón Repository.
3. Recomendar prácticas de seguridad adicionales (por ejemplo, implementar tokens CSRF, validar entrada de usuario en el lado del cliente y servidor).
4. Sugerir mejoras de UI usando Tailwind sin romper la compatibilidad con los JSP existentes.
5. Proponer pruebas unitarias adicionales para la capa de DAO y fachada, preferiblemente usando una base de datos en memoria (H2) para CI.
6. Indicar posibles refactorizaciones de código repetitivo en los servlets o beans, como extraer lógica común a utilidades.
7. Aconsejar la actualización de dependencias a versiones estables más recientes cuando sea posible, manteniendo la compatibilidad con Java 17.
8. Ofrecer ideas de nuevas funcionalidades (por ejemplo, filtros avanzados, notificaciones por email, integración con API de geolocalización) y describir dónde deberían encajar dentro de la arquitectura.
9. Evitar introducir gráficos o diagramas en la respuesta; mantener todo en texto plano.
10. Proveer ejemplos de snippets de código en Java o JSP que puedan ser insertados directamente en los paquetes correspondientes.

Fin del documento de guía para NOTEBOOK LM.
