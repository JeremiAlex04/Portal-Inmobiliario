<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="es" class="scroll-smooth">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <link rel="icon" type="image/png"
                href="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png">
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
                            <a href="${pageContext.request.contextPath}/pagos?accion=planes"
                                class="text-sm font-semibold text-slate-600 hover:text-blue-600 transition-colors">Planes</a>
                            <a href="${pageContext.request.contextPath}/propiedades?accion=nuevo"
                                class="text-sm font-semibold text-slate-600 hover:text-blue-600 transition-colors">Publicar</a>
                            <c:if test="${not empty sessionScope.usuarioLogueado}">
                                <a href="${pageContext.request.contextPath}/favorito?accion=listar"
                                    class="text-sm font-semibold text-red-500 hover:text-red-600 transition-colors">♥ Favoritos</a>
                            </c:if>
                            <a href="${pageContext.request.contextPath}/contacto"
                                class="text-sm font-semibold text-slate-600 hover:text-blue-600 transition-colors">Contacto</a>
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

                    <!-- Barra de Búsqueda Avanzada (Sprint 2) -->
                    <form action="${pageContext.request.contextPath}/propiedades" method="get" class="mb-6 bg-white p-5 rounded-2xl shadow-sm border border-slate-200">
                        <div class="flex flex-col md:flex-row gap-3 mb-3">
                            <div class="flex-grow">
                                <input type="text" name="q" value="${paramQ}" placeholder="Buscar por distrito, título o descripción..." class="w-full px-4 py-3 rounded-xl border border-slate-300 focus:ring-2 focus:ring-indigo-500 outline-none text-slate-700">
                            </div>
                            <div class="md:w-44">
                                <select name="operacion" class="w-full px-4 py-3 rounded-xl border border-slate-300 focus:ring-2 focus:ring-indigo-500 outline-none text-slate-700 bg-white">
                                    <option value="">Operación</option>
                                    <option value="VENTA" ${paramOperacion == 'VENTA' ? 'selected' : ''}>Venta</option>
                                    <option value="ALQUILER" ${paramOperacion == 'ALQUILER' ? 'selected' : ''}>Alquiler</option>
                                </select>
                            </div>
                            <div class="md:w-44">
                                <select name="tipo" class="w-full px-4 py-3 rounded-xl border border-slate-300 focus:ring-2 focus:ring-indigo-500 outline-none text-slate-700 bg-white">
                                    <option value="">Tipo Inmueble</option>
                                    <option value="Casa" ${paramTipo == 'Casa' ? 'selected' : ''}>Casa</option>
                                    <option value="Departamento" ${paramTipo == 'Departamento' ? 'selected' : ''}>Departamento</option>
                                    <option value="Terreno" ${paramTipo == 'Terreno' ? 'selected' : ''}>Terreno</option>
                                    <option value="Local Comercial" ${paramTipo == 'Local Comercial' ? 'selected' : ''}>Local Comercial</option>
                                </select>
                            </div>
                        </div>
                        <!-- Filtros avanzados Sprint 2 -->
                        <div class="flex flex-col md:flex-row gap-3 items-end">
                            <div class="md:w-36">
                                <label class="block text-xs font-bold text-slate-500 mb-1">Precio Mín (USD)</label>
                                <input type="number" name="precioMin" value="${paramPrecioMin}" placeholder="0" min="0" class="w-full px-3 py-2.5 rounded-lg border border-slate-300 text-sm">
                            </div>
                            <div class="md:w-36">
                                <label class="block text-xs font-bold text-slate-500 mb-1">Precio Máx (USD)</label>
                                <input type="number" name="precioMax" value="${paramPrecioMax}" placeholder="∞" min="0" class="w-full px-3 py-2.5 rounded-lg border border-slate-300 text-sm">
                            </div>
                            <div class="md:w-36">
                                <label class="block text-xs font-bold text-slate-500 mb-1">Dormitorios</label>
                                <select name="dormitorios" class="w-full px-3 py-2.5 rounded-lg border border-slate-300 text-sm bg-white">
                                    <option value="">Todos</option>
                                    <option value="1" ${paramDormitorios == '1' ? 'selected' : ''}>1</option>
                                    <option value="2" ${paramDormitorios == '2' ? 'selected' : ''}>2</option>
                                    <option value="3" ${paramDormitorios == '3' ? 'selected' : ''}>3</option>
                                    <option value="4" ${paramDormitorios == '4' ? 'selected' : ''}>4+</option>
                                </select>
                            </div>
                            <div class="md:w-36">
                                <label class="block text-xs font-bold text-slate-500 mb-1">Baños</label>
                                <select name="banos" class="w-full px-3 py-2.5 rounded-lg border border-slate-300 text-sm bg-white">
                                    <option value="">Todos</option>
                                    <option value="1" ${paramBanos == '1' ? 'selected' : ''}>1</option>
                                    <option value="2" ${paramBanos == '2' ? 'selected' : ''}>2</option>
                                    <option value="3" ${paramBanos == '3' ? 'selected' : ''}>3+</option>
                                </select>
                            </div>
                            <button type="submit" class="bg-indigo-600 hover:bg-indigo-700 text-white px-8 py-2.5 rounded-xl font-bold shadow-md transition-colors">Buscar</button>
                            <a href="${pageContext.request.contextPath}/propiedades" class="text-sm text-slate-500 hover:text-slate-700 font-bold px-4 py-2.5">Limpiar</a>
                        </div>
                    </form>

                    <!-- Contador de resultados -->
                    <c:if test="${totalResultados != null}">
                        <div class="mb-6 text-sm font-semibold text-slate-500">
                            Se encontraron <span class="text-slate-900 font-black">${totalResultados}</span> propiedades
                        </div>
                    </c:if>

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
                                        <!-- Imagen con foto principal Sprint 2 -->
                                        <div class="relative h-56 bg-gradient-to-br from-slate-200 to-slate-300 overflow-hidden">
                                            <c:choose>
                                                <c:when test="${not empty propiedad.fotoPrincipal}">
                                                    <img src="${pageContext.request.contextPath}/${propiedad.fotoPrincipal}" alt="${propiedad.titulo}"
                                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="w-full h-full flex items-center justify-center text-slate-400 text-6xl">🏠</div>
                                                </c:otherwise>
                                            </c:choose>
                                            <div class="absolute top-4 left-4 bg-white/90 backdrop-blur-sm px-3 py-1 rounded-full text-xs font-bold text-indigo-600 shadow-sm uppercase">
                                                <c:out value="${propiedad.operacion != null ? propiedad.operacion : 'En Venta'}" />
                                            </div>
                                            <!-- Sprint 2: Botón favorito -->
                                            <c:if test="${not empty sessionScope.usuarioLogueado}">
                                                <c:choose>
                                                    <c:when test="${propiedad.favorito}">
                                                        <a href="${pageContext.request.contextPath}/favorito?accion=remover&id=${propiedad.id}" class="absolute top-4 right-4 w-10 h-10 bg-red-500 text-white rounded-full flex items-center justify-center text-lg shadow-lg hover:bg-red-600 transition-colors" title="Quitar de favoritos">♥</a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="${pageContext.request.contextPath}/favorito?accion=agregar&id=${propiedad.id}" class="absolute top-4 right-4 w-10 h-10 bg-white/80 backdrop-blur text-slate-400 rounded-full flex items-center justify-center text-lg shadow-lg hover:bg-red-50 hover:text-red-500 transition-colors" title="Guardar en favoritos">♡</a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:if>
                                        </div>
                                        <div class="p-6 flex-grow flex flex-col">
                                            <h3 class="text-xl font-bold text-slate-900 line-clamp-1 mb-2">
                                                <c:out value="${propiedad.titulo}" />
                                            </h3>
                                            <div class="flex items-center text-slate-500 text-sm mb-3">
                                                <svg class="w-4 h-4 text-red-500 mr-1 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                                                <span class="truncate">
                                                    <c:out value="${propiedad.distrito != null ? propiedad.distrito : propiedad.ubicacion}" /><c:if test="${propiedad.provincia != null}">, <c:out value="${propiedad.provincia}" /></c:if>
                                                </span>
                                            </div>
                                            
                                            <div class="flex gap-3 text-[10px] font-bold text-slate-500 mb-4 bg-slate-50 p-2 rounded-lg uppercase tracking-tight">
                                                <c:if test="${propiedad.numDormitorios > 0}">
                                                    <div class="flex items-center gap-1">
                                                        <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>
                                                        ${propiedad.numDormitorios} Dorm.
                                                    </div>
                                                </c:if>
                                                <c:if test="${propiedad.numBanos > 0}">
                                                    <div class="flex items-center gap-1">
                                                        <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"></path></svg>
                                                        ${propiedad.numBanos} Baños
                                                    </div>
                                                </c:if>
                                                <c:if test="${propiedad.areaTechadaM2 != null}">
                                                    <div class="flex items-center gap-1">
                                                        <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 8V4m0 0h4M4 4l5 5m11-1V4m0 0h-4m4 0l-5 5M4 16v4m0 0h4m-4 0l5-5m11 5l-5-5m5 5v-4m0 4h-4"></path></svg>
                                                        ${propiedad.areaTechadaM2} m²
                                                    </div>
                                                </c:if>
                                            </div>
                                            <p class="text-slate-600 text-sm mb-4 line-clamp-2 flex-grow">
                                                <c:out value="${propiedad.descripcion}" />
                                            </p>
                                            <div class="pt-4 border-t border-slate-100 flex justify-between items-center mt-auto">
                                                <div>
                                                    <div class="text-blue-600 font-extrabold text-lg">
                                                        US$ <c:out value="${propiedad.precioUsd != null ? propiedad.precioUsd : propiedad.precio}" />
                                                    </div>
                                                    <c:if test="${propiedad.precioPen != null}">
                                                        <div class="text-xs text-slate-500 font-medium">S/. <c:out value="${propiedad.precioPen}" /></div>
                                                    </c:if>
                                                </div>
                                                <a href="${pageContext.request.contextPath}/propiedades?accion=ver&id=${propiedad.id}" class="text-sm font-bold text-white bg-blue-600 hover:bg-blue-700 px-5 py-2 rounded-lg shadow-md">Ver Detalle</a>
                                            </div>
                                            <!-- Sprint 3: Checkbox comparador -->
                                            <label class="flex items-center gap-2 mt-3 text-xs text-slate-500 cursor-pointer hover:text-blue-600">
                                                <input type="checkbox" class="comp-check rounded" data-id="${propiedad.id}" onchange="actualizarComparador()">
                                                Agregar a comparación
                                            </label>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>

                            <!-- Paginación -->
                            <c:if test="${totalPages > 1}">
                                <c:set var="paginParams" value="q=${paramQ}&operacion=${paramOperacion}&tipo=${paramTipo}&precioMin=${paramPrecioMin}&precioMax=${paramPrecioMax}&dormitorios=${paramDormitorios}&banos=${paramBanos}" />
                                <div class="mt-12 flex justify-center items-center gap-2">
                                    <c:if test="${currentPage > 1}">
                                        <a href="${pageContext.request.contextPath}/propiedades?page=${currentPage - 1}&${paginParams}" class="px-4 py-2 border border-slate-200 rounded-lg text-slate-600 hover:bg-slate-50 font-semibold transition-colors">Anterior</a>
                                    </c:if>
                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <c:choose>
                                            <c:when test="${currentPage == i}">
                                                <span class="px-4 py-2 bg-blue-600 text-white rounded-lg font-bold shadow-md shadow-blue-600/20">${i}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${pageContext.request.contextPath}/propiedades?page=${i}&${paginParams}" class="px-4 py-2 border border-slate-200 rounded-lg text-slate-600 hover:bg-slate-50 font-semibold transition-colors">${i}</a>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                    <c:if test="${currentPage < totalPages}">
                                        <a href="${pageContext.request.contextPath}/propiedades?page=${currentPage + 1}&${paginParams}" class="px-4 py-2 border border-slate-200 rounded-lg text-slate-600 hover:bg-slate-50 font-semibold transition-colors">Siguiente</a>
                                    </c:if>
                                </div>
                            </c:if>
                        </c:otherwise>
                    </c:choose>

                </div>
            </main>

            <!-- Footer -->
            <footer class="bg-slate-900 border-t border-slate-800 text-slate-400 py-12 mt-auto">
                <div class="max-w-7xl mx-auto px-4 text-center">
                    <div class="flex justify-center items-center gap-2 mb-6 opacity-80">
                        <img src="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png"
                            alt="Inmobix Logo" class="h-6 w-auto grayscale">
                        <span class="text-xl font-bold text-slate-300">Inmobix</span>
                    </div>
                    <p class="text-sm">&copy; 2026 Portal Inmobiliario. Todos los derechos reservados.</p>
                </div>
            </footer>

            <!-- Sprint 3: Botón flotante comparador -->
            <div id="compBar" class="hidden fixed bottom-6 left-1/2 -translate-x-1/2 z-50 bg-indigo-600 text-white px-8 py-4 rounded-full shadow-2xl flex items-center gap-4 font-bold">
                <span id="compCount">Comparar (0)</span>
                <button onclick="irComparar()" class="bg-white text-indigo-700 px-4 py-2 rounded-full text-sm font-bold hover:bg-indigo-50">Ver Comparación</button>
                <button onclick="limpiarComparador()" class="text-indigo-200 hover:text-white text-sm">✕</button>
            </div>

            <script>
            let comparar_ids = JSON.parse(localStorage.getItem('comparar_ids') || '[]');
            function actualizarComparador() {
                comparar_ids = [];
                document.querySelectorAll('.comp-check:checked').forEach(cb => {
                    if(comparar_ids.length < 4) comparar_ids.push(cb.dataset.id);
                    else { cb.checked = false; alert('Máximo 4 propiedades.'); }
                });
                localStorage.setItem('comparar_ids', JSON.stringify(comparar_ids));
                const bar = document.getElementById('compBar');
                document.getElementById('compCount').textContent = 'Comparar (' + comparar_ids.length + ')';
                bar.classList.toggle('hidden', comparar_ids.length === 0);
            }
            function irComparar() {
                if(comparar_ids.length < 2) { alert('Selecciona al menos 2 propiedades.'); return; }
                window.location.href = '${pageContext.request.contextPath}/comparar?ids=' + comparar_ids.join(',');
            }
            function limpiarComparador() {
                comparar_ids = []; localStorage.removeItem('comparar_ids');
                document.querySelectorAll('.comp-check').forEach(cb => cb.checked = false);
                actualizarComparador();
            }
            // Restore on load
            window.addEventListener('DOMContentLoaded', function() {
                comparar_ids.forEach(id => {
                    const cb = document.querySelector('.comp-check[data-id="'+id+'"]');
                    if(cb) cb.checked = true;
                });
                actualizarComparador();
            });
            </script>
        </body>
        </html>