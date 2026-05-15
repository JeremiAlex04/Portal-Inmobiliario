package org.example.proyectoweb.facade;

import org.example.proyectoweb.dao.FavoritoDAO;
import org.example.proyectoweb.dto.PropiedadDTO;

import java.util.List;
import java.util.Set;

public class FavoritoFacade {

    private FavoritoDAO favoritoDAO;

    public FavoritoFacade() {
        this.favoritoDAO = new FavoritoDAO();
    }

    public boolean agregarFavorito(int idUsuario, int idPropiedad) {
        return favoritoDAO.agregarFavorito(idUsuario, idPropiedad);
    }

    public boolean removerFavorito(int idUsuario, int idPropiedad) {
        return favoritoDAO.removerFavorito(idUsuario, idPropiedad);
    }

    public boolean esFavorito(int idUsuario, int idPropiedad) {
        return favoritoDAO.esFavorito(idUsuario, idPropiedad);
    }

    public Set<Integer> obtenerIdsFavoritos(int idUsuario) {
        return favoritoDAO.obtenerIdsFavoritos(idUsuario);
    }

    public List<PropiedadDTO> listarFavoritos(int idUsuario) {
        return favoritoDAO.listarFavoritos(idUsuario);
    }
}
