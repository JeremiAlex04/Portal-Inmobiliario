package org.example.proyectoweb.dao;

import org.example.proyectoweb.dto.UbicacionDTO;
import org.example.proyectoweb.util.ConexionDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UbicacionDAO {

    public List<UbicacionDTO> listarUbicaciones(String tipo) {
        List<UbicacionDTO> lista = new ArrayList<>();
        String sql = "";

        if ("DEPARTAMENTO".equalsIgnoreCase(tipo)) {
            sql = "SELECT id_departamento as id, nombre, codigo_ubigeo FROM departamento ORDER BY nombre ASC";
        } else if ("PROVINCIA".equalsIgnoreCase(tipo)) {
            sql = "SELECT p.id_provincia as id, p.nombre, p.codigo_ubigeo, p.id_departamento as parentId, d.nombre as parentNombre " +
                  "FROM provincia p INNER JOIN departamento d ON p.id_departamento = d.id_departamento ORDER BY p.nombre ASC";
        } else if ("DISTRITO".equalsIgnoreCase(tipo)) {
            sql = "SELECT d.id_distrito as id, d.nombre, d.codigo_ubigeo, d.id_provincia as parentId, p.nombre as parentNombre " +
                  "FROM distrito d INNER JOIN provincia p ON d.id_provincia = p.id_provincia ORDER BY d.nombre ASC";
        } else {
            return lista;
        }

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                UbicacionDTO u = new UbicacionDTO();
                u.setId(rs.getInt("id"));
                u.setNombre(rs.getString("nombre"));
                u.setCodigoUbigeo(rs.getString("codigo_ubigeo"));
                u.setTipo(tipo.toUpperCase());
                
                if (!"DEPARTAMENTO".equalsIgnoreCase(tipo)) {
                    u.setParentId(rs.getInt("parentId"));
                    u.setParentNombre(rs.getString("parentNombre"));
                }
                lista.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    public boolean registrarUbicacion(UbicacionDTO u) {
        String sql = "";
        if ("DEPARTAMENTO".equalsIgnoreCase(u.getTipo())) {
            sql = "INSERT INTO departamento (nombre, codigo_ubigeo) VALUES (?, ?)";
        } else if ("PROVINCIA".equalsIgnoreCase(u.getTipo())) {
            sql = "INSERT INTO provincia (id_departamento, nombre, codigo_ubigeo) VALUES (?, ?, ?)";
        } else if ("DISTRITO".equalsIgnoreCase(u.getTipo())) {
            sql = "INSERT INTO distrito (id_provincia, nombre, codigo_ubigeo) VALUES (?, ?, ?)";
        }

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            if ("DEPARTAMENTO".equalsIgnoreCase(u.getTipo())) {
                stmt.setString(1, u.getNombre());
                stmt.setString(2, u.getCodigoUbigeo());
            } else {
                stmt.setInt(1, u.getParentId());
                stmt.setString(2, u.getNombre());
                stmt.setString(3, u.getCodigoUbigeo());
            }
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean editarUbicacion(UbicacionDTO u) {
        String sql = "";
        if ("DEPARTAMENTO".equalsIgnoreCase(u.getTipo())) {
            sql = "UPDATE departamento SET nombre = ?, codigo_ubigeo = ? WHERE id_departamento = ?";
        } else if ("PROVINCIA".equalsIgnoreCase(u.getTipo())) {
            sql = "UPDATE provincia SET id_departamento = ?, nombre = ?, codigo_ubigeo = ? WHERE id_provincia = ?";
        } else if ("DISTRITO".equalsIgnoreCase(u.getTipo())) {
            sql = "UPDATE distrito SET id_provincia = ?, nombre = ?, codigo_ubigeo = ? WHERE id_distrito = ?";
        }

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            if ("DEPARTAMENTO".equalsIgnoreCase(u.getTipo())) {
                stmt.setString(1, u.getNombre());
                stmt.setString(2, u.getCodigoUbigeo());
                stmt.setInt(3, u.getId());
            } else {
                stmt.setInt(1, u.getParentId());
                stmt.setString(2, u.getNombre());
                stmt.setString(3, u.getCodigoUbigeo());
                stmt.setInt(4, u.getId());
            }
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean eliminarUbicacion(int id, String tipo) {
        String sql = "";
        if ("DEPARTAMENTO".equalsIgnoreCase(tipo)) {
            sql = "DELETE FROM departamento WHERE id_departamento = ?";
        } else if ("PROVINCIA".equalsIgnoreCase(tipo)) {
            sql = "DELETE FROM provincia WHERE id_provincia = ?";
        } else if ("DISTRITO".equalsIgnoreCase(tipo)) {
            sql = "DELETE FROM distrito WHERE id_distrito = ?";
        }

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
