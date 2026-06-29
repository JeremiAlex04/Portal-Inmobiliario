<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!-- Footer con Tailwind -->
<footer class="mt-auto bg-gradient-to-b from-zinc-950 to-black border-t border-white/10 text-slate-400 pt-14 pb-8">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-10 text-left">
            <!-- Column 1: Brand Info -->
            <div class="space-y-4">
                <div class="inline-flex items-center gap-2">
                    <img src="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png" alt="Inmobix Logo"
                        class="h-8 w-auto brightness-0 invert">
                    <span class="text-2xl font-black text-white tracking-tight">InmobiX</span>
                </div>
                <p class="text-sm text-slate-400 leading-relaxed">
                    El portal inmobiliario premium del Perú. Encuentra tu próximo hogar con la seguridad, rapidez y confianza que mereces.
                </p>
                <!-- Social Icons -->
                <div class="flex items-center gap-4 pt-2">
                    <a href="#" class="inline-flex items-center justify-center w-8 h-8 rounded-full border border-slate-500/40 text-slate-400 hover:text-white hover:border-white/60 transition-all" title="Facebook" aria-label="Facebook">
                        <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24"><path d="M22 12c0-5.52-4.48-10-10-10S2 6.48 2 12c0 4.84 3.44 8.87 8 9.8V15H8v-3h2V9.5C10 7.57 11.57 6 13.5 6H16v3h-2c-.55 0-1 .45-1 1v2h3v3h-3v6.95c4.56-.93 8-4.96 8-9.75z"/></svg>
                    </a>
                    <a href="#" class="inline-flex items-center justify-center w-8 h-8 rounded-full border border-slate-500/40 text-slate-400 hover:text-white hover:border-white/60 transition-all" title="Instagram" aria-label="Instagram">
                        <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24"><path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zM12 0C8.741 0 8.333.014 7.053.072 2.695.272.273 2.69.073 7.051.014 8.333 0 8.741 0 12c0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98 1.281.058 1.689.072 4.948.072 3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98C15.668.014 15.259 0 12 0zm0 5.838a6.162 6.162 0 100 12.324 6.162 6.162 0 000-12.324zM12 16a4 4 0 110-8 4 4 0 010 8zm6.406-11.845a1.44 1.44 0 100 2.881 1.44 1.44 0 000-2.881z"/></svg>
                    </a>
                </div>
            </div>

            <!-- Column 2: Empresa -->
            <div class="space-y-4">
                <h4 class="text-white font-bold text-sm tracking-wider uppercase">Empresa</h4>
                <ul class="space-y-2 text-sm">
                    <li><a href="${pageContext.request.contextPath}/index.jsp" class="hover:text-white transition-colors">Inicio</a></li>
                    <li><a href="${pageContext.request.contextPath}/propiedades" class="hover:text-white transition-colors">Catálogo</a></li>
                    <li><a href="${pageContext.request.contextPath}/pagos?accion=planes" class="hover:text-white transition-colors">Planes</a></li>
                    <li><a href="${pageContext.request.contextPath}/contacto" class="hover:text-white transition-colors">Contacto</a></li>
                </ul>
            </div>

            <!-- Column 3: Servicios -->
            <div class="space-y-4">
                <h4 class="text-white font-bold text-sm tracking-wider uppercase">Servicios</h4>
                <ul class="space-y-2 text-sm">
                    <li><a href="${pageContext.request.contextPath}/propiedades" class="hover:text-white transition-colors">Comprar propiedad</a></li>
                    <li><a href="${pageContext.request.contextPath}/propiedades?accion=nuevo" class="hover:text-white transition-colors">Publicar inmueble</a></li>
                    <li><a href="${pageContext.request.contextPath}/pagos?accion=planes" class="hover:text-white transition-colors">Planes de membresía</a></li>
                    <li><a href="${pageContext.request.contextPath}/favorito?accion=listar" class="hover:text-white transition-colors">Favoritos</a></li>
                </ul>
            </div>

            <!-- Column 4: Soporte -->
            <div class="space-y-4">
                <h4 class="text-white font-bold text-sm tracking-wider uppercase">Soporte</h4>
                <ul class="space-y-2 text-sm">
                    <li><a href="${pageContext.request.contextPath}/contacto" class="hover:text-white transition-colors">Contacto</a></li>
                    <li><a href="${pageContext.request.contextPath}/contacto" class="hover:text-white transition-colors">Preguntas frecuentes</a></li>
                    <li><a href="${pageContext.request.contextPath}/contacto" class="hover:text-white transition-colors">Términos y condiciones</a></li>
                    <li><a href="${pageContext.request.contextPath}/contacto" class="hover:text-white transition-colors">Política de privacidad</a></li>
                </ul>
            </div>
        </div>

        <div class="mt-9 pt-5 border-t border-white/10 flex flex-col md:flex-row justify-between items-center gap-4 text-xs text-slate-500">
            <p>&copy; 2026 Portal Inmobiliario Inmobix. Todos los derechos reservados.</p>
            <p>Hecho con enfoque en rendimiento, seguridad y usabilidad.</p>
        </div>
    </div>
</footer>
