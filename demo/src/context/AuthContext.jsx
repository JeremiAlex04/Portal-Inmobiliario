import { createContext, useContext, useState, useEffect } from 'react';
import { usuarios } from '../data/mockData';

const AuthContext = createContext(null);

const CREDENTIALS = {
  'admin@inmobix.pe':       { password: '123456', id: 2 },
  'agente@inmobix.com':     { password: '123456', id: 1 },
  'maria.torres@inmobix.com': { password: '123456', id: 3 },
  'comprador@inmobix.pe':   { password: '123456', id: 4 },
};

export function AuthProvider({ children }) {
  const [user, setUser] = useState(() => {
    try { return JSON.parse(localStorage.getItem('inmobix_user')); } catch { return null; }
  });

  const login = (correo, password) => {
    const cred = CREDENTIALS[correo];
    if (cred && cred.password === password) {
      const found = usuarios.find(u => u.id_usuario === cred.id);
      localStorage.setItem('inmobix_user', JSON.stringify(found));
      setUser(found);
      return { ok: true };
    }
    return { ok: false, error: 'Correo o contraseña incorrectos' };
  };

  const logout = () => { localStorage.removeItem('inmobix_user'); setUser(null); };

  return (
    <AuthContext.Provider value={{ user, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
}

export const useAuth = () => useContext(AuthContext);
