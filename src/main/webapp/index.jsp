<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
            <div class="header-brand">
                <img src="${pageContext.request.contextPath}/assets/img/logo/inmobix_logo.png" alt="Inmobix Logo" class="header-logo">
                <h1 class="header-title">Inmobix</h1>
            </div>
            <nav>
                <a href="${pageContext.request.contextPath}/index.jsp">Inicio</a>
                <a href="${pageContext.request.contextPath}/propiedades">Catálogo</a>
                <a href="${pageContext.request.contextPath}/propiedades?accion=nuevo">Publicar</a>
                <c:if test="${not empty sessionScope.usuario}">
                    <a href="${pageContext.request.contextPath}/propiedades?accion=mis_propiedades">Mis Propiedades</a>
                    <a href="${pageContext.request.contextPath}/usuario?accion=logout" class="btn btn-outline" style="padding: 6px 12px; margin-left: 10px;">Cerrar Sesión</a>
                </c:if>
                <c:if test="${empty sessionScope.usuario}">
                    <a href="${pageContext.request.contextPath}/usuario?accion=login" style="margin-left: 10px;">Login</a>
                    <a href="${pageContext.request.contextPath}/usuario?accion=registro" class="btn" style="padding: 6px 12px; color: white !important;">Registrarse</a>
                </c:if>
            </nav>
        </div>
    </header>
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
