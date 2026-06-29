package org.example.proyectoweb.bean;

import jakarta.enterprise.context.SessionScoped;
import jakarta.faces.application.FacesMessage;
import jakarta.faces.context.FacesContext;
import jakarta.inject.Inject;
import jakarta.inject.Named;
import org.example.proyectoweb.dto.UsuarioDTO;
import org.example.proyectoweb.facade.UsuarioFacade;

import java.io.Serializable;

@Named("authBean")
@SessionScoped
public class AuthBean implements Serializable {

    @Inject
    private ConfiguracionBean configuracionBean;

    private UsuarioFacade usuarioFacade = new UsuarioFacade();

    private String correo;
    private String password;
    private UsuarioDTO usuario;
    private boolean logueado;

    // Registro
    private String nombres;
    private String apellidos;
    private String correoRegistro;
    private String passwordRegistro;
    private int idRol = 2;

    public String login() {
        String error = usuarioFacade.validarCredencialesLogin(correo, password);
        if (error != null) {
            FacesContext.getCurrentInstance().addMessage(null,
                    new FacesMessage(FacesMessage.SEVERITY_ERROR, error, null));
            return null;
        }

        UsuarioDTO u = usuarioFacade.autenticar(correo, password);
        if (u != null) {
            this.usuario = u;
            this.logueado = true;
            this.correo = null;
            this.password = null;

            FacesContext.getCurrentInstance().addMessage(null,
                    new FacesMessage(FacesMessage.SEVERITY_INFO, "Bienvenido " + u.getNombres(), null));

            if (u.getIdRol() == 5) {
                return "/admin/dashboard.xhtml?faces-redirect=true";
            } else if (u.getIdRol() == 3 || u.getIdRol() == 4) {
                return "/agente/panel.xhtml?faces-redirect=true";
            } else if (u.getIdRol() == 2) {
                return "/propiedades.xhtml?faces-redirect=true";
            }
            return "/index.xhtml?faces-redirect=true";
        }
        FacesContext.getCurrentInstance().addMessage(null,
                new FacesMessage(FacesMessage.SEVERITY_ERROR, "Credenciales incorrectas", null));
        return null;
    }

    public String registrar() {
        UsuarioDTO u = new UsuarioDTO();
        u.setNombres(nombres);
        u.setApellidos(apellidos);
        u.setCorreo(correoRegistro);
        u.setPasswordHash(passwordRegistro);
        u.setIdRol(idRol);

        String error = usuarioFacade.validarUsuario(u);
        if (error != null) {
            FacesContext.getCurrentInstance().addMessage(null,
                    new FacesMessage(FacesMessage.SEVERITY_ERROR, error, null));
            return null;
        }

        if (usuarioFacade.existeCorreo(u.getCorreo())) {
            FacesContext.getCurrentInstance().addMessage(null,
                    new FacesMessage(FacesMessage.SEVERITY_ERROR, "El correo ya se encuentra registrado.", null));
            return null;
        }

        boolean ok = usuarioFacade.registrarUsuario(u);
        if (ok) {
            limpiarFormularioRegistro();
            FacesContext.getCurrentInstance().addMessage(null,
                    new FacesMessage(FacesMessage.SEVERITY_INFO, "Registro exitoso. Ya puedes iniciar sesión.", null));
            return "/login.xhtml?faces-redirect=true";
        }
        FacesContext.getCurrentInstance().addMessage(null,
                new FacesMessage(FacesMessage.SEVERITY_ERROR, "Error al registrar. Verifica tus datos.", null));
        return null;
    }

    public String logout() {
        this.usuario = null;
        this.logueado = false;
        this.correo = null;
        this.password = null;
        FacesContext.getCurrentInstance().getExternalContext().invalidateSession();
        return "/index.xhtml?faces-redirect=true";
    }

    public boolean permiteRol(int... roles) {
        if (!logueado || usuario == null) return false;
        for (int r : roles) {
            if (usuario.getIdRol() == r) return true;
        }
        return false;
    }

    private void limpiarFormularioRegistro() {
        this.nombres = null;
        this.apellidos = null;
        this.correoRegistro = null;
        this.passwordRegistro = null;
        this.idRol = 2;
    }

    // Getters y Setters
    public String getCorreo() { return correo; }
    public void setCorreo(String correo) { this.correo = correo; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public UsuarioDTO getUsuario() { return usuario; }
    public void setUsuario(UsuarioDTO usuario) { this.usuario = usuario; }

    public boolean isLogueado() { return logueado; }
    public void setLogueado(boolean logueado) { this.logueado = logueado; }

    public String getNombres() { return nombres; }
    public void setNombres(String nombres) { this.nombres = nombres; }

    public String getApellidos() { return apellidos; }
    public void setApellidos(String apellidos) { this.apellidos = apellidos; }

    public String getCorreoRegistro() { return correoRegistro; }
    public void setCorreoRegistro(String correoRegistro) { this.correoRegistro = correoRegistro; }

    public String getPasswordRegistro() { return passwordRegistro; }
    public void setPasswordRegistro(String passwordRegistro) { this.passwordRegistro = passwordRegistro; }

    public int getIdRol() { return idRol; }
    public void setIdRol(int idRol) { this.idRol = idRol; }
}
