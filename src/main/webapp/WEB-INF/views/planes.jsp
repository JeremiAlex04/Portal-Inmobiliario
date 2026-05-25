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
        <script>
            tailwind.config = {
                theme: {
                    extend: {
                        colors: {
                            brandHeader: '#000000',
                            brandFooter: '#000000',
                            brandBtn: '#000000',
                            brandHover: '#71717A',
                            brandBg: '#FFFFFF',
                            brandText: '#0A0A0A'
                        }
                    }
                }
            }
        </script>
</head>
<body class="bg-brandBg text-brandText min-h-screen font-sans">
    <header class="text-white fixed w-full top-0 z-50 bg-black/90 backdrop-blur-md backdrop-blur-xl border-b border-white/10 shadow-lg">
        <div class="max-w-7xl mx-auto px-4 flex justify-between items-center h-16">
            <a href="${pageContext.request.contextPath}/index.jsp" class="flex items-center gap-2">
                <img src="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png" alt="Logo" class="h-8 brightness-0 invert">
                <span class="text-xl font-bold text-white">Inmobix</span>
            </a>
            <div class="flex items-center gap-4">
                <a href="${pageContext.request.contextPath}/propiedades" class="text-sm font-semibold text-white/80 hover:text-brandHover">Catálogo</a>
                <a href="${pageContext.request.contextPath}/pagos?accion=historial" class="text-sm font-semibold text-brandHover">Mis Pagos</a>
                <a href="${pageContext.request.contextPath}/usuario?accion=logout" class="bg-brandBtn hover:bg-brandHover text-white px-4 py-2 rounded-full text-sm font-bold">Salir</a>
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
                            <div class="absolute -top-4 left-1/2 -translate-x-1/2 bg-indigo-600 text-white px-4 py-1 rounded-full text-xs font-bold flex items-center gap-1">
                                <svg class="w-3 h-3 text-yellow-300 fill-current" viewBox="0 0 20 20">
                                    <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"></path>
                                </svg>
                                Recomendado
                            </div>
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
                            <li class="flex items-center gap-2">
                                <svg class="w-4 h-4 text-emerald-500 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M5 13l4 4L19 7"></path></svg>
                                ${plan.maxPropiedades} propiedades activas
                            </li>
                            <li class="flex items-center gap-2">
                                <svg class="w-4 h-4 text-emerald-500 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M5 13l4 4L19 7"></path></svg>
                                Hasta ${plan.maxFotos} fotos por propiedad
                            </li>
                            <li class="flex items-center gap-2">
                                <c:choose>
                                    <c:when test="${plan.destacada}">
                                        <svg class="w-4 h-4 text-emerald-500 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M5 13l4 4L19 7"></path></svg>
                                    </c:when>
                                    <c:otherwise>
                                        <svg class="w-4 h-4 text-slate-300 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M6 18L18 6M6 6l12 12"></path></svg>
                                    </c:otherwise>
                                </c:choose>
                                Publicaciones destacadas
                            </li>
                            <li class="flex items-center gap-2">
                                <c:choose>
                                    <c:when test="${plan.analytics}">
                                        <svg class="w-4 h-4 text-emerald-500 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M5 13l4 4L19 7"></path></svg>
                                    </c:when>
                                    <c:otherwise>
                                        <svg class="w-4 h-4 text-slate-300 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M6 18L18 6M6 6l12 12"></path></svg>
                                    </c:otherwise>
                                </c:choose>
                                Analytics avanzados
                            </li>
                        </ul>
                        <c:choose>
                            <c:when test="${plan.precioPen.doubleValue() == 0}">
                                <span class="block w-full text-center bg-slate-100 text-slate-500 py-3 rounded-xl font-bold">Plan Actual</span>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/pagos?accion=formulario&plan=${plan.id}" class="block w-full text-center bg-brandBtn hover:bg-brandHover text-white py-3 rounded-xl font-bold shadow-lg transition-all hover:-translate-y-0.5">Seleccionar Plan</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:forEach>
            </div>
        </div>
    </main>
</body>
</html>
