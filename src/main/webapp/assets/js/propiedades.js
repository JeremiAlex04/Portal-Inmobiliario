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

// Restore checkboxes on page load
document.addEventListener('DOMContentLoaded', () => {
    comparar_ids.forEach(id => {
        const cb = document.querySelector('.comp-check[data-id="' + id + '"]');
        if (cb) cb.checked = true;
    });
    actualizarComparador();
});
