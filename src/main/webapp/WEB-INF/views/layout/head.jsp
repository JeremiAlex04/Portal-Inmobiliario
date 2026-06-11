<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png">
<title><c:out value="${not empty pageTitle ? pageTitle : 'Inmobix - Portal Inmobiliario'}" /></title>

<!-- Hojas de Estilos Personalizadas -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/estilosadic.css">

<!-- Configuración y script de Tailwind CSS Play CDN -->
<script src="https://cdn.tailwindcss.com"></script>
<script src="${pageContext.request.contextPath}/assets/js/tailwind-config.js"></script>

<!-- Google Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400..900;1,400..900&family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">

<!-- Script Base Compartido -->
<script src="${pageContext.request.contextPath}/assets/js/main.js" defer></script>
