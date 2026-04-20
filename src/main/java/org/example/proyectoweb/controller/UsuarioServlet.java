package org.example.proyectoweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.example.proyectoweb.dao.UsuarioDAO;
import org.example.proyectoweb.model.Usuario;

import java.io.IOException;

@WebServlet("/usuario")
public class UsuarioServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO;

    @Override
    public void init() {
        usuarioDAO = new UsuarioDAO();
    }

  
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nombre = request.getParameter("nombre");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        Usuario u = new Usuario(0, nombre, email, password);

        boolean ok = usuarioDAO.registrarUsuario(u);

        if (ok) {
            request.setAttribute("msg", " Usuario registrado correctamente");
        } else {
            request.setAttribute("msg", " Error al registrar usuario");
        }

        request.getRequestDispatcher("/WEB-INF/views/registroUsuario.jsp")
               .forward(request, response);
    }
} 
