<script setup lang="ts">
import { Link, router } from '@inertiajs/vue3';
import { toTypedSchema } from '@vee-validate/zod';
import { useForm, useField } from 'vee-validate';
import { ref } from 'vue';
import { z } from 'zod';
// 1. Updated imports to use the Vite alias and your new folder structure
import BaseInput from '@/components/NetHealth/base/BaseInput.vue';
import BaseSelect from '@/components/NetHealth/base/BaseSelect.vue';
import PhoneInput from '@/components/NetHealth/base/PhoneInput.vue';
import MultiStepForm from '@/components/NetHealth/MultiStepForm.vue';
// 2. Imported 'router' from Inertia to handle the backend submission

const STEPS = ['Account Setup', 'Personal Details', 'Professional Profile'];

const STEP_FIELDS = [
    ['firstName', 'secondName', 'email', 'password', 'confirmPassword'],
    ['phone', 'dateOfBirth', 'gender', 'governorate'],
    ['medicalLicenseNumber', 'specialty', 'experience', 'qualifications'],
];

const GENDER_OPTIONS = [
    { value: 'male', label: 'Male' },
    { value: 'female', label: 'Female' },
    { value: 'other', label: 'Other' },
];

const GOVERNORATE_OPTIONS = [
    { value: 'alexandria', label: 'Alexandria' },
    // ... (keeping your original governorate options to save space)
    { value: 'suez', label: 'Suez' },
];

const doctorSchema = z
    .object({
        firstName: z.string().min(1, 'First name is required'),
        secondName: z.string().min(1, 'Second name is required'),
        email: z
            .string()
            .min(1, 'Email is required')
            .email('Please enter a valid email'),
        password: z.string().min(6, 'Password must be at least 6 characters'),
        confirmPassword: z.string().min(1, 'Please confirm your password'),
        phone: z
            .string()
            .min(1, 'Phone is required')
            .regex(/^\+\d+$/, 'Enter a valid phone number'),
        dateOfBirth: z.string().min(1, 'Date of birth is required'),
        gender: z.string().min(1, 'Please select gender'),
        governorate: z.string().min(1, 'Please select governorate'),
        medicalLicenseNumber: z
            .string()
            .min(1, 'Medical license number is required'),
        specialty: z.string().min(1, 'Specialty is required'),
        experience: z.string().optional(),
        qualifications: z.string().optional(),
    })
    .refine((data) => data.password === data.confirmPassword, {
        message: 'Passwords do not match',
        path: ['confirmPassword'],
    });

const { validateField } = useForm({
    validationSchema: toTypedSchema(doctorSchema),
    initialValues: {
        firstName: '',
        secondName: '',
        email: '',
        password: '',
        confirmPassword: '',
        phone: '',
        dateOfBirth: '',
        gender: '',
        governorate: '',
        medicalLicenseNumber: '',
        specialty: '',
        experience: '',
        qualifications: '',
    },
});

const fieldOpts = { validateOnBlur: true, validateOnValueUpdate: false };

const { value: firstName, errorMessage: firstNameError } = useField(
    'firstName',
    undefined,
    fieldOpts,
);
const { value: secondName, errorMessage: secondNameError } = useField(
    'secondName',
    undefined,
    fieldOpts,
);
const { value: email, errorMessage: emailError } = useField(
    'email',
    undefined,
    fieldOpts,
);
const { value: password, errorMessage: passwordError } = useField(
    'password',
    undefined,
    fieldOpts,
);
const { value: confirmPassword, errorMessage: confirmPasswordError } = useField(
    'confirmPassword',
    undefined,
    fieldOpts,
);
const { value: phone, errorMessage: phoneError } = useField(
    'phone',
    undefined,
    fieldOpts,
);
const { value: dateOfBirth, errorMessage: dateOfBirthError } = useField(
    'dateOfBirth',
    undefined,
    fieldOpts,
);
const { value: gender, errorMessage: genderError } = useField(
    'gender',
    undefined,
    fieldOpts,
);
const { value: governorate, errorMessage: governorateError } = useField(
    'governorate',
    undefined,
    fieldOpts,
);
const { value: medicalLicenseNumber, errorMessage: medicalLicenseNumberError } =
    useField('medicalLicenseNumber', undefined, fieldOpts);
const { value: specialty, errorMessage: specialtyError } = useField(
    'specialty',
    undefined,
    fieldOpts,
);
const { value: experience, errorMessage: experienceError } = useField(
    'experience',
    undefined,
    fieldOpts,
);
const { value: qualifications, errorMessage: qualificationsError } = useField(
    'qualifications',
    undefined,
    fieldOpts,
);

const currentStep = ref(0);
const showPassword = ref(false);
const showConfirmPassword = ref(false);
const verificationFiles = ref([]);
const dropzoneInput = ref(null);

async function validateCurrentStep(stepIndex) {
    const fields = STEP_FIELDS[stepIndex] ?? [];
    for (const name of fields) {
        const { valid } = await validateField(name);
        if (!valid) return false;
    }
    return true;
}

function onFileChange(event) {
    const files = event.target.files;
    if (!files?.length) return;
    verificationFiles.value = [
        ...verificationFiles.value,
        ...Array.from(files),
    ];
}

function removeFile(index) {
    verificationFiles.value = verificationFiles.value.filter(
        (_, i) => i !== index,
    );
    if (dropzoneInput.value) dropzoneInput.value.value = '';
}

function triggerDropzone() {
    dropzoneInput.value?.click();
}

function onDrop(event) {
    event.preventDefault();
    const files = event.dataTransfer?.files;
    if (!files?.length) return;
    verificationFiles.value = [
        ...verificationFiles.value,
        ...Array.from(files),
    ];
}

function onDragover(event) {
    event.preventDefault();
}

// 3. Updated onSubmit to send data to Laravel
function onSubmit() {
    const full_name = `${firstName.value.trim()} ${secondName.value.trim()}`;

    const payload = {
        full_name,
        email: email.value,
        phone: phone.value,
        gender: gender.value,
        date_of_birth: dateOfBirth.value,
        governorate: governorate.value,
        medical_license_number: medicalLicenseNumber.value,
        specialty: specialty.value,
        experience: experience.value || null,
        qualifications: qualifications.value || null,
        password: password.value,
        password_confirmation: confirmPassword.value, // Laravel expects this exact naming convention
        verification_documents: verificationFiles.value,
    };

    // Send the POST request to the Laravel backend using Inertia
    router.post('/register/doctor', payload, {
        preserveScroll: true,
        onError: (errors) => {
            // If Laravel's backend validation fails, errors will show up here
            console.error('Laravel Backend Errors:', errors);
        },
    });
}

function onFinish() {
    onSubmit();
}
</script>

<template>
    <div class="space-y-6">
        <div class="text-center">
            <h1 class="text-2xl font-bold text-gray-900">Create an Account</h1>
            <p class="mt-1 text-sm text-gray-600">Doctor registration</p>
        </div>

        <MultiStepForm
            v-model:step="currentStep"
            :steps="STEPS"
            :validate-step="validateCurrentStep"
            @finish="onFinish"
        >
        </MultiStepForm>

        <p class="text-center text-sm text-gray-600">
            Already have an account?
            <Link href="/login" class="font-medium text-primary hover:underline"
                >Login</Link
            >
        </p>
    </div>
</template>
