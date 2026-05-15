package org.example.proyectoweb.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.proyectoweb.facade.UsuarioFacade;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

@WebServlet("/setup-admin")
public class SetupAdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String rawPassword = "123456";
        String hash = BCrypt.hashpw(rawPassword, BCrypt.gensalt());
        
        UsuarioFacade usuarioFacade = new UsuarioFacade();
        boolean ok = usuarioFacade.repararCuentasPrueba(hash);
        
        try {
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<html><body style='font-family:sans-serif; text-align:center; margin-top:50px;'>");
            if (ok) {
                response.getWriter().println("<h2 style='color:green;'>¡Reparación de Seguridad Completada!</h2>");
                response.getWriter().println("<p>Se ha generado un nuevo hash BCrypt válido y se inyectó en el Administrador y en el Agente.</p>");
            } else {
                response.getWriter().println("<h2 style='color:red;'>Ocurrió un error al inyectar las cuentas.</h2>");
            }
            response.getWriter().println("<p><b>Admin:</b> admin@inmobix.pe</p>");
            response.getWriter().println("<p><b>Agente:</b> agente@inmobix.com</p>");
            response.getWriter().println("<p><b>Clave para ambos:</b> 123456</p>");
            response.getWriter().println("<a href='" + request.getContextPath() + "/login' style='padding:10px 20px; background:blue; color:white; text-decoration:none; border-radius:5px;'>Ir al Login</a>");
            response.getWriter().println("</body></html>");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error inyectando el admin: " + e.getMessage());
        }
    }
}
