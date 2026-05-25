<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png">
    <title>Inmobix - Procesar Pago</title>
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
<header class="text-white fixed w-full top-0 z-50 bg-black/90 backdrop-blur-md backdrop-blur-xl border-b shadow-lg">
    <div class="max-w-7xl mx-auto px-4 flex justify-between items-center h-16">
        <a href="${pageContext.request.contextPath}/index.jsp" class="flex items-center gap-2"><img src="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png" class="h-8"><span class="text-xl font-bold">Inmobix</span></a>
        <a href="${pageContext.request.contextPath}/pagos?accion=planes" class="text-sm font-bold text-brandHover">← Planes</a>
    </div>
</header>
<main class="pt-24 pb-16 px-4"><div class="max-w-lg mx-auto bg-white rounded-2xl shadow-xl border p-8">
    <h2 class="text-2xl font-bold mb-2">Procesar Pago</h2>
    <p class="text-slate-500 mb-6">Plan: <strong>${planSeleccionado.nombre}</strong></p>
    <div class="bg-blue-50 rounded-xl p-4 mb-6">
        <div class="text-3xl font-black text-blue-600">S/. <fmt:formatNumber value="${planSeleccionado.precioPen}" maxFractionDigits="2"/></div>
        <div class="text-xs text-blue-500 font-semibold">${planSeleccionado.duracionDias} días · ${planSeleccionado.maxPropiedades} propiedades</div>
    </div>
    <c:if test="${param.error == 'true'}"><div class="mb-4 bg-red-50 border-l-4 border-red-500 p-3 rounded-r-lg text-sm text-red-700">Error al procesar el pago.</div></c:if>
    <form action="${pageContext.request.contextPath}/pagos" method="post" class="space-y-5" id="pagoForm">
        <input type="hidden" name="accion" value="procesar"><input type="hidden" name="idPlan" value="${planSeleccionado.id}">
        <div><label class="block text-sm font-bold text-slate-700 mb-2">Método de Pago *</label>
            <select name="metodoPago" required class="w-full px-4 py-3 rounded-lg border focus:ring-2 focus:ring-blue-500 outline-none bg-white">
                <option value="TARJETA">Tarjeta</option><option value="TRANSFERENCIA">Transferencia</option><option value="YAPE">Yape</option><option value="EFECTIVO">Efectivo</option>
            </select></div>
        <div><label class="block text-sm font-bold text-slate-700 mb-2">Nombre Titular *</label><input type="text" required class="w-full px-4 py-3 rounded-lg border focus:ring-2 focus:ring-blue-500 outline-none"></div>
        <div><label class="block text-sm font-bold text-slate-700 mb-2">RUC/DNI *</label><input type="text" required class="w-full px-4 py-3 rounded-lg border focus:ring-2 focus:ring-blue-500 outline-none"></div>
        <button type="submit" class="w-full bg-brandBtn hover:bg-brandHover text-white font-bold py-4 rounded-xl shadow-lg">Confirmar Pago</button>
    </form>
</div></main>
</body></html>
