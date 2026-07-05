// Toast notification system
function showToast(message, type) {
    type = type || 'info';
    var container = document.getElementById('toast-container');
    if (!container) {
        container = document.createElement('div');
        container.id = 'toast-container';
        container.className = 'fixed top-4 right-4 z-[9999] flex flex-col gap-2';
        document.body.appendChild(container);
    }

    var colors = {
        success: 'bg-emerald-600 text-white',
        error: 'bg-red-600 text-white',
        info: 'bg-gray-900 text-white',
        warning: 'bg-amber-500 text-white'
    };
    var icons = {
        success: '<svg class="w-5 h-5 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>',
        error: '<svg class="w-5 h-5 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>',
        info: '<svg class="w-5 h-5 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>',
        warning: '<svg class="w-5 h-5 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>'
    };

    var toast = document.createElement('div');
    toast.className = 'flex items-center gap-3 px-4 py-3 rounded-xl shadow-lg text-sm font-medium animate-slide-down ' + (colors[type] || colors.info);
    toast.innerHTML = (icons[type] || icons.info) + '<span>' + message + '</span>';
    container.appendChild(toast);

    setTimeout(function() {
        toast.style.opacity = '0';
        toast.style.transform = 'translateX(100%)';
        toast.style.transition = 'all 0.3s ease';
        setTimeout(function() { toast.remove(); }, 300);
    }, 4000);
}

// Mobile menu toggle
function toggleMobileMenu() {
    var menu = document.getElementById('mobile-menu');
    if (menu) {
        menu.classList.toggle('hidden');
    }
}

// Close mobile menu on outside click
document.addEventListener('click', function(e) {
    var menu = document.getElementById('mobile-menu');
    var btn = e.target.closest('button[onclick*="toggleMobileMenu"]');
    if (menu && !menu.contains(e.target) && !btn) {
        if (!menu.classList.contains('hidden')) {
            menu.classList.add('hidden');
        }
    }
});

// Close mobile menu on resize to desktop
window.addEventListener('resize', function() {
    var menu = document.getElementById('mobile-menu');
    if (menu && window.innerWidth >= 768) {
        menu.classList.add('hidden');
    }
});

// 1. Typing Effect
var words = ["para tu familia", "con seguridad SUNARP", "al mejor precio", "en zonas exclusivas"];
var wordIndex = 0;
var charIndex = 0;
var isDeleting = false;

function type() {
    var typedTextSpan = document.getElementById("typed-text");
    if (!typedTextSpan) return;

    var currentWord = words[wordIndex];
    if (isDeleting) {
        charIndex--;
    } else {
        charIndex++;
    }
    typedTextSpan.textContent = currentWord.substring(0, charIndex);

    var typeSpeed = isDeleting ? 40 : 80;

    if (!isDeleting && charIndex === currentWord.length) {
        typeSpeed = 2200;
        isDeleting = true;
    } else if (isDeleting && charIndex === 0) {
        isDeleting = false;
        wordIndex = (wordIndex + 1) % words.length;
        typeSpeed = 400;
    }

    setTimeout(type, typeSpeed);
}

// 2. Statistical Counter Animation
var countersAnimated = false;
function animateCounters() {
    if (countersAnimated) return;
    countersAnimated = true;

    var counters = document.querySelectorAll('.stat-counter');
    counters.forEach(function(counter) {
        var target = +counter.getAttribute('data-target');
        var suffix = counter.getAttribute('data-suffix') || "";
        var duration = 2000;
        var step = target / (duration / 16);
        var current = 0;

        function update() {
            current += step;
            if (current < target) {
                counter.textContent = Math.floor(current) + suffix;
                requestAnimationFrame(update);
            } else {
                counter.textContent = target + suffix;
            }
        }
        update();
    });
}

// 3. Form handling
document.addEventListener('DOMContentLoaded', function() {
    var forms = document.querySelectorAll("form");
    forms.forEach(function(form) {
        form.addEventListener("submit", function() {
            var btn = form.querySelector("button[type='submit']");
            if (btn) {
                btn.innerHTML = "Procesando...";
                btn.style.opacity = "0.7";
                btn.style.pointerEvents = "none";
            }
        });
    });
});

// Initialize Typewriter
var typedTextSpan = document.getElementById("typed-text");
if (typedTextSpan) {
    type();
}

// Scroll Reveal Observer
var revealElements = document.querySelectorAll('.reveal, .reveal-stagger');
if (revealElements.length > 0) {
    var revealCallback = function(entries, observer) {
        entries.forEach(function(entry) {
            if (entry.isIntersecting) {
                entry.target.classList.add('active');
                if (entry.target.id === 'stats-section') {
                    animateCounters();
                }
            }
        });
    };

    var revealObserver = new IntersectionObserver(revealCallback, {
        root: null,
        threshold: 0.05
    });

    revealElements.forEach(function(el) {
        revealObserver.observe(el);
    });
}

// Lazy load images
document.addEventListener('DOMContentLoaded', function() {
    var lazyImages = document.querySelectorAll('img[loading="lazy"]');
    if ('loading' in HTMLImageElement.prototype) {
        lazyImages.forEach(function(img) {
            img.src = img.dataset.src || img.src;
        });
    }
});
