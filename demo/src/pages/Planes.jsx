import { Link } from 'react-router-dom';

export default function Planes() {
  return (
    <div className="page-simple">
      <div className="page-header center">
        <span className="page-eyebrow">Para Agentes y Constructoras</span>
        <h1>Planes de Publicación</h1>
        <p>Elige el plan que mejor se adapte a tus necesidades inmobiliarias.</p>
      </div>

      <div className="planes-grid">
        
        {/* Plan Gratuito */}
        <div className="plan-card">
          <div className="plan-nombre">Básico / Gratuito</div>
          <div className="plan-precio">
            <span className="plan-gratis">Gratis</span>
          </div>
          <p className="plan-desc">Ideal para agentes independientes que están empezando.</p>
          
          <ul className="plan-features">
            <li><span className="check">✓</span> 3 publicaciones activas</li>
            <li><span className="check">✓</span> 5 fotos por inmueble</li>
            <li><span className="check">✓</span> Posicionamiento estándar</li>
            <li><span className="check">✓</span> Soporte por email</li>
          </ul>

          <div className="plan-specs">
            <div><span>Duración:</span> <strong>30 días</strong></div>
            <div><span>Estadísticas:</span> <strong>Básicas</strong></div>
          </div>
          
          <Link to="/registro?rol=3" className="btn-outline-dark" style={{textAlign:'center'}}>Crear cuenta gratis</Link>
        </div>

        {/* Plan Premium (Destacado) */}
        <div className="plan-card plan-card-premium">
          <span className="plan-popular-badge">Más Elegido</span>
          <div className="plan-nombre" style={{color:'var(--amber-600)'}}>Premium Agente</div>
          <div className="plan-precio">
            <span className="plan-monto">US$ 49</span>
            <span className="plan-periodo">/ mes</span>
          </div>
          <p className="plan-desc">Para agentes consolidados que necesitan mayor alcance.</p>
          
          <ul className="plan-features">
            <li><span className="check">✓</span> 50 publicaciones activas</li>
            <li><span className="check">✓</span> 20 fotos por inmueble</li>
            <li><span className="check">✓</span> Posicionamiento destacado</li>
            <li><span className="check">✓</span> 3 propiedades en Hero principal</li>
            <li><span className="check">✓</span> Soporte prioritario WhatsApp</li>
          </ul>

          <div className="plan-specs">
            <div><span>Duración:</span> <strong>30 días</strong></div>
            <div><span>Estadísticas:</span> <strong>Avanzadas</strong></div>
          </div>
          
          <Link to="/registro?rol=3" className="btn-black" style={{textAlign:'center'}}>Empezar ahora</Link>
        </div>

        {/* Plan Constructora */}
        <div className="plan-card">
          <div className="plan-nombre">Inmobiliaria / Constructora</div>
          <div className="plan-precio">
            <span className="plan-monto">US$ 149</span>
            <span className="plan-periodo">/ mes</span>
          </div>
          <p className="plan-desc">Para empresas con múltiples proyectos e inventario amplio.</p>
          
          <ul className="plan-features">
            <li><span className="check">✓</span> Publicaciones ilimitadas</li>
            <li><span className="check">✓</span> Fotos y videos ilimitados</li>
            <li><span className="check">✓</span> Perfil de empresa verificado</li>
            <li><span className="check">✓</span> Panel multi-agente (5 usuarios)</li>
            <li><span className="check">✓</span> Soporte telefónico 24/7</li>
          </ul>

          <div className="plan-specs">
            <div><span>Duración:</span> <strong>30 días</strong></div>
            <div><span>Estadísticas:</span> <strong>Exportables</strong></div>
          </div>
          
          <Link to="/registro?rol=4" className="btn-outline-dark" style={{textAlign:'center'}}>Contactar ventas</Link>
        </div>

      </div>

      <div className="planes-faq">
        <h2 style={{textAlign:'center'}}>Preguntas Frecuentes</h2>
        <div className="faq-list mt-8">
          <details className="faq-item">
            <summary>¿Qué métodos de pago aceptan? <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="16" height="16"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M19 9l-7 7-7-7"></path></svg></summary>
            <p>Aceptamos todas las tarjetas de crédito y débito (Visa, Mastercard, Amex), transferencias bancarias a cuentas en soles y dólares, y pagos a través de Yape o Plin para planes básicos.</p>
          </details>
          <details className="faq-item">
            <summary>¿Puedo cambiar de plan en cualquier momento? <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="16" height="16"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M19 9l-7 7-7-7"></path></svg></summary>
            <p>Sí, puedes hacer un upgrade (mejorar tu plan) o downgrade en cualquier momento desde tu panel de agente. Los cambios se aplicarán en el siguiente ciclo de facturación.</p>
          </details>
          <details className="faq-item">
            <summary>¿Las publicaciones caducan? <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="16" height="16"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M19 9l-7 7-7-7"></path></svg></summary>
            <p>En el plan gratuito, las publicaciones se desactivan automáticamente después de 30 días si no se renuevan manualmente. En los planes de pago, las publicaciones permanecen activas mientras tu suscripción esté vigente.</p>
          </details>
        </div>
      </div>
    </div>
  );
}
