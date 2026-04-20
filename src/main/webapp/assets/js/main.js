document.addEventListener("DOMContentLoaded", () => {
    const form = document.querySelector("form");
    if (form) {
        form.addEventListener("submit", () => {
            const btn = form.querySelector("button[type='submit']");
            if (btn) {
                btn.innerHTML = "Procesando...";
                btn.style.opacity = "0.7";
                btn.style.pointerEvents = "none";
            }
        });
    }
});
