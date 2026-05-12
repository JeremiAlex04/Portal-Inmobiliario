package org.example.proyectoweb.facade;

import org.example.proyectoweb.dao.PropiedadDAO;
import org.example.proyectoweb.dto.PropiedadDTO;

import java.util.List;

public class PropiedadFacade {

    private PropiedadDAO propiedadDAO;

    public PropiedadFacade() {
        this.propiedadDAO = new PropiedadDAO();
    }

    public List<PropiedadDTO> buscarPropiedades(String keyword, String operacion, String tipoInmueble) {
        return propiedadDAO.buscarPropiedades(keyword, operacion, tipoInmueble);
    }

    public List<PropiedadDTO> listarPropiedades() {
        return propiedadDAO.obtenerPropiedades();
    }

    public PropiedadDTO obtenerPropiedad(int id) {
        return propiedadDAO.obtenerPropiedadPorId(id);
    }

    public boolean registrarPropiedad(PropiedadDTO propiedad) {
        return propiedadDAO.registrarPropiedad(propiedad);
    }

    public boolean actualizarPropiedad(PropiedadDTO propiedad) {
        return propiedadDAO.actualizarPropiedad(propiedad);
    }

    public boolean eliminarPropiedad(int id) {
        return propiedadDAO.eliminarPropiedad(id);
    }
}
