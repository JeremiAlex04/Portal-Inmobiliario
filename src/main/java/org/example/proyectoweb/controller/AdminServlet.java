package org.example.proyectoweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.proyectoweb.dto.UsuarioDTO;
import org.example.proyectoweb.dto.UbicacionDTO;
import org.example.proyectoweb.dto.PropiedadDTO;
import org.example.proyectoweb.facade.PropiedadFacade;
import org.example.proyectoweb.facade.UsuarioFacade;
import org.example.proyectoweb.facade.UbicacionFacade;
import org.example.proyectoweb.facade.AuditoriaFacade;

import java.io.IOException;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    private UsuarioFacade usuarioFacade;
    private PropiedadFacade propiedadFacade;
    private UbicacionFacade ubicacionFacade;
    private AuditoriaFacade auditoriaFacade;

    @Override
    public void init() {
        usuarioFacade = new UsuarioFacade();
        propiedadFacade = new PropiedadFacade();
        ubicacionFacade = new UbicacionFacade();
        auditoriaFacade = new AuditoriaFacade();
    }

    // =========================================================
    // Validación de acceso administrativo (rol = 5)
    // =========================================================
    
    private UsuarioDTO validarAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogueado") == null) {
            response.sendRedirect(request.getContextPath() + "/usuario?accion=login");
            return null;
        }
        UsuarioDTO usuario = (UsuarioDTO) session.getAttribute("usuarioLogueado");
        if (usuario.getIdRol() != 5) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado. Se requiere rol de Administrador.");
            return null;
        }
        return usuario;
    }

    // =========================================================
    // GET — Navegación y listados
    // =========================================================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UsuarioDTO usuario = validarAdmin(request, response);
        if (usuario == null) return;

        String accion = request.getParameter("accion");
        if (accion == null) accion = "dashboard";

        switch (accion) {

            // ---- DASHBOARD ----
            case "dashboard":
                int totalUsuarios = usuarioFacade.contarUsuariosPorRol(0);
                int totalAgentes = usuarioFacade.contarUsuariosPorRol(3);
                int totalPropiedades = propiedadFacade.contarPropiedades(null, null, null);
                int propActivas = usuarioFacade.contarPropiedadesActivas();
                int propVendidas = usuarioFacade.contarPropiedadesVendidas();
                int propPausadas = usuarioFacade.contarPropiedadesPausadas();
                int propBorradores = usuarioFacade.contarPropiedadesBorradores();

                request.setAttribute("totalUsuarios", totalUsuarios);
                request.setAttribute("totalAgentes", totalAgentes);
                request.setAttribute("totalPropiedades", totalPropiedades);
                request.setAttribute("propActivas", propActivas);
                request.setAttribute("propVendidas", propVendidas);
                request.setAttribute("propPausadas", propPausadas);
                request.setAttribute("propBorradores", propBorradores);

                // Últimos 5 usuarios registrados
                request.setAttribute("ultimosUsuarios", usuarioFacade.listarUsuarios());
                // Últimas 5 propiedades publicadas
                request.setAttribute("ultimasPropiedades", propiedadFacade.listarPropiedades(0, 5));

                request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
                break;

            // ---- USUARIOS: Listado con búsqueda ----
            case "usuarios":
                String filtro = request.getParameter("filtro");
                String busqueda = request.getParameter("busqueda");

                if (filtro != null && busqueda != null && !busqueda.trim().isEmpty()) {
                    request.setAttribute("listaUsuarios", usuarioFacade.buscarUsuarios(filtro, busqueda.trim()));
                    request.setAttribute("filtroActual", filtro);
                    request.setAttribute("busquedaActual", busqueda);
                } else {
                    request.setAttribute("listaUsuarios", usuarioFacade.listarUsuarios());
                }
                request.getRequestDispatcher("/WEB-INF/views/admin/usuarios.jsp").forward(request, response);
                break;

            // ---- USUARIOS: Eliminar ----
            case "eliminar_usuario":
                int idEliminar = Integer.parseInt(request.getParameter("id"));
                if (idEliminar != usuario.getIdUsuario()) {
                    UsuarioDTO targetUser = usuarioFacade.obtenerUsuarioPorId(idEliminar);
                    boolean deleted = usuarioFacade.eliminarUsuario(idEliminar);
                    if (deleted && targetUser != null) {
                        String det = "{\"correo\":\"" + targetUser.getCorreo() + "\",\"nombre\":\"" + targetUser.getNombres() + " " + targetUser.getApellidos() + "\"}";
                        auditoriaFacade.registrarEvento(usuario.getIdUsuario(), "usuario", idEliminar, "ELIMINAR", request.getRemoteAddr(), request.getHeader("User-Agent"), det);
                    }
                }
                response.sendRedirect(request.getContextPath() + "/admin?accion=usuarios");
                break;

            // ---- USUARIOS: Cambiar estado ----
            case "cambiar_estado":
                int idEstado = Integer.parseInt(request.getParameter("id"));
                int nuevoEstado = Integer.parseInt(request.getParameter("estado"));
                if (idEstado != usuario.getIdUsuario()) {
                    UsuarioDTO targetUser = usuarioFacade.obtenerUsuarioPorId(idEstado);
                    boolean changed = usuarioFacade.cambiarEstadoUsuario(idEstado, nuevoEstado);
                    if (changed && targetUser != null) {
                        String det = "{\"correo\":\"" + targetUser.getCorreo() + "\",\"activo\":" + nuevoEstado + "}";
                        auditoriaFacade.registrarEvento(usuario.getIdUsuario(), "usuario", idEstado, "ACTUALIZAR", request.getRemoteAddr(), request.getHeader("User-Agent"), det);
                    }
                }
                response.sendRedirect(request.getContextPath() + "/admin?accion=usuarios");
                break;

            // ---- USUARIOS: Cambiar rol ----
            case "cambiar_rol":
                int idRolUser = Integer.parseInt(request.getParameter("id"));
                int nuevoRol = Integer.parseInt(request.getParameter("rol"));
                if (idRolUser != usuario.getIdUsuario()) {
                    UsuarioDTO targetUser = usuarioFacade.obtenerUsuarioPorId(idRolUser);
                    boolean changed = usuarioFacade.cambiarRolUsuario(idRolUser, nuevoRol);
                    if (changed && targetUser != null) {
                        String det = "{\"correo\":\"" + targetUser.getCorreo() + "\",\"rol_nuevo\":" + nuevoRol + ",\"rol_anterior\":" + targetUser.getIdRol() + "}";
                        auditoriaFacade.registrarEvento(usuario.getIdUsuario(), "usuario", idRolUser, "ACTUALIZAR", request.getRemoteAddr(), request.getHeader("User-Agent"), det);
                    }
                }
                response.sendRedirect(request.getContextPath() + "/admin?accion=usuarios");
                break;

            // ---- PROPIEDADES: Listado con búsqueda ----
            case "propiedades":
                String keyProp = request.getParameter("busqueda");
                String operacion = request.getParameter("operacion");
                String tipoProp = request.getParameter("tipoInmueble");

                if ((keyProp != null && !keyProp.trim().isEmpty()) || (operacion != null && !operacion.isEmpty()) || (tipoProp != null && !tipoProp.isEmpty())) {
                    request.setAttribute("listaPropiedades", propiedadFacade.buscarPropiedadesAdmin(keyProp, operacion, tipoProp, 0, 1000));
                    request.setAttribute("busquedaActual", keyProp);
                    request.setAttribute("operacionActual", operacion);
                    request.setAttribute("tipoActual", tipoProp);
                } else {
                    request.setAttribute("listaPropiedades", propiedadFacade.listarPropiedadesAdmin(0, 1000));
                }
                request.getRequestDispatcher("/WEB-INF/views/admin/propiedades.jsp").forward(request, response);
                break;

            // ---- PROPIEDADES: Cambiar estado ----
            case "cambiar_estado_prop":
                int idProp = Integer.parseInt(request.getParameter("id"));
                String nuevoEstadoProp = request.getParameter("estado");
                PropiedadDTO targetProp = propiedadFacade.obtenerPropiedad(idProp);
                boolean changedProp = propiedadFacade.cambiarEstadoPropiedad(idProp, nuevoEstadoProp);
                if (changedProp && targetProp != null) {
                    String det = "{\"titulo\":\"" + targetProp.getTitulo().replace("\"", "\\\"") + "\",\"estado_nuevo\":\"" + nuevoEstadoProp + "\",\"estado_anterior\":\"" + targetProp.getEstado() + "\"}";
                    auditoriaFacade.registrarEvento(usuario.getIdUsuario(), "propiedad", idProp, "ACTUALIZAR", request.getRemoteAddr(), request.getHeader("User-Agent"), det);
                }
                response.sendRedirect(request.getContextPath() + "/admin?accion=propiedades");
                break;

            // ---- PROPIEDADES: Eliminar ----
            case "eliminar_prop":
                int idEliminarProp = Integer.parseInt(request.getParameter("id"));
                PropiedadDTO targetPropDel = propiedadFacade.obtenerPropiedad(idEliminarProp);
                boolean deletedProp = propiedadFacade.eliminarPropiedad(idEliminarProp);
                if (deletedProp && targetPropDel != null) {
                    String det = "{\"titulo\":\"" + targetPropDel.getTitulo().replace("\"", "\\\"") + "\"}";
                    auditoriaFacade.registrarEvento(usuario.getIdUsuario(), "propiedad", idEliminarProp, "ELIMINAR", request.getRemoteAddr(), request.getHeader("User-Agent"), det);
                }
                response.sendRedirect(request.getContextPath() + "/admin?accion=propiedades");
                break;

            // ---- UBICACIONES: Listado ----
            case "ubicaciones":
                String tipo = request.getParameter("tipo");
                if (tipo == null) tipo = "DEPARTAMENTO";

                request.setAttribute("tipoActual", tipo);
                request.setAttribute("listaUbicaciones", ubicacionFacade.listarUbicaciones(tipo));

                if ("PROVINCIA".equals(tipo)) {
                    request.setAttribute("listaPadres", ubicacionFacade.listarUbicaciones("DEPARTAMENTO"));
                } else if ("DISTRITO".equals(tipo)) {
                    request.setAttribute("listaPadres", ubicacionFacade.listarUbicaciones("PROVINCIA"));
                }

                request.getRequestDispatcher("/WEB-INF/views/admin/ubicaciones.jsp").forward(request, response);
                break;

            // ---- UBICACIONES: Eliminar ----
            case "eliminar_ubicacion":
                int idUbi = Integer.parseInt(request.getParameter("id"));
                String tipoDel = request.getParameter("tipo");
                ubicacionFacade.eliminarUbicacion(idUbi, tipoDel);
                response.sendRedirect(request.getContextPath() + "/admin?accion=ubicaciones&tipo=" + tipoDel);
                break;

            // ---- AUDITORIA: Panel de logs ----
            case "auditoria":
                request.setAttribute("listaEventos", auditoriaFacade.listarEventos());
                request.getRequestDispatcher("/WEB-INF/views/admin/auditoria.jsp").forward(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/admin?accion=dashboard");
                break;
        }
    }

    // =========================================================
    // POST — Formularios de creación/edición
    // =========================================================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UsuarioDTO admin = validarAdmin(request, response);
        if (admin == null) return;

        String accion = request.getParameter("accion");
        if (accion == null) accion = "";

        switch (accion) {

            // ---- USUARIOS: Registrar nuevo desde admin ----
            case "registrar_usuario":
                UsuarioDTO nuevo = new UsuarioDTO();
                nuevo.setNombres(request.getParameter("nombres"));
                nuevo.setApellidos(request.getParameter("apellidos"));
                nuevo.setCorreo(request.getParameter("correo"));
                nuevo.setPasswordHash(request.getParameter("password"));
                nuevo.setIdRol(Integer.parseInt(request.getParameter("idRol")));

                boolean regUser = usuarioFacade.registrarUsuario(nuevo);
                if (regUser) {
                    String det = "{\"correo\":\"" + nuevo.getCorreo() + "\",\"rol\":" + nuevo.getIdRol() + "}";
                    auditoriaFacade.registrarEvento(admin.getIdUsuario(), "usuario", 0, "CREAR", request.getRemoteAddr(), request.getHeader("User-Agent"), det);
                }
                response.sendRedirect(request.getContextPath() + "/admin?accion=usuarios");
                break;

            // ---- USUARIOS: Editar existente ----
            case "editar_usuario":
                UsuarioDTO editar = new UsuarioDTO();
                editar.setIdUsuario(Integer.parseInt(request.getParameter("id")));
                editar.setNombres(request.getParameter("nombres"));
                editar.setApellidos(request.getParameter("apellidos"));
                editar.setCorreo(request.getParameter("correo"));

                boolean edUser = usuarioFacade.editarUsuario(editar);
                if (edUser) {
                    String det = "{\"correo\":\"" + editar.getCorreo() + "\"}";
                    auditoriaFacade.registrarEvento(admin.getIdUsuario(), "usuario", editar.getIdUsuario(), "ACTUALIZAR", request.getRemoteAddr(), request.getHeader("User-Agent"), det);
                }
                response.sendRedirect(request.getContextPath() + "/admin?accion=usuarios");
                break;

            // ---- UBICACIONES: Guardar (crear o editar) ----
            case "guardar_ubicacion":
                UbicacionDTO u = new UbicacionDTO();
                String idStr = request.getParameter("id");
                String tipoU = request.getParameter("tipo");

                u.setTipo(tipoU);
                u.setNombre(request.getParameter("nombre"));
                u.setCodigoUbigeo(request.getParameter("codigoUbigeo"));

                String parentIdStr = request.getParameter("parentId");
                if (parentIdStr != null && !parentIdStr.isEmpty()) {
                    u.setParentId(Integer.parseInt(parentIdStr));
                }

                if (idStr == null || idStr.isEmpty()) {
                    ubicacionFacade.registrarUbicacion(u);
                } else {
                    u.setId(Integer.parseInt(idStr));
                    ubicacionFacade.editarUbicacion(u);
                }

                response.sendRedirect(request.getContextPath() + "/admin?accion=ubicaciones&tipo=" + tipoU);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/admin?accion=dashboard");
                break;
        }
    }
}
