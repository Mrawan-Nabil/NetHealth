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

const STEPS = ['Account Setup', 'Personal Details', 'Medical Profile'];

const STEP_FIELDS = [
    ['firstName', 'secondName', 'email', 'password', 'confirmPassword'],
    ['phone', 'dateOfBirth', 'gender', 'governorate', 'nationalId'],
    ['bloodType', 'allergies', 'chronicConditions', 'emergencyContactName', 'emergencyContactPhone'],
];

const GENDER_OPTIONS = [
    { value: 'male', label: 'Male' },
    { value: 'female', label: 'Female' },
    { value: 'other', label: 'Other' },
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

const BLOOD_TYPE_OPTIONS = [
    { value: 'A+', label: 'A+' },
    { value: 'A-', label: 'A-' },
    { value: 'B+', label: 'B+' },
    { value: 'B-', label: 'B-' },
    { value: 'AB+', label: 'AB+' },
    { value: 'AB-', label: 'AB-' },
    { value: 'O+', label: 'O+' },
    { value: 'O-', label: 'O-' },
];

const patientSchema = z
    .object({
        firstName: z.string().min(1, 'First name is required'),
        secondName: z.string().min(1, 'Second name is required'),
        email: z.string().min(1, 'Email is required').email('Please enter a valid email'),
        password: z.string().min(8, 'Password must be at least 8 characters'),
        confirmPassword: z.string().min(1, 'Please confirm your password'),
        phone: z.string().min(1, 'Phone is required'),
        dateOfBirth: z.string().min(1, 'Date of birth is required'),
        gender: z.string().min(1, 'Please select gender'),
        governorate: z.string().min(1, 'Please select governorate'),
        nationalId: z.string().min(1, 'National ID is required'),
        bloodType: z.string().nullable(),
        allergies: z.string().nullable(),
        chronicConditions: z.string().nullable(),
        emergencyContactName: z.string().nullable(),
        emergencyContactPhone: z.string().nullable(),
    })
    .refine((data) => data.password === data.confirmPassword, {
        message: 'Passwords do not match',
        path: ['confirmPassword'],
    });

// Destructure setFieldError to handle Laravel errors
const { validateField, setFieldError } = useForm({
    validationSchema: toTypedSchema(patientSchema),
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
        bloodType: '',
        allergies: '',
        chronicConditions: '',
        emergencyContactName: '',
        emergencyContactPhone: '',
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
const { value: bloodType, errorMessage: bloodTypeError } = useField('bloodType', undefined, fieldOpts);
const { value: allergies, errorMessage: allergiesError } = useField('allergies', undefined, fieldOpts);
const { value: chronicConditions, errorMessage: chronicConditionsError } = useField('chronicConditions', undefined, fieldOpts);
const { value: emergencyContactName, errorMessage: emergencyContactNameError } = useField('emergencyContactName', undefined, fieldOpts);
const { value: emergencyContactPhone, errorMessage: emergencyContactPhoneError } = useField('emergencyContactPhone', undefined, fieldOpts);

const currentStep = ref(0);
const showPassword = ref(false);
const showConfirmPassword = ref(false);

async function validateCurrentStep(stepIndex) {
    const fields = STEP_FIELDS[stepIndex] ?? [];
    for (const name of fields) {
        const { valid } = await validateField(name);
        if (!valid) return false;
    }
    return true;
}

function onSubmit() {
    const full_name = `${firstName.value.trim()} ${secondName.value.trim()}`;
    const payload = {
        full_name,
        email: email.value,
        phone: phone.value,
        gender: gender.value,
        date_of_birth: dateOfBirth.value, // Key matched to Laravel update
        governorate: governorate.value,
        national_id: nationalId.value,
        password: password.value,
        password_confirmation: confirmPassword.value, // Required for 'confirmed' rule
        blood_type: bloodType.value,
        allergies: allergies.value || null,
        chronic_conditions: chronicConditions.value || null,
        emergency_contact_name: emergencyContactName.value,
        emergency_contact_phone: emergencyContactPhone.value,
    };

    router.post('/register/patient', payload, {
        onError: (errors) => {
            // Mapping Laravel backend errors to Frontend Vee-Validate fields
            if (errors.email) setFieldError('email', errors.email);
            if (errors.phone) setFieldError('phone', errors.phone);
            if (errors.national_id) setFieldError('nationalId', errors.national_id);
            if (errors.password) setFieldError('password', errors.password);
            if (errors.full_name) setFieldError('firstName', errors.full_name);

            // Auto-navigate to step with error
            if (errors.email || errors.password || errors.full_name) {
                currentStep.value = 0;
            } else if (errors.phone || errors.national_id || errors.date_of_birth) {
                currentStep.value = 1;
            }
        }
    });
}

function onFinish() {
    onSubmit();
}
</script>

<template>
    <AuthLayout>
        <div class="space-y-6">
            <div class="text-center">
                <h1 class="text-2xl font-bold text-gray-900">Create an Account</h1>
                <p class="mt-1 text-sm text-gray-600">Patient registration</p>
            </div>

            <MultiStepForm v-model:step="currentStep" :steps="STEPS" :validate-step="validateCurrentStep" @finish="onFinish">
                <template #default="{ stepIndex }">
                    <form v-if="stepIndex === 0" class="grid grid-cols-2 gap-4" @submit.prevent>
                        <BaseInput v-model="firstName" label="First Name" placeholder="First name" :error="firstNameError" class="col-span-1" />
                        <BaseInput v-model="secondName" label="Second Name" placeholder="Second name" :error="secondNameError" class="col-span-1" />
                        <BaseInput v-model="email" label="Email" type="email" placeholder="you@example.com" :error="emailError" class="col-span-2" />
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
                                    class="rounded p-1 text-gray-500 hover:text-gray-700"
                                    :aria-label="showPassword ? 'Hide password' : 'Show password'"
                                    @click="showPassword = !showPassword"
                                >
                                    <svg v-if="showPassword" class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21" />
                                    </svg>
                                    <svg v-else class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
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
                                    class="rounded p-1 text-gray-500 hover:text-gray-700"
                                    :aria-label="showConfirmPassword ? 'Hide password' : 'Show password'"
                                    @click="showConfirmPassword = !showConfirmPassword"
                                >
                                    <svg v-if="showConfirmPassword" class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21" />
                                    </svg>
                                    <svg v-else class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
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
                            <option v-for="opt in GENDER_OPTIONS" :key="opt.value" :value="opt.value">
                                {{ opt.label }}
                            </option>
                        </BaseSelect>
                        <BaseSelect
                            v-model="governorate"
                            label="Governorate"
                            placeholder="Select governorate"
                            :error="governorateError"
                            class="col-span-2"
                        >
                            <option v-for="opt in GOVERNORATE_OPTIONS" :key="opt.value" :value="opt.value">
                                {{ opt.label }}
                            </option>
                        </BaseSelect>
                        <BaseInput v-model="nationalId" label="National ID" placeholder="National ID" :error="nationalIdError" class="col-span-2" />
                    </form>

                    <form v-else-if="stepIndex === 2" class="grid grid-cols-2 gap-4" @submit.prevent>
                        <BaseSelect v-model="bloodType" label="Blood Type" placeholder="Select blood type" :error="bloodTypeError" class="col-span-2">
                            <option v-for="opt in BLOOD_TYPE_OPTIONS" :key="opt.value" :value="opt.value">
                                {{ opt.label }}
                            </option>
                        </BaseSelect>
                        <div class="col-span-2">
                            <label class="mb-1.5 block text-sm font-medium text-gray-700">Allergies</label>
                            <textarea
                                v-model="allergies"
                                rows="3"
                                placeholder="List any known allergies (optional)"
                                class="w-full rounded-xl border border-gray-300 bg-white px-4 py-2.5 text-gray-900 placeholder-gray-500 transition-shadow focus:border-primary focus:ring-2 focus:ring-primary/30 focus:outline-none"
                                :class="{ 'border-red-500 focus:border-red-500 focus:ring-red-500/30': allergiesError }"
                            />
                            <span v-if="allergiesError" class="mt-1 block text-sm text-red-500">{{ allergiesError }}</span>
                        </div>
                        <div class="col-span-2">
                            <label class="mb-1.5 block text-sm font-medium text-gray-700">Chronic Conditions</label>
                            <textarea
                                v-model="chronicConditions"
                                rows="3"
                                placeholder="List any chronic conditions (optional)"
                                class="w-full rounded-xl border border-gray-300 bg-white px-4 py-2.5 text-gray-900 placeholder-gray-500 transition-shadow focus:border-primary focus:ring-2 focus:ring-primary/30 focus:outline-none"
                                :class="{ 'border-red-500 focus:border-red-500 focus:ring-red-500/30': chronicConditionsError }"
                            />
                            <span v-if="chronicConditionsError" class="mt-1 block text-sm text-red-500">{{ chronicConditionsError }}</span>
                        </div>
                        <BaseInput
                            v-model="emergencyContactName"
                            label="Emergency Contact Name"
                            placeholder="Full name"
                            :error="emergencyContactNameError"
                            class="col-span-2"
                        />
                        <div class="col-span-2">
                            <PhoneInput
                                v-model="emergencyContactPhone"
                                label="Emergency Contact Phone"
                                placeholder="Phone number"
                                :error="emergencyContactPhoneError"
                            />
                        </div>
                    </form>
                </template>
            </MultiStepForm>

            <p class="text-center text-sm text-gray-600">
                Already have an account?
                <Link href="/login" class="font-medium text-primary hover:underline">Login</Link>
            </p>
        </div>
    </AuthLayout>
</template>
