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
public class PropiedadServlet extends HttpServlet {

    private PropiedadFacade propiedadFacade;
    private FavoritoFacade favoritoFacade;
    private EstadisticaDAO estadisticaDAO;
    private GaleriaDAO galeriaDAO;
    private org.example.proyectoweb.facade.AuditoriaFacade auditoriaFacade;

    // Extensiones permitidas para fotos
    private static final List<String> EXTENSIONES_PERMITIDAS = Arrays.asList("jpg", "jpeg", "png", "webp");

    @Override
    public void init() throws ServletException {
        propiedadFacade = new PropiedadFacade();
        favoritoFacade = new FavoritoFacade();
        estadisticaDAO = new EstadisticaDAO();
        galeriaDAO = new GaleriaDAO();
        auditoriaFacade = new org.example.proyectoweb.facade.AuditoriaFacade();
    }

    private void cargarCatalogos(HttpServletRequest request) {
        request.setAttribute("listaDistritos", propiedadFacade.obtenerDistritos());
        request.setAttribute("listaTipos", propiedadFacade.obtenerTiposInmueble());
        request.setAttribute("listaOperaciones", propiedadFacade.obtenerOperaciones());
    }

    // =========================================================
    // =========================================================
    // Utilidad: Las imágenes físicas fueron reemplazadas por URLs dinámicas
    // =========================================================

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
                case "nuevo": {
                    UsuarioDTO usuario = (UsuarioDTO) request.getSession().getAttribute("usuarioLogueado");
                    if (usuario == null) {
                        request.setAttribute("error", "Por favor, inicia sesión para publicar una propiedad.");
                        request.getRequestDispatcher("/WEB-INF/views/public/login.jsp").forward(request, response);
                        return;
                    }
                    if (usuario.getIdRol() != 3 && usuario.getIdRol() != 4 && usuario.getIdRol() != 5) {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado. Se requiere cuenta de Agente o Constructora.");
                        return;
                    }
                    cargarCatalogos(request);
                    request.getRequestDispatcher("/WEB-INF/views/agente/registro.jsp").forward(request, response);
                    break;
                }

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
                        request.getRequestDispatcher("/WEB-INF/views/public/detalle_propiedad.jsp").forward(request, response);
                    } else {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Propiedad no encontrada");
                    }
                    break;

                case "editar": {
                    UsuarioDTO usuario = (UsuarioDTO) request.getSession().getAttribute("usuarioLogueado");
                    if (usuario == null) {
                        request.setAttribute("error", "Por favor, inicia sesión para editar una propiedad.");
                        request.getRequestDispatcher("/WEB-INF/views/public/login.jsp").forward(request, response);
                        return;
                    }
                    int idEditar = Integer.parseInt(request.getParameter("id"));
                    PropiedadDTO pEditar = propiedadFacade.obtenerPropiedad(idEditar);
                    
                    if (pEditar == null) {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Propiedad no encontrada");
                        return;
                    }

                    // Validar que el usuario sea el dueño o administrador
                    if (usuario.getIdRol() != 5 && pEditar.getIdUsuarioAgente() != usuario.getIdUsuario()) {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN, "No tienes permiso para editar esta propiedad.");
                        return;
                    }

                    request.setAttribute("propiedad", pEditar);
                    // Sprint 3: Cargar galería para edición
                    request.setAttribute("galeriaFotos", galeriaDAO.obtenerFotos(idEditar));
                    cargarCatalogos(request);
                    request.getRequestDispatcher("/WEB-INF/views/agente/registro.jsp").forward(request, response);
                    break;
                }

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

                    request.getRequestDispatcher("/WEB-INF/views/public/propiedades.jsp").forward(request, response);
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
            // ---- ELIMINAR propiedad (POST — operación destructiva) ----
            String accionPost = request.getParameter("accion");
            if ("eliminar".equals(accionPost)) {
                UsuarioDTO sessionUser = (UsuarioDTO) request.getSession().getAttribute("usuarioLogueado");
                if (sessionUser == null) {
                    request.setAttribute("error", "Por favor, inicia sesión para eliminar una propiedad.");
                    request.getRequestDispatcher("/WEB-INF/views/public/login.jsp").forward(request, response);
                    return;
                }
                int idEliminar = Integer.parseInt(request.getParameter("id"));
                PropiedadDTO pDel = propiedadFacade.obtenerPropiedad(idEliminar);

                if (pDel == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Propiedad no encontrada");
                    return;
                }

                // Validar permisos
                if (sessionUser.getIdRol() != 5 && pDel.getIdUsuarioAgente() != sessionUser.getIdUsuario()) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "No tienes permiso para eliminar esta propiedad.");
                    return;
                }

                propiedadFacade.eliminarPropiedad(idEliminar);
                String details = "{\"titulo\":\"" + pDel.getTitulo().replace("\"", "\\\"") + "\",\"precio\":" + pDel.getPrecio() + ",\"moneda\":\"" + pDel.getMonedaBase() + "\"}";
                auditoriaFacade.registrarEvento(sessionUser.getIdUsuario(), "propiedad", idEliminar, "ELIMINAR", request.getRemoteAddr(), request.getHeader("User-Agent"), details);

                if (sessionUser.getIdRol() == 3 || sessionUser.getIdRol() == 4 || sessionUser.getIdRol() == 5) {
                    response.sendRedirect(request.getContextPath() + "/panel");
                } else {
                    response.sendRedirect(request.getContextPath() + "/propiedades");
                }
                return;
            }

            // ---- CREAR / EDITAR propiedad ----
            UsuarioDTO usuario = (UsuarioDTO) request.getSession().getAttribute("usuarioLogueado");
            if (usuario == null) {
                request.setAttribute("error", "Sesión inválida o expirada. Por favor, inicia sesión.");
                request.getRequestDispatcher("/WEB-INF/views/public/login.jsp").forward(request, response);
                return;
            }
            if (usuario.getIdRol() != 3 && usuario.getIdRol() != 4 && usuario.getIdRol() != 5) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "No tienes permiso para realizar esta acción.");
                return;
            }
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

            // Coordenadas
            String latStr = request.getParameter("latitud");
            if (latStr != null && !latStr.isEmpty()) {
                propiedad.setLatitud(new BigDecimal(latStr));
            }
            String lngStr = request.getParameter("longitud");
            if (lngStr != null && !lngStr.isEmpty()) {
                propiedad.setLongitud(new BigDecimal(lngStr));
            }

            // Datos de Consistencia de BD
            propiedad.setReferencia(request.getParameter("referencia"));
            String numPisosStr = request.getParameter("numPisos");
            if (numPisosStr != null && !numPisosStr.isEmpty()) {
                propiedad.setNumPisos(Integer.parseInt(numPisosStr));
            }
            propiedad.setTour360Url(request.getParameter("tour360Url"));

            // Procesar URL de la foto principal
            String fotoPrincipal = request.getParameter("fotoPrincipalUrl");
            propiedad.setFotoPrincipal(fotoPrincipal != null && !fotoPrincipal.trim().isEmpty() ? fotoPrincipal.trim() : null);

            // Obtener URLs de la galería
            String[] fotosGaleria = request.getParameterValues("fotoGaleriaUrl");

            // Validacion de negocio (Sprint 1): Venta mayor a 10,000
            if (propiedad.getIdOperacion() == 1 && propiedad.getPrecio().compareTo(new BigDecimal("10000")) < 0) {
                request.setAttribute("error", "Por políticas de negocio, el precio de Venta debe ser mayor a 10,000.");
                request.setAttribute("propiedad", propiedad);
                cargarCatalogos(request);
                request.getRequestDispatcher("/WEB-INF/views/agente/registro.jsp").forward(request, response);
                return;
            }

            boolean exito;
            boolean esNuevo = (propiedad.getId() <= 0);
            PropiedadDTO oldProp = null;

            if (!esNuevo) {
                oldProp = propiedadFacade.obtenerPropiedad(propiedad.getId());
                if (oldProp == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Propiedad no encontrada");
                    return;
                }
                // Validar que el usuario sea el dueño o administrador
                if (usuario.getIdRol() != 5 && oldProp.getIdUsuarioAgente() != usuario.getIdUsuario()) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "No tienes permiso para actualizar esta propiedad.");
                    return;
                }
                propiedad.setIdUsuarioAgente(oldProp.getIdUsuarioAgente());
                exito = propiedadFacade.actualizarPropiedad(propiedad);
            } else {
                int idAgente = usuario.getIdUsuario();
                int activeCount = propiedadFacade.contarPropiedadesActivas(idAgente);
                int limit = propiedadFacade.obtenerLimitePublicaciones(idAgente);
                if (activeCount >= limit) {
                    request.setAttribute("error", "Límite de publicaciones alcanzado (" + limit + " activo/s). Por favor, actualiza tu plan en la sección Suscripciones.");
                    request.setAttribute("propiedad", propiedad);
                    cargarCatalogos(request);
                    request.getRequestDispatcher("/WEB-INF/views/agente/registro.jsp").forward(request, response);
                    return;
                }
                propiedad.setIdUsuarioAgente(idAgente);
                exito = propiedadFacade.registrarPropiedad(propiedad);
            }

            if (exito) {
                // Guardar las fotos secundarias en la galería (persistencia de URLs)
                if (!esNuevo) {
                    galeriaDAO.eliminarFotosPorPropiedad(propiedad.getId());
                }
                if (fotosGaleria != null) {
                    int orden = 0;
                    for (String url : fotosGaleria) {
                        if (url != null && !url.trim().isEmpty()) {
                            PropiedadFotoDTO foto = new PropiedadFotoDTO();
                            foto.setIdPropiedad(propiedad.getId());
                            foto.setRutaArchivo(url.trim());
                            foto.setOrden(orden++);
                            foto.setEsPrincipal(false);
                            galeriaDAO.agregarFoto(foto);
                        }
                    }
                }

                if (usuario != null) {
                    String details;
                    if (esNuevo) {
                        details = "{\"titulo\":\"" + propiedad.getTitulo().replace("\"", "\\\"") + "\",\"precio\":" + propiedad.getPrecio() + ",\"moneda\":\"" + propiedad.getMonedaBase() + "\"}";
                        auditoriaFacade.registrarEvento(usuario.getIdUsuario(), "propiedad", propiedad.getId(), "CREAR", request.getRemoteAddr(), request.getHeader("User-Agent"), details);
                    } else {
                        // Comparación de precio
                        boolean cambioSignificativo = false;
                        BigDecimal pct = BigDecimal.ZERO;
                        if (oldProp != null) {
                            BigDecimal oldPrice = oldProp.getPrecio();
                            BigDecimal newPrice = propiedad.getPrecio();
                            
                            if (oldProp.getMonedaBase().equals(propiedad.getMonedaBase())) {
                                BigDecimal diff = newPrice.subtract(oldPrice).abs();
                                if (oldPrice.compareTo(BigDecimal.ZERO) > 0) {
                                    pct = diff.divide(oldPrice, 4, java.math.RoundingMode.HALF_UP);
                                }
                            } else {
                                BigDecimal oldUsd = oldProp.getPrecioUsd();
                                BigDecimal tc = oldProp.getTipoCambioVenta() != null ? oldProp.getTipoCambioVenta() : new BigDecimal("3.75");
                                BigDecimal newUsd = propiedad.getMonedaBase().equals("USD") ? propiedad.getPrecio() : propiedad.getPrecio().divide(tc, 4, java.math.RoundingMode.HALF_UP);
                                BigDecimal diff = newUsd.subtract(oldUsd).abs();
                                if (oldUsd.compareTo(BigDecimal.ZERO) > 0) {
                                    pct = diff.divide(oldUsd, 4, java.math.RoundingMode.HALF_UP);
                                }
                            }
                            if (pct.compareTo(new BigDecimal("0.20")) > 0) {
                                cambioSignificativo = true;
                            }
                        }

                        if (cambioSignificativo) {
                            details = "{\"titulo\":\"" + propiedad.getTitulo().replace("\"", "\\\"") + "\",\"cambio_precio_20_pct\":true,\"precio_anterior\":" + oldProp.getPrecio() + ",\"moneda_anterior\":\"" + oldProp.getMonedaBase() + "\",\"precio_nuevo\":" + propiedad.getPrecio() + ",\"moneda_nueva\":\"" + propiedad.getMonedaBase() + "\",\"porcentaje\":" + pct.multiply(new BigDecimal("100")).setScale(2, java.math.RoundingMode.HALF_UP) + "}";
                        } else {
                            details = "{\"titulo\":\"" + propiedad.getTitulo().replace("\"", "\\\"") + "\",\"precio\":" + propiedad.getPrecio() + ",\"moneda\":\"" + propiedad.getMonedaBase() + "\"}";
                        }
                        auditoriaFacade.registrarEvento(usuario.getIdUsuario(), "propiedad", propiedad.getId(), "ACTUALIZAR", request.getRemoteAddr(), request.getHeader("User-Agent"), details);
                    }
                }

                if (usuario != null && usuario.getIdRol() == 5) {
                    response.sendRedirect(request.getContextPath() + "/admin?accion=propiedades");
                } else if (usuario != null && (usuario.getIdRol() == 3 || usuario.getIdRol() == 4)) {
                    response.sendRedirect(request.getContextPath() + "/panel");
                } else {
                    response.sendRedirect(request.getContextPath() + "/propiedades");
                }
            } else {
                request.setAttribute("error", "No se pudo guardar la propiedad en la base de datos. Verifica los datos.");
                request.setAttribute("propiedad", propiedad);
                cargarCatalogos(request);
                request.getRequestDispatcher("/WEB-INF/views/agente/registro.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error de formato de datos: " + e.getMessage());
            cargarCatalogos(request);
            request.getRequestDispatcher("/WEB-INF/views/agente/registro.jsp").forward(request, response);
        }
    }
}
