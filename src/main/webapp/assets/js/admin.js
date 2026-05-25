// Toggle audit log JSON detail blocks
function toggleDetail(id) {
    const el = document.getElementById('detail-' + id);
    if (el) {
        el.classList.toggle('hidden');
    }
}

// Confirmation alert for deletions
function confirmarEliminacion(url) {
    if (confirm("¿Estás seguro que deseas ELIMINAR permanentemente este elemento de la plataforma? Esta acción es irreversible.")) {
        window.location.href = url;
    }
}

// Specific confirmation alert for locations
function confirmarEliminacionUbicacion(url) {
    if (confirm("¿Estás seguro de eliminar esta ubicación? Podría afectar a propiedades asociadas.")) {
        window.location.href = url;
    }
}

// Location management modal helpers
function editarUbicacion(id, nombre, codigo, parentId) {
    const title = document.getElementById('modalTitle');
    if (title) title.innerText = 'Editar Ubicación';
    
    const fId = document.getElementById('formId');
    if (fId) fId.value = id;
    
    const fNombre = document.getElementById('formNombre');
    if (fNombre) fNombre.value = nombre;
    
    const fCodigo = document.getElementById('formCodigo');
    if (fCodigo) fCodigo.value = codigo;
    
    const parentSelect = document.getElementById('formParentId');
    if (parentSelect) {
        parentSelect.value = parentId;
    }
    
    const modal = document.getElementById('ubicacionModal');
    if (modal) {
        modal.classList.remove('hidden');
        modal.classList.add('flex');
    }
}

function nuevaUbicacion() {
    const title = document.getElementById('modalTitle');
    if (title) title.innerText = 'Nueva Ubicación';
    
    const fId = document.getElementById('formId');
    if (fId) fId.value = '';
    
    const fNombre = document.getElementById('formNombre');
    if (fNombre) fNombre.value = '';
    
    const fCodigo = document.getElementById('formCodigo');
    if (fCodigo) fCodigo.value = '';
    
    const parentSelect = document.getElementById('formParentId');
    if (parentSelect) {
        parentSelect.selectedIndex = 0;
    }
    
    const modal = document.getElementById('ubicacionModal');
    if (modal) {
        modal.classList.remove('hidden');
        modal.classList.add('flex');
    }
}

function cerrarModal() {
    const modal = document.getElementById('ubicacionModal');
    if (modal) {
        modal.classList.add('hidden');
        modal.classList.remove('flex');
    }
}

// User management modal helpers
function abrirModalNuevo() {
    const title = document.getElementById('modalUsuarioTitle');
    if (title) title.innerText = 'Registrar Nuevo Usuario';
    
    const action = document.getElementById('formAccion');
    if (action) action.value = 'registrar_usuario';
    
    const userId = document.getElementById('formUserId');
    if (userId) userId.value = '';
    
    const nombres = document.getElementById('formNombres');
    if (nombres) nombres.value = '';
    
    const apellidos = document.getElementById('formApellidos');
    if (apellidos) apellidos.value = '';
    
    const correo = document.getElementById('formCorreo');
    if (correo) correo.value = '';
    
    const pwdField = document.getElementById('passwordField');
    if (pwdField) pwdField.classList.remove('hidden');
    
    const rolField = document.getElementById('rolField');
    if (rolField) rolField.classList.remove('hidden');
    
    const modal = document.getElementById('modalUsuario');
    if (modal) {
        modal.classList.remove('hidden');
        modal.classList.add('flex');
    }
}

function abrirModalEditar(id, nombres, apellidos, correo) {
    const title = document.getElementById('modalUsuarioTitle');
    if (title) title.innerText = 'Editar Usuario #' + id;
    
    const action = document.getElementById('formAccion');
    if (action) action.value = 'editar_usuario';
    
    const userId = document.getElementById('formUserId');
    if (userId) userId.value = id;
    
    const fNombres = document.getElementById('formNombres');
    if (fNombres) fNombres.value = nombres;
    
    const fApellidos = document.getElementById('formApellidos');
    if (fApellidos) fApellidos.value = apellidos;
    
    const fCorreo = document.getElementById('formCorreo');
    if (fCorreo) fCorreo.value = correo;
    
    const pwdField = document.getElementById('passwordField');
    if (pwdField) pwdField.classList.add('hidden');
    
    const rolField = document.getElementById('rolField');
    if (rolField) rolField.classList.add('hidden');
    
    const modal = document.getElementById('modalUsuario');
    if (modal) {
        modal.classList.remove('hidden');
        modal.classList.add('flex');
    }
}

function cerrarModalUsuario() {
    const modal = document.getElementById('modalUsuario');
    if (modal) {
        modal.classList.add('hidden');
        modal.classList.remove('flex');
    }
}
