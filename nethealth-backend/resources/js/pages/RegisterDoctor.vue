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

const STEPS = ['Account Setup', 'Personal Details', 'Professional Profile'];

const STEP_FIELDS = [
    ['firstName', 'secondName', 'email', 'password', 'confirmPassword'],
    ['phone', 'dateOfBirth', 'gender', 'governorate', 'nationalId'],
    ['professionalTitle', 'specialty', 'medicalLicenseNumber', 'syndicateId', 'consultationFee', 'experience', 'qualifications'],
];

const GENDER_OPTIONS = [
    { value: 'male', label: 'Male' },
    { value: 'female', label: 'Female' },
    { value: 'other', label: 'Other' },
];

const TITLE_OPTIONS = [
    { value: 'resident', label: 'Resident (نائب)' },
    { value: 'specialist', label: 'Specialist (أخصائي)' },
    { value: 'consultant', label: 'Consultant (استشاري)' },
    { value: 'professor', label: 'Professor (أستاذ)' },
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

const doctorSchema = z
    .object({
        firstName: z.string().min(1, 'First name is required'),
        secondName: z.string().min(1, 'Second name is required'),
        email: z.string().min(1, 'Email is required').email('Please enter a valid email'),
        password: z.string().min(8, 'Password must be at least 8 characters'),
        confirmPassword: z.string().min(1, 'Please confirm your password'),
        phone: z
            .string()
            .min(1, 'Phone is required')
            .regex(/^\+\d+$/, 'Enter a valid phone number'),
        dateOfBirth: z.string().min(1, 'Date of birth is required'),
        gender: z.string().min(1, 'Please select gender'),
        governorate: z.string().min(1, 'Please select governorate'),
        nationalId: z.string().min(1, 'National ID is required'),

        // Professional Profile Fields
        professionalTitle: z.string().min(1, 'Please select a title'),
        specialty: z.string().min(1, 'Specialty is required'),
        medicalLicenseNumber: z.string().min(1, 'Medical license number is required'),
        syndicateId: z.string().min(1, 'Syndicate ID is required'),
        consultationFee: z
            .string()
            .min(1, 'Fee is required')
            .regex(/^\d+(\.\d{1,2})?$/, 'Enter a valid amount (e.g. 300)'),
        experience: z.string().nullable().optional(),
        qualifications: z.string().nullable().optional(),
    })
    .refine((data) => data.password === data.confirmPassword, {
        message: 'Passwords do not match',
        path: ['confirmPassword'],
    });

const { validateField, setFieldError } = useForm({
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
        nationalId: '',
        professionalTitle: '',
        specialty: '',
        medicalLicenseNumber: '',
        syndicateId: '',
        consultationFee: '',
        experience: '',
        qualifications: '',
    },
});

const fieldOpts = { validateOnBlur: true, validateOnValueUpdate: false };

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

// Doctor specific fields
const { value: professionalTitle, errorMessage: professionalTitleError } = useField('professionalTitle', undefined, fieldOpts);
const { value: specialty, errorMessage: specialtyError } = useField('specialty', undefined, fieldOpts);
const { value: medicalLicenseNumber, errorMessage: medicalLicenseNumberError } = useField('medicalLicenseNumber', undefined, fieldOpts);
const { value: syndicateId, errorMessage: syndicateIdError } = useField('syndicateId', undefined, fieldOpts);
const { value: consultationFee, errorMessage: consultationFeeError } = useField('consultationFee', undefined, fieldOpts);
const { value: experience, errorMessage: experienceError } = useField('experience', undefined, fieldOpts);
const { value: qualifications, errorMessage: qualificationsError } = useField('qualifications', undefined, fieldOpts);

