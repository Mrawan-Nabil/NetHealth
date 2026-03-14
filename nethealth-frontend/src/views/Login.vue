<script setup>
import { ref } from 'vue'
import { useForm, useField } from 'vee-validate'
import { toTypedSchema } from '@vee-validate/zod'
import { z } from 'zod'
import BaseInput from '../components/base/BaseInput.vue'
import { RouterLink } from 'vue-router'
import netHealthLogo from '../assets/logo.png'

// Schema validation
const loginSchema = z.object({
  email: z.string().min(1, 'Email is required').email('Enter a valid email'),
  password: z.string().min(1, 'Password is required').min(6, 'Min 6 chars')
})

// Form setup
const { handleSubmit } = useForm({
  validationSchema: toTypedSchema(loginSchema),
  initialValues: { email: '', password: '' },
})

// Fields
const { value: email, errorMessage: emailError } = useField('email')
const { value: password, errorMessage: passwordError } = useField('password')

const rememberMe = ref(false)

// Submit
const onSubmit = handleSubmit(values => {
  console.log({ ...values, rememberMe: rememberMe.value })
})
</script>

<template>
  <div class="page-enter">
    <!-- Logo & Header -->
    <div class="text-center mb-8">
      <img :src="netHealthLogo" class="mx-auto w-24 h-24 mb-4 gentle-float" />
      <h1 class="text-3xl font-bold text-gray-900 mb-2">Welcome Back</h1>
      <p class="text-gray-600 text-sm leading-relaxed">Your health, managed in one secure place</p>
    </div>

    <!-- Form -->
    <form @submit.prevent="onSubmit" class="space-y-6">
      <BaseInput 
        v-model="email" 
        label="Email" 
        type="email" 
        placeholder="you@example.com" 
        :error="emailError"
        class="input-focus"
      />
      <BaseInput 
        v-model="password" 
        label="Password" 
        type="password" 
        placeholder="••••••••" 
        :error="passwordError"
        class="input-focus"
      />

      <div class="flex items-center justify-between">
        <label class="flex items-center gap-2 cursor-pointer group">
          <input 
            type="checkbox" 
            v-model="rememberMe" 
            class="h-4 w-4 rounded border-gray-300 text-[#14B8A6] focus:ring-[#14B8A6]/30 transition-all duration-200" 
          />
          <span class="text-sm text-gray-700 group-hover:text-gray-900 transition-colors duration-200">Remember me</span>
        </label>
        <RouterLink 
          to="/forgot-password" 
          class="text-sm text-[#14B8A6] hover:text-[#0D9488] font-medium transition-colors duration-200"
        >
          Forgot password?
        </RouterLink>
      </div>

      <button 
        type="submit" 
        class="btn-primary w-full bg-gradient-to-r from-[#14B8A6] to-[#0D9488] text-white py-3 px-6 rounded-xl font-semibold shadow-lg"
      >
        Sign In
      </button>
    </form>

    <!-- Footer -->
    <div class="text-center mt-8 text-sm text-gray-600">
      Don't have an account?
      <RouterLink 
        :to="{ name: 'Register' }" 
        class="text-[#14B8A6] hover:text-[#0D9488] font-semibold transition-colors duration-200 ml-1"
      >
        Create Account
      </RouterLink>
    </div>
  </div>
</template>

<style scoped>
/* Auth form specific styles using unified system */

/* Page entrance animation */
.page-enter {
  animation: pageSlideUp 0.5s cubic-bezier(0.4, 0, 0.2, 1);
}

@keyframes pageSlideUp {
  from {
    opacity: 0;
    transform: translateY(32px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Gentle float animation for logo */
.gentle-float {
  animation: gentleFloat 4s cubic-bezier(0.25, 0.46, 0.45, 0.94) infinite;
}

@keyframes gentleFloat {
  0%, 100% {
    transform: translateY(0px);
  }
  50% {
    transform: translateY(-8px);
  }
}

/* Input focus animation */
.input-focus :deep(input) {
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
}

.input-focus :deep(input:focus) {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px -2px rgba(20, 184, 166, 0.15);
}

/* Button styling */
.btn-primary {
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
}

.btn-primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 16px -4px rgba(20, 184, 166, 0.3);
}

.btn-primary:active {
  transform: scale(0.98);
  transition-duration: 0.15s;
}

/* Enhanced input styling */
:deep(input) {
  border-radius: 12px;
  padding: 12px 16px;
  font-size: 14px;
  line-height: 1.5;
  border: 2px solid #E5E7EB;
}

:deep(input:focus) {
  border-color: #14B8A6;
  box-shadow: 0 0 0 3px rgba(20, 184, 166, 0.1);
}

:deep(label) {
  font-weight: 600;
  font-size: 14px;
  color: #374151;
  margin-bottom: 8px;
}

/* Consistent button styling */
button[type="submit"] {
  font-size: 16px;
  line-height: 1.5;
  padding: 14px 24px;
}

/* Form spacing */
form {
  max-width: 400px;
  margin: 0 auto;
}

/* Link styling */
a {
  text-decoration: none;
}

a:hover {
  text-decoration: underline;
}
</style>