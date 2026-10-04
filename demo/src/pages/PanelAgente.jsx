import { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { propiedades } from '../data/mockData';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';

export default function PanelAgente() {
  const { user, logout } = useAuth();
  const navigate = useNavigate();
  const [activeTab, setActiveTab] = useState('dashboard');

  if (!user || user.id_rol !== 3) {
    return <div style={{padding:'2rem'}}>Acceso denegado.</div>;
  }

  // Filtrar mis propiedades
  const misPropiedades = propiedades.filter(p => p.id_usuario_agente === user.id_usuario);
  const activas = misPropiedades.filter(p => p.estado === 'ACTIVO').length;
  const enRevision = misPropiedades.filter(p => p.estado === 'REVISIÓN').length;

  const dataVistas = [
    { name: 'Lun', vistas: 40 },
    { name: 'Mar', vistas: 30 },
    { name: 'Mié', vistas: 55 },
    { name: 'Jue', vistas: 45 },
    { name: 'Vie', vistas: 70 },
    { name: 'Sáb', vistas: 90 },
    { name: 'Dom', vistas: 110 },
  ];

  return (
    <div className="page-panel">
      {/* Sidebar Dark */}
      <aside className="panel-sidebar">
        <div className="panel-sidebar-logo">
          <div className="panel-sidebar-logo-text" style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
            <img src="/logo.png" alt="InmobiX Logo" style={{ height: '24px', filter: 'brightness(0) invert(1)' }} />
            InmobiX Panel
          </div>
          <div className="panel-sidebar-logo-sub">Consola Agente</div>
        </div>
        
        <nav className="panel-nav">
          <button className={`panel-nav-item ${activeTab === 'dashboard' ? 'active' : ''}`} onClick={() => setActiveTab('dashboard')}>
            <svg fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>
            Dashboard
          </button>
          <button className={`panel-nav-item ${activeTab === 'propiedades' ? 'active' : ''}`} onClick={() => setActiveTab('propiedades')}>
            <svg fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"></path></svg>
            Mis Propiedades
          </button>
          <button className={`panel-nav-item ${activeTab === 'consultas' ? 'active' : ''}`} onClick={() => setActiveTab('consultas')}>
            <svg fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z"></path></svg>
            Consultas <span className="badge">3</span>
          </button>
          <button className={`panel-nav-item ${activeTab === 'suscripcion' ? 'active' : ''}`} onClick={() => setActiveTab('suscripcion')}>
            <svg fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"></path></svg>
            Mi Suscripción
          </button>
        </nav>

        <div style={{ marginTop: 'auto' }}>
          <div className="panel-user-bottom">
            <div className="panel-avatar-initials">{user.nombres.charAt(0)}{user.apellidos.charAt(0)}</div>
            <div>
              <div className="panel-user-name">{user.nombres} {user.apellidos}</div>
              <div className="panel-user-role">Agente Inmobiliario</div>
            </div>
          </div>
          <div className="panel-bottom-btns">
            <Link to="/" className="panel-btn-small panel-btn-portal">Ir al Portal</Link>
            <button onClick={() => { logout(); navigate('/'); }} className="panel-btn-small panel-btn-salir">Salir</button>
          </div>
        </div>
      </aside>

      {/* Contenido */}
      <main className="panel-main">
        <div className="panel-content">
          
          <div className="panel-welcome">
            <div className="panel-welcome-avatar">{user.nombres.charAt(0)}</div>
            <div>
              <h2>Hola, {user.nombres}</h2>
              <div className="panel-welcome-badge">Plan Premium Activo</div>
            </div>
          </div>

          {activeTab === 'dashboard' && (
            <>
              <div className="kpi-grid">
                <div className="kpi-card">
                  <div>
                    <div className="kpi-label">Propiedades</div>
                    <div className="kpi-value">{misPropiedades.length}</div>
                  </div>
                  <div className="kpi-icon-wrap"><svg fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg></div>
                </div>
                <div className="kpi-card kpi-green">
                  <div>
                    <div className="kpi-label">Activas</div>
                    <div className="kpi-value">{activas}</div>
                  </div>
                  <div className="kpi-icon-wrap"><svg fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg></div>
                </div>
                <div className="kpi-card kpi-amber">
                  <div>
                    <div className="kpi-label">En Revisión</div>
                    <div className="kpi-value">{enRevision}</div>
                  </div>
                  <div className="kpi-icon-wrap"><svg fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg></div>
                </div>
                <div className="kpi-card">
                  <div>
                    <div className="kpi-label">Nuevas Consultas</div>
                    <div className="kpi-value">3</div>
                  </div>
                  <div className="kpi-icon-wrap"><svg fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z"></path></svg></div>
                </div>
              </div>

              <div className="charts-grid">
                <div className="chart-card">
                  <h4>Vistas de perfil (últimos 7 días)</h4>
                  <div style={{ height: '250px' }}>
                    <ResponsiveContainer width="100%" height="100%">
                      <LineChart data={dataVistas}>
                        <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="var(--slate-200)" />
                        <XAxis dataKey="name" axisLine={false} tickLine={false} tick={{fill:'var(--slate-400)', fontSize:12}} />
                        <YAxis axisLine={false} tickLine={false} tick={{fill:'var(--slate-400)', fontSize:12}} />
                        <Tooltip contentStyle={{ borderRadius:'8px', border:'1px solid var(--slate-200)' }} />
                        <Line type="monotone" dataKey="vistas" stroke="var(--slate-900)" strokeWidth={3} dot={{r:4, fill:'var(--amber-500)', strokeWidth:0}} activeDot={{r:6}} />
                      </LineChart>
                    </ResponsiveContainer>
                  </div>
                </div>
              </div>
            </>
          )}

          {activeTab === 'propiedades' && (
            <>
              <div className="panel-section-header">
                <h3 className="panel-section-title" style={{marginBottom:0}}>Mis Propiedades</h3>
                <button className="btn-black btn-sm">+ Nueva Publicación</button>
              </div>
              <div style={{ borderRadius: 'var(--radius-xl)', overflow: 'hidden', border: '1px solid var(--slate-200)' }}>
                <table className="panel-table">
                  <thead>
                    <tr>
                      <th>Propiedad</th>
                      <th>Estado</th>
                      <th>Precio (USD)</th>
                      <th>Acciones</th>
                    </tr>
                  </thead>
                  <tbody>
                    {misPropiedades.map(p => (
                      <tr key={p.id_propiedad}>
                        <td>
                          <div className="td-tipo">{p.id_tipo_inmueble === 1 ? 'Casa' : 'Departamento'}</div>
                          <div className="td-title" title={p.titulo}>{p.titulo}</div>
                        </td>
                        <td>
                          <span className={`status-badge ${p.estado === 'ACTIVO' ? 'status-activo' : 'status-pausado'}`}>
                            {p.estado === 'ACTIVO' ? 'Activo' : 'En Revisión'}
                          </span>
                        </td>
                        <td style={{fontWeight:600}}>${p.precio.toLocaleString()}</td>
                        <td>
                          <Link to={`/propiedad/${p.id_propiedad}`} className="btn-outline-dark" style={{padding:'0.2rem 0.6rem', fontSize:'0.75rem'}}>Ver</Link>
                        </td>
                      </tr>
                    ))}
                    {misPropiedades.length === 0 && (
                      <tr><td colSpan="4" style={{textAlign:'center', padding:'2rem'}}>No tienes propiedades publicadas.</td></tr>
                    )}
                  </tbody>
                </table>
              </div>
            </>
          )}

          {activeTab === 'consultas' && (
            <>
              <h3 className="panel-section-title">Consultas Recibidas</h3>
              <div className="consultas-list">
                <div className="consulta-item estado-pendiente">
                  <div className="consulta-meta">
                    <strong>Carlos Mendez</strong>
                    <span className="consulta-badge pendiente">Nueva</span>
                    <span className="consulta-fecha">Hace 2 horas</span>
                  </div>
                  <div className="consulta-prop">Sobre: "Departamento de lujo frente al mar en Miraflores"</div>
                  <div className="consulta-msg">Hola, me gustaría agendar una visita para este fin de semana. ¿Está disponible?</div>
                  <div className="consulta-contact">
                    <a href="mailto:carlos@gmail.com">carlos@gmail.com</a>
                    <span>|</span>
                    <a href="tel:+51987654321">+51 987 654 321</a>
                  </div>
                </div>
                <div className="consulta-item estado-leida">
                  <div className="consulta-meta">
                    <strong>Ana Souza</strong>
                    <span className="consulta-badge leida">Leída</span>
                    <span className="consulta-fecha">Ayer</span>
                  </div>
                  <div className="consulta-prop">Sobre: "Hermosa Casa de 3 Pisos en La Molina"</div>
                  <div className="consulta-msg">Quisiera saber si el precio es negociable y si aceptan mascotas.</div>
                  <div className="consulta-contact">
                    <a href="mailto:ana@gmail.com">ana@gmail.com</a>
                  </div>
                </div>
              </div>
            </>
          )}

          {activeTab === 'suscripcion' && (
            <>
              <h3 className="panel-section-title">Mi Suscripción</h3>
              <div className="suscripcion-card">
                <div className="plan-badge-big plan-premium">Plan Premium</div>
                
                <div className="sus-details">
                  <div className="sus-row">
                    <span>Estado</span>
                    <strong style={{color:'var(--emerald-500)'}}>Activo</strong>
                  </div>
                  <div className="sus-row">
                    <span>Renovación automática</span>
                    <strong>15 Octubre, 2026</strong>
                  </div>
                  <div className="sus-row">
                    <span>Límite de publicaciones</span>
                    <strong>50 / Ilimitadas</strong>
                  </div>
                </div>

                <div className="sus-price">US$ 49.00 <span style={{fontSize:'0.875rem', color:'var(--slate-500)', fontWeight:400}}>/mes</span></div>
                
                <div style={{display:'flex', gap:'0.75rem', marginTop:'1.5rem'}}>
                  <button className="btn-black" style={{flex:1}}>Mejorar Plan</button>
                  <button className="btn-outline-dark" style={{flex:1}}>Cancelar</button>
                </div>
              </div>
            </>
          )}

        </div>
      </main>
    </div>
  );
}
