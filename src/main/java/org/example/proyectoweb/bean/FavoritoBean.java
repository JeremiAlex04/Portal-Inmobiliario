package org.example.proyectoweb.bean;

import jakarta.enterprise.context.RequestScoped;
import jakarta.inject.Inject;
import jakarta.inject.Named;
import org.example.proyectoweb.dto.PropiedadDTO;
import org.example.proyectoweb.facade.FavoritoFacade;

import java.util.List;

@Named("favoritoBean")
@RequestScoped
public class FavoritoBean {

    @Inject
    private AuthBean authBean;

    private FavoritoFacade favoritoFacade = new FavoritoFacade();

    public List<PropiedadDTO> getListaFavoritos() {
        if (!authBean.isLogueado()) return List.of();
        return favoritoFacade.listarFavoritos(authBean.getUsuario().getIdUsuario());
    }

    public String agregarFavorito(int idPropiedad) {
        if (!authBean.isLogueado()) return "/login.xhtml?faces-redirect=true";
        favoritoFacade.agregarFavorito(authBean.getUsuario().getIdUsuario(), idPropiedad);
        return null;
    }

    public String removerFavorito(int idPropiedad) {
        if (!authBean.isLogueado()) return "/login.xhtml?faces-redirect=true";
        favoritoFacade.removerFavorito(authBean.getUsuario().getIdUsuario(), idPropiedad);
        return null;
    }

    public boolean esFavorito(int idPropiedad) {
        if (!authBean.isLogueado()) return false;
        return favoritoFacade.esFavorito(authBean.getUsuario().getIdUsuario(), idPropiedad);
    }
}
