package org.example.proyectoweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.proyectoweb.dao.WhatsAppDAO;
import org.example.proyectoweb.dto.UsuarioDTO;

import java.io.IOException;

@WebServlet("/whatsapp")
public class WhatsAppServlet extends HttpServlet {
    private WhatsAppDAO whatsAppDAO;

    @Override
    public void init() { whatsAppDAO = new WhatsAppDAO(); }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int idPropiedad = Integer.parseInt(request.getParameter("idPropiedad"));
        UsuarioDTO user = (UsuarioDTO) request.getSession().getAttribute("usuarioLogueado");
        Integer idUsuario = user != null ? user.getIdUsuario() : null;

        whatsAppDAO.registrarContacto(idPropiedad, idUsuario);

        response.sendRedirect(request.getContextPath() + "/propiedades?accion=ver&id=" + idPropiedad + "&whatsappRegistrado=true");
    }
}
