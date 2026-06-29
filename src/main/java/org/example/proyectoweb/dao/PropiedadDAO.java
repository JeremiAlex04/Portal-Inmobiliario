package org.example.proyectoweb.dao;

import org.example.proyectoweb.dto.PropiedadDTO;
import org.example.proyectoweb.util.ConexionDB;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PropiedadDAO {

    public List<PropiedadDTO> buscarPropiedades(String keyword, String operacion, String tipoInmueble, int offset,
            int limit) {
        keyword = cleanKeyword(keyword);
        List<PropiedadDTO> lista = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT v.*, p.descripcion, p.foto_principal, p.numero_vistas, p.destacada, p.area_total_m2, p.fecha_publicacion " +
                        "FROM v_propiedades_bimonetarias v " +
                        "INNER JOIN propiedad p ON v.id_propiedad = p.id_propiedad " +
                        "WHERE 1=1 ");

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (v.titulo LIKE ? OR v.distrito LIKE ? OR p.descripcion LIKE ?) ");
        }
        if (operacion != null && !operacion.trim().isEmpty()) {
            sql.append(" AND v.operacion = ? ");
        }
        if (tipoInmueble != null && !tipoInmueble.trim().isEmpty()) {
            sql.append(" AND v.tipo_inmueble = ? ");
        }

        sql.append(" ORDER BY v.id_propiedad DESC LIMIT ? OFFSET ?");

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
            stmt.setInt(paramIndex++, limit);
            stmt.setInt(paramIndex++, offset);

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

                    // Sprint 2: foto + vistas + tipo cambio
                    try { p.setFotoPrincipal(rs.getString("foto_principal")); } catch(Exception ignored) {}
                    try { p.setNumeroVistas(rs.getInt("numero_vistas")); } catch(Exception ignored) {}
                    try { p.setTipoCambioVenta(rs.getBigDecimal("tipo_cambio_venta")); } catch(Exception ignored) {}
                    try { p.setDestacada(rs.getBoolean("destacada")); } catch(Exception ignored) {}
                    try { p.setAreaTotalM2(rs.getBigDecimal("area_total_m2")); } catch(Exception ignored) {}
                    try { p.setFechaPublicacion(rs.getString("fecha_publicacion")); } catch(Exception ignored) {}

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

    public List<org.example.proyectoweb.dto.CatalogoDTO> obtenerDistritos() {
        List<org.example.proyectoweb.dto.CatalogoDTO> lista = new ArrayList<>();
        String sql = "SELECT d.id_distrito, CONCAT(d.nombre, ' (', p.nombre, ')') AS nombre FROM distrito d INNER JOIN provincia p ON d.id_provincia = p.id_provincia ORDER BY d.nombre";
        try (Connection conn = ConexionDB.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                lista.add(new org.example.proyectoweb.dto.CatalogoDTO(rs.getInt(1), rs.getString(2)));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public List<org.example.proyectoweb.dto.CatalogoDTO> obtenerTiposInmueble() {
        List<org.example.proyectoweb.dto.CatalogoDTO> lista = new ArrayList<>();
        String sql = "SELECT id_tipo, nombre FROM tipo_inmueble ORDER BY nombre";
        try (Connection conn = ConexionDB.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                lista.add(new org.example.proyectoweb.dto.CatalogoDTO(rs.getInt(1), rs.getString(2)));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public List<org.example.proyectoweb.dto.CatalogoDTO> obtenerOperaciones() {
        List<org.example.proyectoweb.dto.CatalogoDTO> lista = new ArrayList<>();
        String sql = "SELECT id_operacion, nombre FROM operacion ORDER BY nombre";
        try (Connection conn = ConexionDB.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                lista.add(new org.example.proyectoweb.dto.CatalogoDTO(rs.getInt(1), rs.getString(2)));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public List<PropiedadDTO> obtenerPropiedades(int offset, int limit) {
        return buscarPropiedades(null, null, null, offset, limit);
    }

    public int contarPropiedades(String keyword, String operacion, String tipoInmueble) {
        keyword = cleanKeyword(keyword);
        int total = 0;
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(v.id_propiedad) " +
                        "FROM v_propiedades_bimonetarias v " +
                        "INNER JOIN propiedad p ON v.id_propiedad = p.id_propiedad " +
                        "WHERE 1=1 ");

        // Sprint 2: filtros extendidos (se parsean de keyword con formato especial)
        // Los filtros avanzados se pasan como parámetros separados via overload

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (v.titulo LIKE ? OR v.distrito LIKE ? OR p.descripcion LIKE ?) ");
        }
        if (operacion != null && !operacion.trim().isEmpty()) {
            sql.append(" AND v.operacion = ? ");
        }
        if (tipoInmueble != null && !tipoInmueble.trim().isEmpty()) {
            sql.append(" AND v.tipo_inmueble = ? ");
        }

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
                if (rs.next()) {
                    total = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;

    }

    public List<PropiedadDTO> obtenerPropiedadesPorAgente(int idAgente) {
        List<PropiedadDTO> lista = new ArrayList<>();
        String sql = "SELECT v.*, p.descripcion, p.foto_principal, p.numero_vistas FROM v_propiedades_bimonetarias v INNER JOIN propiedad p ON v.id_propiedad = p.id_propiedad WHERE p.id_usuario_agente = ? ORDER BY v.id_propiedad DESC";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idAgente);
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
                    p.setAreaTechadaM2(rs.getBigDecimal("area_techada_m2"));
                    p.setNumDormitorios(rs.getInt("num_dormitorios"));
                    lista.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public boolean registrarPropiedad(PropiedadDTO p) {
        String sql = "INSERT INTO propiedad (id_usuario_agente, id_tipo_inmueble, id_operacion, id_distrito, partida_sunarp, titulo, descripcion, direccion, area_total_m2, area_techada_m2, num_dormitorios, num_banos, num_cocheras, anio_construccion, moneda_base, precio, bono_mi_vivienda, bono_verde, foto_principal, latitud, longitud, referencia, num_pisos, tour_360_url, fecha_publicacion, fecha_expiracion, estado) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 'ACTIVO')";
        boolean rowInserted = false;

        try (Connection conn = ConexionDB.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, p.getIdUsuarioAgente());
            stmt.setInt(2, p.getIdTipoInmueble());
            stmt.setInt(3, p.getIdOperacion());
            stmt.setInt(4, p.getIdDistrito());
            stmt.setString(5, p.getPartidaRegistral());
            stmt.setString(6, p.getTitulo());
            stmt.setString(7, p.getDescripcion());
            stmt.setString(8,
                    p.getDireccion() != null && !p.getDireccion().isEmpty() ? p.getDireccion() : "Sin Dirección");
            stmt.setBigDecimal(9, p.getAreaTotalM2());
            stmt.setBigDecimal(10, p.getAreaTechadaM2());
            stmt.setInt(11, p.getNumDormitorios());
            stmt.setInt(12, p.getNumBanos());
            stmt.setInt(13, p.getNumCocheras());
            stmt.setInt(14, p.getAnioConstruccion());
            stmt.setString(15, p.getMonedaBase() != null ? p.getMonedaBase() : "USD");
            stmt.setBigDecimal(16, p.getPrecio());
            stmt.setInt(17, p.getBonoMiVivienda());
            stmt.setInt(18, p.getBonoVerde());
            stmt.setString(19, p.getFotoPrincipal());
            stmt.setBigDecimal(20, p.getLatitud());
            stmt.setBigDecimal(21, p.getLongitud());
            
            stmt.setString(22, p.getReferencia());
            if (p.getNumPisos() != null) {
                stmt.setInt(23, p.getNumPisos());
            } else {
                stmt.setNull(23, java.sql.Types.INTEGER);
            }
            stmt.setString(24, p.getTour360Url());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                rowInserted = true;
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        p.setId(rs.getInt(1));
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al registrar propiedad: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rowInserted;
    }

    public PropiedadDTO obtenerPropiedadPorId(int id) {
        PropiedadDTO p = null;
        String sql = "SELECT p.*, " +
                     "ti.nombre AS tipo_inmueble, " +
                     "op.nombre AS operacion, " +
                     "d.nombre AS distrito, " +
                     "pr.nombre AS provincia, " +
                     "dep.nombre AS departamento, " +
                     "u.nombres AS agente_nombres, " +
                     "u.apellidos AS agente_apellidos, " +
                     "u.telefono AS agente_telefono, " +
                     "u.correo AS agente_correo, " +
                     "tc.venta AS tipo_cambio_venta, " +
                     "CASE WHEN p.moneda_base = 'USD' THEN ROUND(p.precio * tc.venta, 2) ELSE p.precio END AS precio_pen, " +
                     "CASE WHEN p.moneda_base = 'PEN' THEN ROUND(p.precio / tc.venta, 2) ELSE p.precio END AS precio_usd " +
                     "FROM propiedad p " +
                     "LEFT JOIN tipo_inmueble ti ON p.id_tipo_inmueble = ti.id_tipo " +
                     "LEFT JOIN operacion op ON p.id_operacion = op.id_operacion " +
                     "LEFT JOIN distrito d ON p.id_distrito = d.id_distrito " +
                     "LEFT JOIN provincia pr ON d.id_provincia = pr.id_provincia " +
                     "LEFT JOIN departamento dep ON pr.id_departamento = dep.id_departamento " +
                     "LEFT JOIN usuario u ON p.id_usuario_agente = u.id_usuario " +
                     "LEFT JOIN (SELECT venta FROM tipo_cambio WHERE par_moneda = 'USD/PEN' ORDER BY fecha_vigencia DESC LIMIT 1) tc ON 1=1 " +
                     "WHERE p.id_propiedad = ?";

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    p = new PropiedadDTO();
                    p.setId(rs.getInt("id_propiedad"));
                    p.setIdUsuarioAgente(rs.getInt("id_usuario_agente"));
                    p.setIdTipoInmueble(rs.getInt("id_tipo_inmueble"));
                    p.setIdOperacion(rs.getInt("id_operacion"));
                    p.setIdDistrito(rs.getInt("id_distrito"));
                    p.setPartidaRegistral(rs.getString("partida_sunarp"));
                    p.setTitulo(rs.getString("titulo"));
                    p.setDescripcion(rs.getString("descripcion"));
                    p.setDireccion(rs.getString("direccion"));
                    p.setAreaTotalM2(rs.getBigDecimal("area_total_m2"));
                    p.setAreaTechadaM2(rs.getBigDecimal("area_techada_m2"));
                    p.setNumDormitorios(rs.getInt("num_dormitorios"));
                    p.setNumBanos(rs.getInt("num_banos"));
                    p.setNumCocheras(rs.getInt("num_cocheras"));
                    p.setAnioConstruccion(rs.getInt("anio_construccion"));
                    p.setMonedaBase(rs.getString("moneda_base"));
                    p.setPrecio(rs.getBigDecimal("precio"));
                    p.setBonoMiVivienda(rs.getInt("bono_mi_vivienda"));
                    p.setBonoVerde(rs.getInt("bono_verde"));
                    p.setEstado(rs.getString("estado"));
                    p.setLatitud(rs.getBigDecimal("latitud"));
                    p.setLongitud(rs.getBigDecimal("longitud"));

                    // Text catalogs from base joins
                    p.setTipoInmueble(rs.getString("tipo_inmueble"));
                    p.setOperacion(rs.getString("operacion"));
                    p.setDistrito(rs.getString("distrito"));
                    p.setProvincia(rs.getString("provincia"));
                    p.setDepartamento(rs.getString("departamento"));
                    p.setPrecioPen(rs.getBigDecimal("precio_pen"));
                    p.setPrecioUsd(rs.getBigDecimal("precio_usd"));

                    // New DB fields
                    p.setReferencia(rs.getString("referencia"));
                    p.setNumPisos(rs.getObject("num_pisos") != null ? rs.getInt("num_pisos") : null);
                    p.setTour360Url(rs.getString("tour_360_url"));
                    p.setFechaPublicacion(rs.getString("fecha_publicacion"));
                    p.setFechaExpiracion(rs.getString("fecha_expiracion"));
                    p.setDestacada(rs.getBoolean("destacada"));
                    p.setFotoPrincipal(rs.getString("foto_principal"));
                    p.setNumeroVistas(rs.getInt("numero_vistas"));

                    // Agent details
                    String nombres = rs.getString("agente_nombres") != null ? rs.getString("agente_nombres") : "";
                    String apellidos = rs.getString("agente_apellidos") != null ? rs.getString("agente_apellidos") : "";
                    p.setAgenteNombre((nombres + " " + apellidos).trim());
                    p.setAgenteTelefono(rs.getString("agente_telefono"));
                    p.setAgenteCorreo(rs.getString("agente_correo"));
                    
                    try { p.setTipoCambioVenta(rs.getBigDecimal("tipo_cambio_venta")); } catch(Exception ignored) {}
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener propiedad por id: " + e.getMessage());
        }
        return p;
    }

    public boolean actualizarPropiedad(PropiedadDTO p) {
        String sql = "UPDATE propiedad SET id_tipo_inmueble=?, id_operacion=?, id_distrito=?, partida_sunarp=?, titulo=?, descripcion=?, direccion=?, area_total_m2=?, area_techada_m2=?, num_dormitorios=?, num_banos=?, num_cocheras=?, anio_construccion=?, moneda_base=?, precio=?, bono_mi_vivienda=?, bono_verde=?, foto_principal=?, latitud=?, longitud=?, referencia=?, num_pisos=?, tour_360_url=? WHERE id_propiedad=?";
        boolean rowUpdated = false;

        try (Connection conn = ConexionDB.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, p.getIdTipoInmueble());
            stmt.setInt(2, p.getIdOperacion());
            stmt.setInt(3, p.getIdDistrito());
            stmt.setString(4, p.getPartidaRegistral());
            stmt.setString(5, p.getTitulo());
            stmt.setString(6, p.getDescripcion());
            stmt.setString(7,
                    p.getDireccion() != null && !p.getDireccion().isEmpty() ? p.getDireccion() : "Sin Dirección");
            stmt.setBigDecimal(8, p.getAreaTotalM2());
            stmt.setBigDecimal(9, p.getAreaTechadaM2());
            stmt.setInt(10, p.getNumDormitorios());
            stmt.setInt(11, p.getNumBanos());
            stmt.setInt(12, p.getNumCocheras());
            stmt.setInt(13, p.getAnioConstruccion());
            stmt.setString(14, p.getMonedaBase() != null ? p.getMonedaBase() : "USD");
            stmt.setBigDecimal(15, p.getPrecio());
            stmt.setInt(16, p.getBonoMiVivienda());
            stmt.setInt(17, p.getBonoVerde());
            stmt.setString(18, p.getFotoPrincipal());
            stmt.setBigDecimal(19, p.getLatitud());
            stmt.setBigDecimal(20, p.getLongitud());
            
            stmt.setString(21, p.getReferencia());
            if (p.getNumPisos() != null) {
                stmt.setInt(22, p.getNumPisos());
            } else {
                stmt.setNull(22, java.sql.Types.INTEGER);
            }
            stmt.setString(23, p.getTour360Url());
            
            stmt.setInt(24, p.getId());

            rowUpdated = stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al actualizar propiedad: " + e.getMessage());
        }
        return rowUpdated;
    }

    public boolean eliminarPropiedad(int id) {
        String sql = "DELETE FROM propiedad WHERE id_propiedad = ?";
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

    public boolean cambiarEstadoPropiedad(int idPropiedad, String nuevoEstado) {
        String sql = "UPDATE propiedad SET estado = ? WHERE id_propiedad = ?";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, nuevoEstado);
            stmt.setInt(2, idPropiedad);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Sprint 2: Incrementar vistas
    public void incrementarVistas(int idPropiedad) {
        String sql = "UPDATE propiedad SET numero_vistas = numero_vistas + 1 WHERE id_propiedad = ?";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idPropiedad);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Sprint 2: Búsqueda avanzada con filtros extendidos
    public List<PropiedadDTO> buscarPropiedadesAvanzado(String keyword, String operacion, String tipoInmueble,
            BigDecimal precioMin, BigDecimal precioMax, Integer dormitorios, Integer banos, int offset, int limit) {
        keyword = cleanKeyword(keyword);
        List<PropiedadDTO> lista = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT v.*, p.descripcion, p.foto_principal, p.numero_vistas, p.destacada, p.area_total_m2 " +
                "FROM v_propiedades_bimonetarias v " +
                "INNER JOIN propiedad p ON v.id_propiedad = p.id_propiedad " +
                "WHERE 1=1 ");

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (v.titulo LIKE ? OR v.distrito LIKE ? OR p.descripcion LIKE ?) ");
        }
        if (operacion != null && !operacion.trim().isEmpty()) {
            sql.append(" AND v.operacion = ? ");
        }
        if (tipoInmueble != null && !tipoInmueble.trim().isEmpty()) {
            sql.append(" AND v.tipo_inmueble = ? ");
        }
        if (precioMin != null) {
            sql.append(" AND v.precio_usd >= ? ");
        }
        if (precioMax != null) {
            sql.append(" AND v.precio_usd <= ? ");
        }
        if (dormitorios != null && dormitorios > 0) {
            if (dormitorios >= 4) {
                sql.append(" AND v.num_dormitorios >= 4 ");
            } else {
                sql.append(" AND v.num_dormitorios = ? ");
            }
        }
        if (banos != null && banos > 0) {
            if (banos >= 3) {
                sql.append(" AND v.num_banos >= 3 ");
            } else {
                sql.append(" AND v.num_banos = ? ");
            }
        }
        sql.append(" ORDER BY v.id_propiedad DESC LIMIT ? OFFSET ?");

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String term = "%" + keyword.trim() + "%";
                stmt.setString(idx++, term);
                stmt.setString(idx++, term);
                stmt.setString(idx++, term);
            }
            if (operacion != null && !operacion.trim().isEmpty()) {
                stmt.setString(idx++, operacion.trim());
            }
            if (tipoInmueble != null && !tipoInmueble.trim().isEmpty()) {
                stmt.setString(idx++, tipoInmueble.trim());
            }
            if (precioMin != null) {
                stmt.setBigDecimal(idx++, precioMin);
            }
            if (precioMax != null) {
                stmt.setBigDecimal(idx++, precioMax);
            }
            if (dormitorios != null && dormitorios > 0 && dormitorios < 4) {
                stmt.setInt(idx++, dormitorios);
            }
            if (banos != null && banos > 0 && banos < 3) {
                stmt.setInt(idx++, banos);
            }
            stmt.setInt(idx++, limit);
            stmt.setInt(idx++, offset);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    PropiedadDTO p = mapResultSet(rs);
                    lista.add(p);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error búsqueda avanzada: " + e.getMessage());
        }
        return lista;
    }

    // Sprint 2: Conteo avanzado
    public int contarPropiedadesAvanzado(String keyword, String operacion, String tipoInmueble,
            BigDecimal precioMin, BigDecimal precioMax, Integer dormitorios, Integer banos) {
        keyword = cleanKeyword(keyword);
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(v.id_propiedad) FROM v_propiedades_bimonetarias v " +
                "INNER JOIN propiedad p ON v.id_propiedad = p.id_propiedad WHERE 1=1 ");

        if (keyword != null && !keyword.trim().isEmpty()) sql.append(" AND (v.titulo LIKE ? OR v.distrito LIKE ? OR p.descripcion LIKE ?) ");
        if (operacion != null && !operacion.trim().isEmpty()) sql.append(" AND v.operacion = ? ");
        if (tipoInmueble != null && !tipoInmueble.trim().isEmpty()) sql.append(" AND v.tipo_inmueble = ? ");
        if (precioMin != null) sql.append(" AND v.precio_usd >= ? ");
        if (precioMax != null) sql.append(" AND v.precio_usd <= ? ");
        if (dormitorios != null && dormitorios > 0) {
            if (dormitorios >= 4) sql.append(" AND v.num_dormitorios >= 4 ");
            else sql.append(" AND v.num_dormitorios = ? ");
        }
        if (banos != null && banos > 0) {
            if (banos >= 3) sql.append(" AND v.num_banos >= 3 ");
            else sql.append(" AND v.num_banos = ? ");
        }

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (keyword != null && !keyword.trim().isEmpty()) { String t = "%"+keyword.trim()+"%"; stmt.setString(idx++,t); stmt.setString(idx++,t); stmt.setString(idx++,t); }
            if (operacion != null && !operacion.trim().isEmpty()) stmt.setString(idx++, operacion.trim());
            if (tipoInmueble != null && !tipoInmueble.trim().isEmpty()) stmt.setString(idx++, tipoInmueble.trim());
            if (precioMin != null) stmt.setBigDecimal(idx++, precioMin);
            if (precioMax != null) stmt.setBigDecimal(idx++, precioMax);
            if (dormitorios != null && dormitorios > 0 && dormitorios < 4) stmt.setInt(idx++, dormitorios);
            if (banos != null && banos > 0 && banos < 3) stmt.setInt(idx++, banos);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private String cleanKeyword(String keyword) {
        if (keyword == null) return null;
        String trimmed = keyword.trim();
        if (trimmed.contains("(")) {
            trimmed = trimmed.split("\\(")[0].trim();
        }
        return trimmed;
    }

    // Helper: mapear ResultSet a DTO
    private PropiedadDTO mapResultSet(ResultSet rs) throws SQLException {
        PropiedadDTO p = new PropiedadDTO();
        p.setId(rs.getInt("id_propiedad"));
        p.setTitulo(rs.getString("titulo"));
        try { p.setDescripcion(rs.getString("descripcion")); } catch(Exception ignored) {}
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
        try { p.setFotoPrincipal(rs.getString("foto_principal")); } catch(Exception ignored) {}
        try { p.setNumeroVistas(rs.getInt("numero_vistas")); } catch(Exception ignored) {}
        try { p.setTipoCambioVenta(rs.getBigDecimal("tipo_cambio_venta")); } catch(Exception ignored) {}
        try { p.setDestacada(rs.getBoolean("destacada")); } catch(Exception ignored) {}
        try { p.setAreaTotalM2(rs.getBigDecimal("area_total_m2")); } catch(Exception ignored) {}
        p.setUbicacion(rs.getString("distrito") + ", " + rs.getString("provincia"));
        p.setPrecio(rs.getBigDecimal("precio_usd"));
        return p;
    }

    // Sprint 2: Propiedades por agente con filtro de estado y ordenamiento
    public List<PropiedadDTO> obtenerPropiedadesAgenteConFiltros(int idAgente, String estado, String orden) {
        List<PropiedadDTO> lista = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT v.*, p.descripcion, p.foto_principal, p.numero_vistas FROM v_propiedades_bimonetarias v " +
            "INNER JOIN propiedad p ON v.id_propiedad = p.id_propiedad WHERE p.id_usuario_agente = ? ");
        // Nota: v_propiedades_bimonetarias filtra por ACTIVO, pero para el agente queremos todo
        // Usamos query directa para incluir todos los estados
        sql = new StringBuilder(
            "SELECT p.id_propiedad, p.titulo, p.estado, p.moneda_base, p.precio, p.foto_principal, p.numero_vistas, " +
            "p.area_techada_m2, p.num_dormitorios, p.num_banos, p.descripcion, " +
            "ti.nombre as tipo_inmueble, op.nombre as operacion, d.nombre as distrito " +
            "FROM propiedad p " +
            "JOIN tipo_inmueble ti ON ti.id_tipo = p.id_tipo_inmueble " +
            "JOIN operacion op ON op.id_operacion = p.id_operacion " +
            "JOIN distrito d ON d.id_distrito = p.id_distrito " +
            "WHERE p.id_usuario_agente = ? ");

        if (estado != null && !estado.isEmpty()) {
            sql.append(" AND p.estado = ? ");
        }
        if ("vistas".equals(orden)) {
            sql.append(" ORDER BY p.numero_vistas DESC");
        } else {
            sql.append(" ORDER BY p.id_propiedad DESC");
        }

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            stmt.setInt(idx++, idAgente);
            if (estado != null && !estado.isEmpty()) {
                stmt.setString(idx++, estado);
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    PropiedadDTO p = new PropiedadDTO();
                    p.setId(rs.getInt("id_propiedad"));
                    p.setTitulo(rs.getString("titulo"));
                    p.setEstado(rs.getString("estado"));
                    p.setMonedaBase(rs.getString("moneda_base"));
                    p.setPrecio(rs.getBigDecimal("precio"));
                    p.setPrecioUsd(rs.getBigDecimal("precio")); // approx
                    p.setFotoPrincipal(rs.getString("foto_principal"));
                    p.setNumeroVistas(rs.getInt("numero_vistas"));
                    p.setAreaTechadaM2(rs.getBigDecimal("area_techada_m2"));
                    p.setNumDormitorios(rs.getInt("num_dormitorios"));
                    p.setNumBanos(rs.getInt("num_banos"));
                    p.setTipoInmueble(rs.getString("tipo_inmueble"));
                    p.setOperacion(rs.getString("operacion"));
                    p.setDistrito(rs.getString("distrito"));
                    lista.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public int obtenerLimitePublicaciones(int idUsuario) {
        String sql = "SELECT COALESCE(p.max_propiedades, 1) AS max_propiedades " +
                     "FROM usuario u " +
                     "LEFT JOIN suscripcion s ON u.id_usuario = s.id_usuario AND s.estado = 'ACTIVA' AND s.fecha_fin >= NOW() " +
                     "LEFT JOIN plan p ON s.id_plan = p.id_plan " +
                     "WHERE u.id_usuario = ? " +
                     "LIMIT 1";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idUsuario);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("max_propiedades");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 1; // Plan Gratuito por defecto
    }

    public int contarPropiedadesActivas(int idUsuario) {
        String sql = "SELECT COUNT(*) FROM propiedad WHERE id_usuario_agente = ? AND estado = 'ACTIVO'";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idUsuario);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<PropiedadDTO> obtenerPropiedadesDestacadas(int limit) {
        List<PropiedadDTO> lista = new ArrayList<>();
        String sql = "SELECT v.*, p.descripcion, p.foto_principal, p.numero_vistas, p.destacada, p.area_total_m2 " +
                     "FROM v_propiedades_bimonetarias v " +
                     "INNER JOIN propiedad p ON v.id_propiedad = p.id_propiedad " +
                     "WHERE p.destacada = 1 AND p.estado = 'ACTIVO' " +
                     "ORDER BY p.id_propiedad DESC LIMIT ?";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
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
                    p.setFotoPrincipal(rs.getString("foto_principal"));
                    p.setNumeroVistas(rs.getInt("numero_vistas"));
                    p.setTipoCambioVenta(rs.getBigDecimal("tipo_cambio_venta"));
                    p.setUbicacion(rs.getString("distrito") + ", " + rs.getString("provincia"));
                    p.setPrecio(rs.getBigDecimal("precio_usd"));
                    p.setDestacada(true);
                    p.setAreaTotalM2(rs.getBigDecimal("area_total_m2"));
                    lista.add(p);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener propiedades destacadas: " + e.getMessage());
        }

        if (lista.isEmpty()) {
            String fallbackSql = "SELECT v.*, p.descripcion, p.foto_principal, p.numero_vistas, p.destacada, p.area_total_m2 " +
                                 "FROM v_propiedades_bimonetarias v " +
                                 "INNER JOIN propiedad p ON v.id_propiedad = p.id_propiedad " +
                                 "WHERE p.estado = 'ACTIVO' " +
                                 "ORDER BY p.id_propiedad DESC LIMIT ?";
            try (Connection conn = ConexionDB.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(fallbackSql)) {
                stmt.setInt(1, limit);
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
                        p.setFotoPrincipal(rs.getString("foto_principal"));
                        p.setNumeroVistas(rs.getInt("numero_vistas"));
                        p.setTipoCambioVenta(rs.getBigDecimal("tipo_cambio_venta"));
                        p.setUbicacion(rs.getString("distrito") + ", " + rs.getString("provincia"));
                        p.setPrecio(rs.getBigDecimal("precio_usd"));
                        p.setDestacada(rs.getBoolean("destacada"));
                        p.setAreaTotalM2(rs.getBigDecimal("area_total_m2"));
                        lista.add(p);
                    }
                }
            } catch (SQLException e) {
                System.err.println("Error al obtener propiedades fallback destacadas: " + e.getMessage());
            }
        }
        return lista;
    }

    public List<PropiedadDTO> buscarPropiedadesAdmin(String keyword, String operacion, String tipoInmueble, int offset, int limit) {
        keyword = cleanKeyword(keyword);
        List<PropiedadDTO> lista = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
            "SELECT p.id_propiedad, p.titulo, p.estado, p.moneda_base, p.precio, p.foto_principal, p.numero_vistas, " +
            "p.area_techada_m2, p.num_dormitorios, p.num_banos, p.descripcion, p.fecha_publicacion, " +
            "ti.nombre as tipo_inmueble, op.nombre as operacion, d.nombre as distrito, pr.nombre as provincia, " +
            "tc.venta AS tipo_cambio_venta, " +
            "CASE WHEN p.moneda_base = 'USD' THEN ROUND(p.precio * tc.venta, 2) ELSE p.precio END AS precio_pen, " +
            "CASE WHEN p.moneda_base = 'PEN' THEN ROUND(p.precio / tc.venta, 2) ELSE p.precio END AS precio_usd " +
            "FROM propiedad p " +
            "LEFT JOIN tipo_inmueble ti ON p.id_tipo_inmueble = ti.id_tipo " +
            "LEFT JOIN operacion op ON p.id_operacion = op.id_operacion " +
            "LEFT JOIN distrito d ON p.id_distrito = d.id_distrito " +
            "LEFT JOIN provincia pr ON d.id_provincia = pr.id_provincia " +
            "LEFT JOIN (SELECT venta FROM tipo_cambio WHERE par_moneda = 'USD/PEN' ORDER BY fecha_vigencia DESC LIMIT 1) tc ON 1=1 " +
            "WHERE 1=1 "
        );

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (p.titulo LIKE ? OR d.nombre LIKE ? OR p.descripcion LIKE ?) ");
        }
        if (operacion != null && !operacion.trim().isEmpty()) {
            sql.append(" AND op.nombre = ? ");
        }
        if (tipoInmueble != null && !tipoInmueble.trim().isEmpty()) {
            sql.append(" AND ti.nombre = ? ");
        }

        sql.append(" ORDER BY p.id_propiedad DESC LIMIT ? OFFSET ?");

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
            stmt.setInt(paramIndex++, limit);
            stmt.setInt(paramIndex++, offset);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    PropiedadDTO p = new PropiedadDTO();
                    p.setId(rs.getInt("id_propiedad"));
                    p.setTitulo(rs.getString("titulo"));
                    p.setEstado(rs.getString("estado"));
                    p.setMonedaBase(rs.getString("moneda_base"));
                    p.setPrecio(rs.getBigDecimal("precio"));
                    p.setPrecioPen(rs.getBigDecimal("precio_pen"));
                    p.setPrecioUsd(rs.getBigDecimal("precio_usd"));
                    p.setFotoPrincipal(rs.getString("foto_principal"));
                    p.setNumeroVistas(rs.getInt("numero_vistas"));
                    p.setAreaTechadaM2(rs.getBigDecimal("area_techada_m2"));
                    p.setNumDormitorios(rs.getInt("num_dormitorios"));
                    p.setNumBanos(rs.getInt("num_banos"));
                    p.setDescripcion(rs.getString("descripcion"));
                    p.setFechaPublicacion(rs.getString("fecha_publicacion"));
                    p.setTipoInmueble(rs.getString("tipo_inmueble"));
                    p.setOperacion(rs.getString("operacion"));
                    p.setDistrito(rs.getString("distrito"));
                    p.setProvincia(rs.getString("provincia"));
                    p.setUbicacion(rs.getString("distrito") + ", " + rs.getString("provincia"));
                    try { p.setTipoCambioVenta(rs.getBigDecimal("tipo_cambio_venta")); } catch(Exception ignored) {}
                    lista.add(p);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al buscar propiedades admin: " + e.getMessage());
        }
        return lista;
    }

    public int contarPropiedadesAdmin(String keyword, String operacion, String tipoInmueble) {
        keyword = cleanKeyword(keyword);
        int total = 0;
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(p.id_propiedad) " +
            "FROM propiedad p " +
            "LEFT JOIN tipo_inmueble ti ON p.id_tipo_inmueble = ti.id_tipo " +
            "LEFT JOIN operacion op ON p.id_operacion = op.id_operacion " +
            "LEFT JOIN distrito d ON p.id_distrito = d.id_distrito " +
            "WHERE 1=1 "
        );

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (p.titulo LIKE ? OR d.nombre LIKE ? OR p.descripcion LIKE ?) ");
        }
        if (operacion != null && !operacion.trim().isEmpty()) {
            sql.append(" AND op.nombre = ? ");
        }
        if (tipoInmueble != null && !tipoInmueble.trim().isEmpty()) {
            sql.append(" AND ti.nombre = ? ");
        }

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
                if (rs.next()) {
                    total = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }
}
