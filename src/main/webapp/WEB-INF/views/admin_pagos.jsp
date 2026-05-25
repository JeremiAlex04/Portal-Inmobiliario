<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png">
<title>Inmobix Admin - Pagos</title><script src="https://cdn.tailwindcss.com"></script></head>
<body class="bg-slate-50 min-h-screen font-sans">
<header class="fixed w-full top-0 z-50 bg-white/80 backdrop-blur-xl border-b shadow-sm"><div class="max-w-7xl mx-auto px-4 flex justify-between items-center h-16">
<a href="${pageContext.request.contextPath}/admin" class="flex items-center gap-2"><img src="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png" class="h-8"><span class="text-xl font-bold">Inmobix Admin</span></a>
<a href="${pageContext.request.contextPath}/admin" class="text-sm font-bold text-blue-600">← Dashboard</a>
</div></header>
<main class="pt-24 pb-16 px-4"><div class="max-w-6xl mx-auto">
<h1 class="text-3xl font-bold mb-6">Gestión de Pagos</h1>
<form action="${pageContext.request.contextPath}/pagos" method="get" class="bg-white rounded-xl shadow border p-4 mb-6 flex gap-3 items-end">
<input type="hidden" name="accion" value="admin">
<div class="flex-1"><label class="block text-xs font-bold text-slate-500 mb-1">Estado</label>
<select name="estado" class="w-full border rounded-lg px-3 py-2.5 text-sm bg-white"><option value="">Todos</option>
<option value="PENDIENTE" ${filtroEstado=='PENDIENTE'?'selected':''}>Pendiente</option>
<option value="APROBADO" ${filtroEstado=='APROBADO'?'selected':''}>Aprobado</option>
<option value="RECHAZADO" ${filtroEstado=='RECHAZADO'?'selected':''}>Rechazado</option></select></div>
<button class="bg-slate-900 text-white px-6 py-2.5 rounded-lg text-sm font-bold">Filtrar</button></form>
<div class="bg-white rounded-2xl shadow-xl border overflow-hidden"><table class="w-full text-sm">
<thead class="bg-slate-50 border-b text-xs uppercase tracking-wider"><tr><th class="px-4 py-3">ID</th><th class="px-4 py-3 text-left">Usuario</th><th class="px-4 py-3">Plan</th><th class="px-4 py-3">Monto</th><th class="px-4 py-3">Método</th><th class="px-4 py-3">Código</th><th class="px-4 py-3">Fecha</th><th class="px-4 py-3">Estado</th><th class="px-4 py-3">Acciones</th></tr></thead>
<tbody class="divide-y"><c:forEach var="p" items="${listaPagos}"><tr class="hover:bg-slate-50">
<td class="px-4 py-3 text-center font-mono">#${p.id}</td>
<td class="px-4 py-3 font-bold">${p.nombreUsuario}</td>
<td class="px-4 py-3 text-center">${p.nombrePlan}</td>
<td class="px-4 py-3 text-center font-bold">S/. <fmt:formatNumber value="${p.monto}" maxFractionDigits="2"/></td>
<td class="px-4 py-3 text-center">${p.metodoPago}</td>
<td class="px-4 py-3 text-center font-mono text-xs">${p.codigoOperacion}</td>
<td class="px-4 py-3 text-center text-xs">${p.fecha}</td>
<td class="px-4 py-3 text-center"><span class="px-2 py-1 rounded text-xs font-bold ${p.estado=='APROBADO'?'bg-emerald-100 text-emerald-700':p.estado=='RECHAZADO'?'bg-red-100 text-red-700':'bg-amber-100 text-amber-700'}">${p.estado}</span></td>
<td class="px-4 py-3 text-center">
<c:if test="${p.estado == 'PENDIENTE'}">
<form action="${pageContext.request.contextPath}/pagos" method="post" class="inline-flex gap-1">
<input type="hidden" name="accion" value="cambiarEstado"><input type="hidden" name="idPago" value="${p.id}">
<button name="nuevoEstado" value="APROBADO" class="bg-emerald-600 text-white px-3 py-1 rounded text-xs font-bold hover:bg-emerald-700">Aprobar</button>
<button name="nuevoEstado" value="RECHAZADO" class="bg-red-600 text-white px-3 py-1 rounded text-xs font-bold hover:bg-red-700">Rechazar</button>
</form></c:if></td>
</tr></c:forEach></tbody></table></div></div></main></body></html>
