<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Propiedades Disponibles</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <script src="${pageContext.request.contextPath}/assets/js/main.js" defer></script>
</head>
<body>
    <header>
        <h1>Catálogo de Propiedades</h1>
    </header>
    <nav>
        <a href="${pageContext.request.contextPath}/index.jsp">Inicio</a>
        <a href="${pageContext.request.contextPath}/propiedades">Ver Propiedades</a>
        <a href="${pageContext.request.contextPath}/propiedades?accion=nuevo">Publicar Propiedad</a>
    </nav>
    <div class="container">
        
        <div style="display:flex; justify-content: space-between; align-items:center;">
             <h2>Propiedades en Venta / Alquiler</h2>
             <a href="${pageContext.request.contextPath}/propiedades?accion=nuevo" class="btn-add">+ Añadir Propiedad</a>
        </div>

        <c:choose>
            <c:when test="${empty listaPropiedades}">
                <div class="alert">
                    No hay propiedades agregadas o no se pudo conectar a la base de datos MySQL (JDBC).<br>
                    Verifica que MySQL esté corriendo y haya registros.
                </div>
            </c:when>
            <c:otherwise>
                <div class="grid">
                    <c:forEach var="propiedad" items="${listaPropiedades}">
                        <div class="card">
                            <h3><c:out value="${propiedad.titulo}" /></h3>
                            <p class="location">Ubicación: <c:out value="${propiedad.ubicacion}" /></p>
                            <p><c:out value="${propiedad.descripcion}" /></p>
                            <div class="price">US$ <c:out value="${propiedad.precio}" /></div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

    </div>
</body>
</html>
