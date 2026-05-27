let comparar_ids = JSON.parse(localStorage.getItem('comparar_ids') || '[]');

function actualizarComparador() {
    comparar_ids = [];
    document.querySelectorAll('.comp-check:checked').forEach(cb => {
        if (comparar_ids.length < 4) {
            comparar_ids.push(cb.dataset.id);
        } else {
            cb.checked = false;
            alert('Máximo 4 propiedades.');
        }
    });
    localStorage.setItem('comparar_ids', JSON.stringify(comparar_ids));
    
    const bar = document.getElementById('compBar');
    const count = document.getElementById('compCount');
    if (count) {
        count.textContent = 'Comparar (' + comparar_ids.length + ')';
    }
    if (bar) {
        bar.classList.toggle('hidden', comparar_ids.length === 0);
    }
}

function irComparar() {
    if (comparar_ids.length < 2) {
        alert('Selecciona al menos 2 propiedades.');
        return;
    }
    const contextPath = document.body.dataset.contextPath || '';
    window.location.href = contextPath + '/comparar?ids=' + comparar_ids.join(',');
}

function limpiarComparador() {
    comparar_ids = [];
    localStorage.removeItem('comparar_ids');
    document.querySelectorAll('.comp-check').forEach(cb => cb.checked = false);
    actualizarComparador();
}

// View mode toggling (Grid vs List)
function applyViewMode(mode) {
    const container = document.getElementById('propiedades-container');
    const btnGrid = document.getElementById('btn-view-grid');
    const btnList = document.getElementById('btn-view-list');
    
    if (!container) return;
    
    const cards = container.querySelectorAll('.propiedad-card');
    
    if (mode === 'list') {
        // List mode (horizontal)
        container.className = 'grid grid-cols-1 gap-6';
        
        cards.forEach(card => {
            card.className = 'propiedad-card group bg-white rounded-2xl shadow-sm hover:shadow-xl border border-slate-200 overflow-hidden transition-all duration-300 hover:-translate-y-1 flex flex-col md:flex-row';
            
            const imgContainer = card.querySelector('.propiedad-img-container');
            if (imgContainer) {
                imgContainer.className = 'propiedad-img-container relative h-56 md:h-auto md:w-80 shrink-0 bg-gradient-to-br from-slate-200 to-slate-300 overflow-hidden';
            }
            
            const body = card.querySelector('.propiedad-body');
            if (body) {
                body.className = 'propiedad-body p-6 flex-grow flex flex-col justify-between';
            }
        });
        
        // Update toggle buttons active/inactive classes
        if (btnGrid) {
            btnGrid.classList.remove('bg-white', 'shadow-sm', 'text-black');
            btnGrid.classList.add('text-slate-600');
        }
        if (btnList) {
            btnList.classList.add('bg-white', 'shadow-sm', 'text-black');
            btnList.classList.remove('text-slate-600');
        }
    } else {
        // Grid mode (vertical, default)
        container.className = 'grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8';
        
        cards.forEach(card => {
            card.className = 'propiedad-card group bg-white rounded-2xl shadow-sm hover:shadow-xl border border-slate-200 overflow-hidden transition-all duration-300 hover:-translate-y-1 flex flex-col';
            
            const imgContainer = card.querySelector('.propiedad-img-container');
            if (imgContainer) {
                imgContainer.className = 'propiedad-img-container relative h-56 bg-gradient-to-br from-slate-200 to-slate-300 overflow-hidden';
            }
            
            const body = card.querySelector('.propiedad-body');
            if (body) {
                body.className = 'propiedad-body p-6 flex-grow flex flex-col';
            }
        });
        
        // Update toggle buttons active/inactive classes
        if (btnGrid) {
            btnGrid.classList.add('bg-white', 'shadow-sm', 'text-black');
            btnGrid.classList.remove('text-slate-600');
        }
        if (btnList) {
            btnList.classList.remove('bg-white', 'shadow-sm', 'text-black');
            btnList.classList.add('text-slate-600');
        }
    }
}

// Restore checkboxes and view mode preference on page load
document.addEventListener('DOMContentLoaded', () => {
    comparar_ids.forEach(id => {
        const cb = document.querySelector('.comp-check[data-id="' + id + '"]');
        if (cb) cb.checked = true;
    });
    actualizarComparador();

    // View mode toggle listeners
    const btnGrid = document.getElementById('btn-view-grid');
    const btnList = document.getElementById('btn-view-list');
    
    if (btnGrid && btnList) {
        btnGrid.addEventListener('click', () => {
            localStorage.setItem('propiedades_view_mode', 'grid');
            applyViewMode('grid');
        });
        
        btnList.addEventListener('click', () => {
            localStorage.setItem('propiedades_view_mode', 'list');
            applyViewMode('list');
        });
    }
    
    // Restore saved view mode preference
    const savedMode = localStorage.getItem('propiedades_view_mode') || 'grid';
    applyViewMode(savedMode);
});
