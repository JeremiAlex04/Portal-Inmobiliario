package org.example.proyectoweb.facade;

import org.example.proyectoweb.dao.AuditoriaDAO;
import org.example.proyectoweb.dto.EventoAuditoriaDTO;

import java.util.List;

public class AuditoriaFacade {

    private AuditoriaDAO auditoriaDAO;

    public AuditoriaFacade() {
        this.auditoriaDAO = new AuditoriaDAO();
    }

    public boolean registrarEvento(Integer idUsuario, String entidad, long idEntidad, String accion, String ipOrigen, String userAgent, String detalleJson) {
        return auditoriaDAO.registrarEvento(idUsuario, entidad, idEntidad, accion, ipOrigen, userAgent, detalleJson);
    }

    public List<EventoAuditoriaDTO> listarEventos() {
        return auditoriaDAO.listarEventos();
    }
}
