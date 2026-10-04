import { Link } from 'react-router-dom';
import { useCompare } from '../context/CompareContext';
import { getTipo, getDistrito, getOperacion } from '../data/mockData';

export default function PropiedadCard({ propiedad }) {
  const { compareList, toggleCompare } = useCompare();
  const isComparing = compareList.includes(propiedad.id_propiedad);

  const operacion = getOperacion(propiedad.id_operacion);
  const tipo = getTipo(propiedad.id_tipo_inmueble);
  const distrito = getDistrito(propiedad.id_distrito);

  // Formato de precios
  const isUSD = propiedad.moneda_base === 'USD';
  const tc = 3.78;
  const precioUSD = isUSD ? propiedad.precio : propiedad.precio / tc;
  const precioPEN = isUSD ? propiedad.precio * tc : propiedad.precio;

  return (
    <div className="property-card">
      <Link to={`/propiedad/${propiedad.id_propiedad}`} className="card-img-wrap">
        <img src={propiedad.foto_principal} alt={propiedad.titulo} className="card-img" />
        
        <span className="card-op-badge">
          {operacion?.nombre}
        </span>

        {propiedad.bono_mi_vivienda && <span className="card-bono bono-mivivienda">MiVivienda</span>}
        {!propiedad.bono_mi_vivienda && propiedad.bono_verde && <span className="card-bono bono-verde">Bono Verde</span>}

        <div className="card-location-overlay">
          <span className="card-location-text">{distrito?.nombre}, Lima</span>
          <span className="card-area-pill">{propiedad.area_total_m2} m²</span>
        </div>
      </Link>

      <div className="card-body">
        <Link to={`/propiedad/${propiedad.id_propiedad}`} className="card-title">
          {propiedad.titulo}
        </Link>
        <p className="card-desc">
          {propiedad.descripcion}
        </p>

        <div className="card-specs">
          <div className="card-spec">
            <svg fill="none" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>
            <span>{propiedad.num_dormitorios} Dorm.</span>
          </div>
          <div className="card-spec">
            <svg fill="none" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M8 14v3m4-3v3m4-3v3M3 21h18M3 10h18M3 7l9-4 9 4M4 10h16v11H4V10z"></path></svg>
            <span>{propiedad.num_banos} Baños</span>
          </div>
          <div className="card-spec" style={{ marginLeft: 'auto' }}>
            <span>{tipo?.nombre}</span>
          </div>
        </div>

        <div className="card-footer">
          <div>
            <div className="card-price-main">US$ {precioUSD.toLocaleString(undefined, { maximumFractionDigits: 0 })}</div>
            <div className="card-price-alt">S/ {precioPEN.toLocaleString(undefined, { maximumFractionDigits: 0 })}</div>
          </div>
          
          <button 
            className={`btn-compare ${isComparing ? 'active' : ''}`}
            onClick={(e) => { e.preventDefault(); toggleCompare(propiedad.id_propiedad); }}
          >
            {isComparing ? 'Agregado' : '+ Comparar'}
          </button>
        </div>
      </div>
    </div>
  );
}
