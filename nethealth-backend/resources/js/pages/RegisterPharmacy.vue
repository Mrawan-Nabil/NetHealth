<script setup>
import { Link, router } from '@inertiajs/vue3';
import { toTypedSchema } from '@vee-validate/zod';
import { useForm, useField } from 'vee-validate';
import { ref } from 'vue';
import { z } from 'zod';
import AuthLayout from '@/layouts/AuthLayout.vue';
import BaseInput from '../components/base/BaseInput.vue';
import BaseSelect from '../components/base/BaseSelect.vue';
import PhoneInput from '../components/base/PhoneInput.vue';
import MultiStepForm from '../components/MultiStepForm.vue';

const STEPS = ['Admin Account', 'Admin Details', 'Pharmacy Profile'];

const STEP_FIELDS = [
    ['firstName', 'secondName', 'email', 'password', 'confirmPassword'],
    ['phone', 'dateOfBirth', 'gender', 'governorate', 'nationalId'],
    ['pharmacyName', 'pharmacyPhone', 'pharmacyAddress', 'pharmacyGovernorate', 'licenseNumber', 'commercialRegistrationNumber', 'taxId'],
];

const GENDER_OPTIONS = [
    { value: 'male', label: 'Male' },
    { value: 'female', label: 'Female' },
];

const GOVERNORATE_OPTIONS = [
    { value: 'alexandria', label: 'Alexandria' },
    { value: 'assiut', label: 'Assiut' },
    { value: 'aswan', label: 'Aswan' },
    { value: 'beheira', label: 'Beheira' },
    { value: 'beni_suef', label: 'Beni Suef' },
    { value: 'cairo', label: 'Cairo' },
    { value: 'daqahlia', label: 'Dakahlia' },
    { value: 'damietta', label: 'Damietta' },
    { value: 'fayoum', label: 'Fayoum' },
    { value: 'gharbia', label: 'Gharbia' },
    { value: 'giza', label: 'Giza' },
    { value: 'ismailia', label: 'Ismailia' },
    { value: 'kafr_el_sheikh', label: 'Kafr El Sheikh' },
    { value: 'luxor', label: 'Luxor' },
    { value: 'matrouh', label: 'Matrouh' },
    { value: 'menoufia', label: 'Menoufia' },
    { value: 'minya', label: 'Minya' },
    { value: 'new_valley', label: 'New Valley' },
    { value: 'north_sinai', label: 'North Sinai' },
    { value: 'port_said', label: 'Port Said' },
    { value: 'qalyubia', label: 'Qalyubia' },
    { value: 'qena', label: 'Qena' },
    { value: 'red_sea', label: 'Red Sea' },
    { value: 'sharqia', label: 'Sharqia' },
    { value: 'sohag', label: 'Sohag' },
    { value: 'south_sinai', label: 'South Sinai' },
    { value: 'suez', label: 'Suez' },
];

const pharmacySchema = z
    .object({
        // Admin Info
        firstName: z.string().min(1, 'First name is required'),
        secondName: z.string().min(1, 'Second name is required'),
        email: z.string().min(1, 'Email is required').email('Please enter a valid email'),
        password: z.string().min(8, 'Password must be at least 8 characters'),
        confirmPassword: z.string().min(1, 'Please confirm your password'),
        phone: z.string().min(1, 'Admin phone is required').regex(/^\+\d+$/, 'Enter a valid phone number'),
        dateOfBirth: z.string().min(1, 'Date of birth is required'),
        gender: z.string().min(1, 'Please select gender'),
        governorate: z.string().min(1, 'Please select admin governorate'),
        nationalId: z.string().min(1, 'National ID is required'),

        // Pharmacy Info
        pharmacyName: z.string().min(1, 'Pharmacy name is required'),
        pharmacyPhone: z.string().min(1, 'Pharmacy phone is required'),
        pharmacyAddress: z.string().min(1, 'Pharmacy address is required'),
        pharmacyGovernorate: z.string().min(1, 'Please select pharmacy governorate'),
        licenseNumber: z.string().min(1, 'Ministry of Health License is required'),
        commercialRegistrationNumber: z.string().min(1, 'Commercial Registration Number is required'), // MANDATORY NOW
        taxId: z.string().min(1, 'Tax ID is required'), // MANDATORY NOW
    })
    .refine((data) => data.password === data.confirmPassword, {
        message: 'Passwords do not match',
        path: ['confirmPassword'],
    });

