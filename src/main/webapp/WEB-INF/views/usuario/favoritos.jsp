<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="es" class="scroll-smooth">
<head>
    <c:set var="pageTitle" value="Inmobix - Mis Favoritos" scope="request" />
    <jsp:include page="/WEB-INF/views/layout/head.jsp" />
</head>
<body class="bg-brandBg text-brandText flex flex-col min-h-screen font-sans">
    
    <!-- Navbar -->
        <c:set var="activePage" value="favoritos" scope="request" />
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <main class="flex-grow pt-28 pb-16 px-4">
        <div class="max-w-7xl mx-auto">
            
            <div class="mb-8 flex items-center gap-2">
                <svg class="w-8 h-8 text-red-500 fill-current" viewBox="0 0 24 24"><path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"></path></svg>
                <h1 class="text-3xl font-bold text-slate-900 tracking-tight">Mis Favoritos</h1>
            </div>

            <c:if test="${empty listaFavoritos}">
                <div class="bg-white rounded-2xl p-12 text-center shadow-lg border border-slate-100">
                    <div class="flex justify-center mb-4">
                        <svg class="w-16 h-16 text-slate-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>
                    </div>
                    <h2 class="text-xl font-bold text-slate-900 mb-2">Aún no tienes favoritos</h2>
                    <p class="text-slate-500 mb-6">Explora el catálogo y guarda las propiedades que más te gusten.</p>
                    <a href="${pageContext.request.contextPath}/propiedades" class="inline-block bg-brandBtn hover:bg-brandHover text-white px-8 py-3 rounded-xl font-bold shadow-lg transition-all">Explorar Propiedades</a>
                </div>
            </c:if>

            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <c:forEach var="p" items="${listaFavoritos}">
                    <div class="group bg-white rounded-2xl shadow-lg border border-slate-100 overflow-hidden hover:shadow-xl transition-all duration-300 hover:-translate-y-1">
                        <!-- Imagen -->
                        <div class="relative h-48 bg-gradient-to-br from-slate-200 to-slate-300 overflow-hidden">
                            <c:choose>
                                <c:when test="${not empty p.fotoPrincipal}">
                                    <img src="${p.getFotoPrincipalUrl(pageContext.request.contextPath)}" alt="${p.titulo}" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
                                </c:when>
                                <c:otherwise>
                                     <div class="w-full h-full flex items-center justify-center text-slate-400">
                                         <svg class="w-12 h-12 text-slate-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>
                                     </div>
                                </c:otherwise>
                            </c:choose>
                            <span class="absolute top-3 left-3 px-3 py-1 rounded-full text-xs font-bold ${p.operacion == 'VENTA' ? 'bg-indigo-600 text-white' : 'bg-emerald-600 text-white'}">${p.operacion}</span>
                            <a href="${pageContext.request.contextPath}/favorito?accion=remover&id=${p.id}" class="absolute top-3 right-3 w-10 h-10 bg-red-500 text-white rounded-full flex items-center justify-center text-lg shadow-lg hover:bg-red-600 transition-colors" title="Quitar de favoritos">
                                <svg class="w-5 h-5 text-white fill-current" viewBox="0 0 24 24"><path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"></path></svg>
                            </a>
                        </div>
                        <!-- Info -->
                        <div class="p-5">
                            <h3 class="font-bold text-slate-900 text-lg mb-2 line-clamp-1">${p.titulo}</h3>
                             <p class="text-sm text-slate-500 mb-3 inline-flex items-center gap-1">
                                 <svg class="w-4 h-4 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                                 ${p.distrito}, ${p.provincia}
                             </p>
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
    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
</body>
</html>
