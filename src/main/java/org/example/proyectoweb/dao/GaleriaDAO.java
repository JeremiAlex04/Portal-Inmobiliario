package org.example.proyectoweb.dao;

import org.example.proyectoweb.dto.PropiedadFotoDTO;
import org.example.proyectoweb.util.ConexionDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class GaleriaDAO {

    public boolean agregarFoto(PropiedadFotoDTO foto) {
        String sql = "INSERT INTO propiedad_fotos (id_propiedad, ruta_archivo, orden, es_principal) VALUES (?, ?, ?, ?)";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, foto.getIdPropiedad());
            stmt.setString(2, foto.getRutaArchivo());
            stmt.setInt(3, foto.getOrden());
            stmt.setBoolean(4, foto.isEsPrincipal());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public List<PropiedadFotoDTO> obtenerFotos(int idPropiedad) {
        List<PropiedadFotoDTO> fotos = new ArrayList<>();
        String sql = "SELECT * FROM propiedad_fotos WHERE id_propiedad = ? ORDER BY es_principal DESC, orden ASC";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idPropiedad);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    PropiedadFotoDTO f = new PropiedadFotoDTO();
                    f.setId(rs.getInt("id_foto"));
                    f.setIdPropiedad(rs.getInt("id_propiedad"));
                    f.setRutaArchivo(rs.getString("ruta_archivo"));
                    f.setOrden(rs.getInt("orden"));
                    f.setEsPrincipal(rs.getBoolean("es_principal"));
                    f.setFechaSubida(rs.getString("fecha_subida"));
                    fotos.add(f);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return fotos;
    }

    public int contarFotos(int idPropiedad) {
        String sql = "SELECT COUNT(*) FROM propiedad_fotos WHERE id_propiedad = ?";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idPropiedad);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public boolean eliminarFoto(int idFoto) {
        String sql = "DELETE FROM propiedad_fotos WHERE id_foto = ?";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idFoto);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public PropiedadFotoDTO obtenerFoto(int idFoto) {
        String sql = "SELECT * FROM propiedad_fotos WHERE id_foto = ?";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idFoto);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    PropiedadFotoDTO f = new PropiedadFotoDTO();
                    f.setId(rs.getInt("id_foto"));
                    f.setIdPropiedad(rs.getInt("id_propiedad"));
                    f.setRutaArchivo(rs.getString("ruta_archivo"));
                    f.setOrden(rs.getInt("orden"));
                    f.setEsPrincipal(rs.getBoolean("es_principal"));
                    return f;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean eliminarFotosPorPropiedad(int idPropiedad) {
        String sql = "DELETE FROM propiedad_fotos WHERE id_propiedad = ?";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idPropiedad);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}
