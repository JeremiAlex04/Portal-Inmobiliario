package org.example.proyectoweb.model;

import java.math.BigDecimal;

public class Propiedad {
    private int id;
    private int idUsuario;
    private String titulo;
    private String descripcion;
    private BigDecimal precio;
    private String ubicacion;
    private String operacion;
    private int idTipoInmueble;

    public Propiedad() {
    }

    public Propiedad(int id, int idUsuario, String titulo, String descripcion, BigDecimal precio, String ubicacion, String operacion, int idTipoInmueble) {
        this.id = id;
        this.idUsuario = idUsuario;
        this.titulo = titulo;
        this.descripcion = descripcion;
        this.precio = precio;
        this.ubicacion = ubicacion;
        this.operacion = operacion;
        this.idTipoInmueble = idTipoInmueble;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }

    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public BigDecimal getPrecio() { return precio; }
    public void setPrecio(BigDecimal precio) { this.precio = precio; }

    public String getUbicacion() { return ubicacion; }
    public void setUbicacion(String ubicacion) { this.ubicacion = ubicacion; }

    public String getOperacion() { return operacion; }
    public void setOperacion(String operacion) { this.operacion = operacion; }

    public int getIdTipoInmueble() { return idTipoInmueble; }
    public void setIdTipoInmueble(int idTipoInmueble) { this.idTipoInmueble = idTipoInmueble; }
}
