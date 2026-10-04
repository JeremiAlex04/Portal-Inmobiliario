import { useState } from 'react';

export default function Contacto() {
  const [enviado, setEnviado] = useState(false);

  const handleSubmit = (e) => {
    e.preventDefault();
    setEnviado(true);
  };

  return (
    <div className="page-simple">
      <div className="page-header center" style={{marginBottom:'2.5rem'}}>
        <span className="page-eyebrow">Atención al Cliente</span>
        <h1>Contacto InmobiX</h1>
        <p>¿Tienes alguna duda o consulta? Estamos aquí para ayudarte.</p>
      </div>

      <div className="contacto-layout">
        <div className="contacto-info">
          <div className="contacto-item">
            <div className="contacto-icon">📍</div>
            <div>
              <strong>Oficina Central</strong>
              <p>Av. Jose Pardo 1234, Piso 5<br/>Miraflores, Lima - Perú</p>
            </div>
          </div>
          <div className="contacto-item">
            <div className="contacto-icon">📞</div>
            <div>
              <strong>Teléfono</strong>
              <p>Atención al cliente: +51 (01) 555-0000<br/>Soporte técnico: +51 987 654 321</p>
            </div>
          </div>
          <div className="contacto-item">
            <div className="contacto-icon">✉️</div>
            <div>
              <strong>Correo Electrónico</strong>
              <p>soporte@inmobix.pe<br/>ventas@inmobix.pe</p>
            </div>
          </div>
          <div className="contacto-item">
            <div className="contacto-icon">🕒</div>
            <div>
              <strong>Horario de Atención</strong>
              <p>Lunes a Viernes: 9:00 AM - 6:00 PM<br/>Sábados: 9:00 AM - 1:00 PM</p>
            </div>
          </div>
        </div>

        <div className="contacto-form-wrap">
          {enviado ? (
            <div className="consulta-success">
              <span className="success-icon">✅</span>
              <h4>¡Mensaje Enviado!</h4>
              <p>Hemos recibido tu consulta correctamente. Un asesor de InmobiX se comunicará contigo a la brevedad posible.</p>
              <button className="btn-black" onClick={() => setEnviado(false)} style={{marginTop:'1rem'}}>Enviar otro mensaje</button>
            </div>
          ) : (
            <form className="contacto-form" onSubmit={handleSubmit}>
              <h3>Envíanos un mensaje</h3>
              <div className="form-group" style={{marginBottom:'0.85rem'}}>
                <label>Nombre Completo</label>
                <input type="text" required />
              </div>
              <div className="form-group" style={{marginBottom:'0.85rem'}}>
                <label>Correo Electrónico</label>
                <input type="email" required />
              </div>
              <div className="form-group" style={{marginBottom:'0.85rem'}}>
                <label>Asunto</label>
                <select className="filter-input" required>
                  <option value="">Selecciona un motivo</option>
                  <option value="1">Duda sobre planes</option>
                  <option value="2">Problema con mi cuenta</option>
                  <option value="3">Reportar un anuncio</option>
                  <option value="4">Otras consultas</option>
                </select>
              </div>
              <div className="form-group" style={{marginBottom:'1.25rem'}}>
                <label>Mensaje</label>
                <textarea rows="5" required></textarea>
              </div>
              <button type="submit" className="btn-black" style={{width:'100%', padding:'0.85rem'}}>Enviar Mensaje</button>
            </form>
          )}
        </div>
      </div>
    </div>
  );
}
