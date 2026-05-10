package org.example.proyectoweb.dao;

import org.example.proyectoweb.model.Usuario;
import org.example.proyectoweb.util.ConexionDB;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class UsuarioDAO {

    public boolean registrarUsuario(Usuario u) {

        String sql = "INSERT INTO usuarios (nombre, email, password) VALUES (?, ?, ?)";

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, u.getNombre());
            stmt.setString(2, u.getEmail());
            stmt.setString(3, u.getPassword());

            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
