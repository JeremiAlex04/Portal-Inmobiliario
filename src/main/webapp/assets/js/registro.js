/**
 * registro.js — Wizard Multi-Paso para Publicación de Propiedad
 * Controla la navegación, validación, animaciones y la interacción
 * del formulario de registro tipo Urbania.
 */

document.addEventListener("DOMContentLoaded", () => {

    // =====================================================
    //  WIZARD STATE
    // =====================================================
    let currentStep = 1;
    const totalSteps = 5;

    const panels = document.querySelectorAll('.wizard-panel');
    const indicators = document.querySelectorAll('.wizard-step-indicator');
    const progressLine = document.getElementById('progress-line');
    const btnPrev = document.getElementById('btn-prev');
    const btnNext = document.getElementById('btn-next');
    const btnSubmit = document.getElementById('btn-submit');
    const wizardForm = document.getElementById('wizard-form');

    // =====================================================
    //  VALIDATION STATE & DYNAMIC BUTTONS
    // =====================================================
    function isStepValid(step) {
        switch (step) {
            case 1: {
                const tipo = document.getElementById('idTipoInmueble').value;
                const op = document.getElementById('idOperacion').value;
                return !!tipo && !!op;
            }
            case 2: {
                const distrito = document.getElementById('idDistrito').value;
                const direccion = document.getElementById('direccion').value.trim();
                return !!distrito && !!direccion;
            }
            case 3: {
                const titulo = document.getElementById('titulo').value.trim();
                const desc = document.getElementById('descripcion').value.trim();
                return !!titulo && !!desc;
            }
            case 4: {
                const precio = document.getElementById('precio').value;
                return !!precio && parseFloat(precio) > 0;
            }
            case 5:
                return true;
        }
        return true;
    }

    function updateNextButtonState() {
        if (!btnNext) return;
        if (isStepValid(currentStep)) {
            btnNext.classList.remove('opacity-40', 'cursor-not-allowed');
            btnNext.classList.add('hover:-translate-y-0.5', 'hover:bg-zinc-800');
        } else {
            btnNext.classList.add('opacity-40', 'cursor-not-allowed');
            btnNext.classList.remove('hover:-translate-y-0.5', 'hover:bg-zinc-800');
        }
    }

    // =====================================================
    //  STEP NAVIGATION
    // =====================================================
    function goToStep(step) {
        if (step < 1 || step > totalSteps) return;

        // Animate out current panel
        const currentPanel = document.querySelector(`.wizard-panel[data-panel="${currentStep}"]`);
        const targetPanel = document.querySelector(`.wizard-panel[data-panel="${step}"]`);

        if (currentPanel) {
            currentPanel.classList.add('wizard-exit');
            currentPanel.classList.remove('active');
            setTimeout(() => {
                currentPanel.style.display = 'none';
            }, 250);
        }

        currentStep = step;

        // Animate in target panel after short delay
        setTimeout(() => {
            panels.forEach(p => {
                p.classList.remove('active', 'wizard-exit');
                p.style.display = 'none';
            });

            if (targetPanel) {
                targetPanel.style.display = 'block';
                // Trigger reflow to restart transition
                targetPanel.offsetHeight;
                targetPanel.classList.add('active');
            }

            // Invalidate Leaflet map on step 2 transition
            if (step === 2 && window.regMap) {
                setTimeout(() => { window.regMap.invalidateSize(); }, 150);
            }
        }, 250);

        updateIndicators();
        updateButtons();
        updateProgressLine();
        updateNextButtonState();

        // Update summary on last step
        if (step === totalSteps) {
            updateSummary();
        }

        // Scroll to top of wizard
        window.scrollTo({ top: 200, behavior: 'smooth' });
    }

    function updateIndicators() {
        indicators.forEach(ind => {
            const step = parseInt(ind.dataset.step);
            const circle = ind.querySelector('.step-circle');
            const label = ind.querySelector('.step-label');

            if (step === currentStep) {
                // Active
                circle.className = 'step-circle w-10 h-10 rounded-full bg-black text-white flex items-center justify-center text-sm font-bold shadow-md ring-4 ring-black/10 transition-all duration-300';
                label.className = 'step-label text-[11px] font-bold mt-2 text-black uppercase tracking-wider';
                restoreStepIcon(circle, step);
            } else if (isStepValid(step)) {
                // Completed & Valid
                circle.className = 'step-circle w-10 h-10 rounded-full bg-black text-white flex items-center justify-center text-sm font-bold shadow-md transition-all duration-300';
                circle.innerHTML = '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M5 13l4 4L19 7"></path></svg>';
                label.className = 'step-label text-[11px] font-bold mt-2 text-black uppercase tracking-wider';
            } else {
                // Inactive / Invalid
                circle.className = 'step-circle w-10 h-10 rounded-full bg-slate-200 text-slate-400 flex items-center justify-center text-sm font-bold transition-all duration-300';
                label.className = 'step-label text-[11px] font-semibold mt-2 text-slate-400 uppercase tracking-wider';
                restoreStepIcon(circle, step);
            }
        });
    }

    function restoreStepIcon(circle, step) {
        const icons = {
            1: '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>',
            2: '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>',
            3: '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"></path></svg>',
            4: '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>',
            5: '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>'
        };
        circle.innerHTML = icons[step] || step;
    }

    function updateButtons() {
        if (btnPrev) {
            btnPrev.style.display = currentStep > 1 ? 'flex' : 'none';
        }
        if (btnNext) {
            btnNext.style.display = currentStep < totalSteps ? 'flex' : 'none';
        }
        if (btnSubmit) {
            btnSubmit.style.display = currentStep === totalSteps ? 'flex' : 'none';
        }
    }

    function updateProgressLine() {
        if (progressLine) {
            const pct = ((currentStep - 1) / (totalSteps - 1)) * 100;
            progressLine.style.width = pct + '%';
        }
    }

    // =====================================================
    //  VALIDATION PER STEP
    // =====================================================
    function validateStep(step) {
        hideAllErrors();

        switch (step) {
            case 1: {
                const tipo = document.getElementById('idTipoInmueble');
                const op = document.getElementById('idOperacion');
                if (!tipo.value || !op.value) {
                    showError('step1-error');
                    return false;
                }
                return true;
            }
            case 2: {
                const distrito = document.getElementById('idDistrito');
                const direccion = document.getElementById('direccion');
                if (!distrito.value || !direccion.value.trim()) {
                    showError('step2-error');
                    return false;
                }
                return true;
            }
            case 3: {
                const titulo = document.getElementById('titulo');
                const desc = document.getElementById('descripcion');
                if (!titulo.value.trim() || !desc.value.trim()) {
                    showError('step3-error');
                    return false;
                }
                return true;
            }
            case 4: {
                const precio = document.getElementById('precio');
                if (!precio.value || parseFloat(precio.value) <= 0) {
                    showError('step4-error');
                    return false;
                }
                return true;
            }
            case 5:
                return true;
        }
        return true;
    }

    function showError(id) {
        const el = document.getElementById(id);
        if (el) {
            el.classList.remove('hidden');
            el.classList.add('wizard-error-shake');
            setTimeout(() => el.classList.remove('wizard-error-shake'), 600);
        }
    }

    function hideAllErrors() {
        document.querySelectorAll('[id^="step"][id$="-error"]').forEach(el => {
            el.classList.add('hidden');
        });
    }

    // =====================================================
    //  BUTTON HANDLERS
    // =====================================================
    if (btnNext) {
        btnNext.addEventListener('click', () => {
            if (validateStep(currentStep)) {
                goToStep(currentStep + 1);
            }
        });
    }

    if (btnPrev) {
        btnPrev.addEventListener('click', () => {
            goToStep(currentStep - 1);
        });
    }

    // Click on step indicator to jump directly (obeying timeline click)
    indicators.forEach(ind => {
        ind.addEventListener('click', () => {
            const targetStep = parseInt(ind.dataset.step);
            goToStep(targetStep);
        });
    });

    // Form submit validation & spinner
    if (wizardForm) {
        wizardForm.addEventListener('submit', (e) => {
            for (let s = 1; s <= totalSteps; s++) {
                if (!isStepValid(s)) {
                    e.preventDefault();
                    goToStep(s);
                    showError(`step${s}-error`);
                    return;
                }
            }
            if (btnSubmit) {
                btnSubmit.innerHTML = '<svg class="animate-spin w-5 h-5 inline mr-2" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path></svg> Procesando...';
                btnSubmit.style.opacity = '0.7';
                btnSubmit.style.pointerEvents = 'none';
            }
        });
    }

    // =====================================================
    //  INPUT LISTENERS FOR NEXT BTN STATE
    // =====================================================
    const inputDistrito = document.getElementById('idDistrito');
    const inputDireccion = document.getElementById('direccion');
    const inputTitulo = document.getElementById('titulo');
    const inputDesc = document.getElementById('descripcion');
    const inputPrecio = document.getElementById('precio');

    if (inputDistrito) inputDistrito.addEventListener('change', updateNextButtonState);
    if (inputDireccion) inputDireccion.addEventListener('input', updateNextButtonState);
    if (inputTitulo) inputTitulo.addEventListener('input', updateNextButtonState);
    if (inputDesc) inputDesc.addEventListener('input', updateNextButtonState);
    if (inputPrecio) inputPrecio.addEventListener('input', updateNextButtonState);

    // =====================================================
    //  CARD SELECTORS (Tipo Inmueble & Operación)
    // =====================================================
    function updateSelectionInfoBanner() {
        const tipoCard = document.querySelector('.tipo-card.selected');
        const opCard = document.querySelector('.operacion-card.selected');
        const banner = document.getElementById('step1-selection-info');
        const tipoText = document.getElementById('selected-tipo-text');
        const opText = document.getElementById('selected-operacion-text');

        if (tipoCard && opCard) {
            if (tipoText) tipoText.textContent = tipoCard.querySelector('span').textContent.trim();
            if (opText) opText.textContent = opCard.querySelector('.text-base').textContent.trim();
            if (banner) banner.classList.remove('hidden');
        } else {
            if (banner) banner.classList.add('hidden');
        }
        updateNextButtonState();
    }

    // Tipo Inmueble Cards
    document.querySelectorAll('.tipo-card').forEach(card => {
        card.addEventListener('click', () => {
            document.querySelectorAll('.tipo-card').forEach(c => c.classList.remove('selected'));
            card.classList.add('selected');
            document.getElementById('idTipoInmueble').value = card.dataset.value;
            hideAllErrors();
            updateSelectionInfoBanner();
        });
    });

    // Operación Cards
    document.querySelectorAll('.operacion-card').forEach(card => {
        card.addEventListener('click', () => {
            document.querySelectorAll('.operacion-card').forEach(c => c.classList.remove('selected'));
            card.classList.add('selected');
            document.getElementById('idOperacion').value = card.dataset.value;
            hideAllErrors();
            updateSelectionInfoBanner();
        });
    });

    // =====================================================
    //  CURRENCY SYMBOL UPDATE
    // =====================================================
    const monedaRadios = document.querySelectorAll('input[name="monedaBase"]');
    const currencySymbol = document.getElementById('currency-symbol');

    monedaRadios.forEach(radio => {
        radio.addEventListener('change', () => {
            if (currencySymbol) {
                currencySymbol.textContent = radio.value === 'USD' ? 'US$' : 'S/.';
            }
        });
    });

    // Set initial currency symbol
    const checkedMoneda = document.querySelector('input[name="monedaBase"]:checked');
    if (checkedMoneda && currencySymbol) {
        currencySymbol.textContent = checkedMoneda.value === 'USD' ? 'US$' : 'S/.';
    }

    // =====================================================
    //  DRAG & DROP PHOTO UPLOAD
    // =====================================================
    const dropZone = document.getElementById('drop-zone');
    const fileInput = document.getElementById('fotoPrincipalInput');
    const previewContainer = document.getElementById('imgPreview');
    const previewImg = document.getElementById('previewImg');
    const removeBtn = document.getElementById('removePreview');

    if (dropZone && fileInput) {
        dropZone.addEventListener('click', () => {
            fileInput.click();
        });

        ['dragenter', 'dragover'].forEach(evt => {
            dropZone.addEventListener(evt, (e) => {
                e.preventDefault();
                e.stopPropagation();
                dropZone.classList.add('drag-active');
            });
        });

        ['dragleave', 'drop'].forEach(evt => {
            dropZone.addEventListener(evt, (e) => {
                e.preventDefault();
                e.stopPropagation();
                dropZone.classList.remove('drag-active');
            });
        });

        dropZone.addEventListener('drop', (e) => {
            const files = e.dataTransfer.files;
            if (files.length > 0) {
                fileInput.files = files;
                showPreview(files[0]);
            }
        });

        fileInput.addEventListener('change', () => {
            if (fileInput.files.length > 0) {
                showPreview(fileInput.files[0]);
            }
        });

        if (removeBtn) {
            removeBtn.addEventListener('click', () => {
                fileInput.value = '';
                if (previewContainer) previewContainer.classList.add('hidden');
            });
        }
    }

    function showPreview(file) {
        if (!file || !previewImg || !previewContainer) return;
        const reader = new FileReader();
        reader.onload = (e) => {
            previewImg.src = e.target.result;
            previewContainer.classList.remove('hidden');
        };
        reader.readAsDataURL(file);
    }

    // =====================================================
    //  SUMMARY UPDATE
    // =====================================================
    function updateSummary() {
        const tipoCard = document.querySelector('.tipo-card.selected');
        const sumTipo = document.getElementById('sum-tipo');
        if (sumTipo) {
            sumTipo.textContent = tipoCard ? tipoCard.querySelector('span').textContent.trim() : '—';
        }

        const opCard = document.querySelector('.operacion-card.selected');
        const sumOp = document.getElementById('sum-operacion');
        if (sumOp) {
            sumOp.textContent = opCard ? opCard.querySelector('.text-base').textContent.trim() : '—';
        }

        const distrito = document.getElementById('idDistrito');
        const sumUbi = document.getElementById('sum-ubicacion');
        if (sumUbi && distrito) {
            const selectedOption = distrito.options[distrito.selectedIndex];
            const dir = document.getElementById('direccion');
            sumUbi.textContent = (dir && dir.value ? dir.value + ', ' : '') + (selectedOption ? selectedOption.text.trim() : '—');
        }

        const titulo = document.getElementById('titulo');
        const sumTit = document.getElementById('sum-titulo');
        if (sumTit) {
            sumTit.textContent = titulo && titulo.value ? titulo.value : '—';
        }

        const precio = document.getElementById('precio');
        const moneda = document.querySelector('input[name="monedaBase"]:checked');
        const sumPrecio = document.getElementById('sum-precio');
        if (sumPrecio) {
            const symbol = moneda && moneda.value === 'PEN' ? 'S/.' : 'US$';
            const val = precio && precio.value ? parseFloat(precio.value).toLocaleString('es-PE', { minimumFractionDigits: 2 }) : '—';
            sumPrecio.textContent = val !== '—' ? symbol + ' ' + val : '—';
        }
    }

    // =====================================================
    //  LEAFLET MAP
    // =====================================================
    const mapContainer = document.getElementById('registro-map');
    if (mapContainer) {
        const defaultLat = -12.046374;
        const defaultLng = -77.042793;

        const latInput = document.getElementById('latitud');
        const lngInput = document.getElementById('longitud');

        const savedLat = latInput ? latInput.value : '';
        const savedLng = lngInput ? lngInput.value : '';

        const initialLat = savedLat ? parseFloat(savedLat) : defaultLat;
        const initialLng = savedLng ? parseFloat(savedLng) : defaultLng;
        const initialZoom = savedLat ? 16 : 13;

        window.regMap = L.map('registro-map').setView([initialLat, initialLng], initialZoom);
        L.tileLayer('https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=8IyYWrIbuDLsiINCC7Du', {
            attribution: '&copy; MapTiler &copy; OpenStreetMap contributors'
        }).addTo(window.regMap);

        let marker;

        function updateCoords(lat, lng) {
            if (latInput) latInput.value = lat;
            if (lngInput) lngInput.value = lng;
            const display = document.getElementById('coordenadas-display');
            if (display) display.textContent = lat.toFixed(6) + ", " + lng.toFixed(6);
        }

        if (savedLat && savedLng) {
            marker = L.marker([initialLat, initialLng], { draggable: true }).addTo(window.regMap);
            const display = document.getElementById('coordenadas-display');
            if (display) display.textContent = initialLat.toFixed(6) + ", " + initialLng.toFixed(6);

            marker.on('dragend', function () {
                const position = marker.getLatLng();
                updateCoords(position.lat, position.lng);
            });
        }

        window.regMap.on('click', function (e) {
            updateCoords(e.latlng.lat, e.latlng.lng);

            if (marker) {
                marker.setLatLng(e.latlng);
            } else {
                marker = L.marker(e.latlng, { draggable: true }).addTo(window.regMap);
                marker.on('dragend', function () {
                    const position = marker.getLatLng();
                    updateCoords(position.lat, position.lng);
                });
            }
        });
    }

    // =====================================================
    //  INITIALIZE
    // =====================================================
    // Set initial display styles explicitly for all panels
    panels.forEach(p => {
        const stepNum = parseInt(p.dataset.panel);
        if (stepNum === currentStep) {
            p.style.display = 'block';
            p.classList.add('active');
        } else {
            p.style.display = 'none';
            p.classList.remove('active');
        }
    });

    updateButtons();
    updateProgressLine();
    updateSelectionInfoBanner();
    updateIndicators();
});
