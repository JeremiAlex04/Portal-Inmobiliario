import { useState, useEffect } from 'react';
import { Link, useNavigate, useSearchParams } from 'react-router-dom';

export default function Registro() {
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const requestedRol = searchParams.get('rol');

  const [step, setStep] = useState(1);
  const [rol, setRol] = useState(requestedRol ? Number(requestedRol) : null);
  const [formData, setFormData] = useState({
    nombres: '', apellidos: '', correo: '', telefono: '', clave: '', ruc: '', nombre_empresa: ''
  });

  // Si viene con rol de la URL, pre-seleccionar pero seguir mostrando paso 1
  useEffect(() => {
    if (requestedRol) setRol(Number(requestedRol));
  }, [requestedRol]);

  const handleNext = () => {
    if (step === 1 && !rol) return;
    setStep(step + 1);
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    setStep(3); // success view
    setTimeout(() => {
      navigate('/login');
    }, 2500);
  };

  return (
    <div className="auth-page">
      <div className="auth-card" style={{ maxWidth: '480px' }}>
        <div className="auth-header">
          <div className="auth-logo" style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '0.5rem' }}>
            <img src="/logo.png" alt="InmobiX Logo" style={{ height: '48px' }} />
            InmobiX
          </div>
          <h1>Crea tu cuenta</h1>
          {step === 1 && <p>¿Cómo deseas utilizar el portal?</p>}
          {step === 2 && <p>Completa tus datos personales</p>}
        </div>

        {step < 3 && (
          <div className="steps-indicator" style={{ marginBottom: '2rem' }}>
            <div className={`step-dot ${step >= 1 ? 'active' : ''}`}>1</div>
            <div style={{ width: '2rem', height: '1px', background: 'var(--slate-200)', alignSelf: 'center' }}></div>
            <div className={`step-dot ${step >= 2 ? 'active' : ''}`}>2</div>
          </div>
        )}

        {step === 1 && (
          <div className="registro-roles">
            <div className={`rol-option ${rol === 1 ? 'selected' : ''}`} onClick={() => setRol(1)}>
              <strong>Comprador / Inquilino</strong>
              <span>Busco propiedades para comprar o alquilar.</span>
            </div>
            <div className={`rol-option ${rol === 3 ? 'selected' : ''}`} onClick={() => setRol(3)}>
              <strong>Agente Independiente</strong>
              <span>Quiero publicar propiedades y gestionar clientes.</span>
            </div>
            <div className={`rol-option ${rol === 4 ? 'selected' : ''}`} onClick={() => setRol(4)}>
              <strong>Constructora / Inmobiliaria</strong>
              <span>Represento a una empresa con proyectos inmobiliarios.</span>
            </div>
            <button className="btn-black" style={{ marginTop: '1rem', width: '100%' }} onClick={handleNext} disabled={!rol}>
              Continuar
            </button>
          </div>
        )}

        {step === 2 && (
          <form className="auth-form" onSubmit={handleSubmit}>
            <div className="form-row">
              <div className="form-group">
                <label>Nombres</label>
                <input type="text" required value={formData.nombres} onChange={e => setFormData({...formData, nombres: e.target.value})} />
              </div>
              <div className="form-group">
                <label>Apellidos</label>
                <input type="text" required value={formData.apellidos} onChange={e => setFormData({...formData, apellidos: e.target.value})} />
              </div>
            </div>
            <div className="form-row">
              <div className="form-group">
                <label>Correo Electrónico</label>
                <input type="email" required value={formData.correo} onChange={e => setFormData({...formData, correo: e.target.value})} />
              </div>
              <div className="form-group">
                <label>Teléfono (opcional)</label>
                <input type="tel" value={formData.telefono} onChange={e => setFormData({...formData, telefono: e.target.value})} />
              </div>
            </div>

            {rol === 4 && (
              <div className="form-row">
                <div className="form-group">
                  <label>RUC</label>
                  <input type="text" required value={formData.ruc} onChange={e => setFormData({...formData, ruc: e.target.value})} />
                </div>
                <div className="form-group">
                  <label>Nombre Empresa</label>
                  <input type="text" required value={formData.nombre_empresa} onChange={e => setFormData({...formData, nombre_empresa: e.target.value})} />
                </div>
              </div>
            )}

            <div className="form-group">
              <label>Contraseña</label>
              <input type="password" required value={formData.clave} onChange={e => setFormData({...formData, clave: e.target.value})} />
            </div>

            <div className="form-actions" style={{ justifyContent: 'space-between', marginTop: '1rem' }}>
              <button type="button" className="btn-outline-dark" onClick={() => setStep(1)}>Atrás</button>
              <button type="submit" className="btn-black">Crear Cuenta</button>
            </div>
          </form>
        )}

        {step === 3 && (
          <div className="success-card">
            <span className="success-icon">🎉</span>
            <h2 style={{ fontFamily: 'var(--font-title)', fontSize: '1.5rem', marginBottom: '0.5rem' }}>¡Cuenta Creada!</h2>
            <p style={{ color: 'var(--slate-500)', fontSize: '0.9rem' }}>Redirigiendo al inicio de sesión...</p>
          </div>
        )}

        {step < 3 && (
          <div className="auth-footer">
            ¿Ya tienes una cuenta? <Link to="/login">Inicia Sesión</Link>
          </div>
        )}
      </div>
    </div>
  );
}
