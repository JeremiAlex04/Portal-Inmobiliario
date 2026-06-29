package org.example.proyectoweb.bean;

import jakarta.enterprise.context.RequestScoped;
import jakarta.faces.application.FacesMessage;
import jakarta.faces.context.FacesContext;
import jakarta.inject.Named;
import org.example.proyectoweb.dto.ContactoDTO;
import org.example.proyectoweb.facade.ContactoFacade;

@Named("contactoBean")
@RequestScoped
public class ContactoBean {

    private ContactoFacade contactoFacade = new ContactoFacade();

    private String nombres;
    private String email;
    private String mensaje;

    public String enviar() {
        ContactoDTO c = new ContactoDTO(0, nombres, "", email, mensaje);
        boolean ok = contactoFacade.guardarMensaje(c);
        if (ok) {
            FacesContext.getCurrentInstance().addMessage(null,
                    new FacesMessage(FacesMessage.SEVERITY_INFO, "Mensaje enviado correctamente", null));
            nombres = null;
            email = null;
            mensaje = null;
        } else {
            FacesContext.getCurrentInstance().addMessage(null,
                    new FacesMessage(FacesMessage.SEVERITY_ERROR, "Error al enviar el mensaje", null));
        }
        return null;
    }

    // Getters y Setters
    public String getNombres() { return nombres; }
    public void setNombres(String nombres) { this.nombres = nombres; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getMensaje() { return mensaje; }
    public void setMensaje(String mensaje) { this.mensaje = mensaje; }
}
