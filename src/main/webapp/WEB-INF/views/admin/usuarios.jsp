<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es" class="scroll-smooth">
<head>
    <c:set var="pageTitle" value="Inmobix - Gestión de Usuarios" scope="request" />
    <jsp:include page="/WEB-INF/views/layout/head.jsp" />
    <script src="${pageContext.request.contextPath}/assets/js/admin.js" defer></script>
</head>
<body class="bg-brandBg text-brandText flex flex-col min-h-screen font-sans">
    
    <!-- Navbar -->
        <c:set var="activePage" value="usuarios" scope="request" />
    <c:set var="isAdminArea" value="true" scope="request" />
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <main class="flex-grow pt-28 pb-16 px-4">
        <div class="max-w-7xl mx-auto">
            
            <div class="mb-8 flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
                <div>
                    <h1 class="text-3xl font-bold text-slate-900 tracking-tight">Gestión de Usuarios</h1>
                    <p class="text-slate-500 mt-2">Administra roles, accesos y estado de todas las cuentas del sistema.</p>
                </div>
                <button onclick="abrirModalNuevo()" class="bg-brandBtn hover:bg-brandHover text-white px-6 py-3 rounded-xl font-bold shadow-lg shadow-brandBtn/20 transition-all hover:-translate-y-0.5 flex items-center gap-2">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M10 3a1 1 0 011 1v5h5a1 1 0 110 2h-5v5a1 1 0 11-2 0v-5H4a1 1 0 110-2h5V4a1 1 0 011-1z" clip-rule="evenodd" />
                    </svg>
                    Nuevo Usuario
                </button>
            </div>

            <!-- Barra de búsqueda -->
            <div class="bg-white rounded-2xl shadow-md border border-slate-100 p-4 mb-6">
                <form action="${pageContext.request.contextPath}/admin" method="GET" class="flex flex-col md:flex-row gap-3 items-end">
                    <input type="hidden" name="accion" value="usuarios">
                    <div class="flex-1">
                        <label class="block text-xs font-bold text-slate-500 mb-1">Buscar por</label>
                        <select name="filtro" class="w-full bg-slate-50 border border-slate-200 rounded-lg px-3 py-2.5 text-sm">
                            <option value="nombre" ${filtroActual == 'nombre' ? 'selected' : ''}>Nombre</option>
                            <option value="correo" ${filtroActual == 'correo' ? 'selected' : ''}>Correo</option>
                            <option value="rol" ${filtroActual == 'rol' ? 'selected' : ''}>Rol (ID)</option>
                        </select>
                    </div>
                    <div class="flex-[2]">
                        <label class="block text-xs font-bold text-slate-500 mb-1">Término de búsqueda</label>
                        <input type="text" name="busqueda" value="${busquedaActual}" placeholder="Escribe aquí..." class="w-full bg-slate-50 border border-slate-200 rounded-lg px-3 py-2.5 text-sm">
                    </div>
                    <button type="submit" class="bg-slate-900 text-white px-6 py-2.5 rounded-lg text-sm font-bold hover:bg-slate-800 transition-colors">Buscar</button>
                    <a href="${pageContext.request.contextPath}/admin?accion=usuarios" class="text-sm text-slate-500 hover:text-slate-700 font-bold px-4 py-2.5">Limpiar</a>
                </form>
            </div>

            <!-- Tabla de Usuarios -->
            <div class="bg-white rounded-2xl shadow-xl shadow-slate-200/50 border border-slate-100 overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full text-left text-sm text-slate-600">
                        <thead class="bg-slate-50 border-b border-slate-100 text-slate-700 uppercase font-semibold text-xs tracking-wider">
                            <tr>
                                <th class="px-6 py-4">ID</th>
                                <th class="px-6 py-4">Usuario</th>
                                <th class="px-6 py-4">Contacto</th>
                                <th class="px-6 py-4">Rol</th>
                                <th class="px-6 py-4">Estado</th>
                                <th class="px-6 py-4 text-center">Acciones</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-100">
                            <c:forEach var="u" items="${listaUsuarios}">
                                <tr class="hover:bg-slate-50 transition-colors">
                                    <td class="px-6 py-4 font-bold text-slate-400">#${u.idUsuario}</td>
                                    <td class="px-6 py-4">
                                        <div class="font-bold text-slate-900">${u.nombres} ${u.apellidos}</div>
                                        <div class="text-xs text-slate-400 mt-1">Registrado: ${u.fechaRegistro}</div>
                                    </td>
                                    <td class="px-6 py-4 font-medium">${u.correo}</td>
                                    <td class="px-6 py-4">
                                        <form action="${pageContext.request.contextPath}/admin" method="GET" class="flex items-center gap-2">
                                            <input type="hidden" name="accion" value="cambiar_rol">
                                            <input type="hidden" name="id" value="${u.idUsuario}">
                                            <select name="rol" onchange="if(confirm('¿Estás seguro de cambiar el rol de este usuario?')) { this.form.submit(); } else { location.reload(); }" class="bg-slate-50 border border-slate-200 text-slate-700 text-xs rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2" ${u.idUsuario == sessionScope.usuarioLogueado.idUsuario ? 'disabled' : ''}>
                                                <option value="2" ${u.idRol == 2 ? 'selected' : ''}>COMPRADOR</option>
                                                <option value="3" ${u.idRol == 3 ? 'selected' : ''}>AGENTE</option>
                                                <option value="4" ${u.idRol == 4 ? 'selected' : ''}>CONSTRUCTORA</option>
                                                <option value="5" ${u.idRol == 5 ? 'selected' : ''}>ADMIN</option>
                                            </select>
                                        </form>
                                    </td>
                                    <td class="px-6 py-4">
                                        <c:choose>
                                            <c:when test="${u.activo == 1}">
                                                <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold bg-emerald-100 text-emerald-700">
                                                    <span class="w-1.5 h-1.5 rounded-full bg-emerald-600"></span> Activo
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold bg-red-100 text-red-700">
                                                    <span class="w-1.5 h-1.5 rounded-full bg-red-600"></span> Bloqueado
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="px-6 py-4">
                                        <div class="flex justify-center gap-2">
                                            <c:if test="${u.idUsuario != sessionScope.usuarioLogueado.idUsuario}">
                                                <button onclick="abrirModalEditar('${u.idUsuario}', '${u.nombres}', '${u.apellidos}', '${u.correo}')" class="text-xs font-bold px-3 py-1.5 rounded-lg border border-slate-200 text-slate-700 hover:text-black hover:border-black hover:bg-black/5 transition-all">Editar</button>
                                                <c:choose>
                                                    <c:when test="${u.activo == 1}">
                                                        <a href="${pageContext.request.contextPath}/admin?accion=cambiar_estado&id=${u.idUsuario}&estado=0" class="text-xs font-bold px-3 py-1.5 rounded-lg bg-orange-50 text-orange-600 hover:bg-orange-100 transition-colors">Bloquear</a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="${pageContext.request.contextPath}/admin?accion=cambiar_estado&id=${u.idUsuario}&estado=1" class="text-xs font-bold px-3 py-1.5 rounded-lg bg-emerald-50 text-emerald-600 hover:bg-emerald-100 transition-colors">Activar</a>
                                                    </c:otherwise>
                                                </c:choose>
                                                
                                                <button onclick="confirmarEliminacion('${pageContext.request.contextPath}/admin?accion=eliminar_usuario&id=${u.idUsuario}')" class="text-xs font-bold px-3 py-1.5 rounded-lg bg-red-50 text-red-600 hover:bg-red-100 transition-colors">Eliminar</button>
                                            </c:if>
                                            <c:if test="${u.idUsuario == sessionScope.usuarioLogueado.idUsuario}">
                                                <span class="text-xs text-slate-400 italic">Tú (Admin)</span>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listaUsuarios}">
                                <tr>
                                    <td colspan="6" class="px-6 py-12 text-center text-slate-500 italic">No se encontraron usuarios que coincidan con la búsqueda o filtros.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </main>

    <!-- Modal Crear/Editar Usuario -->
    <div id="modalUsuario" class="fixed inset-0 z-[60] hidden items-center justify-center bg-slate-900/60 backdrop-blur-sm p-4">
        <div class="bg-white rounded-3xl shadow-2xl w-full max-w-md overflow-hidden transform transition-all">
            <div class="bg-slate-900 px-8 py-6 flex justify-between items-center">
                <h3 id="modalUsuarioTitle" class="text-xl font-bold text-white">Registrar Nuevo Usuario</h3>
                <button onclick="cerrarModalUsuario()" class="text-slate-400 hover:text-white transition-colors">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg>
                </button>
            </div>
            
            <form action="${pageContext.request.contextPath}/admin" method="POST" class="p-8 space-y-5">
                <input type="hidden" name="accion" id="formAccion" value="registrar_usuario">
                <input type="hidden" name="id" id="formUserId">

                <div>
                    <label class="block text-sm font-bold text-slate-700 mb-2">Nombres</label>
                    <input type="text" name="nombres" id="formNombres" required class="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-slate-700 focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none">
                </div>
                <div>
                    <label class="block text-sm font-bold text-slate-700 mb-2">Apellidos</label>
                    <input type="text" name="apellidos" id="formApellidos" required class="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-slate-700 focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none">
                </div>
                <div>
                    <label class="block text-sm font-bold text-slate-700 mb-2">Correo Electrónico</label>
                    <input type="email" name="correo" id="formCorreo" required class="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-slate-700 focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none">
                </div>
                <div id="passwordField">
                    <label class="block text-sm font-bold text-slate-700 mb-2">Contraseña</label>
                    <input type="password" name="password" minlength="6" class="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-slate-700 focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none">
                </div>
                <div id="rolField">
                    <label class="block text-sm font-bold text-slate-700 mb-2">Rol</label>
                    <select name="idRol" class="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-slate-700 focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none">
                        <option value="2">COMPRADOR</option>
                        <option value="3">AGENTE</option>
                        <option value="4">CONSTRUCTORA</option>
                        <option value="5">ADMINISTRADOR</option>
                    </select>
                </div>

                <div class="pt-4 flex gap-3">
                    <button type="button" onclick="cerrarModalUsuario()" class="flex-1 border border-slate-200 text-slate-700 hover:text-black hover:border-black hover:bg-black/5 font-bold py-4 rounded-xl transition-all">Cancelar</button>
                    <button type="submit" class="flex-1 bg-brandBtn hover:bg-brandHover text-white font-bold py-4 rounded-xl shadow-lg shadow-brandBtn/20 transition-all">Guardar</button>
                </div>
            </form>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
</body>
</html>
