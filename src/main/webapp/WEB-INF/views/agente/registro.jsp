<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es" class="scroll-smooth">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png"
        href="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png">
    <title>Inmobix - ${propiedad != null && propiedad.id > 0 ? 'Editar Inmueble' : 'Publicar Inmueble'}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <style>
        /* Card Selection styles directly in page to bypass any browser cache issues */
        .tipo-card, .operacion-card {
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1) !important;
        }
        .tipo-card.selected, .operacion-card.selected {
            border: 2.5px solid #000000 !important;
            background-color: #fafafa !important;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.15) !important;
            transform: scale(1.03) !important;
            position: relative;
        }
        .tipo-card.selected::after, .operacion-card.selected::after {
            content: '' !important;
            position: absolute !important;
            top: 8px !important;
            right: 8px !important;
            width: 22px !important;
            height: 22px !important;
            border-radius: 50% !important;
            background-color: #000000 !important;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='%23ffffff' stroke-width='3'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' d='M5 13l4 4L19 7'/%3E%3C/svg%3E") !important;
            background-size: 14px !important;
            background-position: center !important;
            background-repeat: no-repeat !important;
            animation: scaleIn 0.2s cubic-bezier(0.34, 1.56, 0.64, 1) !important;
            z-index: 20 !important;
        }
        @keyframes scaleIn {
            0% { transform: scale(0); opacity: 0; }
            100% { transform: scale(1); opacity: 1; }
        }
        .tipo-card.selected svg, .operacion-card.selected svg {
            color: #000000 !important;
            stroke: #000000 !important;
        }
        .tipo-card.selected span, .operacion-card.selected span {
            color: #000000 !important;
            font-weight: 700 !important;
        }
        
        /* Timeline indicators hover effects */
        .wizard-step-indicator {
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .wizard-step-indicator:hover {
            transform: translateY(-2px);
        }
        .wizard-step-indicator:active {
            transform: translateY(0);
        }
        .wizard-step-indicator .step-circle {
            transition: all 0.3s ease;
        }
        .wizard-step-indicator:hover .step-circle {
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }
    </style>
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
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
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400..900;1,400..900&family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <script src="${pageContext.request.contextPath}/assets/js/registro.js" defer></script>
</head>

<body class="bg-[#f8f8f6] text-brandText flex flex-col min-h-screen" style="font-family:'Inter',sans-serif;">

    <!-- Navbar Premium -->
        <c:set var="activePage" value="publicar" scope="request" />
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <main class="flex-grow pt-28 pb-16 px-4">
        <div class="w-full max-w-5xl mx-auto">

            <!-- Page Header -->
            <div class="text-center mb-10">
                <span class="inline-block px-4 py-1.5 rounded-full bg-black text-white text-[11px] font-bold uppercase tracking-widest mb-4">
                    ${propiedad != null && propiedad.id > 0 ? 'Edición de Inmueble' : 'Nueva Publicación'}
                </span>
                <h1 class="text-3xl md:text-4xl font-light tracking-tight text-slate-900" style="font-family:'Playfair Display',serif;">
                    ${propiedad != null && propiedad.id > 0 ? 'Editar tu Inmueble' : 'Publica tu Inmueble'}
                </h1>
                <p class="text-slate-500 mt-2 text-sm max-w-lg mx-auto">
                    ${propiedad != null && propiedad.id > 0 ? 'Actualiza los datos de tu propiedad paso a paso.' : 'Completa los siguientes pasos para publicar tu propiedad en Inmobix.'}
                </p>
            </div>

            <!-- Error Message -->
            <c:if test="${not empty error}">
                <div id="wizard-error" class="mb-6 bg-red-50 border-l-4 border-red-500 p-4 rounded-r-xl shadow-sm">
                    <div class="flex items-center gap-3">
                        <svg class="w-5 h-5 text-red-500 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                        <p class="text-sm text-red-700 font-medium">${error}</p>
                    </div>
                </div>
            </c:if>

            <!-- ============================================ -->
            <!--          WIZARD PROGRESS BAR                 -->
            <!-- ============================================ -->
            <div class="wizard-progress mb-10">
                <div class="flex items-center justify-between relative">
                    <!-- Progress line background -->
                    <div class="absolute top-5 left-0 right-0 h-[2px] bg-slate-200 z-0 mx-10"></div>
                    <!-- Progress line active -->
                    <div id="progress-line" class="absolute top-5 left-0 h-[2px] bg-black z-[1] mx-10 transition-all duration-500 ease-out" style="width: 0%;"></div>

                    <!-- Step 1 -->
                    <div class="wizard-step-indicator flex flex-col items-center relative z-10 cursor-pointer" data-step="1">
                        <div class="step-circle w-10 h-10 rounded-full bg-black text-white flex items-center justify-center text-sm font-bold shadow-md transition-all duration-300">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>
                        </div>
                        <span class="step-label text-[11px] font-bold mt-2 text-black uppercase tracking-wider">Tipo</span>
                    </div>
                    <!-- Step 2 -->
                    <div class="wizard-step-indicator flex flex-col items-center relative z-10 cursor-pointer" data-step="2">
                        <div class="step-circle w-10 h-10 rounded-full bg-slate-200 text-slate-400 flex items-center justify-center text-sm font-bold transition-all duration-300">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                        </div>
                        <span class="step-label text-[11px] font-semibold mt-2 text-slate-400 uppercase tracking-wider">Ubicación</span>
                    </div>
                    <!-- Step 3 -->
                    <div class="wizard-step-indicator flex flex-col items-center relative z-10 cursor-pointer" data-step="3">
                        <div class="step-circle w-10 h-10 rounded-full bg-slate-200 text-slate-400 flex items-center justify-center text-sm font-bold transition-all duration-300">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"></path></svg>
                        </div>
                        <span class="step-label text-[11px] font-semibold mt-2 text-slate-400 uppercase tracking-wider">Detalles</span>
                    </div>
                    <!-- Step 4 -->
                    <div class="wizard-step-indicator flex flex-col items-center relative z-10 cursor-pointer" data-step="4">
                        <div class="step-circle w-10 h-10 rounded-full bg-slate-200 text-slate-400 flex items-center justify-center text-sm font-bold transition-all duration-300">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                        </div>
                        <span class="step-label text-[11px] font-semibold mt-2 text-slate-400 uppercase tracking-wider">Precio</span>
                    </div>
                    <!-- Step 5 -->
                    <div class="wizard-step-indicator flex flex-col items-center relative z-10 cursor-pointer" data-step="5">
                        <div class="step-circle w-10 h-10 rounded-full bg-slate-200 text-slate-400 flex items-center justify-center text-sm font-bold transition-all duration-300">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                        </div>
                        <span class="step-label text-[11px] font-semibold mt-2 text-slate-400 uppercase tracking-wider">Fotos</span>
                    </div>
                </div>
            </div>

            <!-- ============================================ -->
            <!--             WIZARD FORM                      -->
            <!-- ============================================ -->
            <form id="wizard-form" action="${pageContext.request.contextPath}/propiedades" method="post">
                <input type="hidden" name="id" value="${propiedad != null ? propiedad.id : ''}">

                <!-- ============================== -->
                <!--  PASO 1: TIPO Y OPERACIÓN      -->
                <!-- ============================== -->
                <div class="wizard-panel active" data-panel="1" style="display: block;">
                    <div class="bg-white rounded-2xl shadow-sm border border-slate-100 p-8 md:p-10">

                        <div class="mb-8">
                            <h2 class="text-2xl font-light text-slate-900 mb-1" style="font-family:'Playfair Display',serif;">¿Qué tipo de inmueble deseas publicar?</h2>
                            <p class="text-slate-400 text-sm">Selecciona el tipo de propiedad que vas a publicar.</p>
                        </div>

                        <!-- Tipo de Inmueble Cards -->
                        <input type="hidden" name="idTipoInmueble" id="idTipoInmueble" value="${propiedad != null ? propiedad.idTipoInmueble : ''}" required>

                        <div class="grid grid-cols-2 sm:grid-cols-4 gap-4 mb-12">
                            <c:forEach var="t" items="${listaTipos}">
                                <div class="tipo-card group cursor-pointer rounded-2xl border-2 border-slate-200 bg-white hover:border-black hover:shadow-lg transition-all duration-300 p-5 flex flex-col items-center gap-3 text-center ${propiedad != null && propiedad.idTipoInmueble == t.id ? 'selected' : ''}"
                                     data-value="${t.id}">
                                    <div class="w-14 h-14 rounded-xl bg-slate-50 group-hover:bg-black/5 flex items-center justify-center transition-colors duration-300">
                                        <!-- Icons per type -->
                                        <c:choose>
                                            <c:when test="${t.nombre == 'Casa'}">
                                                <svg class="w-7 h-7 text-slate-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>
                                            </c:when>
                                            <c:when test="${t.nombre == 'Departamento'}">
                                                <svg class="w-7 h-7 text-slate-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"></path></svg>
                                            </c:when>
                                            <c:when test="${t.nombre == 'Terreno'}">
                                                <svg class="w-7 h-7 text-slate-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 20l-5.447-2.724A1 1 0 013 16.382V5.618a1 1 0 011.447-.894L9 7m0 13l6-3m-6 3V7m6 10l4.553 2.276A1 1 0 0021 18.382V7.618a1 1 0 00-.553-.894L15 4m0 13V4m0 0L9 7"></path></svg>
                                            </c:when>
                                            <c:when test="${t.nombre == 'Local Comercial'}">
                                                <svg class="w-7 h-7 text-slate-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"></path></svg>
                                            </c:when>
                                            <c:when test="${t.nombre == 'Oficina'}">
                                                <svg class="w-7 h-7 text-slate-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path></svg>
                                            </c:when>
                                            <c:when test="${t.nombre == 'Industrial'}">
                                                <svg class="w-7 h-7 text-slate-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z"></path></svg>
                                            </c:when>
                                            <c:when test="${t.nombre == 'Cochera'}">
                                                <svg class="w-7 h-7 text-slate-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M8 17h.01M16 17h.01M3 11l1.5-5.5A2 2 0 016.4 4h11.2a2 2 0 011.9 1.5L21 11M3 11h18M3 11v6a1 1 0 001 1h1a1 1 0 001-1v-1h12v1a1 1 0 001 1h1a1 1 0 001-1v-6"></path></svg>
                                            </c:when>
                                            <c:otherwise>
                                                <svg class="w-7 h-7 text-slate-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M8 14v3m4-3v3m4-3v3M3 21h18M3 10h18M3 7l9-4 9 4M4 10h16v11H4V10z"></path></svg>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <span class="text-sm font-semibold text-slate-700">${t.nombre}</span>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- Tipo de Operación -->
                        <div class="mb-2">
                            <h2 class="text-2xl font-light text-slate-900 mb-1" style="font-family:'Playfair Display',serif;">¿Qué operación deseas realizar?</h2>
                            <p class="text-slate-400 text-sm">Selecciona si deseas vender, alquilar o anticrésis.</p>
                        </div>

                        <input type="hidden" name="idOperacion" id="idOperacion" value="${propiedad != null ? propiedad.idOperacion : ''}" required>

                        <div class="grid grid-cols-1 sm:grid-cols-3 gap-4 mt-6">
                            <c:forEach var="op" items="${listaOperaciones}">
                                <div class="operacion-card group cursor-pointer rounded-2xl border-2 border-slate-200 bg-white hover:border-black hover:shadow-lg transition-all duration-300 p-6 flex items-center gap-4 ${propiedad != null && propiedad.idOperacion == op.id ? 'selected' : ''}"
                                     data-value="${op.id}">
                                    <div class="w-12 h-12 rounded-xl bg-slate-50 group-hover:bg-black/5 flex items-center justify-center transition-colors shrink-0">
                                        <c:choose>
                                            <c:when test="${op.nombre == 'VENTA'}">
                                                <svg class="w-6 h-6 text-slate-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z"></path></svg>
                                            </c:when>
                                            <c:when test="${op.nombre == 'ALQUILER'}">
                                                <svg class="w-6 h-6 text-slate-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11 17H9v2H7v2H4a1 1 0 01-1-1v-2.586a1 1 0 01.293-.707l5.964-5.964A6 6 0 1121 9z"></path></svg>
                                            </c:when>
                                            <c:otherwise>
                                                <svg class="w-6 h-6 text-slate-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path></svg>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div>
                                        <span class="text-base font-bold text-slate-800 block">${op.nombre}</span>
                                        <c:choose>
                                            <c:when test="${op.nombre == 'VENTA'}">
                                                <span class="text-xs text-slate-400">Vende tu propiedad al mejor precio</span>
                                            </c:when>
                                            <c:when test="${op.nombre == 'ALQUILER'}">
                                                <span class="text-xs text-slate-400">Ofrece tu propiedad en alquiler</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-xs text-slate-400">Ofrece tu propiedad en anticresis</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- Selection Info Banner -->
                        <div id="step1-selection-info" class="mt-6 p-4 bg-slate-50 border border-slate-200 rounded-xl hidden transition-all duration-300">
                            <div class="flex items-center gap-3">
                                <div class="w-8 h-8 rounded-full bg-black text-white flex items-center justify-center">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M5 13l4 4L19 7"></path></svg>
                                </div>
                                <div>
                                    <p class="text-sm font-bold text-slate-800">Elección Identificada:</p>
                                    <p class="text-xs text-slate-500">
                                        Has seleccionado <span id="selected-tipo-text" class="font-semibold text-black">—</span> para realizar la operación de <span id="selected-operacion-text" class="font-semibold text-black">—</span>.
                                    </p>
                                </div>
                            </div>
                        </div>

                        <!-- Validation message -->
                        <p id="step1-error" class="text-red-500 text-sm font-medium mt-4 hidden">
                            Selecciona un tipo de inmueble y una operación para continuar.
                        </p>
                    </div>
                </div>

                <!-- ============================== -->
                <!--  PASO 2: UBICACIÓN              -->
                <!-- ============================== -->
                <div class="wizard-panel" data-panel="2" style="display: none;">
                    <div class="bg-white rounded-2xl shadow-sm border border-slate-100 p-8 md:p-10">
                        <div class="mb-8">
                            <h2 class="text-2xl font-light text-slate-900 mb-1" style="font-family:'Playfair Display',serif;">¿Dónde está ubicada la propiedad?</h2>
                            <p class="text-slate-400 text-sm">Ingresa la ubicación exacta para que los compradores la encuentren fácilmente.</p>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <!-- Distrito -->
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-2">Distrito *</label>
                                <select name="idDistrito" id="idDistrito" required
                                    class="w-full px-4 py-3.5 rounded-xl border border-slate-200 focus:ring-2 focus:ring-black/10 focus:border-black outline-none bg-white text-sm transition-all">
                                    <option value="">Seleccione un distrito</option>
                                    <c:forEach var="d" items="${listaDistritos}">
                                        <option value="${d.id}" ${propiedad != null && propiedad.idDistrito == d.id ? 'selected' : ''}>
                                            ${d.nombre}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Dirección -->
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-2">Dirección Exacta *</label>
                                <input type="text" name="direccion" id="direccion" required placeholder="Ej. Av. Pardo 123"
                                    value="${propiedad != null ? propiedad.direccion : ''}"
                                    class="w-full px-4 py-3.5 rounded-xl border border-slate-200 focus:ring-2 focus:ring-black/10 focus:border-black outline-none text-sm transition-all">
                            </div>

                            <!-- Partida Registral -->
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-2">Partida Registral (SUNARP)</label>
                                <input type="text" name="partidaRegistral" placeholder="Ej. 11029384"
                                    value="${propiedad != null ? propiedad.partidaRegistral : ''}"
                                    class="w-full px-4 py-3.5 rounded-xl border border-slate-200 focus:ring-2 focus:ring-black/10 focus:border-black outline-none text-sm transition-all">
                            </div>

                            <!-- Referencia -->
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-2">Referencia de Ubicación</label>
                                <input type="text" name="referencia" placeholder="Ej. Frente al parque Kennedy"
                                    value="${propiedad != null ? propiedad.referencia : ''}"
                                    class="w-full px-4 py-3.5 rounded-xl border border-slate-200 focus:ring-2 focus:ring-black/10 focus:border-black outline-none text-sm transition-all">
                            </div>

                            <!-- Map -->
                            <div class="md:col-span-2">
                                <label class="block text-sm font-semibold text-slate-700 mb-2">
                                    Ubicación en el Mapa
                                    <span class="font-normal text-slate-400">(Haz clic para situar el pin)</span>
                                </label>
                                <div id="registro-map" class="w-full h-72 rounded-xl border border-slate-200 shadow-sm z-10"></div>
                                <p class="text-xs text-slate-400 mt-2">Coordenadas: <span id="coordenadas-display" class="font-mono font-semibold text-slate-600">Ninguna</span></p>
                                <input type="hidden" id="latitud" name="latitud" value="${propiedad != null && propiedad.latitud != null ? propiedad.latitud : ''}">
                                <input type="hidden" id="longitud" name="longitud" value="${propiedad != null && propiedad.longitud != null ? propiedad.longitud : ''}">
                            </div>
                        </div>

                        <p id="step2-error" class="text-red-500 text-sm font-medium mt-4 hidden">
                            Selecciona un distrito e ingresa la dirección para continuar.
                        </p>
                    </div>
                </div>

                <!-- ============================== -->
                <!--  PASO 3: CARACTERÍSTICAS        -->
                <!-- ============================== -->
                <div class="wizard-panel" data-panel="3" style="display: none;">
                    <div class="bg-white rounded-2xl shadow-sm border border-slate-100 p-8 md:p-10">
                        <div class="mb-8">
                            <h2 class="text-2xl font-light text-slate-900 mb-1" style="font-family:'Playfair Display',serif;">Describe tu propiedad</h2>
                            <p class="text-slate-400 text-sm">Agrega los detalles técnicos y una descripción atractiva.</p>
                        </div>

                        <div class="space-y-6">
                            <!-- Título -->
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-2">Título de la Publicación *</label>
                                <input type="text" name="titulo" id="titulo" required placeholder="Ej. Hermosa casa de 3 pisos en Miraflores"
                                    value="${propiedad != null ? propiedad.titulo : ''}"
                                    class="w-full px-4 py-3.5 rounded-xl border border-slate-200 focus:ring-2 focus:ring-black/10 focus:border-black outline-none text-sm transition-all">
                            </div>

                            <!-- Descripción -->
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-2">Descripción Detallada *</label>
                                <textarea name="descripcion" id="descripcion" rows="4" required
                                    placeholder="Describe las comodidades, la zona, cercanía a lugares importantes..."
                                    class="w-full px-4 py-3.5 rounded-xl border border-slate-200 focus:ring-2 focus:ring-black/10 focus:border-black outline-none text-sm transition-all resize-none">${propiedad != null ? propiedad.descripcion : ''}</textarea>
                            </div>

                            <!-- Datos Técnicos Grid -->
                            <div>
                                <h3 class="text-lg font-semibold text-slate-800 mb-4 flex items-center gap-2">
                                    <svg class="w-5 h-5 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 8V4m0 0h4M4 4l5 5m11-1V4m0 0h-4m4 0l-5 5M4 16v4m0 0h4m-4 0l5-5m11 5v-4m0 4h-4m4 0l-5-5"></path></svg>
                                    Datos Técnicos
                                </h3>
                                <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                                    <div>
                                        <label class="block text-xs font-semibold text-slate-500 mb-1.5">Área Total (m²)</label>
                                        <input type="number" step="0.01" name="areaTotalM2" placeholder="120.5"
                                            value="${propiedad != null ? propiedad.areaTotalM2 : ''}"
                                            class="w-full px-4 py-3 rounded-xl border border-slate-200 focus:ring-2 focus:ring-black/10 focus:border-black outline-none text-sm transition-all">
                                    </div>
                                    <div>
                                        <label class="block text-xs font-semibold text-slate-500 mb-1.5">Área Techada (m²)</label>
                                        <input type="number" step="0.01" name="areaTechadaM2" placeholder="100.0"
                                            value="${propiedad != null ? propiedad.areaTechadaM2 : ''}"
                                            class="w-full px-4 py-3 rounded-xl border border-slate-200 focus:ring-2 focus:ring-black/10 focus:border-black outline-none text-sm transition-all">
                                    </div>
                                    <div>
                                        <label class="block text-xs font-semibold text-slate-500 mb-1.5">Dormitorios</label>
                                        <input type="number" name="numDormitorios" placeholder="3"
                                            value="${propiedad != null && propiedad.numDormitorios > 0 ? propiedad.numDormitorios : ''}"
                                            class="w-full px-4 py-3 rounded-xl border border-slate-200 focus:ring-2 focus:ring-black/10 focus:border-black outline-none text-sm transition-all">
                                    </div>
                                    <div>
                                        <label class="block text-xs font-semibold text-slate-500 mb-1.5">Baños</label>
                                        <input type="number" name="numBanos" placeholder="2"
                                            value="${propiedad != null && propiedad.numBanos > 0 ? propiedad.numBanos : ''}"
                                            class="w-full px-4 py-3 rounded-xl border border-slate-200 focus:ring-2 focus:ring-black/10 focus:border-black outline-none text-sm transition-all">
                                    </div>
                                    <div>
                                        <label class="block text-xs font-semibold text-slate-500 mb-1.5">Cocheras</label>
                                        <input type="number" name="numCocheras" placeholder="1"
                                            value="${propiedad != null && propiedad.numCocheras > 0 ? propiedad.numCocheras : ''}"
                                            class="w-full px-4 py-3 rounded-xl border border-slate-200 focus:ring-2 focus:ring-black/10 focus:border-black outline-none text-sm transition-all">
                                    </div>
                                    <div>
                                        <label class="block text-xs font-semibold text-slate-500 mb-1.5">Nº de Pisos</label>
                                        <input type="number" name="numPisos" placeholder="2"
                                            value="${propiedad != null && propiedad.numPisos > 0 ? propiedad.numPisos : ''}"
                                            class="w-full px-4 py-3 rounded-xl border border-slate-200 focus:ring-2 focus:ring-black/10 focus:border-black outline-none text-sm transition-all">
                                    </div>
                                    <div>
                                        <label class="block text-xs font-semibold text-slate-500 mb-1.5">Año Construcción</label>
                                        <input type="number" name="anioConstruccion" placeholder="2020"
                                            value="${propiedad != null && propiedad.anioConstruccion > 0 ? propiedad.anioConstruccion : ''}"
                                            class="w-full px-4 py-3 rounded-xl border border-slate-200 focus:ring-2 focus:ring-black/10 focus:border-black outline-none text-sm transition-all">
                                    </div>
                                    <div>
                                        <label class="block text-xs font-semibold text-slate-500 mb-1.5">Tour 360°</label>
                                        <input type="url" name="tour360Url" placeholder="URL del tour"
                                            value="${propiedad != null ? propiedad.tour360Url : ''}"
                                            class="w-full px-4 py-3 rounded-xl border border-slate-200 focus:ring-2 focus:ring-black/10 focus:border-black outline-none text-sm transition-all">
                                    </div>
                                </div>
                            </div>

                            <!-- Atributos Especiales -->
                            <div>
                                <h3 class="text-lg font-semibold text-slate-800 mb-4 flex items-center gap-2">
                                    <svg class="w-5 h-5 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 3v4M3 5h4M6 17v4m-2-2h4m5-16l2.286 6.857L21 12l-5.714 2.143L13 21l-2.286-6.857L5 12l5.714-2.143L13 3z"></path></svg>
                                    Atributos Especiales
                                </h3>
                                <div class="flex flex-wrap gap-4">
                                    <label class="flex items-center gap-3 cursor-pointer bg-slate-50 hover:bg-slate-100 rounded-xl px-5 py-4 border border-slate-200 transition-all">
                                        <input type="checkbox" name="bonoMiVivienda" value="1"
                                            ${propiedad != null && propiedad.bonoMiVivienda == 1 ? 'checked' : ''}
                                            class="w-5 h-5 text-black rounded focus:ring-black accent-black">
                                        <div>
                                            <span class="text-sm font-semibold text-slate-700 block">Bono MiVivienda</span>
                                            <span class="text-xs text-slate-400">Aplica al programa MiVivienda</span>
                                        </div>
                                    </label>
                                    <label class="flex items-center gap-3 cursor-pointer bg-emerald-50/50 hover:bg-emerald-50 rounded-xl px-5 py-4 border border-emerald-200/50 transition-all">
                                        <input type="checkbox" name="bonoVerde" value="1"
                                            ${propiedad != null && propiedad.bonoVerde == 1 ? 'checked' : ''}
                                            class="w-5 h-5 text-emerald-600 rounded focus:ring-emerald-500 accent-emerald-600">
                                        <div>
                                            <span class="text-sm font-semibold text-emerald-800 block">Bono Verde</span>
                                            <span class="text-xs text-emerald-500">Propiedad eco-sostenible</span>
                                        </div>
                                    </label>
                                </div>
                            </div>
                        </div>

                        <p id="step3-error" class="text-red-500 text-sm font-medium mt-4 hidden">
                            Ingresa un título y descripción para continuar.
                        </p>
                    </div>
                </div>

                <!-- ============================== -->
                <!--  PASO 4: PRECIO                 -->
                <!-- ============================== -->
                <div class="wizard-panel" data-panel="4" style="display: none;">
                    <div class="bg-white rounded-2xl shadow-sm border border-slate-100 p-8 md:p-10">
                        <div class="mb-8">
                            <h2 class="text-2xl font-light text-slate-900 mb-1" style="font-family:'Playfair Display',serif;">¿Cuál es el precio de tu inmueble?</h2>
                            <p class="text-slate-400 text-sm">Selecciona la moneda e ingresa el monto que deseas.</p>
                        </div>

                        <!-- Currency Selector -->
                        <div class="flex flex-col items-center gap-8">
                            <div class="flex gap-4">
                                <label class="moneda-card cursor-pointer">
                                    <input type="radio" name="monedaBase" value="USD" class="sr-only peer"
                                        ${propiedad == null || propiedad.monedaBase == 'USD' ? 'checked' : ''}>
                                    <div class="peer-checked:border-black peer-checked:bg-black peer-checked:text-white border-2 border-slate-200 rounded-2xl px-8 py-6 text-center transition-all duration-300 hover:border-slate-400 hover:shadow-md">
                                        <span class="text-3xl font-black block mb-1">US$</span>
                                        <span class="text-xs font-semibold uppercase tracking-wider opacity-70">Dólares</span>
                                    </div>
                                </label>
                                <label class="moneda-card cursor-pointer">
                                    <input type="radio" name="monedaBase" value="PEN" class="sr-only peer"
                                        ${propiedad != null && propiedad.monedaBase == 'PEN' ? 'checked' : ''}>
                                    <div class="peer-checked:border-black peer-checked:bg-black peer-checked:text-white border-2 border-slate-200 rounded-2xl px-8 py-6 text-center transition-all duration-300 hover:border-slate-400 hover:shadow-md">
                                        <span class="text-3xl font-black block mb-1">S/.</span>
                                        <span class="text-xs font-semibold uppercase tracking-wider opacity-70">Soles</span>
                                    </div>
                                </label>
                            </div>

                            <!-- Price Input -->
                            <div class="w-full max-w-md">
                                <label class="block text-sm font-semibold text-slate-700 mb-2 text-center">Monto *</label>
                                <div class="relative">
                                    <span id="currency-symbol" class="absolute left-5 top-1/2 -translate-y-1/2 text-lg font-bold text-slate-400">US$</span>
                                    <input type="number" step="0.01" name="precio" id="precio" required placeholder="150,000.00"
                                        value="${propiedad != null ? propiedad.precio : ''}"
                                        class="w-full pl-16 pr-4 py-5 rounded-2xl border-2 border-slate-200 focus:ring-2 focus:ring-black/10 focus:border-black outline-none text-2xl font-bold text-center transition-all">
                                </div>
                                <p class="text-xs text-slate-400 mt-2 text-center">
                                    Para operaciones de <strong>Venta</strong>, el precio mínimo es de 10,000.
                                </p>
                            </div>
                        </div>

                        <p id="step4-error" class="text-red-500 text-sm font-medium mt-4 hidden text-center">
                            Ingresa un precio válido para continuar.
                        </p>
                    </div>
                </div>

                <!-- ============================== -->
                <!--  PASO 5: FOTOS Y PUBLICACIÓN    -->
                <!-- ============================== -->
                <div class="wizard-panel" data-panel="5" style="display: none;">
                    <div class="bg-white rounded-2xl shadow-sm border border-slate-100 p-8 md:p-10">
                        <div class="mb-8">
                            <h2 class="text-2xl font-light text-slate-900 mb-1" style="font-family:'Playfair Display',serif;">Imágenes de tu propiedad</h2>
                            <p class="text-slate-400 text-sm">Ingresa las direcciones URL de las imágenes de tu inmueble. Puedes usar enlaces de Unsplash u otros repositorios de imágenes.</p>
                        </div>

                        <!-- Foto Principal -->
                        <div class="mb-8">
                            <label class="block text-sm font-bold text-slate-700 mb-2">Foto Principal (URL)</label>
                            <input type="url" name="fotoPrincipalUrl" id="fotoPrincipalInput" 
                                placeholder="Ej: https://images.unsplash.com/photo-..." 
                                value="${propiedad != null ? propiedad.fotoPrincipal : ''}"
                                class="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-sm focus:outline-none focus:border-black transition-all">
                            <!-- Live Preview for Main Photo -->
                            <div id="main-preview-container" class="mt-4 ${propiedad != null && not empty propiedad.fotoPrincipal ? '' : 'hidden'}">
                                <span class="text-xs text-slate-400 block mb-1">Vista Previa Foto Principal:</span>
                                <div class="relative inline-block">
                                    <img id="main-preview-img" src="${propiedad != null ? propiedad.getFotoPrincipalUrl(pageContext.request.contextPath) : ''}" 
                                        alt="Vista previa principal" class="w-48 h-32 object-cover rounded-xl border border-slate-200 shadow-sm">
                                </div>
                            </div>
                        </div>

                        <!-- Galería de Fotos Dinámica -->
                        <div class="mb-8 border-t border-slate-100 pt-6">
                            <div class="flex justify-between items-center mb-4">
                                <div>
                                    <h3 class="text-base font-bold text-slate-800">Galería de Fotos (Opcional)</h3>
                                    <p class="text-xs text-slate-400">Agrega URLs de imágenes secundarias para el carrusel de detalles.</p>
                                </div>
                                <button type="button" id="btn-add-gallery-url" 
                                    class="bg-black hover:bg-zinc-800 text-white text-xs font-bold px-4 py-2 rounded-lg transition-all flex items-center gap-1 shadow-sm">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path></svg>
                                    Agregar Foto
                                </button>
                            </div>

                            <div id="galeria-urls-container" class="space-y-4">
                                <!-- Pre-populated inputs if editing -->
                                <c:forEach var="foto" items="${galeriaFotos}" varStatus="status">
                                    <div class="gallery-url-row flex flex-col gap-2 p-3 bg-slate-50 rounded-xl border border-slate-200">
                                        <div class="flex gap-2 items-center">
                                            <span class="text-xs font-bold text-slate-400 min-w-[20px]">${status.index + 1}</span>
                                            <input type="url" name="fotoGaleriaUrl" placeholder="https://example.com/imagen.jpg" 
                                                value="${foto.rutaArchivo}" 
                                                class="flex-1 bg-white border border-slate-200 rounded-lg px-3 py-2 text-xs focus:outline-none focus:border-black transition-all gallery-url-input">
                                            <button type="button" class="btn-remove-gallery-url text-red-500 hover:text-red-700 p-2 rounded-lg hover:bg-red-50 transition-colors" title="Eliminar">
                                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path></svg>
                                            </button>
                                        </div>
                                        <div class="gallery-preview-wrapper ${not empty foto.rutaArchivo ? '' : 'hidden'}">
                                            <img src="${foto.getRutaArchivoUrl(pageContext.request.contextPath)}" class="w-24 h-16 object-cover rounded-lg border shadow-sm">
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>

                        <!-- Summary Preview -->
                        <div class="mt-8 p-6 bg-slate-50 rounded-xl border border-slate-200">
                            <h3 class="text-base font-bold text-slate-800 mb-4 flex items-center gap-2">
                                <svg class="w-5 h-5 text-slate-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"></path></svg>
                                Resumen de tu Publicación
                            </h3>
                            <div id="summary-content" class="grid grid-cols-2 gap-3 text-sm">
                                <div class="bg-white rounded-lg p-3 border border-slate-100">
                                    <span class="text-xs text-slate-400 block">Tipo</span>
                                    <span id="sum-tipo" class="font-semibold text-slate-800">—</span>
                                </div>
                                <div class="bg-white rounded-lg p-3 border border-slate-100">
                                    <span class="text-xs text-slate-400 block">Operación</span>
                                    <span id="sum-operacion" class="font-semibold text-slate-800">—</span>
                                </div>
                                <div class="bg-white rounded-lg p-3 border border-slate-100">
                                    <span class="text-xs text-slate-400 block">Ubicación</span>
                                    <span id="sum-ubicacion" class="font-semibold text-slate-800">—</span>
                                </div>
                                <div class="bg-white rounded-lg p-3 border border-slate-100">
                                    <span class="text-xs text-slate-400 block">Título</span>
                                    <span id="sum-titulo" class="font-semibold text-slate-800">—</span>
                                </div>
                                <div class="bg-white rounded-lg p-3 border border-slate-100 col-span-2">
                                    <span class="text-xs text-slate-400 block">Precio</span>
                                    <span id="sum-precio" class="font-bold text-xl text-black">—</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ============================== -->
                <!--   NAVIGATION BUTTONS            -->
                <!-- ============================== -->
                <div class="flex items-center justify-between mt-8">
                    <button type="button" id="btn-prev"
                        class="hidden bg-transparent border-2 border-black hover:bg-black/5 text-black font-bold px-8 py-4 rounded-xl transition-all duration-300 text-sm flex items-center gap-2">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path></svg>
                        Anterior
                    </button>
                    <div class="flex-1"></div>

                    <button type="button" id="btn-next"
                        class="bg-black hover:bg-zinc-800 text-white font-bold px-10 py-4 rounded-xl shadow-lg transition-all duration-300 hover:-translate-y-0.5 text-sm flex items-center gap-2">
                        Siguiente
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3"></path></svg>
                    </button>

                    <button type="submit" id="btn-submit"
                        class="hidden bg-black hover:bg-zinc-800 text-white font-bold px-10 py-4 rounded-xl shadow-lg transition-all duration-300 hover:-translate-y-0.5 text-sm flex items-center gap-2">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>
                        ${propiedad != null && propiedad.id > 0 ? 'Actualizar Propiedad' : 'Publicar Propiedad'}
                    </button>
                </div>
            </form>

        </div>
    </main>

    <!-- Footer Premium -->
    <footer class="bg-[#000000] border-t border-white/10 text-slate-400 py-16 mt-auto">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="grid grid-cols-1 md:grid-cols-4 gap-12 mb-12 text-left">
                <div class="space-y-4">
                    <div class="flex items-center gap-2">
                        <img src="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png" alt="Inmobix Logo" class="h-8 w-auto brightness-0 invert">
                        <span class="text-2xl font-black text-white tracking-tight">InmobiX</span>
                    </div>
                    <p class="text-sm text-slate-400 leading-relaxed">
                        El portal inmobiliario premium del Perú. Encuentra tu próximo hogar con la seguridad, rapidez y confianza que mereces.
                    </p>
                    <div class="flex items-center gap-4 pt-2">
                        <a href="#" class="text-slate-400 hover:text-white transition-colors" title="Facebook">
                            <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24"><path d="M22 12c0-5.52-4.48-10-10-10S2 6.48 2 12c0 4.84 3.44 8.87 8 9.8V15H8v-3h2V9.5C10 7.57 11.57 6 13.5 6H16v3h-2c-.55 0-1 .45-1 1v2h3v3h-3v6.95c4.56-.93 8-4.96 8-9.75z"/></svg>
                        </a>
                        <a href="#" class="text-slate-400 hover:text-white transition-colors" title="Instagram">
                            <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24"><path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zM12 0C8.741 0 8.333.014 7.053.072 2.695.272.273 2.69.073 7.051.014 8.333 0 8.741 0 12c0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98 1.281.058 1.689.072 4.948.072 3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98C15.668.014 15.259 0 12 0zm0 5.838a6.162 6.162 0 100 12.324 6.162 6.162 0 000-12.324zM12 16a4 4 0 110-8 4 4 0 010 8zm6.406-11.845a1.44 1.44 0 100 2.881 1.44 1.44 0 000-2.881z"/></svg>
                        </a>
                    </div>
                </div>
                <div class="space-y-4">
                    <h4 class="text-white font-bold text-sm tracking-wider uppercase">Empresa</h4>
                    <ul class="space-y-2 text-sm">
                        <li><a href="#" class="hover:text-white transition-colors">Nosotros</a></li>
                        <li><a href="#" class="hover:text-white transition-colors">Blog Inmobiliario</a></li>
                        <li><a href="#" class="hover:text-white transition-colors">Prensa</a></li>
                        <li><a href="#" class="hover:text-white transition-colors">Carreras</a></li>
                    </ul>
                </div>
                <div class="space-y-4">
                    <h4 class="text-white font-bold text-sm tracking-wider uppercase">Servicios</h4>
                    <ul class="space-y-2 text-sm">
                        <li><a href="${pageContext.request.contextPath}/propiedades" class="hover:text-white transition-colors">Comprar Propiedad</a></li>
                        <li><a href="${pageContext.request.contextPath}/propiedades?accion=nuevo" class="hover:text-white transition-colors">Publicar Inmueble</a></li>
                        <li><a href="${pageContext.request.contextPath}/pagos?accion=planes" class="hover:text-white transition-colors">Planes de Membresía</a></li>
                    </ul>
                </div>
                <div class="space-y-4">
                    <h4 class="text-white font-bold text-sm tracking-wider uppercase">Soporte</h4>
                    <ul class="space-y-2 text-sm">
                        <li><a href="${pageContext.request.contextPath}/contacto" class="hover:text-white transition-colors">Contacto</a></li>
                        <li><a href="#" class="hover:text-white transition-colors">Preguntas Frecuentes</a></li>
                        <li><a href="#" class="hover:text-white transition-colors">Términos y Condiciones</a></li>
                        <li><a href="#" class="hover:text-white transition-colors">Políticas de Privacidad</a></li>
                    </ul>
                </div>
            </div>
            <div class="border-t border-white/10 pt-8 flex flex-col md:flex-row justify-between items-center gap-4 text-xs text-slate-500">
                <p>&amp;copy; 2026 Portal Inmobiliario Inmobix. Todos los derechos reservados.</p>
            </div>
        </div>
    </footer>

</body>
</html>