const { validateField, setFieldError } = useForm({
    validationSchema: toTypedSchema(pharmacySchema),
    initialValues: {
        firstName: '', secondName: '', email: '', password: '', confirmPassword: '',
        phone: '', dateOfBirth: '', gender: '', governorate: '', nationalId: '',
        pharmacyName: '', pharmacyPhone: '', pharmacyAddress: '', pharmacyGovernorate: '',
        licenseNumber: '', commercialRegistrationNumber: '', taxId: ''
    },
});

const fieldOpts = { validateOnBlur: true, validateOnValueUpdate: false };

// Admin Fields
const { value: firstName, errorMessage: firstNameError } = useField('firstName', undefined, fieldOpts);
const { value: secondName, errorMessage: secondNameError } = useField('secondName', undefined, fieldOpts);
const { value: email, errorMessage: emailError } = useField('email', undefined, fieldOpts);
const { value: password, errorMessage: passwordError } = useField('password', undefined, fieldOpts);
const { value: confirmPassword, errorMessage: confirmPasswordError } = useField('confirmPassword', undefined, fieldOpts);
const { value: phone, errorMessage: phoneError } = useField('phone', undefined, fieldOpts);
const { value: dateOfBirth, errorMessage: dateOfBirthError } = useField('dateOfBirth', undefined, fieldOpts);
const { value: gender, errorMessage: genderError } = useField('gender', undefined, fieldOpts);
const { value: governorate, errorMessage: governorateError } = useField('governorate', undefined, fieldOpts);
const { value: nationalId, errorMessage: nationalIdError } = useField('nationalId', undefined, fieldOpts);

// Pharmacy Fields
const { value: pharmacyName, errorMessage: pharmacyNameError } = useField('pharmacyName', undefined, fieldOpts);
const { value: pharmacyPhone, errorMessage: pharmacyPhoneError } = useField('pharmacyPhone', undefined, fieldOpts);
const { value: pharmacyAddress, errorMessage: pharmacyAddressError } = useField('pharmacyAddress', undefined, fieldOpts);
const { value: pharmacyGovernorate, errorMessage: pharmacyGovernorateError } = useField('pharmacyGovernorate', undefined, fieldOpts);
const { value: licenseNumber, errorMessage: licenseNumberError } = useField('licenseNumber', undefined, fieldOpts);
const { value: commercialRegistrationNumber, errorMessage: commercialRegistrationNumberError } = useField('commercialRegistrationNumber', undefined, fieldOpts);
const { value: taxId, errorMessage: taxIdError } = useField('taxId', undefined, fieldOpts);

const currentStep = ref(0);
const showPassword = ref(false);
const showConfirmPassword = ref(false);

// File upload refs
const verificationFiles = ref([]);
const dropzoneInput = ref(null);
const MAX_FILE_SIZE = 10 * 1024 * 1024;

async function validateCurrentStep(stepIndex) {
    const fields = STEP_FIELDS[stepIndex] ?? [];
    for (const name of fields) {
        const { valid } = await validateField(name);
        if (!valid) return false;
    }
    return true;
}

function onFileChange(event) {
    const files = Array.from(event.target.files || []);
    addValidFiles(files);
}

function removeFile(index) {
    verificationFiles.value = verificationFiles.value.filter((_, i) => i !== index);
    if (dropzoneInput.value) dropzoneInput.value.value = '';
}

function triggerDropzone() {
    dropzoneInput.value?.click();
}

