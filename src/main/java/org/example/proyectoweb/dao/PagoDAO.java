package org.example.proyectoweb.dao;

import org.example.proyectoweb.dto.PagoDTO;
import org.example.proyectoweb.dto.PlanDTO;
import org.example.proyectoweb.util.ConexionDB;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class PagoDAO {

    // =========================================================
    // Planes
    // =========================================================
    public List<PlanDTO> listarPlanes() {
        List<PlanDTO> planes = new ArrayList<>();
        String sql = "SELECT * FROM plan WHERE activo = 1 ORDER BY precio_pen ASC";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                PlanDTO p = new PlanDTO();
                p.setId(rs.getInt("id_plan"));
                p.setNombre(rs.getString("nombre"));
                p.setPrecioPen(rs.getBigDecimal("precio_pen"));
                p.setDuracionDias(rs.getInt("duracion_dias"));
                p.setMaxPropiedades(rs.getInt("max_propiedades"));
                p.setMaxFotos(rs.getInt("max_fotos"));
                p.setDestacada(rs.getBoolean("destacada"));
                p.setAnalytics(rs.getBoolean("analytics"));
                p.setDescripcion(rs.getString("descripcion"));
                planes.add(p);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return planes;
    }

    public PlanDTO obtenerPlan(int idPlan) {
        String sql = "SELECT * FROM plan WHERE id_plan = ?";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idPlan);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    PlanDTO p = new PlanDTO();
                    p.setId(rs.getInt("id_plan"));
                    p.setNombre(rs.getString("nombre"));
                    p.setPrecioPen(rs.getBigDecimal("precio_pen"));
                    p.setDuracionDias(rs.getInt("duracion_dias"));
                    p.setMaxPropiedades(rs.getInt("max_propiedades"));
                    p.setMaxFotos(rs.getInt("max_fotos"));
                    p.setDestacada(rs.getBoolean("destacada"));
                    p.setAnalytics(rs.getBoolean("analytics"));
                    p.setDescripcion(rs.getString("descripcion"));
                    return p;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // =========================================================
    // Pagos
    // =========================================================

    /**
     * Registra un pago real en BD con código de operación generado.
     * 1. Crea suscripción
     * 2. Crea pago vinculado a la suscripción
     */
    public boolean registrarPago(int idUsuario, int idPlan, String metodoPago) {
        String sqlSuscripcion = "INSERT INTO suscripcion (id_usuario, id_plan, fecha_fin) " +
                "VALUES (?, ?, DATE_ADD(NOW(), INTERVAL (SELECT duracion_dias FROM plan WHERE id_plan = ?) DAY))";
        String sqlPago = "INSERT INTO pago (id_suscripcion, monto, moneda, metodo, pasarela, referencia_externa, estado) " +
                "VALUES (?, (SELECT precio_pen FROM plan WHERE id_plan = ?), 'PEN', ?, 'OTRO', ?, 'PENDIENTE')";

        Connection conn = null;
        try {
            conn = ConexionDB.getConnection();
            conn.setAutoCommit(false);

            // 1. Crear suscripción
            int idSuscripcion;
            try (PreparedStatement stmt = conn.prepareStatement(sqlSuscripcion, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setInt(1, idUsuario);
                stmt.setInt(2, idPlan);
                stmt.setInt(3, idPlan);
                stmt.executeUpdate();
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    rs.next();
                    idSuscripcion = rs.getInt(1);
                }
            }

            // 2. Crear pago con código operación
            String codigoOperacion = "OP-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
            try (PreparedStatement stmt = conn.prepareStatement(sqlPago)) {
                stmt.setInt(1, idSuscripcion);
                stmt.setInt(2, idPlan);
                stmt.setString(3, mapearMetodoPago(metodoPago));
                stmt.setString(4, codigoOperacion);
                stmt.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) { ex.printStackTrace(); }
        }
        return false;
    }

    private String mapearMetodoPago(String metodo) {
        if (metodo == null) return "TRANSFERENCIA";
        return switch (metodo.toUpperCase()) {
            case "TARJETA" -> "TARJETA";
            case "TRANSFERENCIA" -> "TRANSFERENCIA";
            case "EFECTIVO" -> "PAGO_EFECTIVO";
            case "YAPE" -> "YAPE";
            default -> "TRANSFERENCIA";
        };
    }

    /**
     * Lista todos los pagos para el panel admin.
     */
    public List<PagoDTO> listarPagos(String filtroEstado) {
        List<PagoDTO> pagos = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT pg.id_pago, pg.monto, pg.metodo, pg.estado, pg.referencia_externa, pg.fecha_pago, " +
            "p.nombre AS nombre_plan, CONCAT(u.nombres, ' ', u.apellidos) AS nombre_usuario, s.id_usuario " +
            "FROM pago pg " +
            "INNER JOIN suscripcion s ON pg.id_suscripcion = s.id_suscripcion " +
            "INNER JOIN plan p ON s.id_plan = p.id_plan " +
            "INNER JOIN usuario u ON s.id_usuario = u.id_usuario");
        if (filtroEstado != null && !filtroEstado.isEmpty()) {
            sql.append(" WHERE pg.estado = ?");
        }
        sql.append(" ORDER BY pg.fecha_pago DESC");

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            if (filtroEstado != null && !filtroEstado.isEmpty()) {
                stmt.setString(1, filtroEstado);
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    PagoDTO dto = new PagoDTO();
                    dto.setId(rs.getInt("id_pago"));
                    dto.setMonto(rs.getBigDecimal("monto"));
                    dto.setMetodoPago(rs.getString("metodo"));
                    dto.setEstado(rs.getString("estado"));
                    dto.setCodigoOperacion(rs.getString("referencia_externa"));
                    dto.setFecha(rs.getString("fecha_pago"));
                    dto.setNombrePlan(rs.getString("nombre_plan"));
                    dto.setNombreUsuario(rs.getString("nombre_usuario"));
                    dto.setIdUsuario(rs.getInt("id_usuario"));
                    pagos.add(dto);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return pagos;
    }

    /**
     * Admin aprueba o rechaza un pago.
     */
    public boolean cambiarEstadoPago(int idPago, String nuevoEstado) {
        String sql = "UPDATE pago SET estado = ? WHERE id_pago = ?";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, nuevoEstado);
            stmt.setInt(2, idPago);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    /**
     * Obtiene los pagos de un usuario específico.
     */
    public List<PagoDTO> listarPagosPorUsuario(int idUsuario) {
        List<PagoDTO> pagos = new ArrayList<>();
        String sql = "SELECT pg.id_pago, pg.monto, pg.metodo, pg.estado, pg.referencia_externa, pg.fecha_pago, " +
                "p.nombre AS nombre_plan FROM pago pg " +
                "INNER JOIN suscripcion s ON pg.id_suscripcion = s.id_suscripcion " +
                "INNER JOIN plan p ON s.id_plan = p.id_plan " +
                "WHERE s.id_usuario = ? ORDER BY pg.fecha_pago DESC";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idUsuario);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    PagoDTO dto = new PagoDTO();
                    dto.setId(rs.getInt("id_pago"));
                    dto.setMonto(rs.getBigDecimal("monto"));
                    dto.setMetodoPago(rs.getString("metodo"));
                    dto.setEstado(rs.getString("estado"));
                    dto.setCodigoOperacion(rs.getString("referencia_externa"));
                    dto.setFecha(rs.getString("fecha_pago"));
                    dto.setNombrePlan(rs.getString("nombre_plan"));
                    pagos.add(dto);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return pagos;
    }
}
