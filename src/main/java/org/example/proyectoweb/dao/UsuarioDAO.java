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
}
