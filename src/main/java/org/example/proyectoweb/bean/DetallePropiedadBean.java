package org.example.proyectoweb.bean;

import jakarta.enterprise.context.RequestScoped;
import jakarta.faces.context.FacesContext;
import jakarta.inject.Inject;
import jakarta.inject.Named;
import org.example.proyectoweb.dao.ConsultaDAO;
import org.example.proyectoweb.dao.EstadisticaDAO;
import org.example.proyectoweb.dao.GaleriaDAO;
import org.example.proyectoweb.dto.ConsultaDTO;
import org.example.proyectoweb.dto.EstadisticaDiariaDTO;
import org.example.proyectoweb.dto.PropiedadDTO;
import org.example.proyectoweb.dto.PropiedadFotoDTO;
import org.example.proyectoweb.facade.PropiedadFacade;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@Named("detallePropiedadBean")
@RequestScoped
public class DetallePropiedadBean {

    private PropiedadFacade propiedadFacade = new PropiedadFacade();
    private EstadisticaDAO estadisticaDAO = new EstadisticaDAO();
    private GaleriaDAO galeriaDAO = new GaleriaDAO();
    private ConsultaDAO consultaDAO = new ConsultaDAO();

    @Inject
    private AuthBean authBean;

    @Inject
    private FavoritoBean favoritoBean;

    private int id;
    private PropiedadDTO propiedad;
    private List<PropiedadFotoDTO> galeria;

    // Consulta form
    private String consultaNombre;
    private String consultaEmail;
    private String consultaTelefono;
    private String consultaMensaje;

    public void cargar() {
        if (id <= 0) return;

        // Incrementar vistas
        propiedadFacade.incrementarVistas(id);
        estadisticaDAO.registrarVistaDiaria(id);

        propiedad = propiedadFacade.obtenerPropiedad(id);
        if (propiedad != null && authBean.isLogueado()) {
            propiedad.setFavorito(favoritoBean.esFavorito(id));
        }
        galeria = galeriaDAO.obtenerFotos(id);
    }

    private org.example.proyectoweb.dao.WhatsAppDAO whatsAppDAO = new org.example.proyectoweb.dao.WhatsAppDAO();

    public String enviarConsulta() {
        ConsultaDTO c = new ConsultaDTO();
        c.setIdPropiedad(id);
        c.setNombre(consultaNombre);
        c.setEmail(consultaEmail);
        c.setTelefono(consultaTelefono);
        c.setMensaje(consultaMensaje);
        if (authBean.isLogueado()) c.setIdUsuario(authBean.getUsuario().getIdUsuario());

        boolean ok = consultaDAO.registrarConsulta(c);
        if (ok) {
            FacesContext.getCurrentInstance().getExternalContext().getFlash().put("consultaEnviada", true);
        } else {
            FacesContext.getCurrentInstance().getExternalContext().getFlash().put("errorConsulta", true);
        }
        return "/detalle_propiedad.xhtml?id=" + id + "&faces-redirect=true";
    }

    public String contactarWhatsApp() {
        Integer idUsuario = authBean.isLogueado() ? authBean.getUsuario().getIdUsuario() : null;
        whatsAppDAO.registrarContacto(id, idUsuario);

        String telefono = propiedad.getAgenteTelefono();
        if (telefono != null) {
            telefono = telefono.replaceAll("[^0-9]", "");
        } else {
            telefono = "";
        }

        if (!telefono.startsWith("51") && telefono.length() == 9) {
            telefono = "51" + telefono;
        }

        String mensaje = "Hola, estoy interesado en tu propiedad \"" + propiedad.getTitulo() + "\" que vi en InmobiX.";
        String urlEncodedMensaje = URLEncoder.encode(mensaje, java.nio.charset.StandardCharsets.UTF_8);
        String whatsappUrl = "https://wa.me/" + telefono + "?text=" + urlEncodedMensaje;

        try {
            FacesContext.getCurrentInstance().getExternalContext().redirect(whatsappUrl);
            FacesContext.getCurrentInstance().responseComplete();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Chart.js data helpers
    public String getLabelsJson() {
        List<EstadisticaDiariaDTO> stats = estadisticaDAO.obtenerVistas30Dias(id);
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < stats.size(); i++) {
            if (i > 0) sb.append(",");
            sb.append("\"").append(stats.get(i).getFecha()).append("\"");
        }
        sb.append("]");
        return sb.toString();
    }

    public String getDataJson() {
        List<EstadisticaDiariaDTO> stats = estadisticaDAO.obtenerVistas30Dias(id);
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < stats.size(); i++) {
            if (i > 0) sb.append(",");
            sb.append(stats.get(i).getNumVistas());
        }
        sb.append("]");
        return sb.toString();
    }

