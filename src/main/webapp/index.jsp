<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page import="org.example.proyectoweb.facade.PropiedadFacade" %>
<%@ page import="org.example.proyectoweb.dto.PropiedadDTO" %>
<%@ page import="java.util.List" %>
<%
    try {
        PropiedadFacade facade = new PropiedadFacade();
        List<PropiedadDTO> destacadas = facade.obtenerPropiedadesDestacadas(3);
        request.setAttribute("destacadas", destacadas);
        request.setAttribute("listaDistritos", facade.obtenerDistritos());
        request.setAttribute("listaTipos", facade.obtenerTiposInmueble());
    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("destacadas", new java.util.ArrayList<PropiedadDTO>());
        request.setAttribute("listaDistritos", new java.util.ArrayList());
        request.setAttribute("listaTipos", new java.util.ArrayList());
    }
%>
<!DOCTYPE html>
    <html lang="es" class="scroll-smooth">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png">
        <title>Inmobix - Portal Inmobiliario</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/estilosadic.css">
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


        <script src="${pageContext.request.contextPath}/assets/js/main.js" defer></script>
    </head>

    <body class="bg-brandBg text-brandText flex flex-col min-h-screen font-body">

        <!-- Navbar Premium con Glassmorphism -->
            <c:set var="activePage" value="inicio" scope="request" />
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

        <!-- Hero Section -->
        <main class="flex-grow pt-20">
            <div class="relative min-h-[80vh] flex items-center justify-center overflow-hidden">
                <!-- Background Image -->
                <div class="absolute inset-0 z-0">
                    <!-- Imagen de Header-->
                    <img src="https://www.ciudaris.com/blog/wp-content/uploads/elegir-mejor-inmobiliaria-peru-ciudaris.jpg"
                        alt="Hero Background" class="w-full h-full object-cover" />
                    <div class="absolute inset-0 bg-gradient-to-r from-black/85 via-black/50 to-transparent">
                    </div>
                </div>

                <div class="relative z-10 w-full max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex flex-col items-start text-left gap-10">
                    <div class="max-w-2xl">
                        <span class="px-4 py-1.5 rounded-full bg-white/10 border border-white/20 text-white text-xs font-semibold tracking-wide mb-6 backdrop-blur-sm inline-block">Encuentra tu próximo hogar</span>
                        <h1 class="font-title text-3xl sm:text-4xl md:text-6xl lg:text-7xl font-light text-white leading-tight mb-6 tracking-tight">
                            El lugar perfecto <br /> <span id="typed-text" class="typing-cursor italic text-zinc-300"></span>
                        </h1>
                        <p class="text-lg md:text-xl text-slate-300 max-w-lg leading-relaxed">
                            Descubre propiedades exclusivas en las mejores zonas del Perú. Comprar, alquilar o vender nunca fue tan fácil y seguro.
                        </p>
                    </div>

                    <!-- Buscador Inteligente Premium -->
                    <div class="w-full max-w-4xl bg-black/45 backdrop-blur-md border border-white/15 rounded-3xl p-6 shadow-2xl transition-all hover:border-white/25">
                        <form action="${pageContext.request.contextPath}/propiedades" method="get" class="flex flex-col gap-4">
                            <!-- Pestañas Compra / Alquiler -->
                            <div class="flex items-center gap-2 border-b border-white/10 pb-4">
                                <input type="hidden" name="operacion" id="search-operacion" value="VENTA" />
                                <button type="button" onclick="setSearchOperacion('VENTA')" id="btn-tab-venta" class="px-6 py-2 rounded-full text-xs font-bold bg-white text-black shadow-md transition-all duration-300 hover:scale-105">Comprar</button>
                                <button type="button" onclick="setSearchOperacion('ALQUILER')" id="btn-tab-alquiler" class="px-6 py-2 rounded-full text-xs font-bold text-white/80 hover:text-white hover:bg-white/10 transition-all duration-300 hover:scale-105">Alquilar</button>
                            </div>

                            <!-- Columnas del Buscador -->
                            <div class="grid grid-cols-1 md:grid-cols-12 gap-4 items-end">
                                <!-- Ubicación / Distrito -->
                                <div class="md:col-span-6 relative">
                                    <label class="block text-[10px] font-black text-zinc-300 uppercase tracking-widest mb-1.5">¿Dónde deseas buscar?</label>
                                    <div class="relative">
                                        <div class="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-zinc-400">
                                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                                        </div>
                                        <input type="text" name="q" id="search-keyword" autocomplete="off" placeholder="Escribe el distrito o provincia..." class="w-full bg-white/10 border border-white/10 text-white rounded-xl pl-10 pr-4 py-3.5 text-sm focus:outline-none focus:border-white/35 focus:bg-white/15 transition-all" />
                                        <!-- Sugerencias Inteligentes -->
                                        <div id="suggestions-box" class="hidden absolute left-0 right-0 top-full mt-2 bg-zinc-950/95 border border-white/15 rounded-2xl shadow-2xl overflow-hidden max-h-60 overflow-y-auto z-50 backdrop-blur-lg">
                                            <!-- Cargado vía JS -->
                                        </div>
                                    </div>
                                </div>

                                <!-- Tipo de Propiedad -->
                                <div class="md:col-span-4">
                                    <label class="block text-[10px] font-black text-zinc-300 uppercase tracking-widest mb-1.5">Tipo de Inmueble</label>
                                    <div class="relative">
                                        <select name="tipo" class="w-full bg-white/10 border border-white/10 text-white rounded-xl px-4 py-3.5 text-sm focus:outline-none focus:border-white/35 transition-all appearance-none cursor-pointer">
                                            <option value="" class="bg-zinc-900 text-white">Todos los tipos</option>
                                            <c:forEach var="t" items="${listaTipos}">
                                                <option value="${t.nombre}" class="bg-zinc-900 text-white">${t.nombre}</option>
                                            </c:forEach>
                                        </select>
                                        <div class="absolute inset-y-0 right-0 pr-3.5 flex items-center pointer-events-none text-zinc-400">
                                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path></svg>
                                        </div>
                                    </div>
                                </div>

                                <!-- Botón Buscar -->
                                <div class="md:col-span-2">
                                    <button type="submit" class="w-full bg-white hover:bg-zinc-200 text-black font-black py-3.5 rounded-xl text-sm transition-all hover:scale-105 flex items-center justify-center gap-2 shadow-lg shadow-white/5">
                                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
                                        Buscar
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Propiedades Destacadas (Carga Dinámica) -->
            <section class="reveal max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-24">
                <div class="flex flex-col md:flex-row md:items-end justify-between mb-12">
                    <div>
                        <span class="text-xs font-bold uppercase tracking-widest text-slate-400 block mb-2">Exclusividad</span>
                        <h2 class="font-title text-3xl md:text-4xl lg:text-5xl font-light tracking-tight text-slate-900">Propiedades Destacadas</h2>
                    </div>
                    <a href="${pageContext.request.contextPath}/propiedades" class="text-sm font-bold text-black border-b-2 border-black pb-1 hover:text-slate-500 hover:border-slate-500 transition-all mt-4 md:mt-0 flex items-center gap-1">
                        Ver todo el catálogo
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3"></path></svg>
                    </a>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-3 gap-8 reveal-stagger">
                    <c:forEach var="p" items="${destacadas}">
                        <div class="bg-white border border-slate-200 rounded-3xl overflow-hidden shadow-sm hover:shadow-xl transition-all duration-300 flex flex-col group">
                            <!-- Image -->
                            <div class="relative h-64 overflow-hidden bg-slate-100">
                                <c:choose>
                                    <c:when test="${not empty p.fotoPrincipal}">
                                        <img src="${p.getFotoPrincipalUrl(pageContext.request.contextPath)}" alt="${p.titulo}" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="w-full h-full flex items-center justify-center text-slate-300">
                                            <svg class="w-16 h-16" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path>
                                            </svg>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                <!-- Badges overlay -->
                                <div class="absolute top-4 left-4 flex flex-col gap-2">
                                    <span class="bg-black text-white text-[10px] font-black uppercase tracking-widest px-3 py-1.5 rounded-full shadow-md">${p.operacion}</span>
                                    <c:if test="${p.bonoVerde == 1}">
                                        <span class="bg-emerald-500 text-white text-[9px] font-extrabold uppercase tracking-wider px-2.5 py-1 rounded-full shadow-md">Bono Verde</span>
                                    </c:if>
                                </div>
                            </div>

                            <!-- Details -->
                            <div class="p-6 flex-grow flex flex-col justify-between">
                                <div>
                                    <span class="text-xs text-slate-400 block font-semibold mb-1">${p.distrito}, ${p.provincia}</span>
                                    <h3 class="font-title text-lg font-medium text-slate-800 line-clamp-1 mb-2 group-hover:text-black transition-colors">${p.titulo}</h3>
                                    <p class="text-xs text-slate-500 line-clamp-2 mb-4 leading-relaxed">${p.descripcion}</p>
                                </div>

                                <div class="mt-4">
                                    <div class="flex items-center justify-between border-t border-slate-100 pt-4 mb-4 text-xs text-slate-500 font-semibold">
                                        <span class="inline-flex items-center gap-1">
                                            <svg class="w-4 h-4 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>
                                            ${p.numDormitorios} Dorm.
                                        </span>
                                        <span class="inline-flex items-center gap-1">
                                            <svg class="w-4 h-4 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 14v3m4-3v3m4-3v3M3 21h18M3 10h18M3 7l9-4 9 4M4 10h16v11H4V10z"></path></svg>
                                            ${p.numBanos} Baños
                                        </span>
                                        <span class="inline-flex items-center gap-1">
                                            <svg class="w-4 h-4 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 8V4m0 0h4M4 4l5 5m11-1V4m0 0h-4m4 0l-5 5M4 16v4m0 0h4m-4 0l5-5m11 5v-4m0 4h-4m4 0l-5-5"></path></svg>
                                            ${p.areaTotalM2} m²
                                        </span>
                                    </div>

                                    <div class="flex items-center justify-between">
                                        <div>
                                            <span class="text-xs text-slate-400 block font-medium">Precio</span>
                                            <span class="text-lg font-black text-black">
                                                <c:choose>
                                                    <c:when test="${p.monedaBase == 'USD'}">US$ ${p.precioUsd}</c:when>
                                                    <c:otherwise>S/. ${p.precioPen}</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/propiedades?accion=ver&id=${p.id}" class="bg-black hover:bg-zinc-800 text-white text-xs font-bold px-4 py-2.5 rounded-full transition-all">Ver Ficha</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                    <!-- Fallback si no hay propiedades registradas aún -->
                    <c:if test="${empty destacadas}">
                        <div class="col-span-3 border border-dashed border-slate-300 rounded-3xl p-16 text-center text-slate-500">
                            <svg class="w-12 h-12 text-slate-300 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"></path>
                            </svg>
                            <p class="font-bold">No hay propiedades disponibles en este momento.</p>
                            <p class="text-xs mt-1">Crea una cuenta de agente y publica tu primera propiedad para verla en la página principal.</p>
                        </div>
                    </c:if>
                </div>
            </section>

            <!-- Propuesta de Valor -->
            <section class="reveal bg-zinc-50 border-y border-slate-200/60 py-24">
                <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
                    <span class="text-xs font-bold uppercase tracking-widest text-slate-400 block mb-3">Valor</span>
                    <h2 class="font-title text-3xl md:text-4xl lg:text-5xl font-light tracking-tight text-slate-900 mb-4">¿Por qué confiar en Inmobix?</h2>
                    <p class="text-slate-500 max-w-xl mx-auto mb-16 text-sm">Ofrecemos una plataforma robusta y transparente tanto para compradores exigentes como para agentes inmobiliarios independientes.</p>

                    <div class="grid grid-cols-1 md:grid-cols-3 gap-12 reveal-stagger">
                        <div class="space-y-4 flex flex-col items-center">
                            <div class="w-16 h-16 rounded-full bg-white border border-slate-200 flex items-center justify-center text-black shadow-sm mb-2">
                                <svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"></path></svg>
                            </div>
                            <h3 class="font-title text-xl font-medium text-slate-800">Seguridad Garantizada</h3>
                            <p class="text-xs text-slate-500 max-w-xs leading-relaxed">Verificamos las partidas registrales de cada propiedad mediante la SUNARP, asegurando la validez jurídica de la información.</p>
                        </div>

                        <div class="space-y-4 flex flex-col items-center">
                            <div class="w-16 h-16 rounded-full bg-white border border-slate-200 flex items-center justify-center text-black shadow-sm mb-2">
                                <svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path></svg>
                            </div>
                            <h3 class="font-title text-xl font-medium text-slate-800">Rapidez y Fluidez</h3>
                            <p class="text-xs text-slate-500 max-w-xs leading-relaxed">Filtros de búsqueda avanzada responsivos y un comparador dinámico para encontrar la propiedad ideal en pocos clics.</p>
                        </div>

                        <div class="space-y-4 flex flex-col items-center">
                            <div class="w-16 h-16 rounded-full bg-white border border-slate-200 flex items-center justify-center text-black shadow-sm mb-2">
                                <svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8h2a2 2 0 012 2v6a2 2 0 01-2 2h-2v4l-4-4H9a1.994 1.994 0 01-1.414-.586m0 0L11 14h4a2 2 0 002-2V6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2v4l.586-.586z"></path></svg>
                            </div>
                            <h3 class="font-title text-xl font-medium text-slate-800">Contacto Directo</h3>
                            <p class="text-xs text-slate-500 max-w-xs leading-relaxed">Sin intermediarios opacos. Comunícate directamente por correo o mensajería de WhatsApp con el agente responsable.</p>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Estadísticas -->
            <section id="stats-section" class="reveal max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20 text-center">
                <div class="grid grid-cols-2 md:grid-cols-4 gap-8">
                    <div class="border-r border-slate-200 last:border-0 p-4">
                        <span class="stat-counter text-4xl md:text-5xl font-black text-black block mb-2" data-target="1500" data-suffix="+">0+</span>
                        <span class="text-xs font-bold text-slate-400 uppercase tracking-wider">Inmuebles Activos</span>
                    </div>
                    <div class="border-r border-slate-200 last:border-0 p-4">
                        <span class="stat-counter text-4xl md:text-5xl font-black text-black block mb-2" data-target="80" data-suffix="+">0+</span>
                        <span class="text-xs font-bold text-slate-400 uppercase tracking-wider">Agentes Autorizados</span>
                    </div>
                    <div class="border-r border-slate-200 last:border-0 p-4">
                        <span class="stat-counter text-4xl md:text-5xl font-black text-black block mb-2" data-target="99" data-suffix="%">0%</span>
                        <span class="text-xs font-bold text-slate-400 uppercase tracking-wider">Clientes Satisfechos</span>
                    </div>
                    <div class="border-r border-slate-200 last:border-0 p-4">
                        <span class="stat-counter text-4xl md:text-5xl font-black text-black block mb-2" data-target="24" data-suffix="h">0h</span>
                        <span class="text-xs font-bold text-slate-400 uppercase tracking-wider">Tiempo de Respuesta</span>
                    </div>
                </div>
            </section>

            <!-- Call to Action -->
            <c:if test="${empty sessionScope.usuarioLogueado || sessionScope.usuarioLogueado.idRol != 2}">
            <section class="reveal max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pb-24">
                <div class="bg-black text-white rounded-3xl p-12 text-center shadow-2xl relative overflow-hidden flex flex-col items-center">
                    <div class="absolute -right-20 -top-20 w-80 h-80 rounded-full bg-zinc-800 opacity-20 filter blur-3xl"></div>
                    <div class="absolute -left-20 -bottom-20 w-80 h-80 rounded-full bg-zinc-800 opacity-20 filter blur-3xl"></div>

                    <div class="relative z-10 max-w-xl">
                        <span class="text-xs font-bold uppercase tracking-widest text-zinc-400 block mb-3">Únete a nosotros</span>
                        <h2 class="font-title text-3xl md:text-4xl lg:text-5xl font-light tracking-tight mb-4">¿Deseas vender o alquilar una propiedad?</h2>
                        <p class="text-zinc-400 text-sm mb-8 leading-relaxed">Crea tu cuenta de agente, selecciona tu plan preferido y publica tus propiedades en el portal inmobiliario líder del país en minutos.</p>
                        <div class="flex flex-wrap justify-center gap-4">
                            <a href="${pageContext.request.contextPath}/usuario?accion=registro" class="bg-brandBtn hover:bg-brandHover text-white px-8 py-3.5 rounded-full font-bold text-sm shadow-md transition-all hover:-translate-y-0.5">Comenzar Gratis</a>
                            <a href="${pageContext.request.contextPath}/pagos?accion=planes" class="bg-transparent hover:bg-white/10 text-white border border-white/30 px-8 py-3.5 rounded-full font-bold text-sm transition-all hover:-translate-y-0.5">Ver Planes de Publicación</a>
                        </div>
                    </div>
                </div>
            </section>
            </c:if>
        </main>

        <!-- Footer -->
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
                    
                </div>
            </div>
        </footer>

        <!-- Script Autocomplete del Buscador Inteligente -->
        <script>
            // Exponer distritos de la base de datos a JS
            const availableDistricts = [
                <c:forEach var="d" items="${listaDistritos}" varStatus="status">
                    "${d.nombre}"${not status.last ? ',' : ''}
                </c:forEach>
            ];

            function setSearchOperacion(op) {
                document.getElementById('search-operacion').value = op;
                const btnVenta = document.getElementById('btn-tab-venta');
                const btnAlquiler = document.getElementById('btn-tab-alquiler');
                if (op === 'VENTA') {
                    btnVenta.className = 'px-6 py-2 rounded-full text-xs font-bold bg-white text-black shadow-md transition-all duration-300 hover:scale-105';
                    btnAlquiler.className = 'px-6 py-2 rounded-full text-xs font-bold text-white/80 hover:text-white hover:bg-white/10 transition-all duration-300 hover:scale-105';
                } else {
                    btnAlquiler.className = 'px-6 py-2 rounded-full text-xs font-bold bg-white text-black shadow-md transition-all duration-300 hover:scale-105';
                    btnVenta.className = 'px-6 py-2 rounded-full text-xs font-bold text-white/80 hover:text-white hover:bg-white/10 transition-all duration-300 hover:scale-105';
                }
            }

            document.addEventListener('DOMContentLoaded', () => {
                const searchInput = document.getElementById('search-keyword');
                const suggestionsBox = document.getElementById('suggestions-box');

                if (!searchInput || !suggestionsBox) return;

                searchInput.addEventListener('input', () => {
                    const val = searchInput.value.toLowerCase().trim();
                    if (!val || val.length < 2) {
                        suggestionsBox.classList.add('hidden');
                        return;
                    }

                    // Filtrar distritos que contengan la entrada
                    const filtered = availableDistricts.filter(d => d.toLowerCase().includes(val)).slice(0, 5);

                    if (filtered.length === 0) {
                        suggestionsBox.classList.add('hidden');
                        return;
                    }

                    suggestionsBox.innerHTML = '';
                    filtered.forEach(d => {
                        const div = document.createElement('div');
                        div.className = 'px-4 py-3 hover:bg-white/10 cursor-pointer text-sm border-b border-white/5 last:border-b-0 transition-colors text-left text-white';
                        
                        // Separar distrito de provincia
                        const cleanName = d.split(' (')[0];
                        div.innerHTML = `<span class="font-bold">${cleanName}</span> <span class="text-zinc-400 text-xs">${d.includes('(') ? '(' + d.split(' (')[1] : ''}</span>`;
                        
                        div.addEventListener('click', () => {
                            searchInput.value = cleanName;
                            suggestionsBox.classList.add('hidden');
                        });
                        suggestionsBox.appendChild(div);
                    });

                    suggestionsBox.classList.remove('hidden');
                });

                // Cerrar sugerencias si se hace clic fuera
                document.addEventListener('click', (e) => {
                    if (!searchInput.contains(e.target) && !suggestionsBox.contains(e.target)) {
                        suggestionsBox.classList.add('hidden');
                    }
                });
            });
        </script>
    </body>
</html>