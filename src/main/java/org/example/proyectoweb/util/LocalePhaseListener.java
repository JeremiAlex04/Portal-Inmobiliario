package org.example.proyectoweb.util;

import jakarta.faces.context.FacesContext;
import jakarta.faces.event.PhaseEvent;
import jakarta.faces.event.PhaseId;
import jakarta.faces.event.PhaseListener;
import jakarta.servlet.http.HttpServletRequest;

import java.util.Locale;

public class LocalePhaseListener implements PhaseListener {

    @Override
    public void afterPhase(PhaseEvent event) {
        FacesContext fc = event.getFacesContext();
        HttpServletRequest req = (HttpServletRequest) fc.getExternalContext().getRequest();
        String lang = req.getParameter("lang");
        if (lang != null && (lang.equals("es") || lang.equals("en"))) {
            fc.getViewRoot().setLocale(new Locale(lang));
            req.getSession().setAttribute("idioma", lang);
        } else {
            // Restore from session if available
            Object sessionLang = req.getSession().getAttribute("idioma");
            if (sessionLang != null) {
                fc.getViewRoot().setLocale(new Locale((String) sessionLang));
            }
        }
    }

    @Override
    public void beforePhase(PhaseEvent event) {}

    @Override
    public PhaseId getPhaseId() {
        return PhaseId.RESTORE_VIEW;
    }
}
