import { Link } from 'react-router-dom';

export default function Nosotros() {
  return (
    <div className="page-simple">
      <div className="page-header center">
        <span className="page-eyebrow">Sobre InmobiX</span>
        <h1>Revolucionando el Sector Inmobiliario</h1>
      </div>

      <div className="nosotros-mission">
        <div className="mission-text">
          <h2>Nuestra Misión</h2>
          <p>En InmobiX, nuestro objetivo es democratizar el acceso a la vivienda en el Perú a través de la tecnología. Conectamos a compradores y vendedores mediante una plataforma robusta, segura y fácil de usar, garantizando la transparencia en cada transacción.</p>
          <p>Nacimos de un proyecto universitario en la Universidad Tecnológica del Perú (UTP) y nos hemos convertido en el estándar técnico para portales inmobiliarios en la región.</p>
          
          <div className="tech-grid">
            <div className="tech-card">
              <span className="tech-icon">🏢</span>
              <strong>+5,000</strong>
              <span>Propiedades listadas</span>
            </div>
            <div className="tech-card">
              <span className="tech-icon">🤝</span>
              <strong>+1,200</strong>
              <span>Agentes verificados</span>
            </div>
          </div>
        </div>
        <div className="mission-img">
          <img src="https://images.unsplash.com/photo-1556761175-5973dc0f32d7?ixlib=rb-4.0.3&auto=format&fit=crop&w=1600&q=80" alt="Oficina de Inmobix" />
        </div>
      </div>

      <div>
        <h2 style={{fontFamily:'var(--font-title)', fontSize:'1.75rem', fontWeight:400, color:'var(--slate-900)', textAlign:'center', marginBottom:'1rem'}}>El Equipo Fundador</h2>
        <p style={{textAlign:'center', color:'var(--slate-500)', marginBottom:'2rem'}}>Desarrolladores del Sistema - UTP Lima Sur</p>
        
        <div className="team-grid">
          <div className="team-card">
            <div className="team-avatar-img"></div>
            <strong>JeremiAlex04</strong>
            <span className="team-rol">Líder Técnico</span>
            <span className="team-esp">Arquitectura Java EE</span>
          </div>
          <div className="team-card">
            <div className="team-avatar-img"></div>
            <strong>Desarrollador 2</strong>
            <span className="team-rol">Backend Developer</span>
            <span className="team-esp">JPA & BD MySQL</span>
          </div>
          <div className="team-card">
            <div className="team-avatar-img"></div>
            <strong>Desarrollador 3</strong>
            <span className="team-rol">Frontend JSF</span>
            <span className="team-esp">Tailwind & Facelets</span>
          </div>
          <div className="team-card">
            <div className="team-avatar-img"></div>
            <strong>Desarrollador 4</strong>
            <span className="team-rol">QA & Testing</span>
            <span className="team-esp">Validación de Datos</span>
          </div>
        </div>
      </div>
    </div>
  );
}
