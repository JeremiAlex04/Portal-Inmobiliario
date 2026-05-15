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
        
        // Validación de rol (Solo agentes = 3 o admin = 5)
        if (usuario.getIdRol() != 3 && usuario.getIdRol() != 4 && usuario.getIdRol() != 5) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado. Se requiere rol de Agente.");
            return;
        }

        List<PropiedadDTO> lista = propiedadFacade.obtenerPropiedadesPorAgente(usuario.getIdUsuario());
        request.setAttribute("listaMisPropiedades", lista);
        request.getRequestDispatcher("/WEB-INF/views/panel_agente.jsp").forward(request, response);
    }
}
