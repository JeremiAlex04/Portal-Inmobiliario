package org.example.proyectoweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import org.example.proyectoweb.facade.ContactoFacade;
import org.example.proyectoweb.dto.ContactoDTO;

import java.io.IOException;

@WebServlet("/contacto")
public class ContactoServlet extends HttpServlet {

    private ContactoFacade facade;

    @Override
    public void init() {
        facade = new ContactoFacade();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/contacto.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String nombre = request.getParameter("nombre");
        String email = request.getParameter("email");
        String mensaje = request.getParameter("mensaje");

        ContactoDTO c = new ContactoDTO(0, nombre, "", email, mensaje);

        if (facade.guardarMensaje(c)) {
            request.setAttribute("msg", "Mensaje enviado correctamente ✔");
            request.setAttribute("msgType", "success");
        } else {
            request.setAttribute("msg", "Error al enviar mensaje ✘");
            request.setAttribute("msgType", "error");
        }

        request.getRequestDispatcher("/WEB-INF/views/contacto.jsp")
               .forward(request, response);
    }
}
