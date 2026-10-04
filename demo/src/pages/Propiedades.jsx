import { useState, useMemo } from 'react';
import { useSearchParams } from 'react-router-dom';
import PropiedadCard from '../components/PropiedadCard';
import { propiedades, getDistrito } from '../data/mockData';

export default function Propiedades() {
  const [searchParams] = useSearchParams();
  const qDistrito = searchParams.get('distrito') || '';
  const qOperacion = searchParams.get('op') || '';
  const qTipo = searchParams.get('tipo') || '';
  const qBono = searchParams.get('bono') || '';
  const qQuery = searchParams.get('q') || '';
  const isDestacada = searchParams.get('destacada') === 'true';

  const [filtros, setFiltros] = useState({
    distrito: qDistrito, operacion: qOperacion, tipo: qTipo,
    precioMin: '', precioMax: '', dorms: '', bono: qBono, q: qQuery
  });

  const [vista, setVista] = useState('grid'); // 'grid' | 'list'

  const propiedadesFiltradas = useMemo(() => {
    return propiedades.filter(p => {
      if (isDestacada && !p.destacada) return false;
      if (filtros.q && !p.titulo.toLowerCase().includes(filtros.q.toLowerCase())) return false;
      if (filtros.distrito && p.id_distrito.toString() !== filtros.distrito) return false;
      if (filtros.operacion && p.id_operacion.toString() !== filtros.operacion) return false;
      if (filtros.tipo && p.id_tipo_inmueble.toString() !== filtros.tipo) return false;
      if (filtros.precioMin && p.precio < Number(filtros.precioMin)) return false;
      if (filtros.precioMax && p.precio > Number(filtros.precioMax)) return false;
      if (filtros.dorms && p.num_dormitorios < Number(filtros.dorms)) return false;
      if (filtros.bono === 'mivivienda' && !p.bono_mi_vivienda) return false;
      if (filtros.bono === 'verde' && !p.bono_verde) return false;
      return true;
    });
  }, [filtros, isDestacada]);

  const handleChange = (k, v) => setFiltros(f => ({ ...f, [k]: v }));
  const resetFiltros = () => setFiltros({ distrito: '', operacion: '', tipo: '', precioMin: '', precioMax: '', dorms: '', bono: '', q: '' });

  return (
    <div className="page-catalogo">
      <div className="catalogo-header">
        <span className="catalogo-eyebrow">Colección Premium</span>
        <h1 className="catalogo-title">Descubrir Propiedades</h1>
        <p className="catalogo-subtitle">Explora y filtra las propiedades disponibles en todo el Perú con nuestra búsqueda avanzada.</p>
      </div>

      <div className="filter-bar">
        <div className="filter-bar-inner">
          <div className="filter-grid">
            <div>
              <label className="filter-label">¿Buscas una propiedad?</label>
              <input 
                type="text" 
                className="filter-input" 
                placeholder="Ej. Departamento en Miraflores" 
                value={filtros.q} onChange={e => handleChange('q', e.target.value)} 
              />
            </div>
            <div>
              <label className="filter-label">Operación</label>
              <select className="filter-input" value={filtros.operacion} onChange={e => handleChange('operacion', e.target.value)}>
                <option value="">Todas</option>
                <option value="1">Comprar</option>
                <option value="2">Alquilar</option>
                <option value="3">Anticresis</option>
              </select>
            </div>
            <div>
              <label className="filter-label">Tipo</label>
              <select className="filter-input" value={filtros.tipo} onChange={e => handleChange('tipo', e.target.value)}>
                <option value="">Todos</option>
                <option value="1">Casa</option>
                <option value="2">Departamento</option>
                <option value="3">Terreno</option>
                <option value="4">Oficina</option>
              </select>
            </div>
            <div>
              <label className="filter-label">Dormitorios</label>
              <select className="filter-input" value={filtros.dorms} onChange={e => handleChange('dorms', e.target.value)}>
                <option value="">Cualquiera</option>
                <option value="1">1+ dorms</option>
                <option value="2">2+ dorms</option>
                <option value="3">3+ dorms</option>
                <option value="4">4+ dorms</option>
              </select>
            </div>
          </div>

          <div className="filter-grid-2">
            <div>
              <label className="filter-label">Precio Min (USD)</label>
              <input type="number" className="filter-input" placeholder="Ej. 50000" value={filtros.precioMin} onChange={e => handleChange('precioMin', e.target.value)} />
            </div>
            <div>
              <label className="filter-label">Precio Max (USD)</label>
              <input type="number" className="filter-input" placeholder="Ej. 300000" value={filtros.precioMax} onChange={e => handleChange('precioMax', e.target.value)} />
            </div>
            <div>
              <label className="filter-label">Beneficios y Bonos</label>
              <div className="filter-extras">
                <label className={`filter-checkbox ${filtros.bono === 'mivivienda' ? 'checked' : ''}`}>
                  <input type="radio" name="bono" checked={filtros.bono === 'mivivienda'} onChange={() => handleChange('bono', 'mivivienda')} /> MiVivienda
                </label>
                <label className={`filter-checkbox ${filtros.bono === 'verde' ? 'checked' : ''}`}>
                  <input type="radio" name="bono" checked={filtros.bono === 'verde'} onChange={() => handleChange('bono', 'verde')} /> Bono Verde
                </label>
                {filtros.bono && (
                  <button type="button" onClick={() => handleChange('bono', '')} className="text-xs text-slate-500 underline ml-2">Quitar</button>
                )}
              </div>
            </div>
            <div className="filter-actions">
              <button className="btn-outline-dark" onClick={resetFiltros}>Limpiar</button>
              <button className="btn-black">Buscar</button>
            </div>
          </div>
        </div>
      </div>

      <div className="catalogo-results">
        <div className="catalogo-bar">
          <div className="result-count">
            Se encontraron <strong>{propiedadesFiltradas.length}</strong> propiedades
          </div>
          <div className="catalogo-controls">
            <div className="vista-toggle">
              <button className={vista === 'grid' ? 'active' : ''} onClick={() => setVista('grid')}>▦</button>
              <button className={vista === 'list' ? 'active' : ''} onClick={() => setVista('list')}>☰</button>
            </div>
          </div>
        </div>

        {propiedadesFiltradas.length === 0 ? (
          <div className="empty-state">
            <span className="empty-icon">🏚️</span>
            <h3>No se encontraron propiedades</h3>
            <p>Intenta ajustar tus filtros de búsqueda.</p>
            <button className="btn-black" onClick={resetFiltros}>Limpiar todos los filtros</button>
          </div>
        ) : (
          <div className={vista === 'grid' ? 'cards-grid' : 'cards-list'}>
            {propiedadesFiltradas.map(p => (
              <PropiedadCard key={p.id_propiedad} propiedad={p} />
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
