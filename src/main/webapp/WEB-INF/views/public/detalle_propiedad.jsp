<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es" class="scroll-smooth">
<head>
    <c:set var="pageTitle" value="Inmobix - Detalle de Propiedad" scope="request" />
    <jsp:include page="/WEB-INF/views/layout/head.jsp" />
    <!-- Leaflet CSS -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
</head>
<body class="bg-brandBg text-brandText flex flex-col min-h-screen font-sans">
    
    <!-- Navbar -->
        <c:set var="activePage" value="catalogo" scope="request" />
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <main class="flex-grow pt-28 pb-16 px-4">
        <div class="max-w-6xl mx-auto">
            
            <!-- Barra de Navegación y Utilidades Superior -->
            <div class="flex flex-col sm:flex-row sm:justify-between sm:items-center mb-6 gap-4 border-b border-slate-100 pb-4">
                <a href="${pageContext.request.contextPath}/propiedades" class="text-slate-800 hover:text-black flex items-center gap-2 font-bold transition-colors">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path></svg>
                    Volver al catálogo
                </a>
                <div class="flex items-center gap-6 text-sm text-slate-500 font-semibold select-none">
                    <!-- Favorito -->
                    <c:choose>
                        <c:when test="${not empty sessionScope.usuarioLogueado}">
                            <c:choose>
                                <c:when test="${propiedad.favorito}">
                                    <a href="${pageContext.request.contextPath}/favorito?accion=remover&id=${propiedad.id}" class="flex items-center gap-1.5 text-red-500 hover:text-red-600 transition-colors" title="Quitar de favoritos">
                                        <svg class="w-4.5 h-4.5 fill-current" viewBox="0 0 24 24"><path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/></svg>
                                        <span>Favorito</span>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/favorito?accion=agregar&id=${propiedad.id}" class="flex items-center gap-1.5 hover:text-black transition-colors" title="Guardar en favoritos">
                                        <svg class="w-4.5 h-4.5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"></path></svg>
                                        <span>Favorito</span>
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/usuario?accion=login" class="flex items-center gap-1.5 hover:text-black transition-colors" title="Inicia sesión para guardar">
                                <svg class="w-4.5 h-4.5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"></path></svg>
                                <span>Favorito</span>
                            </a>
                        </c:otherwise>
                    </c:choose>

                    <!-- Compartir -->
                    <button onclick="navigator.clipboard.writeText(window.location.href); alert('Enlace de la propiedad copiado al portapapeles.');" class="flex items-center gap-1.5 hover:text-black transition-colors focus:outline-none">
                        <svg class="w-4.5 h-4.5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M8.684 10.742l4.632-2.316m0 0a3 3 0 100-4.243 3 3 0 000 4.243zm0 4.243l-4.632 2.316m0 0a3 3 0 105.196 2.584l-5.196-2.584a3 3 0 00-5.196-2.584zm0 0a3 3 0 100-4.243 3 3 0 000 4.243z"></path></svg>
                        <span>Compartir</span>
                    </button>

                    <!-- Imprimir -->
                    <button onclick="window.print();" class="flex items-center gap-1.5 hover:text-black transition-colors focus:outline-none">
                        <svg class="w-4.5 h-4.5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z"></path></svg>
                        <span>Imprimir</span>
                    </button>
                </div>
            </div>

            <!-- Galería de Fotos Premium Dinámica (Mosaico Estilo Urbania Adaptativo) -->
            <c:set var="cantFotosSecundarias" value="${galeriaFotos.size()}" />
            <c:choose>
                <%-- Caso 0: Solo la foto principal --%>
                <c:when test="${cantFotosSecundarias == 0}">
                    <div class="h-72 md:h-[28rem] rounded-2xl overflow-hidden relative group mb-8 shadow-lg border border-slate-100 bg-slate-100">
                        <div class="w-full h-full relative overflow-hidden bg-slate-200">
                            <c:choose>
                                <c:when test="${not empty propiedad.fotoPrincipal}">
                                    <img id="heroImg" src="${propiedad.getFotoPrincipalUrl(pageContext.request.contextPath)}" alt="${propiedad.titulo}" class="w-full h-full object-cover cursor-pointer hover:scale-[1.02] transition-transform duration-500" onclick="const lightboxImg = document.getElementById('lightboxImg'); const lightbox = document.getElementById('lightbox'); if (lightboxImg && lightbox) { lightboxImg.src = this.src; lightbox.classList.remove('hidden'); }">
                                </c:when>
                                <c:otherwise>
                                    <img id="heroImg" src="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png" alt="${propiedad.titulo}" class="w-full h-full object-contain p-12 bg-slate-100 cursor-pointer">
                                </c:otherwise>
                            </c:choose>
                            
                            <!-- Badge de Marca / Anunciante -->
                            <div class="absolute top-4 left-4 bg-white/95 backdrop-blur px-3.5 py-2 rounded-xl flex items-center gap-2 shadow-md border border-slate-100 z-10 select-none">
                                <img src="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png" alt="Logo" class="h-4.5 w-auto object-contain">
                                <span class="text-[10px] font-extrabold text-black uppercase tracking-wider">${propiedad.agenteNombre}</span>
                            </div>
                            
                            <!-- Cápsulas flotantes de datos -->
                            <div class="absolute bottom-4 left-4 flex flex-wrap items-center gap-2 z-10 select-none">
                                <span class="px-3 py-1.5 bg-black/80 backdrop-blur-md text-white rounded-xl text-[11px] font-bold inline-flex items-center gap-1.5 shadow-md border border-white/10">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                                    </svg>
                                    1 foto
                                </span>
                                <c:if test="${not empty propiedad.tour360Url}">
                                    <span class="px-3 py-1.5 bg-black/80 backdrop-blur-md text-white rounded-xl text-[11px] font-bold inline-flex items-center gap-1.5 shadow-md border border-white/10">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5 text-red-500 animate-pulse" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                                        </svg>
                                        360° Tour
                                    </span>
                                </c:if>
                                <span class="px-3 py-1.5 bg-black/80 backdrop-blur-md text-white rounded-xl text-[11px] font-bold inline-flex items-center gap-1.5 shadow-md border border-white/10">
                                    <svg class="w-3.5 h-3.5 text-white/80" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path></svg>
                                    ${propiedad.numeroVistas} vistas
                                </span>
                            </div>
                        </div>
                    </div>
                </c:when>

                <%-- Caso 1: Foto principal + 1 foto secundaria --%>
                <c:when test="${cantFotosSecundarias == 1}">
                    <div class="grid grid-cols-1 md:grid-cols-4 gap-2 h-72 md:h-[28rem] rounded-2xl overflow-hidden relative group mb-8 shadow-lg border border-slate-100 bg-slate-100">
                        <!-- Foto Principal (ocupa 3 de 4 columnas) -->
                        <div class="col-span-1 md:col-span-3 relative overflow-hidden bg-slate-200 h-full">
                            <c:choose>
                                <c:when test="${not empty propiedad.fotoPrincipal}">
                                    <img id="heroImg" src="${propiedad.getFotoPrincipalUrl(pageContext.request.contextPath)}" alt="${propiedad.titulo}" class="w-full h-full object-cover cursor-pointer hover:scale-[1.02] transition-transform duration-500" onclick="const lightboxImg = document.getElementById('lightboxImg'); const lightbox = document.getElementById('lightbox'); if (lightboxImg && lightbox) { lightboxImg.src = this.src; lightbox.classList.remove('hidden'); }">
                                </c:when>
                                <c:otherwise>
                                    <img id="heroImg" src="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png" alt="${propiedad.titulo}" class="w-full h-full object-contain p-12 bg-slate-100 cursor-pointer">
                                </c:otherwise>
                            </c:choose>
                            
                            <!-- Badge de Marca / Anunciante -->
                            <div class="absolute top-4 left-4 bg-white/95 backdrop-blur px-3.5 py-2 rounded-xl flex items-center gap-2 shadow-md border border-slate-100 z-10 select-none">
                                <img src="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png" alt="Logo" class="h-4.5 w-auto object-contain">
                                <span class="text-[10px] font-extrabold text-black uppercase tracking-wider">${propiedad.agenteNombre}</span>
                            </div>
                            
                            <!-- Cápsulas flotantes de datos -->
                            <div class="absolute bottom-4 left-4 flex flex-wrap items-center gap-2 z-10 select-none">
                                <span class="px-3 py-1.5 bg-black/80 backdrop-blur-md text-white rounded-xl text-[11px] font-bold inline-flex items-center gap-1.5 shadow-md border border-white/10">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                                    </svg>
                                    2 fotos
                                </span>
                                <c:if test="${not empty propiedad.tour360Url}">
                                    <span class="px-3 py-1.5 bg-black/80 backdrop-blur-md text-white rounded-xl text-[11px] font-bold inline-flex items-center gap-1.5 shadow-md border border-white/10">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5 text-red-500 animate-pulse" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                                        </svg>
                                        360° Tour
                                    </span>
                                </c:if>
                                <span class="px-3 py-1.5 bg-black/80 backdrop-blur-md text-white rounded-xl text-[11px] font-bold inline-flex items-center gap-1.5 shadow-md border border-white/10">
                                    <svg class="w-3.5 h-3.5 text-white/80" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path></svg>
                                    ${propiedad.numeroVistas} vistas
                                </span>
                            </div>
                        </div>
                        
                        <!-- 1 Foto Secundaria (ocupa 1 de 4 columnas, altura completa) -->
                        <div class="hidden md:block col-span-1 relative overflow-hidden bg-slate-200 h-full">
                            <img src="${galeriaFotos.get(0).getRutaArchivoUrl(pageContext.request.contextPath)}" alt="Foto 1" class="w-full h-full object-cover cursor-pointer hover:scale-105 transition-transform duration-500 gallery-thumb" onclick="cambiarFotoPrincipal(this.src)">
                        </div>

                        <!-- Botón flotante para ver en grande -->
                        <button type="button" onclick="const hero = document.getElementById('heroImg'); if(hero) { const lightboxImg = document.getElementById('lightboxImg'); const lightbox = document.getElementById('lightbox'); if (lightboxImg && lightbox) { lightboxImg.src = hero.src; lightbox.classList.remove('hidden'); } }" class="absolute bottom-4 right-4 bg-white hover:bg-slate-100 text-black px-4 py-2.5 rounded-xl text-xs font-bold shadow-lg border border-slate-200 flex items-center gap-1.5 transition-all duration-300">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                            </svg>
                            Ver todas las fotos
                        </button>
                    </div>
                </c:when>

                <%-- Caso 2: Foto principal + 2 fotos secundarias --%>
                <c:when test="${cantFotosSecundarias == 2}">
                    <div class="grid grid-cols-1 md:grid-cols-4 gap-2 h-72 md:h-[28rem] rounded-2xl overflow-hidden relative group mb-8 shadow-lg border border-slate-100 bg-slate-100">
                        <!-- Foto Principal (ocupa 2 de 4 columnas) -->
                        <div class="col-span-1 md:col-span-2 relative overflow-hidden bg-slate-200 h-full">
                            <c:choose>
                                <c:when test="${not empty propiedad.fotoPrincipal}">
                                    <img id="heroImg" src="${propiedad.getFotoPrincipalUrl(pageContext.request.contextPath)}" alt="${propiedad.titulo}" class="w-full h-full object-cover cursor-pointer hover:scale-[1.02] transition-transform duration-500" onclick="const lightboxImg = document.getElementById('lightboxImg'); const lightbox = document.getElementById('lightbox'); if (lightboxImg && lightbox) { lightboxImg.src = this.src; lightbox.classList.remove('hidden'); }">
                                </c:when>
                                <c:otherwise>
                                    <img id="heroImg" src="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png" alt="${propiedad.titulo}" class="w-full h-full object-contain p-12 bg-slate-100 cursor-pointer">
                                </c:otherwise>
                            </c:choose>
                            
                            <!-- Badge de Marca / Anunciante -->
                            <div class="absolute top-4 left-4 bg-white/95 backdrop-blur px-3.5 py-2 rounded-xl flex items-center gap-2 shadow-md border border-slate-100 z-10 select-none">
                                <img src="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png" alt="Logo" class="h-4.5 w-auto object-contain">
                                <span class="text-[10px] font-extrabold text-black uppercase tracking-wider">${propiedad.agenteNombre}</span>
                            </div>
                            
                            <!-- Cápsulas flotantes de datos -->
                            <div class="absolute bottom-4 left-4 flex flex-wrap items-center gap-2 z-10 select-none">
                                <span class="px-3 py-1.5 bg-black/80 backdrop-blur-md text-white rounded-xl text-[11px] font-bold inline-flex items-center gap-1.5 shadow-md border border-white/10">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                                    </svg>
                                    3 fotos
                                </span>
                                <c:if test="${not empty propiedad.tour360Url}">
                                    <span class="px-3 py-1.5 bg-black/80 backdrop-blur-md text-white rounded-xl text-[11px] font-bold inline-flex items-center gap-1.5 shadow-md border border-white/10">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5 text-red-500 animate-pulse" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                                        </svg>
                                        360° Tour
                                    </span>
                                </c:if>
                                <span class="px-3 py-1.5 bg-black/80 backdrop-blur-md text-white rounded-xl text-[11px] font-bold inline-flex items-center gap-1.5 shadow-md border border-white/10">
                                    <svg class="w-3.5 h-3.5 text-white/80" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path></svg>
                                    ${propiedad.numeroVistas} vistas
                                </span>
                            </div>
                        </div>
                        
                        <!-- 2 Fotos Secundarias (ocupan 1 columna cada una, altura completa) -->
                        <div class="hidden md:block col-span-1 relative overflow-hidden bg-slate-200 h-full">
                            <img src="${galeriaFotos.get(0).getRutaArchivoUrl(pageContext.request.contextPath)}" alt="Foto 1" class="w-full h-full object-cover cursor-pointer hover:scale-105 transition-transform duration-500 gallery-thumb" onclick="cambiarFotoPrincipal(this.src)">
                        </div>
                        <div class="hidden md:block col-span-1 relative overflow-hidden bg-slate-200 h-full">
                            <img src="${galeriaFotos.get(1).getRutaArchivoUrl(pageContext.request.contextPath)}" alt="Foto 2" class="w-full h-full object-cover cursor-pointer hover:scale-105 transition-transform duration-500 gallery-thumb" onclick="cambiarFotoPrincipal(this.src)">
                        </div>

                        <!-- Botón flotante para ver en grande -->
                        <button type="button" onclick="const hero = document.getElementById('heroImg'); if(hero) { const lightboxImg = document.getElementById('lightboxImg'); const lightbox = document.getElementById('lightbox'); if (lightboxImg && lightbox) { lightboxImg.src = hero.src; lightbox.classList.remove('hidden'); } }" class="absolute bottom-4 right-4 bg-white hover:bg-slate-100 text-black px-4 py-2.5 rounded-xl text-xs font-bold shadow-lg border border-slate-200 flex items-center gap-1.5 transition-all duration-300">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                            </svg>
                            Ver todas las fotos
                        </button>
                    </div>
                </c:when>

                <%-- Caso 3: Foto principal + 3 fotos secundarias --%>
                <c:when test="${cantFotosSecundarias == 3}">
                    <div class="grid grid-cols-1 md:grid-cols-4 gap-2 h-72 md:h-[28rem] rounded-2xl overflow-hidden relative group mb-8 shadow-lg border border-slate-100 bg-slate-100">
                        <!-- Foto Principal (ocupa 2 de 4 columnas, altura completa) -->
                        <div class="col-span-1 md:col-span-2 relative overflow-hidden bg-slate-200 h-full">
                            <c:choose>
                                <c:when test="${not empty propiedad.fotoPrincipal}">
                                    <img id="heroImg" src="${propiedad.getFotoPrincipalUrl(pageContext.request.contextPath)}" alt="${propiedad.titulo}" class="w-full h-full object-cover cursor-pointer hover:scale-[1.02] transition-transform duration-500" onclick="const lightboxImg = document.getElementById('lightboxImg'); const lightbox = document.getElementById('lightbox'); if (lightboxImg && lightbox) { lightboxImg.src = this.src; lightbox.classList.remove('hidden'); }">
                                </c:when>
                                <c:otherwise>
                                    <img id="heroImg" src="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png" alt="${propiedad.titulo}" class="w-full h-full object-contain p-12 bg-slate-100 cursor-pointer">
                                </c:otherwise>
                            </c:choose>
                            
                            <!-- Badge de Marca / Anunciante -->
                            <div class="absolute top-4 left-4 bg-white/95 backdrop-blur px-3.5 py-2 rounded-xl flex items-center gap-2 shadow-md border border-slate-100 z-10 select-none">
                                <img src="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png" alt="Logo" class="h-4.5 w-auto object-contain">
                                <span class="text-[10px] font-extrabold text-black uppercase tracking-wider">${propiedad.agenteNombre}</span>
                            </div>
                            
                            <!-- Cápsulas flotantes de datos -->
                            <div class="absolute bottom-4 left-4 flex flex-wrap items-center gap-2 z-10 select-none">
                                <span class="px-3 py-1.5 bg-black/80 backdrop-blur-md text-white rounded-xl text-[11px] font-bold inline-flex items-center gap-1.5 shadow-md border border-white/10">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                                    </svg>
                                    4 fotos
                                </span>
                                <c:if test="${not empty propiedad.tour360Url}">
                                    <span class="px-3 py-1.5 bg-black/80 backdrop-blur-md text-white rounded-xl text-[11px] font-bold inline-flex items-center gap-1.5 shadow-md border border-white/10">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5 text-red-500 animate-pulse" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                                        </svg>
                                        360° Tour
                                    </span>
                                </c:if>
                                <span class="px-3 py-1.5 bg-black/80 backdrop-blur-md text-white rounded-xl text-[11px] font-bold inline-flex items-center gap-1.5 shadow-md border border-white/10">
                                    <svg class="w-3.5 h-3.5 text-white/80" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path></svg>
                                    ${propiedad.numeroVistas} vistas
                                </span>
                            </div>
                        </div>

                        <!-- Foto Secundaria 1 (ocupa 1 de 4 columnas, altura completa) -->
                        <div class="hidden md:block col-span-1 relative overflow-hidden bg-slate-200 h-full">
                            <img src="${galeriaFotos.get(0).getRutaArchivoUrl(pageContext.request.contextPath)}" alt="Foto 1" class="w-full h-full object-cover cursor-pointer hover:scale-105 transition-transform duration-500 gallery-thumb" onclick="cambiarFotoPrincipal(this.src)">
                        </div>

                        <!-- 2 Fotos Secundarias en la última columna (apiladas en 2 filas) -->
                        <div class="hidden md:grid col-span-1 grid-rows-2 gap-2 h-full">
                            <div class="relative overflow-hidden bg-slate-200 h-full">
                                <img src="${galeriaFotos.get(1).getRutaArchivoUrl(pageContext.request.contextPath)}" alt="Foto 2" class="w-full h-full object-cover cursor-pointer hover:scale-105 transition-transform duration-500 gallery-thumb" onclick="cambiarFotoPrincipal(this.src)">
                            </div>
                            <div class="relative overflow-hidden bg-slate-200 h-full">
                                <img src="${galeriaFotos.get(2).getRutaArchivoUrl(pageContext.request.contextPath)}" alt="Foto 3" class="w-full h-full object-cover cursor-pointer hover:scale-105 transition-transform duration-500 gallery-thumb" onclick="cambiarFotoPrincipal(this.src)">
                            </div>
                        </div>

                        <!-- Botón flotante para ver en grande -->
                        <button type="button" onclick="const hero = document.getElementById('heroImg'); if(hero) { const lightboxImg = document.getElementById('lightboxImg'); const lightbox = document.getElementById('lightbox'); if (lightboxImg && lightbox) { lightboxImg.src = hero.src; lightbox.classList.remove('hidden'); } }" class="absolute bottom-4 right-4 bg-white hover:bg-slate-100 text-black px-4 py-2.5 rounded-xl text-xs font-bold shadow-lg border border-slate-200 flex items-center gap-1.5 transition-all duration-300">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                            </svg>
                            Ver todas las fotos
                        </button>
                    </div>
                </c:when>

                <%-- Caso 4 o más fotos secundarias: Mosaico estándar de 5 fotos --%>
                <c:otherwise>
                    <div class="grid grid-cols-1 md:grid-cols-4 gap-2 h-72 md:h-[28rem] rounded-2xl overflow-hidden relative group mb-8 shadow-lg border border-slate-100 bg-slate-100">
                        <!-- Foto Principal (ocupa 2 columnas y 2 filas) -->
                        <div class="col-span-1 md:col-span-2 md:row-span-2 relative overflow-hidden bg-slate-200 h-full">
                            <c:choose>
                                <c:when test="${not empty propiedad.fotoPrincipal}">
                                    <img id="heroImg" src="${propiedad.getFotoPrincipalUrl(pageContext.request.contextPath)}" alt="${propiedad.titulo}" class="w-full h-full object-cover cursor-pointer hover:scale-[1.02] transition-transform duration-500" onclick="const lightboxImg = document.getElementById('lightboxImg'); const lightbox = document.getElementById('lightbox'); if (lightboxImg && lightbox) { lightboxImg.src = this.src; lightbox.classList.remove('hidden'); }">
                                </c:when>
                                <c:otherwise>
                                    <img id="heroImg" src="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png" alt="${propiedad.titulo}" class="w-full h-full object-contain p-12 bg-slate-100 cursor-pointer">
                                </c:otherwise>
                            </c:choose>
                            
                            <!-- Badge de Marca / Anunciante -->
                            <div class="absolute top-4 left-4 bg-white/95 backdrop-blur px-3.5 py-2 rounded-xl flex items-center gap-2 shadow-md border border-slate-100 z-10 select-none">
                                <img src="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png" alt="Logo" class="h-4.5 w-auto object-contain">
                                <span class="text-[10px] font-extrabold text-black uppercase tracking-wider">${propiedad.agenteNombre}</span>
                            </div>
                            
                            <!-- Cápsulas flotantes de datos -->
                            <div class="absolute bottom-4 left-4 flex flex-wrap items-center gap-2 z-10 select-none">
                                <span class="px-3 py-1.5 bg-black/80 backdrop-blur-md text-white rounded-xl text-[11px] font-bold inline-flex items-center gap-1.5 shadow-md border border-white/10">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                                    </svg>
                                    ${cantFotosSecundarias + 1} fotos
                                </span>
                                <c:if test="${not empty propiedad.tour360Url}">
                                    <span class="px-3 py-1.5 bg-black/80 backdrop-blur-md text-white rounded-xl text-[11px] font-bold inline-flex items-center gap-1.5 shadow-md border border-white/10">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5 text-red-500 animate-pulse" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                                        </svg>
                                        360° Tour
                                    </span>
                                </c:if>
                                <span class="px-3 py-1.5 bg-black/80 backdrop-blur-md text-white rounded-xl text-[11px] font-bold inline-flex items-center gap-1.5 shadow-md border border-white/10">
                                    <svg class="w-3.5 h-3.5 text-white/80" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path></svg>
                                    ${propiedad.numeroVistas} vistas
                                </span>
                            </div>
                        </div>

                        <!-- 4 Fotos Secundarias (Derecha, 2 cuadrículas x 2 filas) -->
                        <c:forEach begin="0" end="3" var="i">
                            <div class="hidden md:block col-span-1 row-span-1 relative overflow-hidden bg-slate-200 h-full">
                                <img src="${galeriaFotos.get(i).getRutaArchivoUrl(pageContext.request.contextPath)}" alt="Foto ${i+1}" class="w-full h-full object-cover cursor-pointer hover:scale-105 transition-transform duration-500 gallery-thumb" onclick="cambiarFotoPrincipal(this.src)">
                            </div>
                        </c:forEach>

                        <!-- Botón flotante para ver en grande -->
                        <button type="button" onclick="const hero = document.getElementById('heroImg'); if(hero) { const lightboxImg = document.getElementById('lightboxImg'); const lightbox = document.getElementById('lightbox'); if (lightboxImg && lightbox) { lightboxImg.src = hero.src; lightbox.classList.remove('hidden'); } }" class="absolute bottom-4 right-4 bg-white hover:bg-slate-100 text-black px-4 py-2.5 rounded-xl text-xs font-bold shadow-lg border border-slate-200 flex items-center gap-1.5 transition-all duration-300">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                            </svg>
                            Ver todas las fotos
                        </button>
                    </div>
                </c:otherwise>
            </c:choose>

            <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                <!-- Detalles Principales -->
                <div class="lg:col-span-2 space-y-6">
                    <!-- Ficha Resumen de la Propiedad (Título, Precio, Ubicación, Características Rápidas) -->
                    <div class="bg-white rounded-2xl p-8 shadow-xl border border-slate-100 space-y-6">
                        <div class="flex flex-wrap gap-2">
                            <span class="px-3.5 py-1 bg-black text-white rounded-md text-xs font-extrabold tracking-wide uppercase select-none">${propiedad.operacion}</span>
                            <span class="px-3.5 py-1 bg-slate-100 text-slate-800 rounded-md text-xs font-extrabold tracking-wide uppercase select-none">${propiedad.tipoInmueble}</span>
                            <c:if test="${propiedad.bonoMiVivienda == 1}">
                                <span class="px-3.5 py-1 bg-emerald-50 text-emerald-800 rounded-md text-xs font-extrabold tracking-wide uppercase select-none">Bono MiVivienda</span>
                            </c:if>
                            <c:if test="${propiedad.bonoVerde == 1}">
                                <span class="px-3.5 py-1 bg-teal-50 text-teal-800 rounded-md text-xs font-extrabold tracking-wide uppercase select-none">Bono Verde</span>
                            </c:if>
                        </div>
                        
                        <h1 class="text-3xl md:text-4xl font-black text-slate-900 tracking-tight leading-tight"><c:out value="${propiedad.titulo}" /></h1>
                        
                        <!-- Bloque de Precio bimonetario con tipo de cambio -->
                        <div class="flex flex-col">
                            <div class="flex items-baseline gap-3.5 flex-wrap">
                                <span class="text-3xl md:text-4xl font-black text-black tracking-tight">US$ ${propiedad.precioUsd}</span>
                                <span class="text-2xl font-medium text-slate-300">/</span>
                                <span class="text-2xl md:text-3xl font-extrabold text-slate-650 tracking-tight">S/. ${propiedad.precioPen}</span>
                            </div>
                            <c:if test="${propiedad.tipoCambioVenta != null}">
                                <span class="text-[10px] font-bold uppercase tracking-wider text-slate-400 mt-1.5">Tipo de cambio referencial: S/. ${propiedad.tipoCambioVenta} por USD (fuente SBS)</span>
                            </c:if>
                        </div>

                        <!-- Ubicación -->
                        <p class="text-slate-600 flex items-center gap-2 text-base">
                            <svg class="w-5 h-5 text-slate-400 shrink-0 inline" fill="none" stroke="currentColor" stroke-width="2.2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"></path><path stroke-linecap="round" stroke-linejoin="round" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                            <span><c:out value="${propiedad.direccion}" />, <c:out value="${propiedad.distrito}" />, <c:out value="${propiedad.provincia}" /></span>
                        </p>

                        <!-- Barra de Características Rápidas (Estilo Urbania) -->
                        <div class="flex flex-wrap gap-x-8 gap-y-4 py-5 border-t border-slate-150 text-slate-700">
                            <!-- Area Total -->
                            <div class="flex items-center gap-2">
                                <svg class="w-5 h-5 text-slate-400 shrink-0" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M4 8V4m0 0h4M4 4l5 5m11-1V4m0 0h-4m4 0l-5 5M4 16v4m0 0h4m-4 0l5-5m11 5l-5-5m5 5v-4m0 4h-4"></path></svg>
                                <span class="text-sm font-bold text-slate-900">${propiedad.areaTotalM2} m² <span class="text-slate-500 font-normal">tot.</span></span>
                            </div>
                            <!-- Area Techada -->
                            <c:if test="${propiedad.areaTechadaM2 != null}">
                                <div class="flex items-center gap-2">
                                    <svg class="w-5 h-5 text-slate-400 shrink-0" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M4 8V4m0 0h4M4 4l5 5m11-1V4m0 0h-4m4 0l-5 5M4 16v4m0 0h4m-4 0l5-5m11 5l-5-5m5 5v-4m0 4h-4"></path></svg>
                                    <span class="text-sm font-bold text-slate-900">${propiedad.areaTechadaM2} m² <span class="text-slate-500 font-normal">tech.</span></span>
                                </div>
                            </c:if>
                            <!-- Dormitorios -->
                            <div class="flex items-center gap-2">
                                <svg class="w-5 h-5 text-slate-400 shrink-0" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>
                                <span class="text-sm font-bold text-slate-900">${propiedad.numDormitorios} <span class="text-slate-500 font-normal">dorm.</span></span>
                            </div>
                            <!-- Baños -->
                            <div class="flex items-center gap-2">
                                <svg class="w-5 h-5 text-slate-400 shrink-0" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"></path></svg>
                                <span class="text-sm font-bold text-slate-900">${propiedad.numBanos} <span class="text-slate-500 font-normal">baños</span></span>
                            </div>
                            <!-- Cocheras -->
                            <c:if test="${propiedad.numCocheras > 0}">
                                <div class="flex items-center gap-2">
                                    <svg class="w-5 h-5 text-slate-400 shrink-0" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M8 17a5 5 0 0110 0m-10 0a5 5 0 0010 0m-10 0V9a2 2 0 114 0v8m4 0V9a2 2 0 00-4 0v8m-12 0h20"></path></svg>
                                    <span class="text-sm font-bold text-slate-900">${propiedad.numCocheras} <span class="text-slate-500 font-normal">coch.</span></span>
                                </div>
                            </c:if>
                            <!-- Pisos -->
                            <c:if test="${propiedad.numPisos > 0}">
                                <div class="flex items-center gap-2">
                                    <svg class="w-5 h-5 text-slate-400 shrink-0" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0V5a2 2 0 00-2-2h-5m-9 0v16"></path></svg>
                                    <span class="text-sm font-bold text-slate-900">${propiedad.numPisos} <span class="text-slate-500 font-normal">pisos</span></span>
                                </div>
                            </c:if>
                        </div>
                        
                        <!-- Tour 360 Virtual Banner -->
                        <c:if test="${not empty propiedad.tour360Url}">
                            <div class="mt-6 p-6 bg-black text-white rounded-2xl flex flex-col md:flex-row justify-between items-center gap-4 shadow-xl border border-white/10 hover:border-white/20 transition-all duration-300">
                                <div class="space-y-1 text-center md:text-left">
                                    <div class="flex items-center gap-2 justify-center md:justify-start">
                                        <span class="flex h-2.5 w-2.5 relative">
                                            <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-red-400 opacity-75"></span>
                                            <span class="relative inline-flex rounded-full h-2.5 w-2.5 bg-red-500"></span>
                                        </span>
                                        <h4 class="font-extrabold text-white tracking-wide uppercase text-xs">Recorrido Virtual Disponible</h4>
                                    </div>
                                    <p class="text-sm text-slate-300">Explora esta propiedad en 3D interactivo desde la comodidad de tu hogar.</p>
                                </div>
                                <a href="${propiedad.tour360Url}" target="_blank" rel="noopener noreferrer" class="bg-white hover:bg-slate-200 text-black px-6 py-3 rounded-xl text-sm font-bold shadow-md flex items-center gap-2 shrink-0 transition-all duration-300 hover:scale-105">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-black" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                                    </svg>
                                    Iniciar Tour 360°
                                </a>
                            </div>
                        </c:if>
                    </div>

                    <!-- Galería de Información (Diseño de Cuadros en Rejilla) -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        
                        <!-- Tarjeta 1: Descripción -->
                        <div class="bg-white rounded-2xl p-6 shadow-xl border border-slate-100 flex flex-col">
                            <h2 class="text-xl font-bold text-slate-900 mb-4 flex items-center gap-2">
                                <svg class="w-5 h-5 text-black" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h7"></path></svg>
                                Descripción
                            </h2>
                            <div class="text-slate-600 text-sm leading-relaxed whitespace-pre-wrap flex-grow"><c:out value="${propiedad.descripcion}" /></div>
                        </div>

                        <!-- Tarjeta 2: Características -->
                        <div class="bg-white rounded-2xl p-6 shadow-xl border border-slate-100 flex flex-col">
                            <h2 class="text-xl font-bold text-slate-900 mb-4 flex items-center gap-2">
                                <svg class="w-5 h-5 text-black" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"></path></svg>
                                Características
                            </h2>
                            <div class="grid grid-cols-2 gap-3 flex-grow">
                                <!-- Área Total -->
                                <div class="p-3 bg-slate-50 rounded-xl flex items-center gap-2.5 border border-slate-100 hover:bg-slate-100/50 transition-colors">
                                    <span class="p-2 bg-black text-white rounded-lg shrink-0"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 8V4m0 0h4M4 4l5 5m11-1V4m0 0h-4m4 0l-5 5M4 16v4m0 0h4m-4 0l5-5m11 5l-5-5m5 5v-4m0 4h-4"></path></svg></span>
                                    <div>
                                        <div class="font-extrabold text-slate-900 text-sm">${propiedad.areaTotalM2} m²</div>
                                        <div class="text-[10px] text-slate-500 font-bold uppercase tracking-wider">Área Total</div>
                                    </div>
                                </div>
                                <!-- Área Techada -->
                                <div class="p-3 bg-slate-50 rounded-xl flex items-center gap-2.5 border border-slate-100 hover:bg-slate-100/50 transition-colors">
                                    <span class="p-2 bg-black text-white rounded-lg shrink-0"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 8V4m0 0h4M4 4l5 5m11-1V4m0 0h-4m4 0l-5 5M4 16v4m0 0h4m-4 0l5-5m11 5l-5-5m5 5v-4m0 4h-4"></path></svg></span>
                                    <div>
                                        <div class="font-extrabold text-slate-900 text-sm">${propiedad.areaTechadaM2 != null ? propiedad.areaTechadaM2 : '0'} m²</div>
                                        <div class="text-[10px] text-slate-500 font-bold uppercase tracking-wider">Área Techada</div>
                                    </div>
                                </div>
                                <!-- Dormitorios -->
                                <div class="p-3 bg-slate-50 rounded-xl flex items-center gap-2.5 border border-slate-100 hover:bg-slate-100/50 transition-colors">
                                    <span class="p-2 bg-black text-white rounded-lg shrink-0"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg></span>
                                    <div>
                                        <div class="font-extrabold text-slate-900 text-sm">${propiedad.numDormitorios}</div>
                                        <div class="text-[10px] text-slate-500 font-bold uppercase tracking-wider">Dormitorios</div>
                                    </div>
                                </div>
                                <!-- Baños -->
                                <div class="p-3 bg-slate-50 rounded-xl flex items-center gap-2.5 border border-slate-100 hover:bg-slate-100/50 transition-colors">
                                    <span class="p-2 bg-black text-white rounded-lg shrink-0"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"></path></svg></span>
                                    <div>
                                        <div class="font-extrabold text-slate-900 text-sm">${propiedad.numBanos}</div>
                                        <div class="text-[10px] text-slate-500 font-bold uppercase tracking-wider">Baños</div>
                                    </div>
                                </div>
                                <!-- Cocheras -->
                                <div class="p-3 bg-slate-50 rounded-xl flex items-center gap-2.5 border border-slate-100 hover:bg-slate-100/50 transition-colors">
                                    <span class="p-2 bg-black text-white rounded-lg shrink-0"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 17a5 5 0 0110 0m-10 0a5 5 0 0010 0m-10 0V9a2 2 0 114 0v8m4 0V9a2 2 0 00-4 0v8m-12 0h20"></path></svg></span>
                                    <div>
                                        <div class="font-extrabold text-slate-900 text-sm">${propiedad.numCocheras}</div>
                                        <div class="text-[10px] text-slate-500 font-bold uppercase tracking-wider">Cocheras</div>
                                    </div>
                                </div>
                                <!-- Pisos -->
                                <div class="p-3 bg-slate-50 rounded-xl flex items-center gap-2.5 border border-slate-100 hover:bg-slate-100/50 transition-colors">
                                    <span class="p-2 bg-black text-white rounded-lg shrink-0"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0V5a2 2 0 00-2-2h-5m-9 0v16"></path></svg></span>
                                    <div>
                                        <div class="font-extrabold text-slate-900 text-sm">${propiedad.numPisos != null ? propiedad.numPisos : '1'}</div>
                                        <div class="text-[10px] text-slate-500 font-bold uppercase tracking-wider">N° Pisos</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Tarjeta 3: Información Adicional -->
                        <div class="bg-white rounded-2xl p-6 shadow-xl border border-slate-100 flex flex-col justify-between">
                            <h2 class="text-xl font-bold text-slate-900 mb-4 flex items-center gap-2">
                                <svg class="w-5 h-5 text-black" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path></svg>
                                Detalles de la Propiedad
                            </h2>
                            <div class="space-y-4 text-sm flex-grow flex flex-col justify-center">
                                <c:if test="${not empty propiedad.partidaRegistral}">
                                    <div class="flex justify-between items-center py-2.5 border-b border-slate-100">
                                        <span class="text-slate-500 font-bold uppercase tracking-tight text-xs">Partida SUNARP</span>
                                        <span class="font-mono text-slate-900 font-bold text-sm bg-slate-100 px-2.5 py-1 rounded-md border border-slate-200">${propiedad.partidaRegistral}</span>
                                    </div>
                                </c:if>
                                <c:if test="${not empty propiedad.referencia}">
                                    <div class="flex justify-between items-start py-2.5 border-b border-slate-100 gap-4">
                                        <span class="text-slate-500 font-bold uppercase tracking-tight text-xs shrink-0 mt-0.5">Referencia</span>
                                        <span class="text-slate-700 text-right text-xs font-semibold leading-relaxed">${propiedad.referencia}</span>
                                    </div>
                                </c:if>
                                <c:if test="${not empty propiedad.fechaPublicacion}">
                                    <div class="flex justify-between items-center py-2.5 border-b border-slate-100">
                                        <span class="text-slate-500 font-bold uppercase tracking-tight text-xs">Publicado</span>
                                        <span class="text-slate-700 font-semibold text-xs">${propiedad.fechaPublicacion}</span>
                                    </div>
                                </c:if>
                                <c:if test="${not empty propiedad.fechaExpiracion}">
                                    <div class="flex justify-between items-center py-2.5">
                                        <span class="text-slate-500 font-bold uppercase tracking-tight text-xs">Expiración</span>
                                        <span class="text-slate-700 font-semibold text-xs">${propiedad.fechaExpiracion}</span>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <!-- Tarjeta 4: Ubicación (Map) -->
                        <div class="bg-white rounded-2xl p-6 shadow-xl border border-slate-100 flex flex-col">
                            <h2 class="text-xl font-bold text-slate-900 mb-2 flex items-center gap-2">
                                <svg class="w-5 h-5 text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                                Mapa de Ubicación
                            </h2>
                            <p class="text-slate-500 mb-3 text-[11px] font-semibold truncate">
                                ${propiedad.direccion}, ${propiedad.distrito}, ${propiedad.provincia}
                            </p>
                            <div id="map" class="w-full h-48 rounded-xl border border-slate-200 z-0 flex-grow" data-lat="${propiedad.latitud != null ? propiedad.latitud : -12.046374}" data-lng="${propiedad.longitud != null ? propiedad.longitud : -77.042793}" data-zoom="${propiedad.latitud != null ? 15 : 13}" data-titulo="<c:out value='${propiedad.titulo}'/>" data-distrito="<c:out value='${propiedad.distrito}'/>"></div>
                        </div>

                    </div>
                </div>

                <!-- Barra Lateral -->
                <div class="space-y-6">
                    <!-- Tarjeta Sticky de Contacto Unificada (Estilo Anunciante Anuncios Premium) -->
                    <div class="bg-white rounded-2xl p-6 shadow-xl border border-slate-200/80 sticky top-28 space-y-4">
                        <!-- Cabecera del Agente -->
                        <div class="flex items-center gap-3 pb-3 border-b border-slate-100 select-none">
                            <div class="w-12 h-12 bg-black text-white rounded-full flex items-center justify-center font-black text-base uppercase shrink-0">
                                ${propiedad.agenteNombre.substring(0,2)}
                            </div>
                            <div>
                                <h4 class="font-extrabold text-slate-800 text-sm leading-tight">${propiedad.agenteNombre}</h4>
                                <span class="text-[10px] text-slate-400 font-bold uppercase tracking-wider">Agente Anmobiliario</span>
                            </div>
                        </div>

                        <!-- Subtítulo de Contacto -->
                        <div class="text-sm font-extrabold text-slate-900 tracking-tight leading-tight select-none">
                            Contáctate con el anunciante por esta propiedad
                        </div>

                        <!-- Notificaciones de consulta -->
                        <c:if test="${param.consultaEnviada == 'true'}">
                            <div class="bg-emerald-50 border-l-4 border-emerald-500 p-3 rounded-r-xl text-xs text-emerald-800 font-bold">
                                Consulta enviada exitosamente.
                            </div>
                        </c:if>
                        <c:if test="${param.errorConsulta == 'true'}">
                            <div class="bg-red-50 border-l-4 border-red-500 p-3 rounded-r-xl text-xs text-red-800 font-bold">
                                Ocurrió un error al enviar la consulta. Inténtalo de nuevo.
                            </div>
                        </c:if>

                        <!-- Formulario de Consulta Directo (Siempre Visible) -->
                        <form id="contactForm" action="${pageContext.request.contextPath}/consulta" method="post" class="space-y-3">
                            <input type="hidden" name="idPropiedad" value="${propiedad.id}">
                            
                            <!-- Email -->
                            <div class="relative border border-slate-200 focus-within:border-black rounded-xl p-3 bg-slate-50/20 transition-all">
                                <label class="block text-[9px] font-bold text-slate-400 uppercase tracking-wider select-none">Email</label>
                                <input type="email" name="email" required class="w-full bg-transparent text-sm text-slate-900 focus:outline-none border-none p-0 mt-0.5" value="${sessionScope.usuarioLogueado != null ? sessionScope.usuarioLogueado.correo : ''}">
                            </div>

                            <!-- Nombre y Teléfono (2 columnas) -->
                            <div class="grid grid-cols-2 gap-3">
                                <div class="relative border border-slate-200 focus-within:border-black rounded-xl p-3 bg-slate-50/20 transition-all">
                                    <label class="block text-[9px] font-bold text-slate-400 uppercase tracking-wider select-none">Nombre</label>
                                    <input type="text" name="nombre" required class="w-full bg-transparent text-sm text-slate-900 focus:outline-none border-none p-0 mt-0.5" value="${sessionScope.usuarioLogueado != null ? sessionScope.usuarioLogueado.nombres : ''}">
                                </div>
                                <div class="relative border border-slate-200 focus-within:border-black rounded-xl p-3 bg-slate-50/20 transition-all">
                                    <label class="block text-[9px] font-bold text-slate-400 uppercase tracking-wider select-none">Teléfono</label>
                                    <input type="tel" name="telefono" class="w-full bg-transparent text-sm text-slate-900 focus:outline-none border-none p-0 mt-0.5">
                                </div>
                            </div>

                            <!-- Mensaje -->
                            <div class="relative border border-slate-200 focus-within:border-black rounded-xl p-3 bg-slate-50/20 transition-all">
                                <label class="block text-[9px] font-bold text-slate-400 uppercase tracking-wider select-none">Mensaje</label>
                                <textarea name="mensaje" required rows="3" class="w-full bg-transparent text-sm text-slate-900 focus:outline-none border-none p-0 mt-0.5 resize-none">¡Hola! Estoy interesado en la propiedad "${propiedad.titulo}" y me gustaría recibir más información. Por favor, contáctenme.</textarea>
                            </div>

                            <!-- Botón de Envío -->
                            <button type="submit" class="w-full bg-black hover:bg-zinc-800 text-white font-extrabold py-3.5 rounded-xl shadow-md transition-all text-xs uppercase tracking-wider">
                                Enviar Consulta
                            </button>
                        </form>

                        <!-- Botón Directo WhatsApp -->
                        <div class="border-t border-slate-100 pt-3 space-y-2">
                            <button type="button" onclick="document.getElementById('waModal').classList.remove('hidden')" class="w-full border border-slate-200 hover:border-black text-slate-800 font-extrabold py-3 rounded-xl flex justify-center items-center gap-2 transition-all text-xs uppercase tracking-wider focus:outline-none">
                                <svg class="w-4 h-4 text-emerald-500 fill-current" viewBox="0 0 24 24">
                                    <path d="M12.031 6.172c-3.181 0-5.767 2.586-5.767 5.767 0 1.012.261 2.001.763 2.87l-.811 2.96 3.028-.794c.839.457 1.776.697 2.729.697 3.181 0 5.767-2.586 5.767-5.767 0-3.181-2.586-5.767-5.767-5.767zm3.39 8.161c-.146.411-.75.763-1.037.81-.27.043-.618.069-1.01-.061a5.05 5.05 0 01-2.181-1.341 5.56 5.56 0 01-1.468-1.921 2.39 2.39 0 01-.107-.94c.101-.527.42-.77.561-.914.137-.146.3-.186.4-.186h.257c.081 0 .182-.03.284.213.102.242.348.847.379.914.03.065.051.141.01.223-.04.081-.061.131-.121.202-.06.071-.126.157-.182.213-.061.061-.126.126-.05.257.076.131.338.557.724.901.496.442.914.581 1.046.642.131.061.207.051.284-.04.076-.091.328-.385.415-.517.086-.131.171-.111.288-.065.116.046.733.348.86.411.127.065.213.096.244.152.03.056.03.324-.116.735z"></path>
                                </svg>
                                Contactar por WhatsApp
                            </button>
                        </div>
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
                <button onclick="document.getElementById('waModal').classList.add('hidden')" class="flex-1 border border-slate-300 hover:border-black text-slate-700 hover:text-black bg-transparent hover:bg-black/5 py-3 rounded-xl font-bold transition-all duration-300">Cancelar</button>
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

    <!-- Footer -->
    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<!-- Leaflet JS -->
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/detalle_propiedad.js" defer></script>

</body>
</html>
