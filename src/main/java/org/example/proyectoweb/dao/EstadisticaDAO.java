package org.example.proyectoweb.dao;

import org.example.proyectoweb.dto.EstadisticaDiariaDTO;
import org.example.proyectoweb.util.ConexionDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EstadisticaDAO {

    /**
     * Registra o incrementa la visita diaria de una propiedad.
     * Usa INSERT ON DUPLICATE KEY UPDATE para ser idempotente.
     */
    public void registrarVistaDiaria(int idPropiedad) {
        String sql = "INSERT INTO estadisticas_propiedad (id_propiedad, fecha, num_vistas) " +
                     "VALUES (?, CURDATE(), 1) " +
                     "ON DUPLICATE KEY UPDATE num_vistas = num_vistas + 1";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idPropiedad);
            stmt.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    /**
     * Obtiene vistas diarias de los últimos 30 días para Chart.js.
     */
    public List<EstadisticaDiariaDTO> obtenerVistas30Dias(int idPropiedad) {
        List<EstadisticaDiariaDTO> stats = new ArrayList<>();
        String sql = "SELECT DATE_FORMAT(fecha, '%Y-%m-%d') AS fecha, num_vistas " +
                     "FROM estadisticas_propiedad " +
                     "WHERE id_propiedad = ? AND fecha >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) " +
                     "ORDER BY fecha ASC";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idPropiedad);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    stats.add(new EstadisticaDiariaDTO(rs.getString("fecha"), rs.getInt("num_vistas")));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return stats;
    }

    /**
     * Obtiene el total de vistas de una propiedad.
     */
    public int obtenerTotalVistas(int idPropiedad) {
        String sql = "SELECT COALESCE(SUM(num_vistas), 0) FROM estadisticas_propiedad WHERE id_propiedad = ?";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idPropiedad);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    /**
     * Promedio de vistas diarias en un distrito (para comparación).
     */
    public double obtenerPromedioDistrito(int idDistrito) {
        String sql = "SELECT COALESCE(AVG(ep.num_vistas), 0) FROM estadisticas_propiedad ep " +
                     "INNER JOIN propiedad p ON ep.id_propiedad = p.id_propiedad " +
                     "WHERE p.id_distrito = ? AND ep.fecha >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idDistrito);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getDouble(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }
}
