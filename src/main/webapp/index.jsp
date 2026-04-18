<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Portal Inmobiliario - Inicio</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <script src="${pageContext.request.contextPath}/assets/js/main.js" defer></script>
</head>
<body>
    <header>
        <h1>Mi Inmobiliaria</h1>
    </header>
    <nav>
        <a href="${pageContext.request.contextPath}/index.jsp">Inicio</a>
        <a href="${pageContext.request.contextPath}/propiedades">Ver Propiedades</a>
        <a href="${pageContext.request.contextPath}/propiedades?accion=nuevo">Publicar Propiedad</a>
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
