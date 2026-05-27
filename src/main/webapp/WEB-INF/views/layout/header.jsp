<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!-- Navbar Premium con Glassmorphism -->
<header class="text-white fixed w-full top-0 z-50 bg-black/90 backdrop-blur-md border-b border-white/10 shadow-lg transition-all">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-20">
            <!-- Logo -->
            <a href="${pageContext.request.contextPath}/index.jsp" class="flex items-center gap-3">
                <img src="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png"
                    alt="Inmobix Logo" class="h-10 w-auto object-contain brightness-0 invert">
                <span class="text-2xl font-bold text-white tracking-tight">Inmobix</span>
            </a>

            <!-- Desktop Nav -->
            <nav class="hidden md:flex items-center gap-8">
                <c:choose>
                    <c:when test="${isAdminArea == 'true'}">
                        <!-- Admin Navigation Links -->
                        <a href="${pageContext.request.contextPath}/admin?accion=dashboard" 
                           class="text-sm font-semibold ${activePage == 'dashboard' ? 'text-brandHover' : 'text-white/80 hover:text-brandHover'} transition-colors">Dashboard</a>
                        <a href="${pageContext.request.contextPath}/admin?accion=usuarios" 
                           class="text-sm font-semibold ${activePage == 'usuarios' ? 'text-brandHover' : 'text-white/80 hover:text-brandHover'} transition-colors">Usuarios</a>
                        <a href="${pageContext.request.contextPath}/admin?accion=propiedades" 
                           class="text-sm font-semibold ${activePage == 'propiedades' ? 'text-brandHover' : 'text-white/80 hover:text-brandHover'} transition-colors">Propiedades</a>
                        <a href="${pageContext.request.contextPath}/admin?accion=ubicaciones" 
                           class="text-sm font-semibold ${activePage == 'ubicaciones' ? 'text-brandHover' : 'text-white/80 hover:text-brandHover'} transition-colors">Ubicaciones</a>
                        <a href="${pageContext.request.contextPath}/admin?accion=auditoria" 
                           class="text-sm font-semibold ${activePage == 'auditoria' ? 'text-brandHover' : 'text-white/80 hover:text-brandHover'} transition-colors">Auditoría</a>
                    </c:when>
                    <c:otherwise>
                        <!-- Public Navigation Links -->
                        <a href="${pageContext.request.contextPath}/index.jsp"
                            class="text-sm font-semibold ${activePage == 'inicio' ? 'text-brandHover' : 'text-white/80 hover:text-brandHover'} transition-colors">Inicio</a>
                        <a href="${pageContext.request.contextPath}/propiedades"
                            class="text-sm font-semibold ${activePage == 'catalogo' ? 'text-brandHover' : 'text-white/80 hover:text-brandHover'} transition-colors">Catálogo</a>
                        <a href="${pageContext.request.contextPath}/pagos?accion=planes"
                            class="text-sm font-semibold ${activePage == 'planes' ? 'text-brandHover' : 'text-white/80 hover:text-brandHover'} transition-colors">Planes</a>
                        <a href="${pageContext.request.contextPath}/propiedades?accion=nuevo"
                            class="text-sm font-semibold ${activePage == 'publicar' ? 'text-brandHover' : 'text-white/80 hover:text-brandHover'} transition-colors">Publicar</a>
                        <c:if test="${not empty sessionScope.usuarioLogueado}">
                             <a href="${pageContext.request.contextPath}/favorito?accion=listar"
                                 class="text-sm font-semibold ${activePage == 'favoritos' ? 'text-brandHover' : 'text-white/80 hover:text-brandHover'} transition-colors inline-flex items-center gap-1">
                                 <svg class="w-4 h-4 text-red-500 fill-current" viewBox="0 0 24 24"><path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"></path></svg>
                                 Favoritos
                             </a>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/contacto"
                            class="text-sm font-semibold ${activePage == 'contacto' ? 'text-brandHover' : 'text-white/80 hover:text-brandHover'} transition-colors">Contacto</a>
                    </c:otherwise>
                </c:choose>
            </nav>

            <!-- Actions -->
            <div class="hidden md:flex items-center gap-4">
                <c:choose>
                    <c:when test="${not empty sessionScope.usuarioLogueado}">
                        <c:choose>
                            <c:when test="${isAdminArea == 'true'}">
                                <span class="text-sm font-semibold text-slate-350">Admin: ${sessionScope.usuarioLogueado.nombres}</span>
                                <a href="${pageContext.request.contextPath}/usuario?accion=logout" class="bg-red-650 hover:bg-red-700 text-white px-5 py-2.5 rounded-full text-sm font-semibold shadow-md shadow-red-600/20 transition-all hover:-translate-y-0.5">Cerrar Sesión</a>
                            </c:when>
                            <c:otherwise>
                                <span class="text-sm font-semibold text-white/95">Hola, ${sessionScope.usuarioLogueado.nombres}</span>
                                <c:if test="${sessionScope.usuarioLogueado.idRol == 3 || sessionScope.usuarioLogueado.idRol == 4 || sessionScope.usuarioLogueado.idRol == 5}">
                                    <a href="${pageContext.request.contextPath}/panel" class="text-sm font-semibold ${activePage == 'panel' ? 'text-white' : 'text-brandHover hover:text-white'} transition-colors">Mi Panel</a>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/usuario?accion=logout" class="bg-brandBtn hover:bg-brandHover text-white px-5 py-2.5 rounded-full text-sm font-semibold shadow-md shadow-brandBtn/20 transition-all hover:-translate-y-0.5">Cerrar Sesión</a>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/usuario?accion=login" class="text-sm font-semibold ${activePage == 'login' ? 'text-brandHover' : 'text-white/80 hover:text-brandHover'} transition-colors">Iniciar sesión</a>
                        <a href="${pageContext.request.contextPath}/usuario?accion=registro" class="bg-brandBtn hover:bg-brandHover text-white px-5 py-2.5 rounded-full text-sm font-semibold shadow-md shadow-brandBtn/20 transition-all hover:-translate-y-0.5">Regístrate</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</header>
