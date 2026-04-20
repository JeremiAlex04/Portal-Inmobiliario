package org.example.proyectoweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import org.example.proyectoweb.dao.ContactoDAO;
import org.example.proyectoweb.model.Contacto;

import java.io.IOException;

@WebServlet("/contacto")
public class ContactoServlet extends HttpServlet {

    private ContactoDAO dao;

    @Override
    public void init() {
        dao = new ContactoDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nombre = request.getParameter("nombre");
        String email = request.getParameter("email");
        String mensaje = request.getParameter("mensaje");

        Contacto c = new Contacto(0, nombre, email, mensaje);

        if (dao.guardarMensaje(c)) {
            request.setAttribute("msg", "Mensaje enviado correctamente ✔");
        } else {
            request.setAttribute("msg", "Error al enviar mensaje ✘");
        }

        request.getRequestDispatcher("/WEB-INF/views/contacto.jsp")
               .forward(request, response);
    }
}
