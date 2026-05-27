<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png">
    <title>Inmobix - Comparar Propiedades</title>
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
        
</head>
<body class="bg-brandBg text-brandText min-h-screen font-sans">
        <c:set var="activePage" value="comparador" scope="request" />
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <main class="pt-24 pb-16 px-4">
        <div class="max-w-7xl mx-auto">
            <!-- Breadcrumbs -->
            <nav class="text-sm text-slate-500 mb-6">
                <a href="${pageContext.request.contextPath}/index.jsp" class="hover:text-blue-600">Inicio</a> &gt;
                <a href="${pageContext.request.contextPath}/propiedades" class="hover:text-blue-600">Búsqueda</a> &gt;
                <span class="text-slate-900 font-bold">Comparar Propiedades</span>
            </nav>

            <h1 class="text-3xl font-extrabold text-slate-900 mb-8">Comparador de Propiedades</h1>

            <c:if test="${empty propiedadesComparar}">
                <div class="bg-amber-50 border-l-4 border-amber-400 p-6 rounded-r-xl">
                    <p class="font-bold text-amber-800">No hay propiedades para comparar.</p>
                    <a href="${pageContext.request.contextPath}/propiedades" class="text-blue-600 font-bold mt-2 inline-block">Ir al catálogo →</a>
                </div>
            </c:if>

            <c:if test="${not empty propiedadesComparar}">
            <div class="overflow-x-auto">
                <table class="w-full bg-white rounded-2xl shadow-xl border border-slate-100 text-sm">
                    <thead>
                        <tr class="border-b border-slate-200">
                            <th class="px-6 py-4 text-left text-slate-500 font-bold w-44">Atributo</th>
                            <c:forEach var="p" items="${propiedadesComparar}">
                                <th class="px-6 py-4 text-center min-w-[220px]">
                                    <c:choose>
                                        <c:when test="${not empty p.fotoPrincipal}">
                                            <img src="${p.getFotoPrincipalUrl(pageContext.request.contextPath)}" class="w-full h-32 object-cover rounded-xl mb-3">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="w-full h-32 bg-slate-100 rounded-xl flex items-center justify-center text-slate-300 mb-3">
                                                <svg class="w-12 h-12" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <a href="${pageContext.request.contextPath}/propiedades?accion=ver&id=${p.id}" class="font-bold text-slate-900 hover:text-blue-600 line-clamp-2">${p.titulo}</a>
                                </th>
                            </c:forEach>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-100">
                        <tr class="hover:bg-slate-50">
                            <td class="px-6 py-3 font-bold text-slate-600">Precio USD</td>
                            <c:forEach var="p" items="${propiedadesComparar}">
                                <td class="px-6 py-3 text-center font-black text-lg text-blue-600">US$ <fmt:formatNumber value="${p.precioUsd}" type="number" maxFractionDigits="0"/></td>
                            </c:forEach>
                        </tr>
                        <tr class="hover:bg-slate-50">
                            <td class="px-6 py-3 font-bold text-slate-600">Precio PEN</td>
                            <c:forEach var="p" items="${propiedadesComparar}">
                                <td class="px-6 py-3 text-center font-bold text-slate-700">S/. <fmt:formatNumber value="${p.precioPen}" type="number" maxFractionDigits="0"/></td>
                            </c:forEach>
                        </tr>
                        <tr class="hover:bg-slate-50">
                            <td class="px-6 py-3 font-bold text-slate-600">Operación</td>
                            <c:forEach var="p" items="${propiedadesComparar}">
                                <td class="px-6 py-3 text-center"><span class="px-3 py-1 rounded-full text-xs font-bold ${p.operacion == 'VENTA' ? 'bg-indigo-100 text-indigo-700' : 'bg-emerald-100 text-emerald-700'}">${p.operacion}</span></td>
                            </c:forEach>
                        </tr>
                        <tr class="hover:bg-slate-50">
                            <td class="px-6 py-3 font-bold text-slate-600">Tipo</td>
                            <c:forEach var="p" items="${propiedadesComparar}">
                                <td class="px-6 py-3 text-center">${p.tipoInmueble}</td>
                            </c:forEach>
                        </tr>
                        <tr class="hover:bg-slate-50">
                            <td class="px-6 py-3 font-bold text-slate-600">Ubicación</td>
                            <c:forEach var="p" items="${propiedadesComparar}">
                                <td class="px-6 py-3 text-center text-sm">${p.distrito}, ${p.provincia}</td>
                            </c:forEach>
                        </tr>
                        <tr class="hover:bg-slate-50">
                            <td class="px-6 py-3 font-bold text-slate-600">Área Total</td>
                            <c:forEach var="p" items="${propiedadesComparar}">
                                <td class="px-6 py-3 text-center font-bold">${p.areaTotalM2} m²</td>
                            </c:forEach>
                        </tr>
                        <tr class="hover:bg-slate-50">
                            <td class="px-6 py-3 font-bold text-slate-600">Área Techada</td>
                            <c:forEach var="p" items="${propiedadesComparar}">
                                <td class="px-6 py-3 text-center">${p.areaTechadaM2} m²</td>
                            </c:forEach>
                        </tr>
                        <tr class="hover:bg-slate-50">
                            <td class="px-6 py-3 font-bold text-slate-600">Dormitorios</td>
                            <c:forEach var="p" items="${propiedadesComparar}">
                                <td class="px-6 py-3 text-center text-lg font-bold">${p.numDormitorios}</td>
                            </c:forEach>
                        </tr>
                        <tr class="hover:bg-slate-50">
                            <td class="px-6 py-3 font-bold text-slate-600">Baños</td>
                            <c:forEach var="p" items="${propiedadesComparar}">
                                <td class="px-6 py-3 text-center text-lg font-bold">${p.numBanos}</td>
                            </c:forEach>
                        </tr>
                        <tr class="hover:bg-slate-50">
                            <td class="px-6 py-3 font-bold text-slate-600">Precio / m²</td>
                            <c:forEach var="p" items="${propiedadesComparar}">
                                <td class="px-6 py-3 text-center font-bold text-emerald-600">
                                    <c:if test="${p.areaTechadaM2 != null && p.areaTechadaM2 > 0 && p.precioUsd != null}">
                                        US$ <fmt:formatNumber value="${p.precioUsd / p.areaTechadaM2}" type="number" maxFractionDigits="0"/> /m²
                                    </c:if>
                                </td>
                            </c:forEach>
                        </tr>
                        <tr class="hover:bg-slate-50">
                            <td class="px-6 py-3 font-bold text-slate-600">Bono MiVivienda</td>
                            <c:forEach var="p" items="${propiedadesComparar}">
                                <td class="px-6 py-3 text-center">
                                    <c:choose>
                                        <c:when test="${p.bonoMiVivienda == 1}">
                                            <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold bg-indigo-100 text-indigo-700">Aplica</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold bg-slate-100 text-slate-400">No aplica</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </c:forEach>
                        </tr>
                        <tr class="hover:bg-slate-50">
                            <td class="px-6 py-3 font-bold text-slate-600">Bono Verde</td>
                            <c:forEach var="p" items="${propiedadesComparar}">
                                <td class="px-6 py-3 text-center">
                                    <c:choose>
                                        <c:when test="${p.bonoVerde == 1}">
                                            <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold bg-emerald-100 text-emerald-700">Aplica</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold bg-slate-100 text-slate-400">No aplica</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </c:forEach>
                        </tr>
                        <tr class="hover:bg-slate-50">
                            <td class="px-6 py-3 font-bold text-slate-600">Agente Inmobiliario</td>
                            <c:forEach var="p" items="${propiedadesComparar}">
                                <td class="px-6 py-3 text-center">
                                    <c:choose>
                                        <c:when test="${not empty p.agenteNombre}">
                                            <div class="font-bold text-slate-900">${p.agenteNombre}</div>
                                             <c:if test="${not empty p.agenteTelefono}">
                                                 <div class="text-xs text-slate-500 mt-0.5 inline-flex items-center gap-1">
                                                     <svg class="w-3.5 h-3.5 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.94.725l.548 2.2a1 1 0 01-.321.988l-1.305.98a10.582 10.582 0 004.872 4.872l.98-1.305a1 1 0 01.988-.321l2.2.548a1 1 0 01.725.94V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"></path></svg>
                                                     ${p.agenteTelefono}
                                                 </div>
                                             </c:if>
                                             <c:if test="${not empty p.agenteCorreo}">
                                                 <div class="text-[11px] text-slate-400 mt-0.5 inline-flex items-center gap-1">
                                                     <svg class="w-3.5 h-3.5 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path></svg>
                                                     ${p.agenteCorreo}
                                                 </div>
                                             </c:if>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-slate-400 italic">No asignado</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </c:forEach>
                        </tr>
                        <tr class="hover:bg-slate-50">
                            <td class="px-6 py-3 font-bold text-slate-600">Acción</td>
                            <c:forEach var="p" items="${propiedadesComparar}">
                                <td class="px-6 py-3 text-center">
                                    <a href="${pageContext.request.contextPath}/propiedades?accion=ver&id=${p.id}" class="bg-brandBtn hover:bg-brandHover text-white px-4 py-2 rounded-lg text-xs font-bold">Ver Detalle</a>
                                </td>
                            </c:forEach>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="mt-6 text-center">
                <button onclick="localStorage.removeItem('comparar_ids'); window.location.href='${pageContext.request.contextPath}/propiedades';" class="border border-slate-300 hover:border-black text-slate-700 hover:text-black bg-transparent hover:bg-black/5 px-6 py-3 rounded-xl font-bold transition-all duration-300">Limpiar Comparación</button>
            </div>
            </c:if>
        </div>
    </main>
</body>
</html>
