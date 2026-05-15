<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png">
    <title>Inmobix - Dashboard Administrador</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <script src="https://cdn.tailwindcss.com"></script>
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
                    <a href="${pageContext.request.contextPath}/admin?accion=dashboard" class="text-sm font-bold text-blue-400 border-b-2 border-blue-400 py-1 transition-colors">Dashboard</a>
                    <a href="${pageContext.request.contextPath}/admin?accion=usuarios" class="text-sm font-semibold text-slate-300 hover:text-white transition-colors">Usuarios</a>
                    <a href="${pageContext.request.contextPath}/admin?accion=propiedades" class="text-sm font-semibold text-slate-300 hover:text-white transition-colors">Propiedades</a>
                    <a href="${pageContext.request.contextPath}/admin?accion=ubicaciones" class="text-sm font-semibold text-slate-300 hover:text-white transition-colors">Ubicaciones</a>
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
            
            <div class="mb-8">
                <h1 class="text-3xl font-bold text-slate-900 tracking-tight">Panel de Control</h1>
                <p class="text-slate-500 mt-2">Visión global del portal inmobiliario.</p>
            </div>

            <!-- Dashboard Stats -->
            <div class="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-5 gap-6 mb-10">
                
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
                    <div class="w-14 h-14 bg-amber-100 rounded-full flex items-center justify-center text-amber-600 shrink-0">
                        <svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z"></path></svg>
                    </div>
                    <div>
                        <p class="text-xs font-semibold text-slate-500 uppercase tracking-wider mb-1">Vendidas</p>
                        <h2 class="text-3xl font-black text-amber-600">${propVendidas}</h2>
                    </div>
                </div>

            </div>

            <!-- Últimos Registros -->
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">

                <!-- Últimos Usuarios -->
                <div class="bg-white rounded-2xl shadow-xl shadow-slate-200/50 border border-slate-100 overflow-hidden">
                    <div class="px-6 py-4 border-b border-slate-100 flex justify-between items-center">
                        <h3 class="font-bold text-slate-900">Últimos Usuarios Registrados</h3>
                        <a href="${pageContext.request.contextPath}/admin?accion=usuarios" class="text-xs font-bold text-blue-600 hover:underline">Ver todos →</a>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="w-full text-left text-sm text-slate-600">
                            <thead class="bg-slate-50 text-xs text-slate-500 uppercase tracking-wider">
                                <tr><th class="px-6 py-3">Usuario</th><th class="px-6 py-3">Correo</th><th class="px-6 py-3">Rol</th></tr>
                            </thead>
                            <tbody class="divide-y divide-slate-100">
                                <c:forEach var="u" items="${ultimosUsuarios}" begin="0" end="4">
                                    <tr class="hover:bg-slate-50">
                                        <td class="px-6 py-3 font-bold text-slate-900">${u.nombres} ${u.apellidos}</td>
                                        <td class="px-6 py-3">${u.correo}</td>
                                        <td class="px-6 py-3"><span class="px-2 py-0.5 bg-slate-100 rounded text-xs font-bold">${u.rolNombre}</span></td>
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
                                <tr><th class="px-6 py-3">Título</th><th class="px-6 py-3">Precio</th><th class="px-6 py-3">Estado</th></tr>
                            </thead>
                            <tbody class="divide-y divide-slate-100">
                                <c:forEach var="p" items="${ultimasPropiedades}">
                                    <tr class="hover:bg-slate-50">
                                        <td class="px-6 py-3 font-bold text-slate-900 truncate max-w-[200px]">${p.titulo}</td>
                                        <td class="px-6 py-3 font-bold">US$ ${p.precioUsd}</td>
                                        <td class="px-6 py-3">
                                            <span class="px-2 py-0.5 rounded text-xs font-bold ${p.estado == 'ACTIVO' ? 'bg-green-100 text-green-700' : 'bg-orange-100 text-orange-700'}">${p.estado}</span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div>

            <div class="bg-blue-50 border border-blue-200 text-blue-800 rounded-xl p-6 mt-8 shadow-sm">
                <h3 class="font-bold text-lg mb-2">Bienvenido al Panel Administrativo</h3>
                <p>Desde aquí podrás gestionar todos los accesos a la plataforma. En la pestaña de <strong>Usuarios</strong> puedes registrar, bloquear, eliminar o cambiar roles. En <strong>Propiedades</strong> puedes moderar contenido. En <strong>Ubicaciones</strong> puedes gestionar la geografía del sistema.</p>
            </div>

        </div>
    </main>
</body>
</html>
