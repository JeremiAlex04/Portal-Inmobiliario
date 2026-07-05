package org.example.proyectoweb.bean;

import jakarta.enterprise.context.RequestScoped;
import jakarta.faces.context.FacesContext;
import jakarta.inject.Named;
import org.example.proyectoweb.dto.PropiedadDTO;
import org.example.proyectoweb.facade.PropiedadFacade;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Named("propiedadBean")
@RequestScoped
public class PropiedadBean {

    private PropiedadFacade propiedadFacade = new PropiedadFacade();

    private String keyword;
    private String operacion;
    private String tipoInmueble;
    private BigDecimal precioMin;
    private BigDecimal precioMax;
    private Integer dormitorios;
    private Integer banos;
    private int pagina = 1;
    private static final int LIMIT = 12;

    private List<PropiedadDTO> propiedades;
    private Integer totalPaginas;
    private List<Integer> paginas;

    public List<PropiedadDTO> getPropiedadesDestacadas() {
        return propiedadFacade.obtenerPropiedadesDestacadas(6);
    }

    public List<PropiedadDTO> getPropiedades() {
        if (propiedades == null) cargar();
        return propiedades;
    }

    public int getTotalPaginas() {
        if (totalPaginas == null) cargar();
        return totalPaginas;
    }

    public List<Integer> getPaginas() {
        if (paginas == null) {
            paginas = new ArrayList<>();
            for (int i = 1; i <= getTotalPaginas(); i++) paginas.add(i);
        }
        return paginas;
    }

    private void cargar() {
        int offset = (pagina - 1) * LIMIT;
        propiedades = propiedadFacade.buscarPropiedadesAvanzado(keyword, operacion, tipoInmueble,
                precioMin, precioMax, dormitorios, banos, offset, LIMIT);
        int total = propiedadFacade.contarPropiedadesAvanzado(keyword, operacion, tipoInmueble,
                precioMin, precioMax, dormitorios, banos);
        totalPaginas = (int) Math.ceil((double) total / LIMIT);
    }

    public String buscar() {
        pagina = 1;
        propiedades = null;
        totalPaginas = null;
        paginas = null;
        return "propiedades";
    }

    public String limpiar() {
        keyword = null;
        operacion = null;
        tipoInmueble = null;
        precioMin = null;
        precioMax = null;
        dormitorios = null;
        banos = null;
        pagina = 1;
        propiedades = null;
        totalPaginas = null;
        paginas = null;
        return null;
    }

    public String irPagina() {
        String pagStr = FacesContext.getCurrentInstance()
                .getExternalContext().getRequestParameterMap().get("pagina");
        if (pagStr != null) {
            pagina = Integer.parseInt(pagStr);
            propiedades = null;
            totalPaginas = null;
            paginas = null;
        }
        return null;
    }

    public String verDetalle(int id) {
        return "/detalle_propiedad.xhtml?id=" + id + "&faces-redirect=true";
    }

    public List<org.example.proyectoweb.dto.CatalogoDTO> getListaDistritos() {
        return propiedadFacade.obtenerDistritos();
    }

    public List<org.example.proyectoweb.dto.CatalogoDTO> getListaTipos() {
        return propiedadFacade.obtenerTiposInmueble();
    }

    // Getters y Setters
    public String getKeyword() { return keyword; }
    public void setKeyword(String keyword) { this.keyword = keyword; }

    public String getOperacion() { return operacion; }
    public void setOperacion(String operacion) { this.operacion = operacion; }

    public String getTipoInmueble() { return tipoInmueble; }
    public void setTipoInmueble(String tipoInmueble) { this.tipoInmueble = tipoInmueble; }

    public BigDecimal getPrecioMin() { return precioMin; }
    public void setPrecioMin(BigDecimal precioMin) { this.precioMin = precioMin; }

    public BigDecimal getPrecioMax() { return precioMax; }
    public void setPrecioMax(BigDecimal precioMax) { this.precioMax = precioMax; }

    public Integer getDormitorios() { return dormitorios; }
    public void setDormitorios(Integer dormitorios) { this.dormitorios = dormitorios; }

    public Integer getBanos() { return banos; }
    public void setBanos(Integer banos) { this.banos = banos; }

    public int getPagina() { return pagina; }
    public void setPagina(int pagina) { this.pagina = pagina; }
}