function onDrop(event) {
    event.preventDefault();
    const files = Array.from(event.dataTransfer?.files || []);
    addValidFiles(files);
}

function addValidFiles(files) {
    const validFiles = files.filter((file) => {
        if (file.size > MAX_FILE_SIZE) {
            alert(`The file "${file.name}" is too large. Maximum allowed size is 10MB.`);
            return false;
        }
        return true;
    });
    if (validFiles.length) {
        verificationFiles.value = [...verificationFiles.value, ...validFiles];
    }
}

function onDragover(event) {
    event.preventDefault();
}

function onSubmit() {
    const payload = {
        // Admin Payload
        full_name: `${firstName.value.trim()} ${secondName.value.trim()}`,
        email: email.value,
        phone: phone.value,
        gender: gender.value,
        date_of_birth: dateOfBirth.value,
        governorate: governorate.value,
        national_id: nationalId.value,
        password: password.value,
        password_confirmation: confirmPassword.value,

        // Pharmacy Payload
        pharmacy_name: pharmacyName.value,
        pharmacy_phone: pharmacyPhone.value,
        pharmacy_address: pharmacyAddress.value,
        pharmacy_governorate: pharmacyGovernorate.value,
        license_number: licenseNumber.value,
        commercial_registration_number: commercialRegistrationNumber.value, // MANDATORY NOW
        tax_id: taxId.value, // MANDATORY NOW
        verification_documents: verificationFiles.value,
    };

    router.post('/register/pharmacy', payload, {
        onError: (errors) => {
            console.log('Backend Validation Errors:', errors);

            // Map Admin Errors
            if (errors.full_name) setFieldError('firstName', errors.full_name);
            if (errors.email) setFieldError('email', errors.email);
            if (errors.phone) setFieldError('phone', errors.phone);
            if (errors.password) setFieldError('password', errors.password);
            if (errors.national_id) setFieldError('nationalId', errors.national_id);
            if (errors.date_of_birth) setFieldError('dateOfBirth', errors.date_of_birth);
            if (errors.gender) setFieldError('gender', errors.gender);
            if (errors.governorate) setFieldError('governorate', errors.governorate);

            // Map Pharmacy Errors
            if (errors.pharmacy_name) setFieldError('pharmacyName', errors.pharmacy_name);
            if (errors.pharmacy_phone) setFieldError('pharmacyPhone', errors.pharmacy_phone);
            if (errors.pharmacy_address) setFieldError('pharmacyAddress', errors.pharmacy_address);
            if (errors.pharmacy_governorate) setFieldError('pharmacyGovernorate', errors.pharmacy_governorate);
            if (errors.license_number) setFieldError('licenseNumber', errors.license_number);
            if (errors.commercial_registration_number) setFieldError('commercialRegistrationNumber', errors.commercial_registration_number);
            if (errors.tax_id) setFieldError('taxId', errors.tax_id);

            // Auto-navigate to step
            if (errors.email || errors.password || errors.full_name) {
                currentStep.value = 0;
            } else if (errors.phone || errors.date_of_birth || errors.governorate || errors.national_id || errors.gender) {
                currentStep.value = 1;
            } else if (errors.pharmacy_name || errors.license_number || errors.verification_documents || errors.pharmacy_phone || errors.pharmacy_address || errors.commercial_registration_number || errors.tax_id) {
                currentStep.value = 2;
            }
        },
    });
}

function onFinish() {
    onSubmit();
}
</script>

