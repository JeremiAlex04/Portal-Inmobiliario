import { Link } from 'react-router-dom';

export default function Footer() {
  return (
    <footer className="footer">
      <div className="footer-inner">
        <div className="footer-brand">
          <div className="footer-logo" style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
            <img src="/logo.png" alt="InmobiX Logo" style={{ height: '32px', filter: 'brightness(0) invert(1)' }} />
            InmobiX
          </div>
          <p>
            El portal inmobiliario líder en Perú con integración UBIGEO, conversión bimonetaria SBS y soporte para programas MiVivienda y Bono Verde.
          </p>
          <div className="footer-social">
            <a href="#">FB</a>
            <a href="#">IG</a>
            <a href="#">TW</a>
            <a href="#">IN</a>
          </div>
        </div>

        <div className="footer-col">
          <h4>Plataforma</h4>
          <Link to="/propiedades">Buscar Propiedades</Link>
          <Link to="/comparar">Comparar Inmuebles</Link>
          <Link to="/registro?rol=3">Publicar Propiedad</Link>
          <Link to="/planes">Planes para Agentes</Link>
        </div>

        <div className="footer-col">
          <h4>InmobiX</h4>
          <Link to="/nosotros">Sobre Nosotros</Link>
          <Link to="/contacto">Contacto</Link>
          <Link to="#">Términos y Condiciones</Link>
          <Link to="#">Política de Privacidad</Link>
        </div>

        <div className="footer-col">
          <h4>Contacto</h4>
          <p>Av. Pardo 1234, Miraflores, Lima - Perú</p>
          <p>+51 987 654 321</p>
          <p>hola@inmobix.pe</p>
        </div>
      </div>
      
      <div className="footer-bottom">
        <p>&copy; {new Date().getFullYear()} InmobiX Portal Inmobiliario. Todos los derechos reservados.</p>
        <p>Desarrollado para Universidad Tecnológica del Perú (UTP) - 2026</p>
      </div>
    </footer>
  );
}
