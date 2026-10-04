import { BrowserRouter, Routes, Route } from 'react-router-dom';
import { AuthProvider } from './context/AuthContext';
import { CompareProvider } from './context/CompareContext';
import Navbar from './components/Navbar';
import Footer from './components/Footer';
import Home from './pages/Home';
import Propiedades from './pages/Propiedades';
import DetallePropiedad from './pages/DetallePropiedad';
import Comparar from './pages/Comparar';
import Login from './pages/Login';
import Registro from './pages/Registro';
import PanelAgente from './pages/PanelAgente';
import PanelAdmin from './pages/PanelAdmin';
import Planes from './pages/Planes';
import Contacto from './pages/Contacto';
import Nosotros from './pages/Nosotros';
import Favoritos from './pages/Favoritos';
import './App.css';

function NotFound() {
  return (
    <div className="empty-state" style={{ minHeight: '60vh', justifyContent: 'center' }}>
      <span className="empty-icon">🏚️</span>
      <h2>404 — Página no encontrada</h2>
      <a href="/" className="btn-primary">Volver al inicio</a>
    </div>
  );
}

export default function App() {
  return (
    <AuthProvider>
      <CompareProvider>
        <BrowserRouter>
          <div className="app-wrapper">
            <Navbar />
            <main className="app-main">
              <Routes>
                <Route path="/" element={<Home />} />
                <Route path="/propiedades" element={<Propiedades />} />
                <Route path="/propiedad/:id" element={<DetallePropiedad />} />
                <Route path="/comparar" element={<Comparar />} />
                <Route path="/login" element={<Login />} />
                <Route path="/registro" element={<Registro />} />
                <Route path="/agente" element={<PanelAgente />} />
                <Route path="/admin" element={<PanelAdmin />} />
                <Route path="/planes" element={<Planes />} />
                <Route path="/contacto" element={<Contacto />} />
                <Route path="/nosotros" element={<Nosotros />} />
                <Route path="/favoritos" element={<Favoritos />} />
                <Route path="*" element={<NotFound />} />
              </Routes>
            </main>
            <Footer />
          </div>
        </BrowserRouter>
      </CompareProvider>
    </AuthProvider>
  );
}
