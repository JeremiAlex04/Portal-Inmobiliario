<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es" class="scroll-smooth">
<head>
    <c:set var="pageTitle" value="Inmobix - Dashboard Administrador" scope="request" />
    <jsp:include page="/WEB-INF/views/layout/head.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
</head>
<body class="bg-brandBg text-brandText flex flex-col min-h-screen font-sans">
    
    <!-- Navbar -->
    <c:set var="activePage" value="dashboard" scope="request" />
    <c:set var="isAdminArea" value="true" scope="request" />
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <main class="flex-grow pt-28 pb-16 px-4">
        <div class="max-w-7xl mx-auto">
            
            <div class="mb-8">
                <h1 class="text-3xl font-bold text-slate-900 tracking-tight">Panel de Control</h1>
                <p class="text-slate-500 mt-2">Visión global del portal inmobiliario.</p>
            </div>

            <!-- Dashboard Stats -->
            <div class="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-6 gap-6 mb-10">
                
                <div class="bg-white rounded-2xl p-6 shadow-xl shadow-slate-200/50 border border-slate-100 flex items-center gap-4">
                    <div class="w-14 h-14 bg-blue-100 rounded-full flex items-center justify-center text-blue-600 shrink-0">
                        <svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"></path></svg>
                    </div>
                    <div>
                        <p class="text-xs font-semibold text-slate-500 uppercase tracking-wider mb-1">Total Usuarios</p>
                        <h2 class="text-3xl font-black text-slate-900">${totalUsuarios}</h2>
                    </div>
                </div>

                <div class="bg-white rounded-2xl p-6 shadow-xl shadow-slate-200/50 border border-slate-100 flex items-center gap-4">
                    <div class="w-14 h-14 bg-emerald-100 rounded-full flex items-center justify-center text-emerald-600 shrink-0">
                        <svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path></svg>
                    </div>
                    <div>
                        <p class="text-xs font-semibold text-slate-500 uppercase tracking-wider mb-1">Total Agentes</p>
                        <h2 class="text-3xl font-black text-slate-900">${totalAgentes}</h2>
                    </div>
                </div>

                <div class="bg-white rounded-2xl p-6 shadow-xl shadow-slate-200/50 border border-slate-100 flex items-center gap-4">
                    <div class="w-14 h-14 bg-indigo-100 rounded-full flex items-center justify-center text-indigo-600 shrink-0">
                        <svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>
                    </div>
                    <div>
                        <p class="text-xs font-semibold text-slate-500 uppercase tracking-wider mb-1">Propiedades</p>
                        <h2 class="text-3xl font-black text-slate-900">${totalPropiedades}</h2>
                    </div>
                </div>

                <div class="bg-white rounded-2xl p-6 shadow-xl shadow-slate-200/50 border border-slate-100 flex items-center gap-4">
                    <div class="w-14 h-14 bg-green-100 rounded-full flex items-center justify-center text-green-600 shrink-0">
                        <svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                    </div>
                    <div>
                        <p class="text-xs font-semibold text-slate-500 uppercase tracking-wider mb-1">Activas</p>
                        <h2 class="text-3xl font-black text-green-600">${propActivas}</h2>
                    </div>
                </div>

                <div class="bg-white rounded-2xl p-6 shadow-xl shadow-slate-200/50 border border-slate-100 flex items-center gap-4">
                    <div class="w-14 h-14 bg-yellow-100 rounded-full flex items-center justify-center text-yellow-600 shrink-0">
                        <svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 9v6m4-6v6m7-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                    </div>
                    <div>
                        <p class="text-xs font-semibold text-slate-500 uppercase tracking-wider mb-1">Pausadas</p>
                        <h2 class="text-3xl font-black text-yellow-600">${propPausadas}</h2>
                    </div>
                </div>

                <div class="bg-white rounded-2xl p-6 shadow-xl shadow-slate-200/50 border border-slate-100 flex items-center gap-4">
                    <div class="w-14 h-14 bg-amber-100 rounded-full flex items-center justify-center text-amber-600 shrink-0">
                        <svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z"></path></svg>
                    </div>
                    <div>
                        <p class="text-xs font-semibold text-slate-500 uppercase tracking-wider mb-1">Vendidas</p>
                        <h2 class="text-3xl font-black text-amber-600">${propVendidas}</h2>
                    </div>
                </div>

            </div>

            <!-- Main Grid: Tables and Sidebar widgets -->
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">

                <!-- Left Column: Tables (span 2) -->
                <div class="lg:col-span-2 space-y-8">
                    
                    <!-- Últimos Usuarios -->
                    <div class="bg-white rounded-2xl shadow-xl shadow-slate-200/50 border border-slate-100 overflow-hidden">
                        <div class="px-6 py-4 border-b border-slate-100 flex justify-between items-center">
                            <h3 class="font-bold text-slate-900">Últimos Usuarios Registrados</h3>
                            <a href="${pageContext.request.contextPath}/admin?accion=usuarios" class="text-xs font-bold text-blue-600 hover:underline">Ver todos →</a>
                        </div>
                        <div class="overflow-x-auto">
                            <table class="w-full text-left text-sm text-slate-600">
                                <thead class="bg-slate-50 text-xs text-slate-500 uppercase tracking-wider">
                                    <tr>
                                        <th class="px-6 py-3">Usuario</th>
                                        <th class="px-6 py-3">Correo</th>
                                        <th class="px-6 py-3">Rol</th>
                                        <th class="px-6 py-3">Fecha Reg.</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-slate-100">
                                    <c:forEach var="u" items="${ultimosUsuarios}" begin="0" end="4">
                                        <tr class="hover:bg-slate-50">
                                            <td class="px-6 py-3 font-bold text-slate-900">${u.nombres} ${u.apellidos}</td>
                                            <td class="px-6 py-3">${u.correo}</td>
                                            <td class="px-6 py-3">
                                                <span class="px-2 py-0.5 bg-slate-100 rounded text-xs font-bold">${u.rolNombre}</span>
                                            </td>
                                            <td class="px-6 py-3 text-xs text-slate-500 whitespace-nowrap">${u.fechaRegistro}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Últimas Propiedades -->
                    <div class="bg-white rounded-2xl shadow-xl shadow-slate-200/50 border border-slate-100 overflow-hidden">
                        <div class="px-6 py-4 border-b border-slate-100 flex justify-between items-center">
                            <h3 class="font-bold text-slate-900">Últimas Propiedades Publicadas</h3>
                            <a href="${pageContext.request.contextPath}/admin?accion=propiedades" class="text-xs font-bold text-blue-600 hover:underline">Ver todas →</a>
                        </div>
                        <div class="overflow-x-auto">
                            <table class="w-full text-left text-sm text-slate-600">
                                <thead class="bg-slate-50 text-xs text-slate-500 uppercase tracking-wider">
                                    <tr>
                                        <th class="px-6 py-3">Título</th>
                                        <th class="px-6 py-3">Precio</th>
                                        <th class="px-6 py-3">Estado</th>
                                        <th class="px-6 py-3">Fecha Pub.</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-slate-100">
                                    <c:forEach var="p" items="${ultimasPropiedades}">
                                        <tr class="hover:bg-slate-50">
                                            <td class="px-6 py-3 font-bold text-slate-900 truncate max-w-[200px]">${p.titulo}</td>
                                            <td class="px-6 py-3 font-bold">US$ ${p.precioUsd}</td>
                                            <td class="px-6 py-3">
                                                <span class="px-2 py-0.5 rounded text-xs font-bold ${p.estado == 'ACTIVO' ? 'bg-green-100 text-green-700' : 'bg-orange-100 text-orange-700'}">${p.estado}</span>
                                            </td>
                                            <td class="px-6 py-3 text-xs text-slate-500 whitespace-nowrap">${p.fechaPublicacion}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                </div>

                <!-- Right Column: Sidebar (span 1) -->
                <div class="space-y-8">
                    
                    <!-- Acciones Rápidas -->
                    <div class="bg-white rounded-2xl p-6 shadow-xl shadow-slate-200/50 border border-slate-100">
                        <h3 class="font-bold text-slate-900 mb-4 flex items-center gap-2">
                            <svg class="w-5 h-5 text-indigo-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path></svg>
                            Acciones Rápidas
                        </h3>
                        <div class="grid grid-cols-2 gap-4">
                            <a href="${pageContext.request.contextPath}/admin?accion=usuarios" class="flex flex-col items-center justify-center p-4 bg-slate-50 hover:bg-slate-100 rounded-xl transition duration-200 group text-center border border-slate-100">
                                <div class="w-10 h-10 bg-blue-100 group-hover:bg-blue-200 rounded-lg flex items-center justify-center text-blue-600 mb-2 transition duration-200">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"></path></svg>
                                </div>
                                <span class="text-xs font-bold text-slate-700">Usuarios</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/admin?accion=propiedades" class="flex flex-col items-center justify-center p-4 bg-slate-50 hover:bg-slate-100 rounded-xl transition duration-200 group text-center border border-slate-100">
                                <div class="w-10 h-10 bg-emerald-100 group-hover:bg-emerald-200 rounded-lg flex items-center justify-center text-emerald-600 mb-2 transition duration-200">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>
                                </div>
                                <span class="text-xs font-bold text-slate-700">Propiedades</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/admin?accion=ubicaciones" class="flex flex-col items-center justify-center p-4 bg-slate-50 hover:bg-slate-100 rounded-xl transition duration-200 group text-center border border-slate-100">
                                <div class="w-10 h-10 bg-amber-100 group-hover:bg-amber-200 rounded-lg flex items-center justify-center text-amber-600 mb-2 transition duration-200">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                                </div>
                                <span class="text-xs font-bold text-slate-700">Ubicaciones</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/admin?accion=auditoria" class="flex flex-col items-center justify-center p-4 bg-slate-50 hover:bg-slate-100 rounded-xl transition duration-200 group text-center border border-slate-100">
                                <div class="w-10 h-10 bg-purple-100 group-hover:bg-purple-200 rounded-lg flex items-center justify-center text-purple-600 mb-2 transition duration-200">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path></svg>
                                </div>
                                <span class="text-xs font-bold text-slate-700">Auditoría</span>
                            </a>
                        </div>
                    </div>

                    <!-- Donut Chart -->
                    <div class="bg-white rounded-2xl p-6 shadow-xl shadow-slate-200/50 border border-slate-100">
                        <h3 class="font-bold text-slate-900 mb-4 flex items-center gap-2">
                            <svg class="w-5 h-5 text-indigo-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 3.055A9.003 9.003 0 1020.945 13H11V3.055z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20.488 9H15V3.512A9.025 9.025 0 0120.488 9z"></path></svg>
                            Estados de Inmuebles
                        </h3>
                        <div class="relative flex items-center justify-center h-56">
                            <canvas id="propiedadesChart"></canvas>
                        </div>
                        <div class="mt-4 grid grid-cols-2 gap-2 text-xs font-semibold text-slate-600">
                            <div class="flex items-center gap-1.5"><span class="w-3 h-3 bg-emerald-500 rounded-full inline-block"></span>Activas: ${propActivas}</div>
                            <div class="flex items-center gap-1.5"><span class="w-3 h-3 bg-amber-500 rounded-full inline-block"></span>Vendidas: ${propVendidas}</div>
                            <div class="flex items-center gap-1.5"><span class="w-3 h-3 bg-yellow-500 rounded-full inline-block"></span>Pausadas: ${propPausadas}</div>
                            <div class="flex items-center gap-1.5"><span class="w-3 h-3 bg-blue-500 rounded-full inline-block"></span>Borradores: ${propBorradores}</div>
                        </div>
                    </div>

                </div>

            </div>

        </div>
    </main>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const ctx = document.getElementById('propiedadesChart').getContext('2d');
            new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: ['Activas', 'Vendidas', 'Pausadas', 'Borradores'],
                    datasets: [{
                        data: [${propActivas}, ${propVendidas}, ${propPausadas}, ${propBorradores}],
                        backgroundColor: [
                            '#10B981', // green-500
                            '#F59E0B', // amber-500
                            '#EAB308', // yellow-500
                            '#3B82F6'  // blue-500
                        ],
                        borderWidth: 2,
                        borderColor: '#ffffff'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        }
                    },
                    cutout: '70%'
                }
            });
        });
    </script>
    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
</body>
</html>
