package org.example.proyectoweb.facade;

import org.example.proyectoweb.dao.UsuarioDAO;
import org.example.proyectoweb.dto.UsuarioDTO;

import java.util.List;

public class UsuarioFacade {

    private UsuarioDAO usuarioDAO;

    // ID del administrador principal protegido
    private static final int ADMIN_PRINCIPAL_ID = 2;

    public UsuarioFacade() {
        this.usuarioDAO = new UsuarioDAO();
    }

    // =========================================================
    // VALIDACIONES DE NEGOCIO (Requisito Sprint 1 - Facade)
    // =========================================================

    /**
     * Valida las reglas de negocio para un usuario antes de registrarlo.
     * @return null si es válido, o un mensaje de error si hay violación.
     */
    public String validarUsuario(UsuarioDTO u) {
        // RN-01: Nombres obligatorios
        if (u.getNombres() == null || u.getNombres().trim().isEmpty()) {
            return "El nombre es obligatorio.";
        }

        // RN-02: Apellidos obligatorios
        if (u.getApellidos() == null || u.getApellidos().trim().isEmpty()) {
            return "Los apellidos son obligatorios.";
        }

        // RN-03: Correo obligatorio y con formato válido
        if (u.getCorreo() == null || u.getCorreo().trim().isEmpty()) {
            return "El correo es obligatorio.";
        }
        if (!u.getCorreo().matches("^[\\w._%+-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
            return "El formato del correo electrónico no es válido.";
        }

        // RN-04: Contraseña obligatoria (mínimo 6 caracteres) solo en registro
        if (u.getPasswordHash() != null && !u.getPasswordHash().isEmpty()
                && u.getPasswordHash().length() < 6) {
            return "La contraseña debe tener al menos 6 caracteres.";
        }

        return null; // Todo válido
    }

    // =========================================================
    // OPERACIONES CRUD
    // =========================================================

    public boolean registrarUsuario(UsuarioDTO u) {
        // Aplicar validaciones de negocio
        String error = validarUsuario(u);
        if (error != null) {
            return false;
        }
        return usuarioDAO.registrarUsuario(u);
    }

    public UsuarioDTO autenticar(String correo, String password) {
        return usuarioDAO.autenticar(correo, password);
    }

    public List<UsuarioDTO> listarUsuarios() {
        return usuarioDAO.listarUsuarios();
    }

    public List<UsuarioDTO> buscarUsuarios(String filtro, String valorFiltro) {
        return usuarioDAO.buscarUsuarios(filtro, valorFiltro);
    }

    public UsuarioDTO obtenerUsuarioPorId(int idUsuario) {
        return usuarioDAO.obtenerUsuarioPorId(idUsuario);
    }

    public boolean editarUsuario(UsuarioDTO u) {
        // Validar nombre y correo (sin validar password porque es opcional en edición)
        if (u.getNombres() == null || u.getNombres().trim().isEmpty()) return false;
        if (u.getCorreo() == null || !u.getCorreo().matches("^[\\w._%+-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) return false;
        return usuarioDAO.editarUsuario(u);
    }

    public boolean cambiarEstadoUsuario(int idUsuario, int activo) {
        // RN-05: No permitir desactivar al administrador principal
        if (idUsuario == ADMIN_PRINCIPAL_ID && activo == 0) {
            return false;
        }
        return usuarioDAO.cambiarEstadoUsuario(idUsuario, activo);
    }

    public boolean cambiarRolUsuario(int idUsuario, int idRol) {
        // RN-06: No permitir cambiar el rol del administrador principal
        if (idUsuario == ADMIN_PRINCIPAL_ID) {
            return false;
        }
        return usuarioDAO.cambiarRolUsuario(idUsuario, idRol);
    }

    public boolean eliminarUsuario(int idUsuario) {
        // RN-07: No permitir eliminar al administrador principal
        if (idUsuario == ADMIN_PRINCIPAL_ID) {
            return false;
        }
        return usuarioDAO.eliminarUsuario(idUsuario);
    }

    public int contarUsuariosPorRol(int idRol) {
        return usuarioDAO.contarUsuariosPorRol(idRol);
    }

    public int contarPropiedadesActivas() {
        return usuarioDAO.contarPropiedadesPorEstado("ACTIVO");
    }

    public int contarPropiedadesVendidas() {
        return usuarioDAO.contarPropiedadesPorEstado("VENDIDO");
    }

    public int contarPropiedadesPausadas() {
        return usuarioDAO.contarPropiedadesPorEstado("PAUSADO");
    }

    public int contarPropiedadesBorradores() {
        return usuarioDAO.contarPropiedadesPorEstado("BORRADOR");
    }
}
