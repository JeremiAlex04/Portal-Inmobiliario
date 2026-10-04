import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import PropiedadCard from '../components/PropiedadCard';
import { propiedades, getDistrito } from '../data/mockData';

export default function Home() {
  const navigate = useNavigate();
  const [search, setSearch] = useState({ query: '', operacion: '', tipo: '', distrito: '' });

  const handleSearch = (e) => {
    e.preventDefault();
    const params = new URLSearchParams();
    if (search.query) params.append('q', search.query);
    if (search.operacion) params.append('op', search.operacion);
    if (search.tipo) params.append('tipo', search.tipo);
    if (search.distrito) params.append('distrito', search.distrito);
    navigate(`/propiedades?${params.toString()}`);
  };

  const destacadas = propiedades.filter(p => p.destacada).slice(0, 3);
  const recientes = [...propiedades].sort((a, b) => b.id_propiedad - a.id_propiedad).slice(0, 4);

  return (
    <div className="page-home">
      
      {/* ── HERO PARALLAX ── */}
      <section className="hero">
        <div className="hero-bg-img"></div>
        <div className="hero-overlay"></div>
        <div className="hero-overlay2"></div>
        
        <div className="hero-content">
          <span className="hero-badge">InmobiX</span>
          <h1 className="hero-title">
            El lugar perfecto
          </h1>
          <span className="hero-title-accent"></span>
          <p className="hero-sub">
            Explora departamentos, casas y terrenos en todo el Perú. Propiedades verificadas con búsqueda inteligente y contacto directo.
          </p>

          <div className="hero-pills">
            <span className="hero-pill">Búsqueda inteligente</span>
            <span className="hero-pill">Propiedades verificadas</span>
            <span className="hero-pill">Contacto directo</span>
          </div>
        </div>

        <button className="hero-nav-btn hero-nav-prev"><svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2.5" d="M15 19l-7-7 7-7"></path></svg></button>
        <button className="hero-nav-btn hero-nav-next"><svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2.5" d="M9 5l7 7-7 7"></path></svg></button>

        <div className="hero-caption">
          <div className="hero-caption-cat">Propiedad Destacada</div>
          <div className="hero-caption-title">Villa de Lujo - La Planicie, La Molina</div>
        </div>

        <div className="hero-dots">
          <button className="hero-dot active"></button>
          <button className="hero-dot"></button>
          <button className="hero-dot"></button>
        </div>

        <div className="hero-progress" style={{ width: '45%' }}></div>
      </section>

      {/* ── BUSCADOR FLOTANTE ── */}
      <section className="search-bar-section">
        <div className="search-bar-floating">
          <form onSubmit={handleSearch}>
            <div className="search-grid">
              <div className="search-field">
                <label>¿Buscas una propiedad?</label>
                <input 
                  type="text" 
                  placeholder="Buscar por título, dirección o referencia..." 
                  className="search-input-orig"
                  value={search.query}
                  onChange={e => setSearch({...search, query: e.target.value})}
                />
              </div>
              <div className="search-field">
                <label>Operación</label>
                <select className="search-input-orig" value={search.operacion} onChange={e => setSearch({...search, operacion: e.target.value})}>
                  <option value="">Todas</option>
                  <option value="1">Venta</option>
                  <option value="2">Alquiler</option>
                  <option value="3">Anticresis</option>
                </select>
              </div>
              <div className="search-field">
                <label>Tipo</label>
                <select className="search-input-orig" value={search.tipo} onChange={e => setSearch({...search, tipo: e.target.value})}>
                  <option value="">Todos</option>
                  <option value="1">Casa</option>
                  <option value="2">Departamento</option>
                  <option value="3">Terreno</option>
                  <option value="4">Oficina</option>
                  <option value="5">Local Comercial</option>
                </select>
              </div>
              <div className="search-field">
                <label>Distrito</label>
                <select className="search-input-orig" value={search.distrito} onChange={e => setSearch({...search, distrito: e.target.value})}>
                  <option value="">Todos los distritos</option>
                  {Array.from(new Set(propiedades.map(p => p.id_distrito))).map(id => {
                    const dist = getDistrito(id);
                    return <option key={id} value={id}>{dist?.nombre}</option>;
                  })}
                </select>
              </div>
            </div>
            <div className="search-actions" style={{ justifyContent: 'center' }}>
              <button type="submit" className="btn-black btn-lg" style={{ minWidth: '200px' }}>
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="18" height="18" style={{ marginRight: '8px' }}><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
                Buscar
              </button>
            </div>
          </form>
        </div>
      </section>

      {/* ── PROPIEDADES DESTACADAS ── */}
      <section className="section-gray">
        <div className="section-inner">
          <div className="section-header">
            <div>
              <span className="section-eyebrow">Colección Premium</span>
              <h2 className="section-title">Propiedades Destacadas</h2>
              <p className="section-sub">Los mejores inmuebles seleccionados para ti, con características únicas y ubicaciones privilegiadas.</p>
            </div>
            <a href="/propiedades?destacada=true" className="btn-outline-dark hidden md:inline-flex">Ver todas</a>
          </div>
          <div className="cards-grid">
            {destacadas.map(p => <PropiedadCard key={p.id_propiedad} propiedad={p} />)}
          </div>
        </div>
      </section>

      {/* ── CARACTERÍSTICAS (EXPLORE) ── */}
      <section className="section-light">
        <div className="section-inner">
          <div className="section-header center">
            <span className="section-eyebrow">¿Por qué InmobiX?</span>
            <h2 className="section-title">El Portal Inmobiliario del Perú</h2>
          </div>
          
          <div className="features-grid">
            <div className="explore-card">
              <span className="explore-icon">🌎</span>
              <h3 className="explore-title">Integración UBIGEO</h3>
              <p className="explore-desc">Búsqueda exacta por departamento, provincia y distrito usando la codificación oficial del INEI para todo el territorio peruano.</p>
            </div>
            <div className="explore-card">
              <span className="explore-icon">💱</span>
              <h3 className="explore-title">Bimonetario PEN/USD</h3>
              <p className="explore-desc">Visualiza y compara precios en Soles y Dólares con conversión en tiempo real, adaptado al mercado local.</p>
            </div>
            <div className="explore-card">
              <span className="explore-icon">🏡</span>
              <h3 className="explore-title">Programas del Estado</h3>
              <p className="explore-desc">Filtra rápidamente propiedades que aplican al Nuevo Crédito Mivivienda o que cuentan con certificación Bono Verde.</p>
            </div>
            <div className="explore-card">
              <span className="explore-icon">📍</span>
              <h3 className="explore-title">Mapas Precisos</h3>
              <p className="explore-desc">Ubicación exacta registrada en coordenadas GPS y visualizada a través de mapas interactivos de alta precisión.</p>
            </div>
          </div>
        </div>
      </section>

      {/* ── ÚLTIMOS INGRESOS ── */}
      <section className="section-gray">
        <div className="section-inner">
          <div className="section-header">
            <div>
              <span className="section-eyebrow">Novedades</span>
              <h2 className="section-title">Últimos Ingresos</h2>
            </div>
            <a href="/propiedades" className="btn-outline-dark hidden md:inline-flex">Explorar catálogo</a>
          </div>
          <div className="cards-grid">
            {recientes.map(p => <PropiedadCard key={p.id_propiedad} propiedad={p} />)}
          </div>
        </div>
      </section>

      {/* ── CTA ── */}
      <section className="cta-section">
        <div className="cta-inner">
          <h2>¿Eres Agente Inmobiliario o Constructora?</h2>
          <p>Únete a la red de profesionales más confiable del Perú. Publica tus propiedades, obtén estadísticas detalladas y conecta con miles de compradores verificados cada mes.</p>
          <div className="cta-buttons">
            <a href="/planes" className="btn-primary" style={{ background: 'var(--amber-500)', color: 'var(--slate-950)' }}>Ver Planes y Precios</a>
            <a href="/contacto" className="btn-outline">Contactar con Ventas</a>
          </div>
        </div>
      </section>

    </div>
  );
}
