<script setup>
import { ref } from 'vue'
import { useForm, useField } from 'vee-validate'
import { toTypedSchema } from '@vee-validate/zod'
import { z } from 'zod'
import BaseInput from '../components/base/BaseInput.vue'
import { RouterLink } from 'vue-router'
import netHealthLogo from '../assets/logo.png'
import AuthLayout from '../layouts/AuthLayout.vue'

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
  <!-- أنميشن fadeIn مع حركة من الأسفل مثل صفحة الدكتور -->
  <Transition name="page-fade" appear>
    <div class="max-w-md mx-auto p-4 space-y-6">
      <!-- Logo & Header -->
      <div class="text-center">
        <img :src="netHealthLogo" class="mx-auto w-36 h-36 mb-2" />
        <h1 class="text-2xl font-bold">Welcome</h1>
        <p class="text-gray-500 text-sm">Your health, managed in one secure place</p>
      </div>

      <!-- Form -->
      <form @submit.prevent="onSubmit" class="space-y-4">
        <BaseInput v-model="email" label="Email" type="email" placeholder="you@example.com" :error="emailError" />
        <BaseInput v-model="password" label="Password" type="password" placeholder="••••••••" :error="passwordError" />

        <div class="flex items-center justify-between">
          <label class="flex items-center gap-2 cursor-pointer">
            <input type="checkbox" v-model="rememberMe" class="h-4 w-4 rounded border-gray-300 text-primary focus:ring-primary/30" />
            <span class="text-sm text-gray-700">Remember me</span>
          </label>
          <RouterLink to="/forgot-password" class="text-sm text-primary hover:underline">Forgot password?</RouterLink>
        </div>

        <button type="submit" class="w-full bg-primary text-white py-2 rounded-lg hover:scale-[1.03] transition-all active:scale-95">
          Login
        </button>
      </form>

      <!-- Footer -->
      <div class="text-center mt-6 text-sm text-gray-600">
        Don't have an account?
        <RouterLink :to="{ name: 'RegisterRole' }" class="text-primary hover:underline">Register</RouterLink>
      </div>
    </div>
  </Transition>
</template>

<style scoped>
/* نفس أنميشن page-fade الموجود في صفحة الدكتور */
.page-fade-enter-active {
  transition: opacity 0.5s ease, transform 0.5s ease;
}
.page-fade-enter-from {
  opacity: 0;
  transform: translateY(20px);
}
</style>