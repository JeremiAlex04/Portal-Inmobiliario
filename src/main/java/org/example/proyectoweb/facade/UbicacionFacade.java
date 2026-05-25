package org.example.proyectoweb.facade;

import org.example.proyectoweb.dao.UbicacionDAO;
import org.example.proyectoweb.dto.UbicacionDTO;

import java.util.List;

public class UbicacionFacade {
    private UbicacionDAO ubicacionDAO;

    public UbicacionFacade() {
        this.ubicacionDAO = new UbicacionDAO();
    }

    public List<UbicacionDTO> listarUbicaciones(String tipo) {
        return ubicacionDAO.listarUbicaciones(tipo);
    }

    public boolean registrarUbicacion(UbicacionDTO u) {
        return ubicacionDAO.registrarUbicacion(u);
    }

    public boolean editarUbicacion(UbicacionDTO u) {
        return ubicacionDAO.editarUbicacion(u);
    }

    public boolean eliminarUbicacion(int id, String tipo) {
        return ubicacionDAO.eliminarUbicacion(id, tipo);
    }
}
