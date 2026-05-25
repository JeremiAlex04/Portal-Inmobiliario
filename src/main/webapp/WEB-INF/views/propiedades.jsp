<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo/inmobix_logo.png">
    <title>Propiedades Disponibles</title>
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
    <div class="container">
        
        <div class="flex-between">
             <h2>${not empty titulo_pagina ? titulo_pagina : 'Propiedades en Venta / Alquiler'}</h2>
        </div>

        <!-- Filter Bar -->
        <c:if test="${empty param.accion || param.accion != 'mis_propiedades'}">
        <div class="filter-bar">
            <form action="${pageContext.request.contextPath}/propiedades" method="get">
                <select name="filtro">
                    <option value="TODOS" ${filtroActual == 'TODOS' ? 'selected' : ''}>Todos</option>
                    <option value="VENTA" ${filtroActual == 'VENTA' ? 'selected' : ''}>Comprar</option>
                    <option value="ALQUILER" ${filtroActual == 'ALQUILER' ? 'selected' : ''}>Alquiler</option>
                    <option value="PROYECTO" ${filtroActual == 'PROYECTO' ? 'selected' : ''}>Proyectos</option>
                </select>
                <button type="submit" class="btn">Buscar</button>
            </form>
        </div>
        </c:if>

        <c:choose>
            <c:when test="${empty listaPropiedades}">
                <div class="alert alert-error">
                    No hay propiedades disponibles con el filtro seleccionado.
                </div>
            </c:when>
            <c:otherwise>
                <div class="grid">
                    <c:forEach var="propiedad" items="${listaPropiedades}">
                        <div class="card">
                            <img src="https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80" alt="Casa" class="card-image">
                            <div class="card-content">
                                <span class="card-badge">
                                    <c:choose>
                                        <c:when test="${propiedad.idTipoInmueble == 8}">PROYECTO</c:when>
                                        <c:otherwise><c:out value="${propiedad.operacion}" /></c:otherwise>
                                    </c:choose>
                                </span>
                                <h3><c:out value="${propiedad.titulo}" /></h3>
                                <p class="location">📍 <c:out value="${propiedad.ubicacion}" /></p>
                                <p><c:out value="${propiedad.descripcion}" /></p>
                                <div class="price">US$ <c:out value="${propiedad.precio}" /></div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

    </div>
</body>
</html>
