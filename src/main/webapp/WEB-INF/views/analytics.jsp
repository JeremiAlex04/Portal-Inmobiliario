<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="es">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <link rel="icon" type="image/png"
                href="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png">
            <title>Inmobix - Analytics</title>
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
        
            <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/analytics.js" defer></script>
</head>

        <body class="bg-brandBg text-brandText min-h-screen font-sans">
            <header class="text-white fixed w-full top-0 z-50 bg-black/90 backdrop-blur-md backdrop-blur-xl border-b shadow-lg">
                <div class="max-w-7xl mx-auto px-4 flex justify-between items-center h-16">
                    <a href="${pageContext.request.contextPath}/index.jsp" class="flex items-center gap-2"><img
                            src="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png" class="h-8"><span
                            class="text-xl font-bold">Inmobix</span></a>
                    <a href="${pageContext.request.contextPath}/panel" class="text-sm font-bold text-brandHover">← Mi
                        Panel</a>
                </div>
            </header>
            <main class="pt-24 pb-16 px-4">
                <div class="max-w-5xl mx-auto">
                    <nav class="text-sm text-slate-500 mb-6"><a href="${pageContext.request.contextPath}/panel"
                            class="hover:text-blue-600">Mi Panel</a> &gt; <span
                            class="text-slate-900 font-bold">Analytics</span></nav>
                    <h1 class="text-3xl font-bold mb-2 flex items-center gap-3">
                        <svg class="w-8 h-8 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v16m-6 0a2 2 0 002 2h2a2 2 0 002-2">
                            </path>
                        </svg>
                        Analytics: ${propiedad.titulo}
                    </h1>
                    <p class="text-slate-500 mb-8 flex items-center gap-1 text-sm">
                        <svg class="w-4 h-4 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z">
                            </path>
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path>
                        </svg>
                        ${propiedad.distrito}, ${propiedad.provincia}
                    </p>

                    <!-- Métricas -->
                    <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-8">
                        <div class="bg-white rounded-xl shadow border p-5 text-center">
                            <div class="text-3xl font-black text-blue-600">${totalVistas}</div>
                            <div class="text-xs text-slate-500 font-bold">Total Vistas</div>
                        </div>
                        <div class="bg-white rounded-xl shadow border p-5 text-center">
                            <div class="text-3xl font-black text-emerald-600">${promedioDiario}</div>
                            <div class="text-xs text-slate-500 font-bold">Promedio/día</div>
                        </div>
                        <div class="bg-white rounded-xl shadow border p-5 text-center">
                            <div class="text-3xl font-black text-purple-600">${maxVistas}</div>
                            <div class="text-xs text-slate-500 font-bold">Máximo en un día</div>
                        </div>
                        <div class="bg-white rounded-xl shadow border p-5 text-center">
                            <div class="text-3xl font-black text-amber-600">${promedioDistrito}</div>
                            <div class="text-xs text-slate-500 font-bold">Prom. Distrito</div>
                        </div>
                    </div>

                    <!-- Gráfico -->
                    <div class="bg-white rounded-2xl shadow-xl border p-6 mb-8">
                        <h2 class="text-xl font-bold mb-4">Vistas - Últimos 30 días</h2>
                        <canvas id="vistasChart" height="100" data-labels='${labelsJson}' data-views='${dataJson}'></canvas>
                    </div>

                    <c:if test="${not empty diaMax}">
                        <div class="bg-blue-50 border border-blue-200 rounded-xl p-4 text-sm text-blue-800 font-semibold flex items-center gap-3">
                            <svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"></path></svg>
                            <div>Tu día con más vistas fue <strong>${diaMax}</strong> con <strong>${maxVistas} visitas</strong>.</div>
                        </div>
                    </c:if>
                </div>
            </main>

            
        </body>

        </html>