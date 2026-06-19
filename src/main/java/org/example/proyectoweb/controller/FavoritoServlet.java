package org.example.proyectoweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.proyectoweb.dto.UsuarioDTO;
import org.example.proyectoweb.facade.FavoritoFacade;

import java.io.IOException;

@WebServlet("/favorito")
public class FavoritoServlet extends HttpServlet {

    private FavoritoFacade favoritoFacade;

    @Override
    public void init() {
        favoritoFacade = new FavoritoFacade();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogueado") == null) {
            response.sendRedirect(request.getContextPath() + "/usuario?accion=login");
            return;
        }

        UsuarioDTO usuario = (UsuarioDTO) session.getAttribute("usuarioLogueado");

        // GET solo maneja listado (operación segura y sin efectos secundarios)
        request.setAttribute("listaFavoritos", favoritoFacade.listarFavoritos(usuario.getIdUsuario()));
        request.getRequestDispatcher("/WEB-INF/views/usuario/favoritos.jsp").forward(request, response);
    }

    // POST — Agregar y remover favoritos (operaciones con efectos secundarios)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogueado") == null) {
            response.sendRedirect(request.getContextPath() + "/usuario?accion=login");
            return;
        }

        UsuarioDTO usuario = (UsuarioDTO) session.getAttribute("usuarioLogueado");
        String accion = request.getParameter("accion");
        if (accion == null) accion = "";

        switch (accion) {
            case "agregar":
                int idAgregar = Integer.parseInt(request.getParameter("id"));
                favoritoFacade.agregarFavorito(usuario.getIdUsuario(), idAgregar);
                // Redirigir a la página de origen
                String referer = request.getHeader("Referer");
                response.sendRedirect(referer != null ? referer : request.getContextPath() + "/propiedades");
                break;

            case "remover":
                int idRemover = Integer.parseInt(request.getParameter("id"));
                favoritoFacade.removerFavorito(usuario.getIdUsuario(), idRemover);
                String ref = request.getHeader("Referer");
                response.sendRedirect(ref != null ? ref : request.getContextPath() + "/propiedades");
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/favorito");
                break;
        }
    }
}

