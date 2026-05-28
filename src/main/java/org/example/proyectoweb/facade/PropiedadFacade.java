package org.example.proyectoweb.facade;

import org.example.proyectoweb.dao.PropiedadDAO;
import org.example.proyectoweb.dto.PropiedadDTO;

import java.math.BigDecimal;
import java.util.List;

public class PropiedadFacade {

    private PropiedadDAO propiedadDAO;

    // Constantes de validación de negocio
    private static final BigDecimal PRECIO_MINIMO_VENTA = new BigDecimal("10000");
    private static final BigDecimal PRECIO_MINIMO_ALQUILER = new BigDecimal("100");

    public PropiedadFacade() {
        this.propiedadDAO = new PropiedadDAO();
    }

    // =========================================================
    // VALIDACIONES DE NEGOCIO (Requisito Sprint 1 - Facade)
    // =========================================================

    /**
     * Valida las reglas de negocio para una propiedad antes de persistirla.
     * @return null si es válido, o un mensaje de error si hay violación.
     */
    public String validarPropiedad(PropiedadDTO p) {
        // RN-01: El título no puede estar vacío
        if (p.getTitulo() == null || p.getTitulo().trim().isEmpty()) {
            return "El título de la propiedad es obligatorio.";
        }

        // RN-02: No permitir precios negativos
        if (p.getPrecio() != null && p.getPrecio().compareTo(BigDecimal.ZERO) <= 0) {
            return "El precio debe ser mayor a 0.";
        }

        // RN-03: El precio mínimo en VENTA debe ser mayor a 10,000
        if (p.getIdOperacion() == 1 && p.getPrecio() != null
                && p.getPrecio().compareTo(PRECIO_MINIMO_VENTA) < 0) {
            return "El precio mínimo para una venta es de 10,000.";
        }

        // RN-04: El precio mínimo en ALQUILER debe ser mayor a 100
        if (p.getIdOperacion() == 2 && p.getPrecio() != null
                && p.getPrecio().compareTo(PRECIO_MINIMO_ALQUILER) < 0) {
            return "El precio mínimo para un alquiler es de 100.";
        }

        // RN-05: No permitir publicar propiedades sin ubicación (distrito)
        if (p.getIdDistrito() <= 0) {
            return "Debe seleccionar una ubicación (distrito) para la propiedad.";
        }

        // RN-06: No permitir publicar propiedades sin tipo de inmueble
        if (p.getIdTipoInmueble() <= 0) {
            return "Debe seleccionar el tipo de inmueble.";
        }

        return null; // Todo válido
    }

    // =========================================================
    // OPERACIONES CRUD
    // =========================================================

    public List<PropiedadDTO> buscarPropiedades(String keyword, String operacion, String tipoInmueble, int offset, int limit) {
        return propiedadDAO.buscarPropiedades(keyword, operacion, tipoInmueble, offset, limit);
    }

    public int contarPropiedades(String keyword, String operacion, String tipoInmueble) {
        return propiedadDAO.contarPropiedades(keyword, operacion, tipoInmueble);
    }

    public List<org.example.proyectoweb.dto.CatalogoDTO> obtenerDistritos() {
        return propiedadDAO.obtenerDistritos();
    }

    public List<org.example.proyectoweb.dto.CatalogoDTO> obtenerTiposInmueble() {
        return propiedadDAO.obtenerTiposInmueble();
    }

    public List<org.example.proyectoweb.dto.CatalogoDTO> obtenerOperaciones() {
        return propiedadDAO.obtenerOperaciones();
    }

    public List<PropiedadDTO> listarPropiedades(int offset, int limit) {
        return propiedadDAO.obtenerPropiedades(offset, limit);
    }

    public List<PropiedadDTO> obtenerPropiedadesPorAgente(int idAgente) {
        return propiedadDAO.obtenerPropiedadesPorAgente(idAgente);
    }

    public PropiedadDTO obtenerPropiedad(int id) {
        return propiedadDAO.obtenerPropiedadPorId(id);
    }

    public boolean registrarPropiedad(PropiedadDTO propiedad) {
        // Aplicar validaciones de negocio antes de persistir
        String error = validarPropiedad(propiedad);
        if (error != null) {
            return false;
        }
        return propiedadDAO.registrarPropiedad(propiedad);
    }

    public boolean actualizarPropiedad(PropiedadDTO propiedad) {
        // Aplicar validaciones de negocio antes de actualizar
        String error = validarPropiedad(propiedad);
        if (error != null) {
            return false;
        }
        return propiedadDAO.actualizarPropiedad(propiedad);
    }

    public boolean eliminarPropiedad(int id) {
        return propiedadDAO.eliminarPropiedad(id);
    }

    public boolean cambiarEstadoPropiedad(int idPropiedad, String nuevoEstado) {
        // RN-07: Validar que el estado sea uno de los permitidos por el ENUM de la base de datos
        if (nuevoEstado == null || (!nuevoEstado.equals("BORRADOR") && !nuevoEstado.equals("ACTIVO")
                && !nuevoEstado.equals("PAUSADO") && !nuevoEstado.equals("VENDIDO")
                && !nuevoEstado.equals("ELIMINADO"))) {
            return false;
        }
        return propiedadDAO.cambiarEstadoPropiedad(idPropiedad, nuevoEstado);
    }

    // =========================================================
    // Sprint 2: Búsqueda Avanzada + Vistas + Panel Agente
    // =========================================================

    public List<PropiedadDTO> buscarPropiedadesAvanzado(String keyword, String operacion, String tipoInmueble,
            java.math.BigDecimal precioMin, java.math.BigDecimal precioMax, Integer dormitorios, Integer banos,
            int offset, int limit) {
        return propiedadDAO.buscarPropiedadesAvanzado(keyword, operacion, tipoInmueble, precioMin, precioMax, dormitorios, banos, offset, limit);
    }

    public int contarPropiedadesAvanzado(String keyword, String operacion, String tipoInmueble,
            java.math.BigDecimal precioMin, java.math.BigDecimal precioMax, Integer dormitorios, Integer banos) {
        return propiedadDAO.contarPropiedadesAvanzado(keyword, operacion, tipoInmueble, precioMin, precioMax, dormitorios, banos);
    }

    public void incrementarVistas(int idPropiedad) {
        propiedadDAO.incrementarVistas(idPropiedad);
    }

    public List<PropiedadDTO> obtenerPropiedadesAgenteConFiltros(int idAgente, String estado, String orden) {
        return propiedadDAO.obtenerPropiedadesAgenteConFiltros(idAgente, estado, orden);
    }

    public int obtenerLimitePublicaciones(int idUsuario) {
        return propiedadDAO.obtenerLimitePublicaciones(idUsuario);
    }

    public int contarPropiedadesActivas(int idUsuario) {
        return propiedadDAO.contarPropiedadesActivas(idUsuario);
    }

    public List<PropiedadDTO> obtenerPropiedadesDestacadas(int limit) {
        return propiedadDAO.obtenerPropiedadesDestacadas(limit);
    }

    public List<PropiedadDTO> buscarPropiedadesAdmin(String keyword, String operacion, String tipoInmueble, int offset, int limit) {
        return propiedadDAO.buscarPropiedadesAdmin(keyword, operacion, tipoInmueble, offset, limit);
    }

    public List<PropiedadDTO> listarPropiedadesAdmin(int offset, int limit) {
        return propiedadDAO.buscarPropiedadesAdmin(null, null, null, offset, limit);
    }
}
