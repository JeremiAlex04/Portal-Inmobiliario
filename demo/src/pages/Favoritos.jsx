import { Link } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import PropiedadCard from '../components/PropiedadCard';
import { propiedades } from '../data/mockData';

export default function Favoritos() {
  const { user } = useAuth();
  
  // Como es un demo, si hay usuario logueado mostramos 2 propiedades aleatorias como sus favoritos
  const favs = user ? [propiedades[0], propiedades[1]] : [];

  if (!user) {
    return (
      <div className="empty-state" style={{ minHeight: '60vh', justifyContent: 'center' }}>
        <span className="empty-icon">🔒</span>
        <h3>Inicia Sesión</h3>
        <p>Debes estar logueado para ver tus propiedades favoritas.</p>
        <Link to="/login" className="btn-black">Ir a Login</Link>
      </div>
    );
  }

  return (
    <div className="page-catalogo">
      <div className="catalogo-header">
        <span className="catalogo-eyebrow">Mi Cuenta</span>
        <h1 className="catalogo-title">Mis Favoritos</h1>
        <p className="catalogo-subtitle">Propiedades que has guardado para revisar más tarde.</p>
      </div>

      <div className="catalogo-results" style={{marginTop:'2rem'}}>
        {favs.length === 0 ? (
          <div className="empty-state">
            <span className="empty-icon">❤️</span>
            <h3>No tienes favoritos</h3>
            <p>Aún no has guardado ninguna propiedad. Explora nuestro catálogo y guarda las que más te gusten.</p>
            <Link to="/propiedades" className="btn-black mt-4">Explorar Catálogo</Link>
          </div>
        ) : (
          <div className="cards-grid">
            {favs.map(p => (
              <PropiedadCard key={p.id_propiedad} propiedad={p} />
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
