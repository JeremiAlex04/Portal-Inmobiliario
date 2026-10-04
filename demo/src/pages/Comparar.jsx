import { Link } from 'react-router-dom';
import { useCompare } from '../context/CompareContext';
import { propiedades, getDistrito, getTipo } from '../data/mockData';

export default function Comparar() {
  const { compareList, removeCompare, clearCompare } = useCompare();

  const propiedadesAComparar = compareList.map(id => propiedades.find(p => p.id_propiedad === id)).filter(Boolean);

  // Aseguramos que haya exactamente 3 espacios para mostrar la grilla correctamente
  const maxCompare = 3;
  const slots = Array.from({ length: maxCompare }).map((_, i) => propiedadesAComparar[i] || null);

  const formatPrice = (p) => {
    const isUSD = p.moneda_base === 'USD';
    const tc = 3.78;
    const precioUSD = isUSD ? p.precio : p.precio / tc;
    return `US$ ${precioUSD.toLocaleString(undefined, { maximumFractionDigits: 0 })}`;
  };

  return (
    <div className="page-comparar">
      <div className="comparar-breadcrumb">
        <Link to="/propiedades">← Volver al catálogo</Link>
      </div>
      
      <h1 className="comparar-title">Comparador de Propiedades</h1>
      
      {compareList.length > 0 && (
        <div className="comparar-actions">
          <button className="btn-outline-dark" onClick={clearCompare}>Limpiar comparador</button>
        </div>
      )}

      <div className="comparar-table-wrap">
        <table className="comparar-table">
          <thead>
            <tr>
              <th className="comparar-th-label">Características</th>
              {slots.map((p, i) => (
                <th key={i} className={p ? "comparar-th-prop" : "comparar-th-empty"}>
                  {p ? (
                    <div className="comp-prop-header">
                      <button className="comp-remove" onClick={() => removeCompare(p.id_propiedad)}>✕ Quitar</button>
                      <img src={p.foto_principal} alt={p.titulo} className="comp-prop-img" />
                      <Link to={`/propiedad/${p.id_propiedad}`} className="comp-prop-title">{p.titulo}</Link>
                    </div>
                  ) : (
                    <div className="comp-empty-slot">
                      <span>+</span>
                      <p>Espacio disponible para comparar</p>
                      <Link to="/propiedades" className="btn-outline-dark btn-sm">Buscar propiedad</Link>
                    </div>
                  )}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            <tr className="row-even">
              <td className="comparar-td-label">Precio Referencial</td>
              {slots.map((p, i) => (
                <td key={i} className={p ? "comparar-td-val price-usd-highlight" : "comparar-td-empty"}>
                  {p ? formatPrice(p) : '-'}
                </td>
              ))}
            </tr>
            <tr className="row-odd">
              <td className="comparar-td-label">Ubicación</td>
              {slots.map((p, i) => (
                <td key={i} className={p ? "comparar-td-val" : "comparar-td-empty"}>
                  {p ? getDistrito(p.id_distrito)?.nombre : '-'}
                </td>
              ))}
            </tr>
            <tr className="row-even">
              <td className="comparar-td-label">Tipo</td>
              {slots.map((p, i) => (
                <td key={i} className={p ? "comparar-td-val" : "comparar-td-empty"}>
                  {p ? getTipo(p.id_tipo_inmueble)?.nombre : '-'}
                </td>
              ))}
            </tr>
            <tr className="row-odd">
              <td className="comparar-td-label">Área Total</td>
              {slots.map((p, i) => (
                <td key={i} className={p ? "comparar-td-val" : "comparar-td-empty"}>
                  {p ? `${p.area_total_m2} m²` : '-'}
                </td>
              ))}
            </tr>
            <tr className="row-even">
              <td className="comparar-td-label">Dormitorios / Baños</td>
              {slots.map((p, i) => (
                <td key={i} className={p ? "comparar-td-val" : "comparar-td-empty"}>
                  {p ? `${p.num_dormitorios} dorms, ${p.num_banos} baños` : '-'}
                </td>
              ))}
            </tr>
            <tr className="row-odd">
              <td className="comparar-td-label">Beneficios</td>
              {slots.map((p, i) => (
                <td key={i} className={p ? "comparar-td-val" : "comparar-td-empty"}>
                  {p ? (
                    <div style={{ display: 'flex', flexDirection: 'column', gap: '0.25rem' }}>
                      {p.bono_mi_vivienda ? <span className="card-bono bono-mivivienda" style={{position:'static'}}>MiVivienda</span> : null}
                      {p.bono_verde ? <span className="card-bono bono-verde" style={{position:'static'}}>Bono Verde</span> : null}
                      {!p.bono_mi_vivienda && !p.bono_verde ? <span style={{color:'var(--slate-400)'}}>Ninguno</span> : null}
                    </div>
                  ) : '-'}
                </td>
              ))}
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  );
}