const currentStep = ref(0);
const showPassword = ref(false);
const showConfirmPassword = ref(false);

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
    const full_name = `${firstName.value.trim()} ${secondName.value.trim()}`;
    const payload = {
        full_name,
        email: email.value,
        phone: phone.value,
        gender: gender.value,
        date_of_birth: dateOfBirth.value,
        governorate: governorate.value,
        national_id: nationalId.value,

        professional_title: professionalTitle.value,
        specialty: specialty.value,
        medical_license_number: medicalLicenseNumber.value,
        syndicate_id: syndicateId.value,
        consultation_fee: consultationFee.value,

        experience: experience.value || null,
        qualifications: qualifications.value || null,
        password: password.value,
        password_confirmation: confirmPassword.value,
        verification_documents: verificationFiles.value,
    };

    router.post('/register/doctor', payload, {
        onError: (errors) => {
            console.log('Backend Validation Errors:', errors);

            if (errors.full_name) setFieldError('firstName', errors.full_name);
            if (errors.email) setFieldError('email', errors.email);
            if (errors.phone) setFieldError('phone', errors.phone);
            if (errors.password) setFieldError('password', errors.password);
            if (errors.national_id) setFieldError('nationalId', errors.national_id);
            if (errors.date_of_birth) setFieldError('dateOfBirth', errors.date_of_birth);
            if (errors.gender) setFieldError('gender', errors.gender);
            if (errors.governorate) setFieldError('governorate', errors.governorate);

            if (errors.professional_title) setFieldError('professionalTitle', errors.professional_title);
            if (errors.specialty) setFieldError('specialty', errors.specialty);
            if (errors.medical_license_number) setFieldError('medicalLicenseNumber', errors.medical_license_number);
            if (errors.syndicate_id) setFieldError('syndicateId', errors.syndicate_id);
            if (errors.consultation_fee) setFieldError('consultationFee', errors.consultation_fee);

            if (errors.email || errors.password || errors.full_name) {
                currentStep.value = 0;
            } else if (errors.phone || errors.date_of_birth || errors.governorate || errors.national_id || errors.gender) {
                currentStep.value = 1;
            } else if (
                errors.professional_title ||
                errors.specialty ||
                errors.medical_license_number ||
                errors.syndicate_id ||
                errors.consultation_fee ||
                errors.verification_documents
            ) {
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
                    <h1 class="text-2xl font-bold text-gray-900">Create an Account</h1>
                    <p class="mt-1 text-sm text-gray-600">Doctor registration</p>
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
                                    <BaseInput
                                        v-model="firstName"
                                        label="First Name"
                                        placeholder="First name"
                                        :error="firstNameError"
                                        class="col-span-1"
                                    />
                                    <BaseInput
                                        v-model="secondName"
                                        label="Second Name"
                                        placeholder="Second name"
                                        :error="secondNameError"
                                        class="col-span-1"
                                    />
                                    <BaseInput
                                        v-model="email"
                                        label="Email"
                                        type="email"
                                        placeholder="you@example.com"
                                        :error="emailError"
                                        class="col-span-2"
                                    />
                                    <BaseInput
                                        v-model="password"
                                        :type="showPassword ? 'text' : 'password'"
                                        label="Password"
                                        placeholder="••••••••"
                                        :error="passwordError"
                                        class="col-span-2"
                                    >
                                        <template #icon>
                                            <button
                                                type="button"
                                                class="rounded p-1 text-gray-500 transition-all hover:scale-[1.03] active:scale-95"
                                                @click="showPassword = !showPassword"
                                            >
                                                <svg v-if="showPassword" class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path
                                                        stroke-linecap="round"
                                                        stroke-linejoin="round"
                                                        stroke-width="2"
                                                        d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21"
                                                    />
                                                </svg>
                                                <svg v-else class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path
                                                        stroke-linecap="round"
                                                        stroke-linejoin="round"
                                                        stroke-width="2"
                                                        d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
                                                    />
                                                    <path
                                                        stroke-linecap="round"
                                                        stroke-linejoin="round"
                                                        stroke-width="2"
                                                        d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"
                                                    />
                                                </svg>
                                            </button>
                                        </template>
                                    </BaseInput>
                                    <BaseInput
                                        v-model="confirmPassword"
                                        :type="showConfirmPassword ? 'text' : 'password'"
                                        label="Confirm Password"
                                        placeholder="••••••••"
                                        :error="confirmPasswordError"
                                        class="col-span-2"
                                    >
                                        <template #icon>
                                            <button
                                                type="button"
                                                class="rounded p-1 text-gray-500 transition-all hover:scale-[1.03] active:scale-95"
                                                @click="showConfirmPassword = !showConfirmPassword"
                                            >
                                                <svg v-if="showConfirmPassword" class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path
                                                        stroke-linecap="round"
                                                        stroke-linejoin="round"
                                                        stroke-width="2"
                                                        d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21"
                                                    />
                                                </svg>
                                                <svg v-else class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path
                                                        stroke-linecap="round"
                                                        stroke-linejoin="round"
                                                        stroke-width="2"
                                                        d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
                                                    />
                                                    <path
                                                        stroke-linecap="round"
                                                        stroke-linejoin="round"
                                                        stroke-width="2"
                                                        d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"
                                                    />
                                                </svg>
                                            </button>
                                        </template>
                                    </BaseInput>
                                </form>

                                <form v-else-if="stepIndex === 1" class="grid grid-cols-2 gap-4" @submit.prevent>
                                    <div class="col-span-2">
                                        <PhoneInput v-model="phone" label="Phone" placeholder="1234567890" :error="phoneError" />
                                    </div>
                                    <BaseInput v-model="dateOfBirth" label="Date of Birth" type="date" :error="dateOfBirthError" class="col-span-2" />
                                    <BaseSelect v-model="gender" label="Gender" placeholder="Select gender" :error="genderError" class="col-span-2">
                                        <option v-for="opt in GENDER_OPTIONS" :key="opt.value" :value="opt.value">{{ opt.label }}</option>
                                    </BaseSelect>
                                    <BaseSelect
                                        v-model="governorate"
                                        label="Governorate"
                                        placeholder="Select governorate"
                                        :error="governorateError"
                                        class="col-span-2"
                                    >
                                        <option v-for="opt in GOVERNORATE_OPTIONS" :key="opt.value" :value="opt.value">{{ opt.label }}</option>
                                    </BaseSelect>
                                    <BaseInput
                                        v-model="nationalId"
                                        label="National ID"
                                        placeholder="National ID"
                                        :error="nationalIdError"
                                        class="col-span-2"
                                    />
                                </form>

                                <form v-else-if="stepIndex === 2" class="grid grid-cols-2 gap-4" @submit.prevent>
                                    <BaseSelect
                                        v-model="professionalTitle"
                                        label="Professional Title"
                                        placeholder="Select title"
                                        :error="professionalTitleError"
                                        class="col-span-1"
                                    >
                                        <option v-for="opt in TITLE_OPTIONS" :key="opt.value" :value="opt.value">{{ opt.label }}</option>
                                    </BaseSelect>

                                    <BaseInput
                                        v-model="specialty"
                                        label="Specialty"
                                        placeholder="e.g. Cardiology"
                                        :error="specialtyError"
                                        class="col-span-1"
                                    />

                                    <BaseInput
                                        v-model="medicalLicenseNumber"
                                        label="Medical License No."
                                        placeholder="MoH License"
                                        :error="medicalLicenseNumberError"
                                        class="col-span-1"
                                    />

                                    <BaseInput
                                        v-model="syndicateId"
                                        label="Syndicate ID"
                                        placeholder="رقم النقابة"
                                        :error="syndicateIdError"
                                        class="col-span-1"
                                    />

                                    <BaseInput
                                        v-model="consultationFee"
                                        type="number"
                                        label="Consultation Fee (EGP)"
                                        placeholder="e.g. 300"
                                        :error="consultationFeeError"
                                        class="col-span-2"
                                    />

                                    <div class="col-span-2">
                                        <label class="mb-1.5 block text-sm font-medium text-gray-700">Experience</label>
                                        <textarea
                                            v-model="experience"
                                            rows="3"
                                            placeholder="Describe your professional experience (optional)"
                                            class="w-full rounded-xl border border-gray-300 bg-white px-4 py-2.5 text-gray-900 placeholder-gray-500 transition-all duration-200 focus:border-primary focus:ring-2 focus:ring-primary/30 focus:outline-none"
                                            :class="{ 'border-red-500 focus:border-red-500 focus:ring-red-500/30': experienceError }"
                                        ></textarea>
                                        <span v-if="experienceError" class="mt-1 block text-sm text-red-500">{{ experienceError }}</span>
                                    </div>

                                    <div class="col-span-2">
                                        <label class="mb-1.5 block text-sm font-medium text-gray-700">Qualifications</label>
                                        <textarea
                                            v-model="qualifications"
                                            rows="3"
                                            placeholder="List your qualifications (optional)"
                                            class="w-full rounded-xl border border-gray-300 bg-white px-4 py-2.5 text-gray-900 placeholder-gray-500 transition-all duration-200 focus:border-primary focus:ring-2 focus:ring-primary/30 focus:outline-none"
                                            :class="{ 'border-red-500 focus:border-red-500 focus:ring-red-500/30': qualificationsError }"
                                        ></textarea>
                                        <span v-if="qualificationsError" class="mt-1 block text-sm text-red-500">{{ qualificationsError }}</span>
                                    </div>

                                    <div class="col-span-2">
                                        <label class="mb-1.5 block text-sm font-medium text-gray-700"
                                            >Verification documents (license, degree, CV, etc.)</label
                                        >
                                        <input
                                            ref="dropzoneInput"
                                            type="file"
                                            multiple
                                            accept=".pdf,.jpg,.jpeg,.png"
                                            class="hidden"
                                            @change="onFileChange"
                                        />
                                        <button
                                            type="button"
                                            class="flex w-full flex-col items-center justify-center rounded-xl border-2 border-dashed border-gray-300 bg-gray-50/50 py-8 text-gray-600 transition-all duration-200 hover:scale-[1.01] hover:border-primary hover:bg-primary/5 hover:text-primary focus:ring-2 focus:ring-primary/30 focus:outline-none"
                                            @click="triggerDropzone"
                                            @dragover="onDragover"
                                            @drop="onDrop"
                                        >
                                            <svg
                                                class="mb-2 h-10 w-10 text-gray-400 transition-colors duration-200"
                                                fill="none"
                                                stroke="currentColor"
                                                viewBox="0 0 24 24"
                                            >
                                                <path
                                                    stroke-linecap="round"
                                                    stroke-linejoin="round"
                                                    stroke-width="1.5"
                                                    d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12"
                                                />
                                            </svg>
                                            <span class="text-sm font-medium">Drop files here or click to upload</span>
                                            <span class="mt-1 text-xs text-gray-500">PDF, JPG, PNG</span>
                                        </button>
                                        <TransitionGroup name="file-list" tag="ul" class="mt-3 space-y-2">
                                            <li
                                                v-for="(file, index) in verificationFiles"
                                                :key="index"
                                                class="flex items-center gap-2 rounded-lg border border-gray-200 bg-white px-3 py-2 text-sm transition-all hover:border-primary/30 hover:shadow-sm"
                                            >
                                                <svg class="h-5 w-5 shrink-0 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                                                </svg>
                                                <span class="min-w-0 flex-1 truncate text-gray-700">{{ file.name }}</span>
                                                <button
                                                    type="button"
                                                    class="shrink-0 text-gray-400 transition-colors duration-200 hover:text-red-600"
                                                    aria-label="Remove file"
                                                    @click.stop="removeFile(index)"
                                                >
                                                    <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                        <path
                                                            stroke-linecap="round"
                                                            stroke-linejoin="round"
                                                            stroke-width="2"
                                                            d="M6 18L18 6M6 6l12 12"
                                                        />
                                                    </svg>
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
                    Already have an account?
                    <Link href="/login" class="font-medium text-primary transition-colors duration-200 hover:text-primary/80 hover:underline"
                        >Login</Link
                    >
                </p>
            </div>
        </Transition>
    </AuthLayout>
</template>

<style scoped>
.page-fade-enter-active {
    transition:
        opacity 0.5s ease,
        transform 0.5s ease;
}
.page-fade-enter-from {
    opacity: 0;
    transform: translateY(20px);
}
.step-enter-active,
.step-leave-active {
    transition:
        opacity 0.3s ease,
        transform 0.3s ease;
}
.step-enter-from {
    opacity: 0;
    transform: translateX(30px);
}
.step-leave-to {
    opacity: 0;
    transform: translateX(-30px);
}
.file-list-enter-active,
.file-list-leave-active {
    transition: all 0.2s ease;
}
.file-list-enter-from {
    opacity: 0;
    transform: scale(0.9);
}
.file-list-leave-to {
    opacity: 0;
    transform: scale(0.8);
}
.file-list-leave-active {
    position: absolute;
    width: 100%;
}
.file-list-move {
    transition: transform 0.2s ease;
}
input:focus,
select:focus,
textarea:focus {
    outline: none;
    box-shadow: 0 0 0 2px rgba(59, 130, 246, 0.3);
    border-color: #3b82f6;
}

/* Remove arrows from number inputs in Chrome, Safari, Edge, Opera */
input::-webkit-outer-spin-button,
input::-webkit-inner-spin-button {
    -webkit-appearance: none;
    margin: 0;
}

/* Remove arrows from number inputs in Firefox */
input[type='number'] {
    -moz-appearance: textfield;
}
</style>
