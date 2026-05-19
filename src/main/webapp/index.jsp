<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <!DOCTYPE html>
    <html lang="es" class="scroll-smooth">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png">
        <title>Inmobix - Portal Inmobiliario</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
        <script src="https://cdn.tailwindcss.com"></script>
        <script src="${pageContext.request.contextPath}/assets/js/main.js" defer></script>
    </head>

    <body class="bg-slate-50 text-slate-800 flex flex-col min-h-screen font-sans">

        <!-- Navbar Premium con Glassmorphism -->
        <header
            class="fixed w-full top-0 z-50 bg-white/80 backdrop-blur-md border-b border-slate-200/50 shadow-sm transition-all">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between items-center h-20">
                    <!-- Logo -->
                    <div class="flex items-center gap-3">
                        <img src="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png"
                            alt="Inmobix Logo" class="h-10 w-auto object-contain">
                        <span
                            class="text-2xl font-bold bg-gradient-to-r from-blue-600 to-indigo-600 bg-clip-text text-transparent tracking-tight">Inmobix</span>
                    </div>

                    <!-- Desktop Nav -->
                    <nav class="hidden md:flex items-center gap-8">
                        <a href="${pageContext.request.contextPath}/index.jsp"
                            class="text-sm font-semibold text-blue-600 transition-colors">Inicio</a>
                        <a href="${pageContext.request.contextPath}/propiedades"
                            class="text-sm font-semibold text-slate-600 hover:text-blue-600 transition-colors">Catálogo</a>
                        <a href="${pageContext.request.contextPath}/pagos?accion=planes"
                            class="text-sm font-semibold text-slate-600 hover:text-blue-600 transition-colors">Planes</a>
                        <a href="${pageContext.request.contextPath}/propiedades?accion=nuevo"
                            class="text-sm font-semibold text-slate-600 hover:text-blue-600 transition-colors">Publicar</a>
                        <a href="${pageContext.request.contextPath}/contacto"
                            class="text-sm font-semibold text-slate-600 hover:text-blue-600 transition-colors">Contacto</a>
                    </nav>

                    <!-- Actions -->
                    <div class="hidden md:flex items-center gap-4">
                        <c:choose>
                            <c:when test="${not empty sessionScope.usuarioLogueado}">
                                <span class="text-sm font-semibold text-slate-600">Hola, ${sessionScope.usuarioLogueado.nombres}</span>
                                <c:if test="${sessionScope.usuarioLogueado.idRol == 3 || sessionScope.usuarioLogueado.idRol == 4 || sessionScope.usuarioLogueado.idRol == 5}">
                                    <a href="${pageContext.request.contextPath}/panel" class="text-sm font-semibold text-blue-600 hover:text-blue-800 transition-colors">Mi Panel</a>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/usuario?accion=logout" class="bg-slate-800 hover:bg-slate-900 text-white px-5 py-2.5 rounded-full text-sm font-semibold shadow-md shadow-slate-800/20 transition-all hover:-translate-y-0.5">Cerrar Sesión</a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/usuario?accion=login" class="text-sm font-semibold text-slate-600 hover:text-blue-600 transition-colors">Iniciar sesión</a>
                                <a href="${pageContext.request.contextPath}/usuario?accion=registro" class="bg-blue-600 hover:bg-blue-700 text-white px-5 py-2.5 rounded-full text-sm font-semibold shadow-md shadow-blue-600/20 transition-all hover:-translate-y-0.5">Regístrate</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </header>

        <!-- Hero Section -->
        <main class="flex-grow pt-20">
            <div class="relative min-h-[85vh] flex items-center justify-center overflow-hidden">
                <!-- Background Image -->
                <div class="absolute inset-0 z-0">
                    <img src="https://constructivo.com/imgPosts/1617113803lEt5g56F.jpg"
                        alt="Hero Background" class="w-full h-full object-cover" />
                    <div class="absolute inset-0 bg-gradient-to-r from-slate-900/90 via-slate-900/70 to-transparent">
                    </div>
                </div>

                <div
                    class="relative z-10 w-full max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex flex-col md:w-2/3 lg:w-1/2 items-start text-left">
                    <span
                        class="px-4 py-1.5 rounded-full bg-blue-500/20 border border-blue-400/30 text-blue-200 text-sm font-semibold tracking-wide mb-6 backdrop-blur-sm">Encuentra
                        tu próximo hogar</span>
                    <h1
                        class="text-5xl md:text-6xl lg:text-7xl font-extrabold text-white leading-tight mb-6 tracking-tight">
                        El lugar perfecto <br /> <span
                            class="text-transparent bg-clip-text bg-gradient-to-r from-blue-400 to-indigo-300">para tu
                            familia</span>
                    </h1>
                    <p class="text-lg md:text-xl text-slate-300 mb-10 max-w-lg leading-relaxed">
                        Descubre propiedades exclusivas en las mejores zonas del Perú. Comprar, alquilar o vender nunca
                        fue tan fácil y seguro.
                    </p>
                    <div class="flex flex-wrap items-center gap-4">
                        <a href="${pageContext.request.contextPath}/propiedades"
                            class="bg-blue-600 hover:bg-blue-500 text-white px-8 py-4 rounded-full font-bold text-lg shadow-xl shadow-blue-900/50 transition-all hover:-translate-y-1">
                            Explorar Catálogo
                        </a>
                        <a href="${pageContext.request.contextPath}/propiedades?accion=nuevo"
                            class="bg-white/10 hover:bg-white/20 backdrop-blur-md border border-white/20 text-white px-8 py-4 rounded-full font-bold text-lg transition-all hover:-translate-y-1">
                            Publicar Inmueble
                        </a>
                    </div>
                </div>
            </div>
        </main>

        <!-- Footer -->
        <footer class="bg-slate-900 border-t border-slate-800 text-slate-400 py-12 mt-auto">
            <div class="max-w-7xl mx-auto px-4 text-center">
                <div class="flex justify-center items-center gap-2 mb-6 opacity-80">
                    <img src="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png" alt="Inmobix Logo"
                        class="h-6 w-auto grayscale">
                    <span class="text-xl font-bold text-slate-300">Inmobix</span>
                </div>
                <p class="text-sm">&copy; 2026 Portal Inmobiliario. Todos los derechos reservados.</p>
            </div>
        </footer>
    </body>

    </html>