<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png">
    <title>Inmobix - Gestión de Ubicaciones</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        function confirmarEliminacion(id, tipo) {
            if (confirm("¿Estás seguro de eliminar esta ubicación? Podría afectar a propiedades asociadas.")) {
                window.location.href = "${pageContext.request.contextPath}/admin?accion=eliminar_ubicacion&id=" + id + "&tipo=" + tipo;
            }
        }

        function editarUbicacion(id, nombre, codigo, parentId) {
            document.getElementById('modalTitle').innerText = 'Editar Ubicación';
            document.getElementById('formId').value = id;
            document.getElementById('formNombre').value = nombre;
            document.getElementById('formCodigo').value = codigo;
            
            const parentSelect = document.getElementById('formParentId');
            if (parentSelect) {
                parentSelect.value = parentId;
            }
            
            document.getElementById('ubicacionModal').classList.remove('hidden');
            document.getElementById('ubicacionModal').classList.add('flex');
        }

        function nuevaUbicacion() {
            document.getElementById('modalTitle').innerText = 'Nueva Ubicación';
            document.getElementById('formId').value = '';
            document.getElementById('formNombre').value = '';
            document.getElementById('formCodigo').value = '';
            
            const parentSelect = document.getElementById('formParentId');
            if (parentSelect) {
                parentSelect.selectedIndex = 0;
            }
            
            document.getElementById('ubicacionModal').classList.remove('hidden');
            document.getElementById('ubicacionModal').classList.add('flex');
        }

        function cerrarModal() {
            document.getElementById('ubicacionModal').classList.add('hidden');
            document.getElementById('ubicacionModal').classList.remove('flex');
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
                    <a href="${pageContext.request.contextPath}/admin?accion=usuarios" class="text-sm font-semibold text-slate-300 hover:text-white transition-colors">Usuarios</a>
                    <a href="${pageContext.request.contextPath}/admin?accion=propiedades" class="text-sm font-semibold text-slate-300 hover:text-white transition-colors">Propiedades</a>
                    <a href="${pageContext.request.contextPath}/admin?accion=ubicaciones" class="text-sm font-bold text-blue-400 border-b-2 border-blue-400 py-1 transition-colors">Ubicaciones</a>
                    <a href="${pageContext.request.contextPath}/admin?accion=auditoria" class="text-sm font-semibold text-slate-300 hover:text-white transition-colors">Auditoría</a>
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
            
            <div class="mb-8 flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
                <div>
                    <h1 class="text-3xl font-bold text-slate-900 tracking-tight">Gestión de Ubicaciones</h1>
                    <p class="text-slate-500 mt-2">Administra Departamentos, Provincias y Distritos para la geolocalización de inmuebles.</p>
                </div>
                <button onclick="nuevaUbicacion()" class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-xl font-bold shadow-lg shadow-blue-600/20 transition-all hover:-translate-y-0.5 flex items-center gap-2">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M10 3a1 1 0 011 1v5h5a1 1 0 110 2h-5v5a1 1 0 11-2 0v-5H4a1 1 0 110-2h5V4a1 1 0 011-1z" clip-rule="evenodd" />
                    </svg>
                    Agregar ${tipoActual}
                </button>
            </div>

            <!-- Tabs de Navegación -->
            <div class="flex border-b border-slate-200 mb-8 overflow-x-auto">
                <a href="${pageContext.request.contextPath}/admin?accion=ubicaciones&tipo=DEPARTAMENTO" class="px-6 py-3 text-sm font-bold transition-all border-b-2 ${tipoActual == 'DEPARTAMENTO' ? 'border-blue-600 text-blue-600' : 'border-transparent text-slate-500 hover:text-slate-700'}">Departamentos</a>
                <a href="${pageContext.request.contextPath}/admin?accion=ubicaciones&tipo=PROVINCIA" class="px-6 py-3 text-sm font-bold transition-all border-b-2 ${tipoActual == 'PROVINCIA' ? 'border-blue-600 text-blue-600' : 'border-transparent text-slate-500 hover:text-slate-700'}">Provincias</a>
                <a href="${pageContext.request.contextPath}/admin?accion=ubicaciones&tipo=DISTRITO" class="px-6 py-3 text-sm font-bold transition-all border-b-2 ${tipoActual == 'DISTRITO' ? 'border-blue-600 text-blue-600' : 'border-transparent text-slate-500 hover:text-slate-700'}">Distritos</a>
            </div>

            <!-- Tabla de Ubicaciones -->
            <div class="bg-white rounded-2xl shadow-xl shadow-slate-200/50 border border-slate-100 overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full text-left text-sm text-slate-600">
                        <thead class="bg-slate-50 border-b border-slate-100 text-slate-700 uppercase font-semibold text-xs tracking-wider">
                            <tr>
                                <th class="px-6 py-4">ID</th>
                                <th class="px-6 py-4">Nombre</th>
                                <th class="px-6 py-4">Código Ubigeo</th>
                                <c:if test="${tipoActual != 'DEPARTAMENTO'}">
                                    <th class="px-6 py-4">Pertenece a</th>
                                </c:if>
                                <th class="px-6 py-4 text-center">Acciones</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-100">
                            <c:forEach var="u" items="${listaUbicaciones}">
                                <tr class="hover:bg-slate-50 transition-colors">
                                    <td class="px-6 py-4 font-bold text-slate-400">#${u.id}</td>
                                    <td class="px-6 py-4">
                                        <div class="font-bold text-slate-900">${u.nombre}</div>
                                    </td>
                                    <td class="px-6 py-4">
                                        <span class="px-2 py-1 bg-slate-100 rounded text-xs font-mono font-bold text-slate-600">${u.codigoUbigeo}</span>
                                    </td>
                                    <c:if test="${tipoActual != 'DEPARTAMENTO'}">
                                        <td class="px-6 py-4">
                                            <span class="text-slate-500 font-medium">${u.parentNombre}</span>
                                        </td>
                                    </c:if>
                                    <td class="px-6 py-4">
                                        <div class="flex justify-center gap-2">
                                            <button onclick="editarUbicacion('${u.id}', '${u.nombre}', '${u.codigoUbigeo}', '${u.parentId}')" class="text-xs font-bold px-3 py-1.5 rounded-lg bg-blue-50 text-blue-600 hover:bg-blue-100 transition-colors">Editar</button>
                                            <button onclick="confirmarEliminacion('${u.id}', '${tipoActual}')" class="text-xs font-bold px-3 py-1.5 rounded-lg bg-red-50 text-red-600 hover:bg-red-100 transition-colors">Eliminar</button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listaUbicaciones}">
                                <tr>
                                    <td colspan="5" class="px-6 py-12 text-center text-slate-400 italic">No hay ubicaciones registradas en esta categoría.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </main>

    <!-- Modal Formulario -->
    <div id="ubicacionModal" class="fixed inset-0 z-[60] hidden items-center justify-center bg-slate-900/60 backdrop-blur-sm p-4">
        <div class="bg-white rounded-3xl shadow-2xl w-full max-w-md overflow-hidden transform transition-all">
            <div class="bg-slate-900 px-8 py-6 flex justify-between items-center">
                <h3 id="modalTitle" class="text-xl font-bold text-white">Nueva Ubicación</h3>
                <button onclick="cerrarModal()" class="text-slate-400 hover:text-white transition-colors">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                </button>
            </div>
            
            <form action="${pageContext.request.contextPath}/admin" method="POST" class="p-8 space-y-6">
                <input type="hidden" name="accion" value="guardar_ubicacion">
                <input type="hidden" name="id" id="formId">
                <input type="hidden" name="tipo" value="${tipoActual}">

                <c:if test="${tipoActual != 'DEPARTAMENTO'}">
                    <div>
                        <label class="block text-sm font-bold text-slate-700 mb-2">Seleccionar ${tipoActual == 'PROVINCIA' ? 'Departamento' : 'Provincia'}</label>
                        <select name="parentId" id="formParentId" required class="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-slate-700 focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none transition-all">
                            <c:forEach var="p" items="${listaPadres}">
                                <option value="${p.id}">${p.nombre}</option>
                            </c:forEach>
                        </select>
                    </div>
                </c:if>

                <div>
                    <label class="block text-sm font-bold text-slate-700 mb-2">Nombre de la Ubicación</label>
                    <input type="text" name="nombre" id="formNombre" required placeholder="Ej: Lima, Cusco, Miraflores..." class="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-slate-700 focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none transition-all">
                </div>

                <div>
                    <label class="block text-sm font-bold text-slate-700 mb-2">Código Ubigeo (INEI)</label>
                    <input type="text" name="codigoUbigeo" id="formCodigo" required placeholder="Ej: 15, 1501, 150101..." class="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-slate-700 focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none transition-all">
                </div>

                <div class="pt-4 flex gap-3">
                    <button type="button" onclick="cerrarModal()" class="flex-1 bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold py-4 rounded-xl transition-all">Cancelar</button>
                    <button type="submit" class="flex-1 bg-blue-600 hover:bg-blue-700 text-white font-bold py-4 rounded-xl shadow-lg shadow-blue-600/20 transition-all">Guardar</button>
                </div>
            </form>
        </div>
    </div>

</body>
</html>
