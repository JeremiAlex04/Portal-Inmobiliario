<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es" class="scroll-smooth">
<head>
    <c:set var="pageTitle" value="Inmobix - Mi Perfil" scope="request" />
    <jsp:include page="/WEB-INF/views/layout/head.jsp" />
</head>
<body class="bg-brandBg text-brandText flex flex-col min-h-screen font-sans">
    
    <!-- Navbar Premium -->
        <c:set var="activePage" value="perfil" scope="request" />
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <main class="flex-grow pt-28 pb-16 px-4 max-w-4xl mx-auto w-full">
        <div class="bg-white rounded-2xl shadow-xl shadow-slate-200/50 border border-slate-100 overflow-hidden">
            <div class="px-8 py-6 border-b border-slate-100 bg-slate-50/50 flex justify-between items-center">
                <h1 class="text-2xl font-bold text-slate-800">Mi Perfil</h1>
                <span class="px-3 py-1 rounded-full text-xs font-semibold bg-blue-100 text-blue-700 uppercase tracking-wider">
                    ${sessionScope.usuarioLogueado.rolNombre != null ? sessionScope.usuarioLogueado.rolNombre : 'Usuario'}
                </span>
            </div>

            <div class="p-8">
                <!-- MENSAJES -->
                <c:if test="${not empty msg}">
                    <div class="mb-6 bg-emerald-50 border-l-4 border-emerald-500 p-4 rounded-r-md">
                        <p class="text-sm text-emerald-700 font-medium">${msg}</p>
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="mb-6 bg-red-50 border-l-4 border-red-500 p-4 rounded-r-md">
                        <p class="text-sm text-red-700 font-medium">${error}</p>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/usuario" method="post" class="space-y-6">
                    <input type="hidden" name="accion" value="actualizar_perfil">
                    
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">Nombres</label>
                            <input type="text" name="nombres" value="${sessionScope.usuarioLogueado.nombres}" required class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition-all">
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">Apellidos</label>
                            <input type="text" name="apellidos" value="${sessionScope.usuarioLogueado.apellidos}" required class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition-all">
                        </div>
                    </div>

                    <div>
                        <label class="block text-sm font-semibold text-slate-700 mb-2">Correo Electrónico</label>
                        <input type="email" name="correo" value="${sessionScope.usuarioLogueado.correo}" required class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition-all">
                    </div>

                    <div class="pt-4 border-t border-slate-100 flex justify-end">
                        <button type="submit" class="bg-brandBtn hover:bg-brandHover text-white font-bold py-3 px-6 rounded-lg shadow-lg shadow-brandBtn/20 transition-all hover:-translate-y-0.5">
                            Guardar Cambios
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
</body>
</html>
