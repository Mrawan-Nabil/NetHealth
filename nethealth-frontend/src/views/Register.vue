<template>
  <div class="w-full min-h-screen flex flex-col items-center relative overflow-hidden">
    <!-- Modern Gradient Background -->
    <div class="absolute inset-0 bg-gradient-to-br from-purple-600 via-blue-600 to-cyan-500"></div>
    
    <!-- Blurred Shapes for Depth -->
    <div class="absolute inset-0 overflow-hidden pointer-events-none">
      <div class="absolute top-0 left-1/4 w-96 h-96 bg-purple-400/30 rounded-full blur-3xl animate-float"></div>
      <div class="absolute top-1/3 right-1/4 w-80 h-80 bg-blue-400/30 rounded-full blur-3xl animate-float-delayed"></div>
      <div class="absolute bottom-1/4 left-1/3 w-72 h-72 bg-cyan-400/30 rounded-full blur-3xl animate-float-slow"></div>
      <div class="absolute bottom-0 right-1/3 w-96 h-96 bg-indigo-400/20 rounded-full blur-3xl animate-float"></div>
    </div>

    <!-- Overlay for better readability -->
    <div class="absolute inset-0 bg-black/10"></div>

    <!-- Main Content -->
    <div class="relative w-full max-w-6xl px-4 sm:px-6 lg:px-8 py-12 z-10">
      <!-- Header -->
      <div class="text-center mb-12 animate-fadeInUp">
        <div class="inline-flex items-center justify-center w-24 h-24 bg-white/20 backdrop-blur-xl rounded-3xl mb-6 shadow-2xl border border-white/30 transform hover:scale-105 transition-transform duration-300">
          <svg class="w-12 h-12 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
          </svg>
        </div>
        <h1 class="text-5xl sm:text-6xl font-bold text-white mb-4 tracking-tight drop-shadow-lg">
          Create Your Account
        </h1>
        <p class="text-xl text-white/90 drop-shadow-md">
          Join thousands of healthcare professionals and patients on NetHealth
        </p>
      </div>

      <!-- Tabs -->
      <div class="flex flex-wrap justify-center gap-3 mb-12 animate-fadeInUp" style="animation-delay: 0.1s">
        <button
          v-for="type in types"
          :key="type"
          @click="switchType(type)"
          :class="[
            'px-8 py-4 font-semibold text-base transition-all duration-300 rounded-2xl backdrop-blur-xl border-2',
            selectedType === type
              ? 'bg-white text-purple-600 border-white shadow-2xl scale-105'
              : 'bg-white/10 text-white border-white/30 hover:bg-white/20 hover:border-white/50 hover:scale-102'
          ]"
        >
          {{ type }}
        </button>
      </div>

      <!-- Form Section -->
      <div class="w-full animate-fadeInUp" style="animation-delay: 0.2s">
        <transition name="fade-slide" mode="out-in">
          <form
            :key="selectedType"
            @submit.prevent="submitForm"
            class="w-full max-w-5xl mx-auto bg-white/95 backdrop-blur-xl rounded-3xl p-8 sm:p-10 lg:p-12 shadow-2xl border border-white/50"
          >
            <!-- Form Header -->
            <div class="text-center mb-10">
              <h2 class="text-3xl font-bold text-slate-900 mb-2">
                {{ getRoleTitle() }}
              </h2>
              <p class="text-slate-600">
                {{ getRoleDescription() }}
              </p>
            </div>

            <!-- Form Grid -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
              <div
                v-for="field in getFields(selectedType)"
                :key="field.name"
                :class="field.type === 'textarea' ? 'md:col-span-2' : ''"
                class="flex flex-col group"
              >
                <label class="font-semibold text-slate-700 mb-2 flex items-center gap-2">
                  <span>{{ field.label }}</span>
                  <span v-if="field.required !== false" class="text-red-500">*</span>
                </label>
                
                <!-- Password Input with Toggle -->
                <div v-if="field.type === 'password'" class="relative">
                  <input
                    :type="showPassword[field.name] ? 'text' : 'password'"
                    v-model="formData[field.name]"
                    :placeholder="field.placeholder"
                    class="w-full border-2 border-slate-200 rounded-xl p-4 pr-12 focus:outline-none focus:ring-4 focus:ring-purple-500/20 focus:border-purple-500 transition-all duration-300 hover:border-slate-300 bg-white shadow-sm focus:shadow-lg focus:scale-[1.01]"
                    required
                  />
                  <button
                    type="button"
                    @click="showPassword[field.name] = !showPassword[field.name]"
                    class="absolute right-4 top-1/2 -translate-y-1/2 text-slate-400 hover:text-purple-600 transition-colors"
                  >
                    <svg v-if="!showPassword[field.name]" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                    </svg>
                    <svg v-else class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21" />
                    </svg>
                  </button>
                  
                  <!-- Password Strength Indicator -->
                  <transition name="strength-fade">
                    <div v-if="field.name === 'password' && formData[field.name]" class="mt-3">
                      <div class="flex items-center gap-3">
                        <div class="flex-1 h-2 bg-slate-100 rounded-full overflow-hidden">
                          <div 
                            :class="[
                              'h-full transition-all duration-500 rounded-full',
                              getPasswordStrengthColor(formData[field.name])
                            ]"
                            :style="{ width: `${getPasswordStrength(formData[field.name]) * 25}%` }"
                          ></div>
                        </div>
                        <span :class="['text-sm font-semibold', getPasswordStrengthTextColor(formData[field.name])]">
                          {{ getPasswordStrengthText(formData[field.name]) }}
                        </span>
                      </div>
                      <p class="text-xs text-slate-500 mt-1">
                        Use 8+ characters with a mix of letters, numbers & symbols
                      </p>
                    </div>
                  </transition>
                </div>

                <!-- Select Dropdown -->
                <select
                  v-else-if="field.type === 'select'"
                  v-model="formData[field.name]"
                  class="w-full border-2 border-slate-200 rounded-xl p-4 focus:outline-none focus:ring-4 focus:ring-purple-500/20 focus:border-purple-500 transition-all duration-300 hover:border-slate-300 bg-white shadow-sm focus:shadow-lg focus:scale-[1.01] appearance-none cursor-pointer"
                  :required="field.required !== false"
                >
                  <option value="">{{ field.placeholder }}</option>
                  <option v-for="option in field.options" :key="option.value" :value="option.value">
                    {{ option.label }}
                  </option>
                </select>

                <!-- Textarea -->
                <textarea
                  v-else-if="field.type === 'textarea'"
                  v-model="formData[field.name]"
                  :placeholder="field.placeholder"
                  :required="field.required !== false"
                  rows="4"
                  class="w-full border-2 border-slate-200 rounded-xl p-4 focus:outline-none focus:ring-4 focus:ring-purple-500/20 focus:border-purple-500 transition-all duration-300 hover:border-slate-300 resize-none bg-white shadow-sm focus:shadow-lg focus:scale-[1.01]"
                ></textarea>

                <!-- Regular Input -->
                <input
                  v-else
                  :type="field.type"
                  v-model="formData[field.name]"
                  :placeholder="field.placeholder"
                  :required="field.required !== false"
                  class="w-full border-2 border-slate-200 rounded-xl p-4 focus:outline-none focus:ring-4 focus:ring-purple-500/20 focus:border-purple-500 transition-all duration-300 hover:border-slate-300 bg-white shadow-sm focus:shadow-lg focus:scale-[1.01]"
                />
              </div>
            </div>

            <!-- Submit Button -->
            <button
              type="submit"
              :disabled="isSubmitting"
              class="w-full bg-gradient-to-r from-purple-600 via-blue-600 to-cyan-600 hover:from-purple-700 hover:via-blue-700 hover:to-cyan-700 text-white font-bold text-lg py-5 rounded-2xl shadow-2xl hover:shadow-purple-500/50 transition-all duration-300 hover:scale-[1.02] active:scale-[0.98] disabled:opacity-50 disabled:cursor-not-allowed disabled:hover:scale-100"
            >
              <span v-if="!isSubmitting" class="flex items-center justify-center gap-3">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                Register as {{ selectedType }}
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6" />
                </svg>
              </span>
              <span v-else class="flex items-center justify-center gap-3">
                <svg class="animate-spin h-6 w-6" fill="none" viewBox="0 0 24 24">
                  <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                  <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
                Creating Your Account...
              </span>
            </button>
          </form>
        </transition>
      </div>

      <!-- Links -->
      <div class="text-center mt-8 animate-fadeInUp" style="animation-delay: 0.3s">
        <p class="text-white/90 text-lg drop-shadow-md mb-4">
          Already have an account?
          <router-link to="/login" class="text-white font-bold hover:text-cyan-200 transition-colors ml-1 underline decoration-2 underline-offset-4">
            Login
          </router-link>
        </p>
        <div class="flex items-center justify-center gap-4 text-sm text-white/80">
          <a href="#" class="hover:text-white transition-colors underline">Privacy Policy</a>
          <span>•</span>
          <a href="#" class="hover:text-white transition-colors underline">Terms of Service</a>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()

