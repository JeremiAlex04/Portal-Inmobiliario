package org.example.proyectoweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.proyectoweb.facade.PropiedadFacade;
import org.example.proyectoweb.dto.PropiedadDTO;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/comparar")
public class ComparadorServlet extends HttpServlet {
    private PropiedadFacade propiedadFacade;

    @Override
    public void init() { propiedadFacade = new PropiedadFacade(); }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idsParam = request.getParameter("ids"); // ids=1,2,3
        if (idsParam == null || idsParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/propiedades");
            return;
        }

        String[] ids = idsParam.split(",");
        if (ids.length > 4) {
            response.sendRedirect(request.getContextPath() + "/propiedades?errorComparador=max4");
            return;
        }

        List<PropiedadDTO> propiedades = new ArrayList<>();
        for (String idStr : ids) {
            try {
                int id = Integer.parseInt(idStr.trim());
                PropiedadDTO p = propiedadFacade.obtenerPropiedad(id);
                if (p != null) propiedades.add(p);
            } catch (NumberFormatException ignored) {}
        }

        request.setAttribute("propiedadesComparar", propiedades);
        request.getRequestDispatcher("/WEB-INF/views/comparador.jsp").forward(request, response);
    }
}
