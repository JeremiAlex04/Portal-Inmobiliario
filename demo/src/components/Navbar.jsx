import { Link, useNavigate } from 'react-router-dom';
import { useState } from 'react';
import { useAuth } from '../context/AuthContext';
import { useCompare } from '../context/CompareContext';

export default function Navbar() {
  const { user, logout } = useAuth();
  const { compareList } = useCompare();
  const navigate = useNavigate();
  const [menuOpen, setMenuOpen] = useState(false);
  const [dropdownOpen, setDropdownOpen] = useState(false);

  const handleLogout = () => {
    logout();
    navigate('/');
  };

  return (
    <header className="navbar">
      <div className="navbar-inner">
        <Link to="/" className="navbar-logo">
          <img src="/logo.png" alt="InmobiX Logo" style={{ height: '36px', filter: 'brightness(0) invert(1)' }} />
          <div className="logo-text">InmobiX</div>
        </Link>

        <button className="hamburger" onClick={() => setMenuOpen(!menuOpen)}>
          <span></span><span></span><span></span>
        </button>

        <nav className={`navbar-links ${menuOpen ? 'open' : ''}`}>
          <Link to="/" onClick={() => setMenuOpen(false)}>Inicio</Link>
          <Link to="/propiedades" onClick={() => setMenuOpen(false)}>Explorar</Link>
          <Link to="/planes" onClick={() => setMenuOpen(false)}>Planes</Link>
          <Link to="/nosotros" onClick={() => setMenuOpen(false)}>Nosotros</Link>
          <Link to="/contacto" onClick={() => setMenuOpen(false)}>Contacto</Link>
          
          <Link to="/comparar" onClick={() => setMenuOpen(false)}>
            Comparar
            {compareList.length > 0 && <span className="badge">{compareList.length}</span>}
          </Link>
        </nav>

        <div className="navbar-actions">
          {!user ? (
            <>
              <Link to="/login" className="btn-outline">Iniciar Sesión</Link>
              <Link to="/registro" className="btn-primary">Registrarse</Link>
            </>
          ) : (
            <div className="user-menu" onClick={() => setDropdownOpen(!dropdownOpen)}>
              <div className="avatar" style={{ backgroundImage: `url(${user.avatar_url})`, backgroundSize: 'cover' }}></div>
              <span className="user-name">{user.nombres.split(' ')[0]}</span>
              <svg className="chevron" fill="none" stroke="currentColor" viewBox="0 0 24 24" width="12" height="12"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M19 9l-7 7-7-7"></path></svg>

              {dropdownOpen && (
                <div className="dropdown">
                  <div className="dropdown-header">
                    <strong>{user.nombres} {user.apellidos}</strong>
                    <span style={{ fontSize: '0.75rem', color: 'var(--slate-500)' }}>{user.correo}</span>
                  </div>
                  {user.id_rol === 5 && (
                    <Link to="/admin" className="dropdown-item">⚙️ Panel Admin</Link>
                  )}
                  {user.id_rol === 3 && (
                    <Link to="/agente" className="dropdown-item">📊 Consola Agente</Link>
                  )}
                  {user.id_rol === 2 && (
                    <Link to="/favoritos" className="dropdown-item">❤️ Mis Favoritos</Link>
                  )}
                  <button onClick={handleLogout} className="dropdown-item danger">
                    🚪 Cerrar Sesión
                  </button>
                </div>
              )}
            </div>
          )}
        </div>
      </div>
    </header>
  );
}
