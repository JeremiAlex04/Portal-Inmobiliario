package org.example.proyectoweb.dto;

public class ContactoDTO {

    private int id;
    private String nombres;
    private String apellidos;
    private String email;
    private String mensaje;

    public ContactoDTO() {}

    public ContactoDTO(int id, String nombres, String apellidos, String email, String mensaje) {
        this.id = id;
        this.nombres = nombres;
        this.apellidos = apellidos;
        this.email = email;
        this.mensaje = mensaje;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNombres() { return nombres; }
    public void setNombres(String nombres) { this.nombres = nombres; }

    public String getApellidos() { return apellidos; }
    public void setApellidos(String apellidos) { this.apellidos = apellidos; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getMensaje() { return mensaje; }
    public void setMensaje(String mensaje) { this.mensaje = mensaje; }
}
