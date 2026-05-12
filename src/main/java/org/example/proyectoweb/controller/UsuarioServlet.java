package org.example.proyectoweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.example.proyectoweb.facade.UsuarioFacade;
import org.example.proyectoweb.dto.UsuarioDTO;

import java.io.IOException;

@WebServlet("/usuario")
public class UsuarioServlet extends HttpServlet {

    private UsuarioFacade usuarioFacade;

    @Override
    public void init() {
        usuarioFacade = new UsuarioFacade();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");
        if (accion == null) accion = "login";

        switch (accion) {
            case "registro":
                request.getRequestDispatcher("/WEB-INF/views/registroUsuario.jsp").forward(request, response);
                break;
            case "logout":
                HttpSession session = request.getSession(false);
                if (session != null) {
                    session.invalidate();
                }
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                break;
            case "login":
            default:
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        if (accion == null) accion = "login";

        if ("registro".equals(accion)) {
            String nombres = request.getParameter("nombres");
            String apellidos = request.getParameter("apellidos");
            String correo = request.getParameter("correo");
            String password = request.getParameter("password");

            UsuarioDTO u = new UsuarioDTO();
            u.setNombres(nombres);
            u.setApellidos(apellidos);
            u.setCorreo(correo);
            u.setPasswordHash(password); // El DAO se encarga de hashear

            boolean ok = usuarioFacade.registrarUsuario(u);

            if (ok) {
                request.setAttribute("msg", "Usuario registrado correctamente. Por favor, inicie sesión.");
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Error al registrar usuario. El correo podría estar en uso.");
                request.getRequestDispatcher("/WEB-INF/views/registroUsuario.jsp").forward(request, response);
            }

        } else if ("login".equals(accion)) {
            String correo = request.getParameter("correo");
            String password = request.getParameter("password");

            UsuarioDTO authUser = usuarioFacade.autenticar(correo, password);

            if (authUser != null) {
                // Iniciar sesión
                HttpSession session = request.getSession();
                session.setAttribute("usuarioLogueado", authUser);
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            } else {
                request.setAttribute("error", "Credenciales incorrectas o usuario inactivo.");
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            }
        }
    }
} 
