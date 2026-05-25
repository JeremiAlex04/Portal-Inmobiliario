package org.example.proyectoweb.dto;

public class PlanDTO {
    private int id;
    private String nombre;
    private java.math.BigDecimal precioPen;
    private int duracionDias;
    private int maxPropiedades;
    private int maxFotos;
    private boolean destacada;
    private boolean analytics;
    private String descripcion;

    public PlanDTO() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public java.math.BigDecimal getPrecioPen() { return precioPen; }
    public void setPrecioPen(java.math.BigDecimal precioPen) { this.precioPen = precioPen; }

    public int getDuracionDias() { return duracionDias; }
    public void setDuracionDias(int duracionDias) { this.duracionDias = duracionDias; }

    public int getMaxPropiedades() { return maxPropiedades; }
    public void setMaxPropiedades(int maxPropiedades) { this.maxPropiedades = maxPropiedades; }

    public int getMaxFotos() { return maxFotos; }
    public void setMaxFotos(int maxFotos) { this.maxFotos = maxFotos; }

    public boolean isDestacada() { return destacada; }
    public void setDestacada(boolean destacada) { this.destacada = destacada; }

    public boolean isAnalytics() { return analytics; }
    public void setAnalytics(boolean analytics) { this.analytics = analytics; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }
}
