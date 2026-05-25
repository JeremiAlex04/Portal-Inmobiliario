<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png">
    <title>Inmobix - Contacto</title>
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
        
    <script src="${pageContext.request.contextPath}/assets/js/main.js" defer></script>
</head>
<body class="bg-brandBg text-brandText flex flex-col min-h-screen font-sans">
    
    <!-- Navbar Premium con Glassmorphism -->
    <header class="text-white fixed w-full top-0 z-50 bg-black/90 backdrop-blur-md backdrop-blur-md border-b border-white/10 shadow-lg transition-all">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center h-20">
                <!-- Logo -->
                <div class="flex items-center gap-3">
                    <img src="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png" alt="Inmobix Logo" class="h-10 w-auto object-contain brightness-0 invert">
                    <span class="text-2xl font-bold text-white tracking-tight">Inmobix</span>
                </div>
                
                <!-- Desktop Nav -->
                <nav class="hidden md:flex items-center gap-8">
                    <a href="${pageContext.request.contextPath}/index.jsp" class="text-sm font-semibold text-white/80 hover:text-brandHover transition-colors">Inicio</a>
                    <a href="${pageContext.request.contextPath}/propiedades" class="text-sm font-semibold text-white/80 hover:text-brandHover transition-colors">Catálogo</a>
                    <a href="${pageContext.request.contextPath}/propiedades?accion=nuevo" class="text-sm font-semibold text-white/80 hover:text-brandHover transition-colors">Publicar</a>
                    <a href="${pageContext.request.contextPath}/contacto" class="text-sm font-semibold text-brandHover transition-colors">Contacto</a>
                </nav>

                <!-- Actions -->
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

    <main class="flex-grow pt-28 pb-16 flex items-center justify-center px-4">
        <div class="w-full max-w-lg bg-white p-8 md:p-10 rounded-2xl shadow-xl shadow-slate-200/50 border border-slate-100">
            <div class="text-center mb-8">
                <h2 class="text-3xl font-bold text-slate-900 tracking-tight">Contáctanos</h2>
                <p class="text-slate-500 mt-2">¿Tienes dudas? Envíanos un mensaje y te responderemos a la brevedad.</p>
            </div>

            <c:if test="${not empty msg}">
                <div class="mb-6 rounded-lg border px-4 py-3 text-sm font-medium ${msgType == 'success' ? 'bg-emerald-50 border-emerald-200 text-emerald-700' : 'bg-red-50 border-red-200 text-red-700'}">
                    ${msg}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/contacto" method="post" class="space-y-6">
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2">Nombre completo</label>
                    <input type="text" name="nombre" required placeholder="Tu nombre" class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition-all text-slate-700 bg-slate-50 focus:bg-white placeholder-slate-400">
                </div>

                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2">Correo electrónico</label>
                    <input type="email" name="email" required placeholder="tu@correo.com" class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition-all text-slate-700 bg-slate-50 focus:bg-white placeholder-slate-400">
                </div>

                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2">Mensaje</label>
                    <textarea name="mensaje" rows="5" required placeholder="Escribe tu mensaje aquí..." class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition-all text-slate-700 bg-slate-50 focus:bg-white placeholder-slate-400 resize-y"></textarea>
                </div>

                <div class="pt-4">
                    <button type="submit" class="w-full bg-brandBtn hover:bg-brandHover text-white font-bold py-3.5 px-4 rounded-lg shadow-lg shadow-brandBtn/20 transition-all hover:-translate-y-0.5 active:translate-y-0">
                        Enviar Mensaje
                    </button>
                </div>
            </form>
        </div>
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
</body>
</html>
