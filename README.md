# Avance de Proyecto Final: Portal Inmobiliario

## 🎯 Objetivo del Avance
El objetivo principal es implementar y evidenciar una estructura funcional utilizando Java Servlets, JSP y conexión a base de datos (JDBC) según los lineamientos requeridos para el avance de proyecto web. El proyecto es un Portal Inmobiliario para gestionar publicaciones de alquiler/venta de inmuebles.

## 💻 Tecnologías Utilizadas
* **Lenguaje:** Java 17
* **Framework Web:** Jakarta EE (Servlets 6.x, JSP, JSTL 3.x)
* **Acceso a Datos:** JDBC puro (`java.sql.*`) + MySQL Connector
* **Gestor de Dependencias:** Maven
* **Base de Datos:** MySQL

## 🚀 Pasos de Ejecución (Configuración Local)
1. **Clonar/Abrir el proyecto:** Abre la carpeta del proyecto en tu IDE preferido (VS Code, IntelliJ, Eclipse).
2. **Setup Base de Datos:**
   * Inicia tu motor MySQL local (por ejemplo usando XAMPP, WAMP o el servicio nativo).
   * Ejecuta el script `database.sql` (disponible en la raíz del proyecto) en gestores como phpMyAdmin, DBeaver o Workbench. Esto creará la BD `inmobiliaria_db` y su tabla con datos semilla.
3. **Revisar Credenciales:** Abre `src/main/java/org/example/proyectoweb/util/ConexionDB.java` y verifica que `USER` (por defecto `root`) y `PASSWORD` (por defecto `""`) correspondan a tu motor local de MySQL.
4. **Compilar y Desplegar:**
   * Ejecuta `mvn clean package`
   * Despliega la aplicación resultante (carpeta `target/proyectoweb-1.0-SNAPSHOT` o `.war`) en un contenedor web soportado (como Tomcat 10+). Si usas VS Code con Community Server Connectors, simplemente arrastra la carpeta/war al Tomcat.
5. **Acceso Web:** En tu navegador abre `http://localhost:8080/proyectoweb/index.jsp`.

## 📸 Evidencia de Resultados (Pautas)
*(Para el estudiante: Toma capturas de los siguientes puntos e inclúyelas en tu informe).*
1. **Configuración de Entorno:** Captura del proyecto desplegado en Tomcat.
2. **Patrón MVC (Vista y Servlet):** Captura de `/propiedades` cargada dinámicamente.
3. **Flujo de Envío (POST):** Captura guardando una nueva propiedad desde `/propiedades?accion=nuevo` (Formulario) hacia Servlet.
4. **Conexión a BD:** Captura demostrando en Workbench que el insert se hizo vía código JDBC desde `PropiedadDAO`.
