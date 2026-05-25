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

    public List<Propiedad> obtenerPropiedades(String filtroOperacion, Integer idUsuarioFiltrar) {
        List<Propiedad> lista = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT id_propiedad as id, id_usuario, titulo, descripcion, precio_dolares as precio, direccion as ubicacion, operacion, id_tipo_inmueble FROM propiedades WHERE deleted_at IS NULL ");
        
        List<Object> params = new ArrayList<>();

        if (filtroOperacion != null && !filtroOperacion.isEmpty() && !filtroOperacion.equals("TODOS")) {
            if ("PROYECTO".equals(filtroOperacion)) {
                sql.append("AND id_tipo_inmueble = 8 ");
            } else {
                sql.append("AND operacion = ? ");
                params.add(filtroOperacion);
            }
        }
        
        if (idUsuarioFiltrar != null) {
            sql.append("AND id_usuario = ? ");
            params.add(idUsuarioFiltrar);
        }

        sql.append("ORDER BY id_propiedad DESC");

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Propiedad p = new Propiedad(
                            rs.getInt("id"),
                            rs.getInt("id_usuario"),
                            rs.getString("titulo"),
                            rs.getString("descripcion"),
                            rs.getBigDecimal("precio"),
                            rs.getString("ubicacion"),
                            rs.getString("operacion"),
                            rs.getInt("id_tipo_inmueble")
                    );
                    lista.add(p);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener propiedades: " + e.getMessage());
        } catch (NullPointerException e) {
             System.err.println("Error de conexión (nula). Verifica que la base de datos esté activa.");
        }
        return lista;
    }

    public boolean registrarPropiedad(Propiedad p) {
        // Asumiendo id_distrito = '150101' por defecto para evitar errores de DB
        String sql = "INSERT INTO propiedades (id_usuario, id_tipo_inmueble, id_distrito, operacion, precio_dolares, direccion, titulo, descripcion, estado) VALUES (?, ?, '150101', ?, ?, ?, ?, ?, 'ACTIVO')";
        boolean rowInserted = false;

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, p.getIdUsuario());
            stmt.setInt(2, p.getIdTipoInmueble());
            stmt.setString(3, p.getOperacion());
            stmt.setBigDecimal(4, p.getPrecio());
            stmt.setString(5, p.getUbicacion());
            stmt.setString(6, p.getTitulo());
            stmt.setString(7, p.getDescripcion());

            rowInserted = stmt.executeUpdate() > 0;
        } catch (SQLException e) {
             System.err.println("Error al registrar propiedad: " + e.getMessage());
        } catch (Exception e) {
             e.printStackTrace();
        }
        return rowInserted;
    }
}
