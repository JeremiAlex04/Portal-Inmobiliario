package org.example.proyectoweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.proyectoweb.dto.UsuarioDTO;
import org.example.proyectoweb.dto.PropiedadDTO;
import org.example.proyectoweb.facade.PropiedadFacade;

import java.io.IOException;
import java.util.List;

@WebServlet("/panel")
public class PanelAgenteServlet extends HttpServlet {
    private PropiedadFacade propiedadFacade;

    @Override
    public void init() {
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
        
        // Validación de rol (Solo agentes = 3, constructoras = 4, o admin = 5)
        if (usuario.getIdRol() != 3 && usuario.getIdRol() != 4 && usuario.getIdRol() != 5) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado. Se requiere rol de Agente.");
            return;
        }

        // Sprint 2: Capturar filtros
        String estado = request.getParameter("estado");  // ACTIVO, BORRADOR, VENDIDO, etc.
        String orden = request.getParameter("orden");    // "fecha" o "vistas"

        List<PropiedadDTO> lista = propiedadFacade.obtenerPropiedadesAgenteConFiltros(
                usuario.getIdUsuario(), estado, orden);

        request.setAttribute("listaMisPropiedades", lista);
        request.setAttribute("filtroEstado", estado);
        request.setAttribute("filtroOrden", orden);
        request.getRequestDispatcher("/WEB-INF/views/panel_agente.jsp").forward(request, response);
    }
}
