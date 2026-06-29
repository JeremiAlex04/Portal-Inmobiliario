package org.example.proyectoweb.bean;

import jakarta.enterprise.context.RequestScoped;
import jakarta.faces.context.FacesContext;
import jakarta.inject.Inject;
import jakarta.inject.Named;
import jakarta.servlet.http.HttpServletRequest;
import org.example.proyectoweb.dto.EventoAuditoriaDTO;
import org.example.proyectoweb.dto.PropiedadDTO;
import org.example.proyectoweb.dto.UbicacionDTO;
import org.example.proyectoweb.dto.UsuarioDTO;
import org.example.proyectoweb.facade.AuditoriaFacade;
import org.example.proyectoweb.facade.PropiedadFacade;
import org.example.proyectoweb.facade.UbicacionFacade;
import org.example.proyectoweb.facade.UsuarioFacade;

import java.util.List;

@Named("adminBean")
@RequestScoped
public class AdminBean {

    @Inject
    private AuthBean authBean;

    private UsuarioFacade usuarioFacade = new UsuarioFacade();
    private PropiedadFacade propiedadFacade = new PropiedadFacade();
    private UbicacionFacade ubicacionFacade = new UbicacionFacade();
    private AuditoriaFacade auditoriaFacade = new AuditoriaFacade();

    // ============================================================
    // Dashboard
    // ============================================================
    public int getTotalUsuarios() { return usuarioFacade.contarUsuariosPorRol(0); }
    public int getTotalAgentes() { return usuarioFacade.contarUsuariosPorRol(3); }
    public int getTotalPropiedades() { return propiedadFacade.contarPropiedades(null, null, null); }
    public int getPropActivas() { return usuarioFacade.contarPropiedadesActivas(); }
    public int getPropVendidas() { return usuarioFacade.contarPropiedadesVendidas(); }
    public int getPropPausadas() { return usuarioFacade.contarPropiedadesPausadas(); }
    public int getPropBorradores() { return usuarioFacade.contarPropiedadesBorradores(); }

    public List<UsuarioDTO> getUltimosUsuarios() { return usuarioFacade.listarUsuarios(); }
    public List<PropiedadDTO> getUltimasPropiedades() { return propiedadFacade.listarPropiedades(0, 5); }

    // ============================================================
    // Usuarios
    // ============================================================
    public List<UsuarioDTO> getListaUsuarios() { return usuarioFacade.listarUsuarios(); }

    private String filtroUsuario;
    private String busquedaUsuario;

    public String buscarUsuarios() {
        return "/admin/usuarios.xhtml?faces-redirect=true";
    }

    public List<UsuarioDTO> getUsuariosFiltrados() {
        if (filtroUsuario != null && busquedaUsuario != null && !busquedaUsuario.trim().isEmpty()) {
            return usuarioFacade.buscarUsuarios(filtroUsuario, busquedaUsuario.trim());
        }
        return usuarioFacade.listarUsuarios();
    }

    // Registrar usuario desde admin
    private String nNombres;
    private String nApellidos;
    private String nCorreo;
    private String nPassword;
    private int nIdRol = 1;

    public String registrarUsuario() {
        UsuarioDTO u = new UsuarioDTO();
        u.setNombres(nNombres);
        u.setApellidos(nApellidos);
        u.setCorreo(nCorreo);
        u.setPasswordHash(nPassword);
        u.setIdRol(nIdRol);
        boolean ok = usuarioFacade.registrarUsuario(u);
        if (ok) {
            auditar("usuario", 0, "CREAR", "{\"correo\":\"" + nCorreo + "\",\"rol\":" + nIdRol + "}");
        }
        nNombres = null; nApellidos = null; nCorreo = null; nPassword = null;
        return "/admin/usuarios.xhtml?faces-redirect=true";
    }

    public String cambiarEstadoUsuario(int id, int activo) {
        if (id != authBean.getUsuario().getIdUsuario()) {
            usuarioFacade.cambiarEstadoUsuario(id, activo);
            auditar("usuario", id, "ACTUALIZAR", "{\"activo\":" + activo + "}");
        }
        return "/admin/usuarios.xhtml?faces-redirect=true";
    }

    public String cambiarRolUsuario(int id, int rol) {
        if (id != authBean.getUsuario().getIdUsuario()) {
            usuarioFacade.cambiarRolUsuario(id, rol);
            auditar("usuario", id, "ACTUALIZAR", "{\"rol_nuevo\":" + rol + "}");
        }
        return "/admin/usuarios.xhtml?faces-redirect=true";
    }

    public String eliminarUsuario(int id) {
        if (id != authBean.getUsuario().getIdUsuario()) {
            usuarioFacade.eliminarUsuario(id);
            auditar("usuario", id, "ELIMINAR", "{}");
        }
        return "/admin/usuarios.xhtml?faces-redirect=true";
    }

    // ============================================================
    // Propiedades (Admin)
    // ============================================================
    private String keyProp;
    private String operacionProp;
    private String tipoProp;

    public List<PropiedadDTO> getPropiedadesAdmin() {
        if ((keyProp != null && !keyProp.trim().isEmpty())
                || (operacionProp != null && !operacionProp.isEmpty())
                || (tipoProp != null && !tipoProp.isEmpty())) {
            return propiedadFacade.buscarPropiedadesAdmin(keyProp, operacionProp, tipoProp, 0, 1000);
        }
        return propiedadFacade.listarPropiedadesAdmin(0, 1000);
    }

