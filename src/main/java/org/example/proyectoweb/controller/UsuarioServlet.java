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
    private org.example.proyectoweb.facade.AuditoriaFacade auditoriaFacade;

    @Override
    public void init() {
        usuarioFacade = new UsuarioFacade();
        auditoriaFacade = new org.example.proyectoweb.facade.AuditoriaFacade();
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
                    UsuarioDTO user = (UsuarioDTO) session.getAttribute("usuarioLogueado");
                    if (user != null) {
                        auditoriaFacade.registrarEvento(user.getIdUsuario(), "usuario", user.getIdUsuario(), "LOGOUT", request.getRemoteAddr(), request.getHeader("User-Agent"), "{\"correo\":\"" + user.getCorreo() + "\"}");
                    }
                    session.invalidate();
                }
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                break;
            case "perfil":
                UsuarioDTO currentUser = (UsuarioDTO) request.getSession().getAttribute("usuarioLogueado");
                if (currentUser == null) {
                    response.sendRedirect(request.getContextPath() + "/usuario?accion=login");
                    return;
                }
                request.getRequestDispatcher("/WEB-INF/views/perfil.jsp").forward(request, response);
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
            String idRolStr = request.getParameter("idRol");

            UsuarioDTO u = new UsuarioDTO();
            u.setNombres(nombres);
            u.setApellidos(apellidos);
            u.setCorreo(correo);
            u.setPasswordHash(password); // El DAO se encarga de hashear
            
            if (idRolStr != null && !idRolStr.isEmpty()) {
                u.setIdRol(Integer.parseInt(idRolStr));
            }

            boolean ok = usuarioFacade.registrarUsuario(u);

            if (ok) {
                auditoriaFacade.registrarEvento(null, "usuario", 0, "CREAR", request.getRemoteAddr(), request.getHeader("User-Agent"), "{\"correo\":\"" + u.getCorreo() + "\",\"rol\":" + u.getIdRol() + "}");
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
                
                auditoriaFacade.registrarEvento(authUser.getIdUsuario(), "usuario", authUser.getIdUsuario(), "LOGIN", request.getRemoteAddr(), request.getHeader("User-Agent"), "{\"status\":\"success\",\"correo\":\"" + authUser.getCorreo() + "\"}");

                // Redirección basada en roles (Sprint 1)
                int rol = authUser.getIdRol();
                if (rol == 5) {
                    // Administrador
                    response.sendRedirect(request.getContextPath() + "/admin");
                } else if (rol == 3 || rol == 4) {
                    // Agente o Constructora
                    response.sendRedirect(request.getContextPath() + "/panel");
                } else {
                    // Comprador o Visitante
                    response.sendRedirect(request.getContextPath() + "/propiedades");
                }
            } else {
                auditoriaFacade.registrarEvento(null, "usuario", 0, "LOGIN", request.getRemoteAddr(), request.getHeader("User-Agent"), "{\"status\":\"failed\",\"correo\":\"" + correo + "\"}");
                request.setAttribute("error", "Credenciales incorrectas o usuario inactivo.");
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            }
        } else if ("actualizar_perfil".equals(accion)) {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("usuarioLogueado") == null) {
                response.sendRedirect(request.getContextPath() + "/usuario?accion=login");
                return;
            }
            UsuarioDTO loggedIn = (UsuarioDTO) session.getAttribute("usuarioLogueado");
            
            String nombres = request.getParameter("nombres");
            String apellidos = request.getParameter("apellidos");
            String correo = request.getParameter("correo");

            loggedIn.setNombres(nombres);
            loggedIn.setApellidos(apellidos);
            loggedIn.setCorreo(correo);

            boolean ok = usuarioFacade.editarUsuario(loggedIn);
            if (ok) {
                session.setAttribute("usuarioLogueado", loggedIn); // refresh session
                request.setAttribute("msg", "Perfil actualizado correctamente.");
            } else {
                request.setAttribute("error", "Error al actualizar perfil. Verifique sus datos.");
            }
            request.getRequestDispatcher("/WEB-INF/views/perfil.jsp").forward(request, response);
        }
        }
    }
} 
