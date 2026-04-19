# Inmobix - PORTAL INMOBILIARIO

## 1. Descripción General del Sistema
InmobiX es una plataforma web diseñada para transformar la experiencia de búsqueda, publicación y gestión de inmuebles en el Perú. El sistema actúa como un ecosistema digital que conecta a compradores, arrendatarios, agentes inmobiliarios y empresas desarrolladoras. A diferencia de portales convencionales, InmobiX está optimizado para la realidad del mercado local, integrando una lógica bimonetaria (Soles/dólares), segmentación por distritos y urbanizaciones, y cumplimiento estricto con la normativa peruana de protección de datos personales.

## 2. Arquitectura y Tecnologías
Para garantizar la escalabilidad y el orden técnico exigido, el sistema se ha construido utilizando **Java (Jakarta EE 10)**, adoptando el patrón de diseño clásico MVC (Modelo-Vista-Controlador). Esta elección permite una separación clara de responsabilidades:

* **Capa de Presentación (Vista):** Desarrollada con **JSP (JavaServer Pages) y JSTL 3.x** para generar interfaces dinámicas que responden a los datos procesados por el servidor.
* **Capa de Control (Controlador):** Implementada mediante **Servlets 6.x**, encargados de gestionar el flujo de las solicitudes HTTP (diferenciando GET/POST), la validación de parámetros bidireccionales y la comunicación con la lógica de negocio.
* **Capa de Datos (Modelo):** Utiliza **JDBC puro (`java.sql.*`)** para establecer una conexión con el motor de base de datos relacional (**MySQL 8.x**), permitiendo la persistencia y recuperación de la información inmobiliaria de forma segura.
* **Gestor de Dependencias y Build:** Basado en **Maven**, estandarizando la compilación y empaquetamiento sobre **Java 17**.

## 3. Alcance del Primer Avance
Este primer hito del proyecto establece la infraestructura base del portal para cumplir con la rúbrica de evaluación, la cual incluye:

* **Configuración del Entorno:** Servidor Web Container (Apache Tomcat 10) correctamente configurado y despliegue exitoso del proyecto organizado por paquetes.
* **Gestión de Solicitudes:** Implementación de servlets operativos que diferencian flujos de consulta y registro de datos provenientes desde formularios.
* **Interfaz Dinámica:** Vistas JSP integradas funcionalmente que muestran resultados en tiempo real provenientes del procesamiento y envío del servlet.
* **Persistencia Inicial:** Conexión estable a la base de datos mediante JDBC, verificada mediante una prueba funcional de consulta e inserción de datos relacionales sin ORM.

---

## 🏗️ Requerimientos Funcionales (RF)
*Capacidades que el sistema debe ejecutar para satisfacer las necesidades del negocio en el mercado peruano.*

* **RF-01 · Gestión de Usuarios y Roles:** El sistema debe permitir el registro e inicio de sesión (OAuth: Google, Facebook, Apple). Se deben soportar los roles: Visitante, Comprador, Agente Inmobiliario (con validación de código PN/PJ del MVCS opcional), Constructora/Desarrolladora y Administrador. Incluye verificación de correo y recuperación de cuenta.
* **RF-02 · Publicación y Gestión "Localizada":** Los agentes/constructoras podrán gestionar fichas de propiedades con:
  * *Campos Perú:* Ubicación por Departamento, Provincia, Distrito y Urbanización/Asentamiento.
  * *Datos Técnicos:* Partida Registral (SUNARP), área ocupada/techada, número de dormitorios, baños, y cochera.
  * *Atributos Especiales:* Filtro para proyectos con Bono MiVivienda o Bono Verde.
  * *Multimedia:* Soporte para 30 fotos, video de YouTube/Vimeo y Tours 360°.
* **RF-03 · Motor de Búsqueda y Filtros Bimonetarios:** El sistema debe permitir búsquedas por texto libre con autocompletado de distritos peruanos.
  * *Filtros:* Tipo de inmueble, rango de precio (Soles y dólares con conversión según tipo de cambio del día), superficie y antigüedad.
  * *Alertas:* Notificaciones push/correo cuando aparezca una propiedad que coincida con búsquedas guardadas.
* **RF-04 · Visualización Geográfica Interactiva:** Integración con Google Maps para mostrar pines de propiedades. El usuario debe poder "Dibujar en el mapa" para delimitar una zona específica (ej. "Solo zonas cercanas a la Av. Javier Prado").
* **RF-05 · Contacto y Lead Management (WhatsApp Sync):** El visitante podrá contactar al anunciante vía formulario o botón directo de WhatsApp (primordial en Perú). Los usuarios registrados podrán agendar visitas directamente en el calendario del agente con recordatorios vía SMS.
* **RF-06 · Sistema de Favoritos y Comparador:** Guardado de propiedades en listas personalizadas. El sistema debe permitir la comparación técnica lado a lado de hasta 4 inmuebles, destacando diferencias en precio por m² y servicios.
* **RF-07 · Módulo Comercial y Pasarela Nacional:** Gestión de planes (Gratis, Destacado, Premium).
  * *Pagos Locales:* Integración con pasarelas como Culqi, Niubiz o Izipay.
  * *Métodos:* Soporte para Tarjetas, Yape, Plin y PagoEfectivo.
  * *Facturación:* Generación automática de Boletas y Facturas Electrónicas (CPE) mediante integración con OSE/PSE según normativa de la SUNAT.
