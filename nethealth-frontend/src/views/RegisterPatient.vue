<script setup>
import { ref, onMounted } from 'vue'
import { useForm, useField } from 'vee-validate'
import { toTypedSchema } from '@vee-validate/zod'
import { z } from 'zod'
import BaseInput from '../components/base/BaseInput.vue'
import BaseButton from '../components/base/BaseButton.vue'
import BaseSelect from '../components/base/BaseSelect.vue'
import PhoneInput from '../components/base/PhoneInput.vue'
import MultiStepForm from '../components/MultiStepForm.vue'
import { RouterLink } from 'vue-router'
import netHealthLogo from '../assets/logo.png'

const isVisible = ref(false)

const STEPS = ['Account Setup', 'Personal Details', 'Medical Profile']

const STEP_FIELDS = [
  ['firstName', 'secondName', 'email', 'password', 'confirmPassword'],
  ['phone', 'dateOfBirth', 'gender', 'governorate', 'nationalId'],
  ['bloodType', 'allergies', 'chronicConditions', 'emergencyContactName', 'emergencyContactPhone'],
]

const GENDER_OPTIONS = [
  { value: 'male', label: 'Male' },
  { value: 'female', label: 'Female' },
  { value: 'other', label: 'Other' },
]

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
]

const BLOOD_TYPE_OPTIONS = [
  { value: 'A+', label: 'A+' },
  { value: 'A-', label: 'A-' },
  { value: 'B+', label: 'B+' },
  { value: 'B-', label: 'B-' },
  { value: 'AB+', label: 'AB+' },
  { value: 'AB-', label: 'AB-' },
  { value: 'O+', label: 'O+' },
  { value: 'O-', label: 'O-' },
]
const patientSchema = z
  .object({
    firstName: z.string().min(1, 'First name is required'),
    secondName: z.string().min(1, 'Second name is required'),
    email: z.string().min(1, 'Email is required').email('Please enter a valid email'),
    password: z.string().min(6, 'Password must be at least 6 characters'),
    confirmPassword: z.string().min(1, 'Please confirm your password'),
    phone: z.string().min(1, 'Phone is required').regex(/^\+\d+$/, 'Enter a valid phone number'),
    dateOfBirth: z.string().min(1, 'Date of birth is required'),
    gender: z.string().min(1, 'Please select gender'),
    governorate: z.string().min(1, 'Please select governorate'),
    nationalId: z.string().min(1, 'National ID is required'),
    bloodType: z.string().min(1, 'Please select blood type'),
    allergies: z.string(),
    chronicConditions: z.string(),
    emergencyContactName: z.string().min(1, 'Emergency contact name is required'),
    emergencyContactPhone: z.string().min(1, 'Emergency contact phone is required').regex(/^\+\d+$/, 'Enter a valid phone number'),
  })
  .refine((data) => data.password === data.confirmPassword, {
    message: 'Passwords do not match',
    path: ['confirmPassword'],
  })

const { validateField } = useForm({
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
})

const fieldOpts = { validateOnBlur: true, validateOnValueUpdate: false }

const { value: firstName, errorMessage: firstNameError } = useField('firstName', undefined, fieldOpts)
const { value: secondName, errorMessage: secondNameError } = useField('secondName', undefined, fieldOpts)
const { value: email, errorMessage: emailError } = useField('email', undefined, fieldOpts)
const { value: password, errorMessage: passwordError } = useField('password', undefined, fieldOpts)
const { value: confirmPassword, errorMessage: confirmPasswordError } = useField('confirmPassword', undefined, fieldOpts)
const { value: phone, errorMessage: phoneError } = useField('phone', undefined, fieldOpts)
const { value: dateOfBirth, errorMessage: dateOfBirthError } = useField('dateOfBirth', undefined, fieldOpts)
const { value: gender, errorMessage: genderError } = useField('gender', undefined, fieldOpts)
const { value: governorate, errorMessage: governorateError } = useField('governorate', undefined, fieldOpts)
const { value: nationalId, errorMessage: nationalIdError } = useField('nationalId', undefined, fieldOpts)
const { value: bloodType, errorMessage: bloodTypeError } = useField('bloodType', undefined, fieldOpts)
const { value: allergies, errorMessage: allergiesError } = useField('allergies', undefined, fieldOpts)
const { value: chronicConditions, errorMessage: chronicConditionsError } = useField('chronicConditions', undefined, fieldOpts)
const { value: emergencyContactName, errorMessage: emergencyContactNameError } = useField('emergencyContactName', undefined, fieldOpts)
const { value: emergencyContactPhone, errorMessage: emergencyContactPhoneError } = useField('emergencyContactPhone', undefined, fieldOpts)

