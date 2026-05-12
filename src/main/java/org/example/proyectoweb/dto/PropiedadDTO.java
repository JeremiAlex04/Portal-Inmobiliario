package org.example.proyectoweb.dto;

import java.math.BigDecimal;

public class PropiedadDTO {
    private int id;
    private String titulo;
    private String descripcion;
    private BigDecimal precio;
    private String ubicacion;

    // Campos extendidos para el catálogo (v_propiedades_bimonetarias)
    private String estado;
    private String monedaBase;
    private BigDecimal precioPen;
    private BigDecimal precioUsd;
    private String tipoInmueble;
    private String operacion;
    private String distrito;
    private String provincia;
    private String departamento;
    private BigDecimal areaTechadaM2;
    private int numDormitorios;
    private int numBanos;
    private int bonoMiVivienda;
    private int bonoVerde;

    public PropiedadDTO() {}

    // Constructor básico legacy
    public PropiedadDTO(int id, String titulo, String descripcion, BigDecimal precio, String ubicacion) {
        this.id = id;
        this.titulo = titulo;
        this.descripcion = descripcion;
        this.precio = precio;
        this.ubicacion = ubicacion;
    }

    // Getters y Setters Básicos
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }
    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }
    public BigDecimal getPrecio() { return precio; }
    public void setPrecio(BigDecimal precio) { this.precio = precio; }
    public String getUbicacion() { return ubicacion; }
    public void setUbicacion(String ubicacion) { this.ubicacion = ubicacion; }

    // Getters y Setters Extendidos
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    public String getMonedaBase() { return monedaBase; }
    public void setMonedaBase(String monedaBase) { this.monedaBase = monedaBase; }
    public BigDecimal getPrecioPen() { return precioPen; }
    public void setPrecioPen(BigDecimal precioPen) { this.precioPen = precioPen; }
    public BigDecimal getPrecioUsd() { return precioUsd; }
    public void setPrecioUsd(BigDecimal precioUsd) { this.precioUsd = precioUsd; }
    public String getTipoInmueble() { return tipoInmueble; }
    public void setTipoInmueble(String tipoInmueble) { this.tipoInmueble = tipoInmueble; }
    public String getOperacion() { return operacion; }
    public void setOperacion(String operacion) { this.operacion = operacion; }
    public String getDistrito() { return distrito; }
    public void setDistrito(String distrito) { this.distrito = distrito; }
    public String getProvincia() { return provincia; }
    public void setProvincia(String provincia) { this.provincia = provincia; }
    public String getDepartamento() { return departamento; }
    public void setDepartamento(String departamento) { this.departamento = departamento; }
    public BigDecimal getAreaTechadaM2() { return areaTechadaM2; }
    public void setAreaTechadaM2(BigDecimal areaTechadaM2) { this.areaTechadaM2 = areaTechadaM2; }
    public int getNumDormitorios() { return numDormitorios; }
    public void setNumDormitorios(int numDormitorios) { this.numDormitorios = numDormitorios; }
    public int getNumBanos() { return numBanos; }
    public void setNumBanos(int numBanos) { this.numBanos = numBanos; }
    public int getBonoMiVivienda() { return bonoMiVivienda; }
    public void setBonoMiVivienda(int bonoMiVivienda) { this.bonoMiVivienda = bonoMiVivienda; }
    public int getBonoVerde() { return bonoVerde; }
    public void setBonoVerde(int bonoVerde) { this.bonoVerde = bonoVerde; }
}
