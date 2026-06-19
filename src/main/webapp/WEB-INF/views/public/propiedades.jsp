<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="es" class="scroll-smooth">

        <head>
            <c:set var="pageTitle" value="Inmobix - Catálogo de Propiedades" scope="request" />
            <jsp:include page="/WEB-INF/views/layout/head.jsp" />
            <script src="${pageContext.request.contextPath}/assets/js/propiedades.js" defer></script>
        </head>

        <body class="bg-brandBg text-brandText flex flex-col min-h-screen font-sans" data-context-path="${pageContext.request.contextPath}">

            <!-- Navbar Premium con Glassmorphism -->
                <c:set var="activePage" value="catalogo" scope="request" />
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

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
                            class="inline-flex items-center justify-center bg-brandBtn hover:bg-brandHover text-white px-6 py-3 rounded-xl font-semibold shadow-lg shadow-indigo-600/20 transition-all hover:-translate-y-1">
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
                            <button type="submit" class="bg-brandBtn hover:bg-brandHover text-white px-8 py-2.5 rounded-xl font-bold shadow-md transition-colors">Buscar</button>
                            <a href="${pageContext.request.contextPath}/propiedades" class="text-sm text-slate-500 hover:text-slate-700 font-bold px-4 py-2.5">Limpiar</a>
                        </div>
                    </form>

                    <!-- Contador de resultados y Selector de Vista -->
                    <div class="flex justify-between items-center mb-6">
                        <c:if test="${totalResultados != null}">
                            <div class="text-sm font-semibold text-slate-500">
                                Se encontraron <span class="text-slate-900 font-black">${totalResultados}</span> propiedades
                            </div>
                        </c:if>
                        <c:if test="${totalResultados == null}">
                            <div></div>
                        </c:if>
                        
                        <!-- Controladores de vista Cuadrícula/Lista -->
                        <div class="flex items-center bg-slate-100 p-1 rounded-xl border border-slate-200 gap-1">
                            <button type="button" id="btn-view-grid" class="p-2 rounded-lg text-black bg-white shadow-sm transition-all" title="Vista Cuadrícula (Vertical)">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z" />
                                </svg>
                            </button>
                            <button type="button" id="btn-view-list" class="p-2 rounded-lg text-slate-600 hover:text-black transition-all" title="Vista Lista (Horizontal)">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
                                </svg>
                            </button>
                        </div>
                    </div>

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
                            <div id="propiedades-container" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                                <c:forEach var="propiedad" items="${listaPropiedades}">
                                    <!-- Card -->
                                    <div
                                        class="propiedad-card group bg-white rounded-2xl shadow-sm hover:shadow-xl border border-slate-200 overflow-hidden transition-all duration-300 hover:-translate-y-1 flex flex-col">
                                        <!-- Imagen con foto principal Sprint 2 -->
                                        <div class="propiedad-img-container relative h-56 bg-gradient-to-br from-slate-200 to-slate-300 overflow-hidden">
                                            <c:choose>
                                                <c:when test="${not empty propiedad.fotoPrincipal}">
                                                    <img src="${propiedad.getFotoPrincipalUrl(pageContext.request.contextPath)}" alt="${propiedad.titulo}"
                                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
                                                </c:when>
                                                 <c:otherwise>
                                                     <div class="w-full h-full flex items-center justify-center text-slate-400">
                                                         <svg class="w-12 h-12 text-slate-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>
                                                     </div>
                                                 </c:otherwise>
                                            </c:choose>
                                            <div class="absolute top-4 left-4 bg-white/90 backdrop-blur-sm px-3 py-1 rounded-full text-xs font-bold text-indigo-600 shadow-sm uppercase">
                                                <c:out value="${propiedad.operacion != null ? propiedad.operacion : 'En Venta'}" />
                                            </div>
                                            <!-- Sprint 2: -->
                                             <c:if test="${not empty sessionScope.usuarioLogueado}">
                                                 <c:choose>
                                                     <c:when test="${propiedad.favorito}">
                                                         <form action="${pageContext.request.contextPath}/favorito" method="POST" class="absolute top-4 right-4 z-10 m-0 p-0">
                                                             <input type="hidden" name="accion" value="remover">
                                                             <input type="hidden" name="id" value="${propiedad.id}">
                                                             <button type="submit" class="w-10 h-10 bg-red-500 text-white rounded-full flex items-center justify-center shadow-lg hover:bg-red-600 transition-colors cursor-pointer border-0" title="Quitar de favoritos">
                                                                 <svg class="w-5 h-5 text-white fill-current" viewBox="0 0 24 24"><path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"></path></svg>
                                                             </button>
                                                         </form>
                                                     </c:when>
                                                     <c:otherwise>
                                                         <form action="${pageContext.request.contextPath}/favorito" method="POST" class="absolute top-4 right-4 z-10 m-0 p-0">
                                                             <input type="hidden" name="accion" value="agregar">
                                                             <input type="hidden" name="id" value="${propiedad.id}">
                                                             <button type="submit" class="w-10 h-10 bg-white/80 backdrop-blur text-slate-400 rounded-full flex items-center justify-center shadow-lg hover:bg-red-50 hover:text-red-500 transition-colors cursor-pointer border-0" title="Guardar en favoritos">
                                                                 <svg class="w-5 h-5 text-slate-400 hover:text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"></path></svg>
                                                             </button>
                                                         </form>
                                                     </c:otherwise>
                                                 </c:choose>
                                             </c:if>
                                        </div>
                                        <div class="propiedad-body p-6 flex-grow flex flex-col">
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
                                                <a href="${pageContext.request.contextPath}/propiedades?accion=ver&id=${propiedad.id}" class="text-sm font-bold text-white bg-brandBtn hover:bg-brandHover px-5 py-2 rounded-lg shadow-md">Ver Detalle</a>
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
                                        <a href="${pageContext.request.contextPath}/propiedades?page=${currentPage - 1}&${paginParams}" class="px-4 py-2 border border-slate-200 rounded-lg text-slate-600 hover:bg-black/5 hover:border-black hover:text-black font-semibold transition-all">Anterior</a>
                                    </c:if>
                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <c:choose>
                                            <c:when test="${currentPage == i}">
                                                <span class="px-4 py-2 bg-brandBtn text-white rounded-lg font-bold shadow-md shadow-brandBtn/20">${i}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${pageContext.request.contextPath}/propiedades?page=${i}&${paginParams}" class="px-4 py-2 border border-slate-200 rounded-lg text-slate-600 hover:bg-black/5 hover:border-black hover:text-black font-semibold transition-all">${i}</a>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                    <c:if test="${currentPage < totalPages}">
                                        <a href="${pageContext.request.contextPath}/propiedades?page=${currentPage + 1}&${paginParams}" class="px-4 py-2 border border-slate-200 rounded-lg text-slate-600 hover:bg-black/5 hover:border-black hover:text-black font-semibold transition-all">Siguiente</a>
                                    </c:if>
                                </div>
                            </c:if>
                        </c:otherwise>
                    </c:choose>

                </div>
            </main>

            <!-- Footer -->
            <jsp:include page="/WEB-INF/views/layout/footer.jsp" />

            <!-- Sprint 3: Botón flotante comparador -->
            <div id="compBar" class="hidden fixed bottom-6 left-1/2 -translate-x-1/2 z-50 bg-slate-900 text-white px-8 py-4 rounded-full shadow-2xl flex items-center gap-4 font-bold border border-white/10">
                <span id="compCount">Comparar (0)</span>
                <button onclick="irComparar()" class="bg-transparent border border-white hover:bg-white hover:text-black text-white px-4 py-2 rounded-full text-sm font-bold transition-all duration-300">Ver Comparación</button>
                <button onclick="limpiarComparador()" class="text-slate-400 hover:text-white p-1 rounded-full hover:bg-white/10 transition-colors" title="Limpiar">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M6 18L18 6M6 6l12 12"></path>
                    </svg>
                </button>
            </div>

            
        </body>
        </html>