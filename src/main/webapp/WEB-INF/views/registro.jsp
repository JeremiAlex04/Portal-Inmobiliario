<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="es" class="scroll-smooth">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png">
        <title>Inmobix - Registrar Propiedad</title>
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
                            class="text-sm font-semibold text-slate-600 hover:text-blue-600 transition-colors">Inicio</a>
                        <a href="${pageContext.request.contextPath}/propiedades"
                            class="text-sm font-semibold text-slate-600 hover:text-blue-600 transition-colors">Catálogo</a>
                        <a href="${pageContext.request.contextPath}/propiedades?accion=nuevo"
                            class="text-sm font-semibold text-blue-600 transition-colors">Publicar</a>
                        <a href="${pageContext.request.contextPath}/contacto"
                            class="text-sm font-semibold text-slate-600 hover:text-blue-600 transition-colors">Contacto</a>
                    </nav>

                    <!-- Actions -->
                    <div class="hidden md:flex items-center gap-4">
                        <a href="${pageContext.request.contextPath}/usuario?accion=registro"
                            class="text-sm font-semibold text-slate-600 hover:text-blue-600 transition-colors">Iniciar
                            sesión</a>
                        <a href="${pageContext.request.contextPath}/usuario?accion=registro"
                            class="bg-blue-600 hover:bg-blue-700 text-white px-5 py-2.5 rounded-full text-sm font-semibold shadow-md shadow-blue-600/20 transition-all hover:-translate-y-0.5">Regístrate</a>
                    </div>
                </div>
            </div>
        </header>

        <main class="flex-grow pt-28 pb-16 flex items-center justify-center px-4">
            <div
                class="w-full max-w-2xl bg-white p-8 md:p-10 rounded-2xl shadow-xl shadow-slate-200/50 border border-slate-100">
                <div class="text-center mb-8">
                    <h2 class="text-3xl font-bold text-slate-900 tracking-tight">
                        ${propiedad != null ? 'Editar Inmueble' : 'Publicar Inmueble'}
                    </h2>
                    <p class="text-slate-500 mt-2">
                        ${propiedad != null ? 'Actualiza los datos de tu propiedad.' : 'Ingresa los datos de la propiedad que deseas ofertar.'}
                    </p>
                </div>

                <% String error=(String) request.getAttribute("error"); if(error !=null) { %>
                    <div class="mb-6 bg-red-50 border-l-4 border-red-500 p-4 rounded-r-md">
                        <div class="flex">
                            <div class="flex-shrink-0">
                                <svg class="h-5 w-5 text-red-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20"
                                    fill="currentColor" aria-hidden="true">
                                    <path fill-rule="evenodd"
                                        d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z"
                                        clip-rule="evenodd" />
                                </svg>
                            </div>
                            <div class="ml-3">
                                <p class="text-sm text-red-700 font-medium">
                                    <%= error %>
                                </p>
                            </div>
                        </div>
                    </div>
                    <% } %>

                        <form action="${pageContext.request.contextPath}/propiedades" method="post" class="space-y-6">
                            <input type="hidden" name="id" value="${propiedad != null ? propiedad.id : ''}">
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-2">Título Breve</label>
                                <input type="text" name="titulo" required placeholder="Ej. Casa de 2 pisos con jardín"
                                    value="${propiedad != null ? propiedad.titulo : ''}"
                                    class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition-all text-slate-700 bg-slate-50 focus:bg-white placeholder-slate-400">
                            </div>

                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-2">Ubicación</label>
                                <input type="text" name="ubicacion" required placeholder="Ej. Lima, Miraflores"
                                    value="${propiedad != null ? propiedad.ubicacion : ''}"
                                    class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition-all text-slate-700 bg-slate-50 focus:bg-white placeholder-slate-400">
                            </div>

                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-2">Descripción
                                    Detallada</label>
                                <textarea name="descripcion" rows="4" required
                                    placeholder="Describe las comodidades, áreas, etc."
                                    class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition-all text-slate-700 bg-slate-50 focus:bg-white placeholder-slate-400 resize-y">${propiedad != null ? propiedad.descripcion : ''}</textarea>
                            </div>

                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-2">Precio (US$)</label>
                                <div class="relative">
                                    <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                                        <span class="text-slate-500 font-semibold">$</span>
                                    </div>
                                    <input type="number" step="0.01" name="precio" required placeholder="150000.00"
                                        value="${propiedad != null ? propiedad.precio : ''}"
                                        class="w-full pl-8 pr-4 py-3 rounded-lg border border-slate-300 focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition-all text-slate-700 bg-slate-50 focus:bg-white placeholder-slate-400">
                                </div>
                            </div>

                            <div class="pt-4 flex gap-4">
                                <a href="${pageContext.request.contextPath}/propiedades"
                                    class="w-1/3 text-center bg-slate-200 hover:bg-slate-300 text-slate-700 font-bold py-3.5 px-4 rounded-lg transition-all hover:-translate-y-0.5 active:translate-y-0">
                                    Cancelar
                                </a>
                                <button type="submit"
                                    class="w-2/3 bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-3.5 px-4 rounded-lg shadow-lg shadow-indigo-600/30 transition-all hover:-translate-y-0.5 active:translate-y-0">
                                    ${propiedad != null ? 'Actualizar Propiedad' : 'Guardar Propiedad'}
                                </button>
                            </div>
                        </form>
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