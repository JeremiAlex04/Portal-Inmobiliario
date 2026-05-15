<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png">
    <title>Inmobix - Gestión de Usuarios</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        function confirmarEliminacion(url) {
            if (confirm("¿Estás seguro que deseas ELIMINAR a este usuario de la plataforma? Esta acción es irreversible.")) {
                window.location.href = url;
            }
        }
    </script>
</head>
<body class="bg-slate-50 text-slate-800 flex flex-col min-h-screen font-sans">
    
    <!-- Navbar -->
    <header class="fixed w-full top-0 z-50 bg-slate-900 border-b border-slate-800 shadow-sm transition-all">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center h-20">
                <div class="flex items-center gap-3">
                    <img src="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png" alt="Inmobix Logo" class="h-10 w-auto object-contain brightness-0 invert">
                    <span class="text-2xl font-bold text-white tracking-tight">Inmobix Admin</span>
                </div>
                
                <nav class="hidden md:flex items-center gap-8">
                    <a href="${pageContext.request.contextPath}/admin?accion=dashboard" class="text-sm font-semibold text-slate-300 hover:text-white transition-colors">Dashboard</a>
                    <a href="${pageContext.request.contextPath}/admin?accion=usuarios" class="text-sm font-bold text-blue-400 border-b-2 border-blue-400 py-1 transition-colors">Usuarios</a>
                    <a href="${pageContext.request.contextPath}/admin?accion=propiedades" class="text-sm font-semibold text-slate-300 hover:text-white transition-colors">Propiedades</a>
                </nav>

                <div class="hidden md:flex items-center gap-4">
                    <span class="text-sm font-semibold text-slate-300">Admin: ${sessionScope.usuarioLogueado.nombres}</span>
                    <a href="${pageContext.request.contextPath}/usuario?accion=logout" class="bg-red-600 hover:bg-red-700 text-white px-5 py-2.5 rounded-full text-sm font-semibold shadow-md shadow-red-600/20 transition-all hover:-translate-y-0.5">Cerrar Sesión</a>
                </div>
            </div>
        </div>
    </header>

    <main class="flex-grow pt-28 pb-16 px-4">
        <div class="max-w-7xl mx-auto">
            
            <div class="mb-8 flex justify-between items-center">
                <div>
                    <h1 class="text-3xl font-bold text-slate-900 tracking-tight">Gestión de Usuarios</h1>
                    <p class="text-slate-500 mt-2">Administra roles, accesos y estado de todas las cuentas del sistema.</p>
                </div>
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
                                            <select name="rol" onchange="this.form.submit()" class="bg-slate-50 border border-slate-200 text-slate-700 text-xs rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2" ${u.idUsuario == sessionScope.usuarioLogueado.idUsuario ? 'disabled' : ''}>
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
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </main>

</body>
</html>
