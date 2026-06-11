package org.example.proyectoweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.proyectoweb.dao.ConsultaDAO;
import org.example.proyectoweb.dto.ConsultaDTO;
import org.example.proyectoweb.dto.PropiedadDTO;
import org.example.proyectoweb.dto.UsuarioDTO;
import org.example.proyectoweb.facade.PropiedadFacade;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/consulta")
public class ConsultaServlet extends HttpServlet {
    private ConsultaDAO consultaDAO;
    private PropiedadFacade propiedadFacade;

    @Override
    public void init() {
        consultaDAO = new ConsultaDAO();
        propiedadFacade = new PropiedadFacade();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accion = request.getParameter("accion");
        if (accion == null) accion = "nueva";

        if ("confirmacion".equals(accion)) {
            String cliente = request.getParameter("cliente");
            request.setAttribute("cliente", cliente != null ? cliente : "Cliente Anónimo");
            request.getRequestDispatcher("/WEB-INF/views/public/confirmacion.jsp").forward(request, response);
            return;
        }

        // Por defecto: nueva consulta (accion = nueva)
        List<PropiedadDTO> propiedades;
        try {
            propiedades = propiedadFacade.listarPropiedades(0, 100);
        } catch (Exception e) {
            e.printStackTrace();
            propiedades = new ArrayList<>();
        }
        request.setAttribute("propiedades", propiedades);
        request.getRequestDispatcher("/WEB-INF/views/public/nuevaConsulta.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accion = request.getParameter("accion");

        if ("cambiarEstado".equals(accion)) {
            int idConsulta = Integer.parseInt(request.getParameter("idConsulta"));
            String nuevoEstado = request.getParameter("nuevoEstado");
            consultaDAO.cambiarEstadoConsulta(idConsulta, nuevoEstado);
            response.sendRedirect(request.getContextPath() + "/panel?seccion=consultas");
            return;
        }

        // Registro de nueva consulta
        ConsultaDTO c = new ConsultaDTO();
        c.setIdPropiedad(Integer.parseInt(request.getParameter("idPropiedad")));
        c.setNombre(request.getParameter("nombre"));
        c.setEmail(request.getParameter("email"));
        c.setTelefono(request.getParameter("telefono"));
        c.setMensaje(request.getParameter("mensaje"));

        UsuarioDTO user = (UsuarioDTO) request.getSession().getAttribute("usuarioLogueado");
        if (user != null) c.setIdUsuario(user.getIdUsuario());

        boolean ok = consultaDAO.registrarConsulta(c);

        if ("registrarPublico".equals(accion)) {
            if (ok) {
                String encodedName = URLEncoder.encode(c.getNombre(), StandardCharsets.UTF_8.toString());
                response.sendRedirect(request.getContextPath() + "/consulta?accion=confirmacion&cliente=" + encodedName);
            } else {
                request.setAttribute("error", "Ocurrió un error al registrar la consulta. Intente nuevamente.");
                doGet(request, response);
            }
        } else {
            // Comportamiento por defecto (desde detalle de propiedad)
            if (ok) {
                response.sendRedirect(request.getContextPath() + "/propiedades?accion=ver&id=" + c.getIdPropiedad() + "&consultaEnviada=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/propiedades?accion=ver&id=" + c.getIdPropiedad() + "&errorConsulta=true");
            }
        }
    }
}

