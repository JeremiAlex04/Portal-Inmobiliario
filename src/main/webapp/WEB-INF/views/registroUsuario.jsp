<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link rel="icon" type="image/png"
          href="${pageContext.request.contextPath}/assets/img/logo/inmobix_logo.png">

    <title>Registro - Inmobix</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/styles.css">
</head>
<body>
<header>
    <div class="header-container">
        <img src="${pageContext.request.contextPath}/assets/img/logo/inmobix_logo.png"
             class="header-logo">
        <h1 class="header-title">Inmobix - Registro</h1>
    </div>
</header>
<nav>
    <a href="${pageContext.request.contextPath}/index.jsp">Inicio</a>
    <a href="${pageContext.request.contextPath}/propiedades">Ver Propiedades</a>
    <a href="${pageContext.request.contextPath}/usuario?accion=registro">Registrarse</a>
</nav>

<div class="container">

    <div class="form-container">

        <h2>Crear Cuenta</h2>

        <form action="${pageContext.request.contextPath}/usuario" method="post">

            <div class="form-group">
                <label>Nombre completo</label>
                <input type="text" name="nombre" required>
            </div>

            <div class="form-group">
                <label>Correo electrónico</label>
                <input type="email" name="email" required>
            </div>

            <div class="form-group">
                <label>Contraseña</label>
                <input type="password" name="password" required>
            </div>

            <button type="submit">Registrarse</button>

        </form>

        <!-- MENSAJES -->
        <c:if test="${not empty msg}">
            <div class="alert" style="color:green;">
                ${msg}
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert" style="color:red;">
                ${error}
            </div>
        </c:if>
        <p style="text-align:center; margin-top:15px;">
            ¿Ya tienes cuenta?
            <a href="${pageContext.request.contextPath}/index.jsp#login">
                Iniciar sesión           </a>
        </p>
    </div>
</div>

<footer>
    <p>&copy; 2026 Inmobix - Proyecto Web</p>
</footer>
</body>
</html>

