# 🏢 Portal Inmobiliario "Inmobix" - Avance 01

## 🎯 Objetivo de la Evaluación
Validar e implementar la arquitectura **MVC (Modelo-Vista-Controlador)** junto al patrón **DAO** como cimiento del portal. El sistema garantiza el enrutamiento exitoso con base en verbos HTTP (GET/POST), el listado dinámico de datos y la persistencia segura en base de datos.

## 💻 Stack Tecnológico
| Capa | Tecnología | Desempeño en Arquitectura |
| :--- | :--- | :--- |
| **Backend** | Java 17, Jakarta EE 10 | Procesamiento lógico manejado íntegramente por `Servlets`. |
| **Frontend** | JSP, JSTL 3.x, HTML | Renderización dinámica de datos extraídos del controlador. |
| **Persistencia** | MySQL 8.x, JDBC Puro | Diseño de Modelo y `DAO` libre de ORMs. |
| **Infraestructura** | Maven, Apache Tomcat | Compilación y despliegue del proyecto (`.war`). |

## ⚙️ Flujo de Datos (Arquitectura)
```mermaid
sequenceDiagram
    participant V as Vista (JSP)
    participant C as Controlador (Servlet)
    participant D as Modelo / DAO
    participant BD as MySQL (BD)
    V->>C: 1. Envía datos de formulario (POST)
    C->>D: 2. Solicita Guardar(Propiedad)
    D->>BD: 3. Ejecuta SQL (INSERT INTO)
    BD-->>D: 4. Confirma éxito
    D-->>C: 5. Retorna confirmación
    C->>V: 6. Redirige a lista actualizada
```

## 🚀 Despliegue Rápido (Local)
1. **Base de Datos:** Importe el script `database.sql` en su servidor MySQL. Confirme que las credenciales coinciden dentro del archivo fuente `ConexionDB.java`.
2. **Empaquetado:** Ejecute el comando estándar `mvn clean package` para compilar todo el árbol de dependencias del `pom.xml`.
3. **Servidor Web:** Deposite el compilado resultante en un contenedor **Apache Tomcat** (v10 o superior) e ingrese vía web a `http://localhost:8080/proyectoweb/index.jsp`.

---

## 📸 Evidencia de Resultados Estrictos (Rúbrica)

**1. Despliegue Exitoso en Apache Tomcat**  
*Evidencia del servidor y el proyecto arrancando sin arrojar excepciones.*
![Despliegue Tomcat](https://drive.google.com/uc?export=view&id=1y94NHX8BUn-8_Imy96vGNXfjYqzKjx99)

**2. Listado Dinámico MVC (Vista / Servlet)**  
*Prueba directa de comunicación `doGet` proyectando registros preexistentes.*
![Vistas dinámicas MVC](https://drive.google.com/uc?export=view&id=1Cadbz23AQOzT9BCIyOGUWGPvS_Xrj5N_)

**3. Flujo POST (Alta de Registro e Intercepción)**  
*Evidencia del envío de un formulario de propiedad y el posterior redireccionamiento orquestado por el controlador.*
![Prueba Flujo POST 1](https://drive.google.com/uc?export=view&id=1VbcJyKGq-AxGDtNbcv-m3wNLYTVEmpIj)
![Prueba Flujo POST 2](https://drive.google.com/uc?export=view&id=18zXkuNOPaNVOZz5HvQUg7ywWBeVsFzb2)

**4. Persistencia en Base de Datos (JDBC Puro)**  
*Verificación en el motor MySQL de que los métodos invocados en el `PropiedadDAO` insertaron físicamente las filas requeridas.*
![Verificación BD](https://drive.google.com/uc?export=view&id=1cQnmO-VQeq_7k9rD3w397_EpANEYDHSK)
