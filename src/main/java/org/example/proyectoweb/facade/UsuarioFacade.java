package org.example.proyectoweb.facade;

import org.example.proyectoweb.dao.UsuarioDAO;
import org.example.proyectoweb.dto.UsuarioDTO;

import java.util.List;
import java.util.Locale;

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
        if (u == null) {
            return "Solicitud inválida.";
        }

        u.setNombres(limpiarTexto(u.getNombres()));
        u.setApellidos(limpiarTexto(u.getApellidos()));
        u.setCorreo(normalizarCorreo(u.getCorreo()));

        // RN-01: Nombres obligatorios
        if (u.getNombres() == null || u.getNombres().isEmpty()) {
            return "El nombre es obligatorio.";
        }

        // RN-02: Apellidos obligatorios
        if (u.getApellidos() == null || u.getApellidos().isEmpty()) {
            return "Los apellidos son obligatorios.";
        }

        // RN-03: Correo obligatorio y con formato válido
        if (u.getCorreo() == null || u.getCorreo().isEmpty()) {
            return "El correo es obligatorio.";
        }
        if (!u.getCorreo().matches("^[\\w._%+-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
            return "El formato del correo electrónico no es válido.";
        }

        // RN-04: Contraseña obligatoria (mínimo 6 caracteres)
        if (u.getPasswordHash() == null || u.getPasswordHash().trim().isEmpty()) {
            return "La contraseña es obligatoria.";
        }
        if (u.getPasswordHash().trim().length() < 6) {
            return "La contraseña debe tener al menos 6 caracteres.";
        }

        // RN-05: Solo permitir auto-registro para Comprador/Agente
        if (u.getIdRol() != 2 && u.getIdRol() != 3) {
            u.setIdRol(2);
        }

        return null; // Todo válido
    }

    public String validarCredencialesLogin(String correo, String password) {
        String correoNormalizado = normalizarCorreo(correo);
        if (correoNormalizado.isEmpty()) {
            return "El correo es obligatorio.";
        }
        if (!correoNormalizado.matches("^[\\w._%+-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
            return "El formato del correo electrónico no es válido.";
        }
        if (password == null || password.trim().isEmpty()) {
            return "La contraseña es obligatoria.";
        }
        return null;
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
        if (usuarioDAO.existeCorreo(u.getCorreo())) {
            return false;
        }
        return usuarioDAO.registrarUsuario(u);
    }

    public UsuarioDTO autenticar(String correo, String password) {
        String correoNormalizado = normalizarCorreo(correo);
        String passwordNormalizado = password == null ? null : password.trim();
        if (correoNormalizado.isEmpty() || passwordNormalizado == null || passwordNormalizado.isEmpty()) {
            return null;
        }
        return usuarioDAO.autenticar(correoNormalizado, passwordNormalizado);
    }

    public boolean existeCorreo(String correo) {
        return usuarioDAO.existeCorreo(normalizarCorreo(correo));
    }

    private String limpiarTexto(String valor) {
        if (valor == null) {
            return null;
        }
        String limpio = valor.trim().replaceAll("\\s+", " ");
        return limpio.isEmpty() ? null : limpio;
    }

    private String normalizarCorreo(String correo) {
        return correo == null ? "" : correo.trim().toLowerCase(Locale.ROOT);
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
