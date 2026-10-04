import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { usuarios } from '../data/mockData';

export default function Login() {
  const [correo, setCorreo] = useState('');
  const [clave, setClave] = useState('');
  const [error, setError] = useState('');
  const { login } = useAuth();
  const navigate = useNavigate();

  const handleSubmit = (e) => {
    e.preventDefault();
    const user = usuarios.find(u => u.correo === correo && u.clave === clave);
    if (user) {
      login(user);
      navigate('/');
    } else {
      setError('Credenciales incorrectas (tip: agente@inmobix.pe / 123456)');
    }
  };

  const autofill = (email, pass) => {
    setCorreo(email);
    setClave(pass);
  };

  return (
    <div className="auth-page">
      <div className="auth-card">
        <div className="auth-header">
          <div className="auth-logo" style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '0.5rem' }}>
            <img src="/logo.png" alt="InmobiX Logo" style={{ height: '48px' }} />
            InmobiX
          </div>
          <h1>Bienvenido de nuevo</h1>
          <p>Ingresa a tu cuenta para continuar</p>
        </div>

        {error && <div className="form-error" style={{ marginBottom: '1rem' }}>{error}</div>}

        <form className="auth-form" onSubmit={handleSubmit}>
          <div className="form-group">
            <label>Correo Electrónico</label>
            <input 
              type="email" 
              placeholder="tu@correo.com" 
              required
              value={correo}
              onChange={e => setCorreo(e.target.value)}
            />
          </div>
          <div className="form-group">
            <label>Contraseña</label>
            <input 
              type="password" 
              placeholder="••••••••" 
              required
              value={clave}
              onChange={e => setClave(e.target.value)}
            />
          </div>
          <div className="form-actions" style={{ justifyContent: 'space-between', alignItems: 'center' }}>
            <Link to="#" style={{ fontSize: '0.75rem', color: 'var(--slate-500)', fontWeight: 600 }}>¿Olvidaste tu contraseña?</Link>
            <button type="submit" className="btn-black">Iniciar Sesión</button>
          </div>
        </form>

        <div className="auth-divider">DEMO: Accesos Rápidos</div>
        <div className="quick-logins">
          <button type="button" className="quick-btn" onClick={() => autofill('agente@inmobix.com', '123456')}>Agente</button>
          <button type="button" className="quick-btn" onClick={() => autofill('admin@inmobix.pe', '123456')}>Admin</button>
          <button type="button" className="quick-btn" onClick={() => autofill('comprador@inmobix.pe', '123456')}>Comprador</button>
        </div>

        <div className="auth-footer">
          ¿No tienes una cuenta? <Link to="/registro">Regístrate</Link>
        </div>
      </div>
    </div>
  );
}
