package org.example.proyectoweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.proyectoweb.dao.PropiedadDAO;
import org.example.proyectoweb.model.Propiedad;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "PropiedadServlet", urlPatterns = {"/propiedades"})
public class PropiedadServlet extends HttpServlet {

    private PropiedadDAO propiedadDAO;

    @Override
    public void init() throws ServletException {
        // Inicializa el DAO una sola vez al cargar el Servlet
        propiedadDAO = new PropiedadDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("accion");

        if ("nuevo".equals(action)) {
            // Muestra el formulario de registro
            request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
        } else {
            // Acción por defecto: Listar Propiedades
            List<Propiedad> listaPropiedades = propiedadDAO.obtenerPropiedades();
            // Envío de información desde el servlet a la vista (requerido en la rúbrica)
            request.setAttribute("listaPropiedades", listaPropiedades);
            request.getRequestDispatcher("/WEB-INF/views/propiedades.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Recepción de parámetros y procesamiento básico de datos (requerido en rúbrica)
        String titulo = request.getParameter("titulo");
        String descripcion = request.getParameter("descripcion");
        String precioStr = request.getParameter("precio");
        String ubicacion = request.getParameter("ubicacion");

        try {
            BigDecimal precio = new BigDecimal(precioStr);
            Propiedad nuevaPropiedad = new Propiedad(0, titulo, descripcion, precio, ubicacion);
            
            boolean insertado = propiedadDAO.registrarPropiedad(nuevaPropiedad);
            
            if (insertado) {
                // Redirige al doGet normal para listar con la nueva propiedad
                response.sendRedirect(request.getContextPath() + "/propiedades");
            } else {
                request.setAttribute("error", "No se pudo registrar la propiedad en la base de datos.");
                request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error de conversión de datos: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
        }
    }
}