const currentStep = ref(0)
const showPassword = ref(false)
const showConfirmPassword = ref(false)

async function validateCurrentStep(stepIndex) {
  const fields = STEP_FIELDS[stepIndex] ?? []
  for (const name of fields) {
    const { valid } = await validateField(name)
    if (!valid) return false
  }
  return true
}

function onSubmit() {
  const full_name = `${firstName.value.trim()} ${secondName.value.trim()}`
  const payload = {
    full_name,
    email: email.value,
    phone: phone.value,
    gender: gender.value,
    date_of_birth: dateOfBirth.value,
    governorate: governorate.value,
    national_id: nationalId.value,
    password: password.value,
    blood_type: bloodType.value,
    allergies: allergies.value || null,
    chronic_conditions: chronicConditions.value || null,
    emergency_contact_name: emergencyContactName.value,
    emergency_contact_phone: emergencyContactPhone.value,
  }
  console.log('RegisterPatient payload', payload)
}

function onFinish() {
  onSubmit()
}

onMounted(() => {
  isVisible.value = true
})
</script>
<template>
  <div class="min-h-screen relative overflow-hidden">
    <!-- Vibrant Mesh Gradient Background -->
    <div class="absolute inset-0 bg-gradient-to-br from-purple-600 via-pink-500 to-blue-600"></div>
    <div class="absolute inset-0 bg-gradient-to-tl from-cyan-400 via-purple-500 to-pink-600 opacity-70"></div>
    <div class="absolute inset-0 bg-gradient-to-r from-blue-500 via-purple-600 to-pink-500 opacity-50"></div>
    
    <!-- Animated Background Elements -->
    <div class="absolute top-20 left-20 w-72 h-72 bg-white/10 rounded-full blur-3xl animate-pulse"></div>
    <div class="absolute bottom-20 right-20 w-96 h-96 bg-pink-300/20 rounded-full blur-3xl animate-pulse" style="animation-delay: 1s;"></div>
    <div class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-80 h-80 bg-blue-300/15 rounded-full blur-3xl animate-pulse" style="animation-delay: 2s;"></div>

    <div class="relative min-h-screen flex items-center justify-center py-12 px-6 lg:px-8">
      <div class="w-full max-w-4xl">
        <!-- Header Section -->
        <div 
          :class="[
            'text-center mb-12 transition-all duration-1000 ease-out',
            isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-8'
          ]"
        >
          <!-- Back Button -->
          <div class="flex justify-start mb-8">
            <RouterLink
              :to="{ name: 'RegisterRole' }"
              class="inline-flex items-center gap-2 text-sm font-medium text-white/80 hover:text-white transition-all duration-300 group"
            >
              <svg class="w-4 h-4 transition-transform duration-300 group-hover:-translate-x-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
              </svg>
              Back to Account Types
            </RouterLink>
          </div>

          <!-- Logo -->
          <div class="mb-8">
            <img :src="netHealthLogo" alt="NetHealth" class="h-12 w-auto mx-auto" />
          </div>

          <!-- Badge -->
          <div class="inline-flex items-center gap-2 rounded-full bg-white/10 backdrop-blur-sm px-6 py-3 text-sm font-medium text-white mb-8 border border-white/20 shadow-sm">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
            </svg>
            Patient Registration
          </div>

          <!-- Main heading -->
          <h1 class="text-4xl font-bold tracking-tight text-white sm:text-5xl mb-6 leading-tight">
            <span class="text-white">Create Your</span>
            <span class="block text-white/90">Patient Account</span>
          </h1>
          
          <!-- Subheading -->
          <p class="text-lg text-white/80 leading-relaxed max-w-2xl mx-auto">
            Join thousands of patients who trust our platform for their healthcare journey. Secure, simple, and designed for you.
          </p>
        </div>

        <!-- Main Form Container -->
        <div 
          :class="[
            'glass-container backdrop-blur-[15px] bg-white/10 border border-white/20 rounded-3xl p-8 sm:p-12 shadow-2xl shadow-black/20 transition-all duration-1000 ease-out',
            isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-8'
          ]"
          style="transition-delay: 0.2s;"
        >
          <MultiStepForm
            v-model:step="currentStep"
            :steps="STEPS"
            :validate-step="validateCurrentStep"
            @finish="onFinish"
          >
            <template #default="{ stepIndex }">
              <transition
                name="step"
                mode="out-in"
              >
                <div :key="stepIndex" class="space-y-8">
                  <!-- Step 1: Account Setup -->
                  <form v-if="stepIndex === 0" class="space-y-8" @submit.prevent>
                    <div class="text-center mb-10">
                      <h2 class="text-3xl font-bold text-white mb-4">Account Setup</h2>
                      <p class="text-lg text-white/80">Let's start with your basic information</p>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-8">
                      <BaseInput 
                        v-model="firstName" 
                        label="First Name" 
                        placeholder="Enter your first name" 
                        :error="firstNameError" 
                      />
                      <BaseInput 
                        v-model="secondName" 
                        label="Last Name" 
                        placeholder="Enter your last name" 
                        :error="secondNameError" 
                      />
                    </div>

                    <BaseInput 
                      v-model="email" 
                      label="Email Address" 
                      type="email" 
                      placeholder="you@example.com" 
                      :error="emailError" 
                    />

                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-8">
                      <BaseInput 
                        v-model="password" 
                        :type="showPassword ? 'text' : 'password'" 
                        label="Password" 
                        placeholder="Create a secure password" 
                        :error="passwordError"
                      >
                        <template #icon>
                          <button 
                            type="button" 
                            class="p-2 text-white/60 hover:text-white transition-colors duration-200 rounded-lg hover:bg-white/10" 
                            @click="showPassword = !showPassword"
                          >
                            <svg v-if="showPassword" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.878 9.878L3 3m6.878 6.878L21 21" />
                            </svg>
                            <svg v-else class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
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
                        placeholder="Confirm your password" 
                        :error="confirmPasswordError"
                      >
                        <template #icon>
                          <button 
                            type="button" 
                            class="p-2 text-white/60 hover:text-white transition-colors duration-200 rounded-lg hover:bg-white/10" 
                            @click="showConfirmPassword = !showConfirmPassword"
                          >
                            <svg v-if="showConfirmPassword" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.878 9.878L3 3m6.878 6.878L21 21" />
                            </svg>
                            <svg v-else class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                            </svg>
                          </button>
                        </template>
                      </BaseInput>
                    </div>

                    <!-- Security Notice -->
                    <div class="security-notice">
                      <div class="flex items-start gap-4">
                        <svg class="w-6 h-6 text-teal-600 dark:text-teal-400 flex-shrink-0 mt-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
                        </svg>
                        <div>
                          <p class="text-base font-semibold text-teal-800 dark:text-teal-200">Your data is secure</p>
                          <p class="text-sm text-teal-700 dark:text-teal-300 mt-1">We use bank-level encryption to protect your personal information and comply with HIPAA standards.</p>
                        </div>
                      </div>
                    </div>
                  </form>
                  <!-- Step 2: Personal Details -->
                  <form v-else-if="stepIndex === 1" class="space-y-8" @submit.prevent>
                    <div class="text-center mb-10">
                      <h2 class="text-3xl font-bold text-gray-900 dark:text-gray-50 mb-4">Personal Details</h2>
                      <p class="text-lg text-gray-600 dark:text-gray-300">Help us personalize your healthcare experience</p>
                    </div>

                    <PhoneInput 
                      v-model="phone" 
                      label="Phone Number" 
                      placeholder="Enter your phone number" 
                      :error="phoneError" 
                    />

                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-8">
                      <BaseInput 
                        v-model="dateOfBirth" 
                        label="Date of Birth" 
                        type="date" 
                        :error="dateOfBirthError" 
                      />

                      <BaseSelect 
                        v-model="gender" 
                        label="Gender" 
                        placeholder="Select your gender" 
                        :error="genderError"
                      >
                        <option v-for="opt in GENDER_OPTIONS" :key="opt.value" :value="opt.value">{{ opt.label }}</option>
                      </BaseSelect>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-8">
                      <BaseSelect 
                        v-model="governorate" 
                        label="Governorate" 
                        placeholder="Select your governorate" 
                        :error="governorateError"
                      >
                        <option v-for="opt in GOVERNORATE_OPTIONS" :key="opt.value" :value="opt.value">{{ opt.label }}</option>
                      </BaseSelect>

                      <BaseInput 
                        v-model="nationalId" 
                        label="National ID" 
                        placeholder="Enter your national ID" 
                        :error="nationalIdError" 
                      />
                    </div>
                  </form>

                  <!-- Step 3: Medical Profile -->
                  <form v-else-if="stepIndex === 2" class="space-y-8" @submit.prevent>
                    <div class="text-center mb-10">
                      <h2 class="text-3xl font-bold text-gray-900 dark:text-gray-50 mb-4">Medical Profile</h2>
                      <p class="text-lg text-gray-600 dark:text-gray-300">This information helps us provide better care</p>
                    </div>

                    <BaseSelect 
                      v-model="bloodType" 
                      label="Blood Type" 
                      placeholder="Select your blood type" 
                      :error="bloodTypeError"
                    >
                      <option v-for="opt in BLOOD_TYPE_OPTIONS" :key="opt.value" :value="opt.value">{{ opt.label }}</option>
                    </BaseSelect>

                    <div class="space-y-8">
                      <div>
                        <label class="mb-4 block text-sm font-semibold text-gray-700 dark:text-gray-200">Allergies (Optional)</label>
                        <textarea 
                          v-model="allergies" 
                          rows="4" 
                          placeholder="List any known allergies, medications, or substances you're allergic to..." 
                          class="premium-textarea w-full rounded-2xl border-2 border-gray-200/60 dark:border-gray-700/60 bg-white/80 dark:bg-gray-800/80 backdrop-blur-sm px-6 py-4 text-gray-900 dark:text-gray-100 placeholder-gray-500 dark:placeholder-gray-400 transition-all duration-300 focus:border-teal-500 dark:focus:border-teal-400 focus:outline-none focus:ring-4 focus:ring-teal-500/20 dark:focus:ring-teal-400/20 focus:bg-white dark:focus:bg-gray-800 focus:shadow-lg focus:shadow-teal-500/10 dark:focus:shadow-teal-400/10 hover:border-gray-300 dark:hover:border-gray-600 hover:shadow-md resize-none" 
                          :class="{ 'border-red-500/60 dark:border-red-400/60 focus:border-red-500 dark:focus:border-red-400 focus:ring-red-500/20 dark:focus:ring-red-400/20': allergiesError }"
                        ></textarea>
                        <div v-if="allergiesError" class="mt-2 flex items-center gap-2">
                          <svg class="w-4 h-4 text-red-500 dark:text-red-400 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                          </svg>
                          <span class="text-sm text-red-500 dark:text-red-400">{{ allergiesError }}</span>
                        </div>
                      </div>

                      <div>
                        <label class="mb-4 block text-sm font-semibold text-gray-700 dark:text-gray-200">Chronic Conditions (Optional)</label>
                        <textarea 
                          v-model="chronicConditions" 
                          rows="4" 
                          placeholder="List any chronic conditions, ongoing treatments, or medical history we should know about..." 
                          class="premium-textarea w-full rounded-2xl border-2 border-gray-200/60 dark:border-gray-700/60 bg-white/80 dark:bg-gray-800/80 backdrop-blur-sm px-6 py-4 text-gray-900 dark:text-gray-100 placeholder-gray-500 dark:placeholder-gray-400 transition-all duration-300 focus:border-teal-500 dark:focus:border-teal-400 focus:outline-none focus:ring-4 focus:ring-teal-500/20 dark:focus:ring-teal-400/20 focus:bg-white dark:focus:bg-gray-800 focus:shadow-lg focus:shadow-teal-500/10 dark:focus:shadow-teal-400/10 hover:border-gray-300 dark:hover:border-gray-600 hover:shadow-md resize-none" 
                          :class="{ 'border-red-500/60 dark:border-red-400/60 focus:border-red-500 dark:focus:border-red-400 focus:ring-red-500/20 dark:focus:ring-red-400/20': chronicConditionsError }"
                        ></textarea>
                        <div v-if="chronicConditionsError" class="mt-2 flex items-center gap-2">
                          <svg class="w-4 h-4 text-red-500 dark:text-red-400 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                          </svg>
                          <span class="text-sm text-red-500 dark:text-red-400">{{ chronicConditionsError }}</span>
                        </div>
                      </div>
                    </div>

                    <div class="emergency-notice">
                      <div class="flex items-start gap-4">
                        <svg class="w-6 h-6 text-orange-600 dark:text-orange-400 flex-shrink-0 mt-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                        </svg>
                        <div>
                          <p class="text-base font-semibold text-orange-800 dark:text-orange-200">Emergency Contact Information</p>
                          <p class="text-sm text-orange-700 dark:text-orange-300 mt-1">This person will be contacted in case of medical emergencies.</p>
                        </div>
                      </div>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-8">
                      <BaseInput 
                        v-model="emergencyContactName" 
                        label="Emergency Contact Name" 
                        placeholder="Full name of emergency contact" 
                        :error="emergencyContactNameError" 
                      />

                      <PhoneInput 
                        v-model="emergencyContactPhone" 
                        label="Emergency Contact Phone" 
                        placeholder="Emergency contact phone number" 
                        :error="emergencyContactPhoneError" 
                      />
                    </div>
                  </form>
                </div>
              </transition>
            </template>
          </MultiStepForm>
        </div>

        <!-- Footer -->
        <div 
          :class="[
            'text-center mt-12 transition-all duration-1000 ease-out',
            isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-8'
          ]"
          style="transition-delay: 0.4s;"
        >
          <p class="text-gray-600 dark:text-gray-400 mb-8">
            Already have an account?
            <RouterLink 
              to="/login" 
              class="font-semibold text-teal-600 dark:text-teal-400 hover:text-teal-700 dark:hover:text-teal-300 transition-colors duration-300 hover:underline"
            >
              Sign in instead
            </RouterLink>
          </p>
          
          <div class="flex items-center justify-center gap-8 text-sm text-gray-500 dark:text-gray-400">
            <a href="#" class="hover:text-teal-600 dark:hover:text-teal-400 transition-colors duration-300">Privacy Policy</a>
            <span>•</span>
            <a href="#" class="hover:text-teal-600 dark:hover:text-teal-400 transition-colors duration-300">Terms of Service</a>
            <span>•</span>
            <a href="#" class="hover:text-teal-600 dark:hover:text-teal-400 transition-colors duration-300">Support</a>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>