package org.example.proyectoweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import org.example.proyectoweb.dao.GaleriaDAO;
import org.example.proyectoweb.dto.PropiedadFotoDTO;
import org.example.proyectoweb.dto.UsuarioDTO;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

@WebServlet("/galeria")
@MultipartConfig(fileSizeThreshold = 1024*1024, maxFileSize = 2*1024*1024, maxRequestSize = 12*1024*1024)
public class GaleriaServlet extends HttpServlet {
    private GaleriaDAO galeriaDAO;
    private static final List<String> EXT_PERMITIDAS = Arrays.asList("jpg", "jpeg", "png", "webp");

    @Override
    public void init() { galeriaDAO = new GaleriaDAO(); }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accion = request.getParameter("accion");
        int idPropiedad = Integer.parseInt(request.getParameter("idPropiedad"));

        if ("eliminar".equals(accion)) {
            int idFoto = Integer.parseInt(request.getParameter("idFoto"));
            PropiedadFotoDTO foto = galeriaDAO.obtenerFoto(idFoto);
            if (foto != null) {
                // Eliminar archivo físico
                String realPath = getServletContext().getRealPath("/" + foto.getRutaArchivo());
                File file = new File(realPath);
                if (file.exists()) file.delete();
                galeriaDAO.eliminarFoto(idFoto);
            }
            response.sendRedirect(request.getContextPath() + "/propiedades?accion=editar&id=" + idPropiedad);
            return;
        }

        // Subir fotos
        int existentes = galeriaDAO.contarFotos(idPropiedad);
        int disponibles = 5 - existentes;

        if (disponibles <= 0) {
            response.sendRedirect(request.getContextPath() + "/propiedades?accion=editar&id=" + idPropiedad + "&errorGaleria=maxFotos");
            return;
        }

        String uploadPath = getServletContext().getRealPath("/uploads/propiedades");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        int subidas = 0;
        for (Part part : request.getParts()) {
            if (!"fotos".equals(part.getName()) || part.getSize() == 0) continue;
            if (subidas >= disponibles) break;

            String fileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
            String ext = fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase();
            if (!EXT_PERMITIDAS.contains(ext)) continue;
            if (part.getSize() > 2 * 1024 * 1024) continue;

            String nuevoNombre = UUID.randomUUID().toString() + "." + ext;
            part.write(uploadPath + File.separator + nuevoNombre);

            PropiedadFotoDTO foto = new PropiedadFotoDTO();
            foto.setIdPropiedad(idPropiedad);
            foto.setRutaArchivo("uploads/propiedades/" + nuevoNombre);
            foto.setOrden(existentes + subidas);
            foto.setEsPrincipal(existentes == 0 && subidas == 0);
            galeriaDAO.agregarFoto(foto);
            subidas++;
        }

        response.sendRedirect(request.getContextPath() + "/propiedades?accion=editar&id=" + idPropiedad);
    }
}
