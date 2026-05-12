package org.example.proyectoweb.dao;

import org.example.proyectoweb.dto.PropiedadDTO;
import org.example.proyectoweb.util.ConexionDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PropiedadDAO {

    public List<PropiedadDTO> buscarPropiedades(String keyword, String operacion, String tipoInmueble) {
        List<PropiedadDTO> lista = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder(
            "SELECT v.*, p.descripcion " +
            "FROM v_propiedades_bimonetarias v " +
            "INNER JOIN propiedad p ON v.id_propiedad = p.id_propiedad " +
            "WHERE 1=1 "
        );

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (v.titulo LIKE ? OR v.distrito LIKE ? OR p.descripcion LIKE ?) ");
        }
        if (operacion != null && !operacion.trim().isEmpty()) {
            sql.append(" AND v.operacion = ? ");
        }
        if (tipoInmueble != null && !tipoInmueble.trim().isEmpty()) {
            sql.append(" AND v.tipo_inmueble = ? ");
        }

        sql.append(" ORDER BY v.id_propiedad DESC");

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String term = "%" + keyword.trim() + "%";
                stmt.setString(paramIndex++, term);
                stmt.setString(paramIndex++, term);
                stmt.setString(paramIndex++, term);
            }
            if (operacion != null && !operacion.trim().isEmpty()) {
                stmt.setString(paramIndex++, operacion.trim());
            }
            if (tipoInmueble != null && !tipoInmueble.trim().isEmpty()) {
                stmt.setString(paramIndex++, tipoInmueble.trim());
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    PropiedadDTO p = new PropiedadDTO();
                    p.setId(rs.getInt("id_propiedad"));
                    p.setTitulo(rs.getString("titulo"));
                    p.setDescripcion(rs.getString("descripcion"));
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
                    p.setBonoMiVivienda(rs.getInt("bono_mi_vivienda"));
                    p.setBonoVerde(rs.getInt("bono_verde"));
                    
                    // Backwards compatibility para listar (si es necesario)
                    p.setUbicacion(rs.getString("distrito") + ", " + rs.getString("provincia"));
                    p.setPrecio(rs.getBigDecimal("precio_usd")); 
                    
                    lista.add(p);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al buscar propiedades: " + e.getMessage());
        } catch (NullPointerException e) {
            System.err.println("Error de conexión. Verifica la base de datos.");
        }
        return lista;
    }

    public List<PropiedadDTO> obtenerPropiedades() {
        return buscarPropiedades(null, null, null);
    }

    public boolean registrarPropiedad(PropiedadDTO p) {
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

    public PropiedadDTO obtenerPropiedadPorId(int id) {
        PropiedadDTO p = null;
        String sql = "SELECT * FROM propiedades WHERE id = ?";

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    p = new PropiedadDTO(
                            rs.getInt("id"),
                            rs.getString("titulo"),
                            rs.getString("descripcion"),
                            rs.getBigDecimal("precio"),
                            rs.getString("ubicacion")
                    );
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener propiedad por id: " + e.getMessage());
        }
        return p;
    }

    public boolean actualizarPropiedad(PropiedadDTO p) {
        String sql = "UPDATE propiedades SET titulo = ?, descripcion = ?, precio = ?, ubicacion = ? WHERE id = ?";
        boolean rowUpdated = false;

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, p.getTitulo());
            stmt.setString(2, p.getDescripcion());
            stmt.setBigDecimal(3, p.getPrecio());
            stmt.setString(4, p.getUbicacion());
            stmt.setInt(5, p.getId());

            rowUpdated = stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al actualizar propiedad: " + e.getMessage());
        }
        return rowUpdated;
    }

    public boolean eliminarPropiedad(int id) {
        String sql = "DELETE FROM propiedades WHERE id = ?";
        boolean rowDeleted = false;

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            rowDeleted = stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al eliminar propiedad: " + e.getMessage());
        }
        return rowDeleted;
    }
}
