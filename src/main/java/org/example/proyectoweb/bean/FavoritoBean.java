package org.example.proyectoweb.bean;

import jakarta.enterprise.context.RequestScoped;
import jakarta.faces.context.FacesContext;
import jakarta.inject.Inject;
import jakarta.inject.Named;
import org.example.proyectoweb.dto.PropiedadDTO;
import org.example.proyectoweb.dto.UsuarioDTO;
import org.example.proyectoweb.facade.FavoritoFacade;

import java.util.List;
import java.util.Map;
import java.util.Set;

@Named("favoritoBean")
@RequestScoped
public class FavoritoBean {

    @Inject
    private AuthBean authBean;

    private FavoritoFacade favoritoFacade = new FavoritoFacade();
    private Set<Integer> idsFavoritosCache;

    public List<PropiedadDTO> getListaFavoritos() {
        UsuarioDTO usuarioSesion = authBean.getUsuarioSesion();
        if (usuarioSesion == null) return List.of();
        return favoritoFacade.listarFavoritos(usuarioSesion.getIdUsuario());
    }

    public String agregarFavorito(int idPropiedad) {
        UsuarioDTO usuarioSesion = authBean.getUsuarioSesion();
        if (usuarioSesion == null) return "/login.xhtml?faces-redirect=true";
        favoritoFacade.agregarFavorito(usuarioSesion.getIdUsuario(), idPropiedad);
        return buildCurrentViewRedirect();
    }

    public String removerFavorito(int idPropiedad) {
        UsuarioDTO usuarioSesion = authBean.getUsuarioSesion();
        if (usuarioSesion == null) return "/login.xhtml?faces-redirect=true";
        favoritoFacade.removerFavorito(usuarioSesion.getIdUsuario(), idPropiedad);
        return buildCurrentViewRedirect();
    }

    public boolean esFavorito(int idPropiedad) {
        UsuarioDTO usuarioSesion = authBean.getUsuarioSesion();
        if (usuarioSesion == null) return false;
        return favoritoFacade.esFavorito(usuarioSesion.getIdUsuario(), idPropiedad);
    }

    public boolean esFavoritoListado(int idPropiedad) {
        UsuarioDTO usuarioSesion = authBean.getUsuarioSesion();
        if (usuarioSesion == null) return false;
        if (idsFavoritosCache == null) {
            idsFavoritosCache = favoritoFacade.obtenerIdsFavoritos(usuarioSesion.getIdUsuario());
        }
        return idsFavoritosCache.contains(idPropiedad);
    }

    public String toggleFavorito(int idPropiedad) {
        UsuarioDTO usuarioSesion = authBean.getUsuarioSesion();
        if (usuarioSesion == null) return "/login.xhtml?faces-redirect=true";

        if (esFavoritoListado(idPropiedad)) {
            favoritoFacade.removerFavorito(usuarioSesion.getIdUsuario(), idPropiedad);
            if (idsFavoritosCache != null) idsFavoritosCache.remove(idPropiedad);
        } else {
            favoritoFacade.agregarFavorito(usuarioSesion.getIdUsuario(), idPropiedad);
            if (idsFavoritosCache != null) idsFavoritosCache.add(idPropiedad);
        }
        return buildCurrentViewRedirect();
    }

    private String buildCurrentViewRedirect() {
        FacesContext context = FacesContext.getCurrentInstance();
        if (context == null || context.getViewRoot() == null) {
            return "/usuario/favoritos.xhtml?faces-redirect=true";
        }

        String viewId = context.getViewRoot().getViewId();
        Map<String, String> params = context.getExternalContext().getRequestParameterMap();
        if (params != null && !params.isEmpty()) {
            StringBuilder query = new StringBuilder();
            for (Map.Entry<String, String> entry : params.entrySet()) {
                if (entry.getKey() == null || entry.getValue() == null) continue;
                if (query.length() > 0) query.append("&");
                query.append(entry.getKey()).append("=").append(entry.getValue());
            }
            if (query.length() > 0) {
                return viewId + "?" + query + "&faces-redirect=true";
            }
        }
        return viewId + "?faces-redirect=true";
    }
}
