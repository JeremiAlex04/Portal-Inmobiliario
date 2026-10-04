import { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { usuarios, propiedades } from '../data/mockData';

export default function PanelAdmin() {
  const { user, logout } = useAuth();
  const navigate = useNavigate();
  const [activeTab, setActiveTab] = useState('dashboard');

  if (!user || user.id_rol !== 5) {
    return <div style={{padding:'2rem'}}>Acceso denegado. Se requieren privilegios de Administrador.</div>;
  }

  const propsActivas = propiedades.filter(p => p.estado === 'ACTIVO').length;
  const propsRevision = propiedades.filter(p => p.estado === 'REVISIÓN').length;

  return (
    <div className="page-panel">
      {/* Sidebar Dark */}
      <aside className="panel-sidebar">
        <div className="panel-sidebar-logo">
          <div className="panel-sidebar-logo-text" style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
            <img src="/logo.png" alt="InmobiX Logo" style={{ height: '24px', filter: 'brightness(0) invert(1)' }} />
            InmobiX Admin
          </div>
          <div className="panel-sidebar-logo-sub" style={{color:'var(--red-500)'}}>Consola Sistema</div>
        </div>
        
        <nav className="panel-nav">
          <button className={`panel-nav-item ${activeTab === 'dashboard' ? 'active' : ''}`} onClick={() => setActiveTab('dashboard')} style={activeTab==='dashboard'?{background:'var(--slate-800)', color:'var(--white)'}:{}}>
            <svg fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>
            Dashboard
          </button>
          <button className={`panel-nav-item ${activeTab === 'usuarios' ? 'active' : ''}`} onClick={() => setActiveTab('usuarios')} style={activeTab==='usuarios'?{background:'var(--slate-800)', color:'var(--white)'}:{}}>
            <svg fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"></path></svg>
            Gestión Usuarios
          </button>
          <button className={`panel-nav-item ${activeTab === 'propiedades' ? 'active' : ''}`} onClick={() => setActiveTab('propiedades')} style={activeTab==='propiedades'?{background:'var(--slate-800)', color:'var(--white)'}:{}}>
            <svg fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"></path></svg>
            Auditoría Inmuebles <span className="badge">{propsRevision}</span>
          </button>
          <button className={`panel-nav-item ${activeTab === 'logs' ? 'active' : ''}`} onClick={() => setActiveTab('logs')} style={activeTab==='logs'?{background:'var(--slate-800)', color:'var(--white)'}:{}}>
            <svg fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path></svg>
            Logs del Sistema
          </button>
        </nav>

        <div style={{ marginTop: 'auto' }}>
          <div className="panel-user-bottom">
            <div className="panel-avatar-initials" style={{background:'var(--red-500)'}}>{user.nombres.charAt(0)}{user.apellidos.charAt(0)}</div>
            <div>
              <div className="panel-user-name">{user.nombres} {user.apellidos}</div>
              <div className="panel-user-role" style={{color:'var(--slate-400)'}}>Super Administrador</div>
            </div>
          </div>
          <div className="panel-bottom-btns">
            <Link to="/" className="panel-btn-small panel-btn-portal">Ir al Portal</Link>
            <button onClick={() => { logout(); navigate('/'); }} className="panel-btn-small panel-btn-salir">Salir</button>
          </div>
        </div>
      </aside>

      <main className="panel-main">
        <div className="panel-content">
          
          {activeTab === 'dashboard' && (
            <>
              <h2 className="panel-section-title" style={{fontFamily:'var(--font-body)', fontWeight:700}}>Visión General del Sistema</h2>
              
              <div className="kpi-grid">
                <div className="kpi-card">
                  <div>
                    <div className="kpi-label">Usuarios Totales</div>
                    <div className="kpi-value">{usuarios.length}</div>
                  </div>
                  <div className="kpi-icon-wrap"><svg fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"></path></svg></div>
                </div>
                <div className="kpi-card">
                  <div>
                    <div className="kpi-label">Prop. Activas</div>
                    <div className="kpi-value">{propsActivas}</div>
                  </div>
                  <div className="kpi-icon-wrap"><svg fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg></div>
                </div>
                <div className="kpi-card kpi-amber">
                  <div>
                    <div className="kpi-label">Prop. en Revisión</div>
                    <div className="kpi-value">{propsRevision}</div>
                  </div>
                  <div className="kpi-icon-wrap"><svg fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg></div>
                </div>
              </div>

              <h3 className="panel-section-title" style={{fontFamily:'var(--font-body)', fontWeight:700, fontSize:'1.25rem', marginTop:'2rem'}}>Accesos Recientes (Log)</h3>
              <div style={{ borderRadius: 'var(--radius-xl)', overflow: 'hidden', border: '1px solid var(--slate-200)' }}>
                <table className="panel-table">
                  <thead>
                    <tr>
                      <th>Usuario</th>
                      <th>Rol</th>
                      <th>Acción</th>
                      <th>Fecha y Hora</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td><div className="td-title">Juan Agente</div><div style={{fontSize:'0.75rem', color:'var(--slate-500)'}}>agente@inmobix.pe</div></td>
                      <td><span className="rol-badge rol-agente">Agente</span></td>
                      <td><span className="accion-badge accion-login">Login</span></td>
                      <td style={{color:'var(--slate-500)', fontSize:'0.75rem'}}>Hace 5 min</td>
                    </tr>
                    <tr>
                      <td><div className="td-title">Ana Compradora</div><div style={{fontSize:'0.75rem', color:'var(--slate-500)'}}>comprador@gmail.com</div></td>
                      <td><span className="rol-badge rol-comprador">Comprador</span></td>
                      <td><span className="accion-badge accion-login">Login</span></td>
                      <td style={{color:'var(--slate-500)', fontSize:'0.75rem'}}>Hace 20 min</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </>
          )}

          {activeTab === 'usuarios' && (
            <>
              <div className="panel-section-header">
                <h2 className="panel-section-title" style={{fontFamily:'var(--font-body)', fontWeight:700, marginBottom:0}}>Directorio de Usuarios</h2>
                <div style={{display:'flex', gap:'0.5rem'}}>
                  <input type="text" placeholder="Buscar por correo..." className="filter-input" style={{width:'250px'}} />
                  <button className="btn-black">Buscar</button>
                </div>
              </div>
              <div style={{ borderRadius: 'var(--radius-xl)', overflow: 'hidden', border: '1px solid var(--slate-200)' }}>
                <table className="panel-table">
                  <thead>
                    <tr>
                      <th>ID</th>
                      <th>Nombre y Correo</th>
                      <th>Rol Principal</th>
                      <th>Estado</th>
                      <th>Acciones</th>
                    </tr>
                  </thead>
                  <tbody>
                    {usuarios.map(u => (
                      <tr key={u.id_usuario}>
                        <td style={{color:'var(--slate-400)'}}>#{u.id_usuario}</td>
                        <td>
                          <div className="td-title">{u.nombres} {u.apellidos}</div>
                          <div style={{fontSize:'0.75rem', color:'var(--slate-500)'}}>{u.correo}</div>
                        </td>
                        <td>
                          {u.id_rol === 1 && <span className="rol-badge rol-comprador">Comprador</span>}
                          {u.id_rol === 3 && <span className="rol-badge rol-agente">Agente</span>}
                          {u.id_rol === 4 && <span className="rol-badge rol-constructora">Constructora</span>}
                          {u.id_rol === 5 && <span className="rol-badge rol-administrador">Admin</span>}
                        </td>
                        <td>
                          <span className={`status-badge ${u.activo ? 'status-activo' : 'status-pausado'}`}>
                            {u.activo ? 'Activo' : 'Inactivo'}
                          </span>
                        </td>
                        <td>
                          <div style={{display:'flex', gap:'0.5rem'}}>
                            <button className="btn-outline-dark" style={{padding:'0.2rem 0.6rem', fontSize:'0.75rem'}}>Editar</button>
                            <button className="btn-outline-dark" style={{padding:'0.2rem 0.6rem', fontSize:'0.75rem', color:'var(--red-500)', borderColor:'var(--red-500)'}}>Bloquear</button>
                          </div>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </>
          )}

          {activeTab === 'propiedades' && (
            <>
              <h2 className="panel-section-title" style={{fontFamily:'var(--font-body)', fontWeight:700}}>Auditoría de Inmuebles</h2>
              <div style={{ borderRadius: 'var(--radius-xl)', overflow: 'hidden', border: '1px solid var(--slate-200)' }}>
                <table className="panel-table">
                  <thead>
                    <tr>
                      <th>Propiedad</th>
                      <th>Publicador</th>
                      <th>Estado</th>
                      <th>Acciones</th>
                    </tr>
                  </thead>
                  <tbody>
                    {propiedades.map(p => (
                      <tr key={p.id_propiedad}>
                        <td>
                          <div className="td-tipo">{p.id_tipo_inmueble === 1 ? 'Casa' : 'Departamento'}</div>
                          <div className="td-title" title={p.titulo}>{p.titulo}</div>
                        </td>
                        <td>
                          <div style={{fontSize:'0.82rem', color:'var(--slate-700)'}}>
                            {usuarios.find(u => u.id_usuario === p.id_usuario_agente)?.nombres || 'Desconocido'}
                          </div>
                        </td>
                        <td>
                          <span className={`status-badge ${p.estado === 'ACTIVO' ? 'status-activo' : 'status-pausado'}`}>
                            {p.estado === 'ACTIVO' ? 'Activo' : 'En Revisión'}
                          </span>
                        </td>
                        <td>
                          <div style={{display:'flex', gap:'0.5rem'}}>
                            <Link to={`/propiedad/${p.id_propiedad}`} className="btn-outline-dark" style={{padding:'0.2rem 0.6rem', fontSize:'0.75rem'}}>Ver</Link>
                            {p.estado === 'REVISIÓN' && (
                              <button className="btn-outline-dark" style={{padding:'0.2rem 0.6rem', fontSize:'0.75rem', background:'var(--emerald-500)', color:'white', borderColor:'var(--emerald-500)'}}>Aprobar</button>
                            )}
                          </div>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </>
          )}

        </div>
      </main>
    </div>
  );
}
