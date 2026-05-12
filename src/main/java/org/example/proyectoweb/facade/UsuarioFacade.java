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
}
