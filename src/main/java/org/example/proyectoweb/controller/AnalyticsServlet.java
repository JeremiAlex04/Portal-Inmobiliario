package org.example.proyectoweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.proyectoweb.dao.EstadisticaDAO;
import org.example.proyectoweb.dao.GaleriaDAO;
import org.example.proyectoweb.dto.EstadisticaDiariaDTO;
import org.example.proyectoweb.dto.UsuarioDTO;
import org.example.proyectoweb.facade.PropiedadFacade;
import org.example.proyectoweb.dto.PropiedadDTO;

import java.io.IOException;
import java.util.List;

@WebServlet("/analytics")
public class AnalyticsServlet extends HttpServlet {
    private EstadisticaDAO estadisticaDAO;
    private PropiedadFacade propiedadFacade;

    @Override
    public void init() {
        estadisticaDAO = new EstadisticaDAO();
        propiedadFacade = new PropiedadFacade();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UsuarioDTO user = (UsuarioDTO) request.getSession().getAttribute("usuarioLogueado");
        if (user == null || (user.getIdRol() != 3 && user.getIdRol() != 4 && user.getIdRol() != 5)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        int idPropiedad = Integer.parseInt(request.getParameter("id"));
        PropiedadDTO propiedad = propiedadFacade.obtenerPropiedad(idPropiedad);

        List<EstadisticaDiariaDTO> vistas30d = estadisticaDAO.obtenerVistas30Dias(idPropiedad);
        int totalVistas = estadisticaDAO.obtenerTotalVistas(idPropiedad);

        // Calcular promedios
        int sumVistas = 0;
        int maxVistas = 0;
        String diaMax = "";
        for (EstadisticaDiariaDTO e : vistas30d) {
            sumVistas += e.getNumVistas();
            if (e.getNumVistas() > maxVistas) {
                maxVistas = e.getNumVistas();
                diaMax = e.getFecha();
            }
        }
        double promedioDiario = vistas30d.isEmpty() ? 0 : (double) sumVistas / vistas30d.size();
        double promedioDistrito = propiedad != null ? estadisticaDAO.obtenerPromedioDistrito(propiedad.getIdDistrito()) : 0;

        // Generar JSON para Chart.js
        StringBuilder labelsJson = new StringBuilder("[");
        StringBuilder dataJson = new StringBuilder("[");
        for (int i = 0; i < vistas30d.size(); i++) {
            if (i > 0) { labelsJson.append(","); dataJson.append(","); }
            labelsJson.append("\"").append(vistas30d.get(i).getFecha()).append("\"");
            dataJson.append(vistas30d.get(i).getNumVistas());
        }
        labelsJson.append("]");
        dataJson.append("]");

        request.setAttribute("propiedad", propiedad);
        request.setAttribute("totalVistas", totalVistas);
        request.setAttribute("promedioDiario", String.format("%.1f", promedioDiario));
        request.setAttribute("diaMax", diaMax);
        request.setAttribute("maxVistas", maxVistas);
        request.setAttribute("promedioDistrito", String.format("%.1f", promedioDistrito));
        request.setAttribute("labelsJson", labelsJson.toString());
        request.setAttribute("dataJson", dataJson.toString());

        request.getRequestDispatcher("/WEB-INF/views/analytics.jsp").forward(request, response);
    }
}
