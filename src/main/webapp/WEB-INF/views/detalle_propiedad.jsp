<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png">
    <title>Inmobix - Detalle de Propiedad</title>
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
    <!-- Leaflet CSS -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
</head>
<body class="bg-brandBg text-brandText flex flex-col min-h-screen font-sans">
    
    <!-- Navbar -->
    <header class="text-white fixed w-full top-0 z-50 bg-black/90 backdrop-blur-md backdrop-blur-md border-b border-white/10 shadow-lg transition-all">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center h-20">
                <div class="flex items-center gap-3">
                    <img src="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png" alt="Inmobix Logo" class="h-10 w-auto object-contain brightness-0 invert">
                    <span class="text-2xl font-bold text-white tracking-tight">Inmobix</span>
                </div>
                
                <nav class="hidden md:flex items-center gap-8">
                    <a href="${pageContext.request.contextPath}/index.jsp" class="text-sm font-semibold text-white/80 hover:text-brandHover transition-colors">Inicio</a>
                    <a href="${pageContext.request.contextPath}/propiedades" class="text-sm font-semibold text-white/80 hover:text-brandHover transition-colors">Catálogo</a>
                    <a href="${pageContext.request.contextPath}/propiedades?accion=nuevo" class="text-sm font-semibold text-white/80 hover:text-brandHover transition-colors">Publicar</a>
                    <a href="${pageContext.request.contextPath}/contacto" class="text-sm font-semibold text-white/80 hover:text-brandHover transition-colors">Contacto</a>
                </nav>

                <div class="hidden md:flex items-center gap-4">
                    <c:choose>
                        <c:when test="${not empty sessionScope.usuarioLogueado}">
                            <span class="text-sm font-semibold text-white/80">Hola, ${sessionScope.usuarioLogueado.nombres}</span>
                            <c:if test="${sessionScope.usuarioLogueado.idRol == 3 || sessionScope.usuarioLogueado.idRol == 4 || sessionScope.usuarioLogueado.idRol == 5}">
                                <a href="${pageContext.request.contextPath}/panel" class="text-sm font-semibold text-brandHover hover:text-white transition-colors">Mi Panel</a>
                            </c:if>
                            <a href="${pageContext.request.contextPath}/usuario?accion=logout" class="bg-brandBtn hover:bg-brandHover text-white px-5 py-2.5 rounded-full text-sm font-semibold shadow-md shadow-slate-800/20 transition-all hover:-translate-y-0.5">Cerrar Sesión</a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/usuario?accion=login" class="text-sm font-semibold text-white/80 hover:text-brandHover transition-colors">Iniciar sesión</a>
                            <a href="${pageContext.request.contextPath}/usuario?accion=registro" class="bg-brandBtn hover:bg-brandHover text-white px-5 py-2.5 rounded-full text-sm font-semibold shadow-md shadow-brandBtn/20 transition-all hover:-translate-y-0.5">Regístrate</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </header>

    <main class="flex-grow pt-28 pb-16 px-4">
        <div class="max-w-6xl mx-auto">
            
            <a href="${pageContext.request.contextPath}/propiedades" class="text-brandBtn hover:text-brandHover flex items-center gap-2 font-semibold mb-6 transition-colors">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path></svg>
                Volver al catálogo
            </a>

            <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                <!-- Detalles Principales -->
                <div class="lg:col-span-2 space-y-8">
                    <!-- Tarjeta Hero -->
                    <div class="bg-white rounded-2xl shadow-xl shadow-slate-200/50 border border-slate-100 overflow-hidden">
                        <!-- Sprint 2: Foto principal -->
                        <div class="relative h-72 md:h-96 bg-gradient-to-br from-slate-200 to-slate-300 overflow-hidden">
                            <c:choose>
                                <c:when test="${not empty propiedad.fotoPrincipal}">
                                    <img src="${pageContext.request.contextPath}/${propiedad.fotoPrincipal}" alt="${propiedad.titulo}" class="w-full h-full object-cover">
                                </c:when>
                                <c:otherwise>
                                     <div class="w-full h-full flex items-center justify-center text-slate-400">
                                         <svg class="w-16 h-16 text-slate-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>
                                     </div>
                                </c:otherwise>
                            </c:choose>
                            <c:if test="${not empty sessionScope.usuarioLogueado}">
                                <c:choose>
                                    <c:when test="${propiedad.favorito}">
                                        <a href="${pageContext.request.contextPath}/favorito?accion=remover&id=${propiedad.id}" class="absolute top-4 right-4 w-14 h-14 bg-red-500 text-white rounded-full flex items-center justify-center shadow-xl hover:bg-red-600 transition-colors" title="Quitar de favoritos">
                                            <svg class="w-6 h-6 text-white" fill="currentColor" viewBox="0 0 24 24">
                                                <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
                                            </svg>
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/favorito?accion=agregar&id=${propiedad.id}" class="absolute top-4 right-4 w-14 h-14 bg-white/90 backdrop-blur text-slate-500 rounded-full flex items-center justify-center shadow-xl hover:bg-red-50 hover:text-red-500 transition-colors" title="Guardar en favoritos">
                                            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"></path>
                                            </svg>
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                            <div class="absolute bottom-4 left-4 flex items-center gap-2">
                                <span class="px-3 py-1 bg-white/90 backdrop-blur text-slate-600 rounded-full text-xs font-bold inline-flex items-center gap-1">
                                    <svg class="w-3.5 h-3.5 text-slate-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path></svg>
                                    ${propiedad.numeroVistas} vistas
                                </span>
                            </div>
                        </div>
                        <div class="p-8">
                            <div class="flex flex-wrap gap-2 mb-4">
                                <span class="px-3 py-1 bg-blue-100 text-blue-700 rounded-full text-sm font-bold tracking-wide">${propiedad.operacion}</span>
                                <span class="px-3 py-1 bg-slate-100 text-slate-700 rounded-full text-sm font-bold tracking-wide">${propiedad.tipoInmueble}</span>
                                <c:if test="${propiedad.bonoMiVivienda == 1}">
                                    <span class="px-3 py-1 bg-emerald-100 text-emerald-700 rounded-full text-sm font-bold tracking-wide">Bono MiVivienda</span>
                                </c:if>
                                <c:if test="${propiedad.bonoVerde == 1}">
                                    <span class="px-3 py-1 bg-teal-100 text-teal-700 rounded-full text-sm font-bold tracking-wide">Bono Verde</span>
                                </c:if>
                            </div>
                            <h1 class="text-4xl font-extrabold text-slate-900 mb-4 leading-tight">${propiedad.titulo}</h1>
                            <p class="text-slate-500 flex items-center gap-1.5 text-lg mb-6">
                                <svg class="w-5 h-5 text-slate-400 inline" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                                ${propiedad.direccion}, ${propiedad.distrito}, ${propiedad.provincia}
                            </p>
                            <!-- Sprint 2: Precio bimonetario con tipo de cambio -->
                            <div class="bg-gradient-to-r from-blue-50 to-indigo-50 rounded-xl p-6">
                                <div class="flex items-baseline gap-4 flex-wrap">
                                    <span class="text-4xl font-black text-blue-600">US$ ${propiedad.precioUsd}</span>
                                    <span class="text-2xl font-bold text-slate-400">|</span>
                                    <span class="text-3xl font-bold text-slate-600">S/. ${propiedad.precioPen}</span>
                                </div>
                                <c:if test="${propiedad.tipoCambioVenta != null}">
                                    <p class="text-xs text-slate-400 mt-2 font-semibold">Tipo de cambio referencial: S/. ${propiedad.tipoCambioVenta} por USD (fuente SBS)</p>
                                </c:if>
                            </div>
                        </div>
        
                    <!-- Sprint 3: Galería thumbnails -->
                    <c:if test="${not empty galeriaFotos}">
                    <div class="bg-white rounded-2xl p-6 shadow-xl border border-slate-100">
                        <h2 class="text-lg font-bold text-slate-900 mb-4">Galería</h2>
                        <div class="flex gap-2 overflow-x-auto">
                            <c:forEach var="foto" items="${galeriaFotos}">
                                <img src="${pageContext.request.contextPath}/${foto.rutaArchivo}" alt="Foto" class="w-24 h-20 object-cover rounded-lg cursor-pointer border-2 border-transparent hover:border-blue-500 transition-all gallery-thumb" onclick="cambiarFotoPrincipal(this.src)">
                            </c:forEach>
                        </div>
                    </div>
                    </c:if>

                    <!-- Descripción -->
                    <div class="bg-white rounded-2xl p-8 shadow-xl border border-slate-100">
                        <h2 class="text-2xl font-bold text-slate-900 mb-6">Descripción</h2>
                        <div class="text-slate-600 leading-relaxed whitespace-pre-wrap">${propiedad.descripcion}</div>
                    </div>

                    <!-- Características -->
                    <div class="bg-white rounded-2xl p-8 shadow-xl border border-slate-100">
                        <h2 class="text-2xl font-bold text-slate-900 mb-6">Características</h2>
                        <div class="grid grid-cols-2 md:grid-cols-4 gap-6">
                            <div class="flex flex-col items-center p-4 bg-slate-50 rounded-xl">
                                <svg class="w-6 h-6 text-slate-400 mb-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 8V4m0 0h4M4 4l5 5m11-1V4m0 0h-4m4 0l-5 5M4 16v4m0 0h4m-4 0l5-5m11 5l-5-5m5 5v-4m0 4h-4"></path></svg>
                                <span class="text-xl font-bold">${propiedad.areaTotalM2} m²</span>
                                <span class="text-xs text-slate-500 font-bold uppercase tracking-tight">Área Total</span>
                            </div>
                            <div class="flex flex-col items-center p-4 bg-slate-50 rounded-xl">
                                <svg class="w-6 h-6 text-slate-400 mb-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>
                                <span class="text-xl font-bold">${propiedad.numDormitorios}</span>
                                <span class="text-xs text-slate-500 font-bold uppercase tracking-tight">Dormitorios</span>
                            </div>
                            <div class="flex flex-col items-center p-4 bg-slate-50 rounded-xl">
                                <svg class="w-6 h-6 text-slate-400 mb-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"></path></svg>
                                <span class="text-xl font-bold">${propiedad.numBanos}</span>
                                <span class="text-xs text-slate-500 font-bold uppercase tracking-tight">Baños</span>
                            </div>
                            <div class="flex flex-col items-center p-4 bg-slate-50 rounded-xl">
                                <svg class="w-6 h-6 text-slate-400 mb-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                                <span class="text-xl font-bold">${propiedad.anioConstruccion}</span>
                                <span class="text-xs text-slate-500 font-bold uppercase tracking-tight">Año Const.</span>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white rounded-2xl p-8 shadow-xl border border-slate-100 mt-6">
                        <h2 class="text-2xl font-bold text-slate-900 mb-6">Ubicación</h2>
                        <p class="text-slate-500 mb-4 text-sm flex items-center gap-2">
                            <svg class="w-5 h-5 text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                            ${propiedad.direccion}, ${propiedad.distrito}, ${propiedad.provincia}
                        </p>
                        <div id="map" class="w-full h-80 rounded-xl border border-slate-200 z-0"></div>
                    </div>
                </div>

                <!-- Barra Lateral -->
                <div class="space-y-6">
                    <!-- Agente -->
                    <div class="bg-white rounded-2xl p-6 shadow-xl border border-slate-100 sticky top-28">
                        <h3 class="text-lg font-bold text-slate-900 mb-4 border-b pb-3">Publicado por</h3>
                        <div class="flex items-center gap-3 mb-4">
                            <div class="w-14 h-14 bg-blue-100 rounded-full flex items-center justify-center text-blue-600 font-bold text-lg uppercase">${propiedad.agenteNombre.substring(0,2)}</div>
                            <div><h4 class="font-bold text-slate-800">${propiedad.agenteNombre}</h4><span class="text-xs text-slate-500">Agente Inmobiliario</span></div>
                        </div>
                        <div class="space-y-2 mb-4 text-sm text-slate-600">
                            <div class="flex items-center gap-2">
                                <svg class="w-4 h-4 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"></path></svg>
                                <span class="font-semibold">${propiedad.agenteTelefono != null ? propiedad.agenteTelefono : 'No especificado'}</span>
                            </div>
                            <div class="flex items-center gap-2">
                                <svg class="w-4 h-4 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path></svg>
                                <span class="font-semibold break-all">${propiedad.agenteCorreo}</span>
                            </div>
                        </div>

                        <!-- WhatsApp -->
                        <button onclick="document.getElementById('waModal').classList.remove('hidden')" class="w-full bg-emerald-600 hover:bg-emerald-700 text-white font-bold py-3 rounded-xl shadow-lg mb-3 flex justify-center items-center gap-2 transition-all">
                            <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24"><path d="M12.031 6.172c-3.181 0-5.767 2.586-5.767 5.767 0 1.012.261 2.001.763 2.87l-.811 2.96 3.028-.794c.839.457 1.776.697 2.729.697 3.181 0 5.767-2.586 5.767-5.767 0-3.181-2.586-5.767-5.767-5.767zm3.39 8.161c-.146.411-.75.763-1.037.81-.27.043-.618.069-1.01-.061a5.05 5.05 0 01-2.181-1.341 5.56 5.56 0 01-1.468-1.921 2.39 2.39 0 01-.107-.94c.101-.527.42-.77.561-.914.137-.146.3-.186.4-.186h.257c.081 0 .182-.03.284.213.102.242.348.847.379.914.03.065.051.141.01.223-.04.081-.061.131-.121.202-.06.071-.126.157-.182.213-.061.061-.126.126-.05.257.076.131.338.557.724.901.496.442.914.581 1.046.642.131.061.207.051.284-.04.076-.091.328-.385.415-.517.086-.131.171-.111.288-.065.116.046.733.348.86.411.127.065.213.096.244.152.03.056.03.324-.116.735z"></path></svg>
                            Contactar por WhatsApp
                        </button>

                        <!-- Toggle contacto -->
                        <button onclick="document.getElementById('contactForm').classList.toggle('hidden')" class="w-full bg-brandBtn hover:bg-brandHover text-white font-bold py-3 rounded-xl shadow-lg transition-all">Enviar Consulta</button>
                    </div>

                    <!-- Sprint 3: Formulario de contacto -->
                    <div id="contactForm" class="bg-white rounded-2xl p-6 shadow-xl border border-slate-100 hidden">
                        <h3 class="text-lg font-bold mb-4">Enviar Consulta</h3>
                        <c:if test="${param.consultaEnviada == 'true'}"><div class="mb-4 bg-emerald-50 border-l-4 border-emerald-500 p-3 rounded-r-lg text-sm text-emerald-700 font-bold">Consulta enviada exitosamente.</div></c:if>
                        <form action="${pageContext.request.contextPath}/consulta" method="post" class="space-y-3">
                            <input type="hidden" name="idPropiedad" value="${propiedad.id}">
                            <input type="text" name="nombre" required placeholder="Tu nombre" value="${sessionScope.usuarioLogueado != null ? sessionScope.usuarioLogueado.nombres : ''}" class="w-full px-3 py-2.5 rounded-lg border text-sm">
                            <input type="email" name="email" required placeholder="Tu email" value="${sessionScope.usuarioLogueado != null ? sessionScope.usuarioLogueado.correo : ''}" class="w-full px-3 py-2.5 rounded-lg border text-sm">
                            <input type="tel" name="telefono" placeholder="Teléfono" class="w-full px-3 py-2.5 rounded-lg border text-sm">
                            <textarea name="mensaje" required placeholder="Escribe tu mensaje..." rows="3" class="w-full px-3 py-2.5 rounded-lg border text-sm"></textarea>
                            <button type="submit" class="w-full bg-brandBtn hover:bg-brandHover text-white py-3 rounded-xl font-bold">Enviar</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- WhatsApp Modal -->
    <div id="waModal" class="hidden fixed inset-0 z-[100] bg-black/50 flex items-center justify-center p-4">
        <div class="bg-white rounded-2xl p-8 max-w-md w-full shadow-2xl">
            <h3 class="text-xl font-bold mb-4 inline-flex items-center gap-2">
                <svg class="w-6 h-6 text-emerald-500" fill="currentColor" viewBox="0 0 24 24"><path d="M12.031 6.172c-3.181 0-5.767 2.586-5.767 5.767 0 1.012.261 2.001.763 2.87l-.811 2.96 3.028-.794c.839.457 1.776.697 2.729.697 3.181 0 5.767-2.586 5.767-5.767 0-3.181-2.586-5.767-5.767-5.767zm3.39 8.161c-.146.411-.75.763-1.037.81-.27.043-.618.069-1.01-.061a5.05 5.05 0 01-2.181-1.341 5.56 5.56 0 01-1.468-1.921 2.39 2.39 0 01-.107-.94c.101-.527.42-.77.561-.914.137-.146.3-.186.4-.186h.257c.081 0 .182-.03.284.213.102.242.348.847.379.914.03.065.051.141.01.223-.04.081-.061.131-.121.202-.06.071-.126.157-.182.213-.061.061-.126.126-.05.257.076.131.338.557.724.901.496.442.914.581 1.046.642.131.061.207.051.284-.04.076-.091.328-.385.415-.517.086-.131.171-.111.288-.065.116.046.733.348.86.411.127.065.213.096.244.152.03.056.03.324-.116.735z"></path></svg>
                Contactar por WhatsApp
            </h3>
            <p class="text-slate-600 mb-2">Se enviará un mensaje al agente <strong>${propiedad.agenteNombre}</strong></p>
            <p class="text-slate-500 mb-6">Número: <strong>${propiedad.agenteTelefono != null ? propiedad.agenteTelefono : 'No disponible'}</strong></p>
            <div class="flex gap-3">
                <button onclick="document.getElementById('waModal').classList.add('hidden')" class="flex-1 bg-slate-200 text-slate-700 py-3 rounded-xl font-bold">Cancelar</button>
                <form action="${pageContext.request.contextPath}/whatsapp" method="post" class="flex-1">
                    <input type="hidden" name="idPropiedad" value="${propiedad.id}">
                    <button type="submit" class="w-full bg-emerald-500 hover:bg-emerald-600 text-white py-3 rounded-xl font-bold">Confirmar</button>
                </form>
            </div>
        </div>
    </div>

    <!-- Lightbox -->
    <div id="lightbox" class="hidden fixed inset-0 z-[100] bg-black/90 flex items-center justify-center p-4 cursor-pointer" onclick="this.classList.add('hidden')">
        <img id="lightboxImg" src="" class="max-w-full max-h-[90vh] rounded-xl">
    </div>

            <!-- Footer Premium -->
        <footer class="bg-[#000000] border-t border-white/10 text-slate-400 py-16 mt-auto">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="grid grid-cols-1 md:grid-cols-4 gap-12 mb-12 text-left">
                    <!-- Column 1: Brand Info -->
                    <div class="space-y-4">
                        <div class="flex items-center gap-2">
                            <img src="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png" alt="Inmobix Logo"
                                class="h-8 w-auto brightness-0 invert">
                            <span class="text-2xl font-black text-white tracking-tight">InmobiX</span>
                        </div>
                        <p class="text-sm text-slate-400 leading-relaxed">
                            El portal inmobiliario premium del Perú. Encuentra tu próximo hogar con la seguridad, rapidez y confianza que mereces.
                        </p>
                        <!-- Social Icons -->
                        <div class="flex items-center gap-4 pt-2">
                            <a href="#" class="text-slate-400 hover:text-white transition-colors" title="Facebook">
                                <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24"><path d="M22 12c0-5.52-4.48-10-10-10S2 6.48 2 12c0 4.84 3.44 8.87 8 9.8V15H8v-3h2V9.5C10 7.57 11.57 6 13.5 6H16v3h-2c-.55 0-1 .45-1 1v2h3v3h-3v6.95c4.56-.93 8-4.96 8-9.75z"/></svg>
                            </a>
                            <a href="#" class="text-slate-400 hover:text-white transition-colors" title="Instagram">
                                <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24"><path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zM12 0C8.741 0 8.333.014 7.053.072 2.695.272.273 2.69.073 7.051.014 8.333 0 8.741 0 12c0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98 1.281.058 1.689.072 4.948.072 3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98C15.668.014 15.259 0 12 0zm0 5.838a6.162 6.162 0 100 12.324 6.162 6.162 0 000-12.324zM12 16a4 4 0 110-8 4 4 0 010 8zm6.406-11.845a1.44 1.44 0 100 2.881 1.44 1.44 0 000-2.881z"/></svg>
                            </a>
                        </div>
                    </div>

                    <!-- Column 2: Empresa -->
                    <div class="space-y-4">
                        <h4 class="text-white font-bold text-sm tracking-wider uppercase">Empresa</h4>
                        <ul class="space-y-2 text-sm">
                            <li><a href="#" class="hover:text-white transition-colors">Nosotros</a></li>
                            <li><a href="#" class="hover:text-white transition-colors">Blog Inmobiliario</a></li>
                            <li><a href="#" class="hover:text-white transition-colors">Prensa</a></li>
                            <li><a href="#" class="hover:text-white transition-colors">Carreras</a></li>
                        </ul>
                    </div>

                    <!-- Column 3: Enlaces Rápidos -->
                    <div class="space-y-4">
                        <h4 class="text-white font-bold text-sm tracking-wider uppercase">Servicios</h4>
                        <ul class="space-y-2 text-sm">
                            <li><a href="${pageContext.request.contextPath}/propiedades" class="hover:text-white transition-colors">Comprar Propiedad</a></li>
                            <li><a href="${pageContext.request.contextPath}/propiedades?accion=nuevo" class="hover:text-white transition-colors">Publicar Inmueble</a></li>
                            <li><a href="${pageContext.request.contextPath}/pagos?accion=planes" class="hover:text-white transition-colors">Planes de Membresía</a></li>
                        </ul>
                    </div>

                    <!-- Column 4: Soporte -->
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
                    <div class="flex items-center gap-6">
                        <span class="inline-flex items-center gap-1.5"><span class="w-2 h-2 rounded-full bg-emerald-500"></span> BD Conectada</span>
                        <span>Hecho en Perú</span>
                    </div>
                </div>
            </div>
        </footer>