const types = ['Doctor', 'Patient', 'Clinic', 'Pharmacy']
const selectedType = ref('Patient')
const isSubmitting = ref(false)
const formData = reactive({})
const showPassword = reactive({})

// Define fields for each type
const fieldsByType = {
  Doctor: [
    { name: 'fullName', label: 'Full Name', type: 'text', placeholder: 'Dr. John Smith' },
    { name: 'email', label: 'Email Address', type: 'email', placeholder: 'doctor@example.com' },
    { name: 'password', label: 'Password', type: 'password', placeholder: '••••••••' },
    { name: 'confirmPassword', label: 'Confirm Password', type: 'password', placeholder: '••••••••' },
    { 
      name: 'specialty', 
      label: 'Specialty', 
      type: 'select', 
      placeholder: 'Select Your Specialty',
      options: [
        { value: 'cardiology', label: 'Cardiology' },
        { value: 'dermatology', label: 'Dermatology' },
        { value: 'neurology', label: 'Neurology' },
        { value: 'pediatrics', label: 'Pediatrics' },
        { value: 'psychiatry', label: 'Psychiatry' },
        { value: 'orthopedics', label: 'Orthopedics' },
        { value: 'general', label: 'General Practice' },
        { value: 'other', label: 'Other' }
      ]
    },
    { name: 'clinicName', label: 'Clinic Name', type: 'text', placeholder: 'Medical Center', required: false },
    { name: 'licenseNumber', label: 'License Number', type: 'text', placeholder: 'MD-123456' },
    { name: 'phone', label: 'Phone Number', type: 'tel', placeholder: '+1 (555) 000-0000' }
  ],
  Patient: [
    { name: 'fullName', label: 'Full Name', type: 'text', placeholder: 'John Doe' },
    { name: 'email', label: 'Email Address', type: 'email', placeholder: 'patient@example.com' },
    { name: 'password', label: 'Password', type: 'password', placeholder: '••••••••' },
    { name: 'confirmPassword', label: 'Confirm Password', type: 'password', placeholder: '••••••••' },
    { name: 'age', label: 'Age', type: 'number', placeholder: '25' },
    { 
      name: 'gender', 
      label: 'Gender', 
      type: 'select', 
      placeholder: 'Select Gender',
      options: [
        { value: 'male', label: 'Male' },
        { value: 'female', label: 'Female' },
        { value: 'other', label: 'Other' },
        { value: 'prefer-not-to-say', label: 'Prefer not to say' }
      ]
    },
    { name: 'phone', label: 'Phone Number', type: 'tel', placeholder: '+1 (555) 000-0000' },
    { name: 'medicalHistory', label: 'Medical History (Optional)', type: 'textarea', placeholder: 'Any relevant medical history, allergies, or conditions...', required: false }
  ],
  Clinic: [
    { name: 'clinicName', label: 'Clinic Name', type: 'text', placeholder: 'City Medical Center' },
    { name: 'email', label: 'Email Address', type: 'email', placeholder: 'clinic@example.com' },
    { name: 'password', label: 'Password', type: 'password', placeholder: '••••••••' },
    { name: 'confirmPassword', label: 'Confirm Password', type: 'password', placeholder: '••••••••' },
    { name: 'address', label: 'Address', type: 'textarea', placeholder: '123 Main St, City, State, ZIP' },
    { name: 'phone', label: 'Phone Number', type: 'tel', placeholder: '+1 (555) 000-0000' },
    { name: 'licenseNumber', label: 'License Number', type: 'text', placeholder: 'CL-123456' },
    { name: 'services', label: 'Specialty / Services Offered', type: 'text', placeholder: 'General Practice, Pediatrics, Emergency Care...' }
  ],
  Pharmacy: [
    { name: 'pharmacyName', label: 'Pharmacy Name', type: 'text', placeholder: 'City Pharmacy' },
    { name: 'email', label: 'Email Address', type: 'email', placeholder: 'pharmacy@example.com' },
    { name: 'password', label: 'Password', type: 'password', placeholder: '••••••••' },
    { name: 'confirmPassword', label: 'Confirm Password', type: 'password', placeholder: '••••••••' },
    { name: 'address', label: 'Address', type: 'textarea', placeholder: '123 Main St, City, State, ZIP' },
    { name: 'phone', label: 'Phone Number', type: 'tel', placeholder: '+1 (555) 000-0000' },
    { name: 'licenseNumber', label: 'License Number', type: 'text', placeholder: 'PH-123456' },
    { name: 'pharmacistName', label: 'Pharmacist Name (Optional)', type: 'text', placeholder: 'Jane Smith, PharmD', required: false }
  ]
}

