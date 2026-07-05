package org.example.proyectoweb.bean;

import jakarta.enterprise.context.RequestScoped;
import jakarta.faces.context.FacesContext;
import jakarta.inject.Inject;
import jakarta.inject.Named;
import org.example.proyectoweb.dao.ConsultaDAO;
import org.example.proyectoweb.dao.WhatsAppDAO;
import org.example.proyectoweb.dto.ConsultaDTO;
import org.example.proyectoweb.dto.PropiedadDTO;
import org.example.proyectoweb.dto.UsuarioDTO;
import org.example.proyectoweb.facade.PropiedadFacade;
import org.example.proyectoweb.facade.UsuarioFacade;

import java.util.List;

@Named("agenteBean")
@RequestScoped
public class AgenteBean {

    @Inject
    private AuthBean authBean;

    private PropiedadFacade propiedadFacade = new PropiedadFacade();
    private ConsultaDAO consultaDAO = new ConsultaDAO();
    private WhatsAppDAO whatsAppDAO = new WhatsAppDAO();
    private UsuarioFacade usuarioFacade = new UsuarioFacade();

    private String filtroEstado;
    private String filtroOrden;
    private String filtroConsultaEstado;

    public List<PropiedadDTO> getMisPropiedades() {
        if (!authBean.isLogueado()) return List.of();
        return propiedadFacade.obtenerPropiedadesAgenteConFiltros(
                authBean.getUsuario().getIdUsuario(),
                filtroEstado, filtroOrden);
    }

    public List<ConsultaDTO> getConsultas() {
        if (!authBean.isLogueado()) return List.of();
        return consultaDAO.listarConsultasPorAgente(
                authBean.getUsuario().getIdUsuario(),
                filtroConsultaEstado);
    }

    public int getConsultasPendientes() {
        if (!authBean.isLogueado()) return 0;
        return consultaDAO.contarConsultasPendientes(authBean.getUsuario().getIdUsuario());
    }

    public int getWhatsappSemana() {
        if (!authBean.isLogueado()) return 0;
        return whatsAppDAO.contarContactosSemana(authBean.getUsuario().getIdUsuario());
    }

    public String cambiarEstadoConsulta(int idConsulta, String nuevoEstado) {
        consultaDAO.cambiarEstadoConsulta(idConsulta, nuevoEstado);
        return null;
    }

    public String getSeccion() {
        return seccion;
    }
    public void setSeccion(String seccion) { this.seccion = seccion; }
    private String seccion = "propiedades";

    public UsuarioDTO getAgente() {
        String idStr = FacesContext.getCurrentInstance().getExternalContext().getRequestParameterMap().get("id");
        if (idStr != null) {
            return usuarioFacade.obtenerUsuarioPorId(Integer.parseInt(idStr));
        }
        return authBean.getUsuario();
    }

    // Getters y Setters
    public String getFiltroEstado() { return filtroEstado; }
    public void setFiltroEstado(String filtroEstado) { this.filtroEstado = filtroEstado; }
    public String getFiltroOrden() { return filtroOrden; }
    public void setFiltroOrden(String filtroOrden) { this.filtroOrden = filtroOrden; }
    public String getFiltroConsultaEstado() { return filtroConsultaEstado; }
    public void setFiltroConsultaEstado(String filtroConsultaEstado) { this.filtroConsultaEstado = filtroConsultaEstado; }
}
