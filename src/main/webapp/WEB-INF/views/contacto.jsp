<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    
    </head>
    <body>
       <div class="form-container">

    <h2>Contacto</h2>

    <form action="${pageContext.request.contextPath}/contacto" method="post">

        <div class="form-group">
            <label>Nombre</label>
            <input type="text" name="nombre" required>
        </div>

        <div class="form-group">
            <label>Email</label>
            <input type="email" name="email" required>
        </div>

        <div class="form-group">
            <label>Mensaje</label>
            <textarea name="mensaje" required></textarea>
        </div>

        <button type="submit">Enviar</button>

    </form>

</div>
    </body>
</html>

