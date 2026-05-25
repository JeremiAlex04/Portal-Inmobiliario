package org.example.proyectoweb.dao;

import org.example.proyectoweb.dto.EventoAuditoriaDTO;
import org.example.proyectoweb.util.ConexionDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AuditoriaDAO {

    public boolean registrarEvento(Integer idUsuario, String entidad, long idEntidad, String accion, String ipOrigen, String userAgent, String detalleJson) {
        String sql = "INSERT INTO evento_auditoria (id_usuario, entidad, id_entidad, accion, ip_origen, user_agent, detalle_json) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            if (idUsuario != null && idUsuario > 0) {
                stmt.setInt(1, idUsuario);
            } else {
                stmt.setNull(1, java.sql.Types.INTEGER);
            }
            stmt.setString(2, entidad);
            stmt.setLong(3, idEntidad);
            stmt.setString(4, accion);
            stmt.setString(5, ipOrigen);
            stmt.setString(6, userAgent);
            stmt.setString(7, detalleJson);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al registrar evento de auditoria: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public List<EventoAuditoriaDTO> listarEventos() {
        List<EventoAuditoriaDTO> lista = new ArrayList<>();
        String sql = "SELECT e.*, CONCAT(u.nombres, ' ', u.apellidos) AS usuario_nombre " +
                     "FROM evento_auditoria e " +
                     "LEFT JOIN usuario u ON e.id_usuario = u.id_usuario " +
                     "ORDER BY e.fecha_evento DESC LIMIT 500";

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                EventoAuditoriaDTO e = new EventoAuditoriaDTO();
                e.setIdEvento(rs.getLong("id_evento"));
                int idUsr = rs.getInt("id_usuario");
                if (!rs.wasNull()) {
                    e.setIdUsuario(idUsr);
                }
                e.setUsuarioNombre(rs.getString("usuario_nombre"));
                if (e.getUsuarioNombre() == null || e.getUsuarioNombre().trim().isEmpty()) {
                    e.setUsuarioNombre("Sistema/Anónimo");
                }
                e.setEntidad(rs.getString("entidad"));
                e.setIdEntidad(rs.getLong("id_entidad"));
                e.setAccion(rs.getString("accion"));
                e.setIpOrigen(rs.getString("ip_origen"));
                e.setUserAgent(rs.getString("user_agent"));
                e.setDetalleJson(rs.getString("detalle_json"));
                e.setFechaEvento(rs.getString("fecha_evento"));
                lista.add(e);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar eventos de auditoria: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }
}
