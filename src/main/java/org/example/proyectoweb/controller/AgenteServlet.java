package org.example.proyectoweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.proyectoweb.dto.PropiedadDTO;
import org.example.proyectoweb.dto.UsuarioDTO;
import org.example.proyectoweb.facade.PropiedadFacade;
import org.example.proyectoweb.facade.UsuarioFacade;

import java.io.IOException;
import java.util.List;

@WebServlet("/agente")
public class AgenteServlet extends HttpServlet {

    private UsuarioFacade usuarioFacade;
    private PropiedadFacade propiedadFacade;

    @Override
    public void init() {
        usuarioFacade = new UsuarioFacade();
        propiedadFacade = new PropiedadFacade();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/propiedades");
            return;
        }

        try {
            int idAgente = Integer.parseInt(idStr);
            UsuarioDTO agente = usuarioFacade.obtenerUsuarioPorId(idAgente);

            if (agente == null || (agente.getIdRol() != 3 && agente.getIdRol() != 4)) {
                // If not found or not an agent/constructor
                response.sendRedirect(request.getContextPath() + "/propiedades");
                return;
            }

            // Only get ACTIVO properties for the public profile
            List<PropiedadDTO> propiedades = propiedadFacade.obtenerPropiedadesAgenteConFiltros(idAgente, "ACTIVO", "recientes");

            request.setAttribute("agente", agente);
            request.setAttribute("propiedades", propiedades);
            request.getRequestDispatcher("/WEB-INF/views/perfil_agente.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/propiedades");
        }
    }
}
