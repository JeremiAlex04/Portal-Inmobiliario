<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png">
    <title>Inmobix - Panel de Agente</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        function confirmarEliminacion(url) {
            if (confirm("¿Estás seguro que deseas eliminar esta propiedad? Esta acción no se puede deshacer.")) {
                window.location.href = url;
            }
        }
    </script>
</head>
<body class="bg-slate-50 text-slate-800 flex flex-col min-h-screen font-sans">
    
    <!-- Navbar -->
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
                    <a href="${pageContext.request.contextPath}/propiedades" class="text-sm font-semibold text-slate-600 hover:text-blue-600 transition-colors">Catálogo Público</a>
                    <a href="${pageContext.request.contextPath}/panel" class="text-sm font-bold text-blue-600 transition-colors border-b-2 border-blue-600 py-1">Mi Panel</a>
                </nav>

                <!-- Actions -->
                <div class="hidden md:flex items-center gap-4">
                    <span class="text-sm font-semibold text-slate-600">Hola, ${sessionScope.usuarioLogueado.nombres}</span>
                    <a href="${pageContext.request.contextPath}/usuario?accion=logout" class="bg-slate-800 hover:bg-slate-900 text-white px-5 py-2.5 rounded-full text-sm font-semibold shadow-md shadow-slate-800/20 transition-all hover:-translate-y-0.5">Cerrar Sesión</a>
                </div>
            </div>
        </div>
    </header>

    <main class="flex-grow pt-28 pb-16 px-4">
        <div class="max-w-7xl mx-auto">
            
            <div class="flex justify-between items-center mb-8">
                <div>
                    <h1 class="text-3xl font-bold text-slate-900 tracking-tight">Mis Propiedades</h1>
                    <p class="text-slate-500 mt-2">Gestiona todas las propiedades que has publicado en la plataforma.</p>
                </div>
                <a href="${pageContext.request.contextPath}/propiedades?accion=nuevo" class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg font-bold shadow-lg shadow-blue-600/30 transition-all hover:-translate-y-0.5 flex items-center gap-2">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path></svg>
                    Publicar Inmueble
                </a>
            </div>

            <!-- Tabla de Propiedades -->
            <div class="bg-white rounded-2xl shadow-xl shadow-slate-200/50 border border-slate-100 overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full text-left text-sm text-slate-600">
                        <thead class="bg-slate-50 border-b border-slate-100 text-slate-700 uppercase font-semibold">
                            <tr>
                                <th class="px-6 py-4">ID</th>
                                <th class="px-6 py-4">Título</th>
                                <th class="px-6 py-4">Tipo / Operación</th>
                                <th class="px-6 py-4">Ubicación</th>
                                <th class="px-6 py-4">Precio</th>
                                <th class="px-6 py-4 text-center">Acciones</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-100">
                            <c:choose>
                                <c:when test="${empty listaMisPropiedades}">
                                    <tr>
                                        <td colspan="6" class="px-6 py-8 text-center text-slate-500">
                                            No tienes propiedades publicadas todavía. ¡Haz clic en "Publicar Inmueble" para empezar!
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="p" items="${listaMisPropiedades}">
                                        <tr class="hover:bg-slate-50 transition-colors">
                                            <td class="px-6 py-4 font-medium text-slate-900">#${p.id}</td>
                                            <td class="px-6 py-4">
                                                <div class="font-bold text-slate-800">${p.titulo}</div>
                                                <span class="inline-block mt-1 px-2 py-1 bg-${p.estado == 'ACTIVO' ? 'emerald' : 'slate'}-100 text-${p.estado == 'ACTIVO' ? 'emerald' : 'slate'}-700 text-xs rounded-full font-semibold">${p.estado}</span>
                                            </td>
                                            <td class="px-6 py-4">
                                                <span class="block">${p.tipoInmueble}</span>
                                                <span class="block text-xs text-slate-400 font-semibold uppercase mt-1">${p.operacion}</span>
                                            </td>
                                            <td class="px-6 py-4">
                                                ${p.distrito}
                                            </td>
                                            <td class="px-6 py-4 font-bold text-slate-900">
                                                ${p.monedaBase == 'USD' ? '$' : 'S/'} ${p.precioPen != null ? (p.monedaBase == 'USD' ? p.precioUsd : p.precioPen) : 0}
                                            </td>
                                            <td class="px-6 py-4 flex justify-center gap-3">
                                                <a href="${pageContext.request.contextPath}/propiedades?accion=editar&id=${p.id}" class="text-blue-600 hover:text-blue-800 bg-blue-50 hover:bg-blue-100 px-3 py-1.5 rounded-lg transition-colors font-medium text-xs">Editar</a>
                                                <button onclick="confirmarEliminacion('${pageContext.request.contextPath}/propiedades?accion=eliminar&id=${p.id}')" class="text-red-600 hover:text-red-800 bg-red-50 hover:bg-red-100 px-3 py-1.5 rounded-lg transition-colors font-medium text-xs">Eliminar</button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
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
