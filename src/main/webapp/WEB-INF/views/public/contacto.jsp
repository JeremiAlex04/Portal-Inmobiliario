<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es" class="scroll-smooth">
<head>
    <c:set var="pageTitle" value="Inmobix - Contacto" scope="request" />
    <jsp:include page="/WEB-INF/views/layout/head.jsp" />
</head>
<body class="bg-brandBg text-brandText flex flex-col min-h-screen font-sans">
    
    <!-- Navbar Premium con Glassmorphism -->
        <c:set var="activePage" value="contacto" scope="request" />
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <main class="flex-grow pt-28 pb-16 flex items-center justify-center px-4">
        <div class="w-full max-w-lg bg-white p-8 md:p-10 rounded-2xl shadow-xl shadow-slate-200/50 border border-slate-100">
            <div class="text-center mb-8">
                <h2 class="text-3xl font-bold text-slate-900 tracking-tight">Contáctanos</h2>
                <p class="text-slate-500 mt-2">¿Tienes dudas? Envíanos un mensaje y te responderemos a la brevedad.</p>
            </div>

            <c:if test="${not empty msg}">
                <div class="mb-6 rounded-lg border px-4 py-3 text-sm font-medium ${msgType == 'success' ? 'bg-emerald-50 border-emerald-200 text-emerald-700' : 'bg-red-50 border-red-200 text-red-700'}">
                    ${msg}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/contacto" method="post" class="space-y-6">
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2">Nombre completo</label>
                    <input type="text" name="nombre" required placeholder="Tu nombre" class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition-all text-slate-700 bg-slate-50 focus:bg-white placeholder-slate-400">
                </div>

                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2">Correo electrónico</label>
                    <input type="email" name="email" required placeholder="tu@correo.com" class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition-all text-slate-700 bg-slate-50 focus:bg-white placeholder-slate-400">
                </div>

                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2">Mensaje</label>
                    <textarea name="mensaje" rows="5" required placeholder="Escribe tu mensaje aquí..." class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition-all text-slate-700 bg-slate-50 focus:bg-white placeholder-slate-400 resize-y"></textarea>
                </div>

                <div class="pt-4">
                    <button type="submit" class="w-full bg-brandBtn hover:bg-brandHover text-white font-bold py-3.5 px-4 rounded-lg shadow-lg shadow-brandBtn/20 transition-all hover:-translate-y-0.5 active:translate-y-0">
                        Enviar Mensaje
                    </button>
                </div>
            </form>
        </div>
    </main>

    <!-- Footer -->
    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
</body>
</html>
