<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="es" class="scroll-smooth">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <link rel="icon" type="image/png"
                href="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png">
            <title>Inmobix - Registrar Propiedad</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
            <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
            <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
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
            <header
                class="text-white fixed w-full top-0 z-50 bg-black/90 backdrop-blur-md backdrop-blur-md border-b border-white/10 shadow-lg transition-all">
                <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                    <div class="flex justify-between items-center h-20">
                        <div class="flex items-center gap-3">
                            <img src="${pageContext.request.contextPath}/assets/img/logo/Logo_Inmobix.png"
                                alt="Inmobix Logo" class="h-10 w-auto object-contain brightness-0 invert">
                            <span
                                class="text-2xl font-bold text-white tracking-tight">Inmobix</span>
                        </div>
                        <nav class="hidden md:flex items-center gap-8">
                            <a href="${pageContext.request.contextPath}/index.jsp"
                                class="text-sm font-semibold text-white/80 hover:text-brandHover transition-colors">Inicio</a>
                            <a href="${pageContext.request.contextPath}/propiedades"
                                class="text-sm font-semibold text-white/80 hover:text-brandHover transition-colors">Catálogo</a>
                            <a href="${pageContext.request.contextPath}/propiedades?accion=nuevo"
                                class="text-sm font-semibold text-brandHover transition-colors">Publicar</a>
                            <a href="${pageContext.request.contextPath}/contacto"
                                class="text-sm font-semibold text-white/80 hover:text-brandHover transition-colors">Contacto</a>
                        </nav>
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

            <main class="flex-grow pt-28 pb-16 flex justify-center px-4">
                <div
                    class="w-full max-w-4xl bg-white p-8 md:p-10 rounded-2xl shadow-xl shadow-slate-200/50 border border-slate-100">
                    <div class="text-center mb-8">
                        <h2 class="text-3xl font-bold text-slate-900 tracking-tight">
                            ${propiedad != null && propiedad.id > 0 ? 'Editar Inmueble' : 'Publicar Inmueble'}
                        </h2>
                        <p class="text-slate-500 mt-2">
                            ${propiedad != null && propiedad.id > 0 ? 'Actualiza los datos de tu propiedad.' : 'Ingresa
                            los datos de la propiedad que deseas ofertar.'}
                        </p>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="mb-6 bg-red-50 border-l-4 border-red-500 p-4 rounded-r-md">
                            <div class="flex">
                                <div class="ml-3">
                                    <p class="text-sm text-red-700 font-medium">${error}</p>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/propiedades" method="post" enctype="multipart/form-data" class="space-y-8">
                        <input type="hidden" name="id" value="${propiedad != null ? propiedad.id : ''}">

                        <!-- Sección 1: Datos Principales -->
                        <div>
                            <h3 class="text-xl font-bold text-slate-800 mb-4 border-b pb-2">1. Información Principal
                            </h3>
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div class="md:col-span-2">
                                    <label class="block text-sm font-semibold text-slate-700 mb-2">Título Breve
                                        *</label>
                                    <input type="text" name="titulo" required
                                        placeholder="Ej. Hermosa casa en Miraflores"
                                        value="${propiedad != null ? propiedad.titulo : ''}"
                                        class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:ring-2 focus:ring-indigo-500 outline-none">
                                </div>
                                <div class="md:col-span-2">
                                    <label class="block text-sm font-semibold text-slate-700 mb-2">Descripción Detallada
                                        *</label>
                                    <textarea name="descripcion" rows="4" required
                                        placeholder="Describe las comodidades, cercanía a parques..."
                                        class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:ring-2 focus:ring-indigo-500 outline-none">${propiedad != null ? propiedad.descripcion : ''}</textarea>
                                </div>
                                <div>
                                    <label class="block text-sm font-semibold text-slate-700 mb-2">Tipo de Inmueble
                                        *</label>
                                    <select name="idTipoInmueble" required
                                        class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:ring-2 focus:ring-indigo-500 outline-none bg-white">
                                        <option value="">Seleccione un tipo</option>
                                        <c:forEach var="t" items="${listaTipos}">
                                            <option value="${t.id}" ${propiedad != null && propiedad.idTipoInmueble == t.id ? 'selected' : ''}>
                                                ${t.nombre}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div>
                                    <label class="block text-sm font-semibold text-slate-700 mb-2">Operación *</label>
                                    <select name="idOperacion" required
                                        class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:ring-2 focus:ring-indigo-500 outline-none bg-white">
                                        <option value="">Seleccione operación</option>
                                        <c:forEach var="op" items="${listaOperaciones}">
                                            <option value="${op.id}" ${propiedad != null && propiedad.idOperacion == op.id ? 'selected' : ''}>
                                                ${op.nombre}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <!-- Sección 2: Ubicación -->
                        <div>
                            <h3 class="text-xl font-bold text-slate-800 mb-4 border-b pb-2">2. Ubicación y Registro</h3>
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div>
                                    <label class="block text-sm font-semibold text-slate-700 mb-2">Distrito *</label>
                                    <select name="idDistrito" required
                                        class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:ring-2 focus:ring-indigo-500 outline-none bg-white">
                                        <option value="">Seleccione distrito</option>
                                        <c:forEach var="d" items="${listaDistritos}">
                                            <option value="${d.id}" ${propiedad != null && propiedad.idDistrito == d.id ? 'selected' : ''}>
                                                ${d.nombre}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div>
                                    <label class="block text-sm font-semibold text-slate-700 mb-2">Dirección Exacta
                                        *</label>
                                    <input type="text" name="direccion" required placeholder="Ej. Av. Pardo 123"
                                        value="${propiedad != null ? propiedad.direccion : ''}"
                                        class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:ring-2 focus:ring-indigo-500 outline-none">
                                </div>
                                <div class="md:col-span-2">
                                    <label class="block text-sm font-semibold text-slate-700 mb-2">Partida Registral
                                        (SUNARP)</label>
                                    <input type="text" name="partidaRegistral" placeholder="Ej. 11029384"
                                        value="${propiedad != null ? propiedad.partidaRegistral : ''}"
                                        class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:ring-2 focus:ring-indigo-500 outline-none">
                                </div>
                                <div class="md:col-span-2">
                                    <label class="block text-sm font-semibold text-slate-700 mb-2">Referencia de Ubicación</label>
                                    <input type="text" name="referencia" placeholder="Ej. Altura de la cuadra 8 de Av. Larco, frente a la Iglesia"
                                        value="${propiedad != null ? propiedad.referencia : ''}"
                                        class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:ring-2 focus:ring-indigo-500 outline-none">
                                </div>
                                <div class="md:col-span-2">
                                    <label class="block text-sm font-semibold text-slate-700 mb-2">Ubicación Geográfica en el Mapa * (Haga clic para situar el pin o arrástrelo)</label>
                                    <div id="registro-map" class="w-full h-72 rounded-xl border border-slate-300 shadow-md z-10"></div>
                                    <p class="text-xs text-slate-500 mt-2">Coordenadas seleccionadas: <span id="coordenadas-display" class="font-mono font-semibold text-slate-800">Ninguna</span></p>
                                    <input type="hidden" id="latitud" name="latitud" value="${propiedad != null && propiedad.latitud != null ? propiedad.latitud : ''}">
                                    <input type="hidden" id="longitud" name="longitud" value="${propiedad != null && propiedad.longitud != null ? propiedad.longitud : ''}">
                                </div>
                            </div>
                        </div>

                        <!-- Sección 3: Precio y Datos Técnicos -->
                        <div>
                            <h3 class="text-xl font-bold text-slate-800 mb-4 border-b pb-2">3. Detalles Técnicos y
                                Precio</h3>
                            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                                <div>
                                    <label class="block text-sm font-semibold text-slate-700 mb-2">Moneda *</label>
                                    <select name="monedaBase" required
                                        class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:ring-2 focus:ring-indigo-500 outline-none bg-white">
                                        <option value="USD" ${propiedad !=null && propiedad.monedaBase=='USD'
                                            ? 'selected' : '' }>Dólares (US$)</option>
                                        <option value="PEN" ${propiedad !=null && propiedad.monedaBase=='PEN'
                                            ? 'selected' : '' }>Soles (S/)</option>
                                    </select>
                                </div>
                                <div class="md:col-span-2">
                                    <label class="block text-sm font-semibold text-slate-700 mb-2">Precio *</label>
                                    <input type="number" step="0.01" name="precio" required placeholder="150000.00"
                                        value="${propiedad != null ? propiedad.precio : ''}"
                                        class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:ring-2 focus:ring-indigo-500 outline-none">
                                </div>

                                <!-- Técnicos -->
                                <div>
                                    <label class="block text-sm font-semibold text-slate-700 mb-2">Área Total
                                        (m²)</label>
                                    <input type="number" step="0.01" name="areaTotalM2" placeholder="120.5"
                                        value="${propiedad != null ? propiedad.areaTotalM2 : ''}"
                                        class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:ring-2 focus:ring-indigo-500 outline-none">
                                </div>
                                <div>
                                    <label class="block text-sm font-semibold text-slate-700 mb-2">Área Techada
                                        (m²)</label>
                                    <input type="number" step="0.01" name="areaTechadaM2" placeholder="100.0"
                                        value="${propiedad != null ? propiedad.areaTechadaM2 : ''}"
                                        class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:ring-2 focus:ring-indigo-500 outline-none">
                                </div>
                                <div>
                                    <label class="block text-sm font-semibold text-slate-700 mb-2">Año
                                        Construcción</label>
                                    <input type="number" name="anioConstruccion" placeholder="2015"
                                        value="${propiedad != null && propiedad.anioConstruccion > 0 ? propiedad.anioConstruccion : ''}"
                                        class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:ring-2 focus:ring-indigo-500 outline-none">
                                </div>

                                <!-- Ambientes -->
                                <div>
                                    <label class="block text-sm font-semibold text-slate-700 mb-2">Dormitorios</label>
                                    <input type="number" name="numDormitorios" placeholder="3"
                                        value="${propiedad != null && propiedad.numDormitorios > 0 ? propiedad.numDormitorios : ''}"
                                        class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:ring-2 focus:ring-indigo-500 outline-none">
                                </div>
                                <div>
                                    <label class="block text-sm font-semibold text-slate-700 mb-2">Baños</label>
                                    <input type="number" name="numBanos" placeholder="2"
                                        value="${propiedad != null && propiedad.numBanos > 0 ? propiedad.numBanos : ''}"
                                        class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:ring-2 focus:ring-indigo-500 outline-none">
                                </div>
                                <div>
                                    <label class="block text-sm font-semibold text-slate-700 mb-2">Cocheras</label>
                                    <input type="number" name="numCocheras" placeholder="1"
                                        value="${propiedad != null && propiedad.numCocheras > 0 ? propiedad.numCocheras : ''}"
                                        class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:ring-2 focus:ring-indigo-500 outline-none">
                                </div>
                                <div>
                                    <label class="block text-sm font-semibold text-slate-700 mb-2">Número de Pisos</label>
                                    <input type="number" name="numPisos" placeholder="Ej. 3"
                                        value="${propiedad != null && propiedad.numPisos > 0 ? propiedad.numPisos : ''}"
                                        class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:ring-2 focus:ring-indigo-500 outline-none">
                                </div>
                                <div class="md:col-span-2">
                                    <label class="block text-sm font-semibold text-slate-700 mb-2">Enlace Tour 360 (Recorrido 3D)</label>
                                    <input type="url" name="tour360Url" placeholder="https://my.matterport.com/show/?m=..."
                                        value="${propiedad != null ? propiedad.tour360Url : ''}"
                                        class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:ring-2 focus:ring-indigo-500 outline-none">
                                </div>
                            </div>
                        </div>

                        <!-- Sección 4: Atributos Especiales -->
                        <div>
                            <h3 class="text-xl font-bold text-slate-800 mb-4 border-b pb-2">4. Atributos Especiales</h3>
                            <div class="flex gap-8">
                                <label class="flex items-center gap-3 cursor-pointer">
                                    <input type="checkbox" name="bonoMiVivienda" value="1" ${propiedad !=null &&
                                        propiedad.bonoMiVivienda==1 ? 'checked' : '' }
                                        class="w-5 h-5 text-indigo-600 rounded focus:ring-indigo-500">
                                    <span class="text-slate-700 font-medium">Aplica a Bono MiVivienda</span>
                                </label>
                                <label class="flex items-center gap-3 cursor-pointer">
                                    <input type="checkbox" name="bonoVerde" value="1" ${propiedad !=null &&
                                        propiedad.bonoVerde==1 ? 'checked' : '' }
                                        class="w-5 h-5 text-emerald-500 rounded focus:ring-emerald-500">
                                    <span class="text-slate-700 font-medium text-emerald-700">Aplica a Bono Verde</span>
                                </label>
                            </div>
                        </div>

                        <!-- Sección 5: Foto Principal (Sprint 2) -->
                        <div>
                            <h3 class="text-xl font-bold text-slate-800 mb-4 border-b pb-2">5. Foto Principal</h3>
                            <div>
                                <c:if test="${propiedad != null && not empty propiedad.fotoPrincipal}">
                                    <div class="mb-4">
                                        <p class="text-sm text-slate-500 mb-2">Foto actual:</p>
                                        <img src="${pageContext.request.contextPath}/${propiedad.fotoPrincipal}" alt="Foto actual" class="w-48 h-32 object-cover rounded-lg border border-slate-200">
                                    </div>
                                </c:if>
                                <label class="block text-sm font-semibold text-slate-700 mb-2">Subir imagen (JPG, PNG o WebP — máx. 2 MB)</label>
                                <input type="file" name="fotoPrincipal" accept=".jpg,.jpeg,.png,.webp"
                                    class="w-full px-4 py-3 rounded-lg border border-slate-300 text-sm file:mr-4 file:py-2 file:px-4 file:rounded-lg file:border-0 file:bg-indigo-50 file:text-indigo-700 file:font-semibold hover:file:bg-indigo-100"
                                    onchange="previewImage(this)">
                                <div id="imgPreview" class="mt-3 hidden">
                                    <img id="previewImg" src="" alt="Preview" class="w-48 h-32 object-cover rounded-lg border border-slate-200">
                                </div>
                            </div>
                        </div>

                        <script>
                            function previewImage(input) {
                                const preview = document.getElementById('previewImg');
                                const container = document.getElementById('imgPreview');
                                if (input.files && input.files[0]) {
                                    const reader = new FileReader();
                                    reader.onload = function(e) {
                                        preview.src = e.target.result;
                                        container.classList.remove('hidden');
                                    };
                                    reader.readAsDataURL(input.files[0]);
                                }
                            }
                        </script>

                        <!-- Sprint 3: Galería de imágenes -->
                        <c:if test="${not empty propiedad.id}">
                        <div class="bg-slate-50 rounded-xl p-6 mt-6 border border-slate-200">
                            <h3 class="text-lg font-bold text-slate-800 mb-4 flex items-center gap-2">
                                <svg class="w-5 h-5 text-slate-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 13a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                                Galería de Fotos (máx. 5)
                            </h3>
                            <c:if test="${not empty galeriaFotos}">
                                <div class="flex flex-wrap gap-3 mb-4">
                                    <c:forEach var="foto" items="${galeriaFotos}">
                                        <div class="relative group">
                                            <img src="${pageContext.request.contextPath}/${foto.rutaArchivo}" class="w-24 h-20 object-cover rounded-lg border">
                                            <form action="${pageContext.request.contextPath}/galeria" method="post" class="absolute -top-2 -right-2 hidden group-hover:block">
                                                <input type="hidden" name="accion" value="eliminar">
                                                <input type="hidden" name="idFoto" value="${foto.id}">
                                                <input type="hidden" name="idPropiedad" value="${propiedad.id}">
                                                <button class="bg-red-500 text-white w-6 h-6 rounded-full flex items-center justify-center shadow hover:bg-red-600 transition-colors" title="Eliminar">
                                                    <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M6 18L18 6M6 6l12 12"></path>
                                                    </svg>
                                                </button>
                                            </form>
                                            <c:if test="${foto.esPrincipal}"><span class="absolute bottom-0 left-0 right-0 bg-blue-600 text-white text-[10px] text-center font-bold rounded-b-lg">Principal</span></c:if>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:if>
                            <form action="${pageContext.request.contextPath}/galeria" method="post" enctype="multipart/form-data" class="flex flex-col gap-3">
                                <input type="hidden" name="idPropiedad" value="${propiedad.id}">
                                <input type="file" name="fotos" multiple accept=".jpg,.jpeg,.png,.webp"
                                    class="w-full text-sm file:mr-4 file:py-2 file:px-4 file:rounded-lg file:border-0 file:bg-blue-50 file:text-blue-700 file:font-semibold">
                                <button type="submit" class="bg-blue-600 text-white px-6 py-2 rounded-lg font-bold text-sm w-fit">Subir Fotos</button>
                            </form>
                        </div>
                        </c:if>

                        <div class="pt-6 flex gap-4 border-t border-slate-200 mt-8">
                            <a href="${pageContext.request.contextPath}/propiedades"
                                class="w-1/3 text-center bg-slate-200 hover:bg-slate-300 text-slate-700 font-bold py-4 rounded-xl transition-all">
                                Cancelar
                            </a>
                            <button type="submit"
                                class="w-2/3 bg-brandBtn hover:bg-brandHover text-white font-bold py-4 rounded-xl shadow-lg transition-all">
                                ${propiedad != null && propiedad.id > 0 ? 'Actualizar Propiedad' : 'Publicar Propiedad'}
                            </button>
                        </div>
                    </form>
                </div>
            </main>

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
                    <div class="flex items-center gap-6">
                        <span class="inline-flex items-center gap-1.5"><span class="w-2 h-2 rounded-full bg-emerald-500"></span> BD Conectada</span>
                        <span>Hecho en Perú</span>
                    </div>
                </div>
            </div>
        </footer>

            <script>
                // Inicialización del Mapa
                document.addEventListener("DOMContentLoaded", function() {
                    var defaultLat = -12.046374;
                    var defaultLng = -77.042793;
                    
                    var savedLat = document.getElementById('latitud').value;
                    var savedLng = document.getElementById('longitud').value;
                    
                    var initialLat = savedLat ? parseFloat(savedLat) : defaultLat;
                    var initialLng = savedLng ? parseFloat(savedLng) : defaultLng;
                    var initialZoom = savedLat ? 16 : 13;
                    
                    var regMap = L.map('registro-map').setView([initialLat, initialLng], initialZoom);
                    L.tileLayer('https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=8IyYWrIbuDLsiINCC7Du', {
                        attribution: '&copy; MapTiler &copy; OpenStreetMap contributors'
                    }).addTo(regMap);
                    
                    var marker;
                    
                    // Función para actualizar coordenadas en pantalla y en los inputs
                    function updateCoords(lat, lng) {
                        document.getElementById('latitud').value = lat;
                        document.getElementById('longitud').value = lng;
                        document.getElementById('coordenadas-display').textContent = lat.toFixed(6) + ", " + lng.toFixed(6);
                    }
                    
                    if (savedLat && savedLng) {
                        marker = L.marker([initialLat, initialLng], {draggable: true}).addTo(regMap);
                        document.getElementById('coordenadas-display').textContent = initialLat.toFixed(6) + ", " + initialLng.toFixed(6);
                        
                        marker.on('dragend', function(e) {
                            var position = marker.getLatLng();
                            updateCoords(position.lat, position.lng);
                        });
                    }
                    
                    regMap.on('click', function(e) {
                        var clickLat = e.latlng.lat;
                        var clickLng = e.latlng.lng;
                        
                        updateCoords(clickLat, clickLng);
                        
                        if (marker) {
                            marker.setLatLng(e.latlng);
                        } else {
                            marker = L.marker(e.latlng, {draggable: true}).addTo(regMap);
                            marker.on('dragend', function(ev) {
                                var position = marker.getLatLng();
                                updateCoords(position.lat, position.lng);
                            });
                        }
                    });
                });
            </script>
        </body>

        </html>