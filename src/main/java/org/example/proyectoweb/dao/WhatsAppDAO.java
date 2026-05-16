package org.example.proyectoweb.dao;

import org.example.proyectoweb.util.ConexionDB;

import java.sql.*;

public class WhatsAppDAO {

    public boolean registrarContacto(int idPropiedad, Integer idUsuario) {
        String sql = "INSERT INTO contactos_whatsapp (id_propiedad, id_usuario) VALUES (?, ?)";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idPropiedad);
            if (idUsuario != null) stmt.setInt(2, idUsuario);
            else stmt.setNull(2, Types.BIGINT);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    /**
     * Cuenta contactos WhatsApp recibidos por un agente en los últimos 7 días.
     */
    public int contarContactosSemana(int idAgente) {
        String sql = "SELECT COUNT(*) FROM contactos_whatsapp cw " +
                     "INNER JOIN propiedad p ON cw.id_propiedad = p.id_propiedad " +
                     "WHERE p.id_usuario_agente = ? AND cw.fecha >= DATE_SUB(NOW(), INTERVAL 7 DAY)";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idAgente);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int contarContactosTotales(int idPropiedad) {
        String sql = "SELECT COUNT(*) FROM contactos_whatsapp WHERE id_propiedad = ?";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idPropiedad);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }
}
