<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png">
    <title>Inmobix - Perfil del Agente</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="${pageContext.request.contextPath}/assets/js/main.js" defer></script>
</head>
<body class="bg-slate-50 text-slate-800 flex flex-col min-h-screen font-sans">
    
    <!-- Navbar Premium -->
    <header class="fixed w-full top-0 z-50 bg-white/80 backdrop-blur-md border-b border-slate-200/50 shadow-sm transition-all">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center h-20">
                <!-- Logo -->
                <div class="flex items-center gap-3">
                    <img src="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png" alt="Inmobix Logo" class="h-10 w-auto object-contain">
                    <span class="text-2xl font-bold bg-gradient-to-r from-blue-600 to-indigo-600 bg-clip-text text-transparent tracking-tight">Inmobix</span>
                </div>
                
                <!-- Desktop Nav -->
                <nav class="hidden md:flex items-center gap-8">
                    <a href="${pageContext.request.contextPath}/index.jsp" class="text-sm font-semibold text-slate-600 hover:text-blue-600 transition-colors">Inicio</a>
                    <a href="${pageContext.request.contextPath}/propiedades" class="text-sm font-semibold text-slate-600 hover:text-blue-600 transition-colors">Catálogo</a>
                    <a href="${pageContext.request.contextPath}/propiedades?accion=nuevo" class="text-sm font-semibold text-slate-600 hover:text-blue-600 transition-colors">Publicar</a>
                    <a href="${pageContext.request.contextPath}/contacto" class="text-sm font-semibold text-slate-600 hover:text-blue-600 transition-colors">Contacto</a>
                </nav>

                <!-- Actions -->
                <div class="hidden md:flex items-center gap-4">
                    <c:choose>
                        <c:when test="${not empty sessionScope.usuarioLogueado}">
                            <span class="text-sm font-semibold text-slate-600">Hola, ${sessionScope.usuarioLogueado.nombres}</span>
                            <c:if test="${sessionScope.usuarioLogueado.idRol == 3 || sessionScope.usuarioLogueado.idRol == 4 || sessionScope.usuarioLogueado.idRol == 5}">
                                <a href="${pageContext.request.contextPath}/panel" class="text-sm font-semibold text-blue-600 hover:text-blue-800 transition-colors">Mi Panel</a>
                            </c:if>
                            <a href="${pageContext.request.contextPath}/usuario?accion=logout" class="bg-slate-800 hover:bg-slate-900 text-white px-5 py-2.5 rounded-full text-sm font-semibold shadow-md shadow-slate-800/20 transition-all hover:-translate-y-0.5">Cerrar Sesión</a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/usuario?accion=login" class="text-sm font-semibold text-slate-600 hover:text-blue-600 transition-colors">Iniciar sesión</a>
                            <a href="${pageContext.request.contextPath}/usuario?accion=registro" class="bg-blue-600 hover:bg-blue-700 text-white px-5 py-2.5 rounded-full text-sm font-semibold shadow-md shadow-blue-600/20 transition-all hover:-translate-y-0.5">Regístrate</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </header>

    <main class="flex-grow pt-20">
        <!-- Banner and Profile Info -->
        <div class="bg-indigo-600 h-48 w-full relative">
            <div class="absolute inset-0 bg-gradient-to-r from-indigo-700 to-indigo-500 opacity-90"></div>
        </div>
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative -mt-24">
            <div class="bg-white rounded-2xl shadow-xl shadow-slate-200 p-8 flex flex-col sm:flex-row items-center sm:items-start gap-6 border border-slate-100">
                <div class="w-32 h-32 rounded-full border-4 border-white shadow-lg bg-indigo-100 flex items-center justify-center text-4xl font-bold text-indigo-500 flex-shrink-0">
                    ${agente.nombres.substring(0,1)}${agente.apellidos.substring(0,1)}
                </div>
                <div class="text-center sm:text-left flex-grow">
                    <h1 class="text-3xl font-extrabold text-slate-900">${agente.nombres} ${agente.apellidos}</h1>
                    <p class="text-indigo-600 font-semibold mb-4 uppercase text-sm tracking-wider">${agente.rolNombre != null ? agente.rolNombre : 'Agente Inmobiliario'}</p>
                    
                    <div class="flex flex-col sm:flex-row gap-4 mt-2 justify-center sm:justify-start">
                        <div class="flex items-center gap-2 text-slate-600">
                            <svg class="w-5 h-5 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path></svg>
                            <span class="font-medium">${agente.correo}</span>
                        </div>
                        <div class="flex items-center gap-2 text-slate-600">
                            <svg class="w-5 h-5 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"></path></svg>
                            <span class="font-medium">${propiedades.size()} Propiedades Publicadas</span>
                        </div>
                    </div>
                </div>
                <div class="flex-shrink-0 mt-4 sm:mt-0">
                    <a href="mailto:${agente.correo}" class="bg-slate-900 hover:bg-slate-800 text-white px-6 py-3 rounded-full font-bold shadow-lg shadow-slate-900/30 transition-transform hover:-translate-y-1 inline-flex items-center gap-2">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"></path></svg>
                        Contactar
                    </a>
                </div>
            </div>
        </div>

        <!-- Propiedades del Agente -->
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
            <h2 class="text-2xl font-bold text-slate-900 mb-8 border-b border-slate-200 pb-4">Propiedades Destacadas</h2>

            <c:choose>
                <c:when test="${empty propiedades}">
                    <div class="bg-amber-50 border-l-4 border-amber-500 p-6 rounded-r-xl shadow-sm">
                        <p class="text-amber-800 font-bold text-lg">Este agente aún no tiene propiedades activas.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                        <c:forEach var="prop" items="${propiedades}">
                            <!-- Card -->
                            <div class="group bg-white rounded-2xl shadow-sm hover:shadow-xl border border-slate-200 overflow-hidden transition-all duration-300 hover:-translate-y-1 flex flex-col">
                                <div class="relative h-56 bg-gradient-to-br from-slate-200 to-slate-300 overflow-hidden">
                                    <c:choose>
                                        <c:when test="${not empty prop.fotoPrincipal}">
                                            <img src="${pageContext.request.contextPath}/${prop.fotoPrincipal}" alt="${prop.titulo}"
                                                class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="w-full h-full flex items-center justify-center text-slate-400 text-6xl">🏡</div>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="absolute top-4 left-4 bg-white/90 backdrop-blur-sm px-3 py-1 rounded-full text-xs font-bold text-indigo-600 shadow-sm uppercase">
                                        <c:out value="${prop.operacion != null ? prop.operacion : 'En Venta'}" />
                                    </div>
                                </div>

                                <div class="p-6 flex flex-col flex-grow">
                                    <div class="flex items-start justify-between mb-2">
                                        <div>
                                            <p class="text-xs font-bold text-slate-400 uppercase tracking-wider mb-1"><c:out value="${prop.tipoInmueble}" /></p>
                                            <h3 class="font-bold text-lg text-slate-900 leading-snug line-clamp-2" title="${prop.titulo}">
                                                <c:out value="${prop.titulo}" />
                                            </h3>
                                        </div>
                                    </div>
                                    
                                    <div class="flex items-center text-slate-500 mb-4 mt-1">
                                        <svg class="w-4 h-4 mr-1 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                                        <span class="text-sm truncate"><c:out value="${prop.distrito}" /></span>
                                    </div>

                                    <div class="grid grid-cols-3 gap-2 mb-6 text-center border-y border-slate-100 py-3 mt-auto">
                                        <div>
                                            <p class="text-xs text-slate-500 mb-1">Área</p>
                                            <p class="font-bold text-slate-700 text-sm">${prop.areaTechadaM2} <span class="text-xs font-normal text-slate-500">m²</span></p>
                                        </div>
                                        <div class="border-x border-slate-100">
                                            <p class="text-xs text-slate-500 mb-1">Dorms.</p>
                                            <p class="font-bold text-slate-700 text-sm">${prop.numDormitorios}</p>
                                        </div>
                                        <div>
                                            <p class="text-xs text-slate-500 mb-1">Baños</p>
                                            <p class="font-bold text-slate-700 text-sm">${prop.numBanos}</p>
                                        </div>
                                    </div>

                                    <div class="flex items-center justify-between mt-2">
                                        <div class="text-xl font-extrabold text-indigo-700">
                                            $ ${prop.precio}
                                        </div>
                                        <a href="${pageContext.request.contextPath}/propiedades?accion=detalle&id=${prop.id}"
                                            class="bg-slate-100 hover:bg-slate-200 text-slate-700 px-4 py-2 rounded-lg font-bold text-sm transition-colors">
                                            Ver Detalles
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <!-- Footer -->
    <footer class="bg-slate-900 border-t border-slate-800 text-slate-400 py-12 mt-auto">
        <div class="max-w-7xl mx-auto px-4 text-center">
            <div class="flex justify-center items-center gap-2 mb-6 opacity-80">
                <img src="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png" alt="Inmobix Logo" class="h-6 w-auto grayscale">
                <span class="text-xl font-bold text-slate-300">Inmobix</span>
            </div>
            <p class="text-sm">&copy; 2026 Portal Inmobiliario. Todos los derechos reservados.</p>
        </div>
    </footer>
</body>
</html>
