<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png">
    <title>Inmobix - Perfil del Agente</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
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
        
    <script src="${pageContext.request.contextPath}/assets/js/main.js" defer></script>
</head>
<body class="bg-brandBg text-brandText flex flex-col min-h-screen font-sans">
    
    <!-- Navbar Premium -->
    <header class="text-white fixed w-full top-0 z-50 bg-black/90 backdrop-blur-md backdrop-blur-md border-b border-white/10 shadow-lg transition-all">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center h-20">
                <!-- Logo -->
                <div class="flex items-center gap-3">
                    <img src="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png" alt="Inmobix Logo" class="h-10 w-auto object-contain brightness-0 invert">
                    <span class="text-2xl font-bold text-white tracking-tight">Inmobix</span>
                </div>
                
                <!-- Desktop Nav -->
                <nav class="hidden md:flex items-center gap-8">
                    <a href="${pageContext.request.contextPath}/index.jsp" class="text-sm font-semibold text-white/80 hover:text-brandHover transition-colors">Inicio</a>
                    <a href="${pageContext.request.contextPath}/propiedades" class="text-sm font-semibold text-white/80 hover:text-brandHover transition-colors">Catálogo</a>
                    <a href="${pageContext.request.contextPath}/propiedades?accion=nuevo" class="text-sm font-semibold text-white/80 hover:text-brandHover transition-colors">Publicar</a>
                    <a href="${pageContext.request.contextPath}/contacto" class="text-sm font-semibold text-white/80 hover:text-brandHover transition-colors">Contacto</a>
                </nav>

                <!-- Actions -->
                <div class="hidden md:flex items-center gap-4">
                    <c:choose>
                        <c:when test="${not empty sessionScope.usuarioLogueado}">
                            <span class="text-sm font-semibold text-white/80">Hola, ${sessionScope.usuarioLogueado.nombres}</span>
                            <c:if test="${sessionScope.usuarioLogueado.idRol == 3 || sessionScope.usuarioLogueado.idRol == 4 || sessionScope.usuarioLogueado.idRol == 5}">
                                <a href="${pageContext.request.contextPath}/panel" class="text-sm font-semibold text-brandHover hover:text-white transition-colors">Mi Panel</a>
                            </c:if>
                            <a href="${pageContext.request.contextPath}/usuario?accion=logout" class="bg-brandBtn hover:bg-brandHover text-white px-5 py-2.5 rounded-full text-sm font-semibold shadow-md shadow-slate-800/20 transition-all hover:-translate-y-0.5">Cerrar Sesión</a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/usuario?accion=login" class="text-sm font-semibold text-white/80 hover:text-brandHover transition-colors">Iniciar sesión</a>
                            <a href="${pageContext.request.contextPath}/usuario?accion=registro" class="bg-brandBtn hover:bg-brandHover text-white px-5 py-2.5 rounded-full text-sm font-semibold shadow-md shadow-brandBtn/20 transition-all hover:-translate-y-0.5">Regístrate</a>
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
                                             <div class="w-full h-full flex items-center justify-center text-slate-400">
                                                 <svg class="w-16 h-16 text-slate-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>
                                             </div>
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
            <!-- Footer Premium -->
        <footer class="bg-[#000000] border-t border-white/10 text-slate-400 py-16 mt-auto">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="grid grid-cols-1 md:grid-cols-4 gap-12 mb-12 text-left">
                    <!-- Column 1: Brand Info -->
                    <div class="space-y-4">
                        <div class="flex items-center gap-2">
                            <img src="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png" alt="Inmobix Logo"
                                class="h-8 w-auto brightness-0 invert">
                            <span class="text-2xl font-black text-white tracking-tight">InmobiX</span>
                        </div>
                        <p class="text-sm text-slate-400 leading-relaxed">
                            El portal inmobiliario premium del Perú. Encuentra tu próximo hogar con la seguridad, rapidez y confianza que mereces.
                        </p>
                        <!-- Social Icons -->
                        <div class="flex items-center gap-4 pt-2">
                            <a href="#" class="text-slate-400 hover:text-white transition-colors" title="Facebook">
                                <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24"><path d="M22 12c0-5.52-4.48-10-10-10S2 6.48 2 12c0 4.84 3.44 8.87 8 9.8V15H8v-3h2V9.5C10 7.57 11.57 6 13.5 6H16v3h-2c-.55 0-1 .45-1 1v2h3v3h-3v6.95c4.56-.93 8-4.96 8-9.75z"/></svg>
                            </a>
                            <a href="#" class="text-slate-400 hover:text-white transition-colors" title="Instagram">
                                <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24"><path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zM12 0C8.741 0 8.333.014 7.053.072 2.695.272.273 2.69.073 7.051.014 8.333 0 8.741 0 12c0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98 1.281.058 1.689.072 4.948.072 3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98C15.668.014 15.259 0 12 0zm0 5.838a6.162 6.162 0 100 12.324 6.162 6.162 0 000-12.324zM12 16a4 4 0 110-8 4 4 0 010 8zm6.406-11.845a1.44 1.44 0 100 2.881 1.44 1.44 0 000-2.881z"/></svg>
                            </a>
                        </div>
                    </div>

                    <!-- Column 2: Empresa -->
                    <div class="space-y-4">
                        <h4 class="text-white font-bold text-sm tracking-wider uppercase">Empresa</h4>
                        <ul class="space-y-2 text-sm">
                            <li><a href="#" class="hover:text-white transition-colors">Nosotros</a></li>
                            <li><a href="#" class="hover:text-white transition-colors">Blog Inmobiliario</a></li>
                            <li><a href="#" class="hover:text-white transition-colors">Prensa</a></li>
                            <li><a href="#" class="hover:text-white transition-colors">Carreras</a></li>
                        </ul>
                    </div>

                    <!-- Column 3: Enlaces Rápidos -->
                    <div class="space-y-4">
                        <h4 class="text-white font-bold text-sm tracking-wider uppercase">Servicios</h4>
                        <ul class="space-y-2 text-sm">
                            <li><a href="${pageContext.request.contextPath}/propiedades" class="hover:text-white transition-colors">Comprar Propiedad</a></li>
                            <li><a href="${pageContext.request.contextPath}/propiedades?accion=nuevo" class="hover:text-white transition-colors">Publicar Inmueble</a></li>
                            <li><a href="${pageContext.request.contextPath}/pagos?accion=planes" class="hover:text-white transition-colors">Planes de Membresía</a></li>
                        </ul>
                    </div>

                    <!-- Column 4: Soporte -->
                    <div class="space-y-4">
                        <h4 class="text-white font-bold text-sm tracking-wider uppercase">Soporte</h4>
                        <ul class="space-y-2 text-sm">
                            <li><a href="${pageContext.request.contextPath}/contacto" class="hover:text-white transition-colors">Contacto</a></li>
                            <li><a href="#" class="hover:text-white transition-colors">Preguntas Frecuentes</a></li>
                            <li><a href="#" class="hover:text-white transition-colors">Términos y Condiciones</a></li>
                            <li><a href="#" class="hover:text-white transition-colors">Políticas de Privacidad</a></li>
                        </ul>
                    </div>
                </div>

                <div class="border-t border-white/10 pt-8 flex flex-col md:flex-row justify-between items-center gap-4 text-xs text-slate-500">
                    <p>&amp;copy; 2026 Portal Inmobiliario Inmobix. Todos los derechos reservados.</p>
                    
                </div>
            </div>
        </footer>
</body>
</html>
