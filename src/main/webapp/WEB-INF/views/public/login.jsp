<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es" class="scroll-smooth">
<head>
    <c:set var="pageTitle" value="Inmobix - Iniciar Sesión" scope="request" />
    <jsp:include page="/WEB-INF/views/layout/head.jsp" />
</head>
<body class="bg-brandBg text-brandText flex flex-col min-h-screen font-sans">

    <!-- Navbar Premium con Glassmorphism -->
        <c:set var="activePage" value="login" scope="request" />
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <main class="flex-grow px-4 py-10 md:py-16">
        <div class="max-w-6xl mx-auto grid lg:grid-cols-2 overflow-hidden rounded-3xl shadow-2xl shadow-slate-900/10 border border-slate-100 bg-white">
            <section class="relative hidden lg:flex flex-col justify-between bg-gradient-to-br from-slate-950 via-slate-900 to-slate-800 text-white p-10 xl:p-12">
                <div class="absolute inset-0 opacity-20 bg-[radial-gradient(circle_at_top_right,_rgba(255,255,255,.25),_transparent_35%),radial-gradient(circle_at_bottom_left,_rgba(251,191,36,.25),_transparent_30%)]"></div>
                <div class="relative z-10">
                    <span class="inline-flex items-center gap-2 rounded-full border border-white/15 bg-white/5 px-4 py-1 text-xs font-semibold uppercase tracking-[0.22em] text-slate-200">Portal Inmobiliario</span>
                    <h2 class="mt-6 text-4xl font-black tracking-tight leading-tight">Accede a tu espacio y administra tus propiedades con seguridad.</h2>
                    <p class="mt-4 text-slate-300 text-base leading-relaxed max-w-md">Gestiona favoritos, consultas y publicaciones desde una experiencia moderna, clara y rápida.</p>
                </div>

                <div class="relative z-10 grid grid-cols-3 gap-3 text-sm">
                    <div class="rounded-2xl border border-white/10 bg-white/5 p-4">
                        <div class="text-2xl font-bold text-white">+500</div>
                        <div class="text-slate-300 mt-1">Propiedades</div>
                    </div>
                    <div class="rounded-2xl border border-white/10 bg-white/5 p-4">
                        <div class="text-2xl font-bold text-white">24/7</div>
                        <div class="text-slate-300 mt-1">Soporte</div>
                    </div>
                    <div class="rounded-2xl border border-white/10 bg-white/5 p-4">
                        <div class="text-2xl font-bold text-white">100%</div>
                        <div class="text-slate-300 mt-1">Seguro</div>
                    </div>
                </div>
            </section>

            <section class="p-6 sm:p-8 md:p-10 lg:p-12">
                <div class="max-w-md mx-auto">
                    <div class="text-center lg:text-left mb-8">
                        <div class="inline-flex items-center justify-center w-14 h-14 rounded-2xl bg-slate-950 text-white shadow-lg shadow-slate-900/20 mb-4 lg:hidden">
                            <svg class="w-7 h-7" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 11l9-8 9 8"></path><path d="M5 10v10h14V10"></path><path d="M9 20v-6h6v6"></path></svg>
                        </div>
                        <h1 class="text-3xl md:text-4xl font-black text-slate-950 tracking-tight">Bienvenido de vuelta</h1>
                        <p class="text-slate-500 mt-3">Ingresa tus credenciales para continuar.</p>
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
                        <input type="hidden" name="accion" value="login">
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">Correo electrónico</label>
                            <input type="email" name="correo" required autocomplete="email" spellcheck="false" placeholder="juan@ejemplo.com" class="w-full px-4 py-3 rounded-2xl border border-slate-200 focus:ring-2 focus:ring-slate-950 focus:border-slate-950 outline-none transition-all text-slate-700 bg-slate-50 focus:bg-white placeholder-slate-400">
                        </div>

                        <div>
                            <div class="flex items-center justify-between mb-2">
                                <label class="block text-sm font-semibold text-slate-700">Contraseña</label>
                                <a href="#" class="text-xs font-semibold text-slate-500 hover:text-slate-900">¿Olvidaste tu contraseña?</a>
                            </div>
                            <input type="password" name="password" required minlength="6" autocomplete="current-password" placeholder="••••••••" class="w-full px-4 py-3 rounded-2xl border border-slate-200 focus:ring-2 focus:ring-slate-950 focus:border-slate-950 outline-none transition-all text-slate-700 bg-slate-50 focus:bg-white placeholder-slate-400">
                        </div>

                        <div class="pt-2">
                            <button type="submit" class="w-full inline-flex items-center justify-center gap-2 bg-slate-950 hover:bg-slate-800 text-white font-bold py-3.5 px-4 rounded-2xl shadow-lg shadow-slate-900/20 transition-all hover:-translate-y-0.5 active:translate-y-0">
                                <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M10 17l5-5-5-5"></path><path d="M15 12H3"></path><path d="M21 5v14"></path></svg>
                                Ingresar
                            </button>
                        </div>
                    </form>

                    <div class="mt-8 pt-6 border-t border-slate-100 text-center lg:text-left">
                        <p class="text-slate-600 text-sm">
                            ¿No tienes cuenta?
                            <a href="${pageContext.request.contextPath}/usuario?accion=registro" class="font-bold text-slate-950 hover:text-brandBtn transition-colors ml-1">
                                Regístrate aquí
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
