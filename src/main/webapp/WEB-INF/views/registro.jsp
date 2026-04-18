<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Registrar Propiedad</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <script src="${pageContext.request.contextPath}/assets/js/main.js" defer></script>
</head>
<body>
    <header>
        <h1>Publicar Propiedad</h1>
    </header>
    <nav>
        <a href="${pageContext.request.contextPath}/index.jsp">Inicio</a>
        <a href="${pageContext.request.contextPath}/propiedades">Ver Propiedades</a>
        <a href="${pageContext.request.contextPath}/propiedades?accion=nuevo">Publicar Propiedad</a>
    </nav>
    <div class="form-container">
        <h2>Ingresa los datos del inmueble</h2>
        <% 
            String error = (String) request.getAttribute("error");
            if(error != null) { 
        %>
            <div class="error"><%= error %></div>
        <% } %>

        <form action="${pageContext.request.contextPath}/propiedades" method="post">
            <div class="form-group">
                <label>Título Breve:</label>
                <input type="text" name="titulo" required placeholder="Ej. Casa de 2 pisos con jardín">
            </div>
            <div class="form-group">
                <label>Descripción:</label>
                <textarea name="descripcion" rows="4" required placeholder="Describe las comodidades..."></textarea>
            </div>
            <div class="form-group">
                <label>Precio (US$):</label>
                <input type="number" step="0.01" name="precio" required placeholder="150000.00">
            </div>
            <div class="form-group">
                <label>Ubicación:</label>
                <input type="text" name="ubicacion" required placeholder="Ej. Lima, Miraflores">
            </div>
            <button type="submit">Guardar Propiedad</button>
        </form>
    </div>
</body>
</html>
