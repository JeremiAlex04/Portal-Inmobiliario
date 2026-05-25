<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo/inmobix_logo.png">
    <title>Iniciar Sesión - Inmobix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
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

<div class="container">
    <div class="form-container">
        <h2>Iniciar Sesión</h2>
        <form action="${pageContext.request.contextPath}/usuario" method="post">
            <input type="hidden" name="accion" value="login">
            <div class="form-group">
                <label>Correo electrónico</label>
                <input type="email" name="email" required>
            </div>
            <div class="form-group">
                <label>Contraseña</label>
                <input type="password" name="password" required>
            </div>
            <button type="submit" class="btn">Ingresar</button>
        </form>

        <c:if test="${not empty msg}">
            <div class="alert" style="color:green; margin-top:15px;">
                ${msg}
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert" style="color:red; margin-top:15px;">
                ${error}
            </div>
        </c:if>
        <p style="text-align:center; margin-top:15px;">
            ¿No tienes cuenta?
            <a href="${pageContext.request.contextPath}/usuario?accion=registro">
                Regístrate aquí
            </a>
        </p>
    </div>
</div>

<footer>
    <p>&copy; 2026 Inmobix - Proyecto Web</p>
</footer>
</body>
</html>
