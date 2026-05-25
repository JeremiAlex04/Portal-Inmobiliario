package org.example.proyectoweb.dto;

public class UbicacionDTO {
    private int id;
    private int parentId; // id_departamento for provincia, id_provincia for distrito
    private String parentNombre; // Name of the parent
    private String nombre;
    private String codigoUbigeo;
    private String tipo; // "DEPARTAMENTO", "PROVINCIA", "DISTRITO"

    public UbicacionDTO() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getParentId() { return parentId; }
    public void setParentId(int parentId) { this.parentId = parentId; }

    public String getParentNombre() { return parentNombre; }
    public void setParentNombre(String parentNombre) { this.parentNombre = parentNombre; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getCodigoUbigeo() { return codigoUbigeo; }
    public void setCodigoUbigeo(String codigoUbigeo) { this.codigoUbigeo = codigoUbigeo; }

    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }
}
