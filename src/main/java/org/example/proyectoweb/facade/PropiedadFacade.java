package org.example.proyectoweb.facade;

import org.example.proyectoweb.dao.PropiedadDAO;
import org.example.proyectoweb.dto.PropiedadDTO;

import java.util.List;

public class PropiedadFacade {

    private PropiedadDAO propiedadDAO;

    public PropiedadFacade() {
        this.propiedadDAO = new PropiedadDAO();
    }

    public List<PropiedadDTO> buscarPropiedades(String keyword, String operacion, String tipoInmueble, int offset, int limit) {
        return propiedadDAO.buscarPropiedades(keyword, operacion, tipoInmueble, offset, limit);
    }

    public int contarPropiedades(String keyword, String operacion, String tipoInmueble) {
        return propiedadDAO.contarPropiedades(keyword, operacion, tipoInmueble);
    }

    public List<org.example.proyectoweb.dto.CatalogoDTO> obtenerDistritos() {
        return propiedadDAO.obtenerDistritos();
    }

    public List<org.example.proyectoweb.dto.CatalogoDTO> obtenerTiposInmueble() {
        return propiedadDAO.obtenerTiposInmueble();
    }

    public List<org.example.proyectoweb.dto.CatalogoDTO> obtenerOperaciones() {
        return propiedadDAO.obtenerOperaciones();
    }

    public List<PropiedadDTO> listarPropiedades(int offset, int limit) {
        return propiedadDAO.obtenerPropiedades(offset, limit);
    }

    public List<PropiedadDTO> obtenerPropiedadesPorAgente(int idAgente) {
        return propiedadDAO.obtenerPropiedadesPorAgente(idAgente);
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

    public boolean cambiarEstadoPropiedad(int idPropiedad, String nuevoEstado) {
        return propiedadDAO.cambiarEstadoPropiedad(idPropiedad, nuevoEstado);
    }
}
