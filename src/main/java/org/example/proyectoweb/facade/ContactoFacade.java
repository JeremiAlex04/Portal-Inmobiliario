package org.example.proyectoweb.facade;

import org.example.proyectoweb.dao.ContactoDAO;
import org.example.proyectoweb.dto.ContactoDTO;

public class ContactoFacade {
    private ContactoDAO contactoDAO;

    public ContactoFacade() {
        this.contactoDAO = new ContactoDAO();
    }

    public boolean guardarMensaje(ContactoDTO c) {
        return contactoDAO.guardarMensaje(c);
    }
}
