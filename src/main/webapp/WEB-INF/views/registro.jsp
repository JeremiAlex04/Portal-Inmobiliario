<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo/inmobix_logo.png">
    <title>Registrar Propiedad</title>
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
    <div class="form-container">
        <h2>${not empty propiedad ? 'Editar Propiedad' : 'Ingresa los datos del inmueble'}</h2>
        <% 
            String error = (String) request.getAttribute("error");
            if(error != null) { 
        %>
            <div class="error"><%= error %></div>
        <% } %>

        <form action="${pageContext.request.contextPath}/propiedades" method="post">
            <c:if test="${not empty propiedad}">
                <input type="hidden" name="id" value="${propiedad.id}">
            </c:if>
            <div class="form-group">
                <label>Tipo de Operación:</label>
                <select name="operacion" required>
                    <option value="VENTA" ${propiedad.operacion == 'VENTA' && propiedad.idTipoInmueble != 8 ? 'selected' : ''}>Venta</option>
                    <option value="ALQUILER" ${propiedad.operacion == 'ALQUILER' ? 'selected' : ''}>Alquiler</option>
                    <option value="PROYECTO" ${propiedad.idTipoInmueble == 8 ? 'selected' : ''}>Proyecto</option>
                </select>
            </div>
            <div class="form-group">
                <label>Título Breve:</label>
                <input type="text" name="titulo" required placeholder="Ej. Casa de 2 pisos con jardín" value="<c:out value="${propiedad.titulo}" />">
            </div>
            <div class="form-group">
                <label>Descripción:</label>
                <textarea name="descripcion" rows="4" required placeholder="Describe las comodidades..."><c:out value="${propiedad.descripcion}" /></textarea>
            </div>
            <div class="form-group">
                <label>Precio (US$):</label>
                <input type="number" step="0.01" name="precio" required placeholder="150000.00" value="${propiedad.precio}">
            </div>
            <div class="form-group">
                <label>Ubicación:</label>
                <input type="text" name="ubicacion" required placeholder="Ej. Lima, Miraflores" value="<c:out value="${propiedad.ubicacion}" />">
            </div>
            <button type="submit" class="btn">${not empty propiedad ? 'Actualizar Propiedad' : 'Guardar Propiedad'}</button>
        </form>
    </div>
</body>
</html>
