package org.example.proyectoweb.util;

import org.example.proyectoweb.dao.PropiedadDAO;
import org.example.proyectoweb.dto.PropiedadDTO;
import java.util.List;

public class TestDB {
    public static void main(String[] args) {
        System.out.println("====== INICIANDO DIAGNÓSTICO DE BÚSQUEDA ======");
        PropiedadDAO dao = new PropiedadDAO();

        testSearch(dao, "Miraflores", "VENTA", "");
        testSearch(dao, "", "VENTA", "Departamento");
        testSearch(dao, "Santiago de Surco", "VENTA", "");
        testSearch(dao, "Miraflores (Lima)", "VENTA", "");
    }

    private static void testSearch(PropiedadDAO dao, String keyword, String operacion, String tipo) {
        System.out.println("\n--- Probando búsqueda: q='" + keyword + "', operacion='" + operacion + "', tipo='" + tipo + "' ---");
        try {
            List<PropiedadDTO> res = dao.buscarPropiedadesAvanzado(keyword, operacion, tipo, null, null, null, null, 0, 10);
            System.out.println("Resultados encontrados: " + res.size());
            for (PropiedadDTO p : res) {
                System.out.println(" - ID: " + p.getId() + " | Título: " + p.getTitulo() + " | Distrito: " + p.getDistrito() + " | Operación: " + p.getOperacion() + " | Tipo: " + p.getTipoInmueble() + " | Estado: " + p.getEstado());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
