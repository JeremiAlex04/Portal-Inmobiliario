# Inmobix - PORTAL INMOBILIARIO (Avance de Proyecto Final 01)

## 🎯 Objetivo del Avance
El objetivo principal de este primer hito es establecer e implementar la infraestructura base del portal Inmobix, garantizando una arquitectura técnica completamente funcional. Esto incluye la conexión correcta a una base de datos mediante JDBC, el enrutamiento y procesamiento lógico a través de Servlets (diferenciando flujos GET/POST), y la presentación de resultados al usuario a través de vistas dinámicas JSP.

## 💻 Tecnologías Utilizadas
* **Lenguaje de Programación:** Java 17
* **Framework Web:** Jakarta EE 10 (Servlets 6.x, JSP, JSTL 3.x)
* **Gestor de Dependencias y Build:** Maven
* **Capa de Modelo y Datos:** JDBC puro (`java.sql.*`) sin ORM + MySQL Connector
* **Motor de Base de Datos:** MySQL 8.x

## 🚀 Pasos de Ejecución (Configuración Local)
1. **Clonar/Abrir el proyecto:** Abre la carpeta raíz del proyecto en tu IDE preferido (VS Code, IntelliJ, Eclipse).
2. **Setup Base de Datos:**
   * Inicia tu motor MySQL local (mediante XAMPP, WAMP o como servicio nativo).
   * Ejecuta el script `database.sql` (disponible en la raíz del proyecto) usando herramientas como Workbench, DBeaver o phpMyAdmin.
3. **Revisar Credenciales:** Abre el archivo `src/main/java/org/example/proyectoweb/util/ConexionDB.java` y verifica que las variables `USER` (por defecto `root`) y `PASSWORD` concuerden con las de tu entorno MySQL.
4. **Compilar y Desplegar (Tomcat):**
   * Ejecuta `mvn clean package` usando la terminal.
   * Despliega la aplicación generada en la carpeta de compilación (`.war`) dentro de un contenedor web soportado como Apache Tomcat 10+.
5. **Acceso Web:** Finalmente, interactúa con el proyecto abriendo `http://localhost:8080/proyectoweb/index.jsp` en tu navegador.

---

## 📸 Evidencia de Resultados (Capturas)

### 1. Configuración de Entorno
*Captura del proyecto desplegado exitosamente en Tomcat.*<br>
![Despliegue Tomcat](https://drive.google.com/uc?export=view&id=1y94NHX8BUn-8_Imy96vGNXfjYqzKjx99)

### 2. Patrón MVC (Vista y Servlet)
*Captura de la ruta `/propiedades` cargada dinámicamente con los datos listados.*<br>
![Vistas dinámicas MVC](https://drive.google.com/uc?export=view&id=1Cadbz23AQOzT9BCIyOGUWGPvS_Xrj5N_)

### 3. Flujo de Envío (POST)
*Captura guardando una nueva propiedad desde el formulario ruta `/propiedades?accion=nuevo` y su posterior redireccionamiento.*<br>
![Prueba Flujo POST](https://drive.google.com/uc?export=view&id=[TU_ID_AQUI])

### 4. Conexión a BD
*Captura en Workbench/DBeaver demostrando que la inserción o consulta se realizó directamente vía código JDBC desde el `PropiedadDAO`.*<br>
![Verificación Base de Datos](https://drive.google.com/uc?export=view&id=[TU_ID_AQUI])
