package org.example.proyectoweb.bean;

import jakarta.enterprise.context.RequestScoped;
import jakarta.faces.application.FacesMessage;
import jakarta.faces.context.FacesContext;
import jakarta.inject.Inject;
import jakarta.inject.Named;
import org.example.proyectoweb.dto.UsuarioDTO;
import org.example.proyectoweb.facade.UsuarioFacade;

@Named("usuarioBean")
@RequestScoped
public class UsuarioBean {

    @Inject
    private AuthBean authBean;

    private UsuarioFacade usuarioFacade = new UsuarioFacade();

    private String nombres;
    private String apellidos;
    private String correo;

    public String actualizarPerfil() {
        if (!authBean.isLogueado()) return "/login.xhtml?faces-redirect=true";

        UsuarioDTO u = authBean.getUsuario();
        if (nombres != null) u.setNombres(nombres);
        if (apellidos != null) u.setApellidos(apellidos);
        if (correo != null) u.setCorreo(correo);

        boolean ok = usuarioFacade.editarUsuario(u);
        if (ok) {
            authBean.setUsuario(usuarioFacade.obtenerUsuarioPorId(u.getIdUsuario()));
            FacesContext.getCurrentInstance().addMessage(null,
                    new FacesMessage(FacesMessage.SEVERITY_INFO, "Perfil actualizado correctamente", null));
        } else {
            FacesContext.getCurrentInstance().addMessage(null,
                    new FacesMessage(FacesMessage.SEVERITY_ERROR, "Error al actualizar el perfil", null));
        }
        return null;
    }

    public void cargarDatos() {
        if (authBean.isLogueado() && authBean.getUsuario() != null) {
            this.nombres = authBean.getUsuario().getNombres();
            this.apellidos = authBean.getUsuario().getApellidos();
            this.correo = authBean.getUsuario().getCorreo();
        }
    }

    // Getters y Setters
    public String getNombres() { return nombres; }
    public void setNombres(String nombres) { this.nombres = nombres; }
    public String getApellidos() { return apellidos; }
    public void setApellidos(String apellidos) { this.apellidos = apellidos; }
    public String getCorreo() { return correo; }
    public void setCorreo(String correo) { this.correo = correo; }
}
