document.addEventListener('DOMContentLoaded', () => {
    console.log('NetHealth Vanilla JS initialized.');

     // 1. Password Toggle Logic (For login.html)
    // ==========================================
    const togglePasswordBtn = document.getElementById('togglePasswordBtn');
    const passwordInput = document.getElementById('password');
    const eyeIconContainer = document.getElementById('eyeIconContainer');

    const eyeOpenSvg = `
        <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21" />
        </svg>
    `;

    const eyeClosedSvg = `
        <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
        </svg>
    `;

    if (togglePasswordBtn && passwordInput && eyeIconContainer) {
        togglePasswordBtn.addEventListener('click', () => {
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);
            
            if (type === 'text') {
                eyeIconContainer.innerHTML = eyeOpenSvg;
            } else {
                eyeIconContainer.innerHTML = eyeClosedSvg;
            }
        });
    }

    // ==========================================
    // 2. Multi-Step Form & Animation Logic
    // ==========================================
    const formSteps = document.querySelectorAll('.form-step');
    const nextBtn = document.getElementById('nextBtn');
    const prevBtn = document.getElementById('prevBtn');
    const submitBtn = document.getElementById('submitBtn');
    const spacer = document.getElementById('spacer');

    if (formSteps.length > 0) {
        let currentStep = 1;
        const totalSteps = formSteps.length;

        function updateFormUI() {
            // 1. Show the correct form section
            formSteps.forEach(step => {
                if (parseInt(step.dataset.step) === currentStep) {
                    step.classList.remove('hidden');
                } else {
                    step.classList.add('hidden');
                }
            });

            // 2. Animate the Progress Stepper
            const stepIndicators = document.querySelectorAll('.step-indicator');
            const progressLine = document.getElementById('progressLine');
            const subProgressBar = document.getElementById('subProgressBar');

            if (stepIndicators.length > 0) {
                stepIndicators.forEach((indicator) => {
                    const stepNum = parseInt(indicator.dataset.stepIndicator);
                    const circle = indicator.querySelector('.step-circle');
                    const label = indicator.querySelector('.step-label');

                    // Reset base classes for animation
                    circle.className = 'w-12 h-12 rounded-full flex items-center justify-center font-bold text-lg transition-colors duration-300 border-2 step-circle';
                    label.className = 'text-sm font-semibold mt-2 step-label transition-colors duration-300';

                    if (stepNum < currentStep) {
                        // Completed Step: Solid Primary Background, White Text
                        circle.classList.add('bg-primary', 'border-primary', 'text-white');
                        label.classList.add('text-gray-900');
                    } else if (stepNum === currentStep) {
                        // Active Step: White Background, Primary Border & Text
                        circle.classList.add('bg-white', 'border-primary', 'text-primary');
                        label.classList.add('text-gray-900');
                    } else {
                        // Future Step: White Background, Gray Border & Text
                        circle.classList.add('bg-white', 'border-gray-300', 'text-gray-400');
                        label.classList.add('text-gray-400');
                    }
                });

                // Animate the thin connecting line behind the circles
                const linePercentage = ((currentStep - 1) / (totalSteps - 1)) * 100;
                if (progressLine) progressLine.style.width = `${linePercentage}%`;

                // Animate the thick progress bar at the bottom
                const barPercentage = (currentStep / totalSteps) * 100;
                if (subProgressBar) subProgressBar.style.width = `${barPercentage}%`;
            }

            // 3. Handle 'Next', 'Previous', and 'Submit' Buttons
            if (currentStep === 1) {
                prevBtn.classList.add('hidden');
                spacer.classList.remove('hidden'); 
                nextBtn.classList.remove('hidden');
                submitBtn.classList.add('hidden');
            } else if (currentStep === totalSteps) {
                prevBtn.classList.remove('hidden');
                spacer.classList.add('hidden');
                nextBtn.classList.add('hidden');
                submitBtn.classList.remove('hidden');
            } else {
                prevBtn.classList.remove('hidden');
                spacer.classList.add('hidden');
                nextBtn.classList.remove('hidden');
                submitBtn.classList.add('hidden');
            }
        }

        // Event Listeners for Buttons
        nextBtn.addEventListener('click', () => {
            if (currentStep < totalSteps) {
                currentStep++;
                updateFormUI();
            }
        });

        prevBtn.addEventListener('click', () => {
            if (currentStep > 1) {
                currentStep--;
                updateFormUI();
            }
        });

        // Initialize UI on load
        updateFormUI();
    }

    // ==========================================
    // 3. File Upload UI Logic (Doctor Registration)
    // ==========================================
    const fileInput = document.getElementById('doctorDocuments');
    const fileListContainer = document.getElementById('fileListContainer');
    
    // We use a DataTransfer object to safely manipulate the FileList
    let dataTransfer = new DataTransfer();

    if (fileInput && fileListContainer) {
        fileInput.addEventListener('change', function() {
            // Add newly selected files to our tracker
            for (let i = 0; i < this.files.length; i++) {
                dataTransfer.items.add(this.files[i]);
            }
            // Update the actual input
            this.files = dataTransfer.files;
            // Redraw the UI
            renderFileList();
        });

        function renderFileList() {
            // Clear current list to prevent duplicates
            fileListContainer.innerHTML = ''; 

            Array.from(dataTransfer.files).forEach((file, index) => {
                // Create the white card container
                const fileItem = document.createElement('div');
                fileItem.className = 'flex items-center justify-between p-3.5 bg-white border border-gray-100 rounded-xl shadow-[0_2px_8px_rgba(0,0,0,0.04)]';
                
                // Left side: Check icon + Filename
                const leftDiv = document.createElement('div');
                leftDiv.className = 'flex items-center gap-3 overflow-hidden';
                
                const checkIcon = `<svg class="w-5 h-5 text-primary flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>`;
                
                const fileNameSpan = document.createElement('span');
                fileNameSpan.className = 'text-sm text-gray-700 truncate';
                fileNameSpan.textContent = file.name;

                leftDiv.innerHTML = checkIcon;
                leftDiv.appendChild(fileNameSpan);

                // Right side: 'X' Remove button
                const removeBtn = document.createElement('button');
                removeBtn.type = 'button';
                removeBtn.className = 'text-gray-400 hover:text-gray-600 transition-colors focus:outline-none ml-2 flex-shrink-0';
                removeBtn.innerHTML = `<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M6 18L18 6M6 6l12 12"></path></svg>`;
                
                // Logic to remove the file when 'X' is clicked
                removeBtn.addEventListener('click', () => {
                    const dt = new DataTransfer();
                    Array.from(dataTransfer.files).forEach((f, i) => {
                        if (i !== index) dt.items.add(f); // Keep everything except the deleted one
                    });
                    dataTransfer = dt;
                    fileInput.files = dataTransfer.files; // Update the real input
                    renderFileList(); // Redraw
                });

                // Assemble the card and add it to the page
                fileItem.appendChild(leftDiv);
                fileItem.appendChild(removeBtn);
                fileListContainer.appendChild(fileItem);
            });
        }
    }
});