package org.example.proyectoweb.dao;

import org.example.proyectoweb.dto.PropiedadDTO;
import org.example.proyectoweb.util.ConexionDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class FavoritoDAO {

    public boolean agregarFavorito(int idUsuario, int idPropiedad) {
        String sql = "INSERT IGNORE INTO usuario_favorito (id_usuario, id_propiedad) VALUES (?, ?)";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idUsuario);
            stmt.setInt(2, idPropiedad);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean removerFavorito(int idUsuario, int idPropiedad) {
        String sql = "DELETE FROM usuario_favorito WHERE id_usuario = ? AND id_propiedad = ?";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idUsuario);
            stmt.setInt(2, idPropiedad);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean esFavorito(int idUsuario, int idPropiedad) {
        String sql = "SELECT 1 FROM usuario_favorito WHERE id_usuario = ? AND id_propiedad = ?";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idUsuario);
            stmt.setInt(2, idPropiedad);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Retorna el set de IDs de propiedades favoritas de un usuario.
     * Útil para marcar corazones en el listado sin N+1 queries.
     */
    public Set<Integer> obtenerIdsFavoritos(int idUsuario) {
        Set<Integer> ids = new HashSet<>();
        String sql = "SELECT id_propiedad FROM usuario_favorito WHERE id_usuario = ?";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idUsuario);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ids.add(rs.getInt("id_propiedad"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ids;
    }

    /**
     * Lista todas las propiedades favoritas de un usuario con datos completos.
     */
    public List<PropiedadDTO> listarFavoritos(int idUsuario) {
        List<PropiedadDTO> lista = new ArrayList<>();
        String sql = "SELECT v.*, p.descripcion, p.foto_principal, p.numero_vistas " +
                     "FROM usuario_favorito uf " +
                     "INNER JOIN propiedad p ON uf.id_propiedad = p.id_propiedad " +
                     "INNER JOIN v_propiedades_bimonetarias v ON v.id_propiedad = p.id_propiedad " +
                     "WHERE uf.id_usuario = ? " +
                     "ORDER BY uf.fecha_agregado DESC";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idUsuario);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    PropiedadDTO p = new PropiedadDTO();
                    p.setId(rs.getInt("id_propiedad"));
                    p.setTitulo(rs.getString("titulo"));
                    p.setEstado(rs.getString("estado"));
                    p.setMonedaBase(rs.getString("moneda_base"));
                    p.setPrecioPen(rs.getBigDecimal("precio_pen"));
                    p.setPrecioUsd(rs.getBigDecimal("precio_usd"));
                    p.setTipoInmueble(rs.getString("tipo_inmueble"));
                    p.setOperacion(rs.getString("operacion"));
                    p.setDistrito(rs.getString("distrito"));
                    p.setProvincia(rs.getString("provincia"));
                    p.setDepartamento(rs.getString("departamento"));
                    p.setAreaTechadaM2(rs.getBigDecimal("area_techada_m2"));
                    p.setNumDormitorios(rs.getInt("num_dormitorios"));
                    p.setNumBanos(rs.getInt("num_banos"));
                    try { p.setFotoPrincipal(rs.getString("foto_principal")); } catch(Exception ignored) {}
                    p.setFavorito(true);
                    lista.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
}
