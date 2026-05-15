package org.example.proyectoweb.facade;

import org.example.proyectoweb.dao.UsuarioDAO;
import org.example.proyectoweb.dto.UsuarioDTO;

public class UsuarioFacade {

    private UsuarioDAO usuarioDAO;

    public UsuarioFacade() {
        this.usuarioDAO = new UsuarioDAO();
    }

    public boolean registrarUsuario(UsuarioDTO u) {
        return usuarioDAO.registrarUsuario(u);
    }

    public UsuarioDTO autenticar(String correo, String password) {
        return usuarioDAO.autenticar(correo, password);
    }

    public java.util.List<UsuarioDTO> listarUsuarios() {
        return usuarioDAO.listarUsuarios();
    }

    public boolean cambiarEstadoUsuario(int idUsuario, int activo) {
        return usuarioDAO.cambiarEstadoUsuario(idUsuario, activo);
    }

    public boolean cambiarRolUsuario(int idUsuario, int idRol) {
        return usuarioDAO.cambiarRolUsuario(idUsuario, idRol);
    }

    public boolean eliminarUsuario(int idUsuario) {
        return usuarioDAO.eliminarUsuario(idUsuario);
    }

    public int contarUsuariosPorRol(int idRol) {
        return usuarioDAO.contarUsuariosPorRol(idRol);
    }

    public boolean repararCuentasPrueba(String nuevoHash) {
        return usuarioDAO.repararCuentasPrueba(nuevoHash);
    }
}
