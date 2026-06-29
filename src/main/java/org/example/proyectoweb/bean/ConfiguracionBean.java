package org.example.proyectoweb.bean;

import jakarta.enterprise.context.SessionScoped;
import jakarta.inject.Named;
import java.io.Serializable;
import java.util.Locale;

@Named("configuracionBean")
@SessionScoped
public class ConfiguracionBean implements Serializable {
    private String idioma = "es";

    public Locale getLocale() {
        return new Locale(idioma);
    }

    public void cambiarAespanol() {
        this.idioma = "es";
    }

    public void cambiarAingles() {
        this.idioma = "en";
    }

    public String getIdioma() {
        return idioma;
    }

    public void setIdioma(String idioma) {
        this.idioma = idioma;
    }
}
