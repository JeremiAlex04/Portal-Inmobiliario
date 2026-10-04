import { useParams, Link } from 'react-router-dom';
import { useState } from 'react';
import { MapContainer, TileLayer, Marker, Popup } from 'react-leaflet';
import 'leaflet/dist/leaflet.css';
import L from 'leaflet';
import { useCompare } from '../context/CompareContext';
import { propiedades, getTipo, getOperacion, getDistrito, usuarios } from '../data/mockData';

// Fix icono leaflet
delete L.Icon.Default.prototype._getIconUrl;
L.Icon.Default.mergeOptions({
  iconRetinaUrl: 'https://unpkg.com/leaflet@1.7.1/dist/images/marker-icon-2x.png',
  iconUrl: 'https://unpkg.com/leaflet@1.7.1/dist/images/marker-icon.png',
  shadowUrl: 'https://unpkg.com/leaflet@1.7.1/dist/images/marker-shadow.png',
});

export default function DetallePropiedad() {
  const { id } = useParams();
  const { toggleCompare, compareList } = useCompare();
  
  const propiedad = propiedades.find(p => p.id_propiedad === Number(id));
  const [moneda, setMoneda] = useState('USD'); // USD o PEN
  const [imgMain, setImgMain] = useState(0);

  if (!propiedad) return (
    <div className="empty-state" style={{ minHeight: '60vh', justifyContent: 'center' }}>
      <span className="empty-icon">🏚️</span>
      <h3>Propiedad no encontrada</h3>
      <Link to="/propiedades" className="btn-black">Volver al Explorador</Link>
    </div>
  );

  const operacion = getOperacion(propiedad.id_operacion);
  const tipo = getTipo(propiedad.id_tipo_inmueble);
  const distrito = getDistrito(propiedad.id_distrito);
  const agente = usuarios.find(u => u.id_usuario === propiedad.id_usuario_agente);

  const isUSD = propiedad.moneda_base === 'USD';
  const tc = 3.78;
  const precioUSD = isUSD ? propiedad.precio : propiedad.precio / tc;
  const precioPEN = isUSD ? propiedad.precio * tc : propiedad.precio;

  const currentPrecio = moneda === 'USD' ? precioUSD : precioPEN;
  const currentSymbol = moneda === 'USD' ? 'US$' : 'S/';

  const fotos = [propiedad.foto_principal, ...(propiedad.fotos || [])];

  return (
    <div className="page-detalle">
      <Link to="/propiedades" className="back-link">
        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2.5" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path></svg>
        Volver a la lista de propiedades
      </Link>

      <div className="detalle-grid">
        
        {/* Columna Izquierda: Galería e Info */}
        <div className="detalle-info-col">
          
          <div className="gallery-card">
            <div className="gallery-main-wrap">
              <span className="gallery-op-badge">{operacion?.nombre}</span>
              <div className="gallery-badges">
                {propiedad.bono_mi_vivienda && <span className="badge-mivivienda">MiVivienda</span>}
                {propiedad.bono_verde && <span className="badge-verde">Bono Verde</span>}
              </div>
              <img src={fotos[imgMain]} alt="Inmueble" className="gallery-main-img" />
              
              {fotos.length > 1 && (
                <>
                  <button className="gallery-nav-btn gallery-nav-prev" onClick={() => setImgMain(i => i === 0 ? fotos.length - 1 : i - 1)}>
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2.5" d="M15 19l-7-7 7-7"></path></svg>
                  </button>
                  <button className="gallery-nav-btn gallery-nav-next" onClick={() => setImgMain(i => i === fotos.length - 1 ? 0 : i + 1)}>
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2.5" d="M9 5l7 7-7 7"></path></svg>
                  </button>
                </>
              )}
            </div>
            
            {fotos.length > 1 && (
              <div className="gallery-thumbs">
                {fotos.map((url, i) => (
                  <img 
                    key={i} src={url} alt={`thumb-${i}`} 
                    className={`gallery-thumb ${i === imgMain ? 'active' : ''}`}
                    onClick={() => setImgMain(i)}
                  />
                ))}
              </div>
            )}
          </div>

          <div className="detail-info">
            <div className="detail-tipo">{tipo?.nombre} en {operacion?.nombre}</div>
            <h1 className="detail-title">{propiedad.titulo}</h1>
            <div className="comparar-breadcrumb" style={{ marginBottom: '1.5rem' }}>
              📍 {propiedad.direccion}, <strong>{distrito?.nombre}</strong>
            </div>

            <div className="detail-precio-row">
              <div>
                <div className="price-toggle">
                  <button className={`price-toggle-btn ${moneda === 'USD' ? 'active' : ''}`} onClick={() => setMoneda('USD')}>USD</button>
                  <button className={`price-toggle-btn ${moneda === 'PEN' ? 'active' : ''}`} onClick={() => setMoneda('PEN')}>PEN</button>
                </div>
                <div className="detail-precio-main">
                  {currentSymbol} {currentPrecio.toLocaleString(undefined, { maximumFractionDigits: 0 })}
                </div>
                <div className="detail-precio-alt">
                  Eq. {moneda === 'USD' ? 'S/' : 'US$'} {(moneda === 'USD' ? precioPEN : precioUSD).toLocaleString(undefined, { maximumFractionDigits: 0 })}
                  <div className="detail-precio-tc">T.C. {tc}</div>
                </div>
              </div>
              <button 
                className={`btn-outline-dark ${compareList.includes(propiedad.id_propiedad) ? 'bg-slate-950 text-white' : ''}`}
                onClick={() => toggleCompare(propiedad.id_propiedad)}
                style={{ marginLeft: 'auto' }}
              >
                {compareList.includes(propiedad.id_propiedad) ? '✓ En Comparador' : '+ Comparar'}
              </button>
            </div>

            <h3 className="detail-desc-title">Ficha Técnica</h3>
            <table className="ficha-table">
              <tbody>
                <tr><td>Área Total</td><td>{propiedad.area_total_m2} m²</td></tr>
                <tr><td>Dormitorios</td><td>{propiedad.num_dormitorios}</td></tr>
                <tr><td>Baños</td><td>{propiedad.num_banos}</td></tr>
                <tr><td>Antigüedad</td><td>{propiedad.anio_construccion ? `${new Date().getFullYear() - propiedad.anio_construccion} años` : 'A estrenar'}</td></tr>
                <tr><td>Cocheras</td><td>{propiedad.num_cocheras}</td></tr>
              </tbody>
            </table>

            <h3 className="detail-desc-title">Descripción</h3>
            <div className="detail-desc-text">
              {propiedad.descripcion.split('\n').map((parrafo, i) => (
                <p key={i} style={{ marginBottom: '1rem' }}>{parrafo}</p>
              ))}
            </div>
          </div>

          <div className="map-card">
            <h3>Ubicación</h3>
            <div className="mapa-container" style={{ height: '350px' }}>
              <MapContainer center={[propiedad.latitud, propiedad.longitud]} zoom={15} style={{ height: '100%', width: '100%' }}>
                <TileLayer url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png" attribution="&copy; OpenStreetMap" />
                <Marker position={[propiedad.latitud, propiedad.longitud]}>
                  <Popup>{propiedad.direccion}</Popup>
                </Marker>
              </MapContainer>
            </div>
            <div className="mapa-footer">
              <span>Ubicación exacta registrada en GPS</span>
              <a href="#">Abrir mapa completo</a>
            </div>
          </div>

        </div>

        {/* Columna Derecha: Sidebar Agente & Formulario */}
        <div className="detalle-sidebar">
          
          <div className="agente-card">
            <div className="agente-label">Agente Responsable</div>
            {agente ? (
              <>
                <div className="agente-info">
                  <div className="agente-initials">
                    {agente.nombres.charAt(0)}{agente.apellidos.charAt(0)}
                  </div>
                  <div>
                    <span className="agente-name">{agente.nombres} {agente.apellidos}</span>
                    <span className="agente-verified">✓ Agente Verificado</span>
                  </div>
                </div>
                <div className="agente-contact-row">
                  <svg fill="none" viewBox="0 0 24 24" strokeWidth="2"><path strokeLinecap="round" strokeLinejoin="round" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"></path></svg>
                  {agente.telefono}
                </div>
                <div className="agente-contact-row">
                  <svg fill="none" viewBox="0 0 24 24" strokeWidth="2"><path strokeLinecap="round" strokeLinejoin="round" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path></svg>
                  {agente.correo}
                </div>
                <button className="btn-whatsapp mt-4">
                  WhatsApp
                </button>
              </>
            ) : (
              <p>Información no disponible.</p>
            )}
          </div>

          <div className="consulta-card">
            <div className="consulta-label">Consultar por esta propiedad</div>
            <form className="contacto-form" onSubmit={(e) => { e.preventDefault(); alert('Consulta enviada (demo)'); }}>
              <div className="consulta-field">
                <label>Tu Nombre</label>
                <input type="text" required />
              </div>
              <div className="consulta-field">
                <label>Tu Email</label>
                <input type="email" required />
              </div>
              <div className="consulta-field">
                <label>Tu Teléfono</label>
                <input type="tel" />
              </div>
              <div className="consulta-field">
                <label>Mensaje</label>
                <textarea rows="4" required defaultValue={`Hola, me interesa la propiedad "${propiedad.titulo}". ¿Podrían brindarme más información?`}></textarea>
              </div>
              <button type="submit" className="btn-enviar">Enviar consulta</button>
              <button type="button" className="btn-favorito">❤️ Agregar a Favoritos</button>
            </form>
          </div>

        </div>

      </div>
    </div>
  );
}