* **RF-08 · Panel de Control (Analytics para Agentes):** Dashboard con métricas de rendimiento: impresiones de la ficha, clics en "Ver Teléfono", número de leads de WhatsApp y tasa de conversión mensual.

---

## ⚙️ Requerimientos No Funcionales (RNF)
*Atributos de calidad y restricciones técnicas para un sistema de alta disponibilidad.*

* **RNF-01 · Rendimiento y Carga (LCP):** El tiempo de carga (Largest Contentful Paint) no debe superar los 2.5 segundos en redes móviles 4G. Uso obligatorio de WebP para imágenes y carga diferida (lazy load).
* **RNF-02 · Seguridad y Protección de Datos (Perú):**
  * *Cifrado:* HTTPS/TLS 1.3 y hashing Bcrypt para credenciales.
  * *Legal:* Cumplimiento estricto de la Ley N° 29733 (Ley de Protección de Datos Personales de Perú). Implementación de cláusulas de consentimiento para el Banco de Datos Personales.
  * *Protección:* Implementación de cabeceras de seguridad y mitigación de OWASP Top 10.
* **RNF-03 · Escalabilidad y Arquitectura:** Diseño basado en microservicios o monolito modular capaz de escalar horizontalmente en AWS/Azure. La base de datos debe manejar réplicas de lectura para las consultas de búsqueda.
* **RNF-04 · Disponibilidad (SLA):** Garantizar un 99.9% de uptime. Backups automatizados diarios con retención de 30 días y capacidad de recuperación ante desastres (DRP) en zonas de disponibilidad distintas.
* **RNF-05 · Usabilidad y Accesibilidad:** Interfaz Mobile-First que cumpla con WCAG 2.1 Nivel AA. La navegación debe ser intuitiva para personas mayores (público recurrente en compra de inmuebles).
* **RNF-06 · Interoperabilidad (API Economy):** Exposición de una API RESTful documentada en Swagger. Debe permitir la integración con portales agregadores (ej. enviar feeds a Urbania o Adondevivir) y CRMs externos.
* **RNF-07 · Soporte Bimonetario (Multicurrency):** El sistema debe manejar internamente los precios en una moneda base y permitir la visualización dinámica en la otra moneda, consultando el Tipo de Cambio de la SBS o la SUNAT automáticamente cada mañana.

---

## 🚀 Pasos de Ejecución (Configuración Local)
*(Sección requerida para evaluación de rúbrica)*

1. **Clonar/Abrir el proyecto:** Abre la carpeta del proyecto en tu IDE preferido (VS Code, IntelliJ, Eclipse).
2. **Setup Base de Datos:**
   * Inicia tu motor MySQL local (por ejemplo usando XAMPP, WAMP o el servicio nativo).
   * Ejecuta el script `database.sql` (disponible en la raíz del proyecto) en gestores como phpMyAdmin, DBeaver o Workbench. Esto creará la BD `inmobiliaria_db` y su tabla con datos semilla.
3. **Revisar Credenciales:** Abre `src/main/java/org/example/proyectoweb/util/ConexionDB.java` y verifica que `USER` (por defecto `root`) y `PASSWORD` correspondan a tu motor local de MySQL.
4. **Compilar y Desplegar:**
   * Ejecuta `mvn clean package`
   * Despliega la aplicación resultante (carpeta `target/proyectoweb-1.0-SNAPSHOT` o `.war`) en un contenedor web soportado (como Tomcat 10+). Si usas VS Code con Community Server Connectors, arrastra la carpeta/war al Tomcat.
5. **Acceso Web:** En tu navegador abre `http://localhost:8080/proyectoweb/index.jsp`.

---

## 📸 Evidencia de Resultados (Capturas)

### 1. Configuración de Entorno
*Captura del proyecto desplegado exitosamente en Tomcat.*<br>
![Despliegue Tomcat](https://drive.google.com/uc?export=view&id=1y94NHX8BUn-8_Imy96vGNXfjYqzKjx99)

### 2. Patrón MVC (Vista y Servlet)
*Captura de la ruta `/propiedades` cargada dinámicamente con los datos listados.*<br>
![Vistas dinámicas MVC](https://drive.google.com/uc?export=view&id=1y94NHX8BUn-8_Imy96vGNXfjYqzKjx99)

### 3. Flujo de Envío (POST)
*Captura guardando una nueva propiedad desde el formulario ruta `/propiedades?accion=nuevo` y su posterior redireccionamiento.*<br>
![Prueba Flujo POST](https://drive.google.com/uc?export=view&id=[TU_ID_AQUI])

### 4. Conexión a BD
*Captura en Workbench/DBeaver demostrando que la inserción o consulta se realizó directamente vía código JDBC desde el `PropiedadDAO`.*<br>
![Verificación Base de Datos](https://drive.google.com/uc?export=view&id=[TU_ID_AQUI])
