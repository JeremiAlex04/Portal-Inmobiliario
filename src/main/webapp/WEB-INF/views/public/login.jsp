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

    <main class="flex-grow pt-28 pb-16 flex items-center justify-center px-4">
        <div class="w-full max-w-md bg-white p-8 md:p-10 rounded-2xl shadow-xl shadow-slate-200/50 border border-slate-100">
            <div class="text-center mb-8">
                <h2 class="text-3xl font-bold text-slate-900 tracking-tight">Bienvenido a Inmobix</h2>
                <p class="text-slate-500 mt-2">Ingresa tus credenciales para acceder.</p>
            </div>

            <!-- MENSAJES -->
            <c:if test="${not empty msg}">
                <div class="mb-6 bg-emerald-50 border-l-4 border-emerald-500 p-4 rounded-r-md">
                    <div class="flex">
                        <div class="flex-shrink-0">
                            <svg class="h-5 w-5 text-emerald-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                            </svg>
                        </div>
                        <div class="ml-3">
                            <p class="text-sm text-emerald-700 font-medium">${msg}</p>
                        </div>
                    </div>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="mb-6 bg-red-50 border-l-4 border-red-500 p-4 rounded-r-md">
                    <div class="flex">
                        <div class="flex-shrink-0">
                            <svg class="h-5 w-5 text-red-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
                            </svg>
                        </div>
                        <div class="ml-3">
                            <p class="text-sm text-red-700 font-medium">${error}</p>
                        </div>
                    </div>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/usuario" method="post" class="space-y-5">
                <input type="hidden" name="accion" value="login">
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2">Correo electrónico</label>
                    <input type="email" name="correo" required placeholder="juan@ejemplo.com" class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition-all text-slate-700 bg-slate-50 focus:bg-white placeholder-slate-400">
                </div>

                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2">Contraseña</label>
                    <input type="password" name="password" required placeholder="••••••••" class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition-all text-slate-700 bg-slate-50 focus:bg-white placeholder-slate-400">
                </div>

                <div class="pt-2">
                    <button type="submit" class="w-full bg-brandBtn hover:bg-brandHover text-white font-bold py-3.5 px-4 rounded-lg shadow-lg shadow-brandBtn/20 transition-all hover:-translate-y-0.5 active:translate-y-0">
                        Ingresar
                    </button>
                </div>
            </form>

            <div class="mt-8 pt-6 border-t border-slate-100 text-center">
                <p class="text-slate-600 text-sm">
                    ¿No tienes cuenta?
                    <a href="${pageContext.request.contextPath}/usuario?accion=registro" class="font-bold text-brandBtn hover:text-brandHover transition-colors ml-1">
                        Regístrate aquí
                    </a>
                </p>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
</body>
</html>
