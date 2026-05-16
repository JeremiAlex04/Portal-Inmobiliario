package org.example.proyectoweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.proyectoweb.dao.ConsultaDAO;
import org.example.proyectoweb.dto.ConsultaDTO;
import org.example.proyectoweb.dto.UsuarioDTO;

import java.io.IOException;

@WebServlet("/consulta")
public class ConsultaServlet extends HttpServlet {
    private ConsultaDAO consultaDAO;

    @Override
    public void init() { consultaDAO = new ConsultaDAO(); }

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
        if (ok) {
            response.sendRedirect(request.getContextPath() + "/propiedades?accion=ver&id=" + c.getIdPropiedad() + "&consultaEnviada=true");
        } else {
            response.sendRedirect(request.getContextPath() + "/propiedades?accion=ver&id=" + c.getIdPropiedad() + "&errorConsulta=true");
        }
    }
}
