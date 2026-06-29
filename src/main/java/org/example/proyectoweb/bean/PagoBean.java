package org.example.proyectoweb.bean;

import jakarta.enterprise.context.RequestScoped;
import jakarta.faces.context.FacesContext;
import jakarta.inject.Inject;
import jakarta.inject.Named;
import org.example.proyectoweb.dao.PagoDAO;
import org.example.proyectoweb.dto.PagoDTO;
import org.example.proyectoweb.dto.PlanDTO;

import java.util.List;

@Named("pagoBean")
@RequestScoped
public class PagoBean {

    private PagoDAO pagoDAO = new PagoDAO();

    @Inject
    private AuthBean authBean;

    public List<PlanDTO> getPlanes() {
        return pagoDAO.listarPlanes();
    }

    public PlanDTO getPlanSeleccionado() {
        String planId = FacesContext.getCurrentInstance().getExternalContext().getRequestParameterMap().get("plan");
        if (planId != null) {
            return pagoDAO.obtenerPlan(Integer.parseInt(planId));
        }
        return null;
    }

    public List<PagoDTO> getHistorial() {
        if (!authBean.isLogueado()) return List.of();
        return pagoDAO.listarPagosPorUsuario(authBean.getUsuario().getIdUsuario());
    }

    private String metodoPago;
    private int idPlan;

    public String procesarPago() {
        if (!authBean.isLogueado()) return "/login.xhtml?faces-redirect=true";
        boolean ok = pagoDAO.registrarPago(authBean.getUsuario().getIdUsuario(), idPlan, metodoPago);
        if (ok) {
            return "/usuario/historial_pagos.xhtml?faces-redirect=true";
        }
        return null;
    }

    // Admin
    public List<PagoDTO> getTodosPagos() {
        String estado = FacesContext.getCurrentInstance().getExternalContext().getRequestParameterMap().get("estado");
        return pagoDAO.listarPagos(estado);
    }

    public String cambiarEstadoPago(int idPago, String nuevoEstado) {
        pagoDAO.cambiarEstadoPago(idPago, nuevoEstado);
        return "/admin/pagos.xhtml?faces-redirect=true";
    }

    // Getters y Setters
    public String getMetodoPago() { return metodoPago; }
    public void setMetodoPago(String metodoPago) { this.metodoPago = metodoPago; }
    public int getIdPlan() { return idPlan; }
    public void setIdPlan(int idPlan) { this.idPlan = idPlan; }
}
