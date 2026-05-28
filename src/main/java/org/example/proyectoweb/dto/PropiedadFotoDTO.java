package org.example.proyectoweb.dto;

public class PropiedadFotoDTO {
    private int id;
    private int idPropiedad;
    private String rutaArchivo;
    private int orden;
    private boolean esPrincipal;
    private String fechaSubida;

    public PropiedadFotoDTO() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getIdPropiedad() { return idPropiedad; }
    public void setIdPropiedad(int idPropiedad) { this.idPropiedad = idPropiedad; }

    public String getRutaArchivo() { return rutaArchivo; }
    public void setRutaArchivo(String rutaArchivo) { this.rutaArchivo = rutaArchivo; }

    public String getRutaArchivoUrl(String contextPath) {
        if (rutaArchivo == null || rutaArchivo.isEmpty()) {
            return null;
        }
        if (rutaArchivo.startsWith("http://") || rutaArchivo.startsWith("https://")) {
            return rutaArchivo;
        }
        String path = contextPath;
        if (path == null) path = "";
        String file = rutaArchivo;
        if (file.startsWith("/")) {
            file = file.substring(1);
        }
        return path + "/" + file;
    }

    public int getOrden() { return orden; }
    public void setOrden(int orden) { this.orden = orden; }

    public boolean isEsPrincipal() { return esPrincipal; }
    public void setEsPrincipal(boolean esPrincipal) { this.esPrincipal = esPrincipal; }

    public String getFechaSubida() { return fechaSubida; }
    public void setFechaSubida(String fechaSubida) { this.fechaSubida = fechaSubida; }
}