<!-- Leaflet JS -->
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script>
function cambiarFotoPrincipal(src) {
    const hero = document.getElementById('heroImg');
    if(hero) hero.src = src;
}
document.querySelectorAll('.gallery-thumb, #heroImg').forEach(img => {
    img.addEventListener('dblclick', function() {
        document.getElementById('lightboxImg').src = this.src;
        document.getElementById('lightbox').classList.remove('hidden');
    });
});

// Inicializar Mapa (Coordenadas dinámicas de la propiedad o Lima Centro como fallback)
var lat = ${propiedad.latitud != null ? propiedad.latitud : -12.046374};
var lng = ${propiedad.longitud != null ? propiedad.longitud : -77.042793};
var zoom = ${propiedad.latitud != null ? 15 : 13};

var map = L.map('map').setView([lat, lng], zoom);
L.tileLayer('https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=8IyYWrIbuDLsiINCC7Du', {
    attribution: '&copy; MapTiler &copy; OpenStreetMap contributors'
}).addTo(map);

L.marker([lat, lng]).addTo(map)
    .bindPopup('<b><c:out value="${propiedad.titulo}"/></b><br><c:out value="${propiedad.distrito}"/>')
    .openPopup();

// Auto-show contact form if consultaEnviada
if(new URLSearchParams(window.location.search).get('consultaEnviada')) {
    document.getElementById('contactForm').classList.remove('hidden');
}
if(new URLSearchParams(window.location.search).get('whatsappRegistrado')) {
    alert('Contacto por WhatsApp registrado exitosamente.');
}
</script>
</body>
</html>
