package org.example.proyectoweb;

import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;

/**
 * BUENA PRÁCTICA: Formato de Representación Estandarizado (JSON)
 * 
 * Este recurso RESTful (JAX-RS) expone el endpoint "/hello-world".
 * Define explícitamente el uso de JSON para la comunicación con el cliente, 
 * abstrayendo la lógica interna y entregando datos crudos listos para el consumo.
 */
@Path("/hello-world")
public class HelloResource {
    
    /**
     * Método de Lectura Segura (GET) que devuelve datos estructurados en formato JSON.
     * La anotación @Produces asegura que el Content-Type en la cabecera HTTP de respuesta
     * sea obligatoriamente "application/json".
     */
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String hello() {
        return "{\"status\":\"success\",\"message\":\"Hello, World!\"}";
    }
}