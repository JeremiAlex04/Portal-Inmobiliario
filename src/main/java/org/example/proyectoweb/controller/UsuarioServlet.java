package org.example.proyectoweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("accion");
        if ("registro".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/views/registroUsuario.jsp").forward(request, response);
        } else if ("login".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        } else if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("accion");
        if (action == null) action = "registro";

        if ("registro".equals(action)) {
            String nombres = request.getParameter("nombres");
            String apellidos = request.getParameter("apellidos");
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            // Basic validation
            if (nombres == null || nombres.trim().isEmpty() || email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
                request.setAttribute("error", "Todos los campos obligatorios deben estar llenos.");
                request.getRequestDispatcher("/WEB-INF/views/registroUsuario.jsp").forward(request, response);
                return;
            }

            Usuario u = new Usuario(0, nombres, apellidos, email, password);
            boolean ok = usuarioDAO.registrarUsuario(u);

            if (ok) {
                request.setAttribute("msg", "Usuario registrado correctamente. Ahora puedes iniciar sesión.");
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Error al registrar usuario. Verifica tus datos.");
                request.getRequestDispatcher("/WEB-INF/views/registroUsuario.jsp").forward(request, response);
            }
        } else if ("login".equals(action)) {
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            Usuario u = usuarioDAO.loginUsuario(email, password);
            if (u != null) {
                HttpSession session = request.getSession();
                session.setAttribute("usuario", u);
                response.sendRedirect(request.getContextPath() + "/propiedades");
            } else {
                request.setAttribute("error", "Credenciales inválidas.");
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            }
        }
    }
}
