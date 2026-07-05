<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!-- Header con Tailwind -->
<header class="fixed top-0 left-0 right-0 z-50 bg-black/90 backdrop-blur-md border-b border-white/10 shadow-lg">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="min-h-[78px] flex justify-between items-center gap-4">
            <!-- Logo -->
            <a href="${pageContext.request.contextPath}/index.jsp" class="inline-flex items-center gap-3 no-underline">
                <img src="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png"
                    alt="Inmobix Logo" class="h-10 w-auto object-contain brightness-0 invert">
                <span class="text-2xl font-bold tracking-tight text-white">InmobiX</span>
            </a>

            <!-- Desktop Nav -->
            <nav class="hidden md:flex items-center gap-6 lg:gap-8" aria-label="Menú principal">
                <c:choose>
                    <c:when test="${isAdminArea == 'true'}">
                        <!-- Admin Navigation Links -->
                        <a href="${pageContext.request.contextPath}/admin?accion=dashboard" 
                           class="text-sm font-semibold ${activePage == 'dashboard' ? 'text-white' : 'text-white/80 hover:text-white'} transition-colors">Dashboard</a>
                        <a href="${pageContext.request.contextPath}/admin?accion=usuarios"
                           class="text-sm font-semibold ${activePage == 'usuarios' ? 'text-white' : 'text-white/80 hover:text-white'} transition-colors">Usuarios</a>
                        <a href="${pageContext.request.contextPath}/admin?accion=propiedades"
                           class="text-sm font-semibold ${activePage == 'propiedades' ? 'text-white' : 'text-white/80 hover:text-white'} transition-colors">Propiedades</a>
                        <a href="${pageContext.request.contextPath}/admin?accion=ubicaciones"
                           class="text-sm font-semibold ${activePage == 'ubicaciones' ? 'text-white' : 'text-white/80 hover:text-white'} transition-colors">Ubicaciones</a>
                        <a href="${pageContext.request.contextPath}/admin?accion=auditoria"
                           class="text-sm font-semibold ${activePage == 'auditoria' ? 'text-white' : 'text-white/80 hover:text-white'} transition-colors">Auditoría</a>
                    </c:when>
                    <c:otherwise>
                        <!-- Public Navigation Links -->
                        <a href="${pageContext.request.contextPath}/index.xhtml"
                            class="text-sm font-semibold ${activePage == 'inicio' ? 'text-white' : 'text-white/80 hover:text-white'} transition-colors">Inicio</a>
                        <a href="${pageContext.request.contextPath}/propiedades.xhtml"
                            class="text-sm font-semibold ${activePage == 'catalogo' ? 'text-white' : 'text-white/80 hover:text-white'} transition-colors">Catálogo</a>
                        <c:if test="${empty sessionScope.usuarioLogueado || sessionScope.usuarioLogueado.idRol != 2}">
                            <a href="${pageContext.request.contextPath}/planes.xhtml"
                                class="text-sm font-semibold ${activePage == 'planes' ? 'text-white' : 'text-white/80 hover:text-white'} transition-colors">Planes</a>
                        </c:if>
                        <c:if test="${not empty sessionScope.usuarioLogueado}">
                             <a href="${pageContext.request.contextPath}/usuario/favoritos.xhtml"
                                 class="text-sm font-semibold ${activePage == 'favoritos' ? 'text-white' : 'text-white/80 hover:text-white'} transition-colors inline-flex items-center gap-1">
                                 <svg class="w-4 h-4 text-red-500 fill-current" viewBox="0 0 24 24"><path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"></path></svg>
                                 Favoritos
                             </a>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/nosotros.xhtml"
                            class="text-sm font-semibold ${activePage == 'nosotros' ? 'text-white' : 'text-white/80 hover:text-white'} transition-colors">Nosotros</a>
                        <a href="${pageContext.request.contextPath}/faq.xhtml"
                            class="text-sm font-semibold ${activePage == 'faq' ? 'text-white' : 'text-white/80 hover:text-white'} transition-colors">FAQ</a>
                        <a href="${pageContext.request.contextPath}/contacto.xhtml"
                            class="text-sm font-semibold ${activePage == 'contacto' ? 'text-white' : 'text-white/80 hover:text-white'} transition-colors">Contacto</a>
                    </c:otherwise>
                </c:choose>
            </nav>

            <!-- Actions -->
            <div class="hidden md:flex items-center gap-4">
                <c:choose>
                    <c:when test="${not empty sessionScope.usuarioLogueado}">
                        <c:choose>
                            <c:when test="${isAdminArea == 'true'}">
                                <span class="text-xs font-semibold px-3 py-2 rounded-full bg-white/10 border border-white/15 text-white">Admin: ${sessionScope.usuarioLogueado.nombres}</span>
                                <a href="${pageContext.request.contextPath}/usuario?accion=logout" class="px-4 py-2 rounded-full text-sm font-semibold text-white bg-white/10 hover:bg-white/20 border border-white/15 transition-colors">Cerrar Sesión</a>
                            </c:when>
                            <c:otherwise>
                                <span class="text-xs font-semibold px-3 py-2 rounded-full bg-white/10 border border-white/15 text-white">${sessionScope.usuarioLogueado.nombres}</span>
                                <c:if test="${sessionScope.usuarioLogueado.idRol == 3 || sessionScope.usuarioLogueado.idRol == 4}">
                                    <a href="${pageContext.request.contextPath}/agente/panel.xhtml" class="text-sm font-semibold ${activePage == 'panel' ? 'text-white' : 'text-white/80 hover:text-white'} transition-colors">Panel</a>
                                </c:if>
                                <c:if test="${sessionScope.usuarioLogueado.idRol == 5}">
                                    <a href="${pageContext.request.contextPath}/admin/dashboard.xhtml" class="text-sm font-semibold text-amber-400 hover:text-amber-300 transition-colors">Admin</a>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/usuario?accion=logout" class="px-4 py-2 rounded-full text-sm font-semibold text-white bg-white/10 hover:bg-white/20 border border-white/15 transition-colors">Cerrar Sesión</a>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/usuario?accion=login" class="text-sm font-semibold ${activePage == 'login' ? 'text-white' : 'text-white/80 hover:text-white'} transition-colors">Iniciar sesión</a>
                        <a href="${pageContext.request.contextPath}/usuario?accion=registro" class="px-5 py-2.5 rounded-full text-sm font-semibold bg-white text-black hover:bg-gray-200 transition-colors">Regístrate</a>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Mobile menu button -->
            <button class="md:hidden p-2 rounded-lg text-white hover:bg-white/10" onclick="toggleMobileMenu()" aria-label="Menú" aria-controls="mobile-menu">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
                </svg>
            </button>
        </div>
    </div>

    <!-- Mobile Menu -->
    <div id="mobile-menu" class="hidden md:hidden bg-black/95 border-t border-white/10">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4 space-y-2">
            <c:choose>
                <c:when test="${isAdminArea == 'true'}">
                    <a href="${pageContext.request.contextPath}/admin?accion=dashboard" class="block py-2 text-sm font-semibold ${activePage == 'dashboard' ? 'text-white' : 'text-white/80 hover:text-white'}">Dashboard</a>
                    <a href="${pageContext.request.contextPath}/admin?accion=usuarios" class="block py-2 text-sm font-semibold ${activePage == 'usuarios' ? 'text-white' : 'text-white/80 hover:text-white'}">Usuarios</a>
                    <a href="${pageContext.request.contextPath}/admin?accion=propiedades" class="block py-2 text-sm font-semibold ${activePage == 'propiedades' ? 'text-white' : 'text-white/80 hover:text-white'}">Propiedades</a>
                    <a href="${pageContext.request.contextPath}/admin?accion=ubicaciones" class="block py-2 text-sm font-semibold ${activePage == 'ubicaciones' ? 'text-white' : 'text-white/80 hover:text-white'}">Ubicaciones</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/index.xhtml" class="block py-2 text-sm font-semibold ${activePage == 'inicio' ? 'text-white' : 'text-white/80 hover:text-white'}">Inicio</a>
                    <a href="${pageContext.request.contextPath}/propiedades.xhtml" class="block py-2 text-sm font-semibold ${activePage == 'catalogo' ? 'text-white' : 'text-white/80 hover:text-white'}">Catálogo</a>
                    <a href="${pageContext.request.contextPath}/planes.xhtml" class="block py-2 text-sm font-semibold ${activePage == 'planes' ? 'text-white' : 'text-white/80 hover:text-white'}">Planes</a>
                    <a href="${pageContext.request.contextPath}/nosotros.xhtml" class="block py-2 text-sm font-semibold ${activePage == 'nosotros' ? 'text-white' : 'text-white/80 hover:text-white'}">Nosotros</a>
                    <a href="${pageContext.request.contextPath}/faq.xhtml" class="block py-2 text-sm font-semibold ${activePage == 'faq' ? 'text-white' : 'text-white/80 hover:text-white'}">FAQ</a>
                    <a href="${pageContext.request.contextPath}/contacto.xhtml" class="block py-2 text-sm font-semibold ${activePage == 'contacto' ? 'text-white' : 'text-white/80 hover:text-white'}">Contacto</a>
                    <c:if test="${not empty sessionScope.usuarioLogueado}">
                        <a href="${pageContext.request.contextPath}/usuario/favoritos.xhtml" class="block py-2 text-sm font-semibold text-white/80 hover:text-white">Favoritos</a>
                    </c:if>
                </c:otherwise>
            </c:choose>

            <hr class="border-white/10 my-2">
            <c:choose>
                <c:when test="${not empty sessionScope.usuarioLogueado}">
                    <a href="${pageContext.request.contextPath}/usuario?accion=logout" class="block py-2 text-sm font-semibold text-red-400 hover:text-red-300">Cerrar Sesión</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/usuario?accion=login" class="block py-2 text-sm font-semibold text-white/80 hover:text-white">Iniciar sesión</a>
                    <a href="${pageContext.request.contextPath}/usuario?accion=registro" class="block py-2 text-sm font-semibold text-white">Regístrate</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>

<div class="h-20"></div>

