<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="es" class="scroll-smooth">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <link rel="icon" type="image/png"
                href="${pageContext.request.contextPath}/assets/img/logo/inmobix_logo.png">
            <title>Inmobix - Catálogo de Propiedades</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
            <script src="https://cdn.tailwindcss.com"></script>
            <script src="${pageContext.request.contextPath}/assets/js/main.js" defer></script>
        </head>

        <body class="bg-slate-50 text-slate-800 flex flex-col min-h-screen font-sans">

            <!-- Navbar Premium con Glassmorphism -->
            <header
                class="fixed w-full top-0 z-50 bg-white/80 backdrop-blur-md border-b border-slate-200/50 shadow-sm transition-all">
                <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                    <div class="flex justify-between items-center h-20">
                        <!-- Logo -->
                        <div class="flex items-center gap-3">
                            <img src="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png"
                                alt="Inmobix Logo" class="h-10 w-auto object-contain">
                            <span
                                class="text-2xl font-bold bg-gradient-to-r from-blue-600 to-indigo-600 bg-clip-text text-transparent tracking-tight">Inmobix</span>
                        </div>

                        <!-- Desktop Nav -->
                        <nav class="hidden md:flex items-center gap-8">
                            <a href="${pageContext.request.contextPath}/index.jsp"
                                class="text-sm font-semibold text-slate-600 hover:text-blue-600 transition-colors">Inicio</a>
                            <a href="${pageContext.request.contextPath}/propiedades"
                                class="text-sm font-semibold text-blue-600 transition-colors">Catálogo</a>
                            <a href="${pageContext.request.contextPath}/propiedades?accion=nuevo"
                                class="text-sm font-semibold text-slate-600 hover:text-blue-600 transition-colors">Publicar</a>
                            <a href="${pageContext.request.contextPath}/contacto"
                                class="text-sm font-semibold text-slate-600 hover:text-blue-600 transition-colors">Contacto</a>
                        </nav>

                        <!-- Actions -->
                        <div class="hidden md:flex items-center gap-4">
                            <a href="${pageContext.request.contextPath}/usuario?accion=registro"
                                class="text-sm font-semibold text-slate-600 hover:text-blue-600 transition-colors">Iniciar
                                sesión</a>
                            <a href="${pageContext.request.contextPath}/usuario?accion=registro"
                                class="bg-blue-600 hover:bg-blue-700 text-white px-5 py-2.5 rounded-full text-sm font-semibold shadow-md shadow-blue-600/20 transition-all hover:-translate-y-0.5">Regístrate</a>
                        </div>
                    </div>
                </div>
            </header>

            <main class="flex-grow pt-28 pb-12">
                <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">

                    <div class="flex flex-col md:flex-row md:justify-between md:items-end mb-10 gap-4">
                        <div>
                            <h2 class="text-3xl font-extrabold tracking-tight text-slate-900">Propiedades Destacadas
                            </h2>
                            <p class="text-slate-500 mt-2">Encuentra casas, departamentos y terrenos al mejor precio.
                            </p>
                        </div>
                        <a href="${pageContext.request.contextPath}/propiedades?accion=nuevo"
                            class="inline-flex items-center justify-center bg-indigo-600 hover:bg-indigo-700 text-white px-6 py-3 rounded-xl font-semibold shadow-lg shadow-indigo-600/20 transition-all hover:-translate-y-1">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24"
                                stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M12 4v16m8-8H4" />
                            </svg>
                            Añadir Propiedad
                        </a>
                    </div>

                    <!-- Barra de Búsqueda -->
                    <form action="${pageContext.request.contextPath}/propiedades" method="get" class="mb-10 bg-white p-4 rounded-2xl shadow-sm border border-slate-200 flex flex-col md:flex-row gap-4">
                        <div class="flex-grow">
                            <label class="sr-only">Buscar</label>
                            <input type="text" name="q" value="${paramQ}" placeholder="Buscar por distrito, título o descripción..." class="w-full px-4 py-3 rounded-xl border border-slate-300 focus:ring-2 focus:ring-indigo-500 outline-none text-slate-700">
                        </div>
                        <div class="md:w-48">
                            <select name="operacion" class="w-full px-4 py-3 rounded-xl border border-slate-300 focus:ring-2 focus:ring-indigo-500 outline-none text-slate-700 bg-white">
                                <option value="">Todas las Operaciones</option>
                                <option value="VENTA" ${paramOperacion == 'VENTA' ? 'selected' : ''}>Venta</option>
                                <option value="ALQUILER" ${paramOperacion == 'ALQUILER' ? 'selected' : ''}>Alquiler</option>
                                <option value="ANTICRESIS" ${paramOperacion == 'ANTICRESIS' ? 'selected' : ''}>Anticresis</option>
                            </select>
                        </div>
                        <div class="md:w-48">
                            <select name="tipo" class="w-full px-4 py-3 rounded-xl border border-slate-300 focus:ring-2 focus:ring-indigo-500 outline-none text-slate-700 bg-white">
                                <option value="">Todos los Tipos</option>
                                <option value="Casa" ${paramTipo == 'Casa' ? 'selected' : ''}>Casa</option>
                                <option value="Departamento" ${paramTipo == 'Departamento' ? 'selected' : ''}>Departamento</option>
                                <option value="Terreno" ${paramTipo == 'Terreno' ? 'selected' : ''}>Terreno</option>
                                <option value="Local Comercial" ${paramTipo == 'Local Comercial' ? 'selected' : ''}>Local Comercial</option>
                            </select>
                        </div>
                        <button type="submit" class="bg-indigo-600 hover:bg-indigo-700 text-white px-8 py-3 rounded-xl font-bold shadow-md transition-colors">
                            Buscar
                        </button>
                    </form>

                    <c:choose>
                        <c:when test="${empty listaPropiedades}">
                            <div class="bg-amber-50 border-l-4 border-amber-500 p-6 rounded-r-xl shadow-sm">
                                <div class="flex items-start">
                                    <div class="flex-shrink-0">
                                        <svg class="h-6 w-6 text-amber-500" xmlns="http://www.w3.org/2000/svg"
                                            fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                                        </svg>
                                    </div>
                                    <div class="ml-4">
                                        <h3 class="text-amber-800 font-bold text-lg">No hay propiedades disponibles</h3>
                                        <div class="mt-2 text-amber-700">
                                            <p>Actualmente no hay propiedades agregadas o no se pudo conectar a la base
                                                de datos MySQL.</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                                <c:forEach var="propiedad" items="${listaPropiedades}">
                                    <!-- Card -->
                                    <div
                                        class="group bg-white rounded-2xl shadow-sm hover:shadow-xl border border-slate-200 overflow-hidden transition-all duration-300 hover:-translate-y-1 flex flex-col">
                                        <div class="relative h-56 bg-slate-200 overflow-hidden">
                                            <!-- Placeholder Image (Since no image URL in the original DB, using a random unsplash architecture photo) -->
                                            <img src="https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80"
                                                alt="Propiedad"
                                                class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
                                                <div
                                                    class="absolute top-4 left-4 bg-white/90 backdrop-blur-sm px-3 py-1 rounded-full text-xs font-bold text-indigo-600 shadow-sm uppercase">
                                                    <c:out value="${propiedad.operacion != null ? propiedad.operacion : 'En Venta'}" />
                                                </div>
                                        </div>
                                        <div class="p-6 flex-grow flex flex-col">
                                            <div class="flex items-baseline gap-2 mb-2">
                                                <h3 class="text-2xl font-bold text-slate-900 line-clamp-1">
                                                    <c:out value="${propiedad.titulo}" />
                                                </h3>
                                            </div>
                                            <div class="flex items-center text-slate-500 text-sm mb-3">
                                                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-1 text-slate-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                                                </svg>
                                                <span class="truncate">
                                                    <c:out value="${propiedad.distrito != null ? propiedad.distrito : propiedad.ubicacion}" /><c:if test="${propiedad.provincia != null}">, <c:out value="${propiedad.provincia}" /></c:if>
                                                </span>
                                            </div>
                                            
                                            <div class="flex gap-4 text-xs font-semibold text-slate-600 mb-4 bg-slate-50 p-2 rounded-lg">
                                                <c:if test="${propiedad.numDormitorios > 0}">
                                                    <div class="flex items-center gap-1">🛏️ ${propiedad.numDormitorios} dor.</div>
                                                </c:if>
                                                <c:if test="${propiedad.numBanos > 0}">
                                                    <div class="flex items-center gap-1">🛁 ${propiedad.numBanos} bañ.</div>
                                                </c:if>
                                                <c:if test="${propiedad.areaTechadaM2 != null}">
                                                    <div class="flex items-center gap-1">📐 ${propiedad.areaTechadaM2} m²</div>
                                                </c:if>
                                            </div>
                                            <p class="text-slate-600 text-sm mb-6 line-clamp-2 flex-grow">
                                                <c:out value="${propiedad.descripcion}" />
                                            </p>
                                            <div
                                                class="pt-4 border-t border-slate-100 flex justify-between items-center mt-auto">
                                                <div>
                                                    <div class="text-emerald-600 font-extrabold text-xl">
                                                        US$ <c:out value="${propiedad.precioUsd != null ? propiedad.precioUsd : propiedad.precio}" />
                                                    </div>
                                                    <c:if test="${propiedad.precioPen != null}">
                                                        <div class="text-xs text-slate-500 font-medium">
                                                            S/ <c:out value="${propiedad.precioPen}" />
                                                        </div>
                                                    </c:if>
                                                </div>
                                                <div class="flex gap-2">
                                                    <a href="${pageContext.request.contextPath}/propiedades?accion=editar&id=${propiedad.id}"
                                                        class="text-sm font-semibold text-indigo-600 hover:text-indigo-800 transition-colors bg-indigo-50 px-3 py-1.5 rounded-lg">Editar</a>
                                                    <a href="${pageContext.request.contextPath}/propiedades?accion=eliminar&id=${propiedad.id}"
                                                        onclick="return confirm('¿Estás seguro de eliminar esta propiedad?');"
                                                        class="text-sm font-semibold text-red-600 hover:text-red-800 transition-colors bg-red-50 px-3 py-1.5 rounded-lg">Eliminar</a>
                                                </div>
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
                        <img src="${pageContext.request.contextPath}/assets/img/logo/inmobix_logo.png"
                            alt="Inmobix Logo" class="h-6 w-auto grayscale">
                        <span class="text-xl font-bold text-slate-300">Inmobix</span>
                    </div>
                    <p class="text-sm">&copy; 2026 Portal Inmobiliario. Todos los derechos reservados.</p>
                </div>
            </footer>
        </body>

        </html>