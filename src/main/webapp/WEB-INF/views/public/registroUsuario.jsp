<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es" class="scroll-smooth">
<head>
    <c:set var="pageTitle" value="Inmobix - Registro de Usuario" scope="request" />
    <jsp:include page="/WEB-INF/views/layout/head.jsp" />
</head>
<body class="bg-brandBg text-brandText flex flex-col min-h-screen font-sans">

    <!-- Navbar Premium con Glassmorphism -->
        <c:set var="activePage" value="registro" scope="request" />
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <main class="flex-grow px-4 py-10 md:py-16">
        <div class="max-w-6xl mx-auto grid lg:grid-cols-2 overflow-hidden rounded-3xl shadow-2xl shadow-slate-900/10 border border-slate-100 bg-white">
            <section class="relative hidden lg:flex flex-col justify-between bg-gradient-to-br from-slate-950 via-slate-900 to-amber-900 text-white p-10 xl:p-12">
                <div class="absolute inset-0 opacity-20 bg-[radial-gradient(circle_at_top_right,_rgba(255,255,255,.25),_transparent_35%),radial-gradient(circle_at_bottom_left,_rgba(251,191,36,.25),_transparent_30%)]"></div>
                <div class="relative z-10">
                    <span class="inline-flex items-center gap-2 rounded-full border border-white/15 bg-white/5 px-4 py-1 text-xs font-semibold uppercase tracking-[0.22em] text-slate-200">Registro rápido</span>
                    <h2 class="mt-6 text-4xl font-black tracking-tight leading-tight">Crea tu cuenta y comienza a explorar oportunidades inmobiliarias.</h2>
                    <p class="mt-4 text-slate-300 text-base leading-relaxed max-w-md">Publica, guarda favoritos y contacta agentes desde una plataforma hecha para crecer contigo.</p>
                </div>

                <div class="relative z-10 grid grid-cols-3 gap-3 text-sm">
                    <div class="rounded-2xl border border-white/10 bg-white/5 p-4">
                        <div class="text-2xl font-bold text-white">2</div>
                        <div class="text-slate-300 mt-1">Perfiles de cuenta</div>
                    </div>
                    <div class="rounded-2xl border border-white/10 bg-white/5 p-4">
                        <div class="text-2xl font-bold text-white">1 min</div>
                        <div class="text-slate-300 mt-1">De registro</div>
                    </div>
                    <div class="rounded-2xl border border-white/10 bg-white/5 p-4">
                        <div class="text-2xl font-bold text-white">SSL</div>
                        <div class="text-slate-300 mt-1">Datos protegidos</div>
                    </div>
                </div>
            </section>

            <section class="p-6 sm:p-8 md:p-10 lg:p-12">
                <div class="max-w-md mx-auto">
                    <div class="text-center lg:text-left mb-8">
                        <div class="inline-flex items-center justify-center w-14 h-14 rounded-2xl bg-slate-950 text-white shadow-lg shadow-slate-900/20 mb-4 lg:hidden">
                            <svg class="w-7 h-7" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                        </div>
                        <h1 class="text-3xl md:text-4xl font-black text-slate-950 tracking-tight">Crear cuenta</h1>
                        <p class="text-slate-500 mt-3">Únete a Inmobix y encuentra tu hogar ideal.</p>
                    </div>

                    <!-- MENSAJES -->
                    <c:if test="${not empty msg}">
                        <div class="mb-6 rounded-2xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-emerald-800">
                            <p class="text-sm font-medium">${msg}</p>
                        </div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="mb-6 rounded-2xl border border-red-200 bg-red-50 px-4 py-3 text-red-800">
                            <p class="text-sm font-medium">${error}</p>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/usuario" method="post" class="space-y-5">
                        <input type="hidden" name="accion" value="registro">

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-2">Nombres</label>
                                <input type="text" name="nombres" required maxlength="80" autocomplete="given-name" placeholder="Juan" class="w-full px-4 py-3 rounded-2xl border border-slate-200 focus:ring-2 focus:ring-slate-950 focus:border-slate-950 outline-none transition-all text-slate-700 bg-slate-50 focus:bg-white placeholder-slate-400">
                            </div>
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-2">Apellidos</label>
                                <input type="text" name="apellidos" required maxlength="80" autocomplete="family-name" placeholder="Pérez" class="w-full px-4 py-3 rounded-2xl border border-slate-200 focus:ring-2 focus:ring-slate-950 focus:border-slate-950 outline-none transition-all text-slate-700 bg-slate-50 focus:bg-white placeholder-slate-400">
                            </div>
                        </div>

                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">Correo electrónico</label>
                            <input type="email" name="correo" required autocomplete="email" spellcheck="false" placeholder="juan@ejemplo.com" class="w-full px-4 py-3 rounded-2xl border border-slate-200 focus:ring-2 focus:ring-slate-950 focus:border-slate-950 outline-none transition-all text-slate-700 bg-slate-50 focus:bg-white placeholder-slate-400">
                        </div>

                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">Contraseña</label>
                            <input type="password" name="password" required minlength="6" autocomplete="new-password" placeholder="••••••••" class="w-full px-4 py-3 rounded-2xl border border-slate-200 focus:ring-2 focus:ring-slate-950 focus:border-slate-950 outline-none transition-all text-slate-700 bg-slate-50 focus:bg-white placeholder-slate-400">
                            <p class="mt-2 text-xs text-slate-500">Mínimo 6 caracteres. Usa una contraseña segura.</p>
                        </div>

                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">Tipo de Cuenta</label>
                            <select name="idRol" required class="w-full px-4 py-3 rounded-2xl border border-slate-200 focus:ring-2 focus:ring-slate-950 focus:border-slate-950 outline-none transition-all text-slate-700 bg-slate-50 focus:bg-white">
                                <option value="2">Usuario Regular (Busco propiedades)</option>
                                <option value="3">Agente Inmobiliario (Publico propiedades)</option>
                            </select>
                        </div>

                        <div class="pt-2">
                            <button type="submit" class="w-full inline-flex items-center justify-center gap-2 bg-slate-950 hover:bg-slate-800 text-white font-bold py-3.5 px-4 rounded-2xl shadow-lg shadow-slate-900/20 transition-all hover:-translate-y-0.5 active:translate-y-0">
                                <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 5v14M5 12h14"></path></svg>
                                Registrarse
                            </button>
                        </div>
                    </form>

                    <div class="mt-8 pt-6 border-t border-slate-100 text-center lg:text-left">
                        <p class="text-slate-600 text-sm">
                            ¿Ya tienes cuenta?
                            <a href="${pageContext.request.contextPath}/usuario?accion=login" class="font-bold text-slate-950 hover:text-brandBtn transition-colors ml-1">
                                Iniciar sesión
                            </a>
                        </p>
                    </div>
                </div>
            </section>
        </div>
    </main>

    <!-- Footer -->
    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
</body>
</html>

