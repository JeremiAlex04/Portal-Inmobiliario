package org.example.proyectoweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.proyectoweb.facade.PropiedadFacade;
import org.example.proyectoweb.dto.PropiedadDTO;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "PropiedadServlet", urlPatterns = {"/propiedades"})
public class PropiedadServlet extends HttpServlet {

    private PropiedadFacade propiedadFacade;

    @Override
    public void init() throws ServletException {
        // Inicializa el Facade una sola vez al cargar el Servlet (No se instancia el DAO directamente)
        propiedadFacade = new PropiedadFacade();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "listar";
        }

        try {
            switch (accion) {
                case "nuevo":
                    // Muestra el formulario vacío para registrar
                    request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
                    break;
                case "editar":
                    // Obtiene la propiedad por ID y la envía al formulario para editar
                    int idEditar = Integer.parseInt(request.getParameter("id"));
                    PropiedadDTO pEditar = propiedadFacade.obtenerPropiedad(idEditar);
                    request.setAttribute("propiedad", pEditar);
                    request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
                    break;
                case "eliminar":
                    // Elimina la propiedad y redirige a la lista
                    int idEliminar = Integer.parseInt(request.getParameter("id"));
                    propiedadFacade.eliminarPropiedad(idEliminar);
                    response.sendRedirect(request.getContextPath() + "/propiedades");
                    break;
                case "listar":
                default:
                    // Capturar parámetros de búsqueda
                    String keyword = request.getParameter("q");
                    String operacion = request.getParameter("operacion");
                    String tipoInmueble = request.getParameter("tipo");

                    List<PropiedadDTO> listaPropiedades;
                    if (keyword != null || operacion != null || tipoInmueble != null) {
                        listaPropiedades = propiedadFacade.buscarPropiedades(keyword, operacion, tipoInmueble);
                    } else {
                        listaPropiedades = propiedadFacade.listarPropiedades();
                    }
                    
                    request.setAttribute("listaPropiedades", listaPropiedades);
                    request.setAttribute("paramQ", keyword);
                    request.setAttribute("paramOperacion", operacion);
                    request.setAttribute("paramTipo", tipoInmueble);
                    
                    request.getRequestDispatcher("/WEB-INF/views/propiedades.jsp").forward(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error procesando la solicitud GET");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        String titulo = request.getParameter("titulo");
        String descripcion = request.getParameter("descripcion");
        String precioStr = request.getParameter("precio");
        String ubicacion = request.getParameter("ubicacion");

        try {
            BigDecimal precio = new BigDecimal(precioStr);
            PropiedadDTO propiedad = new PropiedadDTO(0, titulo, descripcion, precio, ubicacion);
            
            boolean exito;
            if (idStr != null && !idStr.isEmpty()) {
                // Actualizar propiedad existente
                int id = Integer.parseInt(idStr);
                propiedad.setId(id);
                exito = propiedadFacade.actualizarPropiedad(propiedad);
            } else {
                // Registrar nueva propiedad
                exito = propiedadFacade.registrarPropiedad(propiedad);
            }
            
            if (exito) {
                // Redirige al listado
                response.sendRedirect(request.getContextPath() + "/propiedades");
            } else {
                request.setAttribute("error", "No se pudo guardar la propiedad en la base de datos.");
                request.setAttribute("propiedad", propiedad); // Mantiene los datos en el form
                request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error de conversión de datos: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
        }
    }
}
