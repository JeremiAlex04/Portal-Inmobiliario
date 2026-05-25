package org.example.proyectoweb.dto;

public class EstadisticaDiariaDTO {
    private String fecha;
    private int numVistas;

    public EstadisticaDiariaDTO() {}

    public EstadisticaDiariaDTO(String fecha, int numVistas) {
        this.fecha = fecha;
        this.numVistas = numVistas;
    }

    public String getFecha() { return fecha; }
    public void setFecha(String fecha) { this.fecha = fecha; }

    public int getNumVistas() { return numVistas; }
    public void setNumVistas(int numVistas) { this.numVistas = numVistas; }
}
