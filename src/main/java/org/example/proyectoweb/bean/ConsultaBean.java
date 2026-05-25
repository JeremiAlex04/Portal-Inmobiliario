package org.example.proyectoweb.bean;

import jakarta.annotation.PostConstruct;
import jakarta.enterprise.context.RequestScoped;
import jakarta.inject.Named;
import org.example.proyectoweb.dto.PropiedadDTO;
import org.example.proyectoweb.dto.ConsultaDTO;
import org.example.proyectoweb.facade.PropiedadFacade;
import org.example.proyectoweb.dao.ConsultaDAO;

import java.io.Serializable;
import java.util.List;

@Named("consultaBean")
@RequestScoped
public class ConsultaBean implements Serializable {
    private static final long serialVersionUID = 1L;

    private int idPropiedad;
    private String nombre;
    private String email;
    private String telefono;
    private String mensaje;

    private List<PropiedadDTO> propiedades;
    private PropiedadFacade propiedadFacade;
    private ConsultaDAO consultaDAO;

    @PostConstruct
    public void init() {
        propiedadFacade = new PropiedadFacade();
        consultaDAO = new ConsultaDAO();
        try {
            // Obtener el listado de propiedades para el combo desplegable
            propiedades = propiedadFacade.listarPropiedades(0, 50);
        } catch (Exception e) {
            propiedades = new java.util.ArrayList<>();
            e.printStackTrace();
        }
    }

    public String enviar() {
        if (nombre == null || nombre.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            mensaje == null || mensaje.trim().isEmpty() ||
            idPropiedad <= 0) {
            return null;
        }

        ConsultaDTO c = new ConsultaDTO();
        c.setIdPropiedad(idPropiedad);
        c.setNombre(nombre);
        c.setEmail(email);
        c.setTelefono(telefono);
        c.setMensaje(mensaje);
        c.setIdUsuario(null); // Visitante anónimo desde JSF

        boolean guardado = consultaDAO.registrarConsulta(c);
        if (guardado) {
            // Navegación básica: Redirige a confirmacion.xhtml con parámetro GET de cliente
            return "confirmacion?faces-redirect=true&cliente=" + nombre;
        }

        return null;
    }

    // Getters y Setters
    public int getIdPropiedad() { return idPropiedad; }
    public void setIdPropiedad(int idPropiedad) { this.idPropiedad = idPropiedad; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }

    public String getMensaje() { return mensaje; }
    public void setMensaje(String mensaje) { this.mensaje = mensaje; }

    public List<PropiedadDTO> getPropiedades() { return propiedades; }
    public void setPropiedades(List<PropiedadDTO> propiedades) { this.propiedades = propiedades; }
}