    public int getTotalVistas() { return estadisticaDAO.obtenerTotalVistas(id); }

    public boolean isTieneCoordenadas() {
        return propiedad != null && propiedad.getLatitud() != null && propiedad.getLongitud() != null;
    }

    public String getTextoUbicacion() {
        if (propiedad == null) return "";
        StringBuilder sb = new StringBuilder();
        if (propiedad.getDireccion() != null && !propiedad.getDireccion().trim().isEmpty()) {
            sb.append(propiedad.getDireccion().trim());
        }
        if (propiedad.getDistrito() != null && !propiedad.getDistrito().trim().isEmpty()) {
            if (sb.length() > 0) sb.append(", ");
            sb.append(propiedad.getDistrito().trim());
        }
        if (propiedad.getProvincia() != null && !propiedad.getProvincia().trim().isEmpty()) {
            if (sb.length() > 0) sb.append(", ");
            sb.append(propiedad.getProvincia().trim());
        }
        if (propiedad.getDepartamento() != null && !propiedad.getDepartamento().trim().isEmpty()) {
            if (sb.length() > 0) sb.append(", ");
            sb.append(propiedad.getDepartamento().trim());
        }
        return sb.toString();
    }

    public String getGoogleMapsUrl() {
        String ubicacion = getTextoUbicacion();
        if (ubicacion == null || ubicacion.isEmpty()) return "https://www.google.com/maps";
        return "https://www.google.com/maps/search/?api=1&query=" +
                URLEncoder.encode(ubicacion, StandardCharsets.UTF_8);
    }

    public String getOpenStreetMapEmbedUrl() {
        if (!isTieneCoordenadas()) return null;
        double lat = propiedad.getLatitud().doubleValue();
        double lng = propiedad.getLongitud().doubleValue();

        // bbox pequeño para un encuadre cercano a la propiedad
        double delta = 0.005d;
        double minLon = lng - delta;
        double minLat = lat - delta;
        double maxLon = lng + delta;
        double maxLat = lat + delta;

        return "https://www.openstreetmap.org/export/embed.html?layer=mapnik"
                + "&bbox=" + minLon + "%2C" + minLat + "%2C" + maxLon + "%2C" + maxLat
                + "&marker=" + lat + "%2C" + lng;
    }

    public String getOpenStreetMapDetalleUrl() {
        if (!isTieneCoordenadas()) return "https://www.openstreetmap.org";
        String lat = propiedad.getLatitud().toPlainString();
        String lng = propiedad.getLongitud().toPlainString();
        return "https://www.openstreetmap.org/?mlat=" + lat + "&mlon=" + lng + "#map=16/" + lat + "/" + lng;
    }

    // Getters y Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public PropiedadDTO getPropiedad() { return propiedad; }

    public List<PropiedadFotoDTO> getGaleria() { return galeria; }

    public String getConsultaNombre() { return consultaNombre; }
    public void setConsultaNombre(String consultaNombre) { this.consultaNombre = consultaNombre; }

    public String getConsultaEmail() { return consultaEmail; }
    public void setConsultaEmail(String consultaEmail) { this.consultaEmail = consultaEmail; }

    public String getConsultaTelefono() { return consultaTelefono; }
    public void setConsultaTelefono(String consultaTelefono) { this.consultaTelefono = consultaTelefono; }

    public String getConsultaMensaje() { return consultaMensaje; }
    public void setConsultaMensaje(String consultaMensaje) { this.consultaMensaje = consultaMensaje; }
}