function getFields(type) {
  return fieldsByType[type]
}

function getRoleTitle() {
  const titles = {
    Doctor: 'Doctor Registration',
    Patient: 'Patient Registration',
    Clinic: 'Clinic Registration',
    Pharmacy: 'Pharmacy Registration'
  }
  return titles[selectedType.value]
}

function getRoleDescription() {
  const descriptions = {
    Doctor: 'Join our network of healthcare professionals and start managing your practice',
    Patient: 'Create your account to access personalized healthcare services',
    Clinic: 'Register your clinic and connect with patients in your area',
    Pharmacy: 'Join our pharmacy network and streamline prescription management'
  }
  return descriptions[selectedType.value]
}

function switchType(type) {
  selectedType.value = type
  // Clear form data when switching types
  Object.keys(formData).forEach(key => delete formData[key])
  Object.keys(showPassword).forEach(key => delete showPassword[key])
}

function getPasswordStrength(password) {
  if (!password) return 0
  let score = 0
  if (password.length >= 8) score++
  if (password.length >= 12) score++
  if (/[a-z]/.test(password) && /[A-Z]/.test(password)) score++
  if (/\d/.test(password)) score++
  if (/[^a-zA-Z0-9]/.test(password)) score++
  return Math.min(score, 4)
}

function getPasswordStrengthText(password) {
  const strength = getPasswordStrength(password)
  const texts = ['Weak', 'Fair', 'Good', 'Strong']
  return texts[strength - 1] || 'Weak'
}

