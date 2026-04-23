<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo/inmobix_logo.png">
    <title>Portal Inmobiliario - Inicio</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <script src="${pageContext.request.contextPath}/assets/js/main.js" defer></script>
</head>
<body>
    <header>
        <div class="header-container">
            <img src="${pageContext.request.contextPath}/assets/img/logo/inmobix_logo.png" alt="Inmobix Logo" class="header-logo">
            <h1 class="header-title">Inmobix</h1>
        </div>
    </header>
    <nav>
        <a href="${pageContext.request.contextPath}/index.jsp">Inicio</a>
        <a href="${pageContext.request.contextPath}/propiedades">Ver Propiedades</a>
        <a href="${pageContext.request.contextPath}/propiedades?accion=nuevo">Publicar Propiedad</a>
        <a href="${pageContext.request.contextPath}/contacto">Contacto</a>
        <a href="${pageContext.request.contextPath}/usuario?accion=registro">Registrarse</a>
    </nav>
    <div class="hero">
        <div class="hero-content">
            <h1>Encuentra el hogar de tus sueños</h1>
            <p>Descubre propiedades exclusivas en las mejores zonas.</p>
            <a href="${pageContext.request.contextPath}/propiedades" class="btn">Explorar Catálogo</a>
        </div>
    </div>
    <footer>
        <p>&copy; 2026 Portal Inmobiliario - Proyecto de Desarrollo Web</p>
    </footer>
</body>
</html>
