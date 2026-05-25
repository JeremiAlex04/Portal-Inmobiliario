<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png">
    <title>Inmobix - Moderación de Propiedades</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <script src="https://cdn.tailwindcss.com"></script>
        <script>
            tailwind.config = {
                theme: {
                    extend: {
                        colors: {
                            brandHeader: '#000000',
                            brandFooter: '#000000',
                            brandBtn: '#000000',
                            brandHover: '#71717A',
                            brandBg: '#FFFFFF',
                            brandText: '#0A0A0A'
                        }
                    }
                }
            }
        </script>
    <script>
        function confirmarEliminacion(url) {
            if (confirm("¿Seguro que deseas ELIMINAR permanentemente esta propiedad de la plataforma?")) {
                window.location.href = url;
            }
        }
    </script>
</head>
<body class="bg-brandBg text-brandText flex flex-col min-h-screen font-sans">
    
    <!-- Navbar -->
    <header class="text-white fixed w-full top-0 z-50 bg-black/90 backdrop-blur-md border-b border-white/10 shadow-lg transition-all">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center h-20">
                <div class="flex items-center gap-3">
                    <img src="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png" alt="Inmobix Logo" class="h-10 w-auto object-contain brightness-0 invert">
                    <span class="text-2xl font-bold text-white tracking-tight">Inmobix Admin</span>
                </div>
                
                <nav class="hidden md:flex items-center gap-8">
                    <a href="${pageContext.request.contextPath}/admin?accion=dashboard" class="text-sm font-semibold text-slate-300 hover:text-white transition-colors">Dashboard</a>
                    <a href="${pageContext.request.contextPath}/admin?accion=usuarios" class="text-sm font-semibold text-slate-300 hover:text-white transition-colors">Usuarios</a>
                    <a href="${pageContext.request.contextPath}/admin?accion=propiedades" class="text-sm font-bold text-blue-400 border-b-2 border-blue-400 py-1 transition-colors">Propiedades</a>
                    <a href="${pageContext.request.contextPath}/admin?accion=ubicaciones" class="text-sm font-semibold text-slate-300 hover:text-white transition-colors">Ubicaciones</a>
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
            
            <div class="mb-8 flex justify-between items-center">
                <div>
                    <h1 class="text-3xl font-bold text-slate-900 tracking-tight">Moderación de Propiedades</h1>
                    <p class="text-slate-500 mt-2">Gestiona, aprueba, rechaza o elimina cualquier publicación inmobiliaria.</p>
                </div>
            </div>

            <!-- Barra de búsqueda -->
            <div class="bg-white rounded-2xl shadow-md border border-slate-100 p-4 mb-6">
                <form action="${pageContext.request.contextPath}/admin" method="GET" class="flex flex-col md:flex-row gap-3 items-end">
                    <input type="hidden" name="accion" value="propiedades">
                    <div class="flex-[2]">
                        <label class="block text-xs font-bold text-slate-500 mb-1">Buscar (distrito, título, descripción)</label>
                        <input type="text" name="busqueda" value="${busquedaActual}" placeholder="Ej: Miraflores, Departamento..." class="w-full bg-slate-50 border border-slate-200 rounded-lg px-3 py-2.5 text-sm">
                    </div>
                    <div class="flex-1">
                        <label class="block text-xs font-bold text-slate-500 mb-1">Operación</label>
                        <select name="operacion" class="w-full bg-slate-50 border border-slate-200 rounded-lg px-3 py-2.5 text-sm">
                            <option value="">Todas</option>
                            <option value="VENTA" ${operacionActual == 'VENTA' ? 'selected' : ''}>Venta</option>
                            <option value="ALQUILER" ${operacionActual == 'ALQUILER' ? 'selected' : ''}>Alquiler</option>
                        </select>
                    </div>
                    <div class="flex-1">
                        <label class="block text-xs font-bold text-slate-500 mb-1">Tipo Inmueble</label>
                        <select name="tipoInmueble" class="w-full bg-slate-50 border border-slate-200 rounded-lg px-3 py-2.5 text-sm">
                            <option value="">Todos</option>
                            <option value="Casa" ${tipoActual == 'Casa' ? 'selected' : ''}>Casa</option>
                            <option value="Departamento" ${tipoActual == 'Departamento' ? 'selected' : ''}>Departamento</option>
                            <option value="Terreno" ${tipoActual == 'Terreno' ? 'selected' : ''}>Terreno</option>
                        </select>
                    </div>
                    <button type="submit" class="bg-slate-900 text-white px-6 py-2.5 rounded-lg text-sm font-bold hover:bg-slate-800 transition-colors">Buscar</button>
                    <a href="${pageContext.request.contextPath}/admin?accion=propiedades" class="text-sm text-slate-500 hover:text-slate-700 font-bold px-4 py-2.5">Limpiar</a>
                </form>
            </div>

            <!-- Tabla de Propiedades -->
            <div class="bg-white rounded-2xl shadow-xl shadow-slate-200/50 border border-slate-100 overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full text-left text-sm text-slate-600">
                        <thead class="bg-slate-50 border-b border-slate-100 text-slate-700 uppercase font-semibold text-xs tracking-wider">
                            <tr>
                                <th class="px-6 py-4">Inmueble</th>
                                <th class="px-6 py-4">Ubicación</th>
                                <th class="px-6 py-4">Operación</th>
                                <th class="px-6 py-4">Precio</th>
                                <th class="px-6 py-4">Estado (Moderación)</th>
                                <th class="px-6 py-4 text-center">Acciones</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-100">
                            <c:forEach var="p" items="${listaPropiedades}">
                                <tr class="hover:bg-slate-50 transition-colors">
                                    <td class="px-6 py-4">
                                        <div class="font-bold text-slate-900 line-clamp-1 w-48">${p.titulo}</div>
                                        <div class="text-xs text-slate-400 mt-1">${p.tipoInmueble} - #${p.id}</div>
                                    </td>
                                    <td class="px-6 py-4 font-medium">${p.distrito}, ${p.provincia}</td>
                                    <td class="px-6 py-4">
                                        <span class="inline-flex items-center px-2 py-1 rounded text-xs font-bold ${p.operacion == 'VENTA' ? 'bg-indigo-100 text-indigo-700' : 'bg-emerald-100 text-emerald-700'}">
                                            ${p.operacion}
                                        </span>
                                    </td>
                                    <td class="px-6 py-4 font-bold text-slate-900">
                                        US$ ${p.precioUsd}
                                    </td>
                                    <td class="px-6 py-4">
                                        <form action="${pageContext.request.contextPath}/admin" method="GET" class="flex items-center gap-2">
                                            <input type="hidden" name="accion" value="cambiar_estado_prop">
                                            <input type="hidden" name="id" value="${p.id}">
                                            <select name="estado" onchange="this.form.submit()" class="bg-slate-50 border border-slate-200 text-slate-700 text-xs rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2">
                                                <option value="ACTIVO" ${p.estado == 'ACTIVO' ? 'selected' : ''}>Disponible (Activo)</option>
                                                <option value="INACTIVO" ${p.estado == 'INACTIVO' ? 'selected' : ''}>Oculto (Inactivo)</option>
                                                <option value="VENDIDO" ${p.estado == 'VENDIDO' ? 'selected' : ''}>Vendido</option>
                                                <option value="ALQUILADO" ${p.estado == 'ALQUILADO' ? 'selected' : ''}>Alquilado</option>
                                                <option value="RECHAZADO" ${p.estado == 'RECHAZADO' ? 'selected' : ''}>Rechazado (Spam)</option>
                                            </select>
                                        </form>
                                    </td>
                                    <td class="px-6 py-4">
                                        <div class="flex justify-center gap-2">
                                            <a href="${pageContext.request.contextPath}/propiedades?accion=ver&id=${p.id}" target="_blank" class="text-xs font-bold px-3 py-1.5 rounded-lg bg-blue-50 text-blue-600 hover:bg-blue-100 transition-colors">Ver Detalles</a>
                                            <button onclick="confirmarEliminacion('${pageContext.request.contextPath}/admin?accion=eliminar_prop&id=${p.id}')" class="text-xs font-bold px-3 py-1.5 rounded-lg bg-red-50 text-red-600 hover:bg-red-100 transition-colors">Eliminar</button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listaPropiedades}">
                                <tr>
                                    <td colspan="6" class="px-6 py-12 text-center text-slate-500">No hay propiedades registradas en la plataforma.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </main>

</body>
</html>
