// 1. Typing Effect configuration & state
const words = ["para tu familia", "con seguridad SUNARP", "al mejor precio", "en zonas exclusivas"];
let wordIndex = 0;
let charIndex = 0;
let isDeleting = false;

function type() {
    const typedTextSpan = document.getElementById("typed-text");
    if (!typedTextSpan) return;
    
    const currentWord = words[wordIndex];
    if (isDeleting) {
        charIndex--;
    } else {
        charIndex++;
    }
    typedTextSpan.textContent = currentWord.substring(0, charIndex);

    let typeSpeed = isDeleting ? 40 : 80;

    if (!isDeleting && charIndex === currentWord.length) {
        typeSpeed = 2200; // Pause at full word
        isDeleting = true;
    } else if (isDeleting && charIndex === 0) {
        isDeleting = false;
        wordIndex = (wordIndex + 1) % words.length;
        typeSpeed = 400; // Pause before next word
    }

    setTimeout(type, typeSpeed);
}

// 2. Statistical Counter Animation
let countersAnimated = false;
function animateCounters() {
    if (countersAnimated) return;
    countersAnimated = true;
    
    const counters = document.querySelectorAll('.stat-counter');
    counters.forEach(counter => {
        const target = +counter.getAttribute('data-target');
        const suffix = counter.getAttribute('data-suffix') || "";
        const duration = 2000;
        const step = target / (duration / 16);
        let current = 0;
        
        const update = () => {
            current += step;
            if (current < target) {
                counter.textContent = Math.floor(current) + suffix;
                requestAnimationFrame(update);
            } else {
                counter.textContent = target + suffix;
            }
        };
        update();
    });
}

// 3. Execution on load (DOM is already fully parsed due to defer tag)
// Global Form Handling & Spinner
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

// Initialize Typewriter animation if element exists
const typedTextSpan = document.getElementById("typed-text");
if (typedTextSpan) {
    type();
}

// Scroll Reveal Observer
const revealElements = document.querySelectorAll('.reveal, .reveal-stagger');
if (revealElements.length > 0) {
    const revealCallback = (entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('active');
                if (entry.target.id === 'stats-section') {
                    animateCounters();
                }
            }
        });
    };

    const revealObserver = new IntersectionObserver(revealCallback, {
        root: null,
        threshold: 0.05 // Trigger reveal when at least 5% is visible
    });

    revealElements.forEach(el => {
        revealObserver.observe(el);
    });
}
