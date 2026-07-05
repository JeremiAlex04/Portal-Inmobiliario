package org.example.proyectoweb.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionDB {

    // Configuración por defecto para MySQL local
    private static final String URL = "jdbc:mysql://localhost:3306/inmobix_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASSWORD = "200319";

    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            return conn;
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Error: No se encontró el driver de MySQL.", e);
        } catch (SQLException e) {
            throw new RuntimeException(
                    "Error: Fallo al conectar con la base de datos. Verifica que MySQL esté corriendo en localhost:3306 y que la BD 'inmobix_db' exista. Credenciales: root/200319",
                    e);
        }
    }
}
