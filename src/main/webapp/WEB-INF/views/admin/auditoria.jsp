<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es" class="scroll-smooth">
<head>
    <c:set var="pageTitle" value="Inmobix - Auditoría de Sistema" scope="request" />
    <jsp:include page="/WEB-INF/views/layout/head.jsp" />
    <script src="${pageContext.request.contextPath}/assets/js/admin.js" defer></script>
</head>
<body class="bg-brandBg text-brandText flex flex-col min-h-screen font-sans">
    
    <!-- Navbar -->
        <c:set var="activePage" value="auditoria" scope="request" />
    <c:set var="isAdminArea" value="true" scope="request" />
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <main class="flex-grow pt-28 pb-16 px-4">
        <div class="max-w-7xl mx-auto">
            
            <div class="mb-8">
                <h1 class="text-3xl font-bold text-slate-900 tracking-tight">Bitácora de Auditoría del Sistema</h1>
                <p class="text-slate-500 mt-2">Monitorea en tiempo real todas las acciones administrativas, inicios de sesión y modificaciones críticas de datos.</p>
            </div>

            <!-- Tabla de Logs de Auditoría -->
            <div class="bg-white rounded-2xl shadow-xl shadow-slate-200/50 border border-slate-100 overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full text-left text-sm text-slate-600">
                        <thead class="bg-slate-50 border-b border-slate-100 text-slate-700 uppercase font-semibold text-xs tracking-wider">
                            <tr>
                                <th class="px-6 py-4">ID</th>
                                <th class="px-6 py-4">Fecha y Hora</th>
                                <th class="px-6 py-4">Usuario</th>
                                <th class="px-6 py-4">Acción</th>
                                <th class="px-6 py-4">Módulo/Entidad</th>
                                <th class="px-6 py-4">Origen IP</th>
                                <th class="px-6 py-4 text-center">Detalle</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-100">
                            <c:forEach var="e" items="${listaEventos}">
                                <tr class="hover:bg-slate-50/80 transition-colors">
                                    <td class="px-6 py-4 font-bold text-slate-400">#${e.idEvento}</td>
                                    <td class="px-6 py-4 font-medium text-slate-700">${e.fechaEvento}</td>
                                    <td class="px-6 py-4">
                                        <div class="font-semibold text-slate-900">${e.usuarioNombre}</div>
                                        <c:if test="${e.idUsuario != null && e.idUsuario > 0}">
                                            <div class="text-[10px] text-slate-400">ID Usuario: #${e.idUsuario}</div>
                                        </c:if>
                                    </td>
                                    <td class="px-6 py-4">
                                        <c:choose>
                                            <c:when test="${e.accion == 'LOGIN'}">
                                                <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-bold bg-blue-100 text-blue-700">LOGIN</span>
                                            </c:when>
                                            <c:when test="${e.accion == 'LOGOUT'}">
                                                <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-bold bg-slate-100 text-slate-700">LOGOUT</span>
                                            </c:when>
                                            <c:when test="${e.accion == 'CREAR'}">
                                                <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-bold bg-emerald-100 text-emerald-700">CREAR</span>
                                            </c:when>
                                            <c:when test="${e.accion == 'ACTUALIZAR'}">
                                                <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-bold bg-amber-100 text-amber-700">ACTUALIZAR</span>
                                            </c:when>
                                            <c:when test="${e.accion == 'ELIMINAR'}">
                                                <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-bold bg-red-100 text-red-700">ELIMINAR</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-bold bg-purple-100 text-purple-700">${e.accion}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="px-6 py-4 font-semibold text-slate-700 uppercase text-xs tracking-wider">
                                        ${e.entidad}
                                        <c:if test="${e.idEntidad != null && e.idEntidad > 0}">
                                            <span class="text-[10px] text-slate-400 font-normal"> (ID: #${e.idEntidad})</span>
                                        </c:if>
                                    </td>
                                    <td class="px-6 py-4">
                                        <div class="font-mono text-xs text-slate-800">${e.ipOrigen}</div>
                                        <div class="text-[10px] text-slate-400 truncate max-w-xs" title="${e.userAgent}">${e.userAgent}</div>
                                    </td>
                                    <td class="px-6 py-4 text-center">
                                        <button onclick="toggleDetail(${e.idEvento})" class="border border-slate-200 text-slate-700 hover:text-black hover:border-black hover:bg-black/5 px-3 py-1.5 rounded-lg text-xs font-bold transition-all">
                                            Ver JSON
                                        </button>
                                    </td>
                                </tr>
                                <tr id="detail-${e.idEvento}" class="hidden bg-slate-100/50">
                                    <td colspan="7" class="px-8 py-4 border-t border-b border-slate-200">
                                        <div class="bg-slate-900 text-emerald-400 p-4 rounded-xl font-mono text-xs overflow-x-auto shadow-inner border border-slate-800">
                                            <pre>${e.detalleJson}</pre>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listaEventos}">
                                <tr>
                                    <td colspan="7" class="px-6 py-8 text-center text-slate-400 italic">No se han registrado eventos de auditoría todavía.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </main>

    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
</body>
</html>
