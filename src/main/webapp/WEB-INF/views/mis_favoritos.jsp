<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="es" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png">
    <title>Inmobix - Mis Favoritos</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-slate-50 text-slate-800 flex flex-col min-h-screen font-sans">
    
    <!-- Navbar -->
    <header class="fixed w-full top-0 z-50 bg-white/80 backdrop-blur-xl border-b border-slate-200 shadow-sm">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center h-20">
                <a href="${pageContext.request.contextPath}/index.jsp" class="flex items-center gap-3">
                    <img src="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png" alt="Logo" class="h-10 w-auto object-contain">
                    <span class="text-2xl font-bold text-slate-900">Inmobix</span>
                </a>
                <nav class="hidden md:flex items-center gap-6">
                    <a href="${pageContext.request.contextPath}/propiedades" class="text-sm font-semibold text-slate-600 hover:text-blue-600">Propiedades</a>
                    <a href="${pageContext.request.contextPath}/favorito?accion=listar" class="text-sm font-bold text-red-500 border-b-2 border-red-500 py-1">♥ Mis Favoritos</a>
                    <a href="${pageContext.request.contextPath}/usuario?accion=logout" class="bg-red-600 hover:bg-red-700 text-white px-5 py-2.5 rounded-full text-sm font-semibold shadow-md transition-all">Cerrar Sesión</a>
                </nav>
            </div>
        </div>
    </header>

    <main class="flex-grow pt-28 pb-16 px-4">
        <div class="max-w-7xl mx-auto">
            
            <div class="mb-8">
                <h1 class="text-3xl font-bold text-slate-900 tracking-tight">♥ Mis Favoritos</h1>
                <p class="text-slate-500 mt-2">Propiedades que has guardado para ver después.</p>
            </div>

            <c:if test="${empty listaFavoritos}">
                <div class="bg-white rounded-2xl p-12 text-center shadow-lg border border-slate-100">
                    <div class="text-6xl mb-4">🏠</div>
                    <h2 class="text-xl font-bold text-slate-900 mb-2">Aún no tienes favoritos</h2>
                    <p class="text-slate-500 mb-6">Explora el catálogo y guarda las propiedades que más te gusten.</p>
                    <a href="${pageContext.request.contextPath}/propiedades" class="inline-block bg-blue-600 hover:bg-blue-700 text-white px-8 py-3 rounded-xl font-bold shadow-lg transition-all">Explorar Propiedades</a>
                </div>
            </c:if>

            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <c:forEach var="p" items="${listaFavoritos}">
                    <div class="group bg-white rounded-2xl shadow-lg border border-slate-100 overflow-hidden hover:shadow-xl transition-all duration-300 hover:-translate-y-1">
                        <!-- Imagen -->
                        <div class="relative h-48 bg-gradient-to-br from-slate-200 to-slate-300 overflow-hidden">
                            <c:choose>
                                <c:when test="${not empty p.fotoPrincipal}">
                                    <img src="${pageContext.request.contextPath}/${p.fotoPrincipal}" alt="${p.titulo}" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
                                </c:when>
                                <c:otherwise>
                                    <div class="w-full h-full flex items-center justify-center text-slate-400 text-5xl">🏠</div>
                                </c:otherwise>
                            </c:choose>
                            <span class="absolute top-3 left-3 px-3 py-1 rounded-full text-xs font-bold ${p.operacion == 'VENTA' ? 'bg-indigo-600 text-white' : 'bg-emerald-600 text-white'}">${p.operacion}</span>
                            <a href="${pageContext.request.contextPath}/favorito?accion=remover&id=${p.id}" class="absolute top-3 right-3 w-10 h-10 bg-red-500 text-white rounded-full flex items-center justify-center text-lg shadow-lg hover:bg-red-600 transition-colors" title="Quitar de favoritos">♥</a>
                        </div>
                        <!-- Info -->
                        <div class="p-5">
                            <h3 class="font-bold text-slate-900 text-lg mb-2 line-clamp-1">${p.titulo}</h3>
                            <p class="text-sm text-slate-500 mb-3">📍 ${p.distrito}, ${p.provincia}</p>
                            <div class="flex items-baseline gap-2 mb-3">
                                <span class="text-xl font-black text-blue-600">US$ <fmt:formatNumber value="${p.precioUsd}" type="number" maxFractionDigits="0"/></span>
                                <c:if test="${p.precioPen != null}">
                                    <span class="text-xs text-slate-400">| S/. <fmt:formatNumber value="${p.precioPen}" type="number" maxFractionDigits="0"/></span>
                                </c:if>
                            </div>
                            <div class="flex gap-4 text-xs text-slate-500 mb-4">
                                <span>${p.areaTechadaM2} m²</span>
                                <span>${p.numDormitorios} dorm.</span>
                                <span>${p.numBanos} baños</span>
                            </div>
                            <a href="${pageContext.request.contextPath}/propiedades?accion=ver&id=${p.id}" class="block w-full text-center bg-slate-900 hover:bg-slate-800 text-white py-3 rounded-xl font-bold text-sm transition-colors">Ver Detalle</a>
                        </div>
                    </div>
                </c:forEach>
            </div>

        </div>
    </main>
</body>
</html>
