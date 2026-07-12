package org.example.proyectoweb.bean;

import jakarta.enterprise.context.RequestScoped;
import jakarta.faces.context.FacesContext;
import jakarta.inject.Inject;
import jakarta.inject.Named;
import org.example.proyectoweb.dao.ConsultaDAO;
import org.example.proyectoweb.dao.WhatsAppDAO;
import org.example.proyectoweb.dao.GaleriaDAO;
import org.example.proyectoweb.dao.EstadisticaDAO;
import org.example.proyectoweb.dto.ConsultaDTO;
import org.example.proyectoweb.dto.PropiedadDTO;
import org.example.proyectoweb.dto.PropiedadFotoDTO;
import org.example.proyectoweb.dto.EstadisticaDiariaDTO;
import org.example.proyectoweb.dto.UsuarioDTO;
import org.example.proyectoweb.facade.PropiedadFacade;
import org.example.proyectoweb.facade.UsuarioFacade;

import java.util.List;
import java.util.ArrayList;

@Named("agenteBean")
@RequestScoped
public class AgenteBean {

    @Inject
    private AuthBean authBean;

    private PropiedadFacade propiedadFacade = new PropiedadFacade();

    private void logDebug(String msg) {
        try {
            java.io.File file = new java.io.File("C:\\Users\\oliva\\.gemini\\antigravity-ide\\brain\\57749d47-ff45-4c4b-9454-5b36efa834e3\\scratch\\debug_profile.log");
            file.getParentFile().mkdirs();
            try (java.io.FileWriter fw = new java.io.FileWriter(file, true);
                 java.io.PrintWriter pw = new java.io.PrintWriter(fw)) {
                pw.println("[" + new java.util.Date() + "] " + msg);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public AgenteBean() {
        logDebug("AgenteBean instantiated. HashCode=" + this.hashCode());
    }
    private ConsultaDAO consultaDAO = new ConsultaDAO();
    private WhatsAppDAO whatsAppDAO = new WhatsAppDAO();
    private UsuarioFacade usuarioFacade = new UsuarioFacade();
    private GaleriaDAO galeriaDAO = new GaleriaDAO();
    private EstadisticaDAO estadisticaDAO = new EstadisticaDAO();

    private String filtroEstado;
    private String filtroOrden;
    private String filtroConsultaEstado;

    private PropiedadDTO nuevaPropiedad = new PropiedadDTO();
    private List<String> fotosGaleria = new ArrayList<>();

    // Alert triggers
    private boolean propiedadGuardadaExito;
    private boolean errorPublicacion;
    private boolean limiteAlcanzado;
    private String mensajeError;
    private Integer idEdicion;

    // Perfil del agente
    private UsuarioDTO perfil;
    private boolean perfilGuardadoExito;
    private boolean errorPerfil;
    private String mensajeErrorPerfil;

    public boolean isPropiedadGuardadaExito() { return propiedadGuardadaExito; }
    public boolean isErrorPublicacion() { return errorPublicacion; }
    public boolean isLimiteAlcanzado() { return limiteAlcanzado; }
    public String getMensajeError() { return mensajeError; }
    public Integer getIdEdicion() { return idEdicion; }
    public void setIdEdicion(Integer idEdicion) { this.idEdicion = idEdicion; }

    // Analytics dynamic properties
    private int totalVistas;
    private double promedioDiario;
    private double promedioDistrito;
    private int maxVistas;
    private String diaMax;
    private String labelsJson = "[]";
    private String dataJson = "[]";

    public int getTotalVistas() { return totalVistas; }
    public double getPromedioDiario() { return promedioDiario; }
    public double getPromedioDistrito() { return promedioDistrito; }
    public int getMaxVistas() { return maxVistas; }
    public String getDiaMax() { return diaMax; }
    public String getLabelsJson() { return labelsJson; }
    public String getDataJson() { return dataJson; }

    public void cargarEstadisticas(int idPropiedad) {
        PropiedadDTO p = propiedadFacade.obtenerPropiedad(idPropiedad);
        if (p == null) return;
        
        List<EstadisticaDiariaDTO> vistas30d = estadisticaDAO.obtenerVistas30Dias(idPropiedad);
        this.totalVistas = estadisticaDAO.obtenerTotalVistas(idPropiedad);

        int sumVistas = 0;
        this.maxVistas = 0;
        this.diaMax = "-";
        for (EstadisticaDiariaDTO e : vistas30d) {
            sumVistas += e.getNumVistas();
            if (e.getNumVistas() > this.maxVistas) {
                this.maxVistas = e.getNumVistas();
                this.diaMax = e.getFecha();
            }
        }
        this.promedioDiario = vistas30d.isEmpty() ? 0 : (double) sumVistas / vistas30d.size();
        this.promedioDistrito = estadisticaDAO.obtenerPromedioDistrito(p.getIdDistrito());

        // Generar JSON para Chart.js
        StringBuilder labelsJsonBuilder = new StringBuilder("[");
        StringBuilder dataJsonBuilder = new StringBuilder("[");
        for (int i = 0; i < vistas30d.size(); i++) {
            if (i > 0) { labelsJsonBuilder.append(","); dataJsonBuilder.append(","); }
            labelsJsonBuilder.append("'").append(vistas30d.get(i).getFecha()).append("'");
            dataJsonBuilder.append(vistas30d.get(i).getNumVistas());
        }
        labelsJsonBuilder.append("]");
        dataJsonBuilder.append("]");

        this.labelsJson = labelsJsonBuilder.toString();
        this.dataJson = dataJsonBuilder.toString();
    }

    public PropiedadDTO getNuevaPropiedad() {
        if (nuevaPropiedad == null || nuevaPropiedad.getId() == 0) {
            String idStr = jakarta.faces.context.FacesContext.getCurrentInstance().getExternalContext().getRequestParameterMap().get("id");
            if (idStr == null || idStr.isEmpty()) {
                idStr = jakarta.faces.context.FacesContext.getCurrentInstance().getExternalContext().getRequestParameterMap().get("editIdEdicion");
            }
            if (idStr != null && !idStr.isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr);
                    if (id > 0) {
                        prepararEdicion(id);
                    }
                } catch (Exception e) {
                    // ignore
                }
            }
        }
        return nuevaPropiedad;
    }

    public void setNuevaPropiedad(PropiedadDTO nuevaPropiedad) {
        this.nuevaPropiedad = nuevaPropiedad;
    }

    public List<String> getFotosGaleria() {
        return fotosGaleria;
    }

    public void setFotosGaleria(List<String> fotosGaleria) {
        this.fotosGaleria = fotosGaleria;
    }

    public void agregarFotoGaleria() {
        if (fotosGaleria == null) {
            fotosGaleria = new ArrayList<>();
        }
        fotosGaleria.add("");
    }

    public void removerFotoGaleria(int index) {
        if (fotosGaleria != null && index >= 0 && index < fotosGaleria.size()) {
            fotosGaleria.remove(index);
        }
    }

    public void cargarPropiedadEdicion() {
        if (idEdicion != null && idEdicion > 0) {
            prepararEdicion(idEdicion);
        } else {
            prepararNuevo();
        }
    }

    public void inicializarEdicionPanel() {
        logDebug("inicializarEdicionPanel() called. seccion=" + seccion + ", idEdicion=" + idEdicion);
        if ("editar".equals(seccion)) {
            if (idEdicion != null && idEdicion > 0) {
                prepararEdicion(idEdicion);
            }
        }
    }

    public void prepararEdicion(int id) {
        this.propiedadGuardadaExito = false;
        this.errorPublicacion = false;
        this.limiteAlcanzado = false;
        this.mensajeError = null;

        PropiedadDTO p = propiedadFacade.obtenerPropiedad(id);
        if (p != null) {
            this.nuevaPropiedad = p;
            
            // Cargar fotos de la galeria de la base de datos
            List<PropiedadFotoDTO> fotos = galeriaDAO.obtenerFotos(id);
            this.fotosGaleria = new ArrayList<>();
            if (fotos != null) {
                for (PropiedadFotoDTO f : fotos) {
                    this.fotosGaleria.add(f.getRutaArchivo());
                }
            }
        } else {
            this.nuevaPropiedad = new PropiedadDTO();
            this.fotosGaleria = new ArrayList<>();
        }
    }

    public void prepararNuevo() {
        this.propiedadGuardadaExito = false;
        this.errorPublicacion = false;
        this.limiteAlcanzado = false;
        this.mensajeError = null;

        this.nuevaPropiedad = new PropiedadDTO();
        this.fotosGaleria = new ArrayList<>();
        // default coordinates
        this.nuevaPropiedad.setLatitud(new java.math.BigDecimal("-12.046374"));
        this.nuevaPropiedad.setLongitud(new java.math.BigDecimal("-77.042793"));
    }

    public String guardarPropiedad() {
        if (!authBean.isLogueado()) return "/login.xhtml?faces-redirect=true";

        this.propiedadGuardadaExito = false;
        this.errorPublicacion = false;
        this.limiteAlcanzado = false;
        this.mensajeError = null;

        nuevaPropiedad.setIdUsuarioAgente((int) authBean.getUsuario().getIdUsuario());
        
        // Defaults if needed
        if (nuevaPropiedad.getLatitud() == null) {
            nuevaPropiedad.setLatitud(new java.math.BigDecimal("-12.046374"));
        }
        if (nuevaPropiedad.getLongitud() == null) {
            nuevaPropiedad.setLongitud(new java.math.BigDecimal("-77.042793"));
        }

        // Validate rules using facade
        String errorMsg = propiedadFacade.validarPropiedad(nuevaPropiedad);
        if (errorMsg != null) {
            this.mensajeError = errorMsg;
            this.errorPublicacion = true;
            return null;
        }

        // Limit check for new properties
        if (nuevaPropiedad.getId() == 0) {
            int idAgente = (int) authBean.getUsuario().getIdUsuario();
            int activeCount = propiedadFacade.contarPropiedadesActivas(idAgente);
            int limit = propiedadFacade.obtenerLimitePublicaciones(idAgente);
            if (activeCount >= limit) {
                this.limiteAlcanzado = true;
                return null;
            }
            nuevaPropiedad.setEstado("ACTIVO");
        }

        boolean ok;
        if (nuevaPropiedad.getId() > 0) {
            ok = propiedadFacade.actualizarPropiedad(nuevaPropiedad);
        } else {
            ok = propiedadFacade.registrarPropiedad(nuevaPropiedad);
        }

        if (ok) {
            int propId = nuevaPropiedad.getId();
            
            // Persistir fotos secundarias a la galeria (sincronizar base de datos)
            galeriaDAO.eliminarFotosPorPropiedad(propId);
            if (fotosGaleria != null) {
                int orden = 0;
                for (String url : fotosGaleria) {
                    if (url != null && !url.trim().isEmpty()) {
                        PropiedadFotoDTO foto = new PropiedadFotoDTO();
                        foto.setIdPropiedad(propId);
                        foto.setRutaArchivo(url.trim());
                        foto.setOrden(orden++);
                        foto.setEsPrincipal(false);
                        galeriaDAO.agregarFoto(foto);
                    }
                }
            }
            
            jakarta.faces.context.FacesContext.getCurrentInstance().getExternalContext().getFlash().put("propiedadPublicada", true);
            nuevaPropiedad = new PropiedadDTO();
            fotosGaleria = new ArrayList<>();
            return "/agente/panel.xhtml?seccion=propiedades&faces-redirect=true";
        } else {
            this.mensajeError = "Ocurrió un error inesperado al actualizar la base de datos.";
            this.errorPublicacion = true;
            return null;
        }
    }

    public String cambiarEstadoPropiedad(int idPropiedad, String nuevoEstado) {
        if (!authBean.isLogueado()) return "/login.xhtml?faces-redirect=true";
        boolean ok = propiedadFacade.cambiarEstadoPropiedad(idPropiedad, nuevoEstado);
        if (ok) {
            jakarta.faces.context.FacesContext.getCurrentInstance().getExternalContext().getFlash().put("estadoCambiado", true);
        }
        return "/agente/panel.xhtml?seccion=propiedades&faces-redirect=true";
    }

    public String eliminarPropiedad(int idPropiedad) {
        if (!authBean.isLogueado()) return "/login.xhtml?faces-redirect=true";
        boolean ok = propiedadFacade.eliminarPropiedad(idPropiedad);
        if (ok) {
            jakarta.faces.context.FacesContext.getCurrentInstance().getExternalContext().getFlash().put("propiedadEliminada", true);
        }
        return "/agente/panel.xhtml?seccion=propiedades&faces-redirect=true";
    }

    public String cambiarEstadoConsulta(int idConsulta, String nuevoEstado) {
        if (!authBean.isLogueado()) return "/login.xhtml?faces-redirect=true";
        System.out.println("[AgenteBean] cambiarEstadoConsulta: idConsulta=" + idConsulta + ", nuevoEstado=" + nuevoEstado);
        boolean ok = consultaDAO.cambiarEstadoConsulta(idConsulta, nuevoEstado);
        System.out.println("[AgenteBean] cambiarEstadoConsulta result: " + ok);
        return null;
    }

    public List<org.example.proyectoweb.dto.CatalogoDTO> getListaTipos() {
        return propiedadFacade.obtenerTiposInmueble();
    }

    public List<org.example.proyectoweb.dto.CatalogoDTO> getListaOperaciones() {
        return propiedadFacade.obtenerOperaciones();
    }

    public List<org.example.proyectoweb.dto.CatalogoDTO> getListaDistritos() {
        return propiedadFacade.obtenerDistritos();
    }

    public List<PropiedadDTO> getMisPropiedades() {
        if (!authBean.isLogueado()) return List.of();
        return propiedadFacade.obtenerPropiedadesAgenteConFiltros(
                authBean.getUsuario().getIdUsuario(),
                filtroEstado, filtroOrden);
    }

    public List<ConsultaDTO> getConsultas() {
        if (!authBean.isLogueado()) return List.of();
        return consultaDAO.listarConsultasPorAgente(
                authBean.getUsuario().getIdUsuario(),
                filtroConsultaEstado);
    }

    public int getConsultasPendientes() {
        if (!authBean.isLogueado()) return 0;
        return consultaDAO.contarConsultasPendientes(authBean.getUsuario().getIdUsuario());
    }

    public int getWhatsappSemana() {
        if (!authBean.isLogueado()) return 0;
        return whatsAppDAO.contarContactosSemana(authBean.getUsuario().getIdUsuario());
    }

    public String getSeccion() {
        logDebug("getSeccion() called. Current field value=" + seccion);
        if (seccion == null || seccion.isEmpty() || "propiedades".equals(seccion)) {
            String param = null;
            java.util.Map<String, String> map = jakarta.faces.context.FacesContext.getCurrentInstance().getExternalContext().getRequestParameterMap();
            if (map.containsKey("seccion")) param = map.get("seccion");
            else if (map.containsKey("editSeccion")) param = map.get("editSeccion");
            else if (map.containsKey("seccion1")) param = map.get("seccion1");
            else if (map.containsKey("seccion2")) param = map.get("seccion2");
            else if (map.containsKey("perfilForm:seccion")) param = map.get("perfilForm:seccion");
            else if (map.containsKey("editForm:seccion")) param = map.get("editForm:seccion");

            logDebug("getSeccion() fallback check. Request param seccion=" + param);
            if (param != null && !param.isEmpty()) {
                seccion = param;
            }
        }
        logDebug("getSeccion() returning=" + seccion);
        return seccion;
    }
    public void setSeccion(String seccion) { 
        logDebug("setSeccion(" + seccion + ") called. isPostback=" + jakarta.faces.context.FacesContext.getCurrentInstance().isPostback());
        if (jakarta.faces.context.FacesContext.getCurrentInstance().isPostback() && (seccion == null || seccion.isEmpty())) {
            logDebug("setSeccion ignored null/empty on postback.");
            return;
        }
        this.seccion = seccion; 
        logDebug("setSeccion field value set to=" + this.seccion);
    }
    private String seccion = "propiedades";

    public UsuarioDTO getAgente() {
        String idStr = FacesContext.getCurrentInstance().getExternalContext().getRequestParameterMap().get("id");
        if (idStr != null) {
            return usuarioFacade.obtenerUsuarioPorId(Integer.parseInt(idStr));
        }
        return authBean.getUsuario();
    }

    // Getters y Setters
    public String getFiltroEstado() { return filtroEstado; }
    public void setFiltroEstado(String filtroEstado) { this.filtroEstado = filtroEstado; }
    public String getFiltroOrden() { return filtroOrden; }
    public void setFiltroOrden(String filtroOrden) { this.filtroOrden = filtroOrden; }
    public String getFiltroConsultaEstado() { return filtroConsultaEstado; }
    public void setFiltroConsultaEstado(String filtroConsultaEstado) { this.filtroConsultaEstado = filtroConsultaEstado; }

    public UsuarioDTO getPerfil() {
        logDebug("getPerfil() called. Current perfil field null=" + (perfil == null));
        if (perfil == null) {
            UsuarioDTO u = authBean.getUsuario();
            logDebug("getPerfil() lazy-load session user null=" + (u == null));
            if (u != null) {
                perfil = new UsuarioDTO();
                perfil.setIdUsuario(u.getIdUsuario());
                perfil.setIdRol(u.getIdRol());
                perfil.setNombres(u.getNombres());
                perfil.setApellidos(u.getApellidos());
                perfil.setCorreo(u.getCorreo());
                perfil.setRolNombre(u.getRolNombre());
                perfil.setFechaRegistro(u.getFechaRegistro());
                logDebug("getPerfil() created new local copy. id=" + perfil.getIdUsuario() + " Nombres=" + perfil.getNombres());
            }
        } else {
            logDebug("getPerfil() returning existing copy. id=" + perfil.getIdUsuario() + " Nombres=" + perfil.getNombres());
        }
        return perfil;
    }

    public void setPerfil(UsuarioDTO perfil) {
        logDebug("setPerfil(" + (perfil == null ? "null" : perfil.getNombres()) + ") called.");
        this.perfil = perfil;
    }

    public boolean isPerfilGuardadoExito() { return perfilGuardadoExito; }
    public boolean isErrorPerfil() { return errorPerfil; }
    public String getMensajeErrorPerfil() { return mensajeErrorPerfil; }

    public String actualizarPerfil() {
        logDebug("actualizarPerfil() invoked.");
        if (!authBean.isLogueado()) {
            logDebug("actualizarPerfil() aborted: User not logged in.");
            return "/login.xhtml?faces-redirect=true";
        }
        this.perfilGuardadoExito = false;
        this.errorPerfil = false;
        this.mensajeErrorPerfil = null;

        if (perfil == null) {
            logDebug("actualizarPerfil() error: perfil field is null!");
            this.mensajeErrorPerfil = "Los datos del perfil no se han cargado correctamente.";
            this.errorPerfil = true;
            return null;
        }

        logDebug("actualizarPerfil() state: id=" + perfil.getIdUsuario() + ", Nombres=" + perfil.getNombres() + ", Apellidos=" + perfil.getApellidos() + ", Correo=" + perfil.getCorreo());

        if (perfil.getNombres() == null || perfil.getNombres().trim().isEmpty()) {
            logDebug("actualizarPerfil() validation failed: Nombres empty.");
            this.mensajeErrorPerfil = "El nombre es obligatorio.";
            this.errorPerfil = true;
            return null;
        }
        if (perfil.getApellidos() == null || perfil.getApellidos().trim().isEmpty()) {
            logDebug("actualizarPerfil() validation failed: Apellidos empty.");
            this.mensajeErrorPerfil = "Los apellidos son obligatorios.";
            this.errorPerfil = true;
            return null;
        }
        if (perfil.getCorreo() == null || perfil.getCorreo().trim().isEmpty() || !perfil.getCorreo().matches("^[\\w._%+-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
            logDebug("actualizarPerfil() validation failed: Correo invalid=" + perfil.getCorreo());
            this.mensajeErrorPerfil = "El formato del correo electrónico no es válido.";
            this.errorPerfil = true;
            return null;
        }

        UsuarioDTO sesion = authBean.getUsuario();
        if (!sesion.getCorreo().equalsIgnoreCase(perfil.getCorreo()) && usuarioFacade.existeCorreo(perfil.getCorreo())) {
            logDebug("actualizarPerfil() validation failed: Correo already registered.");
            this.mensajeErrorPerfil = "El correo ya se encuentra registrado por otro usuario.";
            this.errorPerfil = true;
            return null;
        }

        boolean ok = usuarioFacade.editarUsuario(perfil);
        logDebug("actualizarPerfil() db update ok=" + ok);
        if (ok) {
            sesion.setNombres(perfil.getNombres());
            sesion.setApellidos(perfil.getApellidos());
            sesion.setCorreo(perfil.getCorreo());
            
            jakarta.faces.context.FacesContext.getCurrentInstance().getExternalContext().getSessionMap().put("usuarioLogueado", sesion);
            
            this.perfilGuardadoExito = true;
            logDebug("actualizarPerfil() successful. Redirecting.");
            jakarta.faces.context.FacesContext.getCurrentInstance().getExternalContext().getFlash().put("perfilActualizado", true);
            return "/agente/panel.xhtml?seccion=perfil&faces-redirect=true";
        } else {
            logDebug("actualizarPerfil() error: db update failed.");
            this.mensajeErrorPerfil = "Error al guardar los datos del perfil en la base de datos.";
            this.errorPerfil = true;
            return null;
        }
    }
}
