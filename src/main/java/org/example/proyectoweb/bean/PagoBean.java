package org.example.proyectoweb.bean;

import jakarta.annotation.PostConstruct;
import jakarta.enterprise.context.RequestScoped;
import jakarta.faces.context.FacesContext;
import jakarta.inject.Inject;
import jakarta.inject.Named;
import org.example.proyectoweb.dao.PagoDAO;
import org.example.proyectoweb.dto.PagoDTO;
import org.example.proyectoweb.dto.PlanDTO;
import org.example.proyectoweb.dto.UsuarioDTO;

import java.io.IOException;
import java.util.List;

@Named("pagoBean")
@RequestScoped
public class PagoBean {

    private PagoDAO pagoDAO = new PagoDAO();

    @Inject
    private AuthBean authBean;

    @PostConstruct
    public void init() {
        // Validar que el usuario esté autenticado para acceder a planes
        if (getUsuarioSesion() == null) {
            try {
                FacesContext.getCurrentInstance().getExternalContext()
                    .redirect(FacesContext.getCurrentInstance().getExternalContext()
                        .getRequestContextPath() + "/index.xhtml");
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

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
        UsuarioDTO usuarioSesion = getUsuarioSesion();
        if (usuarioSesion == null) return List.of();
        return pagoDAO.listarPagosPorUsuario(usuarioSesion.getIdUsuario());
    }

    private String metodoPago;
    private int idPlan;

    public String procesarPago() {
        UsuarioDTO usuarioSesion = getUsuarioSesion();
        if (usuarioSesion == null) return "/login.xhtml?faces-redirect=true";
        boolean ok = pagoDAO.registrarPago(usuarioSesion.getIdUsuario(), idPlan, metodoPago);
        if (ok) {
            return "/usuario/historial_pagos.xhtml?faces-redirect=true";
        }
        return null;
    }

    private UsuarioDTO getUsuarioSesion() {
        if (authBean != null && authBean.isLogueado() && authBean.getUsuario() != null) {
            return authBean.getUsuario();
        }
        Object usuarioSesion = FacesContext.getCurrentInstance().getExternalContext().getSessionMap().get("usuarioLogueado");
        return (usuarioSesion instanceof UsuarioDTO) ? (UsuarioDTO) usuarioSesion : null;
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
