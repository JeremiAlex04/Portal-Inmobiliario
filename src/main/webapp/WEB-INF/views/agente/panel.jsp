<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es" class="scroll-smooth">
<head>
    <c:set var="pageTitle" value="Inmobix - Panel de Agente" scope="request" />
    <jsp:include page="/WEB-INF/views/layout/head.jsp" />
    <script src="${pageContext.request.contextPath}/assets/js/admin.js" defer></script>
</head>
<body class="bg-brandBg text-brandText flex flex-col min-h-screen font-sans">
    
    <!-- Navbar -->
        <c:set var="activePage" value="panel" scope="request" />
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <main class="flex-grow pt-28 pb-16 px-4">
        <div class="max-w-7xl mx-auto">
            
            <!-- Sprint 3: Métricas rápidas -->
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
                <div class="bg-white rounded-xl shadow border p-4 text-center"><div class="text-2xl font-black text-blue-600">${consultasPendientesGlobal}</div><div class="text-xs text-slate-500 font-bold">Consultas Pendientes</div></div>
                <div class="bg-white rounded-xl shadow border p-4 text-center"><div class="text-2xl font-black text-emerald-600">${whatsappSemana}</div><div class="text-xs text-slate-500 font-bold">WhatsApp esta semana</div></div>
            </div>

            <div class="flex justify-between items-center mb-6">
                <div class="flex gap-2">
                    <a href="${pageContext.request.contextPath}/panel?seccion=propiedades" class="px-5 py-2.5 rounded-lg text-sm font-bold ${seccion != 'consultas' ? 'bg-brandBtn text-white shadow-lg shadow-brandBtn/20' : 'border border-slate-200 text-slate-600 hover:bg-black/5 hover:text-black hover:border-black transition-all'}">Mis Propiedades</a>
                    <a href="${pageContext.request.contextPath}/panel?seccion=consultas" class="px-5 py-2.5 rounded-lg text-sm font-bold ${seccion == 'consultas' ? 'bg-brandBtn text-white shadow-lg shadow-brandBtn/20' : 'border border-slate-200 text-slate-600 hover:bg-black/5 hover:text-black hover:border-black transition-all'}">Consultas</a>
                </div>
                <a href="${pageContext.request.contextPath}/propiedades?accion=nuevo" class="bg-brandBtn hover:bg-brandHover text-white px-6 py-3 rounded-lg font-bold shadow-lg flex items-center gap-2 text-sm">+ Publicar</a>
            </div>

            <c:if test="${seccion != 'consultas'}">
            <!-- Sprint 2: Filtros de estado y ordenamiento -->
            <div class="bg-white rounded-2xl shadow-md border border-slate-100 p-4 mb-6">
                <form action="${pageContext.request.contextPath}/panel" method="get" class="flex flex-col md:flex-row gap-3 items-end">
                    <div class="flex-1">
                        <label class="block text-xs font-bold text-slate-500 mb-1">Estado</label>
                        <select name="estado" class="w-full bg-slate-50 border border-slate-200 rounded-lg px-3 py-2.5 text-sm">
                            <option value="">Todas</option>
                            <option value="ACTIVO" ${filtroEstado == 'ACTIVO' ? 'selected' : ''}>Activas</option>
                            <option value="BORRADOR" ${filtroEstado == 'BORRADOR' ? 'selected' : ''}>Borrador</option>
                            <option value="VENDIDO" ${filtroEstado == 'VENDIDO' ? 'selected' : ''}>Vendidas</option>
                            <option value="PAUSADO" ${filtroEstado == 'PAUSADO' ? 'selected' : ''}>Pausadas</option>
                        </select>
                    </div>
                    <div class="flex-1">
                        <label class="block text-xs font-bold text-slate-500 mb-1">Ordenar por</label>
                        <select name="orden" class="w-full bg-slate-50 border border-slate-200 rounded-lg px-3 py-2.5 text-sm">
                            <option value="fecha" ${filtroOrden != 'vistas' ? 'selected' : ''}>Más recientes</option>
                            <option value="vistas" ${filtroOrden == 'vistas' ? 'selected' : ''}>Más vistas</option>
                        </select>
                    </div>
                    <button type="submit" class="bg-brandBtn hover:bg-brandHover text-white px-6 py-2.5 rounded-lg text-sm font-bold shadow-md transition-all">Filtrar</button>
                    <a href="${pageContext.request.contextPath}/panel" class="text-sm text-slate-500 hover:text-slate-700 font-bold px-4 py-2.5">Limpiar</a>
                </form>
            </div>

            <!-- Tabla de Propiedades -->
            <div class="bg-white rounded-2xl shadow-xl shadow-slate-200/50 border border-slate-100 overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full text-left text-sm text-slate-600">
                        <thead class="bg-slate-50 border-b border-slate-100 text-slate-700 uppercase font-semibold text-xs tracking-wider">
                            <tr>
                                <th class="px-6 py-4">Propiedad</th>
                                <th class="px-6 py-4">Tipo / Operación</th>
                                <th class="px-6 py-4">Ubicación</th>
                                <th class="px-6 py-4">Precio</th>
                                 <th class="px-6 py-4 text-center">Vistas</th>
                                <th class="px-6 py-4">Estado</th>
                                <th class="px-6 py-4 text-center">Acciones</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-100">
                            <c:choose>
                                <c:when test="${empty listaMisPropiedades}">
                                    <tr>
                                        <td colspan="7" class="px-6 py-8 text-center text-slate-500">
                                            No tienes propiedades publicadas todavía. ¡Haz clic en "Publicar Inmueble" para empezar!
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="p" items="${listaMisPropiedades}">
                                        <tr class="hover:bg-slate-50 transition-colors">
                                            <td class="px-6 py-4">
                                                <div class="flex items-center gap-3">
                                                    <c:choose>
                                                        <c:when test="${not empty p.fotoPrincipal}">
                                                            <img src="${p.getFotoPrincipalUrl(pageContext.request.contextPath)}" alt="" class="w-14 h-10 object-cover rounded-lg border border-slate-200">
                                                        </c:when>
                                                         <c:otherwise>
                                                             <div class="w-14 h-10 bg-slate-100 rounded-lg flex items-center justify-center text-slate-400">
                                                                 <svg class="w-6 h-6 text-slate-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>
                                                             </div>
                                                         </c:otherwise>
                                                    </c:choose>
                                                    <div>
                                                        <div class="font-bold text-slate-800 line-clamp-1 w-40">${p.titulo}</div>
                                                        <div class="text-xs text-slate-400">#${p.id}</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="px-6 py-4">
                                                <span class="block">${p.tipoInmueble}</span>
                                                <span class="block text-xs text-slate-400 font-semibold uppercase mt-1">${p.operacion}</span>
                                            </td>
                                            <td class="px-6 py-4">${p.distrito}</td>
                                            <td class="px-6 py-4 font-bold text-slate-900">
                                                ${p.monedaBase == 'USD' ? 'US$' : 'S/.'} ${p.precio}
                                            </td>
                                            <td class="px-6 py-4 text-center">
                                                <span class="inline-flex items-center px-3 py-1 bg-blue-50 text-blue-700 rounded-full text-xs font-bold">${p.numeroVistas}</span>
                                            </td>
                                            <td class="px-6 py-4">
                                                <span class="inline-flex items-center px-2 py-1 rounded text-xs font-bold
                                                    ${p.estado == 'ACTIVO' ? 'bg-emerald-100 text-emerald-700' : 
                                                      p.estado == 'VENDIDO' ? 'bg-purple-100 text-purple-700' : 
                                                      p.estado == 'BORRADOR' ? 'bg-amber-100 text-amber-700' : 'bg-slate-100 text-slate-700'}">
                                                    ${p.estado}
                                                </span>
                                            </td>
                                            <td class="px-6 py-4">
                                                <div class="flex justify-center gap-2">
                                                    <a href="${pageContext.request.contextPath}/propiedades?accion=editar&id=${p.id}" class="text-blue-600 bg-blue-50 hover:bg-blue-100 px-3 py-1.5 rounded-lg text-xs font-bold flex items-center gap-1">
                                                        <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path></svg>
                                                        Editar
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/analytics?id=${p.id}" class="text-purple-600 bg-purple-50 hover:bg-purple-100 px-3 py-1.5 rounded-lg text-xs font-bold" title="Analytics">
                                                        <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v16m-6 0a2 2 0 002 2h2a2 2 0 002-2"></path></svg>
                                                    </a>
                                                    <button onclick="confirmarEliminacion('${pageContext.request.contextPath}/propiedades', {accion: 'eliminar', id: '${p.id}'})" class="text-red-600 bg-red-50 hover:bg-red-100 px-3 py-1.5 rounded-lg text-xs font-bold">
                                                        <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path></svg>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </c:if>

            <!-- Sprint 3: Sección Consultas -->
            <c:if test="${seccion == 'consultas'}">
            <div class="bg-white rounded-2xl shadow-xl border p-4 mb-6">
                <form action="${pageContext.request.contextPath}/panel" method="get" class="flex gap-3 items-end">
                    <input type="hidden" name="seccion" value="consultas">
                    <div class="flex-1"><label class="block text-xs font-bold text-slate-500 mb-1">Estado</label>
                    <select name="estadoConsulta" class="w-full bg-slate-50 border rounded-lg px-3 py-2.5 text-sm">
                        <option value="">Todas</option>
                        <option value="PENDIENTE" ${filtroConsultaEstado == 'PENDIENTE' ? 'selected' : ''}>Pendientes</option>
                        <option value="LEIDA" ${filtroConsultaEstado == 'LEIDA' ? 'selected' : ''}>Leídas</option>
                        <option value="RESPONDIDA" ${filtroConsultaEstado == 'RESPONDIDA' ? 'selected' : ''}>Respondidas</option>
                        <option value="NO_INTERESADO" ${filtroConsultaEstado == 'NO_INTERESADO' ? 'selected' : ''}>No interesado</option>
                    </select></div>
                    <button class="bg-slate-900 text-white px-6 py-2.5 rounded-lg text-sm font-bold">Filtrar</button>
                </form>
            </div>
            <div class="bg-white rounded-2xl shadow-xl border overflow-hidden"><div class="overflow-x-auto">
            <table class="w-full text-sm">
                <thead class="bg-slate-50 border-b text-xs uppercase tracking-wider"><tr>
                    <th class="px-4 py-3">Fecha</th><th class="px-4 py-3 text-left">Propiedad</th><th class="px-4 py-3 text-left">De</th><th class="px-4 py-3 text-left">Mensaje</th><th class="px-4 py-3">Estado</th><th class="px-4 py-3">Acción</th>
                </tr></thead>
                <tbody class="divide-y">
                <c:choose><c:when test="${empty listaConsultas}"><tr><td colspan="6" class="px-4 py-8 text-center text-slate-500">No hay consultas.</td></tr></c:when>
                <c:otherwise><c:forEach var="c" items="${listaConsultas}"><tr class="hover:bg-slate-50">
                    <td class="px-4 py-3 text-xs text-slate-400">${c.fecha}</td>
                    <td class="px-4 py-3 font-bold text-slate-800"><a href="${pageContext.request.contextPath}/propiedades?accion=ver&id=${c.idPropiedad}" class="hover:text-blue-600">${c.tituloPropiedad}</a></td>
                    <td class="px-4 py-3"><div class="font-bold text-slate-800">${c.nombre}</div><div class="text-xs text-slate-400">${c.email}</div></td>
                    <td class="px-4 py-3 text-slate-600 max-w-xs truncate">${c.mensaje}</td>
                    <td class="px-4 py-3 text-center"><span class="px-2 py-1 rounded text-xs font-bold ${c.estado == 'PENDIENTE' ? 'bg-amber-100 text-amber-700' : c.estado == 'LEIDA' ? 'bg-blue-100 text-blue-700' : c.estado == 'RESPONDIDA' ? 'bg-emerald-100 text-emerald-700' : 'bg-slate-100 text-slate-600'}">${c.estado}</span></td>
                    <td class="px-4 py-3 text-center">
                        <form action="${pageContext.request.contextPath}/consulta" method="post" class="inline-flex gap-1">
                            <input type="hidden" name="accion" value="cambiarEstado"><input type="hidden" name="idConsulta" value="${c.id}">
                            <select name="nuevoEstado" class="text-xs border rounded px-1 py-1"><option value="LEIDA">Leída</option><option value="RESPONDIDA">Respondida</option><option value="NO_INTERESADO">No interesado</option></select>
                            <button class="bg-slate-800 text-white px-2 py-1 rounded text-xs font-bold">OK</button>
                        </form>
                    </td>
                </tr></c:forEach></c:otherwise></c:choose>
                </tbody>
            </table></div></div>
            </c:if>

        </div>
    </main>
    <!-- Footer -->
    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
</body></html>
