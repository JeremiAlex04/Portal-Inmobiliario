package org.example.proyectoweb.dto;

public class EventoAuditoriaDTO {
    private long idEvento;
    private Integer idUsuario;
    private String usuarioNombre;
    private String entidad;
    private long idEntidad;
    private String accion;
    private String ipOrigen;
    private String userAgent;
    private String detalleJson;
    private String fechaEvento;

    public EventoAuditoriaDTO() {}

    public long getIdEvento() { return idEvento; }
    public void setIdEvento(long idEvento) { this.idEvento = idEvento; }

    public Integer getIdUsuario() { return idUsuario; }
    public void setIdUsuario(Integer idUsuario) { this.idUsuario = idUsuario; }

    public String getUsuarioNombre() { return usuarioNombre; }
    public void setUsuarioNombre(String usuarioNombre) { this.usuarioNombre = usuarioNombre; }

    public String getEntidad() { return entidad; }
    public void setEntidad(String entidad) { this.entidad = entidad; }

    public long getIdEntidad() { return idEntidad; }
    public void setIdEntidad(long idEntidad) { this.idEntidad = idEntidad; }

    public String getAccion() { return accion; }
    public void setAccion(String accion) { this.accion = accion; }

    public String getIpOrigen() { return ipOrigen; }
    public void setIpOrigen(String ipOrigen) { this.ipOrigen = ipOrigen; }

    public String getUserAgent() { return userAgent; }
    public void setUserAgent(String userAgent) { this.userAgent = userAgent; }

    public String getDetalleJson() { return detalleJson; }
    public void setDetalleJson(String detalleJson) { this.detalleJson = detalleJson; }

    public String getFechaEvento() { return fechaEvento; }
    public void setFechaEvento(String fechaEvento) { this.fechaEvento = fechaEvento; }
}
