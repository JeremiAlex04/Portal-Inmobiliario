package org.example.proyectoweb.dao;

import org.example.proyectoweb.model.Usuario;
import org.example.proyectoweb.util.ConexionDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UsuarioDAO {

    public boolean registrarUsuario(Usuario u) {
        String sql = "INSERT INTO usuarios (nombres, apellidos, email, password_hash) VALUES (?, ?, ?, ?)";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, u.getNombres());
            stmt.setString(2, u.getApellidos());
            stmt.setString(3, u.getEmail());
            stmt.setString(4, u.getPassword()); // In a real app, hash this!

            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Usuario loginUsuario(String email, String password) {
        String sql = "SELECT id_usuario, nombres, apellidos, email FROM usuarios WHERE email = ? AND password_hash = ?";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Usuario u = new Usuario();
                u.setId(rs.getInt("id_usuario"));
                u.setNombres(rs.getString("nombres"));
                u.setApellidos(rs.getString("apellidos"));
                u.setEmail(rs.getString("email"));
                return u;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
