package org.example.proyectoweb.dto;

import java.math.BigDecimal;

public class PropiedadDTO {
    private int id;
    private String titulo;
    private String descripcion;
    private BigDecimal precio;
    private String ubicacion; // Deprecated

    // Foreign Keys y datos para Inserción en la tabla real (RF-02)
    private int idUsuarioAgente;
    private int idTipoInmueble;
    private int idOperacion;
    private int idDistrito;

    private String partidaRegistral;
    private BigDecimal areaTotalM2;
    private int numCocheras;
    private int anioConstruccion;

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
    private String direccion;

    // Datos del agente que publicó
    private String agenteNombre;
    private String agenteTelefono;
    private String agenteCorreo;

    // Campos de consistencia de base de datos
    private String referencia;
    private Integer numPisos;
    private String tour360Url;
    private String fechaPublicacion;
    private String fechaExpiracion;
    private boolean destacada;

    public PropiedadDTO() {
    }

    // Constructor básico legacy
    public PropiedadDTO(int id, String titulo, String descripcion, BigDecimal precio, String ubicacion) {
        this.id = id;
        this.titulo = titulo;
        this.descripcion = descripcion;
        this.precio = precio;
        this.ubicacion = ubicacion;
    }

    // Getters y Setters Básicos
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public BigDecimal getPrecio() {
        return precio;
    }

    public void setPrecio(BigDecimal precio) {
        this.precio = precio;
    }

    public String getUbicacion() {
        return ubicacion;
    }

    public void setUbicacion(String ubicacion) {
        this.ubicacion = ubicacion;
    }

    // Nuevos campos para RF-02
    public int getIdUsuarioAgente() {
        return idUsuarioAgente;
    }

    public void setIdUsuarioAgente(int idUsuarioAgente) {
        this.idUsuarioAgente = idUsuarioAgente;
    }

    public int getIdTipoInmueble() {
        return idTipoInmueble;
    }

    public void setIdTipoInmueble(int idTipoInmueble) {
        this.idTipoInmueble = idTipoInmueble;
    }

    public int getIdOperacion() {
        return idOperacion;
    }

    public void setIdOperacion(int idOperacion) {
        this.idOperacion = idOperacion;
    }

    public int getIdDistrito() {
        return idDistrito;
    }

    public void setIdDistrito(int idDistrito) {
        this.idDistrito = idDistrito;
    }

    public String getPartidaRegistral() {
        return partidaRegistral;
    }

    public void setPartidaRegistral(String partidaRegistral) {
        this.partidaRegistral = partidaRegistral;
    }

    public BigDecimal getAreaTotalM2() {
        return areaTotalM2;
    }

    public void setAreaTotalM2(BigDecimal areaTotalM2) {
        this.areaTotalM2 = areaTotalM2;
    }

    public int getNumCocheras() {
        return numCocheras;
    }

    public void setNumCocheras(int numCocheras) {
        this.numCocheras = numCocheras;
    }

    public int getAnioConstruccion() {
        return anioConstruccion;
    }

