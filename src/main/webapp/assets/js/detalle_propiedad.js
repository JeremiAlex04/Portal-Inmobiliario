function cambiarFotoPrincipal(src) {
    const hero = document.getElementById('heroImg');
    if (hero) hero.src = src;
}

document.addEventListener("DOMContentLoaded", () => {
    // Gallery Thumbnails Double-Click Lightbox
    document.querySelectorAll('.gallery-thumb, #heroImg').forEach(img => {
        img.addEventListener('dblclick', function() {
            const lightboxImg = document.getElementById('lightboxImg');
            const lightbox = document.getElementById('lightbox');
            if (lightboxImg && lightbox) {
                lightboxImg.src = this.src;
                lightbox.classList.remove('hidden');
            }
        });
    });

    // Map initialization via data attributes
    const mapContainer = document.getElementById('map');
    if (mapContainer) {
        const lat = parseFloat(mapContainer.dataset.lat || -12.046374);
        const lng = parseFloat(mapContainer.dataset.lng || -77.042793);
        const zoom = parseInt(mapContainer.dataset.zoom || 13);
        const titulo = mapContainer.dataset.titulo || '';
        const distrito = mapContainer.dataset.distrito || '';

        const map = L.map('map').setView([lat, lng], zoom);
        L.tileLayer('https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=8IyYWrIbuDLsiINCC7Du', {
            attribution: '&copy; MapTiler &copy; OpenStreetMap contributors'
        }).addTo(map);

        L.marker([lat, lng]).addTo(map)
            .bindPopup(`<b>${titulo}</b><br>${distrito}`)
            .openPopup();
    }

    // Auto-show contact form if query param exists
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('consultaEnviada')) {
        const contactForm = document.getElementById('contactForm');
        if (contactForm) contactForm.classList.remove('hidden');
    }
    if (urlParams.get('whatsappRegistrado')) {
        alert('Contacto por WhatsApp registrado exitosamente.');
    }
});