<template>
    <AuthLayout>
        <Transition name="page-fade" appear>
            <div class="space-y-6">
                <div class="text-center">
                    <h1 class="text-2xl font-bold text-gray-900">Register Pharmacy</h1>
                    <p class="mt-1 text-sm text-gray-600">Create your admin account and register your business</p>
                </div>

                <MultiStepForm v-model:step="currentStep" :steps="STEPS" :validate-step="validateCurrentStep" @finish="onFinish">
                    <template #default="{ stepIndex }">
                        <Transition
                            enter-active-class="step-enter-active"
                            leave-active-class="step-leave-active"
                            enter-from-class="step-enter-from"
                            leave-to-class="step-leave-to"
                            mode="out-in"
                        >
                            <div :key="stepIndex">
                                <form v-if="stepIndex === 0" class="grid grid-cols-2 gap-4" @submit.prevent>
                                    <BaseInput v-model="firstName" label="Admin First Name" placeholder="First name" :error="firstNameError" class="col-span-1" />
                                    <BaseInput v-model="secondName" label="Admin Second Name" placeholder="Second name" :error="secondNameError" class="col-span-1" />
                                    <BaseInput v-model="email" label="Admin Email" type="email" placeholder="you@example.com" :error="emailError" class="col-span-2" />
                                    <BaseInput v-model="password" :type="showPassword ? 'text' : 'password'" label="Password" placeholder="••••••••" :error="passwordError" class="col-span-2">
                                        <template #icon>
                                            <button type="button" class="rounded p-1 text-gray-500 transition-all hover:scale-[1.03] active:scale-95" @click="showPassword = !showPassword">
                                                <svg v-if="showPassword" class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21"/></svg>
                                                <svg v-else class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/></svg>
                                            </button>
                                        </template>
                                    </BaseInput>
                                    <BaseInput v-model="confirmPassword" :type="showConfirmPassword ? 'text' : 'password'" label="Confirm Password" placeholder="••••••••" :error="confirmPasswordError" class="col-span-2">
                                        <template #icon>
                                            <button type="button" class="rounded p-1 text-gray-500 transition-all hover:scale-[1.03] active:scale-95" @click="showConfirmPassword = !showConfirmPassword">
                                                <svg v-if="showConfirmPassword" class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21"/></svg>
                                                <svg v-else class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/></svg>
                                            </button>
                                        </template>
                                    </BaseInput>
                                </form>

                                <form v-else-if="stepIndex === 1" class="grid grid-cols-2 gap-4" @submit.prevent>
                                    <div class="col-span-2">
                                        <PhoneInput v-model="phone" label="Admin Phone" placeholder="1234567890" :error="phoneError" />
                                    </div>
                                    <BaseInput v-model="dateOfBirth" label="Date of Birth" type="date" :error="dateOfBirthError" class="col-span-2" />
                                    <BaseSelect v-model="gender" label="Gender" placeholder="Select gender" :error="genderError" class="col-span-2">
                                        <option v-for="opt in GENDER_OPTIONS" :key="opt.value" :value="opt.value">{{ opt.label }}</option>
                                    </BaseSelect>
                                    <BaseSelect v-model="governorate" label="Admin Governorate" placeholder="Select governorate" :error="governorateError" class="col-span-2">
                                        <option v-for="opt in GOVERNORATE_OPTIONS" :key="opt.value" :value="opt.value">{{ opt.label }}</option>
                                    </BaseSelect>
                                    <BaseInput v-model="nationalId" label="National ID" placeholder="Admin's National ID" :error="nationalIdError" class="col-span-2" />
                                </form>

                                <form v-else-if="stepIndex === 2" class="grid grid-cols-2 gap-4" @submit.prevent>
                                    <BaseInput v-model="pharmacyName" label="Pharmacy Name" placeholder="e.g. Al-Shefaa Pharmacy" :error="pharmacyNameError" class="col-span-2" />

                                    <div class="col-span-2">
                                        <PhoneInput v-model="pharmacyPhone" label="Pharmacy Landline/Phone" placeholder="1234567890" :error="pharmacyPhoneError" />
                                    </div>

                                    <BaseSelect v-model="pharmacyGovernorate" label="Pharmacy Governorate" placeholder="Select governorate" :error="pharmacyGovernorateError" class="col-span-2">
                                        <option v-for="opt in GOVERNORATE_OPTIONS" :key="opt.value" :value="opt.value">{{ opt.label }}</option>
                                    </BaseSelect>

                                    <BaseInput v-model="pharmacyAddress" label="Full Pharmacy Address" placeholder="Street name, building number..." :error="pharmacyAddressError" class="col-span-2" />

                                    <BaseInput v-model="licenseNumber" label="MoH License Number" placeholder="Ministry of Health License" :error="licenseNumberError" class="col-span-2" />

                                    <BaseInput v-model="commercialRegistrationNumber" label="Commercial Registration No." placeholder="السجل التجاري" :error="commercialRegistrationNumberError" class="col-span-1" />
                                    <BaseInput v-model="taxId" label="Tax ID" placeholder="البطاقة الضريبية" :error="taxIdError" class="col-span-1" />

                                    <div class="col-span-2">
                                        <label class="mb-1.5 block text-sm font-medium text-gray-700">Verification Documents (MoH License, Syndicate ID)</label>
                                        <input ref="dropzoneInput" type="file" multiple accept=".pdf,.jpg,.jpeg,.png" class="hidden" @change="onFileChange" />
                                        <button type="button" class="flex w-full flex-col items-center justify-center rounded-xl border-2 border-dashed border-gray-300 bg-gray-50/50 py-8 text-gray-600 transition-all duration-200 hover:scale-[1.01] hover:border-primary hover:bg-primary/5 hover:text-primary focus:ring-2 focus:ring-primary/30 focus:outline-none" @click="triggerDropzone" @dragover="onDragover" @drop="onDrop">
                                            <svg class="mb-2 h-10 w-10 text-gray-400 transition-colors duration-200" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
                                            </svg>
                                            <span class="text-sm font-medium">Drop files here or click to upload</span>
                                            <span class="mt-1 text-xs text-gray-500">PDF, JPG, PNG</span>
                                        </button>
                                        <TransitionGroup name="file-list" tag="ul" class="mt-3 space-y-2">
                                            <li v-for="(file, index) in verificationFiles" :key="index" class="flex items-center gap-2 rounded-lg border border-gray-200 bg-white px-3 py-2 text-sm transition-all hover:border-primary/30 hover:shadow-sm">
                                                <svg class="h-5 w-5 shrink-0 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                                                </svg>
                                                <span class="min-w-0 flex-1 truncate text-gray-700">{{ file.name }}</span>
                                                <button type="button" class="shrink-0 text-gray-400 transition-colors duration-200 hover:text-red-600" aria-label="Remove file" @click.stop="removeFile(index)">
                                                    <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg>
                                                </button>
                                            </li>
                                        </TransitionGroup>
                                    </div>
                                </form>
                            </div>
                        </Transition>
                    </template>
                </MultiStepForm>

                <p class="text-center text-sm text-gray-600">
                    Already registered?
                    <Link href="/login" class="font-medium text-primary transition-colors duration-200 hover:text-primary/80 hover:underline">Login</Link>
                </p>
            </div>
        </Transition>
    </AuthLayout>
</template>

<style scoped>
.page-fade-enter-active { transition: opacity 0.5s ease, transform 0.5s ease; }
.page-fade-enter-from { opacity: 0; transform: translateY(20px); }
.step-enter-active, .step-leave-active { transition: opacity 0.3s ease, transform 0.3s ease; }
.step-enter-from { opacity: 0; transform: translateX(30px); }
.step-leave-to { opacity: 0; transform: translateX(-30px); }
.file-list-enter-active, .file-list-leave-active { transition: all 0.2s ease; }
.file-list-enter-from { opacity: 0; transform: scale(0.9); }
.file-list-leave-to { opacity: 0; transform: scale(0.8); }
.file-list-leave-active { position: absolute; width: 100%; }
.file-list-move { transition: transform 0.2s ease; }
input:focus, select:focus, textarea:focus { outline: none; box-shadow: 0 0 0 2px rgba(59, 130, 246, 0.3); border-color: #3b82f6; }
</style>
