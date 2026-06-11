<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png">
    <title>Inmobix - Mi Perfil</title>
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
                    <span class="text-sm font-semibold text-slate-600">Hola, ${sessionScope.usuarioLogueado.nombres}</span>
                    <c:if test="${sessionScope.usuarioLogueado.idRol == 3 || sessionScope.usuarioLogueado.idRol == 4 || sessionScope.usuarioLogueado.idRol == 5}">
                        <a href="${pageContext.request.contextPath}/panel" class="text-sm font-semibold text-blue-600 hover:text-blue-800 transition-colors">Mi Panel</a>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/usuario?accion=logout" class="bg-slate-800 hover:bg-slate-900 text-white px-5 py-2.5 rounded-full text-sm font-semibold shadow-md shadow-slate-800/20 transition-all hover:-translate-y-0.5">Cerrar Sesión</a>
                </div>
            </div>
        </div>
    </header>

    <main class="flex-grow pt-28 pb-16 px-4 max-w-4xl mx-auto w-full">
        <div class="bg-white rounded-2xl shadow-xl shadow-slate-200/50 border border-slate-100 overflow-hidden">
            <div class="px-8 py-6 border-b border-slate-100 bg-slate-50/50 flex justify-between items-center">
                <h1 class="text-2xl font-bold text-slate-800">Mi Perfil</h1>
                <span class="px-3 py-1 rounded-full text-xs font-semibold bg-blue-100 text-blue-700 uppercase tracking-wider">
                    ${sessionScope.usuarioLogueado.rolNombre != null ? sessionScope.usuarioLogueado.rolNombre : 'Usuario'}
                </span>
            </div>

            <div class="p-8">
                <!-- MENSAJES -->
                <c:if test="${not empty msg}">
                    <div class="mb-6 bg-emerald-50 border-l-4 border-emerald-500 p-4 rounded-r-md">
                        <p class="text-sm text-emerald-700 font-medium">${msg}</p>
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="mb-6 bg-red-50 border-l-4 border-red-500 p-4 rounded-r-md">
                        <p class="text-sm text-red-700 font-medium">${error}</p>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/usuario" method="post" class="space-y-6">
                    <input type="hidden" name="accion" value="actualizar_perfil">
                    
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">Nombres</label>
                            <input type="text" name="nombres" value="${sessionScope.usuarioLogueado.nombres}" required class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition-all">
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">Apellidos</label>
                            <input type="text" name="apellidos" value="${sessionScope.usuarioLogueado.apellidos}" required class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition-all">
                        </div>
                    </div>

                    <div>
                        <label class="block text-sm font-semibold text-slate-700 mb-2">Correo Electrónico</label>
                        <input type="email" name="correo" value="${sessionScope.usuarioLogueado.correo}" required class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition-all">
                    </div>

                    <div class="pt-4 border-t border-slate-100 flex justify-end">
                        <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-6 rounded-lg shadow-lg shadow-blue-600/30 transition-all hover:-translate-y-0.5">
                            Guardar Cambios
                        </button>
                    </div>
                </form>
            </div>
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
