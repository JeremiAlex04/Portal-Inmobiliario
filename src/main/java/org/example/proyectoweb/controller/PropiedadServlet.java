package org.example.proyectoweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.example.proyectoweb.dao.PropiedadDAO;
import org.example.proyectoweb.model.Propiedad;
import org.example.proyectoweb.model.Usuario;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "PropiedadServlet", urlPatterns = {"/propiedades"})
public class PropiedadServlet extends HttpServlet {

    private PropiedadDAO propiedadDAO;

    @Override
    public void init() throws ServletException {
        propiedadDAO = new PropiedadDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("accion");
        HttpSession session = request.getSession(false);
        Usuario u = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if ("nuevo".equals(action)) {
            if (u == null) {
                request.setAttribute("error", "Debes iniciar sesión para publicar una propiedad.");
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
                return;
            }
            request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
        } else if ("mis_propiedades".equals(action)) {
            if (u == null) {
                response.sendRedirect(request.getContextPath() + "/usuario?accion=login");
                return;
            }
            List<Propiedad> lista = propiedadDAO.obtenerPropiedades(null, u.getId());
            request.setAttribute("listaPropiedades", lista);
            request.setAttribute("titulo_pagina", "Mis Propiedades Publicadas");
            request.getRequestDispatcher("/WEB-INF/views/propiedades.jsp").forward(request, response);
        } else if ("editar".equals(action)) {
            if (u == null) {
                response.sendRedirect(request.getContextPath() + "/usuario?accion=login");
                return;
            }
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                Propiedad p = propiedadDAO.obtenerPropiedadPorId(id);
                if (p != null && p.getIdUsuario() == u.getId()) {
                    request.setAttribute("propiedad", p);
                    request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/propiedades?accion=mis_propiedades");
                }
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/propiedades?accion=mis_propiedades");
            }
        } else if ("eliminar".equals(action)) {
            if (u == null) {
                response.sendRedirect(request.getContextPath() + "/usuario?accion=login");
                return;
            }
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                propiedadDAO.eliminarPropiedad(id, u.getId());
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect(request.getContextPath() + "/propiedades?accion=mis_propiedades");
        } else {
            String filtro = request.getParameter("filtro");
            List<Propiedad> listaPropiedades = propiedadDAO.obtenerPropiedades(filtro, null);
            request.setAttribute("listaPropiedades", listaPropiedades);
            request.setAttribute("filtroActual", filtro);
            request.setAttribute("titulo_pagina", "Propiedades en Venta / Alquiler / Proyectos");
            request.getRequestDispatcher("/WEB-INF/views/propiedades.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Usuario u = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (u == null) {
            response.sendRedirect(request.getContextPath() + "/usuario?accion=login");
            return;
        }

        String idStr = request.getParameter("id");
        String titulo = request.getParameter("titulo");
        String descripcion = request.getParameter("descripcion");
        String precioStr = request.getParameter("precio");
        String ubicacion = request.getParameter("ubicacion");
        String operacion = request.getParameter("operacion"); // VENTA, ALQUILER, PROYECTO

        try {
            BigDecimal precio = new BigDecimal(precioStr);
            
            int idTipo = 1; // 1 = Casa
            String opFinal = operacion;
            if ("PROYECTO".equals(operacion)) {
                idTipo = 8; // 8 = Proyecto
                opFinal = "VENTA"; // Defaults to VENTA for projects
            } else if (operacion == null || operacion.isEmpty()) {
                opFinal = "VENTA";
            }

            if (idStr != null && !idStr.isEmpty()) {
                int id = Integer.parseInt(idStr);
                Propiedad propiedadActualizada = new Propiedad(id, u.getId(), titulo, descripcion, precio, ubicacion, opFinal, idTipo);
                boolean actualizado = propiedadDAO.actualizarPropiedad(propiedadActualizada);
                if (actualizado) {
                    response.sendRedirect(request.getContextPath() + "/propiedades?accion=mis_propiedades");
                } else {
                    request.setAttribute("error", "No se pudo actualizar la propiedad.");
                    request.setAttribute("propiedad", propiedadActualizada);
                    request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
                }
            } else {
                Propiedad nuevaPropiedad = new Propiedad(0, u.getId(), titulo, descripcion, precio, ubicacion, opFinal, idTipo);
                boolean insertado = propiedadDAO.registrarPropiedad(nuevaPropiedad);
                
                if (insertado) {
                    response.sendRedirect(request.getContextPath() + "/propiedades?accion=mis_propiedades");
                } else {
                    request.setAttribute("error", "No se pudo registrar la propiedad en la base de datos.");
                    request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
                }
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error de conversión de datos: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
        }
    }
}
