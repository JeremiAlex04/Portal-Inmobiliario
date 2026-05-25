package org.example.proyectoweb.dao;

import org.example.proyectoweb.dto.ConsultaDTO;
import org.example.proyectoweb.util.ConexionDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ConsultaDAO {

    public boolean registrarConsulta(ConsultaDTO c) {
        String sql = "INSERT INTO consultas (id_propiedad, id_usuario, nombre, email, telefono, mensaje) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, c.getIdPropiedad());
            if (c.getIdUsuario() != null) stmt.setInt(2, c.getIdUsuario());
            else stmt.setNull(2, Types.BIGINT);
            stmt.setString(3, c.getNombre());
            stmt.setString(4, c.getEmail());
            stmt.setString(5, c.getTelefono());
            stmt.setString(6, c.getMensaje());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    /**
     * Lista consultas para las propiedades de un agente específico.
     */
    public List<ConsultaDTO> listarConsultasPorAgente(int idAgente, String filtroEstado) {
        List<ConsultaDTO> lista = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT c.*, p.titulo AS titulo_propiedad FROM consultas c " +
            "INNER JOIN propiedad p ON c.id_propiedad = p.id_propiedad " +
            "WHERE p.id_usuario_agente = ?");
        if (filtroEstado != null && !filtroEstado.isEmpty()) {
            sql.append(" AND c.estado = ?");
        }
        sql.append(" ORDER BY c.fecha DESC");

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            stmt.setInt(1, idAgente);
            if (filtroEstado != null && !filtroEstado.isEmpty()) {
                stmt.setString(2, filtroEstado);
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ConsultaDTO dto = new ConsultaDTO();
                    dto.setId(rs.getInt("id_consulta"));
                    dto.setIdPropiedad(rs.getInt("id_propiedad"));
                    dto.setNombre(rs.getString("nombre"));
                    dto.setEmail(rs.getString("email"));
                    dto.setTelefono(rs.getString("telefono"));
                    dto.setMensaje(rs.getString("mensaje"));
                    dto.setEstado(rs.getString("estado"));
                    dto.setFecha(rs.getString("fecha"));
                    dto.setTituloPropiedad(rs.getString("titulo_propiedad"));
                    lista.add(dto);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    public boolean cambiarEstadoConsulta(int idConsulta, String nuevoEstado) {
        String sql = "UPDATE consultas SET estado = ? WHERE id_consulta = ?";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, nuevoEstado);
            stmt.setInt(2, idConsulta);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public int contarConsultasPendientes(int idAgente) {
        String sql = "SELECT COUNT(*) FROM consultas c INNER JOIN propiedad p ON c.id_propiedad = p.id_propiedad WHERE p.id_usuario_agente = ? AND c.estado = 'PENDIENTE'";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idAgente);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }
}
