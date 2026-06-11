<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es" class="scroll-smooth">
<head>
    <c:set var="pageTitle" value="Inmobix - Nueva Consulta" scope="request" />
    <jsp:include page="/WEB-INF/views/layout/head.jsp" />
</head>
<body class="bg-brandBg text-brandText min-h-screen flex flex-col justify-between font-body">

    <!-- Header / Navbar -->
    <c:set var="activePage" value="contacto" scope="request" />
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <!-- Main Content Form -->
    <main class="flex-grow flex items-center justify-center pt-28 pb-16 px-4">
        <div class="w-full max-w-lg bg-white border border-slate-200 rounded-3xl p-8 md:p-10 shadow-2xl shadow-slate-200/50">
            
            <div class="text-center mb-8">
                <h1 class="text-3xl font-bold text-slate-800 tracking-tight">Formulario de Consulta</h1>
                <p class="text-slate-500 mt-2 text-sm">Envíanos tus consultas sobre cualquiera de nuestras propiedades disponibles en el catálogo.</p>
            </div>

            <!-- Error Banner -->
            <c:if test="${not empty error}">
                <div class="mb-6 bg-red-50 border-l-4 border-red-500 p-4 rounded-r-md">
                    <div class="flex">
                        <div class="flex-shrink-0">
                            <svg class="h-5 w-5 text-red-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
                            </svg>
                        </div>
                        <div class="ml-3">
                            <p class="text-sm text-red-700 font-medium">${error}</p>
                        </div>
                    </div>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/consulta" method="post" class="space-y-6">
                <input type="hidden" name="accion" value="registrarPublico">
                
                <!-- Select Propiedad Dinámico -->
                <div>
                    <label for="idPropiedad" class="block text-sm font-semibold text-slate-700 mb-2">Seleccionar Inmueble de Interés</label>
                    <select id="idPropiedad" name="idPropiedad" required
                            class="w-full px-4 py-3 bg-slate-50 border border-slate-300 rounded-xl text-slate-800 focus:outline-none focus:border-brandHover transition-colors appearance-none cursor-pointer">
                        <option value="">-- Seleccionar Propiedad --</option>
                        <c:forEach var="p" items="${propiedades}">
                            <option value="${p.id}">
                                <c:out value="${p.titulo}" /> (US$ <c:out value="${p.precioUsd}" />)
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Input Nombre -->
                <div>
                    <label for="nombre" class="block text-sm font-semibold text-slate-700 mb-2">Nombres y Apellidos</label>
                    <input type="text" id="nombre" name="nombre" required placeholder="Ingresa tu nombre completo"
                           class="w-full px-4 py-3 bg-slate-50 border border-slate-300 rounded-xl text-slate-800 focus:outline-none focus:border-brandHover transition-colors">
                </div>

                <!-- Input Correo -->
                <div>
                    <label for="email" class="block text-sm font-semibold text-slate-700 mb-2">Correo Electrónico</label>
                    <input type="email" id="email" name="email" required placeholder="ejemplo@correo.com"
                           class="w-full px-4 py-3 bg-slate-50 border border-slate-300 rounded-xl text-slate-800 focus:outline-none focus:border-brandHover transition-colors">
                </div>

                <!-- Input Teléfono -->
                <div>
                    <label for="telefono" class="block text-sm font-semibold text-slate-700 mb-2">Teléfono / Celular</label>
                    <input type="text" id="telefono" name="telefono" placeholder="Ej: +51 987654321"
                           class="w-full px-4 py-3 bg-slate-50 border border-slate-300 rounded-xl text-slate-800 focus:outline-none focus:border-brandHover transition-colors">
                </div>

                <!-- Input Mensaje -->
                <div>
                    <label for="mensaje" class="block text-sm font-semibold text-slate-700 mb-2">Mensaje / Consulta</label>
                    <textarea id="mensaje" name="mensaje" required rows="4" placeholder="Escribe tus dudas aquí..."
                              class="w-full px-4 py-3 bg-slate-50 border border-slate-300 rounded-xl text-slate-800 focus:outline-none focus:border-brandHover transition-colors"></textarea>
                </div>

                <!-- Submit Button -->
                <div class="pt-2">
                    <button type="submit" class="w-full py-4 bg-brandBtn hover:bg-brandHover text-white font-bold rounded-xl shadow-lg shadow-brandBtn/20 hover:shadow-brandBtn/30 transition-all cursor-pointer text-center">
                        Enviar Consulta
                    </button>
                </div>
            </form>
        </div>
    </main>

    <!-- Footer -->
    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />

</body>
</html>
