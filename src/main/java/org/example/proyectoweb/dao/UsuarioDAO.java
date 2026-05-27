package org.example.proyectoweb.dao;

import org.example.proyectoweb.dto.UsuarioDTO;
import org.example.proyectoweb.util.ConexionDB;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UsuarioDAO {

    public boolean registrarUsuario(UsuarioDTO u) {
        // Asignamos por defecto el rol 2 (COMPRADOR) si no viene configurado.
        int rol = (u.getIdRol() > 0) ? u.getIdRol() : 2;

        String sql = "INSERT INTO usuario (id_rol, nombres, apellidos, correo, password_hash) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = ConexionDB.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, rol);
            stmt.setString(2, u.getNombres());
            stmt.setString(3, u.getApellidos());
            stmt.setString(4, u.getCorreo());

            // Generar el hash de la contraseña usando BCrypt
            String hash = BCrypt.hashpw(u.getPasswordHash(), BCrypt.gensalt());
            stmt.setString(5, hash);

            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public UsuarioDTO autenticar(String correo, String passwordEnClaro) {
        String sql = "SELECT id_usuario, id_rol, nombres, apellidos, correo, password_hash FROM usuario WHERE correo = ? AND activo = 1";

        try (Connection conn = ConexionDB.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, correo);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String hashBD = rs.getString("password_hash");
                    // Verificamos si la contraseña coincide con el hash
                    if (BCrypt.checkpw(passwordEnClaro, hashBD)) {
                        UsuarioDTO u = new UsuarioDTO();
                        u.setIdUsuario(rs.getInt("id_usuario"));
                        u.setIdRol(rs.getInt("id_rol"));
                        u.setNombres(rs.getString("nombres"));
                        u.setApellidos(rs.getString("apellidos"));
                        u.setCorreo(rs.getString("correo"));
                        u.setPasswordHash(hashBD);
                        return u;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ==========================================
    // ADMIN: GESTIÓN DE USUARIOS
    // ==========================================

    public java.util.List<UsuarioDTO> listarUsuarios() {
        java.util.List<UsuarioDTO> lista = new java.util.ArrayList<>();
        String sql = "SELECT u.id_usuario, u.id_rol, r.nombre as rol_nombre, u.nombres, u.apellidos, u.correo, u.activo, u.fecha_registro "
                +
                "FROM usuario u INNER JOIN rol r ON u.id_rol = r.id_rol ORDER BY u.id_usuario DESC";
        try (Connection conn = ConexionDB.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                UsuarioDTO u = new UsuarioDTO();
                u.setIdUsuario(rs.getInt("id_usuario"));
                u.setIdRol(rs.getInt("id_rol"));
                u.setRolNombre(rs.getString("rol_nombre"));
                u.setNombres(rs.getString("nombres"));
                u.setApellidos(rs.getString("apellidos"));
                u.setCorreo(rs.getString("correo"));
                u.setActivo(rs.getInt("activo"));
                u.setFechaRegistro(rs.getString("fecha_registro"));
                lista.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    public boolean cambiarEstadoUsuario(int idUsuario, int activo) {
        String sql = "UPDATE usuario SET activo = ? WHERE id_usuario = ?";
        try (Connection conn = ConexionDB.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, activo);
            stmt.setInt(2, idUsuario);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean cambiarRolUsuario(int idUsuario, int idRol) {
        String sql = "UPDATE usuario SET id_rol = ? WHERE id_usuario = ?";
        try (Connection conn = ConexionDB.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idRol);
            stmt.setInt(2, idUsuario);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean eliminarUsuario(int idUsuario) {
        String sql = "DELETE FROM usuario WHERE id_usuario = ?";
        try (Connection conn = ConexionDB.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idUsuario);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int contarUsuariosPorRol(int idRol) {
        // idRol 0 = todos
        String sql = idRol == 0 ? "SELECT COUNT(*) FROM usuario" : "SELECT COUNT(*) FROM usuario WHERE id_rol = ?";
        try (Connection conn = ConexionDB.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            if (idRol > 0)
                stmt.setInt(1, idRol);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public java.util.List<UsuarioDTO> buscarUsuarios(String filtro, String valorFiltro) {
        java.util.List<UsuarioDTO> lista = new java.util.ArrayList<>();
        String sql = "SELECT u.id_usuario, u.id_rol, r.nombre as rol_nombre, u.nombres, u.apellidos, u.correo, u.activo, u.fecha_registro "
                + "FROM usuario u INNER JOIN rol r ON u.id_rol = r.id_rol WHERE 1=1 ";

        if ("nombre".equals(filtro)) {
            sql += "AND (u.nombres LIKE ? OR u.apellidos LIKE ?) ";
        } else if ("correo".equals(filtro)) {
            sql += "AND u.correo LIKE ? ";
        } else if ("rol".equals(filtro)) {
            sql += "AND u.id_rol = ? ";
        }
        sql += "ORDER BY u.id_usuario DESC";

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            if ("nombre".equals(filtro)) {
                String term = "%" + valorFiltro + "%";
                stmt.setString(1, term);
                stmt.setString(2, term);
            } else if ("correo".equals(filtro)) {
                stmt.setString(1, "%" + valorFiltro + "%");
            } else if ("rol".equals(filtro)) {
                try {
                    stmt.setInt(1, Integer.parseInt(valorFiltro));
                } catch (NumberFormatException e) {
                    stmt.setInt(1, -1); // ID inexistente para retornar lista vacía en vez de crash
                }
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    UsuarioDTO u = new UsuarioDTO();
                    u.setIdUsuario(rs.getInt("id_usuario"));
                    u.setIdRol(rs.getInt("id_rol"));
                    u.setRolNombre(rs.getString("rol_nombre"));
                    u.setNombres(rs.getString("nombres"));
                    u.setApellidos(rs.getString("apellidos"));
                    u.setCorreo(rs.getString("correo"));
                    u.setActivo(rs.getInt("activo"));
                    u.setFechaRegistro(rs.getString("fecha_registro"));
                    lista.add(u);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    public UsuarioDTO obtenerUsuarioPorId(int idUsuario) {
        String sql = "SELECT u.id_usuario, u.id_rol, r.nombre as rol_nombre, u.nombres, u.apellidos, u.correo, u.activo, u.fecha_registro "
                + "FROM usuario u INNER JOIN rol r ON u.id_rol = r.id_rol WHERE u.id_usuario = ?";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idUsuario);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    UsuarioDTO u = new UsuarioDTO();
                    u.setIdUsuario(rs.getInt("id_usuario"));
                    u.setIdRol(rs.getInt("id_rol"));
                    u.setRolNombre(rs.getString("rol_nombre"));
                    u.setNombres(rs.getString("nombres"));
                    u.setApellidos(rs.getString("apellidos"));
                    u.setCorreo(rs.getString("correo"));
                    u.setActivo(rs.getInt("activo"));
                    u.setFechaRegistro(rs.getString("fecha_registro"));
                    return u;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean editarUsuario(UsuarioDTO u) {
        String sql = "UPDATE usuario SET nombres = ?, apellidos = ?, correo = ? WHERE id_usuario = ?";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, u.getNombres());
            stmt.setString(2, u.getApellidos());
            stmt.setString(3, u.getCorreo());
            stmt.setInt(4, u.getIdUsuario());
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int contarPropiedadesPorEstado(String estado) {
        String sql = "SELECT COUNT(*) FROM propiedad WHERE estado = ?";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, estado);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
