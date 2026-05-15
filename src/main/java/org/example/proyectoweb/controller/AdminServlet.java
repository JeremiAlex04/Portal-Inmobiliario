package org.example.proyectoweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.proyectoweb.dto.UsuarioDTO;
import org.example.proyectoweb.facade.PropiedadFacade;
import org.example.proyectoweb.facade.UsuarioFacade;

import java.io.IOException;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    private UsuarioFacade usuarioFacade;
    private PropiedadFacade propiedadFacade;

    @Override
    public void init() {
        usuarioFacade = new UsuarioFacade();
        propiedadFacade = new PropiedadFacade();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogueado") == null) {
            response.sendRedirect(request.getContextPath() + "/usuario?accion=login");
            return;
        }

        UsuarioDTO usuario = (UsuarioDTO) session.getAttribute("usuarioLogueado");
        
        // Validación de rol (Solo administrador = 5)
        if (usuario.getIdRol() != 5) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado. Se requiere rol de Administrador.");
            return;
        }

        String accion = request.getParameter("accion");
        if (accion == null) accion = "dashboard";

        switch (accion) {
            case "dashboard":
                int totalUsuarios = usuarioFacade.contarUsuariosPorRol(0);
                int totalAgentes = usuarioFacade.contarUsuariosPorRol(3); // Agente
                int totalPropiedades = propiedadFacade.contarPropiedades(null, null, null);
                
                request.setAttribute("totalUsuarios", totalUsuarios);
                request.setAttribute("totalAgentes", totalAgentes);
                request.setAttribute("totalPropiedades", totalPropiedades);
                
                request.getRequestDispatcher("/WEB-INF/views/admin_dashboard.jsp").forward(request, response);
                break;

            case "usuarios":
                request.setAttribute("listaUsuarios", usuarioFacade.listarUsuarios());
                request.getRequestDispatcher("/WEB-INF/views/admin_usuarios.jsp").forward(request, response);
                break;
                
            case "eliminar_usuario":
                int idEliminar = Integer.parseInt(request.getParameter("id"));
                // Validación básica de negocio: No dejar eliminar al propio administrador activo
                if (idEliminar != usuario.getIdUsuario()) {
                    usuarioFacade.eliminarUsuario(idEliminar);
                }
                response.sendRedirect(request.getContextPath() + "/admin?accion=usuarios");
                break;
                
            case "cambiar_estado":
                int idEstado = Integer.parseInt(request.getParameter("id"));
                int nuevoEstado = Integer.parseInt(request.getParameter("estado"));
                if (idEstado != usuario.getIdUsuario()) {
                    usuarioFacade.cambiarEstadoUsuario(idEstado, nuevoEstado);
                }
                response.sendRedirect(request.getContextPath() + "/admin?accion=usuarios");
                break;
                
            case "cambiar_rol":
                int idRolUser = Integer.parseInt(request.getParameter("id"));
                int nuevoRol = Integer.parseInt(request.getParameter("rol"));
                if (idRolUser != usuario.getIdUsuario()) {
                    usuarioFacade.cambiarRolUsuario(idRolUser, nuevoRol);
                }
                response.sendRedirect(request.getContextPath() + "/admin?accion=usuarios");
                break;

            case "propiedades":
                // Listar todas las propiedades, podemos usar buscarPropiedades con límite alto
                request.setAttribute("listaPropiedades", propiedadFacade.listarPropiedades(0, 1000));
                request.getRequestDispatcher("/WEB-INF/views/admin_propiedades.jsp").forward(request, response);
                break;
                
            case "cambiar_estado_prop":
                int idProp = Integer.parseInt(request.getParameter("id"));
                String nuevoEstadoProp = request.getParameter("estado");
                propiedadFacade.cambiarEstadoPropiedad(idProp, nuevoEstadoProp);
                response.sendRedirect(request.getContextPath() + "/admin?accion=propiedades");
                break;
                
            case "eliminar_prop":
                int idEliminarProp = Integer.parseInt(request.getParameter("id"));
                propiedadFacade.eliminarPropiedad(idEliminarProp);
                response.sendRedirect(request.getContextPath() + "/admin?accion=propiedades");
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/admin?accion=dashboard");
                break;
        }
    }
}
