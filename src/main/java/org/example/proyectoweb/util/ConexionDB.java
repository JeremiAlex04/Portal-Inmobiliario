package org.example.proyectoweb.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionDB {

    // Configuración para MySQL en XAMPP local
    private static final String URL = "jdbc:mysql://localhost:3306/inmobix?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASSWORD = "";

    public static Connection getConnection() {
        Connection conn = null;
        try {
            // Registrar explícitamente el driver de MySQL (Requerido en algunos entornos Servlet antiguos/clásicos)
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Conexión exitosa a la base de datos inmobix");
        } catch (ClassNotFoundException e) {
            System.err.println("Error: No se encontró el driver de MySQL.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println(
                    "Error: Fallo al conectar con la base de datos. Verifica credenciales y que el servidor MySQL esté corriendo.");
            e.printStackTrace();
        }
        return conn;
    }
}
