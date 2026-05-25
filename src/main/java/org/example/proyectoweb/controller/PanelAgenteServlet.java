package org.example.proyectoweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.proyectoweb.dto.UsuarioDTO;
import org.example.proyectoweb.dto.PropiedadDTO;
import org.example.proyectoweb.dto.ConsultaDTO;
import org.example.proyectoweb.facade.PropiedadFacade;
import org.example.proyectoweb.dao.ConsultaDAO;
import org.example.proyectoweb.dao.WhatsAppDAO;

import java.io.IOException;
import java.util.List;

@WebServlet("/panel")
public class PanelAgenteServlet extends HttpServlet {
    private PropiedadFacade propiedadFacade;
    private ConsultaDAO consultaDAO;
    private WhatsAppDAO whatsAppDAO;

    @Override
    public void init() {
        propiedadFacade = new PropiedadFacade();
        consultaDAO = new ConsultaDAO();
        whatsAppDAO = new WhatsAppDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogueado") == null) {
            response.sendRedirect(request.getContextPath() + "/usuario?accion=login");
            return;
        }

        UsuarioDTO usuario = (UsuarioDTO) session.getAttribute("usuarioLogueado");
        if (usuario.getIdRol() != 3 && usuario.getIdRol() != 4 && usuario.getIdRol() != 5) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado. Se requiere rol de Agente.");
            return;
        }

        String seccion = request.getParameter("seccion");
        if (seccion == null) seccion = "propiedades";

        switch (seccion) {
            case "consultas":
                String filtroConsulta = request.getParameter("estadoConsulta");
                List<ConsultaDTO> consultas = consultaDAO.listarConsultasPorAgente(usuario.getIdUsuario(), filtroConsulta);
                int pendientes = consultaDAO.contarConsultasPendientes(usuario.getIdUsuario());
                request.setAttribute("listaConsultas", consultas);
                request.setAttribute("consultasPendientes", pendientes);
                request.setAttribute("filtroConsultaEstado", filtroConsulta);
                request.setAttribute("seccion", "consultas");
                break;

            case "propiedades":
            default:
                String estado = request.getParameter("estado");
                String orden = request.getParameter("orden");
                List<PropiedadDTO> lista = propiedadFacade.obtenerPropiedadesAgenteConFiltros(
                        usuario.getIdUsuario(), estado, orden);
                request.setAttribute("listaMisPropiedades", lista);
                request.setAttribute("filtroEstado", estado);
                request.setAttribute("filtroOrden", orden);
                request.setAttribute("seccion", "propiedades");
                break;
        }

        // Métricas globales del panel
        int whatsappSemana = whatsAppDAO.contarContactosSemana(usuario.getIdUsuario());
        int consultasPendientesGlobal = consultaDAO.contarConsultasPendientes(usuario.getIdUsuario());
        request.setAttribute("whatsappSemana", whatsappSemana);
        request.setAttribute("consultasPendientesGlobal", consultasPendientesGlobal);

        request.getRequestDispatcher("/WEB-INF/views/panel_agente.jsp").forward(request, response);
    }
}
