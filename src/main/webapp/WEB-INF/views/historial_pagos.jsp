<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png">
<title>Inmobix - Historial de Pagos</title><script src="https://cdn.tailwindcss.com"></script>
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
        </script></head>
<body class="bg-brandBg text-brandText min-h-screen font-sans">
<header class="text-white fixed w-full top-0 z-50 bg-black/90 backdrop-blur-md backdrop-blur-xl border-b shadow-lg"><div class="max-w-7xl mx-auto px-4 flex justify-between items-center h-16">
<a href="${pageContext.request.contextPath}/index.jsp" class="flex items-center gap-2"><img src="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png" class="h-8"><span class="text-xl font-bold">Inmobix</span></a>
<div class="flex gap-4 items-center"><a href="${pageContext.request.contextPath}/panel" class="text-sm font-bold text-brandHover">Mi Panel</a><a href="${pageContext.request.contextPath}/pagos?accion=planes" class="text-sm font-semibold text-white/80">Ver Planes</a></div>
</div></header>
<main class="pt-24 pb-16 px-4"><div class="max-w-4xl mx-auto">
<c:if test="${param.pagoExitoso == 'true'}"><div class="mb-6 bg-emerald-50 border-l-4 border-emerald-500 p-4 rounded-r-lg flex items-center gap-2"><svg class="w-5 h-5 text-emerald-600 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M5 13l4 4L19 7"></path></svg><p class="text-emerald-800 font-bold">Pago registrado exitosamente. Código de operación generado. Pendiente de aprobación.</p></div></c:if>
<h1 class="text-3xl font-bold mb-8">Historial de Pagos</h1>
<div class="bg-white rounded-2xl shadow-xl border overflow-hidden"><table class="w-full text-sm">
<thead class="bg-slate-50 border-b"><tr><th class="px-6 py-4 text-left">Fecha</th><th class="px-6 py-4 text-left">Plan</th><th class="px-6 py-4">Monto</th><th class="px-6 py-4">Método</th><th class="px-6 py-4">Código Op.</th><th class="px-6 py-4">Estado</th></tr></thead>
<tbody class="divide-y">
<c:choose><c:when test="${empty listaPagos}"><tr><td colspan="6" class="px-6 py-8 text-center text-slate-500">No tienes pagos registrados.</td></tr></c:when>
<c:otherwise><c:forEach var="p" items="${listaPagos}"><tr class="hover:bg-slate-50">
<td class="px-6 py-4 text-slate-500">${p.fecha}</td>
<td class="px-6 py-4 font-bold">${p.nombrePlan}</td>
<td class="px-6 py-4 text-center font-bold">S/. <fmt:formatNumber value="${p.monto}" maxFractionDigits="2"/></td>
<td class="px-6 py-4 text-center">${p.metodoPago}</td>
<td class="px-6 py-4 text-center font-mono text-xs">${p.codigoOperacion}</td>
<td class="px-6 py-4 text-center"><span class="px-3 py-1 rounded-full text-xs font-bold ${p.estado == 'APROBADO' ? 'bg-emerald-100 text-emerald-700' : p.estado == 'RECHAZADO' ? 'bg-red-100 text-red-700' : 'bg-amber-100 text-amber-700'}">${p.estado}</span></td>
</tr></c:forEach></c:otherwise></c:choose>
</tbody></table></div></div></main></body></html>
