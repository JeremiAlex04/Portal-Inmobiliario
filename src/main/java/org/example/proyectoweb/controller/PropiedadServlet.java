package org.example.proyectoweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import org.example.proyectoweb.facade.PropiedadFacade;
import org.example.proyectoweb.facade.FavoritoFacade;
import org.example.proyectoweb.dao.EstadisticaDAO;
import org.example.proyectoweb.dao.GaleriaDAO;
import org.example.proyectoweb.dto.PropiedadDTO;
import org.example.proyectoweb.dto.PropiedadFotoDTO;
import org.example.proyectoweb.dto.UsuarioDTO;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.UUID;

@WebServlet(name = "PropiedadServlet", urlPatterns = { "/propiedades" })
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,       // 1 MB
    maxFileSize       = 2 * 1024 * 1024,   // 2 MB
    maxRequestSize    = 5 * 1024 * 1024    // 5 MB total
)
public class PropiedadServlet extends HttpServlet {

    private PropiedadFacade propiedadFacade;
    private FavoritoFacade favoritoFacade;
    private EstadisticaDAO estadisticaDAO;
    private GaleriaDAO galeriaDAO;

    // Extensiones permitidas para fotos
    private static final List<String> EXTENSIONES_PERMITIDAS = Arrays.asList("jpg", "jpeg", "png", "webp");

    @Override
    public void init() throws ServletException {
        propiedadFacade = new PropiedadFacade();
        favoritoFacade = new FavoritoFacade();
        estadisticaDAO = new EstadisticaDAO();
        galeriaDAO = new GaleriaDAO();
    }

    private void cargarCatalogos(HttpServletRequest request) {
        request.setAttribute("listaDistritos", propiedadFacade.obtenerDistritos());
        request.setAttribute("listaTipos", propiedadFacade.obtenerTiposInmueble());
        request.setAttribute("listaOperaciones", propiedadFacade.obtenerOperaciones());
    }

    // =========================================================
    // Utilidad: procesar imagen subida
    // =========================================================
    private String procesarImagen(HttpServletRequest request) throws IOException, ServletException {
        Part filePart = request.getPart("fotoPrincipal");
        if (filePart == null || filePart.getSize() == 0) {
            return null; // No se subió imagen
        }

        // Validar tamaño (2 MB)
        if (filePart.getSize() > 2 * 1024 * 1024) {
            throw new ServletException("La imagen no puede superar los 2 MB.");
        }

        // Obtener nombre y extensión
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String extension = "";
        int dot = fileName.lastIndexOf('.');
        if (dot > 0) {
            extension = fileName.substring(dot + 1).toLowerCase();
        }

        // Validar extensión
        if (!EXTENSIONES_PERMITIDAS.contains(extension)) {
            throw new ServletException("Formato no permitido. Use: jpg, jpeg, png o webp.");
        }

        // Generar nombre único
        String nuevoNombre = UUID.randomUUID().toString() + "." + extension;

        // Crear directorio de uploads si no existe
        String uploadPath = getServletContext().getRealPath("/uploads/propiedades");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // Guardar archivo
        filePart.write(uploadPath + File.separator + nuevoNombre);

        // Retornar ruta relativa para la BD
        return "uploads/propiedades/" + nuevoNombre;
    }

