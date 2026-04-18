package org.example.proyectoweb.dao;

import org.example.proyectoweb.model.Propiedad;
import org.example.proyectoweb.util.ConexionDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PropiedadDAO {

    public List<Propiedad> obtenerPropiedades() {
        List<Propiedad> lista = new ArrayList<>();
        String sql = "SELECT * FROM propiedades ORDER BY id DESC";

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Propiedad p = new Propiedad(
                        rs.getInt("id"),
                        rs.getString("titulo"),
                        rs.getString("descripcion"),
                        rs.getBigDecimal("precio"),
                        rs.getString("ubicacion")
                );
                lista.add(p);
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener propiedades: " + e.getMessage());
        } catch (NullPointerException e) {
             System.err.println("Error de conexión (nula). Verifica que la base de datos esté activa.");
        }
        return lista;
    }

    public boolean registrarPropiedad(Propiedad p) {
        String sql = "INSERT INTO propiedades (titulo, descripcion, precio, ubicacion) VALUES (?, ?, ?, ?)";
        boolean rowInserted = false;

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, p.getTitulo());
            stmt.setString(2, p.getDescripcion());
            stmt.setBigDecimal(3, p.getPrecio());
            stmt.setString(4, p.getUbicacion());

            rowInserted = stmt.executeUpdate() > 0;
        } catch (SQLException e) {
             System.err.println("Error al registrar propiedad: " + e.getMessage());
        } catch (Exception e) {
             e.printStackTrace();
        }
        return rowInserted;
    }
}
