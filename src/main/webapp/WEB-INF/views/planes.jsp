<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png">
    <title>Inmobix - Planes de Publicación</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-slate-50 text-slate-800 min-h-screen font-sans">
    <header class="fixed w-full top-0 z-50 bg-white/80 backdrop-blur-xl border-b border-slate-200 shadow-sm">
        <div class="max-w-7xl mx-auto px-4 flex justify-between items-center h-16">
            <a href="${pageContext.request.contextPath}/index.jsp" class="flex items-center gap-2">
                <img src="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png" alt="Logo" class="h-8">
                <span class="text-xl font-bold text-slate-900">Inmobix</span>
            </a>
            <div class="flex items-center gap-4">
                <a href="${pageContext.request.contextPath}/propiedades" class="text-sm font-semibold text-slate-600 hover:text-blue-600">Catálogo</a>
                <a href="${pageContext.request.contextPath}/pagos?accion=historial" class="text-sm font-semibold text-blue-600">Mis Pagos</a>
                <a href="${pageContext.request.contextPath}/usuario?accion=logout" class="bg-slate-800 text-white px-4 py-2 rounded-full text-sm font-bold">Salir</a>
            </div>
        </div>
    </header>

    <main class="pt-24 pb-16 px-4">
        <div class="max-w-5xl mx-auto text-center">
            <h1 class="text-4xl font-extrabold text-slate-900 mb-4">Planes de Publicación</h1>
            <p class="text-slate-500 mb-12 text-lg">Elige el plan que mejor se adapte a tus necesidades inmobiliarias.</p>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                <c:forEach var="plan" items="${listaPlanes}">
                    <div class="relative bg-white rounded-2xl shadow-xl border ${plan.nombre == 'PREMIUM' ? 'border-indigo-400 ring-2 ring-indigo-200' : 'border-slate-100'} p-8 flex flex-col">
                        <c:if test="${plan.nombre == 'PREMIUM'}">
                            <div class="absolute -top-4 left-1/2 -translate-x-1/2 bg-indigo-600 text-white px-4 py-1 rounded-full text-xs font-bold">⭐ Recomendado</div>
                        </c:if>
                        <h3 class="text-2xl font-bold text-slate-900 mb-2">${plan.nombre}</h3>
                        <div class="mb-4">
                            <c:choose>
                                <c:when test="${plan.precioPen.doubleValue() == 0}">
                                    <span class="text-4xl font-black text-emerald-600">Gratis</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-4xl font-black text-slate-900">S/. <fmt:formatNumber value="${plan.precioPen}" type="number" maxFractionDigits="0"/></span>
                                    <span class="text-slate-500 text-sm">/mes</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <p class="text-slate-500 text-sm mb-6 flex-grow">${plan.descripcion}</p>
                        <ul class="text-left text-sm space-y-3 mb-8">
                            <li class="flex items-center gap-2"><span class="text-emerald-500 font-bold">✓</span> ${plan.maxPropiedades} propiedades activas</li>
                            <li class="flex items-center gap-2"><span class="text-emerald-500 font-bold">✓</span> Hasta ${plan.maxFotos} fotos por propiedad</li>
                            <li class="flex items-center gap-2">
                                <span class="${plan.destacada ? 'text-emerald-500' : 'text-slate-300'} font-bold">${plan.destacada ? '✓' : '✕'}</span>
                                Publicaciones destacadas
                            </li>
                            <li class="flex items-center gap-2">
                                <span class="${plan.analytics ? 'text-emerald-500' : 'text-slate-300'} font-bold">${plan.analytics ? '✓' : '✕'}</span>
                                Analytics avanzados
                            </li>
                        </ul>
                        <c:choose>
                            <c:when test="${plan.precioPen.doubleValue() == 0}">
                                <span class="block w-full text-center bg-slate-100 text-slate-500 py-3 rounded-xl font-bold">Plan Actual</span>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/pagos?accion=formulario&plan=${plan.id}" class="block w-full text-center ${plan.nombre == 'PREMIUM' ? 'bg-indigo-600 hover:bg-indigo-700' : 'bg-blue-600 hover:bg-blue-700'} text-white py-3 rounded-xl font-bold shadow-lg transition-all hover:-translate-y-0.5">Seleccionar Plan</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:forEach>
            </div>
        </div>
    </main>
</body>
</html>