    public String cambiarEstadoPropiedad(int id, String estado) {
        propiedadFacade.cambiarEstadoPropiedad(id, estado);
        auditar("propiedad", id, "ACTUALIZAR", "{\"estado\":\"" + estado + "\"}");
        return "/admin/propiedades.xhtml?faces-redirect=true";
    }

    public String eliminarPropiedad(int id) {
        propiedadFacade.eliminarPropiedad(id);
        auditar("propiedad", id, "ELIMINAR", "{}");
        return "/admin/propiedades.xhtml?faces-redirect=true";
    }

    // ============================================================
    // Ubicaciones
    // ============================================================
    private String tipoUbicacion = "DEPARTAMENTO";
    private UbiForm ubiForm = new UbiForm();

    public static class UbiForm {
        private String id;
        private String nombre;
        private String codigoUbigeo;
        private String tipo;
        private int parentId;
        public String getId() { return id; }
        public void setId(String id) { this.id = id; }
        public String getNombre() { return nombre; }
        public void setNombre(String nombre) { this.nombre = nombre; }
        public String getCodigoUbigeo() { return codigoUbigeo; }
        public void setCodigoUbigeo(String codigoUbigeo) { this.codigoUbigeo = codigoUbigeo; }
        public String getTipo() { return tipo; }
        public void setTipo(String tipo) { this.tipo = tipo; }
        public int getParentId() { return parentId; }
        public void setParentId(int parentId) { this.parentId = parentId; }
    }

    public List<UbicacionDTO> getListaUbicaciones() {
        return ubicacionFacade.listarUbicaciones(tipoUbicacion);
    }

    public List<UbicacionDTO> getListaPadres() {
        if ("PROVINCIA".equals(tipoUbicacion)) return ubicacionFacade.listarUbicaciones("DEPARTAMENTO");
        if ("DISTRITO".equals(tipoUbicacion)) return ubicacionFacade.listarUbicaciones("PROVINCIA");
        return null;
    }

    public String guardarUbicacion() {
        UbicacionDTO u = new UbicacionDTO();
        u.setTipo(ubiForm.getTipo());
        u.setNombre(ubiForm.getNombre());
        u.setCodigoUbigeo(ubiForm.getCodigoUbigeo());
        if (ubiForm.getParentId() > 0) u.setParentId(ubiForm.getParentId());

        if (ubiForm.getId() == null || ubiForm.getId().isEmpty()) {
            ubicacionFacade.registrarUbicacion(u);
        } else {
            u.setId(Integer.parseInt(ubiForm.getId()));
            ubicacionFacade.editarUbicacion(u);
        }
        return "/admin/ubicaciones.xhtml?tipo=" + ubiForm.getTipo() + "&faces-redirect=true";
    }

    public String eliminarUbicacion(int id, String tipo) {
        ubicacionFacade.eliminarUbicacion(id, tipo);
        return "/admin/ubicaciones.xhtml?tipo=" + tipo + "&faces-redirect=true";
    }

    // ============================================================
    // Auditoria
    // ============================================================
    public List<EventoAuditoriaDTO> getListaEventos() { return auditoriaFacade.listarEventos(); }

    // ============================================================
    // Util
    // ============================================================
    private void auditar(String entidad, long idEntidad, String accion, String detalle) {
        if (authBean != null && authBean.getUsuario() != null) {
            HttpServletRequest req = (HttpServletRequest) FacesContext.getCurrentInstance().getExternalContext().getRequest();
            auditoriaFacade.registrarEvento(
                    authBean.getUsuario().getIdUsuario(),
                    entidad, idEntidad, accion,
                    req.getRemoteAddr(),
                    req.getHeader("User-Agent"),
                    detalle);
        }
    }

    // Getters y Setters
    public String getFiltroUsuario() { return filtroUsuario; }
    public void setFiltroUsuario(String filtroUsuario) { this.filtroUsuario = filtroUsuario; }
    public String getBusquedaUsuario() { return busquedaUsuario; }
    public void setBusquedaUsuario(String busquedaUsuario) { this.busquedaUsuario = busquedaUsuario; }

    public String getnNombres() { return nNombres; }
    public void setnNombres(String nNombres) { this.nNombres = nNombres; }
    public String getnApellidos() { return nApellidos; }
    public void setnApellidos(String nApellidos) { this.nApellidos = nApellidos; }
    public String getnCorreo() { return nCorreo; }
    public void setnCorreo(String nCorreo) { this.nCorreo = nCorreo; }
    public String getnPassword() { return nPassword; }
    public void setnPassword(String nPassword) { this.nPassword = nPassword; }
    public int getnIdRol() { return nIdRol; }
    public void setnIdRol(int nIdRol) { this.nIdRol = nIdRol; }

    public String getKeyProp() { return keyProp; }
    public void setKeyProp(String keyProp) { this.keyProp = keyProp; }
    public String getOperacionProp() { return operacionProp; }
    public void setOperacionProp(String operacionProp) { this.operacionProp = operacionProp; }
    public String getTipoProp() { return tipoProp; }
    public void setTipoProp(String tipoProp) { this.tipoProp = tipoProp; }

    public String getTipoUbicacion() { return tipoUbicacion; }
    public void setTipoUbicacion(String tipoUbicacion) { this.tipoUbicacion = tipoUbicacion; }
    public UbiForm getUbiForm() { return ubiForm; }
    public void setUbiForm(UbiForm ubiForm) { this.ubiForm = ubiForm; }
}
