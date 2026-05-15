package org.example.proyectoweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.proyectoweb.facade.PropiedadFacade;
import org.example.proyectoweb.dto.PropiedadDTO;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "PropiedadServlet", urlPatterns = { "/propiedades" })
public class PropiedadServlet extends HttpServlet {

    private PropiedadFacade propiedadFacade;

    @Override
    public void init() throws ServletException {
        // Inicializa el Facade una sola vez al cargar el Servlet (No se instancia el
        // DAO directamente)
        propiedadFacade = new PropiedadFacade();
    }

    private void cargarCatalogos(HttpServletRequest request) {
        request.setAttribute("listaDistritos", propiedadFacade.obtenerDistritos());
        request.setAttribute("listaTipos", propiedadFacade.obtenerTiposInmueble());
        request.setAttribute("listaOperaciones", propiedadFacade.obtenerOperaciones());
    }

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
                    PropiedadDTO pVer = propiedadFacade.obtenerPropiedad(idVer);
                    if (pVer != null) {
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
                    cargarCatalogos(request);
                    request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
                    break;
                case "eliminar":
                    // Elimina la propiedad y redirige a la lista
                    int idEliminar = Integer.parseInt(request.getParameter("id"));
                    propiedadFacade.eliminarPropiedad(idEliminar);
                    org.example.proyectoweb.dto.UsuarioDTO sessionUser = (org.example.proyectoweb.dto.UsuarioDTO) request.getSession().getAttribute("usuarioLogueado");
                    if (sessionUser != null && (sessionUser.getIdRol() == 3 || sessionUser.getIdRol() == 4 || sessionUser.getIdRol() == 5)) {
                        response.sendRedirect(request.getContextPath() + "/panel");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/propiedades");
                    }
                    break;
                case "listar":
                default:
                    // Capturar parámetros de búsqueda
                    String keyword = request.getParameter("q");
                    String operacion = request.getParameter("operacion");
                    String tipoInmueble = request.getParameter("tipo");

                    // Paginación
                    int page = 1;
                    int recordsPerPage = 10;
                    if (request.getParameter("page") != null) {
                        try {
                            page = Integer.parseInt(request.getParameter("page"));
                        } catch (NumberFormatException e) {
                            page = 1;
                        }
                    }
                    int offset = (page - 1) * recordsPerPage;

                    List<PropiedadDTO> listaPropiedades;
                    int totalRecords = 0;

                    if (keyword != null || operacion != null || tipoInmueble != null) {
                        listaPropiedades = propiedadFacade.buscarPropiedades(keyword, operacion, tipoInmueble, offset, recordsPerPage);
                        totalRecords = propiedadFacade.contarPropiedades(keyword, operacion, tipoInmueble);
                    } else {
                        listaPropiedades = propiedadFacade.listarPropiedades(offset, recordsPerPage);
                        totalRecords = propiedadFacade.contarPropiedades(null, null, null);
                    }

                    int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

                    request.setAttribute("listaPropiedades", listaPropiedades);
                    request.setAttribute("paramQ", keyword);
                    request.setAttribute("paramOperacion", operacion);
                    request.setAttribute("paramTipo", tipoInmueble);
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
            if (areaTotal != null && !areaTotal.isEmpty())
                propiedad.setAreaTotalM2(new BigDecimal(areaTotal));

            String areaTechada = request.getParameter("areaTechadaM2");
            if (areaTechada != null && !areaTechada.isEmpty())
                propiedad.setAreaTechadaM2(new BigDecimal(areaTechada));

            String dormitorios = request.getParameter("numDormitorios");
            if (dormitorios != null && !dormitorios.isEmpty())
                propiedad.setNumDormitorios(Integer.parseInt(dormitorios));

            String banos = request.getParameter("numBanos");
            if (banos != null && !banos.isEmpty())
                propiedad.setNumBanos(Integer.parseInt(banos));

            String cocheras = request.getParameter("numCocheras");
            if (cocheras != null && !cocheras.isEmpty())
                propiedad.setNumCocheras(Integer.parseInt(cocheras));

            String anio = request.getParameter("anioConstruccion");
            if (anio != null && !anio.isEmpty())
                propiedad.setAnioConstruccion(Integer.parseInt(anio));

            // Checkboxes (bonos)
            propiedad.setBonoMiVivienda(request.getParameter("bonoMiVivienda") != null ? 1 : 0);
            propiedad.setBonoVerde(request.getParameter("bonoVerde") != null ? 1 : 0);

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
                // Registrar nueva propiedad
                // Obtener ID de agente logueado. Como fallback ponemos 1
                org.example.proyectoweb.dto.UsuarioDTO usuario = (org.example.proyectoweb.dto.UsuarioDTO) request
                        .getSession().getAttribute("usuarioLogueado");
                propiedad.setIdUsuarioAgente(usuario != null ? usuario.getIdUsuario() : 1);

                exito = propiedadFacade.registrarPropiedad(propiedad);
            }

            if (exito) {
                org.example.proyectoweb.dto.UsuarioDTO sessionUser = (org.example.proyectoweb.dto.UsuarioDTO) request.getSession().getAttribute("usuarioLogueado");
                if (sessionUser != null && (sessionUser.getIdRol() == 3 || sessionUser.getIdRol() == 4 || sessionUser.getIdRol() == 5)) {
                    response.sendRedirect(request.getContextPath() + "/panel");
                } else {
                    response.sendRedirect(request.getContextPath() + "/propiedades");
                }
            } else {
                request.setAttribute("error",
                        "No se pudo guardar la propiedad en la base de datos. Verifica los datos.");
                request.setAttribute("propiedad", propiedad);
                cargarCatalogos(request);
                request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error de formato de datos: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
        }
    }
}