function getPasswordStrengthColor(password) {
  const strength = getPasswordStrength(password)
  const colors = ['bg-red-500', 'bg-orange-500', 'bg-yellow-500', 'bg-green-500']
  return colors[strength - 1] || 'bg-red-500'
}

function getPasswordStrengthTextColor(password) {
  const strength = getPasswordStrength(password)
  const colors = ['text-red-600', 'text-orange-600', 'text-yellow-600', 'text-green-600']
  return colors[strength - 1] || 'text-red-600'
}

async function submitForm() {
  // Basic validation
  if (formData.password !== formData.confirmPassword) {
    alert('Passwords do not match!')
    return
  }

  // Check password strength
  if (getPasswordStrength(formData.password) < 2) {
    alert('Please use a stronger password (at least Fair strength)')
    return
  }

  isSubmitting.value = true

  try {
    // Simulate API call
    await new Promise(resolve => setTimeout(resolve, 2000))
    
    console.log('Registration data:', {
      type: selectedType.value,
      ...formData
    })

    // Redirect to dashboard
    router.push('/dashboard')
  } catch (error) {
    console.error('Registration error:', error)
    alert('Registration failed. Please try again.')
  } finally {
    isSubmitting.value = false
  }
}
</script>

<style scoped>
/* Fade Slide Transition */
.fade-slide-enter-active,
.fade-slide-leave-active {
  transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
}

.fade-slide-enter-from {
  opacity: 0;
  transform: translateY(30px);
}

.fade-slide-leave-to {
  opacity: 0;
  transform: translateY(-30px);
}

/* Strength Fade Transition */
.strength-fade-enter-active,
.strength-fade-leave-active {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.strength-fade-enter-from,
.strength-fade-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}

/* Floating Animations */
@keyframes float {
  0%, 100% {
    transform: translate(0, 0) scale(1);
  }
  33% {
    transform: translate(30px, -30px) scale(1.1);
  }
  66% {
    transform: translate(-20px, 20px) scale(0.9);
  }
}

@keyframes float-delayed {
  0%, 100% {
    transform: translate(0, 0) scale(1);
  }
  33% {
    transform: translate(-30px, 30px) scale(0.9);
  }
  66% {
    transform: translate(20px, -20px) scale(1.1);
  }
}

@keyframes float-slow {
  0%, 100% {
    transform: translate(0, 0) scale(1);
  }
  50% {
    transform: translate(15px, 15px) scale(1.05);
  }
}

.animate-float {
  animation: float 20s ease-in-out infinite;
}

.animate-float-delayed {
  animation: float-delayed 25s ease-in-out infinite;
}

.animate-float-slow {
  animation: float-slow 30s ease-in-out infinite;
}

/* Hover Scale */
.hover\:scale-102:hover {
  transform: scale(1.02);
}

/* Custom Scrollbar */
::-webkit-scrollbar {
  width: 8px;
}

::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.1);
  border-radius: 10px;
}

::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.3);
  border-radius: 10px;
}

::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.5);
}

/* Select Arrow */
select {
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='%236b7280'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M19 9l-7 7-7-7'%3E%3C/path%3E%3C/svg%3E");
  background-repeat: no-repeat;
  background-position: right 1rem center;
  background-size: 1.5em 1.5em;
  padding-right: 3rem;
}
</style>
