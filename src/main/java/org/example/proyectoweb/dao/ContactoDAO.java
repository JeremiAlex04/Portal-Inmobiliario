package org.example.proyectoweb.dao;

import org.example.proyectoweb.model.Contacto;
import org.example.proyectoweb.util.ConexionDB;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class ContactoDAO {

    public boolean guardarMensaje(Contacto c) {

        String sql = "INSERT INTO contacto(nombre, email, mensaje) VALUES (?, ?, ?)";

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, c.getNombre());
            ps.setString(2, c.getEmail());
            ps.setString(3, c.getMensaje());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