    public void setAnioConstruccion(int anioConstruccion) {
        this.anioConstruccion = anioConstruccion;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public String getAgenteNombre() { return agenteNombre; }
    public void setAgenteNombre(String agenteNombre) { this.agenteNombre = agenteNombre; }

    public String getAgenteTelefono() { return agenteTelefono; }
    public void setAgenteTelefono(String agenteTelefono) { this.agenteTelefono = agenteTelefono; }

    public String getAgenteCorreo() { return agenteCorreo; }
    public void setAgenteCorreo(String agenteCorreo) { this.agenteCorreo = agenteCorreo; }

    // Getters y Setters Extendidos
    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getMonedaBase() {
        return monedaBase;
    }

    public void setMonedaBase(String monedaBase) {
        this.monedaBase = monedaBase;
    }

    public BigDecimal getPrecioPen() {
        return precioPen;
    }

    public void setPrecioPen(BigDecimal precioPen) {
        this.precioPen = precioPen;
    }

    public BigDecimal getPrecioUsd() {
        return precioUsd;
    }

    public void setPrecioUsd(BigDecimal precioUsd) {
        this.precioUsd = precioUsd;
    }

    public String getTipoInmueble() {
        return tipoInmueble;
    }

    public void setTipoInmueble(String tipoInmueble) {
        this.tipoInmueble = tipoInmueble;
    }

    public String getOperacion() {
        return operacion;
    }

    public void setOperacion(String operacion) {
        this.operacion = operacion;
    }

    public String getDistrito() {
        return distrito;
    }

    public void setDistrito(String distrito) {
        this.distrito = distrito;
    }

    public String getProvincia() {
        return provincia;
    }

    public void setProvincia(String provincia) {
        this.provincia = provincia;
    }

    public String getDepartamento() {
        return departamento;
    }

    public void setDepartamento(String departamento) {
        this.departamento = departamento;
    }

    public BigDecimal getAreaTechadaM2() {
        return areaTechadaM2;
    }

    public void setAreaTechadaM2(BigDecimal areaTechadaM2) {
        this.areaTechadaM2 = areaTechadaM2;
    }

    public int getNumDormitorios() {
        return numDormitorios;
    }

    public void setNumDormitorios(int numDormitorios) {
        this.numDormitorios = numDormitorios;
    }

    public int getNumBanos() {
        return numBanos;
    }

    public void setNumBanos(int numBanos) {
        this.numBanos = numBanos;
    }

    public int getBonoMiVivienda() {
        return bonoMiVivienda;
    }

    public void setBonoMiVivienda(int bonoMiVivienda) {
        this.bonoMiVivienda = bonoMiVivienda;
    }

    public int getBonoVerde() {
        return bonoVerde;
    }

    public void setBonoVerde(int bonoVerde) {
        this.bonoVerde = bonoVerde;
    }

    // Sprint 2: Multimedia, Favoritos, Vistas
    private String fotoPrincipal;
    private int numeroVistas;
    private boolean favorito; // Flag temporal para la vista
    private java.math.BigDecimal tipoCambioVenta; // Para mostrar referencia
    private java.math.BigDecimal latitud;
    private java.math.BigDecimal longitud;

    public java.math.BigDecimal getLatitud() { return latitud; }
    public void setLatitud(java.math.BigDecimal latitud) { this.latitud = latitud; }
    public java.math.BigDecimal getLongitud() { return longitud; }
    public void setLongitud(java.math.BigDecimal longitud) { this.longitud = longitud; }

    public String getFotoPrincipal() { return fotoPrincipal; }
    public void setFotoPrincipal(String fotoPrincipal) { this.fotoPrincipal = fotoPrincipal; }

    public String getFotoPrincipalUrl(String contextPath) {
        return fotoPrincipalUrl(contextPath);
    }

    public String fotoPrincipalUrl(String contextPath) {
        if (fotoPrincipal == null || fotoPrincipal.isEmpty()) {
            return null;
        }
        if (fotoPrincipal.startsWith("http://") || fotoPrincipal.startsWith("https://")) {
            return fotoPrincipal;
        }
        String path = contextPath;
        if (path == null) path = "";
        String file = fotoPrincipal;
        if (file.startsWith("/")) {
            file = file.substring(1);
        }
        return path + "/" + file;
    }

    public int getNumeroVistas() { return numeroVistas; }
    public void setNumeroVistas(int numeroVistas) { this.numeroVistas = numeroVistas; }

    public boolean isFavorito() { return favorito; }
    public void setFavorito(boolean favorito) { this.favorito = favorito; }

    public BigDecimal getTipoCambioVenta() { return tipoCambioVenta; }
    public void setTipoCambioVenta(BigDecimal tipoCambioVenta) { this.tipoCambioVenta = tipoCambioVenta; }

    // Getters y Setters de consistencia de base de datos
    public String getReferencia() { return referencia; }
    public void setReferencia(String referencia) { this.referencia = referencia; }

    public Integer getNumPisos() { return numPisos; }
    public void setNumPisos(Integer numPisos) { this.numPisos = numPisos; }

    public String getTour360Url() { return tour360Url; }
    public void setTour360Url(String tour360Url) { this.tour360Url = tour360Url; }

    public String getFechaPublicacion() { return fechaPublicacion; }
    public void setFechaPublicacion(String fechaPublicacion) { this.fechaPublicacion = fechaPublicacion; }

    public String getFechaExpiracion() { return fechaExpiracion; }
    public void setFechaExpiracion(String fechaExpiracion) { this.fechaExpiracion = fechaExpiracion; }

    public boolean isDestacada() { return destacada; }
    public void setDestacada(boolean destacada) { this.destacada = destacada; }
}
