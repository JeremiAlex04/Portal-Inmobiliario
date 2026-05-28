document.addEventListener("DOMContentLoaded", () => {
    const canvas = document.getElementById('vistasChart');
    if (canvas) {
        let labels = [];
        let views = [];
        try {
            labels = JSON.parse(canvas.dataset.labels || '[]');
            views = JSON.parse(canvas.dataset.views || '[]');
        } catch (e) {
            console.error("Error parsing charts data attributes:", e);
        }
        
        const ctx = canvas.getContext('2d');
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Vistas',
                    data: views,
                    borderColor: 'rgb(79, 70, 229)',
                    backgroundColor: 'rgba(79, 70, 229, 0.1)',
                    fill: true,
                    tension: 0.4,
                    pointRadius: 4,
                    pointBackgroundColor: 'rgb(79, 70, 229)'
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { display: false } },
                scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } }
            }
        });
    }
});