    // =========================================================
    // GET — Navegación, listado, búsqueda, detalle
    // =========================================================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "listar";
        }

        try {
            switch (accion) {
                case "nuevo":
                    cargarCatalogos(request);
                    request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
                    break;

                case "ver":
                    int idVer = Integer.parseInt(request.getParameter("id"));

                    // Sprint 2: Incrementar contador de vistas
                    propiedadFacade.incrementarVistas(idVer);
                    // Sprint 3: Registrar vista diaria para analytics
                    estadisticaDAO.registrarVistaDiaria(idVer);

                    PropiedadDTO pVer = propiedadFacade.obtenerPropiedad(idVer);
                    if (pVer != null) {
                        // Sprint 2: Verificar si es favorito del usuario actual
                        UsuarioDTO userFav = (UsuarioDTO) request.getSession().getAttribute("usuarioLogueado");
                        if (userFav != null) {
                            pVer.setFavorito(favoritoFacade.esFavorito(userFav.getIdUsuario(), idVer));
                        }
                        // Sprint 3: Galería de fotos
                        List<PropiedadFotoDTO> galeria = galeriaDAO.obtenerFotos(idVer);
                        request.setAttribute("galeriaFotos", galeria);
                        request.setAttribute("propiedad", pVer);
                        request.getRequestDispatcher("/WEB-INF/views/detalle_propiedad.jsp").forward(request, response);
                    } else {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Propiedad no encontrada");
                    }
                    break;

                case "editar":
                    int idEditar = Integer.parseInt(request.getParameter("id"));
                    PropiedadDTO pEditar = propiedadFacade.obtenerPropiedad(idEditar);
                    request.setAttribute("propiedad", pEditar);
                    // Sprint 3: Cargar galería para edición
                    request.setAttribute("galeriaFotos", galeriaDAO.obtenerFotos(idEditar));
                    cargarCatalogos(request);
                    request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
                    break;

                case "eliminar":
                    int idEliminar = Integer.parseInt(request.getParameter("id"));
                    propiedadFacade.eliminarPropiedad(idEliminar);
                    UsuarioDTO sessionUser = (UsuarioDTO) request.getSession().getAttribute("usuarioLogueado");
                    if (sessionUser != null && (sessionUser.getIdRol() == 3 || sessionUser.getIdRol() == 4 || sessionUser.getIdRol() == 5)) {
                        response.sendRedirect(request.getContextPath() + "/panel");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/propiedades");
                    }
                    break;

                case "listar":
                default:
                    // Sprint 2: Capturar todos los filtros avanzados
                    String keyword = request.getParameter("q");
                    String operacion = request.getParameter("operacion");
                    String tipoInmueble = request.getParameter("tipo");
                    String precioMinStr = request.getParameter("precioMin");
                    String precioMaxStr = request.getParameter("precioMax");
                    String dormitoriosStr = request.getParameter("dormitorios");
                    String banosStr = request.getParameter("banos");

                    BigDecimal precioMin = null, precioMax = null;
                    Integer dormitorios = null, banos = null;

                    try { if (precioMinStr != null && !precioMinStr.isEmpty()) precioMin = new BigDecimal(precioMinStr); } catch(Exception ignored) {}
                    try { if (precioMaxStr != null && !precioMaxStr.isEmpty()) precioMax = new BigDecimal(precioMaxStr); } catch(Exception ignored) {}
                    try { if (dormitoriosStr != null && !dormitoriosStr.isEmpty()) dormitorios = Integer.parseInt(dormitoriosStr); } catch(Exception ignored) {}
                    try { if (banosStr != null && !banosStr.isEmpty()) banos = Integer.parseInt(banosStr); } catch(Exception ignored) {}

                    // Paginación
                    int page = 1;
                    int recordsPerPage = 10;
                    if (request.getParameter("page") != null) {
                        try { page = Integer.parseInt(request.getParameter("page")); } catch (NumberFormatException e) { page = 1; }
                    }
                    int offset = (page - 1) * recordsPerPage;

                    // Usar búsqueda avanzada
                    List<PropiedadDTO> listaPropiedades = propiedadFacade.buscarPropiedadesAvanzado(
                            keyword, operacion, tipoInmueble, precioMin, precioMax, dormitorios, banos, offset, recordsPerPage);
                    int totalRecords = propiedadFacade.contarPropiedadesAvanzado(
                            keyword, operacion, tipoInmueble, precioMin, precioMax, dormitorios, banos);

                    // Sprint 2: Marcar favoritos en la lista
                    UsuarioDTO userList = (UsuarioDTO) request.getSession().getAttribute("usuarioLogueado");
                    if (userList != null) {
                        Set<Integer> favIds = favoritoFacade.obtenerIdsFavoritos(userList.getIdUsuario());
                        for (PropiedadDTO p : listaPropiedades) {
                            p.setFavorito(favIds.contains(p.getId()));
                        }
                    }

                    int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

                    request.setAttribute("listaPropiedades", listaPropiedades);
                    request.setAttribute("totalResultados", totalRecords);
                    request.setAttribute("paramQ", keyword);
                    request.setAttribute("paramOperacion", operacion);
                    request.setAttribute("paramTipo", tipoInmueble);
                    request.setAttribute("paramPrecioMin", precioMinStr);
                    request.setAttribute("paramPrecioMax", precioMaxStr);
                    request.setAttribute("paramDormitorios", dormitoriosStr);
                    request.setAttribute("paramBanos", banosStr);
                    request.setAttribute("currentPage", page);
                    request.setAttribute("totalPages", totalPages);

                    request.getRequestDispatcher("/WEB-INF/views/propiedades.jsp").forward(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error procesando la solicitud GET");
        }
    }

    // =========================================================
    // POST — Crear / Editar propiedad con imagen
    // =========================================================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            PropiedadDTO propiedad = new PropiedadDTO();

            // Si hay ID es actualización
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                propiedad.setId(Integer.parseInt(idStr));
            }

            // Datos básicos
            propiedad.setTitulo(request.getParameter("titulo"));
            propiedad.setDescripcion(request.getParameter("descripcion"));
            propiedad.setDireccion(request.getParameter("direccion"));
            propiedad.setPartidaRegistral(request.getParameter("partidaRegistral"));

            // Selects de catálogo
            propiedad.setIdTipoInmueble(Integer.parseInt(request.getParameter("idTipoInmueble")));
            propiedad.setIdOperacion(Integer.parseInt(request.getParameter("idOperacion")));
            propiedad.setIdDistrito(Integer.parseInt(request.getParameter("idDistrito")));

            // Precios
            propiedad.setMonedaBase(request.getParameter("monedaBase"));
            propiedad.setPrecio(new BigDecimal(request.getParameter("precio")));

            // Datos Técnicos
            String areaTotal = request.getParameter("areaTotalM2");
            if (areaTotal != null && !areaTotal.isEmpty()) propiedad.setAreaTotalM2(new BigDecimal(areaTotal));

            String areaTechada = request.getParameter("areaTechadaM2");
            if (areaTechada != null && !areaTechada.isEmpty()) propiedad.setAreaTechadaM2(new BigDecimal(areaTechada));

            String dorm = request.getParameter("numDormitorios");
            if (dorm != null && !dorm.isEmpty()) propiedad.setNumDormitorios(Integer.parseInt(dorm));

            String ban = request.getParameter("numBanos");
            if (ban != null && !ban.isEmpty()) propiedad.setNumBanos(Integer.parseInt(ban));

            String coch = request.getParameter("numCocheras");
            if (coch != null && !coch.isEmpty()) propiedad.setNumCocheras(Integer.parseInt(coch));

            String anio = request.getParameter("anioConstruccion");
            if (anio != null && !anio.isEmpty()) propiedad.setAnioConstruccion(Integer.parseInt(anio));

            // Checkboxes (bonos)
            propiedad.setBonoMiVivienda(request.getParameter("bonoMiVivienda") != null ? 1 : 0);
            propiedad.setBonoVerde(request.getParameter("bonoVerde") != null ? 1 : 0);

            // Sprint 2: Procesar imagen
            try {
                String rutaFoto = procesarImagen(request);
                if (rutaFoto != null) {
                    propiedad.setFotoPrincipal(rutaFoto);
                }
            } catch (ServletException imgError) {
                request.setAttribute("error", imgError.getMessage());
                request.setAttribute("propiedad", propiedad);
                cargarCatalogos(request);
                request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
                return;
            }

            // Validacion de negocio (Sprint 1): Venta mayor a 10,000
            if (propiedad.getIdOperacion() == 1 && propiedad.getPrecio().compareTo(new BigDecimal("10000")) < 0) {
                request.setAttribute("error", "Por políticas de negocio, el precio de Venta debe ser mayor a 10,000.");
                request.setAttribute("propiedad", propiedad);
                cargarCatalogos(request);
                request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
                return;
            }

            boolean exito;
            if (propiedad.getId() > 0) {
                exito = propiedadFacade.actualizarPropiedad(propiedad);
            } else {
                UsuarioDTO usuario = (UsuarioDTO) request.getSession().getAttribute("usuarioLogueado");
                propiedad.setIdUsuarioAgente(usuario != null ? usuario.getIdUsuario() : 1);
                exito = propiedadFacade.registrarPropiedad(propiedad);
            }

            if (exito) {
                UsuarioDTO sessionUser = (UsuarioDTO) request.getSession().getAttribute("usuarioLogueado");
                if (sessionUser != null && (sessionUser.getIdRol() == 3 || sessionUser.getIdRol() == 4 || sessionUser.getIdRol() == 5)) {
                    response.sendRedirect(request.getContextPath() + "/panel");
                } else {
                    response.sendRedirect(request.getContextPath() + "/propiedades");
                }
            } else {
                request.setAttribute("error", "No se pudo guardar la propiedad en la base de datos. Verifica los datos.");
                request.setAttribute("propiedad", propiedad);
                cargarCatalogos(request);
                request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error de formato de datos: " + e.getMessage());
            cargarCatalogos(request);
            request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
        }
    }
}
