<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es" class="scroll-smooth">
<head>
    <c:set var="pageTitle" value="Inmobix - Consulta Registrada" scope="request" />
    <jsp:include page="/WEB-INF/views/layout/head.jsp" />
</head>
<body class="bg-brandBg text-brandText min-h-screen flex flex-col justify-between font-body">

    <!-- Header / Navbar -->
    <c:set var="activePage" value="contacto" scope="request" />
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <!-- Main Content Success -->
    <main class="flex-grow flex items-center justify-center pt-28 pb-16 px-4">
        <div class="w-full max-w-md bg-white border border-slate-200 rounded-3xl p-8 md:p-10 text-center shadow-2xl shadow-slate-200/50">
            
            <!-- Success Icon -->
            <div class="w-20 h-20 bg-emerald-100 border border-emerald-300 rounded-full flex items-center justify-center mx-auto text-emerald-600 mb-6 shadow-lg shadow-emerald-500/10">
                <svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M5 13l4 4L19 7"></path>
                </svg>
            </div>

            <!-- Title -->
            <h1 class="text-3xl font-black text-slate-800 tracking-tight">¡Consulta Registrada!</h1>
            <p class="text-slate-500 mt-3 text-sm">El formulario se ha enviado correctamente a través de la arquitectura Java Web MVC.</p>

            <!-- Customer Detail Badge -->
            <div class="bg-slate-50 border border-slate-200 rounded-2xl p-4 my-6">
                <span class="text-xs text-slate-500 uppercase tracking-wider block">Interesado registrado</span>
                <span class="text-lg font-bold text-blue-600 block mt-1">
                    <c:out value="${cliente}" />
                </span>
            </div>

            <!-- Description -->
            <p class="text-xs text-slate-500 mb-8 leading-relaxed">
                Los datos ya están guardados en la tabla <strong>consultas</strong> de tu base de datos MySQL local y estarán visibles inmediatamente en el panel administrativo y en el panel de agentes.
            </p>

            <!-- Action Buttons for basic navigation -->
            <div class="flex flex-col sm:flex-row gap-4">
                <a href="${pageContext.request.contextPath}/consulta?accion=nueva" class="flex-1 py-3 px-4 border border-black text-black hover:bg-black/5 text-sm font-bold rounded-xl transition-all text-center">
                    Registrar Otro
                </a>
                <a href="${pageContext.request.contextPath}/index.jsp" class="flex-1 py-3 px-4 bg-brandBtn hover:bg-brandHover text-white text-sm font-bold rounded-xl shadow-lg shadow-brandBtn/20 transition-all text-center">
                    Ver Catálogo (JSP)
                </a>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />

</body>
</html>
