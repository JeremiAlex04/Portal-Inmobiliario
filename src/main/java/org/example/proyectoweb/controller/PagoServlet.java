package org.example.proyectoweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.proyectoweb.dao.PagoDAO;
import org.example.proyectoweb.dto.PagoDTO;
import org.example.proyectoweb.dto.PlanDTO;
import org.example.proyectoweb.dto.UsuarioDTO;

import java.io.IOException;
import java.util.List;

@WebServlet("/pagos")
public class PagoServlet extends HttpServlet {
    private PagoDAO pagoDAO;

    @Override
    public void init() { pagoDAO = new PagoDAO(); }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accion = request.getParameter("accion");
        if (accion == null) accion = "planes";

        UsuarioDTO user = (UsuarioDTO) request.getSession().getAttribute("usuarioLogueado");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/usuario?accion=login");
            return;
        }

        switch (accion) {
            case "planes":
                List<PlanDTO> planes = pagoDAO.listarPlanes();
                request.setAttribute("listaPlanes", planes);
                request.getRequestDispatcher("/WEB-INF/views/planes.jsp").forward(request, response);
                break;

            case "formulario":
                int idPlan = Integer.parseInt(request.getParameter("plan"));
                PlanDTO plan = pagoDAO.obtenerPlan(idPlan);
                request.setAttribute("planSeleccionado", plan);
                request.getRequestDispatcher("/WEB-INF/views/pago_formulario.jsp").forward(request, response);
                break;

            case "historial":
                List<PagoDTO> misPagos = pagoDAO.listarPagosPorUsuario(user.getIdUsuario());
                request.setAttribute("listaPagos", misPagos);
                request.getRequestDispatcher("/WEB-INF/views/historial_pagos.jsp").forward(request, response);
                break;

            case "admin":
                if (user.getIdRol() != 5) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                String filtro = request.getParameter("estado");
                List<PagoDTO> todosPagos = pagoDAO.listarPagos(filtro);
                request.setAttribute("listaPagos", todosPagos);
                request.setAttribute("filtroEstado", filtro);
                request.getRequestDispatcher("/WEB-INF/views/admin_pagos.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accion = request.getParameter("accion");
        UsuarioDTO user = (UsuarioDTO) request.getSession().getAttribute("usuarioLogueado");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/usuario?accion=login");
            return;
        }

        if ("procesar".equals(accion)) {
            int idPlan = Integer.parseInt(request.getParameter("idPlan"));
            String metodoPago = request.getParameter("metodoPago");
            boolean ok = pagoDAO.registrarPago(user.getIdUsuario(), idPlan, metodoPago);
            if (ok) {
                response.sendRedirect(request.getContextPath() + "/pagos?accion=historial&pagoExitoso=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/pagos?accion=formulario&plan=" + idPlan + "&error=true");
            }
        } else if ("cambiarEstado".equals(accion)) {
            if (user.getIdRol() != 5) { response.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
            int idPago = Integer.parseInt(request.getParameter("idPago"));
            String nuevoEstado = request.getParameter("nuevoEstado");
            pagoDAO.cambiarEstadoPago(idPago, nuevoEstado);
            response.sendRedirect(request.getContextPath() + "/pagos?accion=admin");
        }
    }
}